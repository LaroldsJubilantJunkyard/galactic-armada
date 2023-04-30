INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"


SECTION "LevelSelectStateASM", ROM0


LevelText::  db "level", 255
LockedText::  db "locked", 255


InitLevelSelect::
	ld a, 0
	ld [wLastKeys], a
	ld [wCurKeys], a

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

    ret;
	
UpdateLevelSelectState::

    call ClearBackground

	; Call Our function that draws text onto background/window tiles
    ld de, $9926
    ld hl, LevelText
    call DrawTextTilesLoop

    ; Our score has max 6 digits
    ; We'll start with the left-most digit (visually) which is also the first byte
    ld c, 1
    ld hl, wLevel
    ld de, $992c ; The window tilemap starts at $9C00
    call DrawNumber_Loop

    ld a, [wMaxLevel]
    ld b, a

    ld a, [wLevel]
    cp a, b
    jp nc, UpdateLevelSelect_Loop

UpdateLevelSelect_Locked:
    
	; Call Our function that draws text onto background/window tiles
    ld de, $9966
    ld hl, LockedText
    call DrawTextTilesLoop

UpdateLevelSelect_Loop::

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

    ld a, [wCurKeys]
	and a, PADF_LEFT
	jp nz, PreviousLevel

	ld a, [wCurKeys]
	and a, PADF_RIGHT
	jp nz, NextLevel

	ld a, [wCurKeys]
	and a, PADF_A
	jp nz, LevelChosen

    jp UpdateLevelSelect_Loop

LevelChosen:

    ld a, 2
    ld [wGameState],a
    jp NextGameState

PreviousLevel:

    ld a, [wLevel]
    cp 0
    ret z

    dec a
    ld [wLevel], a

    jp UpdateLevelSelectState

NextLevel:

    ld a, [wLevel]
    cp 5
    ret nc

    inc a
    ld [wLevel], a

    jp UpdateLevelSelectState