
; Example: IncreasePointerVariableAddress wPointerToData, 2
MACRO IncreasePointerVariableAddress

    
    ld a, [\1+0]
    add a, \2
    ld  [\1+0], a
    ld a, [\1+1]
    adc a, 0
    ld  [\1+1], a

    ENDM

    ; Example: SetPointerVariableValue wPointerToData, 0, r8
MACRO SetPointerVariableValue


    push hl

    ld a, [\1+0]
    add a, \2
    ld l, a
    ld a, [\1+1]
    adc a, 0
    ld h, a


    ld a, \3
    ld [hl], a

    pop hl

    ENDM

; Example: GetPointerVariableValue wPointerToData, 0, r8
MACRO GetPointerVariableValue

    push hl

    ld a, [\1+0]
    add a, \2
    ld l, a
    ld a, [\1+1]
    adc a, 0
    ld h, a

    ld a, [hl]

    pop hl

    ld \3, a

    ENDM
    
    

MACRO CopyAddressToPointerVariable


    ld a, LOW(\1)
    ld [\2+0], a
    ld a, HIGH(\1)
    ld [\2+1], a

    ENDM

