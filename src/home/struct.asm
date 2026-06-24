GetStructWord_BC::
	push hl
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ret

SetStructWord_BC::
	push hl
	add_hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	ret

Func_109f:
	ld a, c
	add [hl]
	ld [hli], a
	ld a, b
	jr nc, .asm_10a6
	inc a
.asm_10a6
	add [hl]
	ld [hld], a
	ret

AddStructWord_BC:
	push hl
	add_hl
	call Func_109f
	pop hl
	ret

Func_10b0:
	ld a, e
	add [hl]
	ld [hli], a
	ld a, d
	jr nc, .asm_10b7
	inc a
.asm_10b7
	add [hl]
	ld [hld], a
	ret

AddStructWord_DE::
	push hl
	add_hl
	call Func_10b0
	pop hl
	ret

; unreferenced
SubStructWord_DE:
	push de
	push af
	xor a
	sub e
	ld e, a
	ld a, 0
	sbc d
	ld d, a
	pop af
	call AddStructWord_DE
	pop de
	ret

GetStructWord_DE::
	push hl
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret

SetStructWord_DE::
	push hl
	add_hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ret

GetStructByte_A::
	push hl
	add_hl
	ld a, [hl]
	pop hl
	ret

GetStructByte_C::
	push hl
	add_hl
	ld c, [hl]
	pop hl
	ret

GetStructByte_B::
	push hl
	add_hl
	ld b, [hl]
	pop hl
	ret

GetStructByte_E::
	push hl
	add_hl
	ld e, [hl]
	pop hl
	ret

GetStructByte_D::
	push hl
	add_hl
	ld d, [hl]
	pop hl
	ret

SetStructByte_C::
	push hl
	add_hl
	ld [hl], c
	pop hl
	ret

SetStructByte_B::
	push hl
	add_hl
	ld [hl], b
	pop hl
	ret

SetStructByte_E::
	push hl
	add_hl
	ld [hl], e
	pop hl
	ret

SetStructByte_D::
	push hl
	add_hl
	ld [hl], d
	pop hl
	ret
