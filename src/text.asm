
SECTION "Text", ROM0

CHARMAP "a", 26
CHARMAP "b", 27
CHARMAP "c", 28
CHARMAP "d", 29
CHARMAP "e", 30
CHARMAP "f", 31
CHARMAP "g", 32
CHARMAP "h", 33
CHARMAP "i", 34
CHARMAP "j", 35
CHARMAP "k", 36
CHARMAP "l", 37
CHARMAP "m", 38
CHARMAP "n", 39
CHARMAP "o", 40
CHARMAP "p", 41
CHARMAP "q", 42
CHARMAP "r", 43
CHARMAP "s", 44
CHARMAP "t", 45
CHARMAP "u", 46
CHARMAP "v", 47
CHARMAP "w", 48
CHARMAP "x", 49
CHARMAP "y", 50
CHARMAP "z", 51

wScoreText:  db "score", 0

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


InitScore::
    call DrawScore
DrawNumber::

    ld c, 6
    ld hl, wScore
    ld de, $9C06

DrawNumber_Loop:

    ld a, [hli]
    add a, 10
    ld [de], a

    ld a, c
    dec a
    ld c, a

    ret z

    inc de

    jp DrawNumber_Loop


DrawScore::


    ld de, $9C00
    ld hl, wScoreText

SetBackgroundTile_Loop:

    ld a, [hl]
    cp 0
    ret z

    ld a, [hl]
    ld [de], a

    inc hl
    inc de

    jp SetBackgroundTile_Loop
