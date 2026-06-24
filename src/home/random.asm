Random::
	push hl
	ld a, [wRNG]
	and $48
	adc $38
	sla a
	sla a
	ld hl, wRNG + $3
	rl [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	ld a, [hl]
	pop hl
	ret

; unreferenced
UnreferencedRandomRange:
	push de
	push hl
	ld e, a
	ld d, $00
	ld h, d ; 0
	ld l, d ; 0
	call Random
.loop
	srl a
	jr nc, .next
	add hl, de
.next
	sla e
	rl d
	and a
	jr nz, .loop
	ld a, h
	pop hl
	pop de
	ret

; initialises wRNG with a seed
SetRNGSeed:
	ld hl, .Seed
	ld de, wRNG
	ld b, $4
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

.Seed:
	db $ff, $80, $26, $37
