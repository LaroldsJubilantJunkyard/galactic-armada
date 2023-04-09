
INCLUDE "src/main/utils/macros/vblank-macros.inc"

SECTION "InputUtilsVariables", WRAM0

mWaitKey:: db

SECTION "InputUtils", ROM0


WaitForKeyFunction::

    ; Save our original value
    push bc

	; save the keys last frame
	ld a, [wCurKeys]
	ld [wLastKeys], a
    
	; This is in input.asm
	; It's straight from: https://gbdev.io/gb-asm-tutorial/part2/input.html
	; In their words (paraphrased): reading player input for gameboy is NOT a trivial task
	; So it's best to use some tested code
    call Input

    
	ld a, [mWaitKey]
    ld b,a
	ld a, [wCurKeys]
    and a, b
    jp z,WaitForKeyFunction_NotPressed
    
	ld a, [wLastKeys]
    and a, b
    jp nz,WaitForKeyFunction_NotPressed

	; restore our original value
	pop bc

    ret


WaitForKeyFunction_NotPressed:

    WaitForVBlank

    jp WaitForKeyFunction