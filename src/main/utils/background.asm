include "src/main/utils/macros/oam-macros.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/macros/vblank-macros.inc"
include "src/main/utils/macros/pointer-macros.inc"
include "src/main/utils/macros/int16-macros.inc"

SECTION "Background", ROM0


textFontTileData: INCBIN "src/generated/backgrounds/text-font.2bpp"
textFontTileDataEnd:
 
starFieldMap: INCBIN "src/generated/backgrounds/star-field.tilemap"
starFieldMapEnd:
 
starFieldTileData: INCBIN "src/generated/backgrounds/star-field.2bpp"
starFieldTileDataEnd:
 
titleScreenTileData: INCBIN "src/generated/backgrounds/title-screen.2bpp"
titleScreenTileDataEnd:

 
titleScreenTileMap: INCBIN "src/generated/backgrounds/title-screen.tilemap"
titleScreenTileMapEnd:

ClearBackground::

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld bc,1024
	ld hl, $9800

ClearBackgroundLoop:

	ld a,0
	ld [hli], a

	
	dec bc
	ld a, b
	or a, c

	jp nz, ClearBackgroundLoop


	; Turn the LCD on
	ld a, LCDCF_ON  | LCDCF_BGON|LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a


	ret

InitializeBackground::

	ld a, 0
	ld [mBackgroundScroll+0],a
	ld a, 0
	ld [mBackgroundScroll+1],a

	ret

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

DrawStarField::

	; Copy the tile data
	ld de, starFieldTileData ; de contains the address where data will be copied from;
	ld hl, $9340 ; hl contains the address where data will be copied to;
	ld bc, starFieldTileDataEnd - starFieldTileData ; bc contains how many bytes we have to copy.
	
DrawStarField_Loop: 
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, DrawStarField_Loop ; Jump to DrawStarField_Loop, if the z flag is not set. (the last operation had a non zero result)

	; Copy the tilemap
	ld de, starFieldMap
	ld hl, $9800
	ld bc, starFieldMapEnd - starFieldMap

DrawStarField_Tilemap:
	ld a, [de]
	add a, 52
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, DrawStarField_Tilemap

	ret

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

; This is called during gameplay state on every frame
ScrollBackground::

	; Increase our scaled integer by 5
	Increase16BitInteger [mBackgroundScroll+0], [mBackgroundScroll+1], 5

	; Get our true (non-scaled) value, and save it for later usage
    Get16BitIntegerNonScaledValue mBackgroundScroll, b
    ld a,b
	ld [mBackgroundScrollReal], a

	ret

; This is called during vblanks
UpdateBackgroundPosition::

	; Tell our background to use our previously saved true value
	ld a, [mBackgroundScrollReal]
	ld [rSCY], a

	ret

SECTION "BackgroundVariables", WRAM0

mBackgroundScroll: dw
mBackgroundScrollReal: db

mFillWidth: db
mFillHeight: db

