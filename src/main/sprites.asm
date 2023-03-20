include "src/main/utils.inc"
include "src/main/hardware.inc"

SECTION "SpriteVariables", WRAM0

wLastOAMAddress:: dw
wSpritesUsed:: db
wHelperValue::db

SECTION "Sprites", ROM0

ClearAllSprites::
	 
	; Start clearing oam
	ld a, 0
    ld b, OAM_COUNT*sizeof_OAM_ATTRS ; 40 sprites times 4 bytes per sprite
    ld hl, _OAMRAM ; The start of our oam sprites in RAM

ClearOamLoop::
    ld [hli], a
    dec b
    jp nz, ClearOamLoop
    ld a,0
    ld [wSpritesUsed],a
    ret

ClearRemainingSprites::

    ld a, [wSpritesUsed]
    cp a, OAM_COUNT
    ret z
    
    SetCurrentOAMValue 0,0

    call NextOAMSprite

    jp ClearRemainingSprites


ResetOAMSprite::
    
    ld a, 0
    ld [wSpritesUsed], a

	ld a, LOW(_OAMRAM)
	ld [wLastOAMAddress+0], a
	ld a, HIGH(_OAMRAM)
	ld [wLastOAMAddress+1], a

    ret

NextOAMSprite::

    ld a, [wSpritesUsed]
    inc a
    ld [wSpritesUsed], a


	ld a,[wLastOAMAddress+0]
    add a, sizeof_OAM_ATTRS
	ld [wLastOAMAddress+0], a
	ld a, HIGH(_OAMRAM)
	ld [wLastOAMAddress+1], a


    ret

    