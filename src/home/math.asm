; returns de = d * e
DTimesE::
	ld a, d
	cp e ; d < e?
	jr c, ATimesE ; yes
	; d >= e, swap values
	ld a, e
	ld e, d
;	fallthrough

; returns de = a * e
; condition: a <= e
ATimesE:
	push hl
	ld d, 0
	ld h, d ; 0
	ld l, d ; 0
.loop
	srl a
	jr nc, .skip_add
	add hl, de
.skip_add
	sla e
	rl d
	and a
	jr nz, .loop
	ld d, h
	ld e, l
	pop hl
	ret

; outputs de = a * a
ASquared:
	cp 2
	jr c, .one
	ld e, a
	jr ATimesE
.one
	ld e, a
	ld d, $00
	ret

; outputs a = sqrt(de)
SquareRoot:
	push bc
	push hl
	ld hl, $4000
	ld b, l ; 0
	ld c, l ; 0
.loop
	push hl
	add hl, bc
	; hl += bc

	srl b
	rr c
	; bc /= 2

	; de < hl?
	ld a, d
	cp h
	jr nz, .check_condition
	ld a, e
	cp l
.check_condition
	jr c, .de_smaller_than_hl
	; de >= hl

	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, de
	ld d, h
	ld e, l
	; de -= hl

	pop hl
	ld a, c
	or l
	ld c, a
	ld a, b
	or h
	ld b, a
	; bc |= hl
	jr .next_iteration
.de_smaller_than_hl
	pop hl
.next_iteration
	srl h
	rr l
	srl h
	rr l
	; hl /= 4

	; hl == 0?
	ld a, h
	or l
	jr nz, .loop

	ld a, c
	pop hl
	pop bc
	ret
