INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/input-macros.inc"
INCLUDE "src/main/utils/macros/vblank-macros.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

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

    WaitForKey PADF_A

    ld a, 1
    ld [wGameState],a
    jp NextGameState
