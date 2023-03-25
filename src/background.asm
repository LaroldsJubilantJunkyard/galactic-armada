
include "src/tilemap.inc"

 SECTION "Background", ROM0

InitializeBackground::

	ld a, 0
	ld [mBackgroundScroll+0],a
	ld a, 0
	ld [mBackgroundScroll+1],a

CopyTiles:: 
	; Copy the tile data
	ld de, Tiles ; de contains the address where data will be copied from;
	ld hl, $9000 ; hl contains the address where data will be copied to;
	ld bc, TilesEnd - Tiles ; bc contains how many bytes we have to copy.
	
CopyTiles_Loop: 
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles_Loop ; Jump to COpyTiles, if the z flag is not set. (the last operation had a non zero result)

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap

CopyTilemap:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTilemap

	ret

SECTION "BackgroundVariables", WRAM0

mBackgroundScroll: dw
mBackgroundScrollReal: db

