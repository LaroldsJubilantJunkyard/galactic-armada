
include "src/utils/hardware.inc"
include "src/utils/macros/oam-macros.inc"
include "src/utils/hardware.inc"
include "src/utils/macros/pointer-macros.inc"
include "src/utils/macros/int16-macros.inc"
include "src/utils/macros/metasprite-macros.inc"
include "src/utils/constants.inc"

SECTION "PlayerVariables", WRAM0

; first byte is low, second is high (little endian)
wPlayerPosition: 
	.x dw
    .y dw

wPlayerPositionTest: db

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

    ; Place in the middle of the screen
    Set16BitIntegerFromNonScaledValue wPlayerPosition.x,80
    Set16BitIntegerFromNonScaledValue wPlayerPosition.y,80

    
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


UpdatePlayer_UpdateSprite:

    Get16BitIntegerNonScaledValue wPlayerPosition.x, b
    Get16BitIntegerNonScaledValue wPlayerPosition.y, c


    DrawSpecificMetasprite playerTestMetaSprite, b, c

    ret

TryShoot:
	ld a, [wLastKeys]
	and a, PADF_A
    ret nz

    Get16BitIntegerNonScaledValue wPlayerPosition.x, b
    ld a,b
    ld [wNextBullet], a

    ld a, [wPlayerPosition.y+0]
    ld [wNextBullet+1], a

    ld a, [wPlayerPosition.y+1]
    ld [wNextBullet+2], a

    call FireNextBullet;

    ret

MoveUp:

    Decrease16BitInteger [wPlayerPosition.y+0], [wPlayerPosition.y+1], PLAYER_MOVE_SPEED

    ret

MoveDown:

    Increase16BitInteger [wPlayerPosition.y+0], [wPlayerPosition.y+1], PLAYER_MOVE_SPEED

    ret

MoveLeft:

    Decrease16BitInteger [wPlayerPosition.x+0], [wPlayerPosition.x+1], PLAYER_MOVE_SPEED
    ret

MoveRight:

    Increase16BitInteger [wPlayerPosition.x+0], [wPlayerPosition.x+1], PLAYER_MOVE_SPEED

    ret


