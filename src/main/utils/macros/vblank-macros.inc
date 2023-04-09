; Example: WaitForVBLankNTimes 3
MACRO WaitForVBlankNTimes

    ; Save our count in this variable
    ld a, \1
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction

    ENDM

MACRO WaitForVBlank

    ; Save our count,as 1, in this variable
    ld a, 1
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction

    ENDM