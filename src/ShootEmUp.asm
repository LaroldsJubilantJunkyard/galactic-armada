INCLUDE "src/utils/hardware.inc"


SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a

; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY] ; Copy the vertical line to a
	cp 144 ; Check if the vertical line (in a) is 0
	jp c, WaitVBlank ; A conditional jump. The condition is that 'c' is set, the last operation overflowed

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a
	
	ld a, 0
	ld [wGameState], a

	ld a, 0
	ld [wScore+0], a
	ld [wScore+1], a
	ld [wScore+2], a
	ld [wScore+3], a
	ld [wScore+4], a
	ld [wScore+5], a

	; from: https://github.com/eievui5/gb-sprobj-lib
	; The library is relatively simple to get set up. First, put the following in your initialization code:
	; Initilize Sprite Object Library.
	call InitSprObjLibWrapper

	call ClearAllSprites
	call InitializeBackground
	call InitializePlayer
	call InitializeBullets
	call InitializeEnemies
	call InitScore
	call InitInterrupts
	call LoadTextFontIntoVRAM

	call DrawStarField

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00|LCDCF_BG9800
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a
    ld a, %11100100
	ld [rOBP0], a

	ld a, 0
	ld [rWY], a

	ld a, 7
	ld [rWX], a
	
Loop:


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



WaitForVBlank:

	; wait until it's vblank
    ld a, [rLY]
    cp 144
    jp c, WaitForVBlank
	
WaitForVBlank2:
	call DrawNumber

	; from: https://github.com/eievui5/gb-sprobj-lib
	; Finally, run the following code during VBlank:
	ld a, HIGH(wShadowOAM)
	call hOAMDMA
	call UpdateBackgroundPosition

	; wait until it's vblank
    ld a, [rLY]
    cp 144
    jp nc, WaitForVBlank2
	
	jp Loop


SECTION "GameVariables", WRAM0

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db
wScore:: ds 6
wGameState::db