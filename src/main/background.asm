
 SECTION "Background", ROM0

InitializeBackground:

	ld a, 0
	ld [mBackgroundScroll+0],a
	ld a, 0
	ld [mBackgroundScroll+1],a
    
    ret


SECTION "BackgroundVariables", WRAM0

mBackgroundScroll: dw
mBackgroundScrollReal: db