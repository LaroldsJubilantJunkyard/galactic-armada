INCLUDE "src/main/utils/hardware.inc"


SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a
	
	ld a, 0
	ld [wGameState], a
	
	ld a, 0
	ld [wLevel], a
	ld [wMaxLevel], a
; Do not turn the LCD off outside of VBlank
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 1
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; from: https://github.com/eievui5/gb-sprobj-lib
	; The library is relatively simple to get set up. First, put the following in your initialization code:
	; Initilize Sprite Object Library.
	call InitSprObjLibWrapper

NextGameState::

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld a, 0
	ld [rSCX],a
	ld [rSCY],a
	ld [rWX],a
	ld [rWY],a

	call LoadTextFontIntoVRAM

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINON | LCDCF_WIN9C00
	ld [rLCDC], a

	call ClearBackground;

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a
    ld a, %11100100
	ld [rOBP0], a

	; Do not turn the LCD off outside of VBlank
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 1
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; disable interrupts
	call DisableInterrupts
	
	; Clear all sprites
	call ClearAllSprites

	; Initiate the next state
	ld a, [wGameState]
	cp a, 3 ; 2 = Gameplay
	call z, InitGameplayState
	ld a, [wGameState]
	cp a,2 ; 1 = Story
	call z, InitStoryState
	ld a, [wGameState]
	cp a, 1 ; 1 = Level Select
	call z, InitLevelSelect
	ld a, [wGameState]
	cp a, 0 ; 0 = Menu
	call z, InitTitleScreenState

	; Update the next state
	ld a, [wGameState]
	cp a, 3 ; 2 = Gameplay
	jp z, UpdateGameplayState
	cp a, 2 ; 2 = Gameplay
	jp z, UpdateStoryState
	cp a, 1 ; 1 = Story
	jp z, UpdateLevelSelectState
	jp UpdateTitleScreenState


SECTION "GameVariables", WRAM0

wLastKeys:: db
wCurKeys:: db
wNewKeys:: db
wGameState::db
wPlayer::db
wLevel:: db
wMaxLevel:: db