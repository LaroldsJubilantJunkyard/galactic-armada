INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/vblank-macros.inc"


SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a
	
	ld a, 0
	ld [wGameState], a

; Do not turn the LCD off outside of VBlank
	WaitForVBlank

	; from: https://github.com/eievui5/gb-sprobj-lib
	; The library is relatively simple to get set up. First, put the following in your initialization code:
	; Initilize Sprite Object Library.
	call InitSprObjLibWrapper

NextGameState::

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	call LoadTextFontIntoVRAM

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00|LCDCF_BG9800
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a
    ld a, %11100100
	ld [rOBP0], a

	; Do not turn the LCD off outside of VBlank
	WaitForVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; disable interrupts
	call DisableInterrupts
	
	; Clear all sprites
	call ClearAllSprites

	; Initiate the next state
	ld a, [wGameState]
	cp a, 1
	call z, InitGameplayState
	ld a, [wGameState]
	cp a, 0
	call z, InitTitleScreenState

	; Update the next state
	ld a, [wGameState]
	cp a, 1
	jp z, UpdateGameplayState
	jp UpdateTitleScreenState


SECTION "GameVariables", WRAM0

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db
wGameState::db