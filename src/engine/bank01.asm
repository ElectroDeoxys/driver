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
	ld hl, wPlayerCar
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
	call SetStructWord_DE

	; swap hl and de
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, ENT_UNK23
	call SetStructWord_DE

	call Func_1124
	ld a, ENT_UNK25
	call SetStructWord_DE

	jp Func_3047
; 0x4057

SECTION "Func_4066", ROMX[$4066], BANK[$1]

Func_4066:
	call Func_1598
	xor a
	ld [wda94], a
	ld [wda95], a
	ld [wda96], a
	ld a, [wGameMode]
	cp MODE_CREDITS
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
	call GetStructWord_BC
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
	ld a, ENT_UNK0D
	call SetStructWord_BC
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
	ld a, ENT_UNK0E
	call GetStructByte_A
	and a
	jr z, .asm_4270
	bit 6, [hl]
	jr z, .asm_4268
	xor a
.asm_4268
	ld b, a
	ld a, ENT_UNK0C
	call GetStructByte_C
	pop hl
	ret
.asm_4270
	ld a, ENT_UNK11
	call GetStructByte_B
	ld a, ENT_UNK0F
	call GetStructByte_C
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
	ld a, ENT_UNK0C
	call GetStructByte_A
	jr Func_42ce

Func_42c3:
	push hl
	call Func_26cd
	ld a, ENT_UNK0C
	call GetStructByte_A
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

Func_42e1::
.asm_42e1
	call Func_4382
	ld a, [wd809]
	cp $08
	jr nc, .asm_42fc
	ld a, [wd80a]
	cp $08
	jr nc, .asm_42fc
.asm_42f2
	ld a, 1
	call YieldEntityUpdate
	jr .asm_42e1
.asm_42f9
	call Func_4382
.asm_42fc
	call Func_1598
	call Func_284b
	bit 7, b
	jr z, .asm_4309
	xor a
	sub b
	ld b, a
.asm_4309
	inc b
	bit 7, d
	jr z, .asm_4311
	xor a
	sub d
	ld d, a
.asm_4311
	inc d
	ld c, d
	ld hl, wd809
	ld a, [hli]
	cp b
	jr nc, .asm_431e
	ld a, [hl]
	cp c
	jr c, .asm_42f2
.asm_431e
	ld a, [wd809]
	and a
	jr z, .asm_434c
	cp b
	jr nc, .asm_4328
	ld b, a
.asm_4328
	ld hl, wd7f9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd7fd]
	ld e, a
	ld a, [wd7fe]
	ld d, a
	call SubtractDEFromHL
	bit 7, h
	ld h, d
	ld l, e
	ld a, b
	jr z, .asm_4343
	sub_hl
	jr .asm_4344
.asm_4343
	add_hl
.asm_4344
	ld a, l
	ld [wd7f9], a
	ld a, h
	ld [wd7fa], a
.asm_434c
	ld a, [wd80a]
	and a
	jr z, .asm_437a
	cp c
	jr nc, .asm_4356
	ld c, a
.asm_4356
	ld hl, wd7fb
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd7ff]
	ld e, a
	ld a, [wd800]
	ld d, a
	call SubtractDEFromHL
	bit 7, h
	ld h, d
	ld l, e
	ld a, c
	jr z, .asm_4371
	sub_hl
	jr .asm_4372
.asm_4371
	add_hl
.asm_4372
	ld a, l
	ld [wd7fb], a
	ld a, h
	ld [wd7fc], a
.asm_437a
	ld a, 1
	call YieldEntityUpdate
	jp .asm_42f9

Func_4382:
	call Func_43bb
	ld hl, wd7fd
	call Func_43ac
	ld a, l
	ld [wd809], a
	ld a, c
	ld [wd7f9], a
	ld a, b
	ld [wd7fa], a
	ld b, d
	ld c, e
	ld hl, wd7ff
	call Func_43ac
	ld a, l
	ld [wd80a], a
	ld a, c
	ld [wd7fb], a
	ld a, b
	ld [wd7fc], a
	ret

Func_43ac:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_767
	call Func_74d
	ld a, h
	and a
	ret z
	ld l, $7f
	ret

Func_43bb:
	call Func_1598
Func_43be::
	ld a, ENT_UNK0E
	call GetStructByte_A
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
	ld a, [wGameMode]
	cp MODE_CREDITS
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
	call SetStructWord_BC
	ld a, ENT_UNK10
	call SetStructByte_C
	ld a, ENT_UNK20
	call SetStructByte_C

	xor a
	ld [wda8f], a
	ld [wda90], a
	ld [wda91], a
	ld a, $00
	ld [wd83f], a
	ld a, [wGameMode]
	cp MODE_CREDITS
	jr nz, .asm_4489
	ld a, $01
	ld [wda7b], a
	ld c, $34
	ld a, ENT_UNK15
	call SetStructByte_C
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
	ld a, ENT_UNK11
	call GetStructByte_A
	cp $08
	jr c, .asm_44c4
	jp Func_42c3
.asm_44c4
	call Func_468a
	ret z
	ld a, ENT_UNK0E
	call GetStructByte_A
	cp $10
	ret c
	ld a, ENT_UNK0E
	call GetStructByte_A
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
	ld a, ENT_UNK0E
	call GetStructByte_B
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
	ld a, ENT_UNK0C
	call GetStructByte_A
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
	ld a, CARSTRUCT_D
	jr .asm_4529
.asm_4527
	ld a, CARSTRUCT_F
.asm_4529
	call GetPlayerCarData_Word
	ld a, $10
	jp Func_28bb

Func_4531:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, .asm_456c
	ld c, a
	ld a, ENT_UNK20
	call SetStructByte_C
	ld a, CARSTRUCT_9
	call GetPlayerCarData_Byte
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
	ld a, ENT_UNK0C
	call GetStructByte_A
	and $0f
	ret z
	ld a, ENT_UNK20
	call GetStructByte_A
	and a
	ret z
	ld c, a
	ld a, CARSTRUCT_A
	call GetPlayerCarData_Byte
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
	ld a, CARSTRUCT_8
	call GetPlayerCarData_Byte
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
	ld a, CARSTRUCT_4
	call GetPlayerCarData_Byte
	ld d, a
	call DTimesE
	ld a, $0d
	call AddStructWord_DE
.asm_45d8
	ld a, [wda91]
	and a
	jr z, .asm_45f4
	ld e, a
	ld a, CARSTRUCT_5
	call GetPlayerCarData_Byte
	ld d, a
	call DTimesE
	xor a
	sub e
	ld e, a
	ld a, $00
	sbc d
	ld d, a
	ld a, $0d
	call AddStructWord_DE
.asm_45f4
	ld a, CARSTRUCT_B
	call GetPlayerCarData_Word
	call Func_265f
	ld a, $0d
	call GetStructWord_BC
	bit 7, b
	jr nz, .asm_4618
	ld a, CARSTRUCT_6
	call GetPlayerCarData_Byte
	cp b
	jr z, .asm_460e
	ret nc
.asm_460e
	ld b, a
	ld c, $00
	jr .asm_4613 ; useless jump
.asm_4613
	ld a, ENT_UNK0D
	jp SetStructWord_BC
.asm_4618
	ld a, CARSTRUCT_7
	call GetPlayerCarData_Byte
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
	ld a, CARSTRUCT_1
	call GetPlayerCarData_Byte
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
	ld a, CARSTRUCT_3
	call GetPlayerCarData_Byte
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
	call GetStructWord_BC
	sra b
	rr c
	ld a, ENT_UNK0D
	call SetStructWord_BC
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
	ld a, ENT_UNK0C
	call GetStructByte_C
	ld a, ENT_UNK0E
	call GetStructByte_B
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
	ld a, ENT_UNK0F
	call GetStructByte_E
	ld a, ENT_UNK11
	call GetStructByte_D
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
	ld a, ENT_UNK11
	call GetStructByte_A
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
	ld a, ENT_UNK0E
	call GetStructByte_A
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
	ld a, ENT_UNK0E
	call GetStructByte_A
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

GetPlayerCarData_Byte:
	push hl
	push af
	ld a, [wPlayerCar]
	ld hl, Data_491d
	get_pointer
	pop af
	add_hl
	ld a, [hl]
	pop hl
	ret

GetPlayerCarData_Word:
	push hl
	push af
	ld a, [wPlayerCar]
	ld hl, Data_491d
	get_pointer
	pop af
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ret

Data_491d:
	dw .Data_4933 ; CAR_00
	dw .Data_4977 ; CAR_01
	dw .Data_4933 ; CAR_02
	dw .Data_4933 ; CAR_03
	dw .Data_4933 ; CAR_04
	dw .Data_4933 ; CAR_05
	dw .Data_4944 ; CAR_06
	dw .Data_4955 ; CAR_07
	dw .Data_4966 ; CAR_08
	dw .Data_4933 ; CAR_09
	dw .Data_4933 ; CAR_10

.Data_4933:
	db $04 ; CARSTRUCT_0
	db $08 ; CARSTRUCT_1
	db $04 ; CARSTRUCT_2
	db $08 ; CARSTRUCT_3
	db $09 ; CARSTRUCT_4
	db $09 ; CARSTRUCT_5
	db $34 ; CARSTRUCT_6
	db $e0 ; CARSTRUCT_7
	db $14 ; CARSTRUCT_8
	db $04 ; CARSTRUCT_9
	db $02 ; CARSTRUCT_A
	db $80, $00 ; CARSTRUCT_B
	db $00, $ff ; CARSTRUCT_D
	db $28, $fd ; CARSTRUCT_F

.Data_4944:
	db $04 ; CARSTRUCT_0
	db $08 ; CARSTRUCT_1
	db $04 ; CARSTRUCT_2
	db $08 ; CARSTRUCT_3
	db $0a ; CARSTRUCT_4
	db $0a ; CARSTRUCT_5
	db $38 ; CARSTRUCT_6
	db $dc ; CARSTRUCT_7
	db $12 ; CARSTRUCT_8
	db $04 ; CARSTRUCT_9
	db $02 ; CARSTRUCT_A
	db $80, $00 ; CARSTRUCT_B
	db $00, $ff ; CARSTRUCT_D
	db $28, $fd ; CARSTRUCT_F

.Data_4955:
	db $04 ; CARSTRUCT_0
	db $08 ; CARSTRUCT_1
	db $04 ; CARSTRUCT_2
	db $08 ; CARSTRUCT_3
	db $09 ; CARSTRUCT_4
	db $09 ; CARSTRUCT_5
	db $38 ; CARSTRUCT_6
	db $dc ; CARSTRUCT_7
	db $14 ; CARSTRUCT_8
	db $04 ; CARSTRUCT_9
	db $02 ; CARSTRUCT_A
	db $80, $00 ; CARSTRUCT_B
	db $00, $ff ; CARSTRUCT_D
	db $28, $fd ; CARSTRUCT_F

.Data_4966:
	db $04 ; CARSTRUCT_0
	db $08 ; CARSTRUCT_1
	db $04 ; CARSTRUCT_2
	db $08 ; CARSTRUCT_3
	db $08 ; CARSTRUCT_4
	db $08 ; CARSTRUCT_5
	db $3a ; CARSTRUCT_6
	db $e0 ; CARSTRUCT_7
	db $14 ; CARSTRUCT_8
	db $03 ; CARSTRUCT_9
	db $02 ; CARSTRUCT_A
	db $90, $00 ; CARSTRUCT_B
	db $38, $ff ; CARSTRUCT_D
	db $28, $fd ; CARSTRUCT_F

.Data_4977:
	db $04 ; CARSTRUCT_0
	db $08 ; CARSTRUCT_1
	db $04 ; CARSTRUCT_2
	db $08 ; CARSTRUCT_3
	db $08 ; CARSTRUCT_4
	db $08 ; CARSTRUCT_5
	db $38 ; CARSTRUCT_6
	db $dc ; CARSTRUCT_7
	db $12 ; CARSTRUCT_8
	db $04 ; CARSTRUCT_9
	db $02 ; CARSTRUCT_A
	db $80, $00 ; CARSTRUCT_B
	db $00, $ff ; CARSTRUCT_D
	db $28, $fd ; CARSTRUCT_F

Func_4988::
	xor a
	ld [wda56], a
	ld [wda55], a
	call Random
	and $03
	ld [wda57], a
.asm_4997
	ld a, [wda56]
	ld hl, wd82d
	cp [hl]
	jr nc, .asm_49bf
	ld a, [wda55]
	ld hl, wd830
	cp [hl]
	jr nc, .asm_49bc
	ld hl, wd832
	ld a, [hl]
	and a
	jr z, .asm_49b3
	dec [hl]
	jr .asm_49bc
.asm_49b3
	ld a, [wd831]
	ld [hl], a
	call Func_49c6
	jr .asm_49bf
.asm_49bc
	call Func_49e3
.asm_49bf
	ld a, 1
	call YieldEntityUpdate
	jr .asm_4997

Func_49c6:
.asm_49c6
	ld hl, $4c0b
	call Func_49fc
	jr z, .asm_49dc
	call Func_4a3d
	jr c, .asm_49dc
	ld hl, wda56
	inc [hl]
	ld hl, wda55
	inc [hl]
	ret
.asm_49dc
	ld a, 1
	call YieldEntityUpdate
	jr .asm_49c6

Func_49e3:
.asm_49e3
	ld hl, $4c0b
	call Func_49fc
	jr z, .asm_49f5
	call Func_4a48
	jr c, .asm_49f5
	ld hl, wda56
	inc [hl]
	ret
.asm_49f5
	ld a, 1
	call YieldEntityUpdate
	jr .asm_49e3

Func_49fc:
	ld a, l
	ld [wdc7a + 0], a
	ld a, h
	ld [wdc7a + 1], a
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, ENT_UNK0E
	call GetStructByte_A
	bit 7, a
	jr z, .asm_4a15
	cpl
	inc a
.asm_4a15
	cp $10
	jr c, .asm_4a38
	call Func_26db
	ld c, a
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_4a29
	ld a, [wda57]
	inc a
	and $03
	ld [wda57], a
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.asm_4a38
	ld hl, $4c2b
	jr .asm_4a29

Func_4a3d:
	call Func_5662
	ret c
	ld b, $05
	ld de, $4bff
	jr Func_4a51
Func_4a48:
	call Func_5605
	ret c
	ld b, $04
	ld de, $4bff
Func_4a51:
	push bc
	push de
	call Func_4a8f
	pop de
	pop bc
	jr c, .asm_4a85
	push hl
	ld h, d
	ld l, e
	ld a, [wdc7a]
	rlca
	rlca
	and $03
	ld c, a
	add a
	add c
	add_hl
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call SpawnEntity
	pop de
	jr c, .asm_4a83
	ld a, ENT_UNK06
	call SetStructWord_DE
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, ENT_UNK23
	call SetStructWord_DE
	and a
	ret
.asm_4a83
	ld h, d
	ld l, e
.asm_4a85
	ld a, $25
	call GetStructWord_DE
	xor a
	ld [hl], a
	ld [de], a
	scf
	ret

Func_4a8f:
	ld b, $08
	ld de, wd8eb
.asm_4a94
	push bc
	ld a, [de]
	and $01
	jr z, .asm_4ab0
	ld a, h
	cp d
	jr nz, .asm_4aa0
	ld a, l
	cp e
.asm_4aa0
	jr z, .asm_4ab0
	call Func_27e5
	ld a, $1f
	cp c
	jr c, .asm_4ab0
	cp b
	jr c, .asm_4ab0
	pop bc
	scf
	ret
.asm_4ab0
	pop bc
	ld a, $27
	add_de
	dec b
	jr nz, .asm_4a94
	and a
	ret
; 0x4ab9

SECTION "Func_5471", ROMX[$5471], BANK[$1]

Func_5471::
	ld hl, wda9c
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret
; 0x5479

SECTION "Func_5605", ROMX[$5605], BANK[$1]

Func_5605:
	push af
	call Random
	and $07
	ld hl, wda87
	add_hl
	ld a, [hl]
	cp $02
	jr z, .asm_5622
	push af
	call Random
	and $03
	ld hl, $563f
	add_hl
	ld h, [hl]
	pop af
	jr .asm_5624
.asm_5622
	ld h, $05
.asm_5624
	ld l, a
	pop af
	call Func_2631
	ret c
	call Func_1124
	jr c, .asm_563c
	ld a, ENT_UNK25
	call SetStructWord_DE
	call Func_3047
	call Func_5643
	and a
	ret
.asm_563c
	ld [hl], $00
	ret
; 0x563f

SECTION "Func_5643", ROMX[$5643], BANK[$1]

Func_5643:
	call Random
	and $07
	ld de, $565a
	add_de
	ld a, [de]
	ld b, a
	ld a, ENT_UNK15
	call SetStructByte_B
	ld a, ENT_UNK0D
	ld c, $00
	jp SetStructWord_BC
; 0x565a

SECTION "Func_5662", ROMX[$5662], BANK[$1]

Func_5662:
	ld l, $01
	ld h, $00
	call Func_2631
	ret c
	set 2, [hl]
	call Func_1124
	jr c, .asm_567e
	ld a, ENT_UNK25
	call SetStructWord_DE
	call Func_3047
	call Func_5643
	and a
	ret
.asm_567e
	ld [hl], $00
	ret
; 0x5681

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

SECTION "Func_5bce", ROMX[$5bce], BANK[$1]

Func_5bce::
	ld a, [hli]
	ld [wdc82], a
	ld a, [hli]
	ld [wdc84], a
	ld a, [hli]
	ld [wdc86], a
	ld a, [hli]
	ld [wdc88], a
	ld a, [hli]
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	push af
	ld a, [wdc82]
	ld l, a
	ld a, [wdc84]
	ld h, a
	pop af
	call Func_2631
	set 3, [hl]
	push hl
	ld hl, $5c32
	ld c, $01
	ld b, $06
	call SpawnEntity
	pop de
	ld a, ENT_UNK06
	call SetStructWord_DE
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, ENT_UNK23
	call SetStructWord_DE
	call Func_1124
	ld a, ENT_UNK25
	call SetStructWord_DE
	call Func_3047
	pop de
	ld a, [wdc88]
	ld b, a
	ld c, $00
	ld a, ENT_UNK0D
	call SetStructWord_BC
	ld a, [wdc86]
	ld c, a
	ld a, ENT_UNK15
	call SetStructByte_C
	ret
; 0x5c32

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
	ld a, ENT_UNK06
	call SetStructWord_DE
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

SECTION "Func_623d", ROMX[$623d], BANK[$1]

Func_623d:
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
	ld hl, $6288
	ld c, $01
	ld b, $10
	call SpawnEntity
	jr c, .asm_6284
	call Func_1124
	jr c, .asm_6282
	ld a, $06
	call SetStructWord_DE
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
.asm_6282
	ld [hl], $00
.asm_6284
	pop de
	pop bc
	pop af
	ret
; 0x6288

SECTION "Func_633f", ROMX[$633f], BANK[$1]

Func_633f:
	push hl
	ld hl, -$4
	add hl, de
	ld d, h
	ld e, l
	ld hl, -$4
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, $08
.asm_634f
	push af
	push bc
	push de
	push hl
	call Func_635e
	pop hl
	pop de
	pop bc
	pop af
	dec a
	jr nz, .asm_634f
	ret

Func_635e:
	push hl
	push bc
	push de
	ld hl, Func_6398
	ld c, BANK(Func_6398)
	ld b, $11
	call SpawnEntity
	jr c, .asm_6394
	call Func_1124
	jr c, .asm_6394
	ld a, $06
	call SetStructWord_DE
	ld h, d
	ld l, e
	inc hl
	xor a
	pop de
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	pop bc
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld [hl], $10
	inc hl
	ld [hl], $08
	ld a, $05
	add_hl
	pop bc
	ld [hl], c
	inc hl
	ld [hl], b
	ret
.asm_6394
	pop de
	pop bc
	pop hl
	ret

Func_6398:
	call Func_1598
	ld a, [hl]
	or $06
	ld [hl], a
	ld a, $0d
	add_hl
	call Random
	ld b, a
	and $1f
	bit 7, b
	jr z, .asm_63ae
	cpl
	inc a
.asm_63ae
	add [hl]
	ld [hli], a
	call Random
	and $07
	add [hl]
	ld [hli], a
	call Random
	and $07
	add $08
	ld [hli], a
	call Random
	and $03
	ld [hl], a
.asm_63c5
	call .Func_63df
	call .Func_6409
	jr c, .asm_63d7
	call .Func_6413
	ld a, $01
	call YieldEntityUpdate
	jr .asm_63c5
.asm_63d7
	call Func_1598
	ld [hl], $00
	jp DespawnEntity

.Func_63df:
	call Func_1598
	ld a, $0d
	add_hl
	ld a, [hli]
	push hl
	call Func_29ea
	pop hl
	ld a, [hl]
	push bc
	ld b, d
	ld c, e
	push af
	call Func_2998
	pop af
	ld d, b
	ld e, c
	pop bc
	call Func_2998
	call Func_1598
	ld a, $01
	push de
	call Func_146c
	pop bc
	ld a, $04
	jp Func_146c

.Func_6409:
	call Func_1598
	ld a, $0f
	add_hl
	ld a, [hli]
	add [hl]
	ld [hl], a
	ret

.Func_6413:
	call Func_1598
	ld a, $10
	add_hl
	ld a, [hl]
	swap a
	rrca
	rrca
	and $03
	add a
	add $c8
	ld c, a
	ld a, $07
	sub_hl
	ld [hl], c
	inc hl
	ld [hl], $0b
	ret
; 0x642c

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

SECTION "Func_64e2", ROMX[$64e2], BANK[$1]

Func_64e2:
.loop
	ld a, [wd83f]
	cp $02
	jr nz, .asm_64ef
	ld a, [wd8e5]
	and a
	jr z, .asm_64f6
.asm_64ef
	ld a, 1
	call YieldEntityUpdate
	jr .loop
.asm_64f6
	call FadeToWhite
	call YieldEntityUpdateUntilFadeEnds
	ld a, $03
	ld [wd820], a
	jp YieldEntityUpdateIndefinitely
; 0x6504

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

Func_65a9::
	call YieldEntityUpdateUntilFadeEnds
	ld a, $01
	ld [wd820], a
	jp YieldEntityUpdateIndefinitely
; 0x65b4

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
	ld a, 1
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

SetMissionFailed:
	push hl
	call Func_6563
	ld a, MUSIC_MISSION_FAILED
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
	ld de, Func_64e2
	ld a, BANK(Func_64e2)
	jp Func_157f

SetMissionSuccess:
	ld a, $02
	ld [wd820], a

	ld a, MUSIC_MISSION_SUCCESS
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
	ld de, Func_64e2
	ld a, BANK(Func_64e2)
	jp Func_157f

Func_6921::
	ld hl, Data_6949
	jr Func_692b
Func_6926::
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
	dw Func_6997 ; MISSION_THE_BANK_JOB
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
	ld a, MIAMI
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
	ld hl, Func_69ae
	ld c, BANK(Func_69ae)
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
	ld a, 1
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
	ld hl, Data_1f37
	call Func_1eda
	xor a
	ld [wda9a], a
.asm_6a19
	ld a, 1
	call YieldEntityUpdate
	call Func_6816
	jr c, .asm_6a19
	call Func_6879
	ld hl, $7ec3
	call Func_6a51
	ld hl, NULL
	jp SetMissionSuccess

Func_6a32:
	ld hl, $5526
	jp SetMissionFailed

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

Func_6a6a:
	call Func_1972
	ld a, MIAMI
	call Func_1a1d
	ld a, CAR_07
	ld [wPlayerCar], a
	ld a, $02
	ld [wd827], a
	ld hl, $7ec9
	call Func_1a2e
	ret

Func_6a83:
	call Func_1ed4
	ld hl, NULL
	call Func_1eda
	ld hl, Func_6a97
	ld c, BANK(Func_6a97)
	ld b, $0b
	call SpawnEntity
	ret

Func_6a97:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, $56ed
	ld c, $5a
	call Func_1ec0
	call Func_67dd
	ld a, $01
	ld [wd820], a
	ld hl, $7ece
	call Func_67f6
	call Func_68b0
	ld a, $0e
	call Func_42a3
	ld hl, Data_1f37
	call Func_1eda
	xor a
	ld [wda9a], a
.asm_6ac2
	ld a, 1
	call YieldEntityUpdate
	call Func_6816
	jr c, .asm_6ac2
	call Func_6879
	ld hl, NULL
	jp SetMissionSuccess

Func_6ad5:
	call Func_1972
	ld a, MIAMI
	call Func_1a1d
	call Func_1a12
	ld hl, $7ed2
	call Func_1a2e
	ret

Func_6ae7:
	call Func_1ed4
	ld hl, Data_1f37
	call Func_1eda
	call Func_7bd4
	xor a
	ld [wda7b], a
	ld hl, Func_6b0c
	ld c, BANK(Func_6b0c)
	ld b, $0b
	call SpawnEntity
	ld hl, Func_6bbb
	ld c, BANK(Func_6bbb)
	ld b, $0f
	call SpawnEntity
	ret

Func_6b0c:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, $6764
	ld c, $5a
	call Func_1ec0
	ld a, $56
	call YieldEntityUpdate
	ld a, $01
	ld [wda7b], a
	ld a, $04
	call YieldEntityUpdate
	ld a, $01
	ld [wd820], a
	ld hl, $7edf
	call Func_68a8
	ld a, $03
	ld [wda76], a
.asm_6b36
	call .Func_6b8a
	ld a, b
	cp $02
	jr nc, .asm_6ba7
	ld a, [wd86e]
	and a
	jr z, .asm_6ba7
	call .Func_6b73
	jr c, .asm_6b50
	ld a, $01
	call YieldEntityUpdate
	jr .asm_6b36
.asm_6b50
	ld hl, $7edb
	call Func_67f6
	xor a
	ld [wda9a], a
.asm_6b5a
	ld a, $01
	call YieldEntityUpdate
	ld a, [wd86e]
	and a
	jr z, .asm_6bad
	call Func_6816
	jr c, .asm_6b5a
	call Func_6879
	ld hl, NULL
	jp SetMissionSuccess

.Func_6b73:
	ld hl, $6bb3
	ld de, wdc7a
	ld b, $08
	call CopyHLtoDE
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_26cd
	jp Func_bdd

.Func_6b8a:
	ld hl, wda7f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	add_hl
	ld de, wda29
	ld b, $06
	call CopyHLtoDE
	ld hl, wda4a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wda23
	jp Func_275f
.asm_6ba7
	ld hl, $54cc
	jp SetMissionFailed
.asm_6bad
	ld hl, $5526
	jp SetMissionFailed
; 0x6bb3

SECTION "Data_6bbb", ROMX[$6bbb], BANK[$1]

Func_6bbb:
	call Func_1591
	call Func_1124
	ld a, e
	ld [wda7f], a
	ld a, d
	ld [wda80], a
	ld a, $06
	call SetStructWord_DE
	ld h, d
	ld l, e
	push hl
	ld hl, $7ed7
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push hl
	ld a, [hl]
	or $06
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld a, $10
	ld [hli], a
	ld [hl], a
	pop hl
	xor a
	ld [wda7d], a
	ld a, $00
	ld [wda7c], a
	call .Func_6d55
	call Func_1598
	ld a, $02
	add_hl
.asm_6c0f
	ld a, $0e
	call .Func_6c33
	inc [hl]
	ld a, $08
	call .Func_6c33
	inc [hl]
	ld a, $0e
	call .Func_6c33
	dec [hl]
	ld a, $08
	call .Func_6c33
	dec [hl]
	call Random
	and $1f
	add $20
	call .Func_6c33
	jr .asm_6c0f

.Func_6c33:
	ld b, a
.asm_6c34
	ld a, $01
	call YieldEntityUpdate
	ld a, [wda7b]
	and a
	jr nz, .asm_6c43
	dec b
	jr nz, .asm_6c34
	ret
.asm_6c43
	pop hl
	ld a, $08
	ld [wda7d], a
	ld a, $ff
	ld [wda7e], a
.asm_6c4e
	ld hl, wda7e
	inc [hl]
	call .Func_6d2d
	jr z, .asm_6c72
.asm_6c57
	ld a, $01
	call YieldEntityUpdate
	call .Func_6d24
	call .Func_6cff
	jr nc, .asm_6c4e
	call Func_2d66
	call .Func_6cbd
	call .Func_6c9e
	call .Func_6d55
	jr .asm_6c57
.asm_6c72
	ld a, $40
	ld [wda7c], a
	ld a, $33
	ld [wda7d], a
.asm_6c7c
	call .Func_6c9e
	call .Func_6d55
	ld hl, wda7d
	ld a, [hl]
	and a
	jr z, .asm_6c91
	dec [hl]
	ld a, $01
	call YieldEntityUpdate
	jr .asm_6c7c
.asm_6c91
	xor a
	ld [wda7b], a
	call Func_1598
	ld a, $05
	add_hl
	jp .asm_6c0f

.Func_6c9e:
	ld a, [wda7c]
	call Func_29ea
	call Func_1598
	push de
	ld a, $01
	call .Func_6cb0
	pop bc
	ld a, $04
.Func_6cb0:
	push af
	push hl
	ld a, [wda7d]
	call Func_2998
	pop hl
	pop af
	jp Func_146c

.Func_6cbd:
	ld de, wda7d
	ld c, a
	ld b, $02
	ld hl, wda7c
	sub [hl]
	jr z, .asm_6cf8
	jr c, .asm_6cde
	cp $80
	jr nc, .asm_6ce8
	cp $04
	jr c, .asm_6cf8
.asm_6cd3
	ld a, [hl]
	inc a
	ld [hl], a
	cp c
	jr z, .asm_6cf1
	dec b
	jr nz, .asm_6cd3
	jr .asm_6cf1
.asm_6cde
	cpl
	inc a
	cp $80
	jr nc, .asm_6cd3
	cp $04
	jr c, .asm_6cf8
.asm_6ce8
	ld a, [hl]
	dec a
	ld [hl], a
	cp c
	jr z, .asm_6cf1
	dec b
	jr nz, .asm_6ce8
.asm_6cf1
	ld a, [de]
	cp $28
	ret c
	dec a
	ld [de], a
	ret
.asm_6cf8
	ld a, [de]
	cp $33
	ret nc
	inc a
	ld [de], a
	ret

.Func_6cff:
	ld a, d
	or b
	jr nz, .asm_6d13
	ld b, e
	ld a, $0c
	cp c
	ret c
	cp b
	ret c
	call Func_2daf
	cp $0c
	jr nc, .asm_6d22
	and a
	ret
.asm_6d13
	ld a, d
	or b
	jr z, .asm_6d21
	srl d
	rr e
	srl b
	rr c
	jr .asm_6d13
.asm_6d21
	ld b, e
.asm_6d22
	scf
	ret

.Func_6d24:
	call Func_1598
	call .Func_6da8
	jp Func_7b62

.Func_6d2d:
	call Func_1598
	ld a, $0d
	add_hl
	ld d, h
	ld e, l
	ld hl, $6e03
	ld a, [wda7e]
	add a
	add a
	add_hl
	push hl
	ld a, [hli]
	or [hl]
	pop hl
	ret z
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	xor a
	dec a
	ret

.Func_6d55:
	call Func_1598
	call .Func_6d95
	jr nc, .asm_6d60
	res 1, [hl]
	ret
.asm_6d60
	set 1, [hl]
	ld d, h
	ld e, l
	ld a, $09
	add_de
	ld a, [wda7c]
	add $08
	swap a
	and $0f
	add a
	add a
	ld hl, $6dbb
	add_hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wc57a]
	and $03
	ret nz
	call Func_1598
	call .Func_6da8
	ld a, [wda7c]
	add $80
	jp Func_623d

.Func_6d95:
	push hl
	ld hl, $6dfb
	ld de, wdc7a
	ld b, $08
	call CopyHLtoDE
	pop hl
	call .Func_6da8
	jp Func_bdd

.Func_6da8:
	push hl
	inc hl
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $08
	add_de
	ld a, $08
	add_bc
	pop hl
	ret
; 0x6dbb

SECTION "Data_6e49", ROMX[$6e49], BANK[$1]

Func_6e49:
	call Func_1972
	ld a, $00
	call Func_1a1d
	call Func_1a12
	ld hl, $7ee1
	call Func_1a2e
	ret

Func_6e5b:
	call Func_1ed4
	ld hl, Data_1f37
	call Func_1eda
	call Func_7bfc
	ld hl, Func_6e72
	ld c, BANK(Func_6e72)
	ld b, $0b
	call SpawnEntity
	ret

Func_6e72:
	call YieldEntityUpdateUntilFadeEnds
	xor a
	ld [wda81], a
	inc a
	ld [wda82], a
	call .Func_6ec9
	call Func_67dd
	ld a, $01
	ld [wd820], a
	ld hl, $7eff
	call Func_68a8
.asm_6e8e
	call Func_6edf
	call Func_67f6
.asm_6e94
	ld a, $01
	call YieldEntityUpdate
	ld a, [wd86e]
	and a
	jr z, .asm_6ec3
	call Func_6805
	jr c, .asm_6e94
	ld a, $0b
	call Func_42a3
	call Func_6ee9
	ld hl, wda81
	inc [hl]
	ld a, [hl]
	cp $05
	jr z, .asm_6eba
	call .Func_6ec9
	jr .asm_6e8e
.asm_6eba
	call Func_6879
	ld hl, NULL
	jp SetMissionSuccess
.asm_6ec3
	ld hl, $5526
	jp SetMissionFailed

.Func_6ec9:
	ld a, [wda81]
	ld hl, $6ed5
	get_pointer
	ld c, $5a
	jp Func_1ec0
; 0x6ed5

SECTION "Data_6edf", ROMX[$6edf], BANK[$1]

Func_6edf:
	ld hl, $7ee6
	ld a, [wda81]
	add a
	add a
	add_hl
	ret

Func_6ee9:
	call Func_6edf
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $7efa
	ld a, [wda81]
	add_hl
	ld l, [hl]
	ld h, $14
	call Func_633f
	ld a, SFX_26
	jp PlaySFX
; 0x6f05

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
	ld a, ENT_UNK06
	call SetStructWord_DE
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

SECTION "Data_7b62", ROMX[$7b62], BANK[$1]

Func_7b62:
	xor a
	ld [wda59], a
	ld a, $0d
	add_hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call SubtractDEFromHL
	ld a, h
	or l
	jr z, .asm_7b8b
	bit 7, h
	jr z, .asm_7b86
	ld a, $01
	ld [wda59], a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	jr .asm_7b8b
.asm_7b86
	ld a, $04
	ld [wda59], a
.asm_7b8b
	ld d, h
	ld e, l
	pop hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_767
	ld a, h
	or l
	jr z, .asm_7bb6
	bit 7, h
	jr z, .asm_7bae
	ld a, [wda59]
	or $08
	ld [wda59], a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	jr .asm_7bb6
.asm_7bae
	ld a, [wda59]
	or $02
	ld [wda59], a
.asm_7bb6
	ld b, h
	ld c, l
	ret

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

Func_7bd4:
	ld a, $01
	vramswitch
	ld de, v0Tiles1 tile $48
	ld hl, BoatGfx
	ld c, BANK(BoatGfx)
	ld b, 20 ; tiles
	call SafeCopyFarTiles
	ld de, v0Tiles1 tile $5c
	ld hl, Gfx_d119d
	ld c, BANK(Gfx_d119d)
	ld b, 4 ; tiles
	xor a
	call CopyTilesWithAlternatingBlackTiles
	ld a, $00
	vramswitch
	ret

Func_7bfc:
	ld a, $01
	vramswitch
	ld de, v0Tiles1 tile $48
	ld hl, Gfx_d11dd
	ld c, BANK(Gfx_d11dd)
	ld b, 4 ; tiles
	xor a
	call CopyTilesWithAlternatingBlackTiles
	ld a, $00
	vramswitch
	ret
; 0x7c17

SECTION "Data_7c48", ROMX[$7c48], BANK[$1]

Data_7c48::
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK

.Miami:
	db PROP_5, PROP_B, PROP_0, PROP_7, PROP_2, PROP_3, PROP_A, PROP_C
	dw Pals_f644 ; OB pals
	db $00, $00, $4c, $76, $54, $76, $5c, $76, $64, $76, $6c, $76, $74, $76, $05, $00, $0b, $00, $0b, $40, $0b, $80, $0b, $c0, $00, $00, $07, $00, $02, $00, $03, $00, $0a, $00, $0a, $40, $0a, $80, $0a, $c0, $0c, $00, $0c, $40, $0c, $80, $0c, $c0, $ff

.LosAngeles:
	db PROP_B, PROP_0, PROP_1, PROP_2, PROP_3, PROP_4, PROP_A, PROP_D
	dw Pals_f644 ; OB pals
    db $00, $00, $4c, $76, $54, $76, $5c, $76, $64, $76, $6c, $76, $74, $76, $0b, $00, $0b, $40, $0b, $80, $0b, $c0, $00, $00, $01, $00, $02, $00, $03, $00, $04, $00, $0a, $00, $0a, $40, $0a, $80, $0a, $c0, $0d, $00, $0d, $40, $0d, $80, $0d, $c0, $ff

.NewYork:
	db PROP_1, PROP_7, PROP_0, PROP_2, PROP_3, PROP_A, PROP_C, PROP_D
	dw Pals_f644 ; OB pals
	db $00, $00, $4c, $76, $54, $76, $5c, $76, $64, $76, $6c, $76, $74, $76, $01, $00, $07, $00, $00, $00, $02, $00, $03, $00, $0a, $00, $0a, $40, $0a, $80, $0a, $c0, $0c, $00, $0c, $40, $0c, $80, $0c, $c0, $0d, $00, $0d, $40, $0d, $80, $0d, $c0, $ff

; whether to skip showing the initial companies screens
; always returns z
CheckSkipCompanies::
	ld a, [.Value]
	and a
	ret

.Value:
	db FALSE

Data_7d05::
	dw $7d11, $7d2e ; MIAMI
	dw $7d4b, $7d68 ; LOS_ANGELES
	dw $7d85, $7da2 ; NEW_YORK

	db $34, $0e, $d0, $0e, $00, $60, $0c, $74, $0f, $18, $0b, $08, $0c, $24, $0b, $64, $0f, $64, $0d, $d0, $11, $74, $0e, $d0, $10, $38, $10, $68, $10
; 0x7d2e

SECTION "Data_7e07", ROMX[$7e07], BANK[$1]

Data_7e07::
	dw $7e13, $7e23 ; MIAMI
	dw $7e33, $7e43 ; LOS_ANGELES
	dw $7e53, $7e63 ; NEW_YORK

	db $00, $1e, $b0, $11, $00
	dw $767c ; palette
	db CAR_06 ; car
	db $01, $32, $00, $c0, $00, $1e, $74, $11

	db $30, $0d, $a8, $11, $c0
	dw NULL ; palette
	db CAR_07 ; car
	db $02, $32, $00, $80, $f4, $0c, $84, $11

	db $cc, $08, $32, $0a, $40
	dw NULL ; palette
	db CAR_08 ; car
	db $04, $32, $00, $80, $0c, $09, $54, $0a

	db $0c, $0f, $58, $02, $80
	dw NULL ; palette
	db CAR_07 ; car
	db $00, $32, $00, $80, $0c, $0f, $94, $02

	db $e8, $05, $40, $1c, $40
	dw $767c ; palette
	db CAR_06 ; car
	db $01, $32, $00, $80, $2c, $06, $40, $1c

	db $08, $11, $9c, $0c, $40
	dw NULL ; palette
	db CAR_08 ; car
	db $00, $32, $00, $40, $58, $11, $94, $0c
; 0x7e73

SECTION "Data_7e88", ROMX[$7e88], BANK[$1]

Data_7e88::
	dw $7e8e ; MIAMI
	dw $7e93 ; LOS_ANGELES
	dw $7e98 ; NEW_YORK
; 0x7e8e
