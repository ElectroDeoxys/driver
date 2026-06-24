ReadJoypad:
	; poll directional pad
	ld a, JOYP_GET_CTRL_PAD
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOYP_INPUTS
	swap a
	ld b, a

	; poll buttons
	ld a, JOYP_GET_BUTTONS
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOYP_INPUTS
	or b
	ld c, a

	ld a, JOYP_GET_NONE
	ldh [rJOYP], a
	ld a, [wJoypadDown]
	xor c
	and c
	ld [wJoypadPressed], a
	ld a, c
	ld [wJoypadDown], a
	ret
