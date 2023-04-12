INCLUDE "src/main/utils/hardware.inc"
INCLUDE "src/main/utils/macros/input-macros.inc"
INCLUDE "src/main/utils/macros/vblank-macros.inc"
INCLUDE "src/main/utils/macros/text-macros.inc"

SECTION "TitleScreenState", ROM0


wPressPlayText::  db "press a to play", 255


 
titleScreenTileData: INCBIN "src/generated/backgrounds/title-screen.2bpp"
titleScreenTileDataEnd:

 
titleScreenTileMap: INCBIN "src/generated/backgrounds/title-screen.tilemap"
titleScreenTileMapEnd:


DrawTitleScreen::

	; Copy the tile data
	ld de, titleScreenTileData ; de contains the address where data will be copied from;
	ld hl, $9340 ; hl contains the address where data will be copied to;
	ld bc, titleScreenTileDataEnd - titleScreenTileData ; bc contains how many bytes we have to copy.
	
DrawTitleScreen_Loop: 
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, DrawTitleScreen_Loop ; Jump to COpyTiles, if the z flag is not set. (the last operation had a non zero result)

	; Copy the tilemap
	ld de, titleScreenTileMap
	ld hl, $9800
	ld bc, titleScreenTileMapEnd - titleScreenTileMap

DrawTitleScreen_Tilemap:
	ld a, [de]
	add a, 52
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, DrawTitleScreen_Tilemap

	ret

InitTitleScreenState::

	call DrawTitleScreen
    DrawText wPressPlayText, $99C3

	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

    ret;
	
UpdateTitleScreenState::

    WaitForKey PADF_A

    ld a, 1
    ld [wGameState],a
    jp NextGameState
