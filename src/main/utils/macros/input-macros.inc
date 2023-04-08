

MACRO WaitForKey

    ld a, \1
    ld [mWaitKey], a

    push bc

    call WaitForKeyFunction

    pop bc


    ENDM