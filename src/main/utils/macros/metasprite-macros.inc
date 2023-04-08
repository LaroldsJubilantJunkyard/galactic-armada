MACRO DrawSpecificMetasprite

    CopyAddressToPointerVariable \1, wMetaspriteAddress

    ld a, \2
    ld [wMetaspriteX],a

    ld a, \3
    ld [wMetaspriteY],a

    call DrawMetasprites;

    ENDM