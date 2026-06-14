MACRO? lb ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

MACRO? jumptable
	rst JumpTable
ENDM

MACRO? get_pointer
	rst GetPointer
ENDM

MACRO? do_frame
	rst DoFrame
ENDM

MACRO? add_hl
	rst AddHL
ENDM

MACRO? sub_hl
	rst SubHL
ENDM

MACRO? add_de
	rst AddDE
ENDM

MACRO? disable_lcd
	rst DisableLCD
ENDM

MACRO? add_bc
	rst AddBC
ENDM

MACRO? bankswitch
	ldh [hROMBank], a
	ld [rROMB0 + $150], a
ENDM

MACRO? wramswitch
	ldh [hWRAMBank], a
	ldh [rWBK], a
ENDM

MACRO? vramswitch
	ldh [hVRAMBank], a
	ldh [rVBK], a
ENDM

MACRO? homecall
	ld a, BANK(\1)
	bankswitch
	call \1
ENDM

MACRO? wait_ppu
:
	ldh a, [rSTAT]
	and STAT_BUSY
	jr z, :-
:
	ldh a, [rSTAT]
	and STAT_BUSY
	jr nz, :-
ENDM

MACRO? call_hl
	ld de, :+
	push de
	jp hl
:
ENDM

MACRO? swap_hl_de
	push de
	ld e, l
	ld d, h
	pop hl
ENDM

DEF deg EQUS " * 256 / 360"

MACRO dbmin
	DEF x = (\1)
	SHIFT
	FOR n, _NARG
		IF (\1) < x
			DEF x = (\1)
		ENDC
		SHIFT
	ENDR
	db x
ENDM

MACRO? maskbits
; masks just enough bits to cover values 0 to \1 - 1
; \2 is an optional shift amount
	ASSERT 0 < (\1) && (\1) <= $100, "bitmask must be 8-bit"
	DEF x = (1 << BITWIDTH((\1) - 1)) - 1
	IF _NARG == 2
		DEF x <<= \2
	ENDC
	and x
ENDM

