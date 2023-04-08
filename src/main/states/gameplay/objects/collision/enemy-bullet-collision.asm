include "src/main/utils/macros/oam-macros.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/constants.inc"
include "src/main/utils/macros/pointer-macros.inc"
include "src/main/utils/macros/int16-macros.inc"
include "src/main/utils/hardware.inc"

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

    ; at this point in time; e = enemy.y, b =bullet.y

    ; subtract  bullet.y, (aka b) - (enemy.y+8, aka e)
    ; carry means e<b, means enemy.bottom is visually above bullet.y (no collision)
    ld a, e
    add a, 16
    cp a, b

    ; no carry means 
    jp c, CheckCurrentEnemyAgainstBullets_NextLoop

    ; subtract  enemy.y-8 (aka e) - bullet.y (aka b)
    ; no carry means e>b, means enemy.top is visually below bullet.y (no collision)
    ld a, e
    sub a, 16
    cp a, b

    ; no carry means no collision
    jp nc, CheckCurrentEnemyAgainstBullets_NextLoop



CheckCurrentEnemyAgainstBullets_Loop_X:

    ; Get our x position
    ; b = bullet
    ; c = enemy address
    GetPointerVariableValue wBulletAddresses, 1, b
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 1, e

    ; compare enemy.right - bullet.x
    ; carry means e<b, means enemy.right is smaller than bullet.x (no collision)
    ld a, e
    add a, 16
    cp a, b

    jp c, CheckCurrentEnemyAgainstBullets_NextLoop

    ; compare enemy.right - bullet.x
    ; carry means e<b, means enemy.right is smaller than bullet.x (no collision)
    ld a, e
    sub a, 16
    cp a, b

    jp nc, CheckCurrentEnemyAgainstBullets_NextLoop
    
    ; set the first byte for the current bullet/enemy as zero for inactive
    SetPointerVariableValue wBulletAddresses, 0,0
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 0, 0

    ; set the second byte for the current bullet/enemy as zero for x=0 (move offscreeen)
    SetPointerVariableValue wBulletAddresses, 1,0
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, 1, 0
    
    call IncreaseScore;

    ; Decrease how many active enemies their are
    ld a, [wActiveEnemyCounter]
    dec a
    ld [wActiveEnemyCounter], a

    ; Decrease how many active bullets their are
    ld a, [wActiveBulletCounter]
    dec a
    ld [wActiveBulletCounter], a

    ret