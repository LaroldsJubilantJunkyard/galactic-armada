include "src/main/utils/macros/oam-macros.inc"
include "src/main/utils/hardware.inc"
include "src/main/utils/macros/vblank-macros.inc"
include "src/main/utils/macros/pointer-macros.inc"
include "src/main/utils/macros/int16-macros.inc"

SECTION "Background", ROM0
 

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
