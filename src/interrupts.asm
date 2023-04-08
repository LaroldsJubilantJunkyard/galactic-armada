INCLUDE "src/utils/hardware.inc"

 SECTION "Interrupts", ROM0

 DisableInterrupts::
	ld a, 0
	ldh [rSTAT], a
	di
	ret

InitInterrupts::

    ld a, IEF_STAT
	ldh [rIE], a
	xor a, a ; This is equivalent to `ld a, 0`!
	ldh [rIF], a
	ei

	ld a, STATF_LYC
	ldh [rSTAT], a

	ld a, 0
	ldh [rLYC], a

    ret

; Define a new section and hard-code it to be at $0048.
SECTION "Stat Interrupt", ROM0[$0048]
StatInterrupt:

	push af

	ldh a, [rLYC]
	cp 0
	jp z, LYCEqualsZero

LYCEquals8:

	ld a, 0
	ldh [rLYC], a

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_WINOFF | LCDCF_WIN9C00|LCDCF_BG9800
	ldh [rLCDC], a

	jp EndStatInterrupts

LYCEqualsZero:

	ld a, 8
	ldh [rLYC], a

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJOFF | LCDCF_OBJ16| LCDCF_WINON | LCDCF_WIN9C00|LCDCF_BG9800
	ldh [rLCDC], a


EndStatInterrupts:

	pop af

	reti;