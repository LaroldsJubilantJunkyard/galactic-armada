; eXAMPLE SetCurrentOAMValue 0, <r8-or-n8>
MACRO SetCurrentOAMValue

    push bc

    ld a, \2
    ld b, a

    ;Get our offset address in hl
	ld a,[wLastOAMAddress+0]
    add a, \1
    ld l, a
	ld a, HIGH(wShadowOAM)
    adc a, 0
    ld h, a
    
    ; Set the value
    ld a, b

    pop bc

    ld [hl], a

    ENDM
