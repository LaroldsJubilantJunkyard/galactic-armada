MACRO CheckAbsoluteDifferenceAndJump

    push bc
    push de
    push hl

    ld a, \1
    ld [wObject1Value], a

    ld a, \2
    ld [wObject2Value], a

    ; Save if the minimum distance
    ld a, \3
    ld [wSize], a

    call CheckObjectPositionDifference


    pop hl
    pop de
    pop bc

    ld a, [wResult]
    cp a, 0
    jp z, \4

    ENDM