INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
SECTION "StoriesASM", ROM0

Story::
    .Line1 db "the galatic empire", NEW_LINE
    .Line2 db "rules the galaxy", NEW_LINE
    .Line3 db "alaxy with an iron", NEW_LINE
    .Line4 db "fist.", NEW_PAGE
    .Line5 db "the rebel force", NEW_LINE
    .Line6 db "remain hopeful of", NEW_LINE
    .Line7 db "freedoms light.", END_OF_MESSAGE

UpdateStoryState_Level1::

    ; Call Our function that typewrites text onto background/window tiles
    ld de, $9821
    ld hl, Story.Line1
    call DrawText_WithTypewriterEffect

    jp UpdateStoryState_Finish