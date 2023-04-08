INCLUDE "src/utils/hardware.inc"
INCLUDE "src/utils/macros/vblank-macros.inc"
INCLUDE "src/utils/macros/text-macros.inc"

SECTION "TitleScreenState", ROM0


wPressPlayText::  db "press a to play", 255
InitTitleScreenState::

	call DrawTitleScreen
    DrawText wPressPlayText, $99C3

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

    

    ret;
	
UpdateTitleScreenState::


	; save the keys last frame
	ld a, [wCurKeys]
	ld [wLastKeys], a

	; This is in input.asm
	; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
	; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
	; So it's best to use some tested code
    call Input

	ld a, [wCurKeys]
    and a, PADF_A
    jp z,UpdateTitleScreenState_Finish

    ld a, 1
    ld [wGameState],a
    jp NextGameState

UpdateTitleScreenState_Finish:

	WaitForVBlank
	
	jp UpdateTitleScreenState

