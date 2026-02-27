Func_4000::
	xor a
	ld [wd868], a
	ld [wd86a], a
	ld a, $00
	ld [wd83f], a
	ld a, [wd828]
	ld c, a
	ld a, [wd829]
	ld b, a
	ld a, [wd82a]
	ld e, a
	ld a, [wd82b]
	ld d, a
	ld hl, wd826
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd82c]
	call Func_2631
	set 1, [hl]
	ld a, l
	ld [wda4a], a
	ld a, h
	ld [wda4b], a
	push hl
	ld hl, Func_4066
	ld c, BANK(Func_4066)
	ld b, $01
	call SpawnEntity
	pop de
	ld a, ENT_UNK06
	call SetEntityWordField_DE

	; swap hl and de
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, ENT_UNK23
	call SetEntityWordField_DE

	call Func_1124
	ld a, ENT_UNK25
	call SetEntityWordField_DE

	jp Func_3047
; 0x4057

SECTION "Func_4066", ROMX[$4066], BANK[$1]

Func_4066:
	call Func_1598
	xor a
	ld [wda94], a
	ld [wda95], a
	ld [wda96], a
	ld a, [wd81f]
	cp $06
	call nz, Func_475f
.asm_407b
	ld a, 1
	call YieldEntityUpdate
	ld a, [wd820]
	cp $00
	jr z, .asm_407b
	ld de, Func_4446
	ld a, BANK(Func_4446)
	jp Func_157f
; 0x408f

SECTION "Func_40f4", ROMX[$40f4], BANK[$1]

Func_40f4:
	xor a
	ld [wda5d], a
	call Func_2f5f
	ld b, $08
	ld de, wd8eb
.asm_4100
	ld a, [de]
	and $01
	jr z, .asm_410b
	ld a, [de]
	and $02
	call z, Func_4119
.asm_410b
	ld a, $27
	add_de
	dec b
	jr nz, .asm_4100
	ld a, [wda5d]
	and a
	ret z
	jp Func_3047

Func_4119:
	push bc
	call Func_2a90
	jr nc, .asm_4121
	pop bc
	ret
.asm_4121
	call Func_2d66
	ld [wda66], a
	call Func_3275
	jr nc, .asm_4137
	ld a, [wda66]
	call Func_31fb
	ld a, $01
	ld [wda5d], a
.asm_4137
	ld a, [wda93]
	ld b, a
	call Func_421c
	srl b
	ld a, [wda66]
	add $80
	ld c, a
	push de
	call Func_2967
	pop de
	ld a, $0d
	call GetEntityWordField_BC
	push hl
	ld h, b
	ld l, c
	sra b
	rr c
	sra b
	rr c
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, $0d
	call SetEntityWordField_BC
	call Func_4258
	ld a, b
	call Func_421c
	srl b
	srl b
	jr z, .asm_4193
	ld a, [wda66]
	sub c
	bit 7, a
	jr z, .asm_4182
	cpl
	inc a
.asm_4182
	cp $41
	jr c, .asm_4193
	push de
	push bc
	call Func_2967
	pop bc
	pop de
	ld a, [wda93]
	add b
	jr .asm_4196
.asm_4193
	ld a, [wda93]
.asm_4196
	cp $10
	jr c, .asm_41b4
	cp $30
	jr c, .asm_41a5
	ld a, SFX_2A
	call PlaySFX
	jr .asm_41b4
.asm_41a5
	push hl
	ld hl, .SfxIDs
	call Random
	and $03
	add_hl
	ld a, [hl]
	call PlaySFX
	pop hl
.asm_41b4
	ld a, [wda93]
	ld b, a
	ld c, $00
	srl b
	rr c
	ld a, [wda92]
	call Func_56a2
	ld c, $09
	ld a, [de]
	and $04
	jr nz, .asm_41d3
	ld a, [wda98]
	and a
	jr z, .asm_41e3
	ld c, $07
.asm_41d3
	push de
	ld a, $21
	add_de
	ld a, [de]
	and a
	jr nz, .asm_41e2
	ld a, c
	call Func_42a3
	ld a, $01
	ld [de], a
.asm_41e2
	pop de
.asm_41e3
	call Func_41ec
	pop bc
	ret

.SfxIDs:
	db SFX_28, SFX_29, SFX_2B, SFX_27

Func_41ec:
	ld a, [de]
	and $08
	ret z
	ld a, [wd83a]
	and a
	jr z, .asm_4202
	ld a, [wda93]
	swap a
	and $0f
	ret z
	add a
	add a
	jr .asm_420d
.asm_4202
	ld a, [wda93]
	swap a
	and $0f
	add $02
	add a
	add a
.asm_420d
	ld c, a
	ld a, [wd86c]
	add c
	cp $38
	jr c, .asm_4218
	ld a, $38
.asm_4218
	ld [wd86c], a
	ret

Func_421c:
	push bc
	ld c, a
	ld a, [de]
	and $08
	ld a, c
	pop bc
	jr z, .asm_422f
	swap a
	and $0f
	ret z
	ld a, $01
	jp Func_427c
.asm_422f
	swap a
	and $0f
	ret z
	push bc
	ld c, a
	srl a
	add c
	pop bc
	jp Func_427c
; 0x423d

SECTION "Func_4258", ROMX[$4258], BANK[$1]

Func_4258:
	push hl
	ld h, d
	ld l, e
	ld a, $0e
	call GetEntityByteField_A
	and a
	jr z, .asm_4270
	bit 6, [hl]
	jr z, .asm_4268
	xor a
.asm_4268
	ld b, a
	ld a, $0c
	call GetEntityByteField_C
	pop hl
	ret
.asm_4270
	ld a, $11
	call GetEntityByteField_B
	ld a, $0f
	call GetEntityByteField_C
	pop hl
	ret

Func_427c:
	push hl
	ld hl, wdc32
	bit WDC32_UNK1_F, [hl]
	jr nz, .asm_429e
	ld l, a
	ld a, [wd83b]
	and a
	jr z, .asm_4292
	ld h, a
	ld a, l
.asm_428d
	add l
	dec h
	jr nz, .asm_428d
	ld l, a
.asm_4292
	ld a, l
	ld hl, wd868
	add [hl]
	cp $38
	jr c, .asm_429d
	ld a, $38
.asm_429d
	ld [hl], a
.asm_429e
	pop hl
	ret
; 0x42a0

SECTION "Func_42a3", ROMX[$42a3], BANK[$1]

Func_42a3:
	push hl
	ld hl, wdc32
	bit WDC32_UNK2_F, [hl]
	jr nz, .asm_42b6
	ld hl, wd86a
	add [hl]
	cp $38
	jr c, .asm_42b5
	ld a, $38
.asm_42b5
	ld [hl], a
.asm_42b6
	pop hl
	ret

Func_42b8:
	push hl
	call Func_26cd
	ld a, $0c
	call GetEntityByteField_A
	jr Func_42ce

Func_42c3:
	push hl
	call Func_26cd
	ld a, $0c
	call GetEntityByteField_A
	add $80
Func_42ce:
	ld l, a
	call Random
	ld h, a
	and $03
	bit 7, h
	jr z, .asm_42db
	cpl
	inc a
.asm_42db
	add l
	call Func_613b
	pop hl
	ret
; 0x42e1

SECTION "Func_43be", ROMX[$43be], BANK[$1]

Func_43be::
	ld a, $0e
	call GetEntityByteField_A
	and $80
	jr z, .asm_43cc
	call Func_29e0
	jr .asm_43cf
.asm_43cc
	call Func_29d6
.asm_43cf
	push hl
	ld h, b
	ld l, c
	call Func_4436
	ld c, h
	ld h, d
	ld l, e
	call Func_4436
	ld e, h
	pop hl
	ld b, $00
	bit 7, c
	jr z, .asm_43e4
	dec b
.asm_43e4
	ld d, $00
	bit 7, e
	jr z, .asm_43eb
	dec d
.asm_43eb
	push hl
	ld a, $07
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld bc, -$40
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, $0a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld de, -$50
	add hl, de
	ld d, h
	ld e, l
	bit 7, d
	jr z, .asm_440e
	ld de, $0000
.asm_440e
	ld hl, wd805
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp d
	jr nz, .asm_441a
	ld a, l
	cp e
.asm_441a
	jr nc, .asm_441e
	ld d, h
	ld e, l
.asm_441e
	bit 7, b
	jr z, .asm_4425
	ld bc, $0000
.asm_4425
	ld hl, wd807
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp b
	jr nz, .asm_4431
	ld a, l
	cp c
.asm_4431
	jr nc, .asm_4435
	ld b, h
	ld c, l
.asm_4435
	ret

Func_4436:
	ld a, [wd81f]
	cp $06
	ret z
	push de
	add hl, hl
	add hl, hl
	add hl, hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	pop de
	ret

Func_4446:
	call Func_1598

	ld bc, 0
	ld a, ENT_UNK0D
	call SetEntityWordField_BC
	ld a, ENT_UNK10
	call SetEntityByteField_C
	ld a, ENT_UNK20
	call SetEntityByteField_C

	xor a
	ld [wda8f], a
	ld [wda90], a
	ld [wda91], a
	ld a, $00
	ld [wd83f], a
	ld a, [wd81f]
	cp $06
	jr nz, .asm_4489
	ld a, $01
	ld [wda7b], a
	ld c, $34
	ld a, ENT_UNK15
	call SetEntityByteField_C
	set 3, [hl]
	res 1, [hl]
	ld de, $5c32
	ld a, $01
	jp Func_157f
.asm_4489
	call Func_4626
	call Func_4658
	call Func_45c3
	call Func_4531
	call Func_44dd
	call Func_451e
	call Func_44a8
	call Func_469c
	ld a, 1
	call YieldEntityUpdate
	jr .asm_4489

Func_44a8:
	ld a, [wda8f]
	inc a
	cp $02
	jr nc, .asm_44b4
	ld [wda8f], a
	ret
.asm_44b4
	xor a
	ld [wda8f], a
	ld a, $11
	call GetEntityByteField_A
	cp $08
	jr c, .asm_44c4
	jp Func_42c3
.asm_44c4
	call Func_468a
	ret z
	ld a, $0e
	call GetEntityByteField_A
	cp $10
	ret c
	ld a, $0e
	call GetEntityByteField_A
	bit 7, a
	jp z, Func_42b8
	jp Func_42c3

Func_44dd:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	ret z
	and $20
	jr nz, .asm_44eb
	ld c, $c0
	jr .asm_44ed
.asm_44eb
	ld c, $40
.asm_44ed
	ld a, $0e
	call GetEntityByteField_B
	bit 7, b
	jr z, .asm_44fe
	ld a, b
	cpl
	inc a
	ld b, a
	ld a, c
	cpl
	inc a
	ld c, a
.asm_44fe
	ld a, $0c
	call GetEntityByteField_A
	add c
	ld c, a
	call Func_468a
	jr nz, .asm_4515
	srl b
	srl b
	srl b
	srl b
	jp Func_2967
.asm_4515
	srl b
	srl b
	srl b
	jp Func_2967

Func_451e:
	call Func_468a
	jr nz, .asm_4527
	ld a, $0d
	jr .asm_4529
.asm_4527
	ld a, $0f
.asm_4529
	call Func_490d
	ld a, $10
	jp Func_28bb

Func_4531:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, .asm_456c
	ld c, a
	ld a, ENT_UNK20
	call SetEntityByteField_C
	ld a, $09
	call Func_48ff
	ld b, a
	call Func_4591
	jr c, .asm_456c
.asm_4549
	ld a, c
	and PAD_RIGHT
	jr nz, .asm_455d
	push hl
	ld a, $0c
	add_hl
.asm_4552
	dec [hl]
	ld a, [hl]
	and $0f
	jr z, .asm_455b
	dec b
	jr nz, .asm_4552
.asm_455b
	pop hl
	ret
.asm_455d
	push hl
	ld a, $0c
	add_hl
.asm_4561
	inc [hl]
	ld a, [hl]
	and $0f
	jr z, .asm_456a
	dec b
	jr nz, .asm_4561
.asm_456a
	pop hl
	ret
.asm_456c
	ld a, $0c
	call GetEntityByteField_A
	and $0f
	ret z
	ld a, $20
	call GetEntityByteField_A
	and a
	ret z
	ld c, a
	ld a, $0a
	call Func_48ff
	ld b, a
	call Func_4591
	jr c, .asm_458d
	ld a, b
	and a
	jr z, .asm_458d
	jr .asm_4549
.asm_458d
	ld b, $01
	jr .asm_4549

Func_4591:
	push bc
	ld a, $08
	call Func_48ff
	ld c, a
	call Func_26b8
	jr nc, .asm_45bd
	srl c
	call Func_26b8
	jr c, .asm_45c0
	ld a, c
	srl c
	add a
	ld c, a
	call Func_26b8
	jr nc, .asm_45b3
	pop bc
	srl b
	and a
	ret
.asm_45b3
	pop bc
	srl b
	ld a, b
	srl b
	add a
	ld b, a
	and a
	ret
.asm_45bd
	pop bc
	and a
	ret
.asm_45c0
	pop bc
	scf
	ret

Func_45c3:
	ld a, [wda90]
	and a
	jr z, .asm_45d8
	ld e, a
	ld a, $04
	call Func_48ff
	ld d, a
	call Func_c28
	ld a, $0d
	call AddEntityWordField_DE
.asm_45d8
	ld a, [wda91]
	and a
	jr z, .asm_45f4
	ld e, a
	ld a, $05
	call Func_48ff
	ld d, a
	call Func_c28
	xor a
	sub e
	ld e, a
	ld a, $00
	sbc d
	ld d, a
	ld a, $0d
	call AddEntityWordField_DE
.asm_45f4
	ld a, $0b
	call Func_490d
	call Func_265f
	ld a, $0d
	call GetEntityWordField_BC
	bit 7, b
	jr nz, .asm_4618
	ld a, $06
	call Func_48ff
	cp b
	jr z, .asm_460e
	ret nc
.asm_460e
	ld b, a
	ld c, $00
	jr .asm_4613
.asm_4613
	ld a, $0d
	jp SetEntityWordField_BC
.asm_4618
	ld a, $07
	call Func_48ff
	cp b
	jr z, .asm_4621
	ret c
.asm_4621
	ld b, a
	ld c, $ff
	jr .asm_4613

Func_4626:
	ld a, [wJoypadDown]
	and PAD_A
	jr nz, .asm_463e
	ld a, $01
	call Func_48ff
	ld c, a
	ld a, [wda90]
	sub c
	jr nc, .asm_463a
	xor a
.asm_463a
	ld [wda90], a
	ret
.asm_463e
	ld a, $20
	ld [wda90], a
	ret
; 0x4644

SECTION "Func_4658", ROMX[$4658], BANK[$1]

Func_4658:
	ld a, [wJoypadDown]
	and PAD_B
	jr nz, .asm_4670
	ld a, $03
	call Func_48ff
	ld c, a
	ld a, [wda91]
	sub c
	jr nc, .asm_466c
	xor a
.asm_466c
	ld [wda91], a
	ret
.asm_4670
	ld a, $20
	ld [wda91], a
	ret
; 0x4676

SECTION "Func_468a", ROMX[$468a], BANK[$1]

Func_468a:
	push hl
	ld a, $0e
	add_hl
	bit 7, [hl]
	ld a, PAD_B
	jr z, .asm_4696
	ld a, PAD_A
.asm_4696
	ld hl, wJoypadDown
	and [hl]
	pop hl
	ret

Func_469c:
	call Func_48a1
	call Func_475f
	call Func_4733
	call Func_313e
	jr z, .asm_46d4
	ld a, [wda5d]
	cp $02
	jr nz, .asm_46bf
	call Func_470f
	ld a, [wda98]
	and a
	jr z, .asm_46bf
	ld a, $03
	call Func_42a3
.asm_46bf
	ld bc, rJOYP
	ld a, $10
	call Func_28bb
	ld c, $10
	call Func_26b8
	jr c, .asm_46d4
	ld bc, $100
	call Func_265f
.asm_46d4
	ld a, $10
	call Func_2abe
	jr z, .asm_4708
	call Func_471e
	ld a, [wda93]
	ld b, a
	srl b
	ld a, [wda5d]
	call Func_2747
	add $80
	ld c, a
	call Func_2967
	ld a, $0d
	call GetEntityWordField_BC
	sra b
	rr c
	ld a, $0d
	call SetEntityWordField_BC
	ld a, [wda93]
	swap a
	and $0f
	call nz, Func_427c
.asm_4708
	call Func_3047
	call Func_40f4
	ret

Func_470f:
	call Random
	and $01
	ld a, SFX_27
	jp z, PlaySFX
	ld a, SFX_29
	jp PlaySFX

Func_471e:
	ld a, [wda93]
	cp $10
	ret c
	call Random
	and $01
	ld a, SFX_29
	jp z, PlaySFX
	ld a, SFX_2B
	jp PlaySFX

Func_4733:
	ld a, $0c
	call GetEntityByteField_C
	ld a, $0e
	call GetEntityByteField_B
	bit 7, b
	jr z, .asm_4749
	ld a, b
	cpl
	inc a
	ld b, a
	ld a, c
	add $80
	ld c, a
.asm_4749
	ld a, $0f
	call GetEntityByteField_E
	ld a, $11
	call GetEntityByteField_D
	call Func_28d1
	ld a, c
	ld [wda92], a
	ld a, b
	ld [wda93], a
	ret

Func_475f:
	ld a, [wd83f]
	cp $00
	ret nz
	call .Func_4772
	call .Func_479f
	call .Func_4781
	call .Func_47e9
	ret

.Func_4772:
	ld a, [wda96]
	and a
	jr nz, .asm_477c
	ld [wda95], a
	ret
.asm_477c
	dec a
	ld [wda96], a
	ret

.Func_4781:
	ld a, [wda97]
	and a
	jr z, .asm_4799
	ld a, [wda99]
	and a
	jr z, .asm_4793
	call .Func_483b
	jp .Func_4829
.asm_4793
	call .Func_4830
	jp .Func_4834
.asm_4799
	call .Func_4830
	jp .Func_483b

.Func_479f:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, .asm_47c3
	ld a, $11
	call GetEntityByteField_A
	cp $08
	jr c, .asm_47c3
	cp $14
	jr c, .asm_47bc
	call Func_468a
	jr z, .asm_47bc
	call .Func_4855
	ret
.asm_47bc
	call .Func_485c
	call .Func_484a
	ret
.asm_47c3
	call Func_468a
	jr z, .asm_47df
	ld a, $0e
	call GetEntityByteField_A
	cp $10
	jr c, .asm_47df
	cp $20
	jr nc, .asm_47bc
	call .Func_485c
	call .Func_4851
	call .Func_483f
	ret
.asm_47df
	call .Func_4846
	call .Func_4851
	call .Func_485c
	ret

.Func_47e9:
	ld a, [wda95]
	and a
	ret nz
	ld a, $0e
	call GetEntityByteField_A
	bit 7, a
	jr z, .asm_47f9
	cpl
	inc a
.asm_47f9
	rrca
	rrca
	and $0f
	cp $0d
	jr c, .asm_480f
	call Random
	and $01
	ld a, $0c
	jr z, .asm_480f
	ld a, SFX_22
	ld c, a
	jr .asm_4812
.asm_480f
	add $0d
	ld c, a
.asm_4812
	ld a, [wda94]
	cp c
	ret z
	call .Func_489c
	ld a, c
	ld [wda94], a
	call PlaySFX
	xor a
	ld [wda95], a
	ld [wda96], a
	ret

.Func_4829:
	ld a, SFX_24
	lb bc, $01, $08
	jr .asm_4860
.Func_4830:
	ld a, $24
	jr .asm_4885
.Func_4834:
	ld a, SFX_25
	lb bc, $01, $08
	jr .asm_4860
.Func_483b:
	ld a, $25
	jr .asm_4885
.Func_483f:
	ld a, SFX_1A
	lb bc, $02, $07
	jr .asm_4860
.Func_4846:
	ld a, $1a
	jr .asm_4885
.Func_484a:
	ld a, SFX_1B
	lb bc, $03, $0a
	jr .asm_4860
.Func_4851:
	ld a, $1b
	jr .asm_4885
.Func_4855:
	ld a, SFX_1C
	lb bc, $04, $1e
	jr .asm_4860
.Func_485c:
	ld a, $1c
	jr .asm_4885
.asm_4860
	ld e, a
	ld a, [wda95]
	cp b
	jr c, .asm_486f
	jr z, .asm_486a
	ret
.asm_486a
	ld a, [wda94]
	cp e
	ret z
.asm_486f
	ld a, [wda94]
	call .Func_489c
	ld a, e
	ld [wda94], a
	call PlaySFX
	ld a, b
	ld [wda95], a
	ld a, c
	ld [wda96], a
	ret
.asm_4885
	and a
	ret z
	push hl
	ld hl, wda94
	cp [hl]
	pop hl
	ret nz
	call Func_f0c
	xor a
	ld [wda94], a
	ld [wda95], a
	ld [wda96], a
	ret

.Func_489c:
	and a
	ret z
	jp Func_f0c

Func_48a1:
	xor a
	ld [wda97], a
	ld [wda98], a
	ld [wda99], a
	ld de, wd8eb
	ld b, $08
.asm_48b0
	ld a, [de]
	and $05
	cp $05
	call z, Func_48bf
	ld a, $27
	add_de
	dec b
	jr nz, .asm_48b0
	ret

Func_48bf:
	push de
	ld a, $01
	add_de
	ld a, [de]
	pop de
	cp $01
	ret nz
	push bc
	call Func_48e6
	call Func_48d1
	pop bc
	ret

Func_48d1:
	ld a, [de]
	and $80
	jr nz, .asm_48de
	push de
	ld a, $22
	add_de
	ld a, [de]
	pop de
	and a
	ret z
.asm_48de
	ld a, [wda98]
	inc a
	ld [wda98], a
	ret

Func_48e6:
	ld a, [de]
	and $80
	ret z
	ld a, [wda97]
	inc a
	ld [wda97], a
	push hl
	ld h, d
	ld l, e
	call Func_270f
	pop hl
	ret nz
	ld a, $01
	ld [wda99], a
	ret

Func_48ff:
	push hl
	push af
	ld a, [wd826]
	ld hl, $491d
	get_pointer
	pop af
	add_hl
	ld a, [hl]
	pop hl
	ret

Func_490d:
	push hl
	push af
	ld a, [wd826]
	ld hl, $491d
	get_pointer
	pop af
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ret
; 0x491d

SECTION "Func_5471", ROMX[$5471], BANK[$1]

Func_5471::
	ld hl, wda9c
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret
; 0x5479

SECTION "Func_56a2", ROMX[$56a2], BANK[$1]

Func_56a2:
	push hl
	ld h, d
	ld l, e
	call Func_289f
	pop hl
	push de
	ld a, $0c
	add_de
	ld a, [de]
	ld c, a
	pop de
	ld a, [wda59]
	call Func_2747
	sub c
	cp $80
	ld c, $01
	jr c, .asm_56bf
	ld c, $ff
.asm_56bf
	push de
	ld a, $20
	add_de
	ld a, c
	ld [de], a
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	ld a, $23
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $56db
	ld a, $01
	call Func_1569
	pop hl
	pop de
	ret
; 0x56db

SECTION "Func_613b", ROMX[$613b], BANK[$1]

Func_613b:
	push af
	ld hl, -$4
	add hl, bc
	ld b, h
	ld c, l
	ld hl, -$4
	add hl, de
	ld d, h
	ld e, l
	push bc
	push de
	ld hl, $6186
	ld c, $01
	ld b, $09
	call SpawnEntity
	jr c, .asm_6182
	call Func_1124
	jr c, .asm_6180
	ld a, $06
	call SetEntityWordField_DE
	ld h, d
	ld l, e
	pop de
	pop bc
	set 2, [hl]
	inc hl
	ld [hl], $00
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], $00
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld [hl], $10
	inc hl
	ld [hl], $08
	ld a, $05
	add_hl
	pop af
	ld [hli], a
	ret
.asm_6180
	ld [hl], $00
.asm_6182
	pop de
	pop bc
	pop af
	ret
; 0x6186

SECTION "Func_642c", ROMX[$642c], BANK[$1]

Func_642c::
	ld a, [wd820]
	cp $01
	ret nz
	ld a, [wd868]
	cp $38
	ret c
	ld a, $0b
	call FindEntity
	ld de, $6446
	ld a, $01
	call Func_1569
	ret
; 0x6446

SECTION "Func_6563", ROMX[$6563], BANK[$1]

Func_6563:
	xor a
	ld [wda76], a
	ld [wd86e], a
	ld a, $02
	ld [wd820], a
	call Func_6575
	jp Func_68b8

Func_6575:
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $23
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $408f
	ld a, $01
	call Func_1569
	ld a, $01
	ld [wd83f], a
	ret

Func_658f:
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $23
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Func_4446
	ld a, $01
	call Func_1569
	ld a, $00
	ld [wd83f], a
	ret
; 0x65a9

SECTION "Func_67dd", ROMX[$67dd], BANK[$1]

Func_67dd:
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wd8e5]
	and a
	jr nz, .loop
	ret

Func_67e9:
.loop
	ld a, $01
	call YieldEntityUpdate
	ld a, [wd83f]
	cp 2
	jr nz, .loop
	ret

Func_67f6:
	ld de, wda76
	ld a, $01
	ld [de], a
	ld b, $04
.asm_67fe
	inc de
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .asm_67fe
	ret

Func_6805:
	call Func_6889
	ld a, $0c
	cp c
	ret c
	cp b
	ret c
	call Func_2daf
	ld c, a
	ld a, $0c
	cp c
	ret

Func_6816:
	xor a
	ld [wd837], a
	ld hl, wda9a
	ld a, [hl]
	and a
	jr z, .asm_6822
	dec [hl]
.asm_6822
	call Func_6889
	ld a, $40
	cp c
	jr c, .asm_684d
	cp b
	jr c, .asm_684d
	ld a, $01
	ld [wd837], a
	call Func_2daf
	ld c, a
	ld a, $40
	cp c
	ret c
	push bc
	call Func_685a
	pop bc
	ld a, $0c
	cp c
	ret c
	ld a, [wda97]
	and a
	jr nz, .asm_684b
	and a
	ret
.asm_684b
	scf
	ret
.asm_684d
	ld a, $fe
	cp c
	ret c
	cp b
	ret c
	ld a, $01
	ld [wd837], a
	jr .asm_684b

Func_685a:
	ld a, [wda97]
	and a
	ret z
	ld a, [wd8e5]
	and a
	ret nz
	ld hl, wda9a
	ld a, [hl]
	and a
	ret nz
	ld a, $20
	call PlaySFX
	ld [hl], $b4
	ld hl, $5366
	ld c, $3c
	jp Func_1ec0

Func_6879:
	call Func_68b8
	xor a
	ld [wda76], a
	ld [wd86e], a
	call Func_6575
	jp Func_67e9

Func_6889:
	ld hl, wda77
	ld de, wda2d
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wda2a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wda23
	jp Func_27e5

Func_68a8:
	ld a, $01
	ld c, [hl]
	inc hl
	ld b, [hl]
	jp Func_1bd3

Func_68b0:
	ld a, $02
	lb bc, 0, 0
	jp Func_1bd3

Func_68b8:
	ld hl, NULL
	call Func_1eda
	ld a, $01
	ld [wd838], a
	ld [wd837], a
	ret

Func_68c7:
	push hl
	call Func_6563
	ld a, $08
	call PlayMusic
	pop hl
	ld c, $5a
	ld a, h
	or l
	jr z, .asm_68e1
	ld c, $2d
	call Func_1ec0
	call Func_67dd
	ld c, $2d
.asm_68e1
	ld hl, $5569
	call Func_1ec0
	ld a, $01
	ld [wTitlescreenTransition], a
	ld de, $64e2
	ld a, $01
	jp Func_157f

Func_68f4:
	ld a, $02
	ld [wd820], a
	ld a, $05
	call PlayMusic
	ld c, $5a
	ld a, h
	or l
	jr z, .asm_690e
	ld c, $2d
	call Func_1ec0
	call Func_67dd
	ld c, $2d
.asm_690e
	ld hl, $55c5
	call Func_1ec0
	ld a, $02
	ld [wTitlescreenTransition], a
	ld de, $64e2
	ld a, $01
	jp Func_157f

Func_6921::
	ld hl, Data_6949
	jr Func_692b
	ld hl, Data_6967
	jr Func_692b ; useless jump

Func_692b:
	ld d, h
	ld e, l
.asm_692d
	ld a, [wMission]
	cp NUM_MISSIONS
	jr c, .valid_mission
	xor a ; MISSION_THE_BANK_JOB
	ld [wMission], a
.valid_mission
	add a ; *2
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .null
	jp hl
.null
	ld hl, wMission
	inc [hl]
	ld h, d
	ld l, e
	jr .asm_692d

Data_6949:
	dw Func_6985 ; MISSION_THE_BANK_JOB
	dw $6a6a ; MISSION_HIDE_THE_EVIDENCE
	dw $6ad5 ; MISSION_BOAT_CHASE
	dw $6e49 ; MISSION_RAM_RAID_RACE
	dw $6f05 ; MISSION_SUPERFLY_DRIVE
	dw $6f7b ; MISSION_BAIT_FOR_A_TRAP
	dw $711a ; MISSION_TAKE_OUT_DIANGELO
	dw $71d2 ; MISSION_STEAL_A_COP_CAR
	dw $725e ; MISSION_GET_LUCKY_TO_THE_DOCS
	dw $7331 ; MISSION_BEVERLY_HILLS_GET_AWAY
	dw $7460 ; MISSION_GRAND_CENTRAL_STATION
	dw $764a ; MISSION_TRASH_GRANGERS_WHEELS
	dw $775c ; MISSION_STOP_GRANGERS_GANG
	dw $7875 ; MISSION_CHASE_ONE_OF_GRANGERS_BOYS
	dw $796b ; MISSION_CROSS_TOWN_RECORD

Data_6967:
	dw $6997 ; MISSION_THE_BANK_JOB
	dw $6a83 ; MISSION_HIDE_THE_EVIDENCE
	dw $6ae7 ; MISSION_BOAT_CHASE
	dw $6e5b ; MISSION_RAM_RAID_RACE
	dw $6f1e ; MISSION_SUPERFLY_DRIVE
	dw $6f8d ; MISSION_BAIT_FOR_A_TRAP
	dw $712c ; MISSION_TAKE_OUT_DIANGELO
	dw $71eb ; MISSION_STEAL_A_COP_CAR
	dw $7277 ; MISSION_GET_LUCKY_TO_THE_DOCS
	dw $7343 ; MISSION_BEVERLY_HILLS_GET_AWAY
	dw $7475 ; MISSION_GRAND_CENTRAL_STATION
	dw $765c ; MISSION_TRASH_GRANGERS_WHEELS
	dw $776e ; MISSION_STOP_GRANGERS_GANG
	dw $788e ; MISSION_CHASE_ONE_OF_GRANGERS_BOYS
	dw $7984 ; MISSION_CROSS_TOWN_RECORD

Func_6985:
	call Func_1972
	ld a, $00
	call Func_1a1d
	call Func_1a12
	ld hl, $7eb2
	call Func_1a2e
	ret

Func_6997:
	call Func_1ed4
	ld hl, NULL
	call Func_1eda
	call LoadPersonGfx
	ld hl, $69ae
	ld c, $01
	ld b, $0b
	call SpawnEntity
	ret

Func_69ae:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, $5625
	ld c, $5a
	call Func_1ec0
	call Func_67dd
	ld a, $01
	ld [wd820], a
	ld hl, $7eb7
	call Func_67f6
	ld hl, $7ec7
	call Func_68a8
.asm_69cd
	ld a, $01
	call YieldEntityUpdate
	ld a, [wd86e]
	and a
	jp z, Func_6a32
	call Func_6805
	jr nc, .asm_69e0
	jr .asm_69cd
.asm_69e0
	xor a
	ld [wda76], a
	ld [wd86e], a
	call Func_6575
	call Func_67e9
	ld hl, $7ebb
	call Func_6a38
	ld hl, $5680
	ld c, $5a
	call Func_1ec0
	call Func_67dd
	call Func_658f
	call Func_68b0
	ld hl, $7ebf
	call Func_67f6
	ld a, $0e
	call Func_42a3
	ld hl, $1f37
	call Func_1eda
	xor a
	ld [wda9a], a
.asm_6a19
	ld a, $01
	call YieldEntityUpdate
	call Func_6816
	jr c, .asm_6a19
	call Func_6879
	ld hl, $7ec3
	call Func_6a51
	ld hl, NULL
	jp Func_68f4

Func_6a32:
	ld hl, $5526
	jp Func_68c7

Func_6a38:
	ld b, $03
.asm_6a3a
	push bc
	push hl
	call Func_79e5
	pop hl
	pop bc
	call Random
	and $0f
	add $18
	call YieldEntityUpdate
	dec b
	jr nz, .asm_6a3a
	jp Func_79d8

Func_6a51:
	ld b, $03
.asm_6a53
	push bc
	push hl
	call Func_7a0c
	pop hl
	pop bc
	call Random
	and $0f
	add $18
	call YieldEntityUpdate
	dec b
	jr nz, .asm_6a53
	jp Func_79d8
; 0x6a6a

SECTION "Data_79d8", ROMX[$79d8], BANK[$1]

Func_79d8:
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, $0e
	call FindEntity
	ret nc
	jr .loop

Func_79e5:
	ld b, $04
	ld de, wdc7a
.asm_79ea
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_79ea
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_26cd
	ld a, c
	ld [wdc7e], a
	ld a, b
	ld [wdc7f], a
	ld a, e
	ld [wdc80], a
	ld a, d
	ld [wdc81], a
	jp Func_7a35

Func_7a0c:
	push hl
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_26cd
	ld a, c
	ld [wdc7a + 0], a
	ld a, b
	ld [wdc7a + 1], a
	ld a, e
	ld [wdc7c], a
	ld a, d
	ld [wdc7d], a
	pop hl
	ld b, $04
	ld de, wdc7e
.asm_7a2c
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_7a2c
	jp Func_7a35

Func_7a35:
	call Func_1124
	ret c
	push de
	ld hl, $7a94
	ld c, $01
	ld b, $0e
	call SpawnEntity
	pop de
	ret c
	ld a, $06
	call SetEntityWordField_DE
	inc de
	xor a
	ld [de], a
	inc de
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -$4
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	xor a
	ld [de], a
	inc de
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -$4
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld a, $10
	ld [de], a
	inc de
	ld a, $08
	ld [de], a
	ld a, $05
	add_de
	ld hl, wdc80
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld hl, wdc7e
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ret
; 0x7a94

SECTION "Data_7bb9", ROMX[$7bb9], BANK[$1]

LoadPersonGfx:
	ld a, $01
	vramswitch
	ld de, v0Tiles1 tile $48
	ld hl, PersonGfx
	ld c, BANK(PersonGfx)
	ld b, 8 ; tiles
	xor a
	call CopyTilesWithAlternatingBlackTiles
	ld a, $00
	vramswitch
	ret
; 0x7bd4

SECTION "Data_7c48", ROMX[$7c48], BANK[$1]

Data_7c48::
	dw $7c4e ; MIAMI
	dw $7c89 ; LOS_ANGELES
	dw $7cc4 ; NEW_YORK
; 0x7c4e

SECTION "CheckSkipCompanies", ROMX[$7cff], BANK[$1]

; whether to skip showing the initial companies screens
; always returns z
CheckSkipCompanies::
	ld a, [.Value]
	and a
	ret

.Value:
	db FALSE
; 0x7d05

SECTION "Data_7e88", ROMX[$7e88], BANK[$1]

Data_7e88::
	dw $7e8e ; MIAMI
	dw $7e93 ; LOS_ANGELES
	dw $7e98 ; NEW_YORK
; 0x7e8e
