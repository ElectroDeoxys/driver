; unreferenced
UnreferencedFarCallHL:
	ldh a, [hROMBank]
	ld b, a
	push bc
	ld a, c
	bankswitch
	ld bc, .return
	push bc
	jp hl
.return
	pop bc
	ld a, b
	bankswitch
	ret
