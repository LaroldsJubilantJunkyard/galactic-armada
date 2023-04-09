
; example: WaitForKey PADF_A
; waits until A is pressed
MACRO WaitForKey

    ; Save the passed value into the variable: mWaitKey
    ; The WaitForKeyFunction always checks against this vriable
    ld a, \1
    ld [mWaitKey], a

    call WaitForKeyFunction


    ENDM