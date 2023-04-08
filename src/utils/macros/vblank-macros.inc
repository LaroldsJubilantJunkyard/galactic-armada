MACRO WaitForVBlankNTimes

    ld a, \1
    ld [wVBlankCount], a

    call WaitForVBlankFunction

    ENDM

MACRO WaitForVBlank

    ld a, 1
    ld [wVBlankCount], a

    call WaitForVBlankFunction

    ENDM