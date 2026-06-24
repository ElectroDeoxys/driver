; returns hl = abs(hl)
GetAbsHL::
	bit 7, h ; negative?
	ret z ; is positive, exit
	push af
	xor a
	sub l
	ld l, a
	ld a, 0
	sbc h
	ld h, a
	pop af
	ret

; returns hl = hl - de
HLMinusDE::
	push af
	ld a, l
	sub e
	ld l, a
	ld a, h
	jr nc, .no_carry
	dec h
.no_carry
	ld a, h
	sub d
	ld h, a
	pop af
	ret

; returns hl = hl - bc
HLMinusBC::
	push af
	ld a, l
	sub c
	ld l, a
	ld a, h
	jr nc, .no_carry
	dec h
.no_carry
	ld a, h
	sub b
	ld h, a
	pop af
	ret
