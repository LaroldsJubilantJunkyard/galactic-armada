


DEF MAX_ENEMY_COUNT EQU 5
DEF MAX_BULLET_COUNT EQU 5

DEF PER_ENEMY_BYTES_COUNT EQU 6 ; Bytes: active, x , y (low), y (high), speed, health
DEF PER_BULLET_BYTES_COUNT EQU 4 ; Bytes: active, x , y (low), y (high)

DEF ENEMY_MOVE_SPEED EQU 5
DEF BULLET_MOVE_SPEED EQU 10

DEF PLAYER_MOVE_SPEED EQU 4
DEF PADDLE_Y_POSITION EQU 136

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

; eXAMPLE SetCurrentOAMValue 0, r8 or n8
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




MACRO Decrease16BitInteger

    ld a, \1
    sub a, \3
    ld \1, a
    ld a, \2
    sbc a, 0
    ld \2, a

    ENDM

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