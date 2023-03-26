
include "src/utils/hardware.inc"
include "src/resources/sprites/happy-face.z80"
include "src/resources/sprites/happy-face.inc"
include "src/utils/oam-macros.inc"
include "src/utils/hardware.inc"
include "src/utils/pointer-macros.inc"
include "src/utils/int16-macros.inc"
include "src/utils/constants.inc"

SECTION "PlayerVariables", WRAM0

; first byte is low, second is high (little endian)
wPlayerPosition: 
	.x dw
    .y dw


wPlayerPositionTest: db

SECTION "Player", ROM0

InitializePlayer::

    ; Place in the middle of the screen
    Set16BitIntegerFromNonScaledValue wPlayerPosition.x,80
    Set16BitIntegerFromNonScaledValue wPlayerPosition.y,80

    
CopyHappyFace:

	ld de, HappyFace
	ld hl, $8000
	ld bc, HappyFaceEnd - HappyFace

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
    SetCurrentOAMValue 1, b

    Get16BitIntegerNonScaledValue wPlayerPosition.y, b
    SetCurrentOAMValue 0, b

    ld b, 0
    SetCurrentOAMValue 2,b
    SetCurrentOAMValue 3, b

    call NextOAMSprite

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

