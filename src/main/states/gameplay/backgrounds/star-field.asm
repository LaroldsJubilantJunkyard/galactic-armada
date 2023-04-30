
SECTION "BackgroundStarField", ROM0

starFieldMap: INCBIN "src/generated/backgrounds/star-field.tilemap"
starFieldMapEnd:
 
starFieldTileData: INCBIN "src/generated/backgrounds/star-field.2bpp"
starFieldTileDataEnd:

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