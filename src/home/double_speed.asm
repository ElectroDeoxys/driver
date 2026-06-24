EnableDoubleSpeed:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	ret nz ; not CGB
	ld hl, rSPD
	bit B_SPD_DOUBLE, [hl]
	ret nz ; already enabled
	set B_SPD_PREPARE, [hl]
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ld a, JOYP_GET_NONE
	ldh [rJOYP], a
	stop
	ret
