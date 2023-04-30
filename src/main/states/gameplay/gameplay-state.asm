INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "GameplayState", ROM0

wScoreText::  db "score", 255
wLivesText::  db "lives", 255


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
	

	ld a, 0
	ld [mBackgroundScroll+0],a
	ld a, 0
	ld [mBackgroundScroll+1],a

	call ClearAllSprites
	call InitializeBackground
	call InitializePlayer
	call InitializeBullets
	call InitializeEnemies
	call InitStatInterrupts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Call Our function that draws text onto background/window tiles
    ld de, $9c00
    ld hl, wScoreText
    call DrawTextTilesLoop

	; Call Our function that draws text onto background/window tiles
    ld de, $9c0D
    ld hl, wLivesText
    call DrawTextTilesLoop
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

; Draw the level for our level
InitializeBackground:

	; Check what level we are on
	; use the star field on level 1
	ld a, [wLevel]
	cp 0
	call z, DrawStarField

	ret
	
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

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Save our count,as 1, in this variable
    ld a, 1
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	ld a, [wLives]
	cp a, 250
	jp nc, EndGameplay

	; from: https://github.com/eievui5/gb-sprobj-lib
	; Finally, run the following code during VBlank:
	ld a, HIGH(wShadowOAM)
	call hOAMDMA
	call UpdateBackgroundPosition


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Save our count,as 1, in this variable
    ld a, 1
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	jp UpdateGameplayState

EndGameplay:
	
    ld a, 1
    ld [wGameState],a
    jp NextGameState

; This is called during gameplay state on every frame
ScrollBackground::

	; Increase our scaled integer by 5
	ld a , [mBackgroundScroll+0]
	add a , 5
	ld [mBackgroundScroll+0], a
	ld a , [mBackgroundScroll+1]
	adc a , 0
	ld [mBackgroundScroll+1], a

	; Get our true (non-scaled) value, and save it for later usage

 	ld a, [mBackgroundScroll+0]
    ld b,a

    ld a, [mBackgroundScroll+1]
    ld c,a

    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

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