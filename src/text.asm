
INCLUDE "src/utils/macros/vblank-macros.inc"
INCLUDE "src/utils/macros/text-macros.inc"
SECTION "Text", ROM0



wScoreText::  db "score", 255

IncreaseScore::

    ld c, 0
    ld hl, wScore+5

IncreaseScore_Loop:



    ld a, [hl]
    inc a
    ld [hl], a
    cp a, 9
    ret c

IncreaseScore_Next:

    ld a, c
    inc a 
    ld c, a

    cp a, 6
    ret z

    ; Reset to zero
    ld a, 0
    ld [hl], a
    ld [hld], a

    jp IncreaseScore_Loop


DrawScore::

    ld c, 6
    ld hl, wScore
    ld de, $9C06

DrawScore_Loop:

    ld a, [hli]
    add a, 10
    ld [de], a

    ld a, c
    dec a
    ld c, a

    ret z

    inc de

    jp DrawScore_Loop


DrawTextTilesLoop::

    ld a, [hl]
    cp 255
    ret z

    ld a, [hl]
    ld [de], a

    inc hl
    inc de

    jp DrawTextTilesLoop




SetBackgroundTile_Typewriter::

    WaitForVBlankNTimes 3

    ld a, [hl]
    cp 255
    ret z

    ld a, [hl]
    ld [de], a

    inc hl
    inc de

    jp SetBackgroundTile_Typewriter
