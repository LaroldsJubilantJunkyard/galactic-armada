include "src/utils.inc"
include "src/hardware.inc"

SECTION "BulletVariables", WRAM0

wNextBullet::
    .x db
    .y dw

wActiveBulletCounter:: db

wUpdateBulletsCounter:db
wUpdateBulletsCurrentBulletAddress:dw


; Bytes: active, x , y (low), y (high)
wBullets:: ds MAX_BULLET_COUNT*PER_BULLET_BYTES_COUNT

SECTION "Bullets", ROM0

InitializeBullets::

    ld b, 0

    ld hl, wBullets

    ld a,0
    ld [wActiveBulletCounter],a

InitializeBullets_Loop:

    ld a, 0
    ld [hl], a

    ; Increase the address
    Increase16BitInteger l, h, PER_BULLET_BYTES_COUNT

    ld a, b
    inc a
    ld b ,a

    cp a, MAX_BULLET_COUNT
    ret z

    jp InitializeBullets_Loop

UpdateBullets::

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveBulletCounter]
    cp a, 0
    ret z

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

    ; Check if we've already
    ld a, [wUpdateBulletsCounter]
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
    

    ; get our 16-bit y position
    GetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 2, c
    GetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 3, d

    Decrease16BitInteger c,d,BULLET_MOVE_SPEED

    SetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 2,c
    SetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 3,d

    DeScale16BitInteger c,d

    ; See if our non scaled low byte is above 160
    ld a, c
    cp a, 178
    ; If it below 160, continue on  to deactivate
    jp nc, UpdateBullets_DeActivateIfOutOfBounds
    
    SetCurrentOAMValue 0, c
    SetCurrentOAMValue 1, b
    SetCurrentOAMValue 2, 0
    SetCurrentOAMValue 3, 0

    call NextOAMSprite
    
    jp UpdateBullets_Loop

UpdateBullets_DeActivateIfOutOfBounds:

    ; if it's y value is grater than 160
    ; Set as inactive
    SetPointerVariableValue wUpdateBulletsCurrentBulletAddress, 0,0

    ; Decrease counter
    ld a,[wActiveBulletCounter]
    dec a
    ld [wActiveBulletCounter], a

    jp UpdateBullets_Loop
    
FireNextBullet::

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveBulletCounter]
    cp a, MAX_BULLET_COUNT
    ret nc

    push bc
    push de
    push hl

    ld a, 0
    ld [wUpdateBulletsCounter], a

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

    
    ; Increase counter
    ld a,[wActiveBulletCounter]
    inc a
    ld [wActiveBulletCounter], a


    jp FireNextBullet_End


FireNextBullet_NextBullet:

    ; Increase the address
    Increase16BitInteger l, h, PER_BULLET_BYTES_COUNT

    ld a,[wUpdateBulletsCounter]
    inc a
    ld [wUpdateBulletsCounter], a

    ld a,[wUpdateBulletsCounter]
    cp a, MAX_BULLET_COUNT
    jp nc,FireNextBullet_End

    jp FireNextBullet_Loop

FireNextBullet_End:


    pop hl
    pop de
    pop bc

    ret