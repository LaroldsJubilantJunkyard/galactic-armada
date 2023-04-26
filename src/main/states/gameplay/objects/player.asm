
include "src/main/utils/hardware.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/macros/pointer-macros.inc"
include "src/main/utils/macros/int16-macros.inc"
include "src/main/utils/macros/metasprite-macros.inc"
include "src/main/utils/constants.inc"

SECTION "PlayerVariables", WRAM0

; first byte is low, second is high (little endian)
wPlayerPositionX:: dw
wPlayerPositionY:: dw

mPlayerFlash: dw

SECTION "Player", ROM0

playerShipTileData: INCBIN "src/generated/sprites/player-ship.2bpp"
playerShipTileDataEnd:

enemyShipTileData:: INCBIN "src/generated/sprites/enemy-ship.2bpp"
enemyShipTileDataEnd::

bulletTileData:: INCBIN "src/generated/sprites/bullet.2bpp"
bulletTileDataEnd::


playerTestMetaSprite::
    .metasprite1    db 0,0,0,0
    .metasprite2    db 0,8,2,0
    .metaspriteEnd  db 128

InitializePlayer::

    ld a, 0
    ld [mPlayerFlash+0],a
    ld [mPlayerFlash+1],a

    ; Place in the middle of the screen
    Set16BitIntegerFromNonScaledValue wPlayerPositionX,80
    Set16BitIntegerFromNonScaledValue wPlayerPositionY,80

    
CopyHappyFace:

	ld de, playerShipTileData
	ld hl, PLAYER_TILES_START
	ld bc, playerShipTileDataEnd - playerShipTileData

CopyHappyFace_Loop:

	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyHappyFace_Loop

    ret;

UpdatePlayer::

UpdatePlayer_HandleInput:

	ld a, [wCurKeys]
	and a, PADF_UP
	call nz, MoveUp

	ld a, [wCurKeys]
	and a, PADF_DOWN
	call nz, MoveDown

	ld a, [wCurKeys]
	and a, PADF_LEFT
	call nz, MoveLeft

	ld a, [wCurKeys]
	and a, PADF_RIGHT
	call nz, MoveRight

	ld a, [wCurKeys]
	and a, PADF_A
	call nz, TryShoot

    ld a, [mPlayerFlash+0]
    ld b, a

    ld a, [mPlayerFlash+1]
    ld c, a
    
    

UpdatePlayer_UpdateSprite_CheckFlashing:

    ld a, b
    or a, c
    jp z, UpdatePlayer_UpdateSprite

    ; decrease bc by 5
    ld a, b
    sub a, 5
    ld b, a
    ld a, c
    sbc a, 0
    ld c, a
    

UpdatePlayer_UpdateSprite_DecreaseFlashing:

    ld a, b
    ld [mPlayerFlash+0], a
    ld a, c
    ld [mPlayerFlash+1], a

    ; descale bc
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b
    srl c
    rr b

    ld a, b
    cp a, 5
    jp c, UpdatePlayer_UpdateSprite_StopFlashing


    bit 0, b
    jp z, UpdatePlayer_UpdateSprite

UpdatePlayer_UpdateSprite_Flashing:

    ret;
UpdatePlayer_UpdateSprite_StopFlashing:

    ld a, 0
    ld [mPlayerFlash+0],a
    ld [mPlayerFlash+1],a

UpdatePlayer_UpdateSprite:

    Get16BitIntegerNonScaledValue wPlayerPositionX, b
    Get16BitIntegerNonScaledValue wPlayerPositionY, c

    DrawSpecificMetasprite playerTestMetaSprite, b, c

    ret

TryShoot:
	ld a, [wLastKeys]
	and a, PADF_A
    ret nz

    Get16BitIntegerNonScaledValue wPlayerPositionX, b
    ld a,b
    ld [wNextBullet], a

    ld a, [wPlayerPositionY+0]
    ld [wNextBullet+1], a

    ld a, [wPlayerPositionY+1]
    ld [wNextBullet+2], a

    call FireNextBullet;

    ret

DamagePlayer::

    

    ld a, 0
    ld [mPlayerFlash+0], a
    ld a, 1
    ld [mPlayerFlash+1], a

    ld a, [wLives]
    dec a
    ld [wLives], a

    ret

MoveUp:

    Decrease16BitInteger [wPlayerPositionY+0], [wPlayerPositionY+1], PLAYER_MOVE_SPEED

    ret

MoveDown:

    Increase16BitInteger [wPlayerPositionY+0], [wPlayerPositionY+1], PLAYER_MOVE_SPEED

    ret

MoveLeft:

    Decrease16BitInteger [wPlayerPositionX+0], [wPlayerPositionX+1], PLAYER_MOVE_SPEED
    ret

MoveRight:

    Increase16BitInteger [wPlayerPositionX+0], [wPlayerPositionX+1], PLAYER_MOVE_SPEED

    ret


