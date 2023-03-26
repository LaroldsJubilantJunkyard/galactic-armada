MACRO DeScale16BitInteger

    srl \2
    rr \1
    srl \2
    rr \1
    srl \2
    rr \1
    srl \2
    rr \1

    ENDM
    
; Example: Decrease16BitInteger lowByte, highByte, subtractAmount
MACRO Decrease16BitInteger

    ld a, \1
    sub a, \3
    ld \1, a
    ld a, \2
    sbc a, 0
    ld \2, a

    ENDM

; Example: Increase16BitInteger lowByte, highByte, addAmount
MACRO Increase16BitInteger

    ld a, \1
    add a, \3
    ld \1, a
    ld a, \2
    adc a, 0
    ld \2, a

    ENDM

; Example: Get16BitIntegerNonScaledValue my16BitIntegerValue, r8
MACRO Get16BitIntegerNonScaledValue

    push bc

    ld a, [\1+0]
    ld b,a

    ld a, [\1+1]
    ld c,a

    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

    ld a ,b

    pop bc
    
    ld \2, a

    ENDM

MACRO Set16BitIntegerFromNonScaledValue

    push bc

    ld a, \2;
    ld b, a;
    ld c, 0

    sla b
    rl c
    sla b
    rl c
    sla b
    rl c
    sla b
    rl c

    ld a, b
    ld [\1+0],a

    ld a, c
    ld [\1+1],a

    pop bc

    ENDM