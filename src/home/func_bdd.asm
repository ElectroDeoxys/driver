; input:
; - bc = x coordinate
; - de = y coordinate
; - wdc7a = ?
; - wdc7c = ?
; - wdc7e = ?
; - wdc80 = ?
Func_bdd::
	push hl
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, bc
	; hl = bc - wdc7a
	bit 7, h
	jr nz, .no_carry
	ld a, [wdc7c + 0]
	ld c, a
	ld a, [wdc7c + 1]
	ld b, a
	ld a, h
	cp b
	jr nz, .asm_bfe
	ld a, l
	cp c
.asm_bfe
	; hl < wdc7c?
	jr nc, .no_carry ; no

	ld hl, wdc7e
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, de
	bit 7, h
	; hl = de - wdc7e
	jr nz, .no_carry
	ld a, [wdc80]
	ld e, a
	ld a, [wdc81]
	ld d, a
	ld a, h
	cp d
	jr nz, .asm_c20
	ld a, l
	cp e
.asm_c20
	; hl < wdc80?
	jr nc, .no_carry

	pop hl
	scf
	ret
.no_carry
	pop hl
	and a
	ret
