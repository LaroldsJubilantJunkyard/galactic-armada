
; DrawSpecificMetasprite bulletMetasprite, b, c
; means draw the bullet metasprite as x=b, y =c
MACRO DrawSpecificMetasprite

    ; Save the address of the metasprite into the 'wMetaspriteAddress' variable
    ; Our DrawMetasprites functoin uses that variable
    CopyAddressToPointerVariable \1, wMetaspriteAddress

    ; Save the x position
    ld a, \2
    ld [wMetaspriteX],a

    ; Save the y position
    ld a, \3
    ld [wMetaspriteY],a

    ; Actually call the 'DrawMetasprites function
    call DrawMetasprites;

    ENDM