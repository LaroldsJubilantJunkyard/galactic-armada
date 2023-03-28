include "src/utils/macros/oam-macros.inc"
include "src/utils/constants.inc"
include "src/utils/macros/pointer-macros.inc"
include "src/utils/macros/int16-macros.inc"

SECTION "MetaSpriteVariables", WRAM0

wMetaspriteAddress:: dw
wMetaspriteX:: db
wMetaspriteY::db

SECTION "MetaSprites", ROM0


DrawMetasprites::

    GetPointerVariableValue wMetaspriteAddress, metasprite_y, b

    ; stop if the y position is 128 
    ld a, b
    cp 128
    ret z

    ld a, [wMetaspriteY]
    add a, b
    ld [wMetaspriteY],a

    GetPointerVariableValue wMetaspriteAddress, metasprite_x, c

    ld a, [wMetaspriteX]
    add a,c
    ld [wMetaspriteX],a


    GetPointerVariableValue wMetaspriteAddress, metasprite_tile, d
    GetPointerVariableValue wMetaspriteAddress, metasprite_flag, e
    
    SetCurrentOAMValue 0, [wMetaspriteY]
    SetCurrentOAMValue 1, [wMetaspriteX]
    SetCurrentOAMValue 2, d
    SetCurrentOAMValue 3, e

    call NextOAMSprite

    IncreasePointerVariableAddress wMetaspriteAddress, METASPRITE_BYTES_COUNT

    jp DrawMetasprites
