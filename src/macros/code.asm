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
