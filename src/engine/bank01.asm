Func_4000::
	xor a
	ld [wDamage], a
	ld [wFelony], a

	ld a, $00
	ld [wd83f], a

	ld a, [wPlayerCarSpawnX + 0]
	ld c, a
	ld a, [wPlayerCarSpawnX + 1]
	ld b, a
	ld a, [wPlayerCarSpawnY + 0]
	ld e, a
	ld a, [wPlayerCarSpawnY + 1]
	ld d, a
	ld hl, wPlayerCar
	ld a, [hli]
	ld h, [hl] ; wPlayerCarOBPal
	ld l, a
	ld a, [wPlayerCarSpawnDir]
	call SpawnCar
	; set it controlled by player
	set CARFLAG_PLAYER_F, [hl] ; CARSTRUCT_FLAGS
	ld a, l
	ld [wPlayerCarPtr + 0], a
	ld a, h
	ld [wPlayerCarPtr + 1], a
	push hl
	ld hl, Func_4066
	ld c, BANK(Func_4066)
	ld b, $01
	call SpawnEntity
	pop de
	ld a, ENT_CAR_PTR
	call SetStructWord_DE

	swap_hl_de
	ld a, CARSTRUCT_ENT_PTR
	call SetStructWord_DE

	call AllocateSprite
	ld a, CARSTRUCT_SPRITE_PTR
	call SetStructWord_DE

	jp Func_3047

; unreferenced
Func_4057:
	push hl
	add_hl
	xor a
	ld [hli], a
	ld a, e
	add c
	ld [hli], a
	jr nc, .asm_4061
	inc b
.asm_4061
	ld a, d
	add b
	ld [hl], a
	pop hl
	ret

Func_4066:
	call GetEntityCarPtr
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
	ld de, EntUpdate_PlayerCar
	ld a, BANK(EntUpdate_PlayerCar)
	jp SetEntityUpdateFunc

Func_408f:
	call GetEntityCarPtr

	ld a, [wda94]
	and a
	call nz, Func_f0c

	xor a
	ld [wda94], a
	ld [wda95], a
	ld [wda96], a

	ld c, HIGH(1.5q12)
	call CompareCarSpeed
	jr c, .asm_40af
	ld a, SFX_1D
	call PlaySFX

.asm_40af
	ld bc, 0.25q12
	call ApplyBrakeSpeed

	ld a, CARSTRUCT_SPEED
	call GetStructWord_BC
	ld a, CARSTRUCT_10
	call GetStructWord_DE
	ld a, b
	or c
	or d
	or e
	jr z, .asm_40d9
	ld c, HIGH(1.5q12)
	call CompareCarSpeed
	jr c, .asm_40d4
	ld a, [wFrameCounter]
	and $01
	call z, Func_42b8
.asm_40d4
	call .Func_40e3
	jr .asm_40af
.asm_40d9
	ld a, $02
	ld [wd83f], a
	call .Func_40e3
	jr .asm_40d9

.Func_40e3:
	ld bc, $fc00
	ld a, CARSTRUCT_10
	call Func_28bb
	call Func_469c
	ld a, 1
	call YieldEntityUpdate
	ret

Func_40f4:
	xor a
	ld [wda5d], a
	call Func_2f5f
	ld b, MAX_NUM_CARS
	ld de, wCars
.loop_cars
	ld a, [de] ; CARSTRUCT_FLAGS
	and CARFLAG_ACTIVE
	jr z, .inactive
	; skip if controlled by player
	ld a, [de] ; CARSTRUCT_FLAGS
	and CARFLAG_PLAYER
	call z, .Func_4119
.inactive
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .loop_cars
	ld a, [wda5d]
	and a
	ret z
	jp Func_3047

.Func_4119:
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

	ld a, CARSTRUCT_SPEED
	call GetStructWord_BC
	push hl
	ld h, b
	ld l, c
	sra b
	rr c
	sra b
	rr c ; /4
	xor a
	sub c
	ld c, a
	ld a, 0
	sbc b
	ld b, a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, CARSTRUCT_SPEED
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
	call IncreaseFelony
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
	ld a, 1
	jp InflictDamage
.asm_422f
	swap a
	and $0f
	ret z
	push bc
	ld c, a
	srl a
	add c
	pop bc
	jp InflictDamage

; unreferenced
Func_423d:
	push hl
	ld hl, wda68
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	xor a
	sub e
	ld e, a
	ld a, $00
	sbc d
	ld d, a
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
	pop hl
	ret

Func_4258:
	push hl
	ld h, d
	ld l, e
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	and a
	jr z, .asm_4270
	bit CARFLAG_UNK6_F, [hl] ; CARSTRUCT_FLAGS
	jr z, .asm_4268
	xor a
.asm_4268
	ld b, a
	ld a, CARSTRUCT_DIR
	call GetStructByte_C
	pop hl
	ret
.asm_4270
	ld a, CARSTRUCT_11
	call GetStructByte_B
	ld a, CARSTRUCT_0F
	call GetStructByte_C
	pop hl
	ret

; inflicts damage to player's car
; given by register a as base damage
InflictDamage:
	push hl

	; don't damage if No Damage cheat is active
	ld hl, wActiveCheats
	bit CHEAT_NO_DAMAGE_F, [hl]
	jr nz, .skip

	ld l, a ; base damage
	; do we have a multiplier?
	ld a, [wDamageMultiplier]
	and a
	jr z, .got_damage_to_add
	; yes, multiply damage received
	ld h, a
	ld a, l
.loop_mult
	add l
	dec h
	jr nz, .loop_mult
	ld l, a

.got_damage_to_add
	; l = damage to add
	ld a, l
	ld hl, wDamage
	add [hl]
	cp MAX_DAMAGE
	jr c, .got_total_damage
	ld a, MAX_DAMAGE
.got_total_damage
	ld [hl], a

.skip
	pop hl
	ret

Func_42a0:
	push hl
	jr Func_42ab

; increases felony by amount given in a
IncreaseFelony:
	push hl
	ld hl, wActiveCheats
	bit CHEAT_IMMUNITY_F, [hl]
	jr nz, Func_42ab.asm_42b6
Func_42ab:
	ld hl, wFelony
	add [hl]
	cp MAX_FELONY
	jr c, .got_felony
	ld a, MAX_FELONY
.got_felony
	ld [hl], a
.asm_42b6
	pop hl
	ret

Func_42b8:
	push hl
	call GetCarCoordinates
	ld a, CARSTRUCT_DIR
	call GetStructByte_A
	jr Func_42ce

Func_42c3:
	push hl
	call GetCarCoordinates
	ld a, CARSTRUCT_DIR
	call GetStructByte_A
	add 180 deg
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
	call GetEntityCarPtr
	call CalculateCarSpeedOffsets
	bit 7, b ; negative y offset?
	jr z, .asm_4309
	xor a
	sub b
	ld b, a
.asm_4309
	inc b
	bit 7, d ; negative x offset?
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
	ld a, [wCameraY + 0]
	ld e, a
	ld a, [wCameraY + 1]
	ld d, a
	call HLMinusDE
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
	ld [wd7f9 + 0], a
	ld a, h
	ld [wd7f9 + 1], a
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
	ld a, [wCameraX + 0]
	ld e, a
	ld a, [wCameraX + 1]
	ld d, a
	call HLMinusDE
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
	ld hl, wCameraY
	call Func_43ac
	ld a, l
	ld [wd809], a
	ld a, c
	ld [wd7f9 + 0], a
	ld a, b
	ld [wd7f9 + 1], a
	ld b, d
	ld c, e
	ld hl, wCameraX
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
	call HLMinusBC
	call GetAbsHL
	ld a, h
	and a
	ret z ; zero
	ld l, $7f
	ret

Func_43bb:
	call GetEntityCarPtr
Func_43be::
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	and $80
	jr z, .asm_43cc
	call Func_29e0
	jr .asm_43cf
.asm_43cc
	call CalculateCarDirectionComponents
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
	ld a, CARSTRUCT_Y
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
	ld a, CARSTRUCT_X
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
	ld de, 0
.asm_440e
	ld hl, wMapWidth
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
	ld bc, 0
.asm_4425
	ld hl, wMapHeight
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

EntUpdate_PlayerCar:
	call GetEntityCarPtr

	ld bc, 0
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld a, CARSTRUCT_10
	call SetStructByte_C
	ld a, CARSTRUCT_20
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
	ld a, CARSTRUCT_15
	call SetStructByte_C
	set CARFLAG_UNK3_F, [hl] ; CARSTRUCT_FLAGS
	; remove player control flag
	res CARFLAG_PLAYER_F, [hl]
	ld de, Func_5c32
	ld a, BANK(Func_5c32)
	jp SetEntityUpdateFunc

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
	ld a, CARSTRUCT_11
	call GetStructByte_A
	cp $08
	jr c, .asm_44c4
	jp Func_42c3
.asm_44c4
	call Func_468a
	ret z
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	cp $10
	ret c
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	bit 7, a
	jp z, Func_42b8
	jp Func_42c3

Func_44dd:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	ret z
	and PAD_LEFT
	jr nz, .d_left
; d_right
	ld c, $c0
	jr .asm_44ed
.d_left
	ld c, $40
.asm_44ed
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_B
	bit 7, b
	jr z, .got_abs_speed
	; going reverse
	ld a, b
	cpl
	inc a
	ld b, a
	ld a, c
	cpl
	inc a
	ld c, a
.got_abs_speed
	ld a, CARSTRUCT_DIR
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
	ld a, CARDATASTRUCT_D
	jr .asm_4529
.asm_4527
	ld a, CARDATASTRUCT_F
.asm_4529
	call GetPlayerCarData_Word
	ld a, CARSTRUCT_10
	jp Func_28bb

Func_4531:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, .asm_456c
	ld c, a
	ld a, CARSTRUCT_20
	call SetStructByte_C
	ld a, CARDATASTRUCT_STEERING
	call GetPlayerCarData_Byte
	ld b, a
	call .Func_4591
	jr c, .asm_456c
.got_steer_value
	ld a, c
	and PAD_RIGHT
	jr nz, .turning_right

; turning left
	push hl
	ld a, CARSTRUCT_DIR
	add_hl
.loop_dec_dir
	dec [hl]
	ld a, [hl]
	; snap to 16ths of a turn
	and $0f
	jr z, .snapped_left
	dec b
	jr nz, .loop_dec_dir
.snapped_left
	pop hl
	ret

.turning_right
	push hl
	ld a, CARSTRUCT_DIR
	add_hl
.loop_inc_dir
	inc [hl]
	ld a, [hl]
	and $0f
	; snap to 16ths of a turn
	jr z, .snapped_right
	dec b
	jr nz, .loop_inc_dir
.snapped_right
	pop hl
	ret

.asm_456c
	ld a, CARSTRUCT_DIR
	call GetStructByte_A
	and $0f
	ret z
	ld a, CARSTRUCT_20
	call GetStructByte_A
	and a
	ret z
	ld c, a
	ld a, CARDATASTRUCT_A
	call GetPlayerCarData_Byte
	ld b, a
	call .Func_4591
	jr c, .asm_458d
	ld a, b
	and a
	jr z, .asm_458d
	jr .got_steer_value
.asm_458d
	ld b, 2 deg
	jr .got_steer_value

.Func_4591:
	push bc
	ld a, CARDATASTRUCT_8
	call GetPlayerCarData_Byte
	ld c, a
	; speed < c?
	call CompareCarSpeed
	jr nc, .no_steering_change ; no
	; speed < c/2?
	srl c
	call CompareCarSpeed
	jr c, .set_carry ; yes
	; speed < (3/4)*c?
	ld a, c
	srl c
	add a
	ld c, a
	call CompareCarSpeed
	jr nc, .three_quarters_steering ; no

	pop bc
	srl b
	; b = (1/2)*b
	and a
	ret

.three_quarters_steering
	pop bc
	srl b
	ld a, b
	srl b
	add a
	ld b, a
	; b = (3/4)*b
	and a
	ret

.no_steering_change
	pop bc
	and a
	ret

.set_carry
	pop bc
	scf
	ret

Func_45c3:
	; is speeding?
	ld a, [wda90]
	and a
	jr z, .asm_45d8 ; no
	ld e, a
	ld a, CARDATASTRUCT_ACCELERATION
	call GetPlayerCarData_Byte
	ld d, a
	; speed += d * e
	call DTimesE
	ld a, CARSTRUCT_SPEED
	call AddStructWord_DE
.asm_45d8
	; is breaking?
	ld a, [wda91]
	and a
	jr z, .limit_speed ; no
	ld e, a
	ld a, CARDATASTRUCT_ACCELERATION_REVERSE
	call GetPlayerCarData_Byte
	ld d, a
	; speed -= d * e
	call DTimesE
	xor a
	sub e
	ld e, a
	ld a, 0
	sbc d
	ld d, a
	ld a, CARSTRUCT_SPEED
	call AddStructWord_DE
.limit_speed
	ld a, CARDATASTRUCT_B
	call GetPlayerCarData_Word
	call ApplyBrakeSpeed
	ld a, CARSTRUCT_SPEED
	call GetStructWord_BC
	bit 7, b
	jr nz, .going_reverse
	ld a, CARDATASTRUCT_TOP_SPEED
	call GetPlayerCarData_Byte
	cp b
	jr z, .limit_forward_speed
	ret nc
	; (max speed) < (cur speed)
.limit_forward_speed
	ld b, a
	ld c, 0
	jr .set_speed ; useless jump

.set_speed
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_BC

.going_reverse
	ld a, CARDATASTRUCT_TOP_SPEED_REVERSE
	call GetPlayerCarData_Byte
	cp b
	jr z, .limit_backward_speed
	ret c
	; (max speed) >= (cur speed)
.limit_backward_speed
	ld b, a
	ld c, $ff
	jr .set_speed

Func_4626:
	ld a, [wJoypadDown]
	and PAD_A
	jr nz, .pressing_a
	ld a, CARDATASTRUCT_1
	call GetPlayerCarData_Byte
	ld c, a
	ld a, [wda90]
	sub c
	jr nc, .asm_463a
	xor a
.asm_463a
	ld [wda90], a
	ret
.pressing_a
	ld a, $20
	ld [wda90], a
	ret

; unreferenced
Func_4644:
	ld a, CARDATASTRUCT_0
	call GetPlayerCarData_Byte
	ld c, a
	ld a, [wda90]
	add c
	cp $20
	jr c, .asm_4654
	ld a, $20
.asm_4654
	ld [wda90], a
	ret

Func_4658:
	ld a, [wJoypadDown]
	and PAD_B
	jr nz, .pressing_b
	ld a, CARDATASTRUCT_3
	call GetPlayerCarData_Byte
	ld c, a
	ld a, [wda91]
	sub c
	jr nc, .asm_466c
	xor a
.asm_466c
	ld [wda91], a
	ret
.pressing_b
	ld a, $20
	ld [wda91], a
	ret

; unreferenced
Func_4676:
	ld a, CARDATASTRUCT_2
	call GetPlayerCarData_Byte
	ld c, a
	ld a, [wda91]
	add c
	cp $20
	jr c, .asm_4686
	ld a, $20
.asm_4686
	ld [wda91], a
	ret

Func_468a:
	push hl
	ld a, CARSTRUCT_SPEED + 1
	add_hl
	bit 7, [hl]
	ld a, PAD_B
	jr z, .forward
	ld a, PAD_A
.forward
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
	call .Func_470f
	ld a, [wda98]
	and a
	jr z, .asm_46bf
	ld a, 3
	call IncreaseFelony
.asm_46bf
	ld bc, -$100
	ld a, CARSTRUCT_10
	call Func_28bb
	ld c, HIGH(1.0q12)
	call CompareCarSpeed
	jr c, .asm_46d4
	ld bc, $100
	call ApplyBrakeSpeed
.asm_46d4
	ld a, $10
	call Func_2abe
	jr z, .asm_4708
	call .Func_471e
	ld a, [wda93]
	ld b, a
	srl b
	ld a, [wda5d]
	call Func_2747
	add $80
	ld c, a
	call Func_2967

	; halve speed
	ld a, CARSTRUCT_SPEED
	call GetStructWord_BC
	sra b
	rr c
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC

	ld a, [wda93]
	swap a
	and $0f
	call nz, InflictDamage
.asm_4708
	call Func_3047
	call Func_40f4
	ret

.Func_470f:
	call Random
	and $01
	ld a, SFX_27
	jp z, PlaySFX
	ld a, SFX_29
	jp PlaySFX

.Func_471e:
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
	ld a, CARSTRUCT_DIR
	call GetStructByte_C
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_B
	bit 7, b
	jr z, .asm_4749
	ld a, b
	cpl
	inc a
	ld b, a
	ld a, c
	add 180 deg
	ld c, a
.asm_4749
	ld a, CARSTRUCT_0F
	call GetStructByte_E
	ld a, CARSTRUCT_11
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
	ld a, CARSTRUCT_11
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
	ld a, CARSTRUCT_SPEED + 1
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
	ld a, CARSTRUCT_SPEED + 1
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
	ld de, wCars
	ld b, MAX_NUM_CARS
.asm_48b0
	ld a, [de] ; CARSTRUCT_FLAGS
	and CARFLAG_ACTIVE | CARFLAG_UNK2
	cp CARFLAG_ACTIVE | CARFLAG_UNK2
	call z, .Func_48bf
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .asm_48b0
	ret

.Func_48bf:
	push de
	ld a, CARSTRUCT_01
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
	ld a, [de] ; CARSTRUCT_FLAGS
	and CARFLAG_UNK7
	jr nz, .asm_48de
	push de
	ld a, CARSTRUCT_22
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
	ld a, [de] ; CARSTRUCT_FLAGS
	and CARFLAG_UNK7
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
	table_width 2
	dw .Data_4933 ; BLACK_CAR
	dw .Data_4977 ; COP_CAR
	dw .Data_4933 ; TAXI
	dw .Data_4933 ; CAR_03
	dw .Data_4933 ; CAR_04
	dw .Data_4933 ; CAR_05
	dw .Data_4944 ; BROWN_CAR
	dw .Data_4955 ; RED_CAR
	dw .Data_4966 ; LIMOUSINE
	dw .Data_4933 ; CAR_09
	dw .Data_4933 ; CAR_10
	assert_table_length NUM_CAR_TYPES

.Data_4933:
	table_width 1
	db $04 ; CARDATASTRUCT_0
	db $08 ; CARDATASTRUCT_1
	db $04 ; CARDATASTRUCT_2
	db $08 ; CARDATASTRUCT_3
	db $09 ; CARDATASTRUCT_ACCELERATION
	db $09 ; CARDATASTRUCT_ACCELERATION_REVERSE
	db HIGH(3.3q12) ; CARDATASTRUCT_TOP_SPEED
	db -HIGH(2.0q12) ; CARDATASTRUCT_TOP_SPEED_REVERSE
	db HIGH(1.3q12) ; CARDATASTRUCT_8
	db 6 deg ; CARDATASTRUCT_STEERING
	db 3 deg ; CARDATASTRUCT_A
	db $80, $00 ; CARDATASTRUCT_B
	db $00, $ff ; CARDATASTRUCT_D
	db $28, $fd ; CARDATASTRUCT_F
	assert_table_length CAR_DATA_STRUCT_SIZE

.Data_4944:
	table_width 1
	db $04 ; CARDATASTRUCT_0
	db $08 ; CARDATASTRUCT_1
	db $04 ; CARDATASTRUCT_2
	db $08 ; CARDATASTRUCT_3
	db $0a ; CARDATASTRUCT_ACCELERATION
	db $0a ; CARDATASTRUCT_ACCELERATION_REVERSE
	db HIGH(3.5q12) ; CARDATASTRUCT_TOP_SPEED
	db -HIGH(2.3q12) ; CARDATASTRUCT_TOP_SPEED_REVERSE
	db HIGH(1.15q12) ; CARDATASTRUCT_8
	db 6 deg ; CARDATASTRUCT_STEERING
	db 3 deg ; CARDATASTRUCT_A
	db $80, $00 ; CARDATASTRUCT_B
	db $00, $ff ; CARDATASTRUCT_D
	db $28, $fd ; CARDATASTRUCT_F
	assert_table_length CAR_DATA_STRUCT_SIZE

.Data_4955:
	table_width 1
	db $04 ; CARDATASTRUCT_0
	db $08 ; CARDATASTRUCT_1
	db $04 ; CARDATASTRUCT_2
	db $08 ; CARDATASTRUCT_3
	db $09 ; CARDATASTRUCT_ACCELERATION
	db $09 ; CARDATASTRUCT_ACCELERATION_REVERSE
	db HIGH(3.5q12) ; CARDATASTRUCT_TOP_SPEED
	db -HIGH(2.3q12) ; CARDATASTRUCT_TOP_SPEED_REVERSE
	db HIGH(1.3q12) ; CARDATASTRUCT_8
	db 6 deg ; CARDATASTRUCT_STEERING
	db 3 deg ; CARDATASTRUCT_A
	db $80, $00 ; CARDATASTRUCT_B
	db $00, $ff ; CARDATASTRUCT_D
	db $28, $fd ; CARDATASTRUCT_F
	assert_table_length CAR_DATA_STRUCT_SIZE

.Data_4966:
	table_width 1
	db $04 ; CARDATASTRUCT_0
	db $08 ; CARDATASTRUCT_1
	db $04 ; CARDATASTRUCT_2
	db $08 ; CARDATASTRUCT_3
	db $08 ; CARDATASTRUCT_ACCELERATION
	db $08 ; CARDATASTRUCT_ACCELERATION_REVERSE
	db HIGH(3.65q12) ; CARDATASTRUCT_TOP_SPEED
	db -HIGH(2.0q12) ; CARDATASTRUCT_TOP_SPEED_REVERSE
	db HIGH(1.3q12) ; CARDATASTRUCT_8
	db 5 deg ; CARDATASTRUCT_STEERING
	db 3 deg ; CARDATASTRUCT_A
	db $90, $00 ; CARDATASTRUCT_B
	db $38, $ff ; CARDATASTRUCT_D
	db $28, $fd ; CARDATASTRUCT_F
	assert_table_length CAR_DATA_STRUCT_SIZE

.Data_4977:
	table_width 1
	db $04 ; CARDATASTRUCT_0
	db $08 ; CARDATASTRUCT_1
	db $04 ; CARDATASTRUCT_2
	db $08 ; CARDATASTRUCT_3
	db $08 ; CARDATASTRUCT_ACCELERATION
	db $08 ; CARDATASTRUCT_ACCELERATION_REVERSE
	db HIGH(3.5q12) ; CARDATASTRUCT_TOP_SPEED
	db -HIGH(2.3q12) ; CARDATASTRUCT_TOP_SPEED_REVERSE
	db HIGH(1.15q12) ; CARDATASTRUCT_8
	db 6 deg ; CARDATASTRUCT_STEERING
	db 3 deg ; CARDATASTRUCT_A
	db $80, $00 ; CARDATASTRUCT_B
	db $00, $ff ; CARDATASTRUCT_D
	db $28, $fd ; CARDATASTRUCT_F
	assert_table_length CAR_DATA_STRUCT_SIZE

EntUpdate_CarSpawner::
	xor a
	ld [wNumNPCCars], a
	ld [wda55], a
	call Random
	and $03
	ld [wda57], a
.loop
	ld a, [wNumNPCCars]
	ld hl, wMaxNumNPCCars
	cp [hl]
	jr nc, .skip
	ld a, [wda55]
	ld hl, wd830
	cp [hl]
	jr nc, .spawn_civilian
	ld hl, wCopSpawnTimer
	ld a, [hl]
	and a
	jr z, .spawn_cop
	; tick down timer
	dec [hl]
	jr .spawn_civilian
.spawn_cop
	ld a, [wCopSpawnCooldown]
	ld [hl], a ; wCopSpawnTimer
	call Func_49c6
	jr .skip
.spawn_civilian
	call Func_49e3
.skip
	ld a, 1
	call YieldEntityUpdate
	jr .loop

Func_49c6:
.asm_49c6
	ld hl, PtrTable_4c0b
	call Func_49fc
	jr z, .wait
	call Func_4a3d
	jr c, .wait
	ld hl, wNumNPCCars
	inc [hl]
	ld hl, wda55
	inc [hl]
	ret
.wait
	ld a, 1
	call YieldEntityUpdate
	jr .asm_49c6

Func_49e3:
.asm_49e3
	ld hl, PtrTable_4c0b
	call Func_49fc
	jr z, .wait
	call Func_4a48
	jr c, .wait
	ld hl, wNumNPCCars
	inc [hl]
	ret
.wait
	ld a, 1
	call YieldEntityUpdate
	jr .asm_49e3

; output:
; - bc = x coordinate
; - de = y coordinate
Func_49fc:
	ld a, l
	ld [wdc7a + 0], a
	ld a, h
	ld [wdc7a + 1], a
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_SPEED + 1
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
	ld hl, PtrTable_4c2b
	jr .asm_4a29

; input:
; - a  = direction
; - bc = x coordinate
; - de = y coordinate
Func_4a3d:
	call SpawnNPCCar_Cop
	ret c
	ld b, $05
	ld de, PtrTable_4bff
	jr Func_4a51

; input:
; - a  = direction
; - bc = x coordinate
; - de = y coordinate
Func_4a48:
	call SpawnNPCCar_Civilian
	ret c
	ld b, $04
	ld de, PtrTable_4bff
;	fallthrough

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
	add c ; *3
	add_hl
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call SpawnEntity
	pop de
	jr c, .asm_4a83
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	swap_hl_de
	ld a, CARSTRUCT_ENT_PTR
	call SetStructWord_DE
	and a
	ret
.asm_4a83
	ld h, d
	ld l, e
.asm_4a85
	ld a, CARSTRUCT_SPRITE_PTR
	call GetStructWord_DE
	xor a
	ld [hl], a ; CARSTRUCT_FLAGS
	ld [de], a ; SPRITESTRUCT_FLAGS
	scf
	ret

Func_4a8f:
	ld b, MAX_NUM_CARS
	ld de, wCars
.loop_cars
	push bc
	ld a, [de] ; CARSTRUCT_FLAGS
	and CARFLAG_ACTIVE
	jr z, .next_car
	ld a, h
	cp d
	jr nz, .compare
	ld a, l
	cp e
.compare
	jr z, .next_car ; same
	call Func_27e5
	ld a, $1f
	cp c
	jr c, .next_car
	cp b
	jr c, .next_car
	pop bc
	scf
	ret
.next_car
	pop bc
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .loop_cars
	and a
	ret

Func_4ab9:
	call Func_4b99
Func_4abc:
	call Func_4bb9
	ret z
	ld a, $01
	call Func_4b41
	ld a, 0 deg
	ret
Func_4ac8:
	call Func_4ba9
	jr Func_4abc

Func_4acd:
	call Func_4b89
Func_4ad0:
	call Func_4bb9
	ret z
	ld a, $02
	call Func_4b09
	ld a, 90 deg
	ret
Func_4adc:
	call Func_4b79
	jr Func_4ad0

Func_4ae1:
	call Func_4ba9
Func_4ae4:
	call Func_4bb9
	ret z
	ld a, $04
	call Func_4b41
	ld a, 180 deg
	ret
Func_4af0:
	call Func_4b99
	jr Func_4ae4

Func_4af5:
	call Func_4b79
Func_4af8:
	call Func_4bb9
	ret z
	ld a, $08
	call Func_4b09
	ld a, 270 deg
	ret
Func_4b04:
	call Func_4b89
	jr Func_4af8

Func_4b09:
	ld [wdc7c], a
	call Random
	ld h, a
	and $0f
	add a
	add a
	add a
	ld l, a
	ld a, $08
	bit 7, h
	jr z, .asm_4b1e
	ld a, $f8
.asm_4b1e
	ld [wdc7e], a
	ld h, $11
.asm_4b23
	ld a, l
	cp $88
	jr c, .asm_4b2a
	ld l, $00
.asm_4b2a
	push de
	ld a, l
	add_de
	ld a, [wdc7c]
	call Func_5681
	jr nz, .asm_4b3f
	pop de
	ld a, [wdc7e]
	add l
	ld l, a
	dec h
	jr nz, .asm_4b23
	ret
.asm_4b3f
	pop hl
	ret

Func_4b41:
	ld [wdc7c], a
	call Random
	ld h, a
	and $0f
	add a
	add a
	add a
	ld l, a
	ld a, $08
	bit 7, h
	jr z, .asm_4b56
	ld a, $f8
.asm_4b56
	ld [wdc7e], a
	ld h, $15
.asm_4b5b
	ld a, l
	cp $a8
	jr c, .asm_4b62
	ld l, $00
.asm_4b62
	push bc
	ld a, l
	add_bc
	ld a, [wdc7c]
	call Func_5681
	jr nz, .asm_4b77
	pop bc
	ld a, [wdc7e]
	add l
	ld l, a
	dec h
	jr nz, .asm_4b5b
	ret
.asm_4b77
	pop hl
	ret

Func_4b79:
	call Func_4bee
	ld hl, $b4
	add hl, bc
	ld b, h
	ld c, l
	ld hl, $4
	add hl, de
	ld d, h
	ld e, l
	ret

Func_4b89:
	call Func_4bee
	ld hl, -$14
	add hl, bc
	ld b, h
	ld c, l
	ld hl, $4
	add hl, de
	ld d, h
	ld e, l
	ret

Func_4b99:
	call Func_4bee
	ld hl, $94
	add hl, de
	ld d, h
	ld e, l
	ld hl, $4
	add hl, bc
	ld b, h
	ld c, l
	ret

Func_4ba9:
	call Func_4bee
	ld hl, -$14
	add hl, de
	ld d, h
	ld e, l
	ld hl, $4
	add hl, bc
	ld b, h
	ld c, l
	ret

Func_4bb9:
	bit 7, b
	jr nz, .ret_z
	push bc
	ld hl, wMapWidth
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $a0
	add hl, bc
	pop bc
	ld a, h
	cp b
	jr nz, .asm_4bcf
	ld a, l
	cp c
.asm_4bcf
	jr c, .ret_z
	bit 7, d
	jr nz, .ret_z
	push de
	ld hl, wMapHeight
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $80
	add hl, de
	pop de
	ld a, h
	cp d
	jr nz, .asm_4be7
	ld a, l
	cp e
.asm_4be7
	jr c, .ret_z
	xor a
	inc a
	ret
.ret_z
	xor a
	ret

Func_4bee:
	ld hl, wCameraX
	ld a, [hli]
	and $f8
	ld c, a
	ld b, [hl]
	ld hl, wCameraY
	ld a, [hli]
	and $f8
	ld e, a
	ld d, [hl]
	ret

PtrTable_4bff:
	dba Func_4ec7
	dba Func_5110
	dba Func_4fe8
	dba Func_523b

PtrTable_4c0b:
	dw PtrTable_4c2b ; $0
	dw PtrTable_4c33 ; $1
	dw PtrTable_4c3b ; $2
	dw PtrTable_4c43 ; $3
	dw PtrTable_4c4b ; $4
	dw PtrTable_4c2b ; $5
	dw PtrTable_4c53 ; $6
	dw PtrTable_4c2b ; $7
	dw PtrTable_4c5b ; $8
	dw PtrTable_4c63 ; $9
	dw PtrTable_4c2b ; $a
	dw PtrTable_4c2b ; $b
	dw PtrTable_4c6b ; $c
	dw PtrTable_4c2b ; $d
	dw PtrTable_4c2b ; $e
	dw PtrTable_4c2b ; $f

PtrTable_4c2b:
	dw Func_4ab9
	dw Func_4acd
	dw Func_4ae1
	dw Func_4af5

PtrTable_4c33:
	dw Func_4ae1
	dw Func_4ac8
	dw Func_4acd
	dw Func_4af5

PtrTable_4c3b:
	dw Func_4af5
	dw Func_4adc
	dw Func_4ae1
	dw Func_4ab9

PtrTable_4c43:
	dw Func_4ae1
	dw Func_4af5
	dw Func_4ac8
	dw Func_4adc

PtrTable_4c4b:
	dw Func_4ab9
	dw Func_4af0
	dw Func_4acd
	dw Func_4af5

PtrTable_4c53:
	dw Func_4ab9
	dw Func_4af5
	dw Func_4af0
	dw Func_4adc

PtrTable_4c5b:
	dw Func_4acd
	dw Func_4b04
	dw Func_4ab9
	dw Func_4ae1

PtrTable_4c63:
	dw Func_4ae1
	dw Func_4acd
	dw Func_4ac8
	dw Func_4b04

PtrTable_4c6b:
	dw Func_4ab9
	dw Func_4acd
	dw Func_4ac8
	dw Func_4adc

Func_4c73:
	bit CARFLAG_UNK3_F, [hl]
	ret nz
	call Func_270f
	jr nz, .asm_4c83
	push hl
	ld a, CARSTRUCT_12
	add_hl
	ld [hl], $00
	pop hl
	ret
.asm_4c83
	ld c, $5a
	bit CARFLAG_UNK2_F, [hl]
	jr z, .asm_4c8b
	ld c, $78
.asm_4c8b
	push hl
	ld a, CARSTRUCT_12
	add_hl
	ld a, [hl]
	inc a
	cp c
	jr nc, .asm_4c97
	ld [hl], a
	pop hl
	ret
.asm_4c97
	ld de, Func_4c9f
	ld a, BANK(Func_4c9f)
	jp SetEntityUpdateFunc

Func_4c9f:
	ld hl, wNumNPCCars
	call .DecrementIfNonZero
	call GetEntityCarPtr
	ld a, CARSTRUCT_SPRITE_PTR
	call GetStructWord_DE
	xor a
	ld [de], a
	ld a, [hl]
	ld [hl], $00
	ld hl, wda55
	and $04
	call nz, .DecrementIfNonZero
	jp DespawnEntity

.DecrementIfNonZero:
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

Func_4cc2:
	ld a, b
	or c
	jr nz, .asm_4cce
	ld d, e
	ld e, $00
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_DE
.asm_4cce
	ld a, CARSTRUCT_16
	call SetStructByte_E
	ld a, CARSTRUCT_17
	call SetStructByte_D
	push hl
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld b, h
	ld c, l
	pop hl
	push hl
	ld a, CARSTRUCT_1C
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_C
	ld a, CARSTRUCT_17
	call GetStructByte_A
	cp c
	jr c, .asm_4d38
.asm_4cfa
	call Func_4da3
	jr c, .asm_4d46
	jr z, .asm_4d50
	call Func_4dc4
	push hl
	ld a, CARSTRUCT_SPEED + 1
	add_hl
	ld a, [hl]
	ld hl, Data_4dc7
	add a
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	push hl
	ld a, CARSTRUCT_1D
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp d
	jr nz, .asm_4d1f
	ld a, l
	cp e
.asm_4d1f
	pop hl
	jr z, .asm_4d33
	jr c, .asm_4d33
	call Func_4d5f
	jr .asm_4cfa
.asm_4d29
	call Func_4da3
	jr c, .asm_4d46
	jr z, .asm_4d50
	call Func_4dc4
.asm_4d33
	call Func_4d7d
	jr .asm_4d29
.asm_4d38
	ld a, CARSTRUCT_17
	call GetStructByte_B
	ld c, $00
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	jr .asm_4cfa
.asm_4d46
	ld a, CARSTRUCT_1C
	call GetStructWord_DE
	ld a, CARSTRUCT_SPEED
	call AddStructWord_DE
.asm_4d50
	call Func_4dc4
	ld a, CARSTRUCT_16
	call GetStructByte_D
	ld e, $00
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_DE

Func_4d5f:
	ld a, CARSTRUCT_17
	call GetStructByte_D
	push hl
	ld bc, $80
	ld a, CARSTRUCT_SPEED
	add_hl
	ld a, [hl]
	add c
	ld [hli], a
	jr nc, .asm_4d71
	inc b
.asm_4d71
	ld a, [hl]
	add b
	ld [hl], a
	cp d
	jr c, .asm_4d7b
	ld [hl], d
	dec hl
	ld [hl], $00
.asm_4d7b
	pop hl
	ret

Func_4d7d:
	ld a, CARSTRUCT_16
	call GetStructByte_D
	push hl
	ld a, CARSTRUCT_SPEED
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -$100
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	bit 7, b
	jr z, .asm_4d97
	ld bc, NULL
.asm_4d97
	ld a, b
	cp d
	jr nc, .asm_4d9e
	ld b, d
	ld c, $00
.asm_4d9e
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_BC

Func_4da3:
	ld a, CARSTRUCT_SPEED
	call GetStructWord_DE
	push hl
	ld a, CARSTRUCT_1C
	add_hl
	ld a, [hl]
	sub e
	ld [hli], a
	jr nc, .asm_4db2
	inc d
.asm_4db2
	ld a, [hl]
	sub d
	ld [hli], a
	jr nc, .asm_4db8
	dec [hl]
.asm_4db8
	bit 7, [hl]
	jr nz, .asm_4dc1
	ld a, [hl]
	dec hl
	or [hl]
	pop hl
	ret
.asm_4dc1
	scf
	pop hl
	ret

Func_4dc4:
	jp Func_5431

Data_4dc7:
	dw $0000
	dw $0000
	dw $0001
	dw $0003
	dw $0006
	dw $000a
	dw $000f
	dw $0015
	dw $001c
	dw $0024
	dw $002d
	dw $0037
	dw $0042
	dw $004e
	dw $005b
	dw $0069
	dw $0078
	dw $0088
	dw $0099
	dw $00ab
	dw $00be
	dw $00d2
	dw $00e7
	dw $00fd
	dw $0114
	dw $012c
	dw $0145
	dw $015f
	dw $017a
	dw $0196
	dw $01b3
	dw $01d1
	dw $01f0
	dw $0210
	dw $0231
	dw $0253
	dw $0276
	dw $029a
	dw $02bf
	dw $02e5
	dw $030c
	dw $0334
	dw $035d
	dw $0387
	dw $03b2
	dw $03de
	dw $040b
	dw $0439
	dw $0468
	dw $0498
	dw $04c9
	dw $04fb
	dw $052e
	dw $0562
	dw $0597
	dw $05cd
	dw $0604
	dw $063c
	dw $0675
	dw $06af
	dw $06ea
	dw $0726
	dw $0763
	dw $07a1
	dw $07e0
	dw $0820
	dw $0861
	dw $08a3
	dw $08e6
	dw $092a
	dw $096f
	dw $09b5
	dw $09fc
	dw $0a44
	dw $0a8d
	dw $0ad7
	dw $0b22
	dw $0b6e
	dw $0bbb
	dw $0c09
	dw $0c58
	dw $0ca8
	dw $0cf9
	dw $0d4b
	dw $0d9e
	dw $0df2
	dw $0e47
	dw $0e9d
	dw $0ef4
	dw $0f4c
	dw $0fa5
	dw $0fff
	dw $105a
	dw $10b6
	dw $1113
	dw $1171
	dw $11d0
	dw $1230
	dw $1291
	dw $12f3
	dw $1356
	dw $13ba
	dw $141f
	dw $1485
	dw $14ec
	dw $1554
	dw $15bd
	dw $1627
	dw $1692
	dw $16fe
	dw $176b
	dw $17d9
	dw $1848
	dw $18b8
	dw $1929
	dw $199b
	dw $1a0e
	dw $1a82
	dw $1af7
	dw $1b6d
	dw $1be4
	dw $1c5c
	dw $1cd5
	dw $1d4f
	dw $1dca
	dw $1e46
	dw $1ec3
	dw $1f41

Func_4ec7:
	call GetEntityCarPtr
	ld c, 0 deg
	ld a, CARSTRUCT_DIR
	call SetStructByte_C
.asm_4ed1
	call GetCarCoordinates
.asm_4ed4
	push de
	ld l, $08
.asm_4ed7
	ld a, $11
	call Func_5681
	jr z, .asm_4f40
	cp $01
	jr nz, .asm_4eff
	push hl
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	pop hl
	dec l
	jr nz, .asm_4ed7
	pop de
	call GetEntityCarPtr
	ld bc, $20
	ld a, CARSTRUCT_15
	call GetStructByte_D
	ld e, d
	call Func_4cc2
	jr .asm_4ed1
.asm_4eff
	ld a, e
	and $f8
	ld e, a
	pop hl
	call HLMinusDE
	ld b, h
	ld c, l
	call GetEntityCarPtr
	bit 7, b
	jp nz, .asm_4fe0
	ld a, CARSTRUCT_18
	call SetStructWord_DE
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	cp $10
	jr nc, .asm_4f21
	ld a, $10
.asm_4f21
	ld d, a
	ld e, $01
	call Func_4cc2
	ld a, $18
	call GetStructWord_DE
	push hl
	ld a, $06
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	call Func_537b
	call GetCarCoordinates
	dec de
	jr .asm_4ed4
.asm_4f40
	ld a, e
	and $f8
	ld e, a
	ld a, $0e
	add_de
	pop hl
	call HLMinusDE
	ld b, h
	ld c, l
	call GetEntityCarPtr
	bit 7, b
	jp nz, .asm_4fe0
	ld a, CARSTRUCT_18
	call SetStructWord_DE
	ld e, $10
	ld a, CARSTRUCT_15
	call GetStructByte_D
	call Func_4cc2
	ld a, $18
	call GetStructWord_DE
	push hl
	ld a, $06
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, $0f
	call Func_5681
	jr z, .asm_4fe0
	cp $04
	jr z, .asm_4fe0
	ld e, a
	ld a, CARSTRUCT_SPEED
	ld bc, 1.0q12
	call SetStructWord_BC
	ld a, e
	cp $08
	jr z, .asm_4fbc
.asm_4f98
	ld a, $14
	ld c, $02
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	add $04
	ld [hl], a
	pop hl
	cp $40
	jr z, .asm_4fb1
	call Func_5431
	jr .asm_4f98
.asm_4fb1
	call Func_55e3
	ld de, Func_5110
	ld a, BANK(Func_5110)
	jp SetEntityUpdateFunc
.asm_4fbc
	ld a, $14
	ld c, $08
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	sub $04
	ld [hl], a
	pop hl
	cp $c0
	jr z, .asm_4fd5
	call Func_5431
	jr .asm_4fbc
.asm_4fd5
	call Func_55e3
	ld de, Func_523b
	ld a, BANK(Func_523b)
	jp SetEntityUpdateFunc
.asm_4fe0
	ld de, Func_535f
	ld a, BANK(Func_535f)
	jp SetEntityUpdateFunc

Func_4fe8:
	call GetEntityCarPtr
	ld c, 180 deg
	ld a, CARSTRUCT_DIR
	call SetStructByte_C
.asm_4ff2
	call GetCarCoordinates
	push de
	ld l, $08
.asm_4ff8
	ld a, $14
	call Func_5681
	jr z, .asm_5064
	cp $04
	jr nz, .asm_5020
	push hl
	ld hl, $08
	add hl, de
	ld d, h
	ld e, l
	pop hl
	dec l
	jr nz, .asm_4ff8
	pop de
	call GetEntityCarPtr
	ld bc, $20
	ld a, CARSTRUCT_15
	call GetStructByte_D
	ld e, d
	call Func_4cc2
	jr .asm_4ff2
.asm_5020
	ld a, e
	and $f8
	add $08
	ld e, a
	jr nc, .asm_5029
	inc d
.asm_5029
	ld h, d
	ld l, e
	pop bc
	call HLMinusBC
	ld b, h
	ld c, l
	call GetEntityCarPtr
	bit 7, b
	jp nz, .asm_5108
	ld a, CARSTRUCT_18
	call SetStructWord_DE
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	cp $10
	jr nc, .asm_5049
	ld a, $10
.asm_5049
	ld d, a
	ld e, $01
	call Func_4cc2
	ld a, $18
	call GetStructWord_DE
	push hl
	ld a, $06
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	call Func_537b
	jr .asm_4ff2
.asm_5064
	ld a, e
	and $f8
	sub $06
	ld e, a
	jr nc, .asm_506d
	dec d
.asm_506d
	ld h, d
	ld l, e
	pop bc
	call HLMinusBC
	ld b, h
	ld c, l
	call GetEntityCarPtr
	bit 7, b
	jp nz, .asm_5108
	ld a, CARSTRUCT_18
	call SetStructWord_DE
	ld e, $10
	ld a, CARSTRUCT_15
	call GetStructByte_D
	call Func_4cc2
	ld a, $18
	call GetStructWord_DE
	push hl
	ld a, $06
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, $08
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, $0f
	call Func_5681
	jr z, .asm_5108
	cp $01
	jr z, .asm_5108
	ld e, a
	ld a, CARSTRUCT_SPEED
	ld bc, 1.0q12
	call SetStructWord_BC
	ld a, e
	cp $08
	jr z, .asm_50e4
.asm_50c0
	ld a, $14
	ld c, $02
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	sub $04
	ld [hl], a
	pop hl
	cp $40
	jr z, .asm_50d9
	call Func_5431
	jr .asm_50c0
.asm_50d9
	call Func_55e3
	ld de, Func_5110
	ld a, BANK(Func_5110)
	jp SetEntityUpdateFunc
.asm_50e4
	ld a, $14
	ld c, $08
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	add $04
	ld [hl], a
	pop hl
	cp $c0
	jr z, .asm_50fd
	call Func_5431
	jr .asm_50e4
.asm_50fd
	call Func_55e3
	ld de, Func_523b
	ld a, BANK(Func_523b)
	jp SetEntityUpdateFunc
.asm_5108
	ld de, Func_535f
	ld a, BANK(Func_535f)
	jp SetEntityUpdateFunc

Func_5110:
	call GetEntityCarPtr
	ld c, 90 deg
	ld a, CARSTRUCT_DIR
	call SetStructByte_C
.asm_511a
	call GetCarCoordinates
	push bc
	ld l, $08
.asm_5120
	ld a, $12
	call Func_5681
	jr z, .asm_518e
	cp $02
	jr nz, .asm_5148
	push hl
	ld hl, $08
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	dec l
	jr nz, .asm_5120
	pop bc
	call GetEntityCarPtr
	ld bc, $20
	ld a, CARSTRUCT_15
	call GetStructByte_D
	ld e, d
	call Func_4cc2
	jr .asm_511a
.asm_5148
	ld a, c
	and $f8
	add $08
	ld c, a
	jr nc, .asm_5151
	inc b
.asm_5151
	ld h, b
	ld l, c
	pop bc
	push hl
	call HLMinusBC
	ld b, h
	ld c, l
	call GetEntityCarPtr
	pop de
	bit 7, b
	jp nz, .asm_5233
	ld a, CARSTRUCT_1A
	call SetStructWord_DE
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	cp $10
	jr nc, .asm_5173
	ld a, $10
.asm_5173
	ld d, a
	ld e, $01
	call Func_4cc2
	ld a, $1a
	call GetStructWord_BC
	push hl
	ld a, $09
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	call Func_537b
	jr .asm_511a
.asm_518e
	ld a, c
	and $f8
	sub $06
	ld c, a
	jr nc, .asm_5197
	dec b
.asm_5197
	ld h, b
	ld l, c
	pop bc
	push hl
	call HLMinusBC
	ld b, h
	ld c, l
	call GetEntityCarPtr
	pop de
	bit 7, b
	jp nz, .asm_5233
	ld a, CARSTRUCT_1A
	call SetStructWord_DE
	ld e, $10
	ld a, CARSTRUCT_15
	call GetStructByte_D
	call Func_4cc2
	ld a, $1a
	call GetStructWord_BC
	push hl
	ld a, $07
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld [hl], $00
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, $08
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, $0f
	call Func_5681
	jr z, .asm_5233
	cp $08
	jr z, .asm_5233
	ld e, a
	ld a, CARSTRUCT_SPEED
	ld bc, 1.0q12
	call SetStructWord_BC
	ld a, e
	cp $01
	jr z, .asm_520f
.asm_51eb
	ld a, $14
	ld c, $04
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	add $04
	ld [hl], a
	pop hl
	cp $80
	jr z, .asm_5204
	call Func_5431
	jr .asm_51eb
.asm_5204
	call Func_55f4
	ld de, Func_4fe8
	ld a, BANK(Func_4fe8)
	jp SetEntityUpdateFunc
.asm_520f
	ld a, $14
	ld c, $01
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	sub $04
	ld [hl], a
	pop hl
	cp $00
	jr z, .asm_5228
	call Func_5431
	jr .asm_520f
.asm_5228
	call Func_55f4
	ld de, Func_4ec7
	ld a, BANK(Func_4ec7)
	jp SetEntityUpdateFunc
.asm_5233
	ld de, Func_535f
	ld a, BANK(Func_535f)
	jp SetEntityUpdateFunc

Func_523b:
	call GetEntityCarPtr
	ld c, 270 deg
	ld a, CARSTRUCT_DIR
	call SetStructByte_C
.asm_5245
	call GetCarCoordinates
.asm_5248
	push bc
	ld l, $08
.asm_524b
	ld a, $18
	call Func_5681
	jr z, .asm_52b6
	cp $08
	jr nz, .asm_5273
	push hl
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	dec l
	jr nz, .asm_524b
	pop bc
	call GetEntityCarPtr
	ld bc, $20
	ld a, CARSTRUCT_15
	call GetStructByte_D
	ld e, d
	call Func_4cc2
	jr .asm_5245
.asm_5273
	ld a, c
	and $f8
	ld c, a
	pop hl
	call HLMinusBC
	ld d, b
	ld e, c
	ld b, h
	ld c, l
	call GetEntityCarPtr
	bit 7, b
	jp nz, .asm_5357
	ld a, CARSTRUCT_1A
	call SetStructWord_DE
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	cp $10
	jr nc, .asm_5297
	ld a, $10
.asm_5297
	ld d, a
	ld e, $01
	call Func_4cc2
	ld a, $1a
	call GetStructWord_BC
	push hl
	ld a, $09
	add_hl
	ld [hl], $00
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	call Func_537b
	call GetCarCoordinates
	dec bc
	jr .asm_5248
.asm_52b6
	ld a, c
	and $f8
	ld c, a
	ld a, $0e
	add_bc
	pop hl
	call HLMinusBC
	ld d, b
	ld e, c
	ld b, h
	ld c, l
	call GetEntityCarPtr
	bit 7, b
	jp nz, .asm_5357
	ld a, CARSTRUCT_1A
	call SetStructWord_DE
	ld e, $10
	ld a, CARSTRUCT_15
	call GetStructByte_D
	call Func_4cc2
	ld a, $1a
	call GetStructWord_BC
	push hl
	ld a, $07
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld [hl], $00
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, $0f
	call Func_5681
	jr z, .asm_5357
	cp $02
	jr z, .asm_5357
	ld e, a
	ld a, CARSTRUCT_SPEED
	ld bc, 1.0q12
	call SetStructWord_BC
	ld a, e
	cp $01
	jr z, .asm_5333
.asm_530f
	ld a, $14
	ld c, $04
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	sub $04
	ld [hl], a
	pop hl
	cp $80
	jr z, .asm_5328
	call Func_5431
	jr .asm_530f
.asm_5328
	call Func_55f4
	ld de, Func_4fe8
	ld a, BANK(Func_4fe8)
	jp SetEntityUpdateFunc
.asm_5333
	ld a, $14
	ld c, $01
	call SetStructByte_C
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	add $04
	ld [hl], a
	pop hl
	cp $00
	jr z, .asm_534c
	call Func_5431
	jr .asm_5333
.asm_534c
	call Func_55f4
	ld de, Func_4ec7
	ld a, BANK(Func_4ec7)
	jp SetEntityUpdateFunc
.asm_5357
	ld de, Func_535f
	ld a, BANK(Func_535f)
	jp SetEntityUpdateFunc

Func_535f:
	call GetEntityCarPtr
	bit CARFLAG_UNK3_F, [hl]
	jr z, .asm_5373
	set CARFLAG_UNK4_F, [hl]
	ld bc, NULL
	ld a, $0d
	call SetStructWord_BC
	jp YieldEntityUpdateIndefinitely
.asm_5373
	ld de, Func_4c9f
	ld a, BANK(Func_4c9f)
	jp SetEntityUpdateFunc

Func_537b:
	ld a, CARSTRUCT_SPEED
	ld bc, NULL
	call SetStructWord_BC
	call Func_3047
	ld a, CARSTRUCT_13
	call SetStructByte_C
	set CARFLAG_UNK5_F, [hl]
.asm_538d
	ld a, 1
	call YieldEntityUpdate
	call Func_4c73
	push hl
	ld a, CARSTRUCT_13
	add_hl
	inc [hl]
	ld a, [hl]
	pop hl
	cp $f0
	jr nc, .asm_53a5
	call Func_53a8
	jr c, .asm_538d
.asm_53a5
	res CARFLAG_UNK5_F, [hl]
	ret

Func_53a8:
	call Func_26db
	ld c, a
	ld b, MAX_NUM_CARS
	ld de, wCars
.loop_cars
	ld a, [de]
	and CARFLAG_ACTIVE
	jr z, .next_car
	call Func_53c2
	ret c
.next_car
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .loop_cars
	and a
	ret

Func_53c2:
	ld a, [de]
	and $d2
	jr nz, .asm_53e9
	ld a, h
	cp d
	jr nz, .asm_53cd
	ld a, l
	cp e
.asm_53cd
	jr z, .asm_53e9
	ld a, c
	ld [wda5a], a
	push bc
	call Func_27e5
	push hl
	ld hl, wda5a
	and [hl]
	pop hl
	jr z, .asm_53e8
	ld a, [wda5a]
	and $0a
	jr nz, .asm_53f2
	jr .asm_53ee
.asm_53e8
	pop bc
.asm_53e9
	and a
	ret
.asm_53eb
	pop bc
	scf
	ret
.asm_53ee
	ld a, $0a
	jr .asm_53f4
.asm_53f2
	ld a, $05
.asm_53f4
	ld [wdc7a], a
	ld a, $3f
	cp c
	jr c, .asm_53e8
	cp b
	jr c, .asm_53e8
	call Func_2707
	push hl
	ld hl, wdc7a
	and [hl]
	pop hl
	jr z, .asm_53e8
	push hl
	ld hl, wda59
	and [hl]
	pop hl
	jr nz, .asm_53e8
	ld a, [de]
	and $20
	jr z, .asm_53eb
	push de
	push hl
	ld a, $13
	add_hl
	ld a, $13
	add_de
	ld a, [de]
	cp [hl]
	pop hl
	pop de
	jr c, .asm_53e8
	jr nz, .asm_53eb
	ld a, h
	cp d
	jr nz, .asm_542d
	ld a, l
	cp e
.asm_542d
	jr c, .asm_53e8
	jr .asm_53eb

Func_5431:
	; apply speed to position
	call CalculateCarSpeedOffsets
	call AddToCarCoordinates

	; update sprite struct
	call Func_3047

	ld a, 1
	call YieldEntityUpdate

	call Func_4c73
	call Func_586a
	call Func_54b3
	ret nc
	set CARFLAG_UNK6_F, [hl]
	ld c, $00
.asm_544d
	ld a, 1
	call YieldEntityUpdate
	push bc
	call Func_4c73
	call Func_586a
	call Func_54b3
	pop bc
	jr nc, .asm_546e
	ld a, c
	cp $03
	jr nc, .asm_5467
	inc c
	jr .asm_544d
.asm_5467
	push bc
	call Func_5479
	pop bc
	jr .asm_544d
.asm_546e
	res CARFLAG_UNK6_F, [hl]
	ret

; ticks down wCarHornSFXTimer
TickCarHornSFXTimer::
	ld hl, wCarHornSFXTimer
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret

Func_5479:
	ld a, [wCarHornSFXTimer]
	and a
	ret nz
	ld a, [wd820]
	cp $01
	ret nz
	ld a, [wGameMode]
	cp MODE_CREDITS
	ret z
	bit CARFLAG_UNK2_F, [hl]
	ret nz
	call Func_270f
	ret nz
	call Random
	maskbits 4
	add a ; *2
	push hl
	ld hl, .data
	add_hl
	ld c, [hl] ; timer
	inc hl
	ld b, [hl] ; sfx
	pop hl
	ld a, c
	ld [wCarHornSFXTimer], a
	ld a, b
	ld [wCarHornSFX], a
	jp PlaySFX

.data
	; duration, sfx
	db 45, SFX_08
	db 45, SFX_09
	db 45, SFX_0A
	db 45, SFX_0B

Func_54b3:
	xor a
	ld [wda5d], a
	call Func_26db
	ld c, a
	ld de, wCars
	ld b, MAX_NUM_CARS
.loop_cars
	ld a, [de]
	and CARFLAG_ACTIVE
	call nz, Func_551b
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .loop_cars

	ld a, [wda5d]
	and a
	ret z
	cp $02
	jr z, .asm_550c
	cp $03
	jr z, .asm_5519
	push hl
	ld hl, $d
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -$100
	add hl, bc
	ld bc, $1000
	bit 7, h
	jr nz, .asm_54f4
	ld a, h
	cp b
	jr nz, .asm_54f2
	ld a, l
	cp c
.asm_54f2
	jr nc, .asm_54f6
.asm_54f4
	ld h, b
	ld l, c
.asm_54f6
	ld b, h
	ld c, l
	pop hl
	ld a, $0d
	call SetStructWord_BC
	ld a, $17
	call SetStructByte_B
	ld b, $10
	ld a, $16
	call SetStructByte_B
	and a
	ret
.asm_550c
	ld bc, 1.0q12
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld a, $17
	call SetStructByte_B
.asm_5519
	scf
	ret

Func_551b:
	ld a, h
	cp d
	jr nz, .asm_5521
	ld a, l
	cp e
.asm_5521
	ret z
	ld a, c
	ld [wda5a], a
	push bc
	call Func_27e5
	push hl
	ld hl, wda5a
	and [hl]
	pop hl
	jr z, .asm_553f
	push hl
	ld a, [wda5a]
	add a
	ld hl, .PtrTable_55c3
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.asm_553f
	pop bc
	ret

.Func_5541:
	pop bc
	ld a, [wda5d]
	and a
	ret nz
	ld a, $01
	ld [wda5d], a
	ret

.Func_554d:
	pop bc
	ld a, [wda5d]
	cp $02
	ret nc
	ld a, $02
	ld [wda5d], a
	ret

.Func_555a:
	pop bc
	ld a, $03
	ld [wda5d], a
	ret

.Func_5561:
	pop hl
	jr .asm_553f

.Func_5564:
	pop hl
	ld a, c
	cp $0b
	jr nc, .asm_553f
	call .Func_55b6
	and $05
	jr z, .asm_5576
	ld a, c
	cp $07
	jr nc, .asm_553f
.asm_5576
	ld a, b
	cp $28
	jr nc, .asm_553f
	cp $19
	jr c, .Func_554d
	jr .Func_5541

.Func_5581:
	pop hl
	ld a, b
	cp $0b
	jr nc, .asm_553f
	call .Func_55b6
	and $0a
	jr z, .asm_5593
	ld a, b
	cp $07
	jr nc, .asm_553f
.asm_5593
	ld a, c
	cp $28
	jr nc, .asm_553f
	cp $19
	jr c, .Func_554d
	jr .Func_5541

.Func_559e:
	pop hl
	ld a, c
	cp $10
	jr nc, .asm_553f
	ld a, b
	cp $10
	jr nc, .asm_553f
	push hl
	ld a, $14
	add_hl
	ld a, [wda59]
	and [hl]
	pop hl
	jr z, .asm_553f
	jr .Func_555a

.Func_55b6:
	push de
	ld a, $0c
	add_de
	ld a, [de]
	and $3f
	pop de
	jp z, Func_2707
	xor a
	ret

.PtrTable_55c3:
	dw .Func_5561
	dw .Func_5564
	dw .Func_5581
	dw .Func_559e
	dw .Func_5564
	dw .Func_5561
	dw .Func_559e
	dw .Func_5561
	dw .Func_5581
	dw .Func_559e
	dw .Func_5561
	dw .Func_5561
	dw .Func_559e
	dw .Func_5561
	dw .Func_5561
	dw .Func_5561

Func_55e3:
	push hl
	ld a, $06
	add_hl
	xor a
	ld [hli], a
	ld a, [hl]
	and $f8
	add $04
	ld [hli], a
	inc hl
	xor a
	ld [hl], a
	pop hl
	ret

Func_55f4:
	push hl
	ld a, $06
	add_hl
	xor a
	ld [hli], a
	inc hl
	inc hl
	ld [hli], a
	ld a, [hl]
	and $f8
	add $04
	ld [hl], a
	pop hl
	ret

; input:
; - a  = direction
; - bc = x coordinate
; - de = y coordinate
SpawnNPCCar_Civilian:
	push af
	; pick random car
	call Random
	maskbits NUM_SPAWNABLE_CARS
	ld hl, wSpawnableNPCCars
	add_hl
	ld a, [hl]
	cp TAXI
	jr z, .taxi

	; pick random palette
	push af
	call Random
	maskbits 4
	ld hl, .CarPals
	add_hl
	ld h, [hl]
	pop af
	jr .got_car_and_pal

.taxi
	; taxi uses yellow palette
	ld h, OBPAL_YELLOW

.got_car_and_pal
	ld l, a
	pop af
	call SpawnCar
	ret c
	call AllocateSprite
	jr c, .asm_563c
	ld a, CARSTRUCT_SPRITE_PTR
	call SetStructWord_DE
	call Func_3047
	call Func_5643
	and a
	ret
.asm_563c
	ld [hl], $00
	ret

.CarPals:
	db OBPAL_RED
	db OBPAL_CYAN
	db OBPAL_BLUE
	db OBPAL_GREEN

Func_5643:
	call Random
	maskbits 8
	ld de, .data
	add_de
	ld a, [de]
	ld b, a
	ld a, CARSTRUCT_15
	call SetStructByte_B
	ld a, CARSTRUCT_SPEED
	ld c, $00
	jp SetStructWord_BC

.data
	db HIGH(2.0q12)
	db HIGH(2.0q12)
	db HIGH(2.0q12)
	db HIGH(1.5q12)
	db HIGH(1.5q12)
	db HIGH(2.5q12)
	db HIGH(2.5q12)
	db HIGH(1.0q12)

; input:
; - a  = direction
; - bc = x coordinate
; - de = y coordinate
SpawnNPCCar_Cop:
	ld l, COP_CAR
	ld h, OBPAL_BLACK
	call SpawnCar
	ret c
	set CARFLAG_UNK2_F, [hl]
	call AllocateSprite
	jr c, .asm_567e
	ld a, CARSTRUCT_SPRITE_PTR
	call SetStructWord_DE
	call Func_3047
	call Func_5643
	and a
	ret
.asm_567e
	ld [hl], $00
	ret

Func_5681:
	push hl
	push af
	call Func_2558
	ld hl, .data
	add_hl
	ld a, [hl]
	ld [wda58], a
	ld l, a
	pop af
	and l
	pop hl
	ret

.data
	db $00, $00, $00, $01, $02, $04, $08, $03, $09, $06, $0c, $11, $12, $14, $18

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
	ld de, Func_56db
	ld a, BANK(Func_56db)
	call OverwriteEntityUpdateFunc
	pop hl
	pop de
	ret

Func_56db:
	call GetEntityCarPtr
	ld a, [hl]
	and ~(CARFLAG_UNK5 | CARFLAG_UNK6)
	or CARFLAG_UNK4
	ld [hl], a
	ld bc, NULL
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	call .Func_577d
.asm_56ef
	call .Func_573b
	call .Func_5777
	call Func_2ab5
	call z, .Func_578a
	ld a, $20
	call GetStructByte_A
	and a
	jr z, .asm_5723
	ld b, a
	ld a, $11
	call GetStructByte_A
	swap a
	and $0f
	inc a
	bit 7, b
	jr z, .asm_5714
	cpl
	inc a
.asm_5714
	ld c, a
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	add c
	ld [hl], a
	ld a, $03
	add_hl
	ld a, [hl]
	add c
	ld [hl], a
	pop hl
.asm_5723
	ld a, $10
	ld bc, -$80
	call Func_28bb
	call Func_3047
	call .Func_57a8
	call Func_4c73
	ld a, 1
	call YieldEntityUpdate
	jr .asm_56ef

.Func_573b:
	ld a, CARSTRUCT_11
	call GetStructByte_A
	bit CARFLAG_UNK2_F, [hl]
	jr nz, .asm_574c
	bit CARFLAG_UNK3_F, [hl]
	jr nz, .asm_5756
	and a
	ret nz
	jr .asm_576d
.asm_574c
	and a
	ret nz
	ld de, Func_5906
	ld a, BANK(Func_5906)
	jp SetEntityUpdateFunc
.asm_5756
	ld c, a
	ld a, [wd86c]
	cp $38
	jr z, .asm_576a
	ld a, c
	cp $10
	ret nc
	ld de, Func_5e75
	ld a, BANK(Func_5e75)
	jp SetEntityUpdateFunc
.asm_576a
	ld a, c
	and a
	ret nz
.asm_576d
	call Func_4c73
	ld a, 1
	call YieldEntityUpdate
	jr .asm_576d

.Func_5777:
	call Func_2877
	jp AddToCarCoordinates

.Func_577d:
	push hl
	ld a, $11
	add_hl
	ld a, [hl]
	cp $08
	jr nc, .asm_5788
	ld [hl], $08
.asm_5788
	pop hl
	ret

.Func_578a:
	ld a, $0f
	call Func_2984
	call .Func_5777
	ld a, $10
	call GetStructWord_BC
	srl b
	rr c
	ld a, $10
	call SetStructWord_BC
	push hl
	ld a, $20
	add_hl
	ld [hl], $00
	pop hl
	ret

.Func_57a8:
	xor a
	ld [wda5d], a
	call Func_2f5f
	ld b, MAX_NUM_CARS
	ld de, wCars
.loop_cars
	ld a, [de]
	and CARFLAG_ACTIVE
	jr z, .next_car
	ld a, h
	cp d
	jr nz, .asm_57bf
	ld a, l
	cp e
.asm_57bf
	jr z, .next_car
	ld a, [de]
	bit 1, a
	jr nz, .next_car
	bit 4, a
	jr nz, .asm_57ce
	and $80
	jr nz, .next_car
.asm_57ce
	call Func_57df
.next_car
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .loop_cars
	ld a, [wda5d]
	and a
	ret z
	jp Func_3047

Func_57df:
	push bc
	call Func_2a90
	jr nc, .asm_57e7
	pop bc
	ret
.asm_57e7
	call Func_2d66
	call Func_31fb
	ld a, $10
	call GetStructWord_BC
	sra b
	rr c
	ld a, $0f
	call GetStructByte_A
	call Func_56a2
	ld a, $01
	ld [wda5d], a
	pop bc
	ret

Func_5805::
	call GetEntityCarPtr
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl]
	call SpawnNPCCar_Cop
	ld d, h
	ld e, l
	call GetEntityPtr
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	swap_hl_de
	ld a, CARSTRUCT_ENT_PTR
	call SetStructWord_DE
	ld bc, 0
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	call Func_58e2
	ld hl, wda55
	inc [hl]
	ld hl, wNumNPCCars
	inc [hl]
.asm_583a
	ld a, 1
	call YieldEntityUpdate
	ld a, [wda7b]
	and a
	jr z, .asm_583a
	ld hl, .data
	ld a, [hli]
	ld [wd833], a
	ld a, [hli]
	ld [wd834], a
	ld a, [hli]
	ld [wd835], a
	ld a, [hl]
	ld [wd836], a
	call GetEntityCarPtr
	call Func_5893
	ld de, Func_5950
	ld a, BANK(Func_5950)
	jp SetEntityUpdateFunc

.data
	db $04, $1c, $10, $0e

Func_586a:
	bit CARFLAG_UNK2_F, [hl]
	ret z
	call Func_589b
	ld a, [wd838]
	and a
	ret nz
	ld a, [wFelony]
	and a
	ret z ; no felony
	ld a, [wGameMode]
	cp MODE_SURVIVAL
	jr z, .asm_5888
	ld a, CARSTRUCT_22
	call GetStructByte_A
	and a
	ret z
.asm_5888
	call Func_5893
	ld de, Func_5950
	ld a, BANK(Func_5950)
	jp SetEntityUpdateFunc

Func_5893:
	ld a, CARSTRUCT_1C
	ld bc, NULL
	jp SetStructWord_BC

Func_589b:
	ld a, CARSTRUCT_22
	ld c, $00
	call SetStructByte_C
	call Func_270f
	ret nz
	call GetCarCoordinates
	push hl
	ld hl, wCameraY
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
	ld a, h
	and a
	jr nz, .asm_58e0
	ld a, l
	cp $80
	jr nc, .asm_58e0
	ld hl, wCameraX
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
	ld a, h
	and a
	jr nz, .asm_58e0
	ld a, l
	cp $a0
	jr nc, .asm_58e0
	pop hl
	ld c, $01
	ld a, CARSTRUCT_22
	jp SetStructByte_C
.asm_58e0
	pop hl
	ret

Func_58e2:
	ld a, [hl]
	and ~(CARFLAG_UNK4 | CARFLAG_UNK5 | CARFLAG_UNK6)
	or CARFLAG_UNK7
	ld [hl], a
	ld a, CARSTRUCT_01
	call GetStructByte_A
	cp $01
	ret nz
	ld a, CARSTRUCT_SPRITE_PTR
	call GetStructWord_DE
	ld a, [de]
	or SPRITEFLAG_UNK7
	ld [de], a
	ret

; unreferenced
Func_58fa:
	res CARFLAG_UNK7_F, [hl]
	ld a, CARSTRUCT_SPRITE_PTR
	call GetStructWord_DE
	ld a, [de]
	and ~SPRITEFLAG_UNK7
	ld [de], a
	ret

Func_5906:
	call GetEntityCarPtr
	call Func_3047
	ld a, [wd838]
	and a
	jr nz, .asm_5918
	ld a, [wFelony]
	and a
	jr nz, .has_felony
.asm_5918
	ld a, 1
	call YieldEntityUpdate
	call Func_4c73
	jr .asm_5918
.has_felony
	ld a, [wd833]
	and a
	jr z, .asm_5936
	ld b, a
.asm_5929
	ld a, 1
	call YieldEntityUpdate
	push bc
	call Func_4c73
	pop bc
	dec b
	jr nz, .asm_5929
.asm_5936
	res CARFLAG_UNK4_F, [hl]
	ld bc, 1.0q12
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld bc, NULL
	ld a, $10
	call SetStructByte_C
	ld de, Func_5950
	ld a, BANK(Func_5950)
	jp SetEntityUpdateFunc

Func_5950:
	call GetEntityCarPtr
	call Func_58e2
	ld c, $00
	ld a, CARSTRUCT_1F
	call SetStructByte_C
.asm_595d
	ld a, [wd838]
	and a
	jp nz, Func_5a84
	call Func_5b25
	call CalculateEuclideanDistance
	ld [wda6c], a
	call Func_2d66
	ld [wda6d], a
	xor a
	ld [wda74], a
	ld a, CARSTRUCT_1F
	call GetStructByte_C
	ld a, [wda6d]
	call Func_271b
	and c
	jr z, .asm_59b7
	cpl
	ld b, a
	ld a, $01
	ld [wda74], a
	ld a, [wda6d]
	call Func_271b
	and b
	jr nz, .asm_59b1
	ld a, c
	cp $0f
	jr z, .asm_59b7
	cpl
	ld b, a
	ld a, CARSTRUCT_DIR
	call GetStructByte_A
	call Func_271b
	ld c, a
	and b
	jr nz, .asm_59b1
	ld a, c
	call Func_26ef
	and b
	jr nz, .asm_59b1
	jr .asm_59b7
.asm_59b1
	call Func_2747
	ld [wda6d], a
.asm_59b7
	ld a, CARSTRUCT_DIR
	call GetStructByte_C
	ld a, [wda6d]
	sub c
	jr z, .asm_59f3
	ld b, $01
	jr nc, .asm_59ca
	cpl
	inc a
	ld b, $ff
.asm_59ca
	cp $20
	jr nc, .asm_59dd
	cp $09
	jr c, .asm_59ed
.asm_59d2
	call Func_5b00
	ld bc, -$c0
	call Func_5ae1
	jr .asm_59f8
.asm_59dd
	cp $80
	jr c, .asm_59e5
	ld a, b
	cpl
	inc a
	ld b, a
.asm_59e5
	call Func_5b00
	call Func_5ade
	jr .asm_59f8
.asm_59ed
	ld a, [wda74]
	and a
	jr nz, .asm_59d2
.asm_59f3
	call Func_5aa0
	jr .asm_59f8
.asm_59f8
	ld a, CARSTRUCT_1F
	ld c, $00
	call SetStructByte_C
	ld a, $10
	call Func_2abe
	ld c, a
	jr z, .asm_5a29
	ld a, [wd839]
	and a
	jr nz, .asm_5a29
	ld a, CARSTRUCT_SPEED
	call GetStructWord_BC
	srl b
	rr c
	ld a, [wda5d]
	call Func_2747
	add $80
	call Func_289f
	ld de, Func_56db
	ld a, BANK(Func_56db)
	jp SetEntityUpdateFunc
.asm_5a29
	push hl
	ld a, CARSTRUCT_1F
	add_hl
	ld [hl], c
	pop hl
	call Func_313e
	call Func_5b7a
	ld c, a
	push hl
	ld a, CARSTRUCT_1F
	add_hl
	ld a, c
	or [hl]
	ld [hl], a
	pop hl
	call Func_3047
	ld a, 1
	call YieldEntityUpdate
	call Func_4c73
	call Func_5a58
	jp .asm_595d

; unreferenced
Func_5a4f:
	push hl
	ld a, $1c
	add_hl
	xor a
	ld [hli], a
	ld [hl], a
	pop hl
	ret

Func_5a58:
	call Func_5a6b
	ret nc
	push de
	push hl
	ld a, $1c
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	pop hl
	pop de
	ret

Func_5a6b:
	push de
	push hl
	ld a, $1c
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd835]
	ld e, a
	ld a, [wd836]
	ld d, a
	ld a, h
	cp d
	jr nz, .asm_5a81
	ld a, l
	cp e
.asm_5a81
	pop hl
	pop de
	ret

Func_5a84:
	set CARFLAG_UNK4_F, [hl]
.asm_5a86
	ld bc, $100
	call ApplyBrakeSpeed
	call Func_270f
	jr z, .asm_5a99
	ld de, Func_4c9f
	ld a, BANK(Func_4c9f)
	jp SetEntityUpdateFunc
.asm_5a99
	ld a, 1
	call YieldEntityUpdate
	jr .asm_5a86

Func_5aa0:
	ld d, $30
	ld bc, $80
	call Func_5a6b
	jr nc, .asm_5abe
	call Func_5bc4
	jr z, .asm_5abe
	ld a, [wd834]
	ld e, a
	ld a, [wda6c]
	cp e
	jr c, .asm_5abe
	ld d, $40
	ld bc, $100
.asm_5abe
	push hl
	ld a, $0d
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, b
	cp $10
	jr nc, .asm_5ad3
	ld bc, 1.0q12
	jr .asm_5ad9
.asm_5ad3
	cp d
	jr c, .asm_5ad9
	ld b, d
	ld c, $00
.asm_5ad9
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_BC

Func_5ade:
	ld bc, $fe80
Func_5ae1:
	push hl
	ld a, $0d
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	bit 7, h
	jr z, .asm_5af0
	ld hl, NULL
.asm_5af0
	ld b, h
	ld c, l
	pop hl
	ld a, b
	cp $10
	jr nc, .asm_5afb
	ld bc, 1.0q12
.asm_5afb
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_BC

Func_5b00:
	ld a, $0e
	call GetStructByte_A
	cp $10
	ret c
	ld a, b
	cpl
	inc a
	ld d, a
	ld a, $20
	call SetStructByte_D
	ld a, [wda6d]
	ld d, a
	ld e, $04
	ld a, c
.asm_5b18
	add b
	cp d
	jr z, .asm_5b1f
	dec e
	jr nz, .asm_5b18
.asm_5b1f
	ld c, a
	ld a, $0c
	jp SetStructByte_C

Func_5b25:
	ld a, [wPlayerCarPtr + 0]
	ld e, a
	ld a, [wPlayerCarPtr + 1]
	ld d, a
	call Func_2707
	ld [wda5b], a
	call Func_27e5
	ld a, [wda59]
	ld [wda5c], a
	call Func_5bc4
	ret nz
	push hl
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_COORDS
	add_hl
	ld de, wda23Coords
	ld b, $06
	call CopyHLtoDE

	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CalculateCarSpeedOffsets
	ld h, d
	ld l, e
	call .Func_5b76
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call .Func_5b76
	ld b, h
	ld c, l
	ld hl, wda23
	call AddToCarCoordinates
	pop hl
	ld de, wda23
	jp Func_27e5

.Func_5b76:
	add hl, hl
	add hl, hl
	add hl, hl
	ret

Func_5b7a:
	xor a
	ld [wda5d], a
	call Func_2f5f
	ld de, wCars
	ld b, MAX_NUM_CARS
.asm_5b86
	ld a, [de]
	and CARFLAG_ACTIVE
	jr z, .asm_5b9f
	bit 3, [hl]
	jr nz, .asm_5b94
	ld a, [de]
	and CARFLAG_PLAYER
	jr nz, .asm_5b9f
.asm_5b94
	ld a, h
	cp d
	jr nz, .asm_5b9a
	ld a, l
	cp e
.asm_5b9a
	jr z, .asm_5b9f
	call .Func_5baa
.asm_5b9f
	ld a, CAR_STRUCT_SIZE
	add_de
	dec b
	jr nz, .asm_5b86
	ld a, [wda5d]
	and a
	ret

.Func_5baa:
	push bc
	call Func_2a90
	jr c, .asm_5bc2
	call Func_2d66
	push af
	call Func_271b
	push hl
	ld hl, wda5d
	or [hl]
	ld [hl], a
	pop hl
	pop af
	call Func_31fb
.asm_5bc2
	pop bc
	ret

Func_5bc4:
	push hl
	ld a, [wda5c]
	ld hl, wda5b
	and [hl]
	pop hl
	ret

Func_5bce::
	ld a, [hli]
	ld [wdc82], a ; car
	ld a, [hli]
	ld [wdc84], a ; pal
	ld a, [hli]
	ld [wdc86], a
	ld a, [hli]
	ld [wdc88], a
	ld a, [hli] ; direction
	ld c, [hl] ; x
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl] ; y
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
	call SpawnCar
	set CARFLAG_UNK3_F, [hl]
	push hl
	ld hl, Func_5c32
	ld c, BANK(Func_5c32)
	ld b, $06
	call SpawnEntity
	pop de
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	swap_hl_de
	ld a, CARSTRUCT_ENT_PTR
	call SetStructWord_DE
	call AllocateSprite
	ld a, CARSTRUCT_SPRITE_PTR
	call SetStructWord_DE
	call Func_3047
	pop de
	ld a, [wdc88]
	ld b, a
	ld c, 0
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld a, [wdc86]
	ld c, a
	ld a, CARSTRUCT_15
	call SetStructByte_C
	ret

Func_5c32:
	call GetEntityCarPtr
	set CARFLAG_UNK4_F, [hl]
.asm_5c37
	ld a, [wda7b]
	and a
	jr nz, .asm_5c44
	ld a, 1
	call YieldEntityUpdate
	jr .asm_5c37
.asm_5c44
	res CARFLAG_UNK4_F, [hl]
	set CARFLAG_UNK7_F, [hl]
	ld c, PAD_LEFT
	ld a, CARSTRUCT_20
	call SetStructByte_C
	ld c, $00
	ld a, CARSTRUCT_1C
	call SetStructByte_C
	ld c, $00
	ld a, CARSTRUCT_1F
	call SetStructByte_C
.asm_5c5d
	call .Func_5d36
	call .Func_5d04
	call .Func_5cbb
	ld c, $00
	ld a, CARSTRUCT_1F
	call SetStructByte_C
	call .Func_5daa
	call GetEntityCarPtr
	ld a, $ff
	call Func_2abe
	call .Func_5da0
	call Func_5b7a
	call .Func_5da0
	call Func_313e
	call Func_3047
	call .Func_5c92
	ld a, 1
	call YieldEntityUpdate
	jp .asm_5c5d

.Func_5c92:
	ld a, [wGameMode]
	cp MODE_CREDITS
	ret nz ; not credits
	ld a, [wda8f]
	inc a
	cp $02
	jr nc, .asm_5ca4
	ld [wda8f], a
	ret
.asm_5ca4
	xor a
	ld [wda8f], a
	ld a, CARSTRUCT_1C
	call GetStructByte_A
	cp $08
	ret nc
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	cp $08
	ret c
	jp Func_42c3

.Func_5cbb:
	ld a, CARSTRUCT_1D
	call GetStructByte_A
	and a
	jr nz, .asm_5ce2
	ld a, CARSTRUCT_15
	call GetStructByte_D
	push hl
	ld a, CARSTRUCT_SPEED
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $80
	add hl, bc
	ld a, h
	cp d
	jr c, .asm_5cda
	ld h, d
	ld l, $00
.asm_5cda
	ld b, h
	ld c, l
	pop hl
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_BC
.asm_5ce2
	push hl
	ld a, CARSTRUCT_SPEED
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -$100
	add hl, bc
	bit 7, h
	jr z, .asm_5cf4
	ld hl, 0.0q12
.asm_5cf4
	ld a, h
	cp $10
	jr nc, .asm_5cfc
	ld hl, 1.0q12
.asm_5cfc
	ld b, h
	ld c, l
	pop hl
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_BC

.Func_5d04:
	ld a, CARSTRUCT_1C
	call GetStructByte_A
	cp $08
	ret c
	ld a, CARSTRUCT_20
	ld c, PAD_LEFT
	call SetStructByte_C
	push hl
	ld a, CARSTRUCT_DIR
	add_hl
	ld a, [hl]
	pop hl
	and $3f
	ret z
	ld c, $01
	cp $20
	jr nc, .asm_5d24
	ld c, $ff
.asm_5d24
	push hl
	ld b, $02
	ld a, $0c
	add_hl
.asm_5d2a
	ld a, [hl]
	add c
	ld [hl], a
	and $3f
	jr z, .asm_5d34
	dec b
	jr nz, .asm_5d2a
.asm_5d34
	pop hl
	ret

.Func_5d36:
	push hl
	ld a, CARSTRUCT_1C
	add_hl
	ld a, [hl]
	cp $ff
	jr z, .asm_5d40
	inc [hl]
.asm_5d40
	inc hl
	ld [hl], $00 ; CARSTRUCT_1D
	pop hl
	ld a, CARSTRUCT_1F
	call GetStructByte_A
	and a
	ret z
	ld c, a
	call Func_26db
	ld b, a
	and c
	ret z
	push af
	push hl
	ld a, CARSTRUCT_1C
	add_hl
	ld [hl], $00 ; CARSTRUCT_1C
	inc hl
	ld [hl], $01 ; CARSTRUCT_1D
	pop hl
	pop af
	cpl
	and b
	jr z, .asm_5d91
	call Func_2747
	ld c, a
	ld a, CARSTRUCT_DIR
	call GetStructByte_A
	sub c
	ld b, -(6 deg)
	jr nc, .asm_5d74
	cpl
	inc a
	ld b, 6 deg
.asm_5d74
	cp $80
	jr c, .asm_5d7c
	ld a, b
	cpl
	inc a
	ld b, a
.asm_5d7c
	push hl
	ld a, CARSTRUCT_DIR
	add_hl
	ld a, [hl]
	add b
	ld [hl], a
	pop hl
	ld c, PAD_LEFT
	bit 7, b
	jr nz, .asm_5d8c
	ld c, PAD_RIGHT
.asm_5d8c
	ld a, CARSTRUCT_20
	jp SetStructByte_C
.asm_5d91
	ld b, 6 deg
	ld a, CARSTRUCT_20
	call GetStructByte_A
	and PAD_RIGHT
	jr nz, .asm_5d7c
	ld b, -(6 deg)
	jr .asm_5d7c

.Func_5da0:
	push hl
	ld c, a
	ld a, CARSTRUCT_1F
	add_hl
	ld a, c
	or [hl]
	ld [hl], a
	pop hl
	ret

.Func_5daa:
	ld a, CARSTRUCT_DIR
	add_hl
	ld a, [hl]
	call Func_5dfd
	ret nz
	ld a, [wdc7a]
	ld c, a
	and $3f
	jr z, .asm_5ddf
	ld a, c
	call Func_271b
	ld c, a
	and $05
	call Func_2747
	push bc
	call Func_5dfd
	pop bc
	jr nz, .asm_5deb
	ld a, c
	and $0a
	call Func_2747
	push bc
	call Func_5dfd
	pop bc
	jr nz, .asm_5df4
	call GetEntityCarPtr
	ld a, c
	jp .Func_5da0
.asm_5ddf
	call GetEntityCarPtr
	ld a, [wdc7a]
	call Func_271b
	jp .Func_5da0
.asm_5deb
	call GetEntityCarPtr
	ld a, c
	and $0a
	jp .Func_5da0
.asm_5df4
	call GetEntityCarPtr
	ld a, c
	and $05
	jp .Func_5da0

Func_5dfd:
	call .Func_5e54
	call .Func_5e29
	call GetEntityCarPtr
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	srl a
	srl a
	srl a
	and $0f
	inc a
	ld b, a
.asm_5e15
	push bc
	call .Func_5e37
	call .Func_5e23
	pop bc
	ret z
	dec b
	jr nz, .asm_5e15
	dec b
	ret

.Func_5e23:
	ld hl, wda23
	jp Func_2ab5

.Func_5e29:
	call GetEntityCarPtr
	ld a, CARSTRUCT_COORDS
	add_hl
	ld de, wda23Coords
	ld b, $06
	jp CopyHLtoDE

.Func_5e37:
	ld hl, wda23
	ld a, [wdc7c + 0]
	ld c, a
	ld a, [wdc7c + 1]
	ld b, a
	ld a, CARSTRUCT_X_FRAC
	call AddBCToStructField
	ld a, [wdc7e]
	ld c, a
	ld a, [wdc7f]
	ld b, a
	ld a, CARSTRUCT_Y_FRAC
	jp AddBCToStructField

.Func_5e54:
	ld [wdc7a], a
	call CalculateDirectionComponents
	ld h, b
	ld l, c
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, l
	ld [wdc7e], a
	ld a, h
	ld [wdc7f], a
	ld h, d
	ld l, e
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, l
	ld [wdc7c + 0], a
	ld a, h
	ld [wdc7c + 1], a
	ret

Func_5e75:
	call GetEntityCarPtr
	call Func_3047
	ld a, CARSTRUCT_10
	call GetStructWord_BC
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld bc, NULL
	ld a, CARSTRUCT_10
	call SetStructWord_BC
	res CARFLAG_UNK4_F, [hl]
	ld de, Func_5c32
	ld a, BANK(Func_5c32)
	jp SetEntityUpdateFunc

EntUpdate_NearbyDestinationArrow::
	ld a, [wGameMode]
	cp MODE_UNDERCOVER
	jr z, .loop
	jp DespawnEntity

.loop
	ld a, [wDestinationType]
	and a
	jr nz, .asm_5eae
	ld a, 1
	call YieldEntityUpdate
	jr .loop
.asm_5eae
	call AllocateSprite
	jr nc, .asm_5eba
	ld a, 1
	call YieldEntityUpdate
	jr .asm_5eae
.asm_5eba
	call GetEntityPtr
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
.asm_5ec2
	call .Func_5ed7
	ld a, 1
	call YieldEntityUpdate
	ld a, [wDestinationType]
	and a
	jr nz, .asm_5ec2
	call GetEntityCarPtr
	ld [hl], $00
	jr .loop

.Func_5ed7:
	ld a, [wDestinationType]
	cp DESTINATION_COORDINATE
	jr nz, .set_invisible
	ld a, [wd83c]
	and a
	jr nz, .set_invisible
	ld a, [wda82]
	and a
	jr nz, .set_invisible
	ld a, [wFrameCounter]
	and %1000
	jr nz, .set_invisible
	call Func_2dd5
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	call GetEntityCarPtr
	ld a, [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [hli], a
	inc hl
	ld [hl], e ; SPRITESTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	inc hl
	ld [hl], c ; SPRITESTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld a, 2 * TILE_WIDTH
	ld [hli], a ; SPRITESTRUCT_HEIGHT
	ld [hli], a ; SPRITESTRUCT_WIDTH
	ld a, $7a ; tile ID
	ld b, 2 | OAM_BANK1 ; attributes
	ld [hli], a ; SPRITESTRUCT_TILE_1
	ld [hl], b ; SPRITESTRUCT_ATTR_1
	inc hl
	inc a
	inc a
	; a = $7c
	ld [hli], a ; SPRITESTRUCT_TILE_2
	ld [hl], b ; SPRITESTRUCT_ATTR_2
	ret
.set_invisible
	call GetEntityCarPtr
	res SPRITEFLAG_VISIBLE_F, [hl]
	ret

EntUpdate_DestinationArrow::
	xor a
	ld [wd83c], a

	; if none of the following game modes, despawn
	ld a, [wGameMode]
	cp MODE_UNDERCOVER
	jr z, .wait_destination_loop
	cp MODE_PURSUIT
	jr z, .wait_destination_loop
	cp MODE_CHECKPOINT
	jr z, .wait_destination_loop
	jp DespawnEntity

; waits until destination type != NONE
.wait_destination_loop
	ld a, [wDestinationType]
	and a
	jr nz, .wait_allocate_sprite_loop
	ld a, 1
	call YieldEntityUpdate
	jr .wait_destination_loop

; wait until a sprite is allocated successfully
.wait_allocate_sprite_loop
	call AllocateSprite
	jr nc, .asm_5f56
	ld a, 1
	call YieldEntityUpdate
	jr .wait_allocate_sprite_loop

.asm_5f56
	call GetEntityPtr
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
.asm_5f5e
	call .Func_5f73
	ld a, 1
	call YieldEntityUpdate
	ld a, [wDestinationType]
	and a
	jr nz, .asm_5f5e
	call GetEntityCarPtr
	ld [hl], $00
	jr .wait_destination_loop

.Func_5f73:
	xor a
	ld [wd83c], a
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, CARSTRUCT_COORDS
	add hl, de
	ld de, wda23Coords
	ld b, $06
.asm_5f86
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_5f86

	call Func_2dd5
	xor a
	ld [wda59], a
	ld hl, wda23Y
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call HLMinusDE
	ld a, h
	or l
	jr z, .asm_5fb7
	bit 7, h
	jr z, .asm_5fb2
	ld a, $04
	ld [wda59], a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	jr .asm_5fb7
.asm_5fb2
	ld a, $01
	ld [wda59], a
.asm_5fb7
	ld d, h
	ld e, l
	ld hl, wda23X
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call HLMinusBC
	ld a, h
	or l
	jr z, .asm_5fe3
	bit 7, h
	jr z, .asm_5fdb
	ld a, [wda59]
	or $02
	ld [wda59], a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	jr .asm_5fe3
.asm_5fdb
	ld a, [wda59]
	or $08
	ld [wda59], a
.asm_5fe3
	ld b, h
	ld c, l

	ld l, FALSE
.asm_5fe7
	ld a, d
	or b
	jr z, .asm_5ff7
	ld l, TRUE
	srl d
	rr e
	srl b
	rr c
	jr .asm_5fe7
.asm_5ff7
	ld b, e ; y
	ld a, [wDestinationType]
	cp DESTINATION_COORDINATE
	jr nz, .asm_600a
	ld a, l
	and a
	jr nz, .asm_600a
	call CalculateEuclideanDistance
	cp 64
	jr c, .asm_605e
.asm_600a
	ld a, [wFrameCounter]
	and $08
	jr z, .set_invisible
	xor a
	ld [wdc7a], a
	call Func_2d66
	call .Func_6023
	jr .asm_6091
.set_invisible
	call GetEntityCarPtr
	res SPRITEFLAG_VISIBLE_F, [hl]
	ret

.Func_6023:
	add 23 deg
	push af
	and $e0
	call CalculateDirectionComponents
	ld h, b
	ld l, c
	call .Func_60d3
	ld b, h ; y offset
	ld c, $00
	ld h, d
	ld l, e
	call .Func_60d3
	ld d, h ; x offset
	ld e, $00
	ld hl, wda23
	call AddToCarCoordinates
	call GetCarCoordinates
	pop af
	swap a
	rrca
	and $07
	ret

.asm_604b
	ld a, $01
	ld [wd83c], a
	call Func_2dd5
	ld a, [wFrameCounter]
	rrca
	and $03
	add_de
	ld a, $08
	jr .asm_6091
.asm_605e
	ld l, a
	ld a, [wda82]
	and a
	jr nz, .asm_606b
	ld a, [wda97]
	and a
	jr nz, .asm_604b
.asm_606b
	ld a, l
	cp $0c
	jr c, .set_invisible
	ld a, $01
	ld [wdc7a], a
	push bc
	call Func_2dd5
	ld hl, wda23Y
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop bc
	call Func_2d66
	add 180 deg
	call .Func_6023
	add $04
	and $07
.asm_6091
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	push af
	call GetEntityCarPtr
	ld a, [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [hli], a
	inc hl
	ld [hl], e ; SPRITESTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	inc hl
	pop af
	ld e, a
	and $03
	jr nz, .asm_60b4
	ld a, $04
	add_bc
.asm_60b4
	ld [hl], c ; SPRITESTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld a, e
	add a
	ld e, a
	add a
	add e ; *6
	ld de, Data_6105
	add_de
	ld a, [de]
	inc de
	ld [hli], a ; SPRITESTRUCT_HEIGHT
	ld a, [de]
	inc de
	ld [hli], a ; SPRITESTRUCT_WIDTH
	ld a, [de]
	inc de
	ld [hli], a ; SPRITESTRUCT_TILE_1
	ld a, [de] ; SPRITESTRUCT_ATTR_1
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a ; SPRITESTRUCT_TILE_2
	ld a, [de]
	ld [hl], a ; SPRITESTRUCT_ATTR_2
	ret

.Func_60d3:
	push bc
	ld b, h
	ld c, l
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [wdc7a]
	and a
	jr z, .asm_60f3
	ld a, [wFrameCounter]
	and $0f
	push hl
	ld hl, Data_60f5
	add_hl
	ld a, [hl]
	pop hl
.asm_60ec
	and a
	jr z, .asm_60f3
	add hl, bc
	dec a
	jr .asm_60ec
.asm_60f3
	pop bc
	ret

Data_60f5:
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $07, $06, $05, $04, $03, $02, $01


MACRO? data_6105
	db \1 * TILE_HEIGHT ; height in tiles
	db \2 * TILE_WIDTH  ; width in tiles
	db \3, \4 ; tile ID, attribute
	IF _NARG == 6
		db \5, \6 ; tile ID, attribute
	ELSE
		db $00, $00
	ENDC
ENDM

Data_6105:
	data_6105 2, 1, $ea, 2 | OAM_BANK1                                                                     ; $0
	data_6105 2, 2, $ec, 2 | OAM_BANK1,                         $ee, 2 | OAM_BANK1                         ; $1
	data_6105 2, 2, $f0, 2 | OAM_BANK1,                         $f2, 2 | OAM_BANK1                         ; $2
	data_6105 2, 2, $ec, 2 | OAM_BANK1 | OAM_YFLIP,             $ee, 2 | OAM_BANK1 | OAM_YFLIP             ; $3
	data_6105 2, 1, $ea, 2 | OAM_BANK1 | OAM_YFLIP                                                         ; $4
	data_6105 2, 2, $ee, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP, $ec, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP ; $5
	data_6105 2, 2, $f2, 2 | OAM_BANK1 | OAM_XFLIP,             $f0, 2 | OAM_BANK1 | OAM_XFLIP             ; $6
	data_6105 2, 2, $ee, 2 | OAM_BANK1 | OAM_XFLIP,             $ec, 2 | OAM_BANK1 | OAM_XFLIP             ; $7
	data_6105 2, 1, $e8, 2 | OAM_BANK1                                                                     ; $8

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
	ld hl, Func_6186
	ld c, BANK(Func_6186)
	ld b, $09
	call SpawnEntity
	jr c, .asm_6182
	call AllocateSprite
	jr c, .asm_6180
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	ld h, d
	ld l, e
	pop de
	pop bc
	set SPRITEFLAG_FIXED_F, [hl]
	inc hl
	ld [hl], $00 ; SPRITESTRUCT_UNK01
	inc hl
	ld [hl], e ; SPRITESTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	ld [hl], $00 ; SPRITESTRUCT_UNK04
	inc hl
	ld [hl], c ; SPRITESTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld [hl], 2 * TILE_HEIGHT ; SPRITESTRUCT_HEIGHT
	inc hl
	ld [hl], TILE_WIDTH ; SPRITESTRUCT_WIDTH
	ld a, SPRITESTRUCT_UNK0D - SPRITESTRUCT_WIDTH
	add_hl
	pop af
	ld [hli], a ; SPRITESTRUCT_UNK0D
	ret
.asm_6180
	ld [hl], $00
.asm_6182
	pop de
	pop bc
	pop af
	ret

Func_6186:
	call GetEntityCarPtr
	set CARFLAG_PLAYER_F, [hl]
	call Random
	and $03
	add $02
	ld c, a
	ld a, CARSTRUCT_SPEED + 1
	call SetStructByte_C
	ld b, $00
	ld a, CARSTRUCT_0F
	call SetStructWord_BC
	ld a, CARSTRUCT_SPEED
	call GetStructByte_A
	push hl
	call CalculateDirectionComponents
	ld h, b
	ld l, c
	call Func_6239
	ld b, h
	ld c, l
	ld h, d
	ld l, e
	call Func_6239
	ld d, h
	ld e, l
	pop hl
	call .Func_6228
	ld a, CARSTRUCT_SPEED
	call GetStructByte_A
	push hl
	call CalculateDirectionComponents
	call Random
	and $03
	jumptable
	dw .Func_61e6
	dw .Func_61ee
	dw .Func_61d1
	dw .Func_61ee

.Func_61d1:
.asm_61d1
	pop hl
.asm_61d2
	call .Func_6213
	ld a, 1
	call YieldEntityUpdate
	bit CARFLAG_UNK3_F, [hl]
	jr nz, .asm_61f8
	call .Func_61fd
	call .Func_6228
	jr .asm_61d2
.Func_61e6:
	sra d
	rr e
	sra b
	rr c
.Func_61ee:
	sra d
	rr e
	sra b
	rr c
	jr .asm_61d1

.asm_61f8
	ld [hl], $00
	jp DespawnEntity

.Func_61fd:
	push hl
	ld a, CARSTRUCT_SPEED + 1
	add_hl
	ld a, [hl]
	inc hl
	dec [hl] ; CARSTRUCT_0F
	jr nz, .asm_620e
	ld [hl], a
	inc hl
	inc [hl]
	ld a, [hl]
	cp $04
	jr nc, .asm_6210
.asm_620e
	pop hl
	ret
.asm_6210
	pop hl
	jr .asm_61f8

.Func_6213:
	push de
	ld d, h
	ld e, l
	ld a, CARSTRUCT_X_FRAC
	add_de
	ld a, CARSTRUCT_10
	call GetStructByte_A
	add a ; *2
	add $72
	ld [de], a
	inc de
	ld a, $08
	ld [de], a
	pop de
	ret

.Func_6228:
	push bc
	push de
	push de
	ld a, CARSTRUCT_01
	call AddBCToStructField
	pop bc
	ld a, CARSTRUCT_04
	call AddBCToStructField
	pop de
	pop bc
	ret

Func_6239:
	add hl, hl
	add hl, hl
	add hl, hl
	ret

; input:
; - a  = direction
; - bc = x coordinate
; - de = y coordinate
SpawnBoatSplash:
	push af
	ld hl, -4
	add hl, bc
	ld b, h
	ld c, l
	ld hl, -4
	add hl, de
	ld d, h
	ld e, l

	push bc
	push de
	ld hl, EntUpdate_BoatSplash
	ld c, BANK(EntUpdate_BoatSplash)
	ld b, $10
	call SpawnEntity
	jr c, .asm_6284
	call AllocateSprite
	jr c, .asm_6282
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	ld h, d
	ld l, e
	pop de
	pop bc

	set SPRITEFLAG_FIXED_F, [hl]
	inc hl
	ld [hl], $00 ; SPRITESTRUCT_UNK01
	inc hl
	ld [hl], e ; SPRITESTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	ld [hl], $00 ; SPRITESTRUCT_UNK04
	inc hl
	ld [hl], c ; SPRITESTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld [hl], 2 * TILE_HEIGHT ; SPRITESTRUCT_HEIGHT
	inc hl
	ld [hl], TILE_WIDTH ; SPRITESTRUCT_WIDTH
	ld a, SPRITESTRUCT_UNK0D - SPRITESTRUCT_WIDTH
	add_hl
	pop af
	ld [hli], a ; SPRITESTRUCT_UNK0D
	ret
.asm_6282
	ld [hl], $00
.asm_6284
	pop de
	pop bc
	pop af
	ret

EntUpdate_BoatSplash:
	call GetEntityCarPtr
	set SPRITEFLAG_VISIBLE_F, [hl]
	call Random
	and $03
	add $04
	ld c, a
	; c = random integer in range [4, 7]
	ld a, SPRITESTRUCT_UNK0E
	call SetStructByte_C
	ld b, $00
	ld a, CARSTRUCT_0F
	call SetStructWord_BC

	ld a, SPRITESTRUCT_UNK0D
	call GetStructByte_A
	push hl
	call CalculateDirectionComponents
	ld h, b
	ld l, c
	call .MultiplyHLBy8
	ld b, h
	ld c, l
	ld h, d
	ld l, e
	call .MultiplyHLBy8
	ld d, h
	ld e, l
	pop hl
	call .AddOffsetToCoordinates

	ld a, SPRITESTRUCT_UNK0D
	call GetStructByte_A
	push hl
	call CalculateDirectionComponents

	; modify speed randomly
	call Random
	maskbits 4
	jumptable
	dw .QuarterSpeed
	dw .HalveSpeed
	dw .FullSpeed
	dw .HalveSpeed

.FullSpeed:
	pop hl
.update_loop
	call .SetTileAndAttributes
	ld a, 1
	call YieldEntityUpdate
	bit SPRITEFLAG_UNK3_F, [hl]
	jr nz, .despawn
	call .UpdateAnimation
	call .AddOffsetToCoordinates
	jr .update_loop

.QuarterSpeed:
	sra d
	rr e
	sra b
	rr c
.HalveSpeed:
	sra d
	rr e
	sra b
	rr c
	jr .FullSpeed
.despawn
	ld [hl], $00
	jp DespawnEntity

.UpdateAnimation:
	push hl
	ld a, SPRITESTRUCT_UNK0E
	add_hl
	ld a, [hl]
	inc hl
	dec [hl] ; SPRITESTRUCT_UNK0F
	jr nz, .asm_6310
	ld [hl], a
	inc hl
	inc [hl]
	ld a, [hl]
	cp $04
	jr nc, .pop_hl_and_despawn
.asm_6310
	pop hl
	ret
.pop_hl_and_despawn
	pop hl
	jr .despawn

.SetTileAndAttributes:
	push de
	ld d, h
	ld e, l
	ld a, SPRITESTRUCT_TILE_1
	add_de
	ld a, SPRITESTRUCT_UNK10
	call GetStructByte_A
	add a ; *2
	add $dc
	ld [de], a ; SPRITESTRUCT_TILE_1
	inc de
	ld a, 3 | OAM_BANK1
	ld [de], a ; SPRITESTRUCT_ATTR_1
	pop de
	ret

; input:
; - bc = x offset
; - de = y offset
.AddOffsetToCoordinates:
	push bc
	push de
	push de
	ld a, SPRITESTRUCT_UNK01
	call AddBCToStructField
	pop bc
	ld a, SPRITESTRUCT_UNK04
	call AddBCToStructField
	pop de
	pop bc
	ret

.MultiplyHLBy8:
	add hl, hl
	add hl, hl
	add hl, hl
	ret

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
	ld a, 8 ; number of particles
.loop
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
	jr nz, .loop
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
	call AllocateSprite
	jr c, .asm_6394
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	ld h, d
	ld l, e
	inc hl
	xor a
	pop de
	ld [hli], a ; SPRITESTRUCT_UNK01
	ld [hl], e ; SPRITESTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	pop bc
	ld [hli], a ; SPRITESTRUCT_UNK04
	ld [hl], c ; SPRITESTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld [hl], 2 * TILE_HEIGHT ; SPRITESTRUCT_HEIGHT
	inc hl
	ld [hl],  TILE_WIDTH ; SPRITESTRUCT_WIDTH
	ld a, SPRITESTRUCT_UNK0D - SPRITESTRUCT_WIDTH
	add_hl
	pop bc
	ld [hl], c ; SPRITESTRUCT_UNK0D
	inc hl
	ld [hl], b ; SPRITESTRUCT_UNK0E
	ret
.asm_6394
	pop de
	pop bc
	pop hl
	ret

Func_6398:
	call GetEntityCarPtr
	ld a, [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [hl], a
	ld a, SPRITESTRUCT_UNK0D
	add_hl
	call Random
	ld b, a
	and $1f
	bit 7, b
	jr z, .got_angle
	cpl
	inc a
.got_angle
	; a = random angle between [-44, 44] deg
	add [hl]
	ld [hli], a ; SPRITESTRUCT_UNK0D

	call Random
	and $07
	add [hl]
	; a = random number between [0.0q4, 0.43q4]
	ld [hli], a ; SPRITESTRUCT_UNK0E

	call Random
	and $07
	add $08
	; a = random number between [8, 15]
	ld [hli], a ; SPRITESTRUCT_UNK0F

	call Random
	and $03
	; a = random number between [0, 3]
	ld [hl], a ; SPRITESTRUCT_UNK10

.loop
	call .ApplyVelocity
	call .Func_6409
	jr c, .despawn
	call .UpdateSprite
	ld a, 1
	call YieldEntityUpdate
	jr .loop
.despawn
	call GetEntityCarPtr
	ld [hl], $00
	jp DespawnEntity

.ApplyVelocity:
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_UNK0D
	add_hl
	ld a, [hli] ; SPRITESTRUCT_UNK0D
	push hl
	call CalculateDirectionComponents
	pop hl

	ld a, [hl] ; SPRITESTRUCT_UNK0E
	push bc
	ld b, d
	ld c, e
	push af
	call CalculateSpeedComponent
	pop af
	ld d, b
	ld e, c
	pop bc
	call CalculateSpeedComponent

	; apply speed
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_UNK01
	push de
	call AddBCToStructField
	pop bc
	ld a, CARSTRUCT_04
	jp AddBCToStructField

.Func_6409:
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_UNK0F
	add_hl
	ld a, [hli]
	add [hl]
	ld [hl], a
	ret

.UpdateSprite:
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_UNK10
	add_hl
	ld a, [hl]
	swap a
	rrca
	rrca
	and $03
	add a
	add $c8
	ld c, a
	ld a, SPRITESTRUCT_UNK10 - SPRITESTRUCT_TILE_1
	sub_hl
	ld [hl], c ; SPRITESTRUCT_TILE_1
	inc hl
	ld [hl], 3 | OAM_BANK1 ; SPRITESTRUCT_ATTR_1
	ret

Func_642c::
	ld a, [wd820]
	cp $01
	ret nz
	ld a, [wDamage]
	cp MAX_DAMAGE
	ret c
	; got maximum amount of damage
	ld a, $0b
	call FindEntity
	ld de, Func_6446
	ld a, BANK(Func_6446)
	call OverwriteEntityUpdateFunc
	ret

Func_6446:
	call Func_6563
	ld a, [wGameMode]
	cp MODE_UNDERCOVER
	jr nz, .generic_text
	; some mission have special text
	ld hl, YouDamagedTheCarTexts
	ld a, [wMission]
	cp MISSION_SUPERFLY_DRIVE
	jp z, SetMissionFailed
	ld hl, TheCarsTooBeatUpTexts
	cp MISSION_STEAL_A_COP_CAR
	jp z, SetMissionFailed
.generic_text
	ld hl, YouWreckedYourCarTexts
	ld c, 90
	call ShowHUDMessage

	ld a, [wGameMode]
	cp MODE_SURVIVAL
	jr z, .asm_6484
	ld a, $01
	ld [wTitlescreenTransition], a
	ld a, MUSIC_MISSION_FAILED
	call PlayMusic
	ld de, Func_64e2
	ld a, BANK(Func_64e2)
	jp SetEntityUpdateFunc

.asm_6484
	ld a, [wHUDMessageStep]
	and a
	jr z, .asm_6491
	ld a, 1
	call YieldEntityUpdate
	jr .asm_6484
.asm_6491
	ld de, Func_64b4
	ld a, BANK(Func_64b4)
	jp SetEntityUpdateFunc

Func_6499:
	call Func_6563
	ld hl, WellDoneTexts
	ld c, 60
	call ShowHUDMessage
.asm_64a4
	ld a, 1
	call YieldEntityUpdate
	ld a, [wHUDMessageStep]
	and a
	jr nz, .asm_64a4
	jr Func_64b4

Func_64b1:
	call Func_6563
;	fallthrough

Func_64b4:
	call Func_6504
	call Func_651b
	jr nc, .asm_64d0
	ld a, $02
	ld [wTitlescreenTransition], a
	ld hl, NewBestTimeTexts
	ld c, 90
	call ShowHUDMessage
	ld a, MUSIC_MISSION_COMPLETE
	call PlayMusic
	jr Func_64e2

.asm_64d0
	ld a, $01
	ld [wTitlescreenTransition], a
	ld hl, RaceOverTexts
	ld c, 90
	ld a, MUSIC_MISSION_FAILED
	call PlayMusic
	call ShowHUDMessage

Func_64e2:
.loop
	ld a, [wd83f]
	cp $02
	jr nz, .asm_64ef
	ld a, [wHUDMessageStep]
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

Func_6504:
	ld hl, wTimerMode
	ld c, [hl]
	ld b, $08
.asm_650a
	ld [hl], $00
	ld a, $04
	call YieldEntityUpdate
	ld [hl], c
	ld a, $04
	call YieldEntityUpdate
	dec b
	jr nz, .asm_650a
	ret

Func_651b:
	ld a, [wGameMode]
	cp MODE_SURVIVAL
	jr nz, .asm_6531
	ld a, [wd88e]
	cp $aa
	jr z, .asm_6551
	ld hl, wd88e
	ld de, wTimer + 2
	jr .asm_6537
.asm_6531
	ld hl, wTimer + 2
	ld de, wd88e
.asm_6537
	ld a, [de]
	cp [hl]
	jr c, .asm_6561
	jr z, .asm_653f
	jr .asm_6551
.asm_653f
	dec hl
	dec de
	ld a, [de]
	cp [hl]
	jr c, .asm_6561
	jr z, .asm_6549
	jr .asm_6551
.asm_6549
	dec hl
	dec de
	ld a, [de]
	cp [hl]
	jr c, .asm_6561
	jr z, .asm_6561
.asm_6551
	ld hl, wTimer
	ld de, wd88c
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	scf
	ret
.asm_6561
	and a
	ret

Func_6563:
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	ld a, $02
	ld [wd820], a
	call Func_6575
	jp Func_68b8

Func_6575:
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_ENT_PTR
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, Func_408f
	ld a, BANK(Func_408f)
	call OverwriteEntityUpdateFunc
	ld a, $01
	ld [wd83f], a
	ret

Func_658f:
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_ENT_PTR
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, EntUpdate_PlayerCar
	ld a, BANK(EntUpdate_PlayerCar)
	call OverwriteEntityUpdateFunc
	ld a, $00
	ld [wd83f], a
	ret

EntUpdate_PlayerDamageController_TakeARide::
	call YieldEntityUpdateUntilFadeEnds
	ld a, $01
	ld [wd820], a
	jp YieldEntityUpdateIndefinitely

EntUpdate_PlayerDamageController_Checkpoint::
	call YieldEntityUpdateUntilFadeEnds
	ld hl, Func_667a
	ld c, BANK(Func_667a)
	ld b, $0c
	call SpawnEntity
	ld a, $06
	add_hl
	ld [hl], $5a
.asm_65c6
	ld a, 1
	call YieldEntityUpdate
	ld a, [wd820]
	cp $01
	jr nz, .asm_65c6
	ld a, TIMER_MODE_COUNT_UP
	ld bc, $0_00
	call StartTimer
	ld hl, Func_6620
	ld c, BANK(Func_6620)
	ld b, $0d
	call SpawnEntity
.asm_65e4
	ld hl, wd83d
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd892]
	add a
	add a
	add_hl
	ld de, wDestinationType
	ld a, DESTINATION_COORDINATE
	ld [de], a
	ld b, $04
.asm_65f8
	inc de
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .asm_65f8
.asm_65fe
	call HasReachedDestination
	jr c, .asm_6619
	ld a, SFX_2C
	call PlaySFX
	ld hl, wd892
	inc [hl]
	ld a, [hl]
	cp $06
	jr nz, .asm_65e4
	ld de, Func_64b1
	ld a, BANK(Func_64b1)
	jp SetEntityUpdateFunc
.asm_6619
	ld a, 1
	call YieldEntityUpdate
	jr .asm_65fe

Func_6620:
	call AllocateSprite
	ld h, d
	ld l, e
	push hl
	ld a, [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [hl], a
	ld a, SPRITESTRUCT_HEIGHT
	add_hl
	ld [hl], $10
	inc hl
	ld [hl], $10
	pop hl
.asm_6633
	call Func_2dd5
	jr c, .asm_663c
	res SPRITEFLAG_VISIBLE_F, [hl]
	jr .asm_6659
.asm_663c
	set SPRITEFLAG_VISIBLE_F, [hl]
	call .Func_6660
	push hl
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, $05
	call SetStructWord_BC
	ld a, $02
	call SetStructWord_DE
.asm_6659
	ld a, 1
	call YieldEntityUpdate
	jr .asm_6633

.Func_6660:
	push hl
	ld a, $09
	add_hl
	ld a, [wFrameCounter]
	rrca
	rrca
	and $03
	add a
	add a
	add $ca
	ld [hli], a
	ld [hl], $0a
	inc hl
	inc a
	inc a
	ld [hli], a
	ld [hl], $0a
	pop hl
	ret

Func_667a:
	call GetEntityPtr
	ld a, $06
	add_hl
	ld c, [hl]
	call AllocateSprite
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld [hl], $38
	inc hl
	inc hl
	inc hl
	ld [hl], $4c
	inc hl
	inc hl
	ld [hl], $10
	inc hl
	ld [hl], $08
	inc hl
	ld a, c
	add $88
	ld [hli], a
	ld [hl], $0a
	dec hl
	ld b, $03
.asm_66a0
	ld a, [de]
	or $02
	ld [de], a
	call .Func_66f5
	ld a, $0f
	call YieldEntityUpdate
	ld a, [de]
	and $fd
	ld [de], a
	ld a, $0f
	call YieldEntityUpdate
	dec [hl]
	dec [hl]
	dec b
	jr nz, .asm_66a0
	ld a, $01
	ld [wd820], a
	ld h, d
	ld l, e
	ld a, $05
	add_hl
	ld [hl], $48
	ld a, $03
	add_hl
	ld [hl], $10
	inc hl
	ld a, c
	add $80
	ld [hli], a
	ld [hl], $0a
	inc hl
	inc a
	inc a
	ld [hli], a
	ld [hl], $0a
	ld h, d
	ld l, e
	ld b, $03
.asm_66dc
	set 1, [hl]
	call .Func_66f5
	ld a, $07
	call YieldEntityUpdate
	res 1, [hl]
	ld a, $07
	call YieldEntityUpdate
	dec b
	jr nz, .asm_66dc
	ld [hl], $00
	jp DespawnEntity

.Func_66f5:
	ld a, SFX_2D
	jp Func_f1f

EntUpdate_PlayerDamageController_GetAway::
	call YieldEntityUpdateUntilFadeEnds
	ld hl, LoseTheTailTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld a, TIMER_MODE_COUNT_UP
	ld bc, $0_00
	call StartTimer
	ld a, $01
	ld [wd820], a
	ld a, $15
	call YieldEntityUpdate
	ld a, $01
	ld [wda7b], a
.asm_671f
	ld a, 1
	call YieldEntityUpdate
	ld a, [wda55]
	and a
	jr nz, .asm_671f
	ld de, Func_6499
	ld a, BANK(Func_6499)
	jp SetEntityUpdateFunc

EntUpdate_PlayerDamageController_Pursuit::
	call YieldEntityUpdateUntilFadeEnds
	ld hl, RamHimTexts
	ld c, 90
	call ShowHUDMessage
	ld a, $3c
	call YieldEntityUpdate
	ld a, $01
	ld [wda7b], a
	call WaitHUDMessage
	ld a, TIMER_MODE_COUNT_UP
	ld bc, $0_00
	call StartTimer
	ld a, $01
	ld [wd820], a
.asm_6757
	ld a, 1
	call YieldEntityUpdate
	call .Func_679c
	call .Func_6764
	jr .asm_6757

.Func_6764:
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wDestinationTargetPtr + 0]
	ld e, a
	ld a, [wDestinationTargetPtr + 1]
	ld d, a
	call Func_275f
	ld hl, $128
	ld a, h
	cp b
	jr nz, .asm_677e
	ld a, l
	cp c
.asm_677e
	ret nc
	call Func_6563
	ld a, $01
	ld [wTitlescreenTransition], a
	ld hl, YouLostHimTexts
	ld c, 90
	call ShowHUDMessage
	ld a, MUSIC_MISSION_FAILED
	call PlayMusic
	ld de, Func_64e2
	ld a, BANK(Func_64e2)
	jp SetEntityUpdateFunc

.Func_679c:
	ld a, [wd86c]
	cp $38
	ret c
	ld de, Func_6499
	ld a, BANK(Func_6499)
	jp SetEntityUpdateFunc

EntUpdate_PlayerDamageController_Survival::
	ld a, 2
	ld [wMaxNumNPCCars], a
	call YieldEntityUpdateUntilFadeEnds
	ld hl, ItsTheCopsGetOutOfHereTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld a, TIMER_MODE_COUNT_UP
	ld bc, $0_00
	call StartTimer
	ld a, $01
	ld [wd820], a
	ld a, $1e
	call YieldEntityUpdate
	ld a, 5
	ld [wMaxNumNPCCars], a
	ld hl, Data_1f4f
	call Func_1eda
	jp YieldEntityUpdateIndefinitely

WaitHUDMessage:
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wHUDMessageStep]
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

; input:
; - hl = coordinate data (x and y)
SetDestinationCoords:
	ld de, wDestinationType
	ld a, DESTINATION_COORDINATE
	ld [de], a
	ld b, $2 + $2
.loop_copy
	inc de
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .loop_copy
	ret

; returns nc if destination has been reached
; i.e. player is within 12 pixels from wDestinationCoords
HasReachedDestination:
	call GetDistanceToDestination
	ld a, 12
	cp c
	ret c ; x distance > 12
	cp b
	ret c ; y distance > 12
	call CalculateEuclideanDistance
	ld c, a
	ld a, 12
	cp c
	ret

HasReachedDestinationWithoutTail:
	xor a
	ld [wd837], a
	ld hl, wda9a
	ld a, [hl]
	and a
	jr z, .asm_6822
	dec [hl]
.asm_6822
	call GetDistanceToDestination
	ld a, 64
	cp c
	jr c, .over_64_px_away
	cp b
	jr c, .over_64_px_away
	ld a, $01
	ld [wd837], a
	call CalculateEuclideanDistance
	ld c, a

	; exit if distance >= 64
	ld a, 64
	cp c
	ret c

	push bc
	call .Func_685a
	pop bc

	; exit if distance >= 12
	ld a, 12
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
.over_64_px_away
	ld a, $fe
	cp c
	ret c
	cp b
	ret c
	ld a, $01
	ld [wd837], a
	jr .asm_684b

.Func_685a:
	ld a, [wda97]
	and a
	ret z
	ld a, [wHUDMessageStep]
	and a
	ret nz
	ld hl, wda9a
	ld a, [hl]
	and a
	ret nz
	ld a, SFX_20
	call PlaySFX
	ld [hl], 180 ; wda9a
	ld hl, LoseTheTailTexts
	ld c, 60
	jp ShowHUDMessage

Func_6879:
	call Func_68b8
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	call Func_6575
	jp Func_67e9

GetDistanceToDestination:
	ld hl, wDestinationCoords
	ld de, wda23X
	ld a, [hli] ; wDestinationX
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld de, wda23Y
	ld a, [hli] ; wDestinationY
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wda23
	jp Func_27e5

; input:
; - hl = pointer to seconds and minutes
StartCountDownTimer:
	ld a, TIMER_MODE_COUNT_DOWN
	ld c, [hl] ; seconds
	inc hl
	ld b, [hl] ; minutes
	jp StartTimer

; starts count up timer, starts at 0:00
StartCountUpTimer:
	ld a, TIMER_MODE_COUNT_UP
	ld bc, $0_00
	jp StartTimer

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

	ld c, 90
	ld a, h
	or l
	jr z, .asm_68e1
	ld c, 45
	call ShowHUDMessage
	call WaitHUDMessage
	ld c, 45
.asm_68e1
	ld hl, MissionFailedTexts
	call ShowHUDMessage

	ld a, $01
	ld [wTitlescreenTransition], a
	ld de, Func_64e2
	ld a, BANK(Func_64e2)
	jp SetEntityUpdateFunc

SetMissionComplete:
	ld a, $02
	ld [wd820], a

	ld a, MUSIC_MISSION_COMPLETE
	call PlayMusic

	ld c, 90
	ld a, h
	or l
	jr z, .asm_690e
	ld c, 45
	call ShowHUDMessage
	call WaitHUDMessage
	ld c, 45
.asm_690e
	ld hl, MissionCompleteTexts
	call ShowHUDMessage

	ld a, $02
	ld [wTitlescreenTransition], a
	ld de, Func_64e2
	ld a, BANK(Func_64e2)
	jp SetEntityUpdateFunc

LoadMission::
	ld hl, MissionLoadPointerTable
	jr Func_692b
Func_6926::
	ld hl, Data_6967
	jr Func_692b ; useless jump
Func_692b:
	ld d, h
	ld e, l
.test_mission
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
	; iterate missions until valid pointer is found
	ld hl, wMission
	inc [hl]
	ld h, d
	ld l, e
	jr .test_mission

MissionLoadPointerTable:
	table_width 2
	dw Func_6985 ; MISSION_THE_BANK_JOB
	dw Func_6a6a ; MISSION_HIDE_THE_EVIDENCE
	dw Func_6ad5 ; MISSION_BOAT_CHASE
	dw Func_6e49 ; MISSION_RAM_RAID_RACE
	dw Func_6f05 ; MISSION_SUPERFLY_DRIVE
	dw Func_6f7b ; MISSION_BAIT_FOR_A_TRAP
	dw Func_711a ; MISSION_TAKE_OUT_DIANGELO
	dw Func_71d2 ; MISSION_STEAL_A_COP_CAR
	dw Func_725e ; MISSION_GET_LUCKY_TO_THE_DOCS
	dw Func_7331 ; MISSION_BEVERLY_HILLS_GET_AWAY
	dw Func_7460 ; MISSION_GRAND_CENTRAL_STATION
	dw Func_764a ; MISSION_TRASH_GRANGERS_WHEELS
	dw Func_775c ; MISSION_STOP_GRANGERS_GANG
	dw Func_7875 ; MISSION_CHASE_ONE_OF_GRANGERS_BOYS
	dw Func_796b ; MISSION_CROSS_TOWN_RECORD
	assert_table_length NUM_MISSIONS

Data_6967:
	table_width 2
	dw Func_6997 ; MISSION_THE_BANK_JOB
	dw Func_6a83 ; MISSION_HIDE_THE_EVIDENCE
	dw Func_6ae7 ; MISSION_BOAT_CHASE
	dw Func_6e5b ; MISSION_RAM_RAID_RACE
	dw Func_6f1e ; MISSION_SUPERFLY_DRIVE
	dw Func_6f8d ; MISSION_BAIT_FOR_A_TRAP
	dw Func_712c ; MISSION_TAKE_OUT_DIANGELO
	dw Func_71eb ; MISSION_STEAL_A_COP_CAR
	dw Func_7277 ; MISSION_GET_LUCKY_TO_THE_DOCS
	dw Func_7343 ; MISSION_BEVERLY_HILLS_GET_AWAY
	dw Func_7475 ; MISSION_GRAND_CENTRAL_STATION
	dw Func_765c ; MISSION_TRASH_GRANGERS_WHEELS
	dw Func_776e ; MISSION_STOP_GRANGERS_GANG
	dw Func_788e ; MISSION_CHASE_ONE_OF_GRANGERS_BOYS
	dw Func_7984 ; MISSION_CROSS_TOWN_RECORD
	assert_table_length NUM_MISSIONS

Func_6985:
	call ChooseCarPool_WithCop
	ld a, MIAMI
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_TheBankJob
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_6997:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	call LoadPersonGfx
	ld hl, EntUpdate_MissionController_TheBankJob
	ld c, BANK(EntUpdate_MissionController_TheBankJob)
	ld b, $0b
	call SpawnEntity
	ret

EntUpdate_MissionController_TheBankJob:
	call YieldEntityUpdateUntilFadeEnds

	ld hl, GetToTheBankTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage

	ld a, $01
	ld [wd820], a

	ld hl, DestinationCoords_TheBankJob_1
	call SetDestinationCoords

	ld hl, Timer_TheBankJob
	call StartCountDownTimer

.bank_loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .too_late
	call HasReachedDestination
	jr nc, .reached_bank
	jr .bank_loop

.reached_bank
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	call Func_6575
	call Func_67e9
	ld hl, Data_7ebb
	call ShowThreePeopleGettingIntoPlayersCar

	ld hl, GetToTheLockUpTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage

	call Func_658f
	call StartCountUpTimer

	ld hl, DestinationCoords_TheBankJob_2
	call SetDestinationCoords

	ld a, 14
	call IncreaseFelony
	ld hl, Data_1f37
	call Func_1eda

	xor a
	ld [wda9a], a
.lock_up_loop
	ld a, 1
	call YieldEntityUpdate
	call HasReachedDestinationWithoutTail
	jr c, .lock_up_loop
	call Func_6879
	ld hl, Data_7ec3
	call ShowThreePeopleGettingOutOfPlayersCar
	ld hl, NULL
	jp SetMissionComplete

.too_late
	ld hl, TooLateTexts
	jp SetMissionFailed

ShowThreePeopleGettingIntoPlayersCar:
	ld b, 3
.loop_persons
	push bc
	push hl
	call SpawnPerson_GettingIntoPlayersCar
	pop hl
	pop bc

	; wait between 24 and 39 frames
	call Random
	and $0f
	add 24
	call YieldEntityUpdate

	dec b
	jr nz, .loop_persons
	jp WaitForPersonToDespawn

ShowThreePeopleGettingOutOfPlayersCar:
	ld b, 3
.loop_persons
	push bc
	push hl
	call SpawnPerson_GettingOutOfPlayersCar
	pop hl
	pop bc

	; wait between 24 and 39 frames
	call Random
	and $0f
	add 24
	call YieldEntityUpdate

	dec b
	jr nz, .loop_persons
	jp WaitForPersonToDespawn

Func_6a6a:
	call ChooseCarPool_WithCop
	ld a, MIAMI
	call SetCity
	ld a, RED_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_RED
	ld [wPlayerCarOBPal], a
	ld hl, PlayerSpawnParams_HideTheEvidence
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_6a83:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	ld hl, EntUpdate_MissionController_HideTheEvidence
	ld c, BANK(EntUpdate_MissionController_HideTheEvidence)
	ld b, $0b
	call SpawnEntity
	ret

EntUpdate_MissionController_HideTheEvidence:
	call YieldEntityUpdateUntilFadeEnds

	ld hl, GoToTheBreakersTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage

	ld a, $01
	ld [wd820], a

	ld hl, DestinationCoords_HideTheEvidence
	call SetDestinationCoords

	call StartCountUpTimer
	ld a, 14
	call IncreaseFelony
	ld hl, Data_1f37
	call Func_1eda

	xor a
	ld [wda9a], a

.loop
	ld a, 1
	call YieldEntityUpdate
	call HasReachedDestinationWithoutTail
	jr c, .loop
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

Func_6ad5:
	call ChooseCarPool_WithCop
	ld a, MIAMI
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_BoatChase
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_6ae7:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	call Func_7bd4
	xor a
	ld [wda7b], a

	ld hl, EntUpdate_MissionController_BoatChase
	ld c, BANK(EntUpdate_MissionController_BoatChase)
	ld b, $0b
	call SpawnEntity

	ld hl, EntUpdate_Boat
	ld c, BANK(EntUpdate_Boat)
	ld b, $0f
	call SpawnEntity
	ret

EntUpdate_MissionController_BoatChase:
	call YieldEntityUpdateUntilFadeEnds

	ld hl, WeNeedThatKeyTexts
	ld c, 90
	call ShowHUDMessage

	ld a, 86
	call YieldEntityUpdate

	ld a, $01
	ld [wda7b], a
	ld a, 4
	call YieldEntityUpdate

	ld a, $01
	ld [wd820], a

	ld hl, Timer_BoatChase
	call StartCountDownTimer

	ld a, DESTINATION_SPRITE
	ld [wDestinationType], a
.chase_loop
	call .Func_6b8a
	ld a, b
	cp $02
	jr nc, .lost_him
	ld a, [wTimerActive]
	and a
	jr z, .lost_him
	call .Func_6b73
	jr c, .set_destination_point
	ld a, 1
	call YieldEntityUpdate
	jr .chase_loop

.set_destination_point
	ld hl, DestinationCoords_BoatChase
	call SetDestinationCoords
	xor a
	ld [wda9a], a
.destination_point_loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .too_late
	call HasReachedDestinationWithoutTail
	jr c, .destination_point_loop
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

.Func_6b73:
	ld hl, .data
	ld de, wdc7a
	ld b, $08
	call CopyHLtoDE
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetCarCoordinates
	jp IsWithinRectangle

.Func_6b8a:
	ld hl, wDestinationSpritePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, SPRITESTRUCT_UNK01
	add_hl
	ld de, wda23Coords
	ld b, $06
	call CopyHLtoDE
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wda23
	jp Func_275f

.lost_him
	ld hl, YouLostHimTexts
	jp SetMissionFailed

.too_late
	ld hl, TooLateTexts
	jp SetMissionFailed

.data
	dw 5128, 64
	dw 5024, 64

EntUpdate_Boat:
	call GetEntityPtr
	call AllocateSprite
	ld a, e
	ld [wDestinationSpritePtr + 0], a
	ld a, d
	ld [wDestinationSpritePtr + 1], a
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	ld h, d
	ld l, e

	push hl
	ld hl, Data_7ed7
	ld c, [hl] ; x
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl] ; y
	inc hl
	ld d, [hl]
	ld hl, -8
	add hl, bc
	ld b, h
	ld c, l
	ld hl, -8
	add hl, de
	ld d, h
	ld e, l
	pop hl
	push hl
	ld a, [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [hli], a
	xor a
	ld [hli], a ; SPRITESTRUCT_UNK01
	ld [hl], e ; SPRITESTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	ld [hli], a ; SPRITESTRUCT_UNK04
	ld [hl], c ; SPRITESTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld a, 2 * TILE_WIDTH
	ld [hli], a ; SPRITESTRUCT_HEIGHT
	ld [hl], a ; SPRITESTRUCT_WIDTH
	pop hl

	xor a
	ld [wBoatSpeed], a
	ld a, 0 deg
	ld [wBoatDirection], a
	call .UpdateSprite

	call GetEntityCarPtr
	ld a, SPRITESTRUCT_Y
	add_hl
.asm_6c0f
	ld a, 14
	call .Func_6c33
	inc [hl]
	ld a, 8
	call .Func_6c33
	inc [hl]
	ld a, 14
	call .Func_6c33
	dec [hl]
	ld a, 8
	call .Func_6c33
	dec [hl]
	call Random
	and %11111
	add 32
	; a = random integer in [32, 63]
	call .Func_6c33
	jr .asm_6c0f

.Func_6c33:
	ld b, a
.asm_6c34
	ld a, 1
	call YieldEntityUpdate
	ld a, [wda7b]
	and a
	jr nz, .asm_6c43
	dec b
	jr nz, .asm_6c34
	ret

.asm_6c43
	pop hl
	ld a, 0.5q4
	ld [wBoatSpeed], a
	ld a, -1
	ld [wBoatWaypoint], a
.next_waypoint
	ld hl, wBoatWaypoint
	inc [hl]
	call .GetWaypoint
	jr z, .finished_waypoints
.move_towards_waypoint_loop
	ld a, 1
	call YieldEntityUpdate
	call .Func_6d24
	call .GetDirectionComponentsTowardsWaypoint
	jr nc, .next_waypoint
	call Func_2d66
	call .UpdateDirectionAndSpeed
	call .ApplyVelocity
	call .UpdateSprite
	jr .move_towards_waypoint_loop

.finished_waypoints
	; we finished the trip, turn to 90 deg
	; and speed down to a complete stop
	ld a, 90 deg
	ld [wBoatDirection], a
	ld a, 3.20q4
	ld [wBoatSpeed], a
.stopping_loop
	call .ApplyVelocity
	call .UpdateSprite
	; speed down gradually
	ld hl, wBoatSpeed
	ld a, [hl]
	and a
	jr z, .stopped
	dec [hl]
	ld a, 1
	call YieldEntityUpdate
	jr .stopping_loop
.stopped
	xor a
	ld [wda7b], a
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_X
	add_hl
	jp .asm_6c0f

.ApplyVelocity:
	ld a, [wBoatDirection]
	call CalculateDirectionComponents
	call GetEntityCarPtr
	push de
	ld a, SPRITESTRUCT_UNK01
	call .ApplyVelocityComponent
	pop bc
	ld a, SPRITESTRUCT_UNK04
.ApplyVelocityComponent:
	push af
	push hl
	ld a, [wBoatSpeed]
	call CalculateSpeedComponent
	pop hl
	pop af
	jp AddBCToStructField

; input:
; - a = target direction
.UpdateDirectionAndSpeed:
	ld de, wBoatSpeed
	ld c, a
	ld b, 4 deg ; steering

	; compare current direction with target direction
	ld hl, wBoatDirection
	sub [hl]
	; if same, then no steering, speed up
	jr z, .speed_up
	; if current > target, then jump
	jr c, .compare_abs
	
	; if diff is greater than 180 deg, turn counter-clockwise
	cp 180 deg
	jr nc, .steer_counterclockwise
	; if diff is smaller than 6 deg, then no steering, speed up
	cp 6 deg
	jr c, .speed_up
	; otherwise turn clockwise
.steer_clockwise
	ld a, [hl] ; wBoatDirection
	inc a
	ld [hl], a
	cp c
	jr z, .speed_down
	dec b
	jr nz, .steer_clockwise
	jr .speed_down
.compare_abs
	; get absolute diff
	cpl
	inc a
	; if diff is greater than 180 deg, turn clockwise
	cp 180 deg
	jr nc, .steer_clockwise
	cp 6 deg
	; if diff is smaller than 6 deg, then no steering, speed up
	jr c, .speed_up
	; otherwise turn counter-clockwise
.steer_counterclockwise
	ld a, [hl] ; wBoatDirection
	dec a
	ld [hl], a
	cp c
	jr z, .speed_down
	dec b
	jr nz, .steer_counterclockwise
.speed_down
	ld a, [de] ; wBoatSpeed
	cp 2.5q4
	ret c
	; [de] >= 2.5q4
	dec a
	ld [de], a
	ret
.speed_up
	ld a, [de]
	cp 3.2q4
	ret nc
	; [de] < 3.2q4
	inc a
	ld [de], a
	ret

.GetDirectionComponentsTowardsWaypoint:
	ld a, d
	or b
	jr nz, .loop_halve
	ld b, e
	ld a, 12
	cp c
	ret c
	cp b
	ret c
	call CalculateEuclideanDistance
	cp 12
	jr nc, .asm_6d22
	; within 12 px
	and a
	ret
.loop_halve
	ld a, d
	or b
	jr z, .asm_6d21
	srl d
	rr e
	srl b
	rr c
	jr .loop_halve
.asm_6d21
	ld b, e
.asm_6d22
	scf
	ret

.Func_6d24:
	call GetEntityCarPtr
	call .GetCoordinates
	jp Func_7b62

.GetWaypoint:
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_UNK0D
	add_hl
	ld d, h
	ld e, l
	ld hl, .Waypoints
	ld a, [wBoatWaypoint]
	add a
	add a ; *4
	add_hl

	; exit if at end of list
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
	ld [de], a ; SPRITESTRUCT_UNK0D
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, c
	ld [de], a ; SPRITESTRUCT_UNK0F
	inc de
	ld a, b
	ld [de], a
	xor a
	dec a
	ret

.UpdateSprite:
	call GetEntityCarPtr
	call .IsInsideVisibleRegion
	jr nc, .inside_region
	; outside region, set invisible
	res SPRITEFLAG_VISIBLE_F, [hl]
	ret
.inside_region
	set SPRITEFLAG_VISIBLE_F, [hl]
	ld d, h
	ld e, l
	ld a, SPRITESTRUCT_TILE_1
	add_de
	ld a, [wBoatDirection]
	add $08
	swap a
	and $0f
	add a
	add a ; *4
	ld hl, .TileIDsAndAttributes
	add_hl
	ld a, [hli]
	ld [de], a ; SPRITESTRUCT_TILE_1
	inc de
	ld a, [hli]
	ld [de], a ; SPRITESTRUCT_ATTR_1
	inc de
	ld a, [hli]
	ld [de], a ; SPRITESTRUCT_TILE_2
	inc de
	ld a, [hl]
	ld [de], a ; SPRITESTRUCT_ATTR_2

	; every 4th frame spawn splash particle
	ld a, [wFrameCounter]
	and %11
	ret nz
	call GetEntityCarPtr
	call .GetCoordinates
	ld a, [wBoatDirection]
	add 180 deg
	jp SpawnBoatSplash

.IsInsideVisibleRegion:
	push hl
	ld hl, .Data_6dfb
	ld de, wdc7a
	ld b, $08
	call CopyHLtoDE
	pop hl
	call .GetCoordinates
	jp IsWithinRectangle

; output:
; - bc = x coordinate
; - de = y coordinate
.GetCoordinates:
	push hl
	inc hl
	inc hl
	ld e, [hl] ; SPRITESTRUCT_Y
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl] ; SPRITESTRUCT_X
	inc hl
	ld b, [hl]
	ld a, 8
	add_de
	ld a, 8
	add_bc
	pop hl
	ret

.TileIDsAndAttributes:
	db $c8, 2 | OAM_BANK1,                         $ca, 2 | OAM_BANK1
	db $cc, 2 | OAM_BANK1,                         $ce, 2 | OAM_BANK1
	db $d0, 2 | OAM_BANK1,                         $d2, 2 | OAM_BANK1
	db $d4, 2 | OAM_BANK1,                         $d6, 2 | OAM_BANK1
	db $d8, 2 | OAM_BANK1,                         $da, 2 | OAM_BANK1
	db $d4, 2 | OAM_BANK1 | OAM_YFLIP,             $d6, 2 | OAM_BANK1 | OAM_YFLIP
	db $d0, 2 | OAM_BANK1 | OAM_YFLIP,             $d2, 2 | OAM_BANK1 | OAM_YFLIP
	db $cc, 2 | OAM_BANK1 | OAM_YFLIP,             $ce, 2 | OAM_BANK1 | OAM_YFLIP
	db $c8, 2 | OAM_BANK1 | OAM_YFLIP,             $ca, 2 | OAM_BANK1 | OAM_YFLIP
	db $ce, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP, $cc, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP
	db $d2, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP, $d0, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP
	db $d6, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP, $d4, 2 | OAM_BANK1 | OAM_XFLIP | OAM_YFLIP
	db $da, 2 | OAM_BANK1 | OAM_XFLIP,             $d8, 2 | OAM_BANK1 | OAM_XFLIP
	db $d6, 2 | OAM_BANK1 | OAM_XFLIP,             $d4, 2 | OAM_BANK1 | OAM_XFLIP
	db $d2, 2 | OAM_BANK1 | OAM_XFLIP,             $d0, 2 | OAM_BANK1 | OAM_XFLIP
	db $ce, 2 | OAM_BANK1 | OAM_XFLIP,             $cc, 2 | OAM_BANK1 | OAM_XFLIP

.Data_6dfb:
	dw 3992, 128
	dw 3678,  64

.Waypoints:
	;  x     y
	dw 4272, 4144
	dw 4032, 4144
	dw 3960, 3808
	dw 4100, 3678
	dw 4852, 3678
	dw 4836, 3806
	dw 4836, 4222
	dw 4916, 4254
	dw 4916, 4350
	dw 4852, 4478
	dw 4836, 4606
	dw 4836, 4798
	dw 4820, 4916
	dw 4916, 4980
	dw 5036, 4980
	dw 5036, 4788
	dw 5322, 4791
	dw NULL ; end

Func_6e49:
	call ChooseCarPool_WithCop
	ld a, MIAMI
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_RamRaidRace
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_6e5b:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	call Func_7bfc
	ld hl, EntUpdate_MissionController_RamRaidRace
	ld c, BANK(EntUpdate_MissionController_RamRaidRace)
	ld b, $0b
	call SpawnEntity
	ret

EntUpdate_MissionController_RamRaidRace:
	call YieldEntityUpdateUntilFadeEnds
	xor a
	ld [wRamRaidRaceRestaurant], a
	inc a
	ld [wda82], a

	call .ShowRestaurantHUDMessage
	call WaitHUDMessage

	ld a, $01
	ld [wd820], a
	ld hl, Timer_RamRaidRace
	call StartCountDownTimer
.next_restaurant
	call .GetRestaurantCoordinates
	call SetDestinationCoords
.restaruant_loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .too_late
	call HasReachedDestination
	jr c, .restaruant_loop
	ld a, 11
	call IncreaseFelony
	call .Func_6ee9
	ld hl, wRamRaidRaceRestaurant
	inc [hl]
	ld a, [hl]
	; have we rammed 5 restaurants?
	cp 5
	jr z, .mission_complete
	; no, go to next one
	call .ShowRestaurantHUDMessage
	jr .next_restaurant

.mission_complete
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

.too_late
	ld hl, TooLateTexts
	jp SetMissionFailed

.ShowRestaurantHUDMessage:
	ld a, [wRamRaidRaceRestaurant]
	ld hl, .TextsTable
	get_pointer
	ld c, 90
	jp ShowHUDMessage

.TextsTable:
	dw GetToTheFirstRestaurantTexts
	dw GetToTheSecondRestaurantTexts
	dw GetToTheThirdRestaurantTexts
	dw GetToTheFourthRestaurantTexts
	dw GetToTheLastRestaurantTexts

.GetRestaurantCoordinates:
	ld hl, DestinationCoordsTable_RamRaidRace
	ld a, [wRamRaidRaceRestaurant]
	add a
	add a ; *4
	add_hl
	ret

.Func_6ee9:
	call .GetRestaurantCoordinates
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, Data_7efa
	ld a, [wRamRaidRaceRestaurant]
	add_hl
	ld l, [hl] ; direction
	ld h, 1.25q4 ; speed
	call Func_633f
	ld a, SFX_26
	jp PlaySFX

Func_6f05:
	call ChooseCarPool_WithCop
	ld a, MIAMI
	call SetCity
	ld a, LIMOUSINE
	ld [wPlayerCar], a
	ld a, OBPAL_BLACK
	ld [wPlayerCarOBPal], a
	ld hl, PlayerSpawnParams_SuperflyDrive
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_6f1e:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	ld hl, EntUpdate_MissionController_SupaflyDrive
	ld c, BANK(EntUpdate_MissionController_SupaflyDrive)
	ld b, $0b
	call SpawnEntity
	ret

EntUpdate_MissionController_SupaflyDrive:
	call YieldEntityUpdateUntilFadeEnds

	; car takes 5x damage
	ld a, 5
	ld [wDamageMultiplier], a

	ld hl, TakeThisPuppyHomeTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage

	ld a, $01
	ld [wd820], a

	ld hl, DestinationCoords_SuperflyDrive
	call SetDestinationCoords

	ld hl, Timer_SuperflyDrive
	call StartCountDownTimer

	xor a
	ld [wda9a], a
.loop
	ld a, [wTimerActive]
	and a
	jr z, .too_late
	call HasReachedDestinationWithoutTail
	jr nc, .mission_complete
	ld a, 1
	call YieldEntityUpdate
	jr .loop

.too_late
	ld hl, TooLateTexts
	jp SetMissionFailed

.mission_complete
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

Func_6f7b:
	call ChooseCarPool_WithCop
	ld a, MIAMI
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_BaitForATrap
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_6f8d:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	ld a, BROWN_CAR
	ld hl, NULL
	call LoadCarGfxAndPals
	ld hl, EntUpdate_MissionController_BaitForATrap
	ld c, BANK(EntUpdate_MissionController_BaitForATrap)
	ld b, $0b
	call SpawnEntity
	ret

EntUpdate_MissionController_BaitForATrap:
	call YieldEntityUpdateUntilFadeEnds

	ld hl, GetToBalHarbourTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage

	ld a, $01
	ld [wd820], a

	ld hl, DestinationCoords_BaitForATrap_1
	call SetDestinationCoords

	ld hl, Timer_BaitForATrap
	call StartCountDownTimer

.asm_6fc8
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .too_late
	call Func_70af
	ld de, $300
	ld a, h
	cp d
	jr nz, .asm_6fe0
	ld a, l
	cp e
.asm_6fe0
	call c, .Func_709d
	ld de, $a0
	ld a, h
	cp d
	jr nz, .asm_6fec
	ld a, l
	cp e
.asm_6fec
	jr nc, .asm_6fc8

	ld hl, DestinationCoords_BaitForATrap_1
	lb de, OBPAL_BLACK, BROWN_CAR
	call Func_70f9
	push hl
	ld hl, Func_70cc
	ld c, BANK(Func_70cc)
	ld b, $05
	call SpawnEntity
	pop de
	call Func_70eb
	set CARFLAG_UNK2_F, [hl]
	set CARFLAG_UNK4_F, [hl]
	ld a, DESTINATION_TARGET
	ld [wDestinationType], a
	ld a, l
	ld [wDestinationTargetPtr + 0], a
	ld a, h
	ld [wDestinationTargetPtr + 1], a
	ld hl, wda55
	inc [hl]
	call .Func_7084
.asm_701e
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .too_late
	call Func_70af
	ld de, $80
	ld a, h
	cp d
	jr nz, .asm_7036
	ld a, l
	cp e
.asm_7036
	jr nc, .asm_701e

	ld hl, RamHimTexts
	ld c, 90
	call ShowHUDMessage
	ld hl, wda7b
.asm_7043
	ld [hl], $00
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .too_late
	ld a, [hl]
	and a
	jr nz, .asm_7043

	ld a, 1
	call Func_42a0
	ld hl, DontLoseHimTexts
	ld c, 90
	call ShowHUDMessage

	ld hl, DestinationCoords_BaitForATrap_2
	call SetDestinationCoords
	call StartCountUpTimer
.asm_706a
	ld a, 1
	call YieldEntityUpdate
	ld hl, wda55
	ld a, [hl]
	and a
	jr z, .lost_him
	call HasReachedDestination
	jr c, .asm_706a
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

.Func_7084:
	ld hl, .data_7097
	call Func_1f19
	xor a
	ld hl, wd82e
	ld [hli], a
	ld [hl], a
	ld [wd837], a
	ld [wd838], a
	ret

.data_7097
	db $00, $00, $04, $1c, $ff, $ff

.Func_709d:
	push hl
	call Func_68b8
	pop hl
	ret

.lost_him
	ld hl, YouLostHimTexts
	jp SetMissionFailed

.too_late
	ld hl, TooLateTexts
	jp SetMissionFailed

Func_70af:
	call Func_2dd5
	ld hl, wda23Y
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wda23
	call Func_275f
	ld h, b
	ld l, c
	ret

Func_70cc:
.loop
	ld a, $01
	ld [wda7b], a
	ld a, 1
	call YieldEntityUpdate
	jr .loop

Func_70d8:
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wda7b]
	and a
	jr z, .loop
	ld de, Func_5950
	ld a, BANK(Func_5950)
	jp SetEntityUpdateFunc

Func_70eb:
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	swap_hl_de
	ld a, CARSTRUCT_ENT_PTR
	jp SetStructWord_DE

; input:
; - d = OBPAL_* constant
; - e = CAR_* constant
Func_70f9:
	push de
	ld c, [hl] ; x
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl] ; y
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl] ; direction
	pop hl
	call SpawnCar
	call AllocateSprite
	ld a, CARSTRUCT_SPRITE_PTR
	call SetStructWord_DE
	call Func_3047
	ld a, [wNumNPCCars]
	inc a
	ld [wNumNPCCars], a
	ret

Func_711a:
	call ChooseCarPool_WithoutCop
	ld a, MIAMI
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_TakeOutDiAngelo
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_712c:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	ld a, RED_CAR
	ld hl, NULL
	call LoadCarGfxAndPals
	xor a
	ld [wd86c], a
	ld c, $05
	call Func_195e
	ld hl, Func_7151
	ld c, BANK(Func_7151)
	ld b, $0b
	call SpawnEntity
	ret

Func_7151:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, RamHimTexts
	ld c, 90
	call ShowHUDMessage
	ld hl, NPCSpawnParams_TakeOutDiAngelo
	call Func_5bce
	ld d, h
	ld e, l
	ld hl, wDestinationType
	ld [hl], DESTINATION_TARGET
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wNumNPCCars
	inc [hl]
	xor a
	ld [wda7b], a
	ld a, $1e
	call YieldEntityUpdate
	ld a, $01
	ld [wda7b], a
	ld a, $1e
	call YieldEntityUpdate
	ld a, $01
	ld [wd820], a
	ld hl, Timer_TakeOutDiAngelo
	call StartCountDownTimer
.asm_718f
	ld a, 1
	call YieldEntityUpdate
	ld a, [wd86c]
	cp $38
	jr nc, .asm_71c9
	ld a, [wTimerActive]
	and a
	jr z, .asm_71c3
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wDestinationTargetPtr + 0]
	ld e, a
	ld a, [wDestinationTargetPtr + 1]
	ld d, a
	call Func_275f
	ld hl, $128
	ld a, h
	cp b
	jr nz, .asm_71bb
	ld a, l
	cp c
.asm_71bb
	jr nc, .asm_718f
	ld hl, YouLostHimTexts
	jp SetMissionFailed
.asm_71c3
	ld hl, TooSlowTexts
	jp SetMissionFailed
.asm_71c9
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

Func_71d2:
	call ChooseCarPool_WithCop
	ld a, LOS_ANGELES
	call SetCity
	ld a, COP_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_BLACK
	ld [wPlayerCarOBPal], a
	ld hl, PlayerSpawnParams_StealACopCar
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_71eb:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	ld hl, Func_71ff
	ld c, BANK(Func_71ff)
	ld b, $0b
	call SpawnEntity
	ret

Func_71ff:
	call YieldEntityUpdateUntilFadeEnds
	ld a, 3
	ld [wDamageMultiplier], a
	ld hl, GetToTheLockUpTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld a, $01
	ld [wd820], a
	ld hl, DestinationCoords_StealACopCar
	call SetDestinationCoords
	call StartCountUpTimer
	ld a, 14
	call IncreaseFelony
	ld hl, Data_1f37
	call Func_1eda
	xor a
	ld [wda9a], a
	ld c, $00
.asm_7231
	push bc
	call HasReachedDestinationWithoutTail
	pop bc
	jr nc, .asm_7255
	call .ShowDamageWarningMessage
	ld a, 1
	call YieldEntityUpdate
	jr .asm_7231

.ShowDamageWarningMessage:
	; did we already show the message?
	ld a, c
	and a
	ret nz
	; no, did we get any damage in the meantime?
	ld a, [wDamage]
	and a
	ret z
	; yes, show message
	ld hl, WatchThePaintworkTexts
	ld c, 90
	call ShowHUDMessage
	; and mark it as showed
	ld c, TRUE
	ret

.asm_7255
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

Func_725e:
	call ChooseCarPool_WithCop
	ld a, LOS_ANGELES
	call SetCity
	ld a, BROWN_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_VAR
	ld [wPlayerCarOBPal], a
	ld hl, PlayerSpawnParams_GetLuckyToTheDocs
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_7277:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	call LoadPersonGfx
	ld hl, Func_728e
	ld c, BANK(Func_728e)
	ld b, $0b
	call SpawnEntity
	ret

Func_728e:
	call YieldEntityUpdateUntilFadeEnds

	ld hl, PickUpLuckyTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage

	ld a, $01
	ld [wd820], a
	ld hl, Timer_GetLuckyToTheDocs
	call StartCountDownTimer
	ld hl, DestinationCoords_GetLuckyToTheDocs_1
	call SetDestinationCoords
	xor a
	ld [wda9a], a
.asm_72b1
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .asm_732b
	call HasReachedDestinationWithoutTail
	jr c, .asm_72b1
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	ld a, $01
	ld [wd837], a
	ld [wd838], a
	call Func_6575
	call Func_67e9
	ld hl, Data_7f3e
	call SpawnPerson_GettingIntoPlayersCar
	call WaitForPersonToDespawn
	ld hl, GetLuckyToTheDocsMsgTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld hl, DestinationCoords_GetLuckyToTheDocs_2
	call SetDestinationCoords
	call Func_658f
	ld a, TRUE
	ld [wTimerActive], a
	xor a
	ld [wd837], a
	ld [wd838], a
	ld a, 14
	call IncreaseFelony
	xor a
	ld [wda9a], a
.asm_7309
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .asm_732b
	call HasReachedDestinationWithoutTail
	jr c, .asm_7309
	call Func_6879
	ld hl, Data_7f46
	call SpawnPerson_GettingOutOfPlayersCar
	call WaitForPersonToDespawn
	ld hl, NULL
	jp SetMissionComplete

.asm_732b
	ld hl, LuckysBoughtItTexts
	jp SetMissionFailed

Func_7331:
	call ChooseCarPool_WithCop
	ld a, LOS_ANGELES
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_BeverlyHillsGetAway
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_7343:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	call LoadPersonGfx
	ld hl, Func_735a
	ld c, BANK(Func_735a)
	ld b, $0b
	call SpawnEntity
	ret

Func_735a:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, GetToBeverlyHillsTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld a, $01
	ld [wd820], a
	ld hl, Timer_BeverlyHillsGetAway
	call StartCountDownTimer
	ld hl, DestinationCoords_BeverlyHillsGetAway_1
	call SetDestinationCoords
	xor a
	ld [wda9a], a
.asm_737d
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .too_late
	call HasReachedDestinationWithoutTail
	jr c, .asm_737d
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	ld a, $01
	ld [wd837], a
	ld [wd838], a
	call Func_6575
	call Func_67e9
	ld hl, Data_7f55
	call ShowThreePeopleGettingIntoPlayersCar
	ld hl, GetToTheLockUpTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	call Func_658f
	call StartCountUpTimer
	ld hl, DestinationCoords_BeverlyHillsGetAway_2
	call SetDestinationCoords
	xor a
	ld [wd837], a
	ld [wd838], a
	ld a, 14
	call IncreaseFelony
.asm_73cc
	ld a, 1
	call YieldEntityUpdate
	call Func_70af
	ld de, $a0
	ld a, h
	cp d
	jr nz, .asm_73dd
	ld a, l
	cp e
.asm_73dd
	jr nc, .asm_73cc
	xor a
	ld [wda7b], a
	ld hl, CopCarSpawnParams_BeverlyHillsGetAway_1
	call .Func_743c
	ld hl, CopCarSpawnParams_BeverlyHillsGetAway_2
	call .Func_743c
.asm_73ef
	ld a, 1
	call YieldEntityUpdate
	call Func_70af
	ld de, $40
	ld a, h
	cp d
	jr nz, .asm_7400
	ld a, l
	cp e
.asm_7400
	jr nc, .asm_73ef
	ld hl, TooManyCopsGetToTheCribTexts
	ld c, 90
	call ShowHUDMessage
	ld a, $1e
	call YieldEntityUpdate
	ld a, 1
	call Func_42a0
	ld a, $01
	ld [wda7b], a
	ld hl, DestinationCoords_BeverlyHillsGetAway_3
	call SetDestinationCoords
	xor a
	ld [wda9a], a
.asm_7423
	ld a, 1
	call YieldEntityUpdate
	call HasReachedDestinationWithoutTail
	jr c, .asm_7423
	call Func_6879
	ld hl, Data_7f6b
	call ShowThreePeopleGettingOutOfPlayersCar
	ld hl, NULL
	jp SetMissionComplete

.Func_743c:
	lb de, OBPAL_BLACK, COP_CAR
	call Func_70f9
	push hl
	ld hl, Func_70d8
	ld c, BANK(Func_70d8)
	ld b, $05
	call SpawnEntity
	pop de
	call Func_70eb
	set CARFLAG_UNK2_F, [hl]
	set CARFLAG_UNK4_F, [hl]
	ld hl, wda55
	inc [hl]
	ret

.too_late
	ld hl, TooLateTexts
	jp SetMissionFailed

Func_7460:
	ld hl, $1fbb
	call Func_1987
	ld a, NEW_YORK
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_GrandCentralStation
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_7475:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	call LoadPersonGfx
	ld hl, Func_748c
	ld c, BANK(Func_748c)
	ld b, $0b
	call SpawnEntity
	ret

Func_748c:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, GetToThePickUpTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld a, $01
	ld [wd820], a
	ld hl, DestinationCoords_GrandCentralStation_1
	call SetDestinationCoords
	ld hl, Timer_GrandCentralStation_1
	call StartCountDownTimer
.asm_74ab
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .too_slow
	call HasReachedDestinationWithoutTail
	jr c, .asm_74ab
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	ld a, $01
	ld [wd837], a
	ld [wd838], a
	call Func_6575
	call Func_67e9
	ld hl, Data_7f7a
	call SpawnPerson_GettingOutOfPlayersCar
	call WaitForPersonToDespawn
	ld a, $3c
	call YieldEntityUpdate
	ld hl, Data_7f7a
	call SpawnPerson_GettingIntoPlayersCar
	call WaitForPersonToDespawn
	ld hl, GetToGrandCentralStationTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld hl, DestinationCoords_GrandCentralStation_2
	call SetDestinationCoords
	ld hl, Timer_GrandCentralStation_2
	call StartCountDownTimer
	xor a
	ld [wd837], a
	ld [wd838], a
	call Func_658f
.asm_7509
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jp z, .too_slow
	call HasReachedDestinationWithoutTail
	jr c, .asm_7509
	xor a
	ld [wDestinationType], a
	ld [wTimerActive], a
	ld a, $01
	ld [wd837], a
	ld [wd838], a
	call Func_6575
	call Func_67e9
	ld hl, Data_7f82
	call SpawnPerson_GettingOutOfPlayersCar
	call WaitForPersonToDespawn
	ld a, $3c
	call YieldEntityUpdate
	ld hl, Data_7f82
	call SpawnPerson_GettingIntoPlayersCar
	call WaitForPersonToDespawn
	ld hl, ReturnTheKeyToTheLockUpTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	call Func_658f
	ld hl, DestinationCoords_GrandCentralStation_3
	call SetDestinationCoords
	ld hl, Timer_GrandCentralStation_3
	call StartCountDownTimer
	call Func_761e
.asm_7563
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .too_slow
	call .Func_75c5
	jr nc, .asm_7563
	call .Func_75a7
	ld a, 1
	call Func_42a0
	ld a, $01
	ld [wd839], a
	ld hl, YouveBeenBuggedLoseTheTailTexts
	ld c, 90
	call ShowHUDMessage
.asm_7588
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .too_slow
	call HasReachedDestinationWithoutTail
	jr c, .asm_7588
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

.too_slow
	ld hl, TooSlowTexts
	jp SetMissionFailed

.Func_75a7:
	lb de, OBPAL_BROWN, CAR_10
	call Func_70f9
	push hl
	ld hl, Func_7637
	ld c, BANK(Func_7637)
	ld b, $05
	call SpawnEntity
	pop de
	call Func_70eb
	set CARFLAG_UNK2_F, [hl]
	set CARFLAG_UNK4_F, [hl]
	ld hl, wda55
	inc [hl]
	ret

.Func_75c5:
	ld hl, .Data_75f7
	call .Func_75e3
	ld hl, .Data_75ff
	ret c
	ld hl, .Data_7604
	call .Func_75e3
	ld hl, .Data_760c
	ret c
	ld hl, .Data_7611
	call .Func_75e3
	ld hl, .Data_7619
	ret

.Func_75e3:
	ld de, wdc7a
	ld b, $08
	call CopyHLtoDE
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetCarCoordinates
	jp IsWithinRectangle

.Data_75f7:
	dw 5424, 16
	dw 6656, 32

.Data_75ff:
	coords_dir 5504, 6680, 270 deg

.Data_7604:
	dw 5424, 16
	dw 6704, 32

.Data_760c:
	coords_dir 5504, 6728, 270 deg

.Data_7611:
	dw 5048, 16
	dw 8024, 80

.Data_7619:
	coords_dir 5128, 8060, 270 deg

Func_761e:
	ld hl, .Data_7631
	call Func_1f19
	xor a
	ld hl, wd82e
	ld [hli], a
	ld [hl], a
	ld [wd837], a
	ld [wd838], a
	ret

.Data_7631:
	db $00, $00, $04, $1c, $08, $07

Func_7637:
	call GetEntityCarPtr
	ld bc, 4.0q12
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld de, Func_5950
	ld a, BANK(Func_5950)
	jp SetEntityUpdateFunc

Func_764a:
	call ChooseCarPool_WithCop
	ld a, NEW_YORK
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_TrashGrangersWheels
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_765c:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	ld a, $08
	ld hl, NULL
	call LoadCarGfxAndPals
	xor a
	ld [wd86c], a
	ld c, $05
	call Func_195e
	ld hl, Func_7681
	ld c, BANK(Func_7681)
	ld b, $0b
	call SpawnEntity
	ret

Func_7681:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, FindAndWreckGrangersCarTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld hl, NPCSpawnParams_TrashGrangersWheels
	call Func_5bce
	ld d, h
	ld e, l
	ld hl, wDestinationType
	ld [hl], DESTINATION_TARGET
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wNumNPCCars
	inc [hl]
	xor a
	ld [wda7b], a
	inc a
	ld [wd83a], a
	ld a, $01
	ld [wd820], a
	ld hl, Timer_TrashGrangersWheels
	call StartCountDownTimer
.asm_76b7
	ld a, 1
	call YieldEntityUpdate
	call .Func_7709
	ld a, [wTimerActive]
	and a
	jr z, .asm_7703
	ld a, [wd86c]
	cp $38
	jr c, .asm_76b7
	ld hl, GetBackToYourHotelTexts
	ld c, 90
	call ShowHUDMessage
	xor a
	ld [wd877], a
	ld hl, wDestinationTargetPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	res 3, [hl]
	ld hl, DestinationCoords_TrashGrangersWheels
	call SetDestinationCoords
	xor a
	ld [wda9a], a
.asm_76ea
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .asm_7703
	call HasReachedDestinationWithoutTail
	jr c, .asm_76ea
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

.asm_7703
	ld hl, TooLateTexts
	jp SetMissionFailed

.Func_7709:
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wDestinationTargetPtr + 0]
	ld e, a
	ld a, [wDestinationTargetPtr + 1]
	ld d, a
	call Func_275f
	ld hl, $180
	ld a, h
	cp b
	jr nz, .asm_7723
	ld a, l
	cp c
.asm_7723
	ret c
	ld hl, wCars
	ld b, MAX_NUM_CARS
	ld de, CAR_STRUCT_SIZE
.loop_cars
	ld a, [wda55]
	cp $03
	ret nc
	bit CARFLAG_ACTIVE_F, [hl]
	jr z, .next_car
	ld a, [hl]
	and CARFLAG_PLAYER | CARFLAG_UNK2 | CARFLAG_UNK3 | CARFLAG_UNK4
	jr nz, .next_car
	call Func_270f
	jr z, .next_car
	set CARFLAG_UNK2_F, [hl]
	ld a, CARSTRUCT_01
	ld c, $01
	call SetStructByte_C
	ld a, CARSTRUCT_02
	ld c, $00
	call SetStructByte_C
	ld a, [wda55]
	inc a
	ld [wda55], a
.next_car
	add hl, de
	dec b
	jr nz, .loop_cars
	ret

Func_775c:
	call ChooseCarPool_WithoutCop
	ld a, NEW_YORK
	call SetCity
	call SetDefaultPlayerCar
	ld hl, PlayerSpawnParams_StopGrangersGang
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_776e:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	ld a, $06
	ld hl, NULL
	call LoadCarGfxAndPals
	xor a
	ld [wd86c], a
	ld c, $05
	call Func_195e
	ld hl, Func_7793
	ld c, BANK(Func_7793)
	ld b, $0b
	call SpawnEntity
	ret

Func_7793:
	xor a
	ld [wGrangersGangCar], a
	ld a, $01
	ld [wda7b], a
.asm_779c
	ld a, 1
	call YieldEntityUpdate
	call .Func_780f
	jr nc, .asm_779c
	call YieldEntityUpdateUntilFadeEnds
	call .Func_77f9
	call WaitHUDMessage
	ld hl, Timer_StopGrangersGang
	call StartCountDownTimer
	ld a, $01
	ld [wd820], a
	jr .asm_77c4
.asm_77bc
	call .Func_7856
	call .Func_780f
	jr nc, .asm_77bc
.asm_77c4
	call .Func_7856
	ld a, [wd86c]
	cp $38
	jr c, .asm_77c4
	ld hl, wDestinationType
	ld [hl], NONE
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	res 3, [hl]
	ld hl, wGrangersGangCar
	ld a, [hl]
	inc a
	ld [hl], a
	cp $05
	jp z, .asm_7867
	call .Func_77f9
	ld b, $1e
.asm_77e9
	call .Func_7856
	dec b
	jr nz, .asm_77e9
	xor a
	ld [wd86c], a
	inc a
	ld [wd86d], a
	jr .asm_77bc

.Func_77f9:
	ld hl, .Texts
	ld a, [wGrangersGangCar]
	get_pointer
	ld c, 90
	jp ShowHUDMessage

.Texts:
	dw TrackDownTheCarAndSmashIntoItTexts
	dw FourCardsLeftTexts
	dw ThreeCardsLeftTexts
	dw TwoCarsLeftTexts
	dw OneCarLeftTexts

.Func_780f:
	ld hl, wCars
	ld de, CAR_STRUCT_SIZE
	ld b, MAX_NUM_CARS
.loop_cars
	bit CARFLAG_ACTIVE_F, [hl]
	jr z, .next_car
	ld a, [hl]
	and CARFLAG_PLAYER | CARFLAG_UNK3 | CARFLAG_UNK4
	jr nz, .next_car
	call Func_270f
	jr z, .next_car
	set CARFLAG_UNK3_F, [hl]
	ld a, CARSTRUCT_01
	ld c, $06
	call SetStructByte_C
	ld de, Data_7870
	ld a, [wGrangersGangCar]
	add_de
	ld a, [de]
	ld c, a
	ld a, CARSTRUCT_02
	call SetStructByte_C
	ld a, CARSTRUCT_15
	ld c, $30
	call SetStructByte_C
	ld d, h
	ld e, l
	ld hl, wDestinationType
	ld [hl], DESTINATION_TARGET
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	scf
	ret
.next_car
	add hl, de
	dec b
	jr nz, .loop_cars
	and a
	ret

.Func_7856:
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	ret nz
	pop hl
	ld hl, ACarGotThroughTexts
	jp SetMissionFailed

.asm_7867
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

Data_7870:
	db $02, $07, $06, $05, $00

Func_7875:
	call ChooseCarPool_WithoutCop
	ld a, NEW_YORK
	call SetCity
	ld a, BROWN_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_VAR
	ld [wPlayerCarOBPal], a
	ld hl, PlayerSpawnParams_ChaseOneOfGrangersBoys
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_788e:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	ld a, $07
	ld hl, NULL
	call LoadCarGfxAndPals
	xor a
	ld [wd86c], a
	ld c, $05
	call Func_195e
	ld hl, Func_78b3
	ld c, BANK(Func_78b3)
	ld b, $0b
	call SpawnEntity
	ret

Func_78b3:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, TrackDownTheCarAndSmashIntoItTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld hl, NPCSpawnParams_ChaseOneOfGrangersBoys
	call Func_5bce
	ld d, h
	ld e, l
	ld hl, wDestinationType
	ld [hl], DESTINATION_TARGET
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $01
	ld [wd820], a
	ld hl, wNumNPCCars
	inc [hl]
	ld a, $01
	ld [wda7b], a
	ld hl, Timer_ChaseOneOfGrangersBoys
	call StartCountDownTimer
.asm_78e6
	ld a, 1
	call YieldEntityUpdate
	ld a, [wTimerActive]
	and a
	jr z, .asm_795c
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wDestinationTargetPtr + 0]
	ld e, a
	ld a, [wDestinationTargetPtr + 1]
	ld d, a
	call Func_275f
	ld hl, $30
	ld a, h
	cp b
	jr nz, .asm_790b
	ld a, l
	cp c
.asm_790b
	jr c, .asm_78e6
	ld hl, RamHimTexts
	ld c, 90
	call ShowHUDMessage
	ld hl, wDestinationTargetPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $15
	add_hl
	ld [hl], $36
.asm_7920
	ld a, 1
	call YieldEntityUpdate
	ld a, [wd86c]
	cp $38
	jr nc, .asm_7962
	ld a, [wTimerActive]
	and a
	jr z, .asm_795c
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wDestinationTargetPtr + 0]
	ld e, a
	ld a, [wDestinationTargetPtr + 1]
	ld d, a
	call Func_275f
	ld a, c
	ld [wdc8c], a
	ld a, b
	ld [wdc8d], a
	ld hl, $160
	ld a, h
	cp b
	jr nz, .asm_7954
	ld a, l
	cp c
.asm_7954
	jr nc, .asm_7920
	ld hl, YouLostHimTexts
	jp SetMissionFailed
.asm_795c
	ld hl, TooSlowTexts
	jp SetMissionFailed
.asm_7962
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete

Func_796b:
	call ChooseCarPool_WithoutCop
	ld a, NEW_YORK
	call SetCity
	ld a, BROWN_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_VAR
	ld [wPlayerCarOBPal], a
	ld hl, PlayerSpawnParams_CrossTownRecord
	call SetPlayerSpawnCoordinatesAndDirection
	ret

Func_7984:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
	call Func_1eda
	ld hl, Func_7998
	ld c, BANK(Func_7998)
	ld b, $0b
	call SpawnEntity
	ret

Func_7998:
	call YieldEntityUpdateUntilFadeEnds
	ld hl, GetAcrossTownAsQuickAsYouCanTexts
	ld c, 90
	call ShowHUDMessage
	call WaitHUDMessage
	ld a, $01
	ld [wd820], a
	ld hl, DestinationCoords_CrossTownRecord
	call SetDestinationCoords
	ld hl, Timer_CrossTownRecord
	call StartCountDownTimer
.asm_79b7
	ld a, [wTimerActive]
	and a
	jr z, .asm_79d2
	call HasReachedDestination
	jr nc, .asm_79c9
	ld a, 1
	call YieldEntityUpdate
	jr .asm_79b7
.asm_79c9
	call Func_6879
	ld hl, NULL
	jp SetMissionComplete
.asm_79d2
	ld hl, TooSlowTexts
	jp SetMissionFailed

WaitForPersonToDespawn:
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, $0e
	call FindEntity
	ret nc
	jr .loop

SpawnPerson_GettingIntoPlayersCar:
	ld b, $2 + $2
	ld de, wdc7a
.loop_copy_coords
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop_copy_coords
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetCarCoordinates
	ld a, c
	ld [wTempX + 0], a
	ld a, b
	ld [wTempX + 1], a
	ld a, e
	ld [wTempY + 0], a
	ld a, d
	ld [wTempY + 1], a
	jp _SpawnPerson

SpawnPerson_GettingOutOfPlayersCar:
	push hl
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetCarCoordinates
	ld a, c
	ld [wdc7a + 0], a
	ld a, b
	ld [wdc7a + 1], a
	ld a, e
	ld [wdc7c + 0], a
	ld a, d
	ld [wdc7c + 1], a
	pop hl
	ld b, $2 + $2
	ld de, wTempX
.loop_copy_coords
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop_copy_coords
	jp _SpawnPerson

_SpawnPerson:
	call AllocateSprite
	ret c
	push de
	ld hl, EntUpdate_Person
	ld c, BANK(EntUpdate_Person)
	ld b, $0e
	call SpawnEntity
	pop de
	ret c
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	inc de
	xor a
	ld [de], a ; SPRITESTRUCT_UNK01
	inc de

	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -4
	add hl, bc
	ld a, l
	ld [de], a ; SPRITESTRUCT_Y
	inc de
	ld a, h
	ld [de], a
	inc de

	xor a
	ld [de], a ; SPRITESTRUCT_UNK04
	inc de
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, -4
	add hl, bc
	ld a, l
	ld [de], a ; SPRITESTRUCT_X
	inc de
	ld a, h
	ld [de], a
	inc de

	ld a, 2 * TILE_HEIGHT
	ld [de], a ; SPRITESTRUCT_HEIGHT
	inc de

	ld a, TILE_WIDTH
	ld [de], a ; SPRITESTRUCT_WIDTH

	ld a, SPRITESTRUCT_UNK0D - SPRITESTRUCT_WIDTH
	add_de

	ld hl, wTempY
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, l
	ld [de], a ; SPRITESTRUCT_UNK0D
	inc de
	ld a, h
	ld [de], a
	inc de

	ld hl, wTempX
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, l
	ld [de], a ; SPRITESTRUCT_UNK0F
	inc de
	ld a, h
	ld [de], a
	ret

EntUpdate_Person:
	call GetEntityCarPtr
	ld a, [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [hl], a
.loop
	call .CalculateDistanceToTarget
	call .CheckIfReachedTarget
	ld a, [wda59]
	and a
	jr z, .despawn
	call .ApplyMovement
	call .UpdateAnimation
	ld a, 1
	call YieldEntityUpdate
	jr .loop
.despawn
	call GetEntityCarPtr
	ld [hl], $00
	jp DespawnEntity

.ApplyMovement:
	ld de, 0
	ld bc, 0
	ld a, [wda59]
	bit 0, a
	call nz, .MovingUp
	bit 2, a
	call nz, .MovingDown
	bit 1, a
	call nz, .MovingRight
	bit 3, a
	call nz, .MovingLeft
	call GetEntityCarPtr
	push de
	ld a, SPRITESTRUCT_UNK01
	call AddBCToStructField
	pop bc
	ld a, SPRITESTRUCT_UNK04
	jp AddBCToStructField

.MovingUp:
	ld bc, -0.5
	ret

.MovingDown:
	ld bc, 0.5
	ret

.MovingLeft:
	ld de, -0.5
	ret

.MovingRight:
	ld de, 0.5
	ret

.CalculateDistanceToTarget:
	call GetEntityCarPtr
	push hl
	inc hl
	inc hl
	ld e, [hl] ; SPRITESTRUCT_Y
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl] ; SPRITESTRUCT_X
	inc hl
	ld b, [hl]
	ld a, 4
	add_bc
	ld a, 4
	add_de
	pop hl
	call Func_7b62
	ld a, c
	ld [wdc7a + 0], a
	ld a, b
	ld [wdc7a + 1], a
	ld a, e
	ld [wdc7c + 0], a
	ld a, d
	ld [wdc7c + 1], a
	ret

.CheckIfReachedTarget:
	ld a, d
	or b
	ret nz
	ld a, c
	cp 2
	ret nc
	ld a, e
	cp 2
	ret nc
	; x and y are < 2 pixels
	xor a
	ld [wda59], a
	ret

.UpdateAnimation:
	call GetEntityCarPtr
	ld a, SPRITESTRUCT_TILE_1
	add_hl
	ld a, [wdc7a + 0]
	ld c, a
	ld a, [wdc7a + 1]
	ld b, a
	ld a, [wdc7c + 0]
	ld e, a
	ld a, [wdc7c + 1]
	ld d, a
	ld a, d
	cp b
	jr nz, .asm_7b4d
	ld a, e
	cp c
.asm_7b4d
	ld c, $00
	jr nc, .asm_7b53
	ld c, $08
.asm_7b53
	ld a, [wFrameCounter]
	rrca
	rrca
	and $03
	add a ; * 2
	add $c8
	add c
	ld [hli], a ; SPRITESTRUCT_TILE_1
	ld [hl], 2 | OAM_BANK1 ; SPRITESTRUCT_ATTR_1
	ret

; input:
; - bc = x coordinate
; - de = y coordinate
Func_7b62:
	xor a
	ld [wda59], a
	ld a, SPRITESTRUCT_UNK0D
	add_hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call HLMinusDE
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
	ld a, [hli] ; SPRITESTRUCT_UNK0F
	ld h, [hl]
	ld l, a
	call HLMinusBC
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
	ld a, BANK("VRAM1")
	vramswitch
	ld de, v0Tiles1 tile $48
	ld hl, PersonGfx
	ld c, BANK(PersonGfx)
	ld b, 8 ; tiles
	xor a
	call CopyTilesWithAlternatingBlackTiles
	ld a, BANK("VRAM0")
	vramswitch
	ret

Func_7bd4:
	ld a, BANK("VRAM1")
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
	ld a, BANK("VRAM0")
	vramswitch
	ret

Func_7bfc:
	ld a, BANK("VRAM1")
	vramswitch
	ld de, v0Tiles1 tile $48
	ld hl, Gfx_d11dd
	ld c, BANK(Gfx_d11dd)
	ld b, 4 ; tiles
	xor a
	call CopyTilesWithAlternatingBlackTiles
	ld a, BANK("VRAM0")
	vramswitch
	ret

Func_7c17::
	ld a, $01
	ld [wd820], a
	call YieldEntityUpdateUntilFadeEnds
	xor a
	ld [wdcb5], a
.asm_7c23
	ld a, 1
	call YieldEntityUpdate
	ld a, [wdc92]
	and a
	jr nz, .asm_7c3a
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr z, .asm_7c23
	ld a, $01
	ld [wdcb5], a
.asm_7c3a
	call FadeToWhite
	call YieldEntityUpdateUntilFadeEnds
	ld a, $03
	ld [wd820], a
	jp YieldEntityUpdateIndefinitely

Data_7c48::
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK

.Miami:
	; props
	db PROP_5, PROP_B, PROP_0, PROP_7, PROP_2, PROP_3, PROP_A, PROP_C

	; OB pals
	dw Pals_f644
	dw NULL
	dw Pals_f64c
	dw Pals_f654
	dw Pals_f65c
	dw Pals_f664
	dw Pals_f66c
	dw Pals_f674

	db $05, $00
	db $0b, $00
	db $0b, $40
	db $0b, $80
	db $0b, $c0
	db $00, $00
	db $07, $00
	db $02, $00
	db $03, $00
	db $0a, $00
	db $0a, $40
	db $0a, $80
	db $0a, $c0
	db $0c, $00
	db $0c, $40
	db $0c, $80
	db $0c, $c0
	db $ff; end

.LosAngeles:
	; props
	db PROP_B, PROP_0, PROP_1, PROP_2, PROP_3, PROP_4, PROP_A, PROP_D

	; OB pals
	dw Pals_f644
    dw NULL
	dw Pals_f64c
	dw Pals_f654
	dw Pals_f65c
	dw Pals_f664
	dw Pals_f66c
	dw Pals_f674

	db $0b, $00
	db $0b, $40
	db $0b, $80
	db $0b, $c0
	db $00, $00
	db $01, $00
	db $02, $00
	db $03, $00
	db $04, $00
	db $0a, $00
	db $0a, $40
	db $0a, $80
	db $0a, $c0
	db $0d, $00
	db $0d, $40
	db $0d, $80
	db $0d, $c0
	db $ff; end

.NewYork:
	; props
	db PROP_1, PROP_7, PROP_0, PROP_2, PROP_3, PROP_A, PROP_C, PROP_D

	; OB pals
	dw Pals_f644
	dw NULL
	dw Pals_f64c
	dw Pals_f654
	dw Pals_f65c
	dw Pals_f664
	dw Pals_f66c
	dw Pals_f674

	db $01, $00
	db $07, $00
	db $00, $00
	db $02, $00
	db $03, $00
	db $0a, $00
	db $0a, $40
	db $0a, $80
	db $0a, $c0
	db $0c, $00
	db $0c, $40
	db $0c, $80
	db $0c, $c0
	db $0d, $00
	db $0d, $40
	db $0d, $80
	db $0d, $c0
	db $ff; end

; whether to skip showing the initial companies screens
; always returns z
CheckSkipCompanies::
	ld a, [.Value]
	and a
	ret

.Value:
	db FALSE

Data_7d05::
	table_width 4
	dw .Miami_1,      .Miami_2      ; MIAMI
	dw .LosAngeles_1, .LosAngeles_2 ; LOS_ANGELES
	dw .NewYork_1,    .NewYork_2    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami_1:
	coords_dir 3636, 3792, 0 deg

	dw 3168, 3956
	dw 2840, 3080
	dw 2852, 3940
	dw 3428, 4560
	dw 3700, 4304
	dw 4152, 4200

.Miami_2:
	coords_dir 7645, 4014, 270 deg

	dw 7468, 3210
	dw 7191, 1086
	dw 5840, 3449
	dw 3756, 3565
	dw 3036, 5799
	dw  390, 4525

.LosAngeles_1:
	coords_dir 2305, 1146, 180 deg

	dw 2658, 1748
	dw 2863, 2199
	dw 4296, 1790
	dw 3414, 1197
	dw 1838, 2379
	dw 1971, 3556

.LosAngeles_2:
	coords_dir 69, 3544, 0 deg

	dw   46, 1061
	dw 1947, 1756
	dw 3821, 2433
	dw 6843, 1138
	dw 7470, 2863
	dw 5714, 5293

.NewYork_1:
	coords_dir 3494, 4017, 0 deg

	dw 3909, 3850
	dw 4851, 3229
	dw 4429, 2017
	dw 3627, 2269
	dw 3116, 2225
	dw 1969, 3558

.NewYork_2:
	coords_dir 2964, 7767, 90 deg

	dw 3917, 7312
	dw 4016, 5512
	dw 1613, 3484
	dw 1000, 1443
	dw 2130,  522
	dw 5223, 5165

Data_7dbf::
	table_width 4
	dw .Miami_1,      .Miami_2      ; MIAMI
	dw .LosAngeles_1, .LosAngeles_2 ; LOS_ANGELES
	dw .NewYork_1,    .NewYork_2    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami_1:
	coords_dir 4196, 4360, 225 deg
	coords_dir 4212, 4344, 225 deg

.Miami_2:
	coords_dir 7022, 80,  0 deg
	coords_dir 6957, 64, 90 deg

.LosAngeles_1:
	coords_dir 1056, 5904, 0 deg
	coords_dir 1056, 5928, 0 deg

.LosAngeles_2:
	coords_dir 4396, 1750, 270 deg
	coords_dir 4396, 1725,  90 deg

.NewYork_1:
	coords_dir 1568, 7232, 90 deg
	coords_dir 1544, 7232, 90 deg

.NewYork_2:
	coords_dir 3441, 4078, 90 deg
	coords_dir 3391, 4078, 90 deg

Data_7e07::
	table_width 4
	dw .Miami_1,      .Miami_2      ; MIAMI
	dw .LosAngeles_1, .LosAngeles_2 ; LOS_ANGELES
	dw .NewYork_1,    .NewYork_2    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami_1:
	dw 7680, 4528 ; player coordinates
	db 0 deg ; player direction
	dw Pals_f644 palette 7 ; target palette
	db BROWN_CAR ; target car
	db OBPAL_VAR ; target pal ID
	db $32, $00
	db 270 deg ; target direction
	dw 7680, 4468 ; target coordinates

.Miami_2:
	dw 3376, 4520 ; player coordinates
	db 270 deg ; player direction
	dw NULL ; target palette
	db RED_CAR ; target car
	db OBPAL_RED ; target pal ID
	db $32, $00
	db 180 deg ; target direction
	dw 3316, 4484 ; target coordinates

.LosAngeles_1:
	dw 2252, 2610 ; player coordinates
	db 90 deg ; player direction
	dw NULL ; target palette
	db LIMOUSINE ; target car
	db OBPAL_BROWN ; target pal ID
	db $32, $00
	db 180 deg ; target direction
	dw 2316, 2644 ; target coordinates

.LosAngeles_2:
	dw 3852, 600 ; player coordinates
	db 180 deg ; player direction
	dw NULL ; target palette
	db RED_CAR ; target car
	db OBPAL_BLACK ; target pal ID
	db $32, $00
	db 180 deg ; target direction
	dw 3852, 660 ; target coordinates

.NewYork_1:
	dw 1512, 7232 ; player coordinates
	db 90 deg ; player direction
	dw Pals_f644 palette 7 ; target palette
	db BROWN_CAR ; target car
	db OBPAL_VAR ; target pal ID
	db $32, $00
	db 180 deg ; target direction
	dw 1580, 7232 ; target coordinates

.NewYork_2:
	dw 4360, 3228 ; player coordinates
	db 90 deg ; player direction
	dw NULL ; target palette
	db LIMOUSINE ; target car
	db OBPAL_BLACK ; target pal ID
	db $32, $00
	db 90 deg ; target direction
	dw 4440, 3220 ; target coordinates

 
CreditsPlayerSpawnParams::
	table_width 2
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami:
	coords_dir 7472, 3248, 270 deg

.LosAngeles:
	coords_dir 3852, 600, 180 deg

.NewYork:
	coords_dir 6124, 7536, 0 deg

TakeARidePlayerSpawnParams::
	table_width 2
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami:
	coords_dir 7472, 3248, 270 deg

.LosAngeles:
	coords_dir 1056, 5928, 0 deg

.NewYork:
	coords_dir 1440, 7152, 180 deg

SurvivalPlayerSpawnParams::
	table_width 2
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami:
	coords_dir 7652, 4544, 315 deg

.LosAngeles:
	coords_dir 1936, 3104, 270 deg

.NewYork:
	coords_dir 1580, 7232, 180 deg
