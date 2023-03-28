
include "src/resources/backgrounds/tilemap.inc"

include "src/utils/macros/oam-macros.inc"
include "src/utils/hardware.inc"
include "src/utils/macros/pointer-macros.inc"
include "src/utils/macros/int16-macros.inc"

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

ScrollBackground::

	Increase16BitInteger [mBackgroundScroll+0], [mBackgroundScroll+1], 5

    Get16BitIntegerNonScaledValue mBackgroundScroll, b
    ld a,b
	ld [mBackgroundScrollReal], a

	ret

UpdateBackgroundPosition::

	ld a, [mBackgroundScrollReal]
	ld [rSCY], a

	ret

SECTION "BackgroundVariables", WRAM0

mBackgroundScroll: dw
mBackgroundScrollReal: db

