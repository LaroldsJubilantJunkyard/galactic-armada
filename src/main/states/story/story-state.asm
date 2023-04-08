INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/vblank-macros.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
INCLUDE "src/main/utils/macros/input-macros.inc"


SECTION "StoryStateASM", ROM0


Story: 
    .Line1 db "the galatic feder-", 255
    .Line2 db "ation rules the g-", 255
    .Line3 db "alaxy with an iron", 255
    .Line4 db "fist.", 255
    .Line5 db "the rebel force r-", 255
    .Line6 db "emain hopeful of", 255
    .Line7 db "freedoms dying li-", 255
    .Line8 db "ght.", 255

InitStoryState::

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

    ret;
	
UpdateStoryState::

    TypewriteText Story.Line1, $9821
    TypewriteText Story.Line2, $9861
    TypewriteText Story.Line3, $98A1
    TypewriteText Story.Line4, $98E1

    WaitForKey PADF_A

    call ClearBackground

    TypewriteText Story.Line5, $9821
    TypewriteText Story.Line6, $9861
    TypewriteText Story.Line7, $98A1


    WaitForKey PADF_A

    call ClearBackground


    ld a, 2
    ld [wGameState],a
    jp NextGameState