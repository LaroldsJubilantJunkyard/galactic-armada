INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/vblank-macros.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/int16-macros.inc"


SECTION "GameplayState", ROM0

wScoreText::  db "score", 255
wLivesText::  db "lives", 255

starFieldMap: INCBIN "src/generated/backgrounds/star-field.tilemap"
starFieldMapEnd:
 
starFieldTileData: INCBIN "src/generated/backgrounds/star-field.2bpp"
starFieldTileDataEnd:

DrawStarField::

	; Copy the tile data
	ld de, starFieldTileData ; de contains the address where data will be copied from;
	ld hl, $9340 ; hl contains the address where data will be copied to;
	ld bc, starFieldTileDataEnd - starFieldTileData ; bc contains how many bytes we have to copy.
	
DrawStarField_Loop: 
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, DrawStarField_Loop ; Jump to DrawStarField_Loop, if the z flag is not set. (the last operation had a non zero result)

	; Copy the tilemap
	ld de, starFieldMap
	ld hl, $9800
	ld bc, starFieldMapEnd - starFieldMap

DrawStarField_Tilemap:
	ld a, [de]
	add a, 52
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, DrawStarField_Tilemap

	ret


InitGameplayState::

	ld a, 3
	ld [wLives+0], a

	ld a, 0
	ld [wScore+0], a
	ld [wScore+1], a
	ld [wScore+2], a
	ld [wScore+3], a
	ld [wScore+4], a
	ld [wScore+5], a

	call ClearAllSprites
	call InitializeBackground
	call InitializePlayer
	call InitializeBullets
	call InitializeEnemies
	call InitStatInterrupts
	call DrawStarField
    DrawText wScoreText,$9c00
    DrawText wLivesText,$9c0D

	call DrawScore
	call DrawLives

	ld a, 0
	ld [rWY], a

	ld a, 7
	ld [rWX], a

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00|LCDCF_BG9800
	ld [rLCDC], a

    ret;
	
UpdateGameplayState::


	; save the keys last frame
	ld a, [wCurKeys]
	ld [wLastKeys], a

	; from: https://github.com/eievui5/gb-sprobj-lib
	; hen put a call to ResetShadowOAM at the beginning of your main loop.
	call ResetShadowOAM

	; This is in input.asm
	; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
	; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
	; So it's best to use some tested code
    call Input

	call ResetOAMSprite
	call UpdatePlayer
	call UpdateEnemies
	call UpdateBullets
	call ClearRemainingSprites
	call SpawnEnemies
	call ScrollBackground

    WaitForVBlank


	ld a, [wLives]
	cp a, 250
	jp nc, EndGameplay

	; from: https://github.com/eievui5/gb-sprobj-lib
	; Finally, run the following code during VBlank:
	ld a, HIGH(wShadowOAM)
	call hOAMDMA
	call UpdateBackgroundPosition

    WaitForVBlank
	
	jp UpdateGameplayState

EndGameplay:
	
    ld a, 0
    ld [wGameState],a
    jp NextGameState


InitializeBackground::

	ld a, 0
	ld [mBackgroundScroll+0],a
	ld a, 0
	ld [mBackgroundScroll+1],a

	ret

; This is called during gameplay state on every frame
ScrollBackground::

	; Increase our scaled integer by 5
	Increase16BitInteger [mBackgroundScroll+0], [mBackgroundScroll+1], 5

	; Get our true (non-scaled) value, and save it for later usage
    Get16BitIntegerNonScaledValue mBackgroundScroll, b
    ld a,b
	ld [mBackgroundScrollReal], a

	ret

; This is called during vblanks
UpdateBackgroundPosition::

	; Tell our background to use our previously saved true value
	ld a, [mBackgroundScrollReal]
	ld [rSCY], a

	ret

SECTION "GameplayVariables", WRAM0

mBackgroundScroll: dw
mBackgroundScrollReal: db

wScore:: ds 6
wLives:: db