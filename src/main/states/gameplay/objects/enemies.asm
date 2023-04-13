
include "src/main/utils/macros/oam-macros.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/macros/pointer-macros.inc"
include "src/main/utils/macros/int16-macros.inc"
include "src/main/utils/macros/metasprite-macros.inc"
include "src/main/utils/macros/collision-macros.inc"
include "src/main/utils/constants.inc"

SECTION "EnemyVariables", WRAM0

wSpawnCounter: db
wNextEnemy:
    .x db
    .y dw
    .speed db
    .health db
wActiveEnemyCounter::db
wUpdateEnemiesCounter:db
wUpdateEnemiesCurrentEnemyAddress::dw

; Bytes: active, x , y (low), y (high), speed, health
wEnemies:: ds MAX_ENEMY_COUNT*PER_ENEMY_BYTES_COUNT

SECTION "Enemies", ROM0

enemyShipMetasprite::
    .metasprite1    db 0,0,4,0
    .metasprite2    db 0,8,6,0
    .metaspriteEnd  db 128

InitializeEnemies::


CopyHappyFace:

	ld de, enemyShipTileData
	ld hl, ENEMY_TILES_START
	ld bc, enemyShipTileDataEnd - enemyShipTileData

CopyHappyFace_Loop:

	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyHappyFace_Loop

    ld a, 0
    ld [wSpawnCounter], a

    ld a,0
    ld [wActiveEnemyCounter], a

    ld b, 0

    ld hl, wEnemies

InitializeEnemies_Loop:

    ; Set as inactive
    ld a, 0
    ld [hl], a

    ; Increase the address
    Increase16BitInteger l, h, PER_ENEMY_BYTES_COUNT

    ld a, b
    inc a
    ld b ,a

    cp a, MAX_ENEMY_COUNT
    ret z

    jp InitializeEnemies_Loop

UpdateEnemies::

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveEnemyCounter]
    cp a, 0
    ret z
    
    ld a, 0
    ld [wUpdateEnemiesCounter], a

    CopyAddressToPointerVariable wEnemies, wUpdateEnemiesCurrentEnemyAddress

    jp UpdateEnemies_Loop

UpdateEnemies_NextEnemy:

    ; Check our coutner, if it's zero
    ; Stop the function
    ld a, [wUpdateEnemiesCounter]
    inc a
    ld [wUpdateEnemiesCounter], a

    ; Compare against the active count
    ld a, [wUpdateEnemiesCounter]
    cp a, MAX_ENEMY_COUNT
    ret nc

    ; Increase the enemy data our address is pointingtwo
    IncreasePointerVariableAddress wUpdateEnemiesCurrentEnemyAddress, PER_ENEMY_BYTES_COUNT

UpdateEnemies_Loop:

    ; The first byte is if the current object is active
    ; If it's zero, it's inactive, go to the loop section
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_activeByte, b
    ld a,b
    cp 0
    jp z, UpdateEnemies_NextEnemy


    ; Get our x position
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_xByte, b
    

    ; get our 16-bit y position
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_yLowByte, c
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_yHighByte, d

    push de
    push bc

UpdateEnemies_Loop_PlayerCollision:

    DeScale16BitInteger c,d

    Get16BitIntegerNonScaledValue wPlayerPositionX, d
    Get16BitIntegerNonScaledValue wPlayerPositionY, e
    

    ; Check the x distances. Jump to 'NoCollisionWithPlayer' on failure
    CheckAbsoluteDifferenceAndJump b,d, 16, NoCollisionWithPlayer

    ; Check the y distances. Jump to 'NoCollisionWithPlayer' on failure
    CheckAbsoluteDifferenceAndJump c,e, 16, NoCollisionWithPlayer

    call DamagePlayer
    call DrawLives

    pop bc
    pop de
    
    jp UpdateEnemies_DeActivateEnemy

NoCollisionWithPlayer::

    pop bc
    pop de


    ; Get our move speed
    GetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_speedByte, e

    Increase16BitInteger c,d,e
    
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_yLowByte,c
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_yHighByte,d

    DeScale16BitInteger c,d

    ; See if our non scaled low byte is above 160
    ld a, c
    cp a, 160
    jp nc, UpdateEnemies_DeActivateEnemy

    
    DrawSpecificMetasprite enemyShipMetasprite, b, c
    
    ; check for collisions against bulelts
    call CheckCurrentEnemyAgainstBullets
    
    ; If it above 160, update the next enemy
    ; If it below 160, continue on  to deactivate
    jp UpdateEnemies_NextEnemy

UpdateEnemies_DeActivateEnemy:

    ; if it's y value is grater than 160
    ; Set as inactive
    SetPointerVariableValue wUpdateEnemiesCurrentEnemyAddress, enemy_activeByte,0

    ; Decrease counter
    ld a,[wActiveEnemyCounter]
    dec a
    ld [wActiveEnemyCounter], a

    jp UpdateEnemies_NextEnemy
    
SpawnNextEnemy:

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveEnemyCounter]
    cp a, MAX_ENEMY_COUNT
    ret nc

    push bc
    push de
    push hl

    ld b, 0

    ld hl, wEnemies

    jp SpawnNextEnemy_Loop


SpawnNextEnemy_NextEnemy:

    ; Increase the address
    Increase16BitInteger l, h, PER_ENEMY_BYTES_COUNT

    ld a, b
    cp a, MAX_ENEMY_COUNT
    jp nc,SpawnNextEnemy_End

    inc a
    ld b ,a

SpawnNextEnemy_Loop:

    ld a, [hl]

    cp a, 0
    jp nz, SpawnNextEnemy_NextEnemy

    ; Set as  active
    ld a, 1
    ld [hli], a

    ; Set the x position
    ld a, [wNextEnemy.x]
    ld [hli], a

    ; Set the y position (low)
    ld a, [wNextEnemy.y+0]
    ld [hli], a

    ;Set the y position (high)
    ld a, [wNextEnemy.y+1]
    ld [hli], a

    ;Set the speed
    ld a, [wNextEnemy.speed]
    ld [hli], a

    ;Set the health
    ld a, [wNextEnemy.health]
    ld [hli], a

    ; Increase counter
    ld a,[wActiveEnemyCounter]
    inc a
    ld [wActiveEnemyCounter], a

    jp SpawnNextEnemy_End


SpawnNextEnemy_End:


    pop hl
    pop de
    pop bc

    ret



SpawnEnemies::

    ; Increase our spwncounter
    ld a, [wSpawnCounter]
    inc a
    ld [wSpawnCounter], a

    ; Check our spawn acounter
    ; Stop if it's below a given value
    ld a, [wSpawnCounter]
    cp a, ENEMY_SPAWN_DELAY_MAX
    ret c

    ; Make sure we don't have the max amount of enmies
    ld a, [wActiveEnemyCounter]
    cp a, MAX_ENEMY_COUNT
    ret nc

GetSpawnPosition:

    ; Generate a semi random value
    call rand
    
    ; make sure it's not above 150
    ld a,b
    cp a, 150
    ret nc

    ; make sure it's not below 24
    ld a, b
    cp a, 24
    ret c

    ; reset our spawn counter
    ld a, 0
    ld [wSpawnCounter], a
    
    ld a, b
    ld [wNextEnemy.x], a

    Set16BitIntegerFromNonScaledValue wNextEnemy.y, 0

    ld a, ENEMY_MOVE_SPEED
    ld [wNextEnemy.speed], a

    ld a, 1
    ld [wNextEnemy.health], a

    call SpawnNextEnemy

    ret