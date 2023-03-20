include "src/main/utils.inc"
include "src/main/hardware.inc"

DEF MAX_BULLET_COUNT EQU 5


; Bytes: active, x , y (low), y (high)
DEF PER_BULLET_BYTES_COUNT EQU 4
DEF BULLET_MOVE_SPEED EQU 20

SECTION "BulletVariables", WRAM0

wNextBullet::
    .x db
    .y dw

wUpdateBulletsCounter:db
wUpdateBulletsCurrentBulletAddress:dw


; Bytes: active, x , y (low), y (high)
wBullets: ds MAX_BULLET_COUNT*PER_BULLET_BYTES_COUNT

SECTION "Bullets", ROM0

InitializeBullets::

    ld b, 0

    ld hl, wBullets

InitializeBullets_Loop:

    ld a, 0
    ld [hl], a

    ; Increase the address
    ld a, l
    add a, PER_BULLET_BYTES_COUNT
    ld l, a
    ld a, h
    adc a, 0
    ld h, a

    ld a, b
    inc a
    ld b ,a

    cp a, MAX_BULLET_COUNT
    ret z

    jp InitializeBullets_Loop

UpdateBullets::

    ld a, 0
    ld [wUpdateBulletsCounter], a

    CopyAddressToPointerVariable wBullets, wUpdateBulletsCurrentBulletAddress

    jp UpdateBullets_PerBullet

UpdateBullets_Loop:

    ; Check our coutner, if it's zero
    ; Stop the function
    ld a, [wUpdateBulletsCounter]
    inc a
    ld [wUpdateBulletsCounter], a
    
    ; Compare against the max bullet count
    cp a, MAX_BULLET_COUNT
    ret nc

    ; Increase the bullet data our address is pointingtwo
    IncreasePointerVariableAddress wUpdateBulletsCurrentBulletAddress, PER_BULLET_BYTES_COUNT

UpdateBullets_PerBullet:



    ; The first byte is if the bullet is active
    ; If it's zero, it's inactive, go to the loop section
    GetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 0, b
    ld a, b
    cp a, 0
    jp z, UpdateBullets_Loop
    

    ; Get our x position
    GetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 1, b
    
    SetCurrentOAMValue 1, b

    ; get our 16-bit y position
    GetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 2, c
    GetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 3, d

    ld a, c
    sub a, BULLET_MOVE_SPEED
    ld c , a
    ld a, d
    sbc a, 0
    ld d, a

    SetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 2,c
    SetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 3,d
    
    srl d
    rr c
    srl d
    rr c
    srl d
    rr c
    srl d
    rr c

    
    SetCurrentOAMValue 0, c
    SetCurrentOAMValue 2, 0
    SetCurrentOAMValue 3, 0
    

    call NextOAMSprite

    ; See if our non scaled low byte is above 160
    ld a, c
    cp a, 160
    ; If it below 160, continue on  to deactivate
    jp c, UpdateBullets_Loop

    ; if it's y value is grater than 160
    ; Set as inactive
    SetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 0,0

    jp UpdateBullets_Loop
    
FireNextBullet::

    push bc
    push de
    push hl

    ld b, MAX_BULLET_COUNT

    ld hl, wBullets

FireNextBullet_Loop:

    ld a, [hl]

    cp a, 0
    jp nz, FireNextBullet_NextBullet

    ; Set as  active
    ld a, 1
    ld [hli], a

    ; Set the x position
    ld a, [wNextBullet.x]
    ld [hli], a

    ; Set the y position (low)
    ld a, [wNextBullet.y+0]
    ld [hli], a

    ;Set the y position (high)
    ld a, [wNextBullet.y+1]
    ld [hli], a

    jp FireNextBullet_End


FireNextBullet_NextBullet:

    ; Increase the address
    ld a, l
    add a, PER_BULLET_BYTES_COUNT
    ld l, a
    ld a, h
    adc a, 0
    ld h, a

    ld a, b
    cp a, MAX_BULLET_COUNT
    jp c,FireNextBullet_End

    inc a
    ld b ,a

    jp FireNextBullet_Loop

FireNextBullet_End:


    pop hl
    pop de
    pop bc

    ret