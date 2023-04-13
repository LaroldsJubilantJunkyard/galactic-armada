include "src/main/utils/macros/oam-macros.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"
include "src/main/utils/macros/pointer-macros.inc"
include "src/main/utils/macros/int16-macros.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/macros/collision-macros.inc"

SECTION "EnemyBulletCollisionVariables", WRAM0

wEnemyBulletCollisionCounter: db
wBulletAddresses: dw

SECTION "EnemyBulletCollision", ROM0

; called from enemies.asm
CheckCurrentEnemyAgainstBullets::

    ld a, 0
    ld [wEnemyBulletCollisionCounter], a

    ; Copy our bullets address
    CopyAddressToPointerVariable wBullets, wBulletAddresses

    jp CheckCurrentEnemyAgainstBullets_Loop

CheckCurrentEnemyAgainstBullets_NextLoop:

    ; increase our counter
    ld a, [wEnemyBulletCollisionCounter]
    inc a
    ld [wEnemyBulletCollisionCounter], a

    ; Stop if we've checked all bullets
    cp a, MAX_BULLET_COUNT
    ret nc

    ; Increase the  data our address is pointing to
    IncreasePointerVariableAddress wBulletAddresses, PER_BULLET_BYTES_COUNT


CheckCurrentEnemyAgainstBullets_Loop:


CheckCurrentEnemyAgainstBullets_Loop_Y:

    ; check if bullet is active
    GetPointerVariableValue wBulletAddresses, 0, b
    ld a, b
    cp a, 1
    jp nz, CheckCurrentEnemyAgainstBullets_NextLoop

    
    ; get our bullet 16-bit y position
    GetPointerVariableValue wBulletAddresses, 2, b
    GetPointerVariableValue wBulletAddresses, 3, c

    DeScale16BitInteger b,c
    
    ; get our enemy 16-bit y position
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 2, e
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 3, d

    DeScale16BitInteger e,d

    ; Check the y distances. Jump to 'CheckCurrentEnemyAgainstBullets_NextLoop' on failure
    CheckAbsoluteDifferenceAndJump b,e, 16, CheckCurrentEnemyAgainstBullets_NextLoop


CheckCurrentEnemyAgainstBullets_Loop_X:

    ; Get our x position
    ; b = bullet
    ; c = enemy address
    GetPointerVariableValue wBulletAddresses, 1, b
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 1, e

    ; Add a 4 pixel offset to the bullet posiition
    ld a, b
    add a, 4
    ld b ,a

    ; Add 8 pixel offset to the enemy position
    ld a, e
    add a, 8
    ld e ,a

    ; Check the x distances. Jump to 'CheckCurrentEnemyAgainstBullets_NextLoop' on failure
    CheckAbsoluteDifferenceAndJump b, e, 12,CheckCurrentEnemyAgainstBullets_NextLoop

    
    ; set the first byte for the current bullet/enemy as zero for inactive
    SetPointerVariableValue wBulletAddresses, 0,0
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 0, 0

    ; set the second byte for the current bullet/enemy as zero for x=0 (move offscreeen)
    SetPointerVariableValue wBulletAddresses, 1,0
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 1, 0
    
    call IncreaseScore;
    call DrawScore

    ; Decrease how many active enemies their are
    ld a, [wActiveEnemyCounter]
    dec a
    ld [wActiveEnemyCounter], a

    ; Decrease how many active bullets their are
    ld a, [wActiveBulletCounter]
    dec a
    ld [wActiveBulletCounter], a

    ret