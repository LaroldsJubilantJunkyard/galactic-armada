INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"
SECTION "Text", ROM0

textFontTileData: INCBIN "src/generated/backgrounds/text-font.2bpp"
textFontTileDataEnd:

LoadTextFontIntoVRAM::
	; Copy the tile data
	ld de, textFontTileData ; de contains the address where data will be copied from;
	ld hl, $9000 ; hl contains the address where data will be copied to;
	ld bc, textFontTileDataEnd - textFontTileData ; bc contains how many bytes we have to copy.
	
LoadTextFontIntoVRAM_Loop: 
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, LoadTextFontIntoVRAM_Loop ; Jump to COpyTiles, if the z flag is not set. (the last operation had a non zero result)
	ret


DrawTextTilesLoop::

    ; Check for the end of string character 255
    ld a, [hl]
    cp 255
    ret z

    ; Write the current character (in hl) to the address
    ; on the tilemap (in de)
    ld a, [hl]
    ld [de], a

    inc hl
    inc de

    ; move to the next character and next background tile
    jp DrawTextTilesLoop

DrawText_WithTypewriterEffect::

    push de
    push de

DrawText_WithTypewriterEffect_Loop:
    
    ; Check for the end of text character 253
    ld a, [hl]
    cp END_OF_MESSAGE
    jp nz, DrawText_WithTypewriterEffect_Loop_NotEndOfText

    pop de
    pop de

    ret

DrawText_WithTypewriterEffect_Loop_NotEndOfText:

    ; check new page
    ld a, [hl]
    cp NEW_PAGE
    jp z, DrawText_WithTypewriterEffect_Loop_NewPage

    ; check new page
    ld a, [hl]
    cp NEW_LINE
    jp z, DrawText_WithTypewriterEffect_Loop_NewLine

    jp DrawText_WithTypewriterEffect_Loop_Normal


DrawText_WithTypewriterEffect_Loop_NewPage:

    push hl

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait for A
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Save the passed value into the variable: mWaitKey
    ; The WaitForKeyFunction always checks against this vriable
    ld a,PADF_A
    ld [mWaitKey], a

    call WaitForKeyFunction

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    call ClearBackground

    pop hl

    inc hl

    pop de
    pop de
    push de 
    push de

    jp DrawText_WithTypewriterEffect_Loop


DrawText_WithTypewriterEffect_Loop_NewLine:

    pop de

    ld a, e
    add a, 64
    ld e, a
    ld a, d
    adc a, 0
    ld d, a

    push de

    inc hl

    jp DrawText_WithTypewriterEffect_Loop

DrawText_WithTypewriterEffect_Loop_Normal:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Wait a small amount of time
    ; Save our count in this variable
    ld a, 3
    ld [wVBlankCount], a

    ; Call our function that performs the code
    call WaitForVBlankFunction
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Write the current character (in hl) to the address
    ; on the tilemap (in de)
    ld a, [hl]
    ld [de], a

    ; move to the next character and next background tile
    inc hl
    inc de

    jp DrawText_WithTypewriterEffect_Loop
