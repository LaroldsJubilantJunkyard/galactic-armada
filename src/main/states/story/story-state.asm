INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"


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


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $9821
    ld hl, Story.Line1
    call DrawText_WithTypewriterEffect


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $9861
    ld hl, Story.Line2
    call DrawText_WithTypewriterEffect


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $98A1
    ld hl, Story.Line3
    call DrawText_WithTypewriterEffect


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $98E1
    ld hl, Story.Line4
    call DrawText_WithTypewriterEffect

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait for A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Save the passed value into the variable: mWaitKey
    ; The WaitForKeyFunction always checks against this vriable
    ld a,PADF_A
    ld [mWaitKey], a

    call WaitForKeyFunction

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    call ClearBackground


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $9821
    ld hl, Story.Line5
    call DrawText_WithTypewriterEffect


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $9861
    ld hl, Story.Line6
    call DrawText_WithTypewriterEffect


    ; Call Our function that typewrites text onto background/window tiles
    ld de, $98A1
    ld hl, Story.Line7
    call DrawText_WithTypewriterEffect


    ; Save the passed value into the variable: mWaitKey
    ; The WaitForKeyFunction always checks against this vriable
    ld a,PADF_A
    ld [mWaitKey], a

    call WaitForKeyFunction

    call ClearBackground


    ld a, 2
    ld [wGameState],a
    jp NextGameState