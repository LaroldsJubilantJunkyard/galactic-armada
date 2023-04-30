INCLUDE "src/main/utils/hardware.inc"


SECTION "GameplayHUD", ROM0

IncreaseScore::

    ; We have 6 digits, start with the right-most digit (the last byte)
    ld c, 0
    ld hl, wScore+5

IncreaseScore_Loop:

    ; Increase the digit 
    ld a, [hl]
    inc a
    ld [hl], a

    ; Stop if it hasn't gone past 0
    cp a, 9
    ret c

; If it HAS gone past 9
IncreaseScore_Next:

    ; Increase a counter so we can not go out of our scores bounds
    ld a, c
    inc a 
    ld c, a

    ; Check if we've gone our o our scores bounds
    cp a, 6
    ret z

    ; Reset the current digit to zero
    ; Then go to the previous byte (visually: to the left)
    ld a, 0
    ld [hl], a
    ld [hld], a

    jp IncreaseScore_Loop

    
DrawLives::

    ld hl, wLives
    ld de, $9C13 ; The window tilemap starts at $9C00

    ld a, [hl]
    add a, 10 ; our numeric tiles start at tile 10, so add to 10 to each bytes value
    ld [de], a

    ret


DrawScore::

    ; Our score has max 6 digits
    ; We'll start with the left-most digit (visually) which is also the first byte
    ld c, 6
    ld hl, wScore
    ld de, $9C06 ; The window tilemap starts at $9C00

DrawNumber_Loop::

    ld a, [hli]
    add a, 10 ; our numeric tiles start at tile 10, so add to 10 to each bytes value
    ld [de], a

    ; Decrease how many numbers we have drawn
    ld a, c
    dec a
    ld c, a
		
    ; Stop when we've drawn all the numbers
    ret z

    ; Increase which tile we are drawing to
    inc de

    jp DrawNumber_Loop