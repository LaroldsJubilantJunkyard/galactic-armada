include "src/utils.inc"
include "src/hardware.inc"

SECTION "SpriteVariables", WRAM0

wLastOAMAddress:: dw
wSpritesUsed:: db
wHelperValue::db

SECTION "Sprites", ROM0

ClearAllSprites::
	 
	; Start clearing oam
	ld a, 0
    ld b, OAM_COUNT*sizeof_OAM_ATTRS ; 40 sprites times 4 bytes per sprite
    ld hl, wShadowOAM ; The start of our oam sprites in RAM

ClearOamLoop::
    ld [hli], a
    dec b
    jp nz, ClearOamLoop
    ld a,0
    ld [wSpritesUsed],a
    ret

ClearRemainingSprites::

    ld a, [wLastOAMAddress+0]
    cp a, 160
    ret nc
    
    SetCurrentOAMValue 0,0
    SetCurrentOAMValue 1,0

    call NextOAMSprite

    jp ClearRemainingSprites


ResetOAMSprite::
    
    ld a, 0
    ld [wSpritesUsed], a

	ld a, LOW(wShadowOAM)
	ld [wLastOAMAddress+0], a
	ld a, HIGH(wShadowOAM)
	ld [wLastOAMAddress+1], a

    ret

NextOAMSprite::

    ld a, [wSpritesUsed]
    inc a
    ld [wSpritesUsed], a


	ld a,[wLastOAMAddress+0]
    add a, sizeof_OAM_ATTRS
	ld [wLastOAMAddress+0], a
	ld a, HIGH(wShadowOAM)
	ld [wLastOAMAddress+1], a


    ret

    