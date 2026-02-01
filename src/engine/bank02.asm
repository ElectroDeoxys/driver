SECTION "Func_8ce1", ROMX[$4ce1], BANK[$2]

Func_8ce1::
	ld a, $01
	call Func_f27
	ld a, TRUE
	ld [wResetDisabled], a
	call $4d7d ; Func_8d7d
	ld a, [wd821]
	cp $02
	jr z, Func_8cff
	ld a, $06
	ld [wd81f], a
	xor a
	ld [wResetDisabled], a
	ret

Func_8cff::
	ld a, TRUE
	ld [wResetDisabled], a
	ld a, $02
	call Func_f2e
	call Func_8ddb
	call $5532 ; Func_9532
	ld bc, $a00
	call Func_945c
	xor a
	ld [wdc26], a
	xor a
	ld [wdc2f], a
	ld hl, $561f
	ld c, $02
	ld b, $13
	call Func_1536
	ld hl, $4d45
	ld c, $02
	ld b, $17
	call Func_1536
	call Func_94d8
	ld a, [wd81f]
	cp $06
	jr nz, .asm_8d40
	ld a, $01
	call Func_f27
.asm_8d40
	xor a
	ld [wResetDisabled], a
	ret
; 0x8d45

SECTION "Func_8d7d", ROMX[$4d7d], BANK[$2]

Func_8d7d:
	call Func_8ddb
	ld de, $4dcb
	ld hl, wdbfb
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld [wd54d], a
	ld a, $09
	call LoadScene
	ld a, $01
	call Func_cf2
	ld hl, Func_8da4
	ld c, $02
	ld b, $16
	call Func_1536
	jp Func_94d8

Func_8da4:
	call Func_1e3f
	ld bc, $b4
.asm_8daa
	ld a, $01
	call Func_14e8
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr nz, .asm_8dc3
	dec bc
	ld a, b
	or c
	jr nz, .asm_8daa
	ld a, $01
	ld [wd821], a
	jp Func_a491
.asm_8dc3
	ld a, $02
	ld [wd821], a
	jp Func_a491
; 0x8dcb

SECTION "Func_8ddb", ROMX[$4ddb], BANK[$2]

Func_8ddb:
	call EmptyScreen
	call Func_a1e
	call Func_110b
	call Func_1488
	call Func_93b5
	xor a
	ld [wdc20], a
	ret
; 0x8def

SECTION "Func_90aa", ROMX[$50aa], BANK[$2]

Func_90aa::
	ld a, [wd81f]
	cp $05
	ret nz
	call Func_8ddb
	ld a, [wdc38]
	ld hl, $66cc
	get_pointer
	call Func_1e4b
	call Func_9177
	call $6096 ; Func_a096
	ld hl, $63a0
	ld c, $36
	ld b, $28
	ld de, wc655
	call Func_b1b
	call $614c ; Func_a14c
	ld bc, $a00
	call Func_945c
	ld hl, $521a
	call $5aa9 ; Func_9aa9
	ld a, BANK(Func_9159)
	ld de, Func_9159
	ld hl, wd54e
	ld [hli], a
	ld [hl], e ; wd54f
	inc hl
	ld [hl], d
	ld hl, $5102
	ld c, $02
	ld b, $15
	call Func_1536
	ld a, $03
	call Func_cf2
	ld a, $03
	call Func_f27
	jp Func_94d8
; 0x9102

SECTION "Func_9159", ROMX[$5159], BANK[$2]

Func_9159:
	ld hl, wdc34
	ld c, $38
	ld a, [wdc30]
	cp $03
	jr c, .asm_9167
	ld c, $40
.asm_9167
	ld b, $7e
	call Func_a0e2
	ld a, [wc57a]
	and $04
	jp z, Func_9d1a
	jp Func_9cd4

Func_9177:
	call Func_9292
.asm_917a
	push hl
	call Func_918d
	pop hl
	ld a, c
	and a
	ret z
	push bc
	push hl
	call Func_91ae
	pop hl
	pop bc
	ld a, b
	add_hl
	jr .asm_917a

Func_918d:
	ld c, $00
	ld b, $00
.asm_9191
	ld a, c
	cp $13
	jr c, .asm_9199
	ld c, b
	inc b
	ret
.asm_9199
	ld a, [hli]
	and a
	jr z, .asm_91a9
	cp $2a
	jr z, .asm_91ab
	cp $20
	jr nz, .asm_91a6
	ld b, c
.asm_91a6
	inc c
	jr .asm_9191
.asm_91a9
	ld b, c
	ret
.asm_91ab
	ld b, c
	inc b
	ret

Func_91ae:
	push af
	push hl
	ld hl, wd771
	ld bc, $20
	call ClearMemory
	pop hl
	ld de, wdbff
	ld a, [wdc25]
	add_de
	pop af
	ld [de], a
	push af
	ld de, wd771
	ld b, a
	ld a, $14
	sub b
	srl a
	add_de
	ld a, b
	ld bc, wd7b1
.asm_91d2
	push af
	ld a, [hli]
	cp $22
	jr z, .asm_9232
	cp $ff
	jr nz, .asm_91e0
	ld a, $27
	jr .asm_9232
.asm_91e0
	cp $fe
	jr nz, .asm_91e8
	ld a, $2e
	jr .asm_9232
.asm_91e8
	cp $fd
	jr nz, .asm_91f0
	ld a, $2d
	jr .asm_9232
.asm_91f0
	cp $fc
	jr nz, .asm_91f8
	ld a, $35
	jr .asm_9232
.asm_91f8
	cp $fb
	jr nz, .asm_9200
	ld a, $2c
	jr .asm_9232
.asm_9200
	cp $fa
	jr nz, .asm_9208
	ld a, $21
	jr .asm_9232
.asm_9208
	cp $f9
	jr nz, .asm_9210
	ld a, $23
	jr .asm_9232
.asm_9210
	cp $9b
	jr c, .asm_921c
	cp $b4
	jr nc, .asm_921c
	sub $40
	jr .asm_9239
.asm_921c
	cp $db
	jr c, .asm_9228
	cp $f4
	jr nc, .asm_9228
	sub $80
	jr .asm_9232
.asm_9228
	cp $61
	jr c, .asm_9239
	cp $7b
	jr nc, .asm_9239
	sub $20
.asm_9232
	push af
	ld a, $0e
	ld [bc], a
	pop af
	jr .asm_923e
.asm_9239
	push af
	ld a, $0c
	ld [bc], a
	pop af
.asm_923e
	sub $20
	jr z, .asm_9244
	add $01
.asm_9244
	ld [de], a
	inc de
	inc bc
	pop af
	dec a
	jr nz, .asm_91d2
	ld a, [wdc25]
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, v0BGMap1
	add hl, de
	ld de, wd771
	ld bc, $114
	call Func_83c
	pop af
	ld c, a
	ld a, $14
	sub c
	srl a
	ld e, a
	ld d, $9c
	ld a, $01
	vramswitch
	ld a, [wdc25]
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld b, $01
	ld de, wd7b1
	call Func_83c
	ld a, $00
	vramswitch
	ld hl, wdc25
	inc [hl]
	ret

Func_9292:
	push hl
	call Func_98c5
	ld hl, $52ad
	ld de, wc62d
	ld b, $08
	call CopyHLtoDE
	pop hl
	xor a
	ld [wdc26], a
	ld [wdc25], a
	ld [wdbfe], a
	ret
; 0x92ad

SECTION "Func_935e", ROMX[$535e], BANK[$2]

Func_935e:
	push hl
	call Func_a1e
	pop hl
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	push hl
	ld b, $01
	call Func_a95
	pop hl
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	and a
	jr z, .asm_9382
	push hl
	ld b, $02
	call Func_a95
	pop hl
.asm_9382
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld h, d
	ld l, e
	call Func_93f4
	pop hl
	ld a, $01
	vramswitch
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld h, d
	ld l, e
	call Func_93f4
	pop hl
	ld a, $00
	vramswitch
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wc5fd
	ld b, $40
	jp Func_b1b

Func_93b5:
	ld a, $02
	ld b, $04
	call Func_af6
	ld de, $7960
	ld c, $33
	ld b, $04
	ld a, $53
	call Func_a95
	ld de, $6830
	ld c, $33
	ld b, $04
	ld a, $2b
	call Func_a95
	ld de, $6ae0
	ld c, $33
	ld b, $05
	ld a, $7b
	call Func_a95
	ret

Func_93e1:
	ld hl, $53ec
	ld de, wc60d
	ld b, $08
	jp CopyHLtoDE
; 0x93ec

SECTION "Func_93f4", ROMX[$53f4], BANK[$2]

Func_93f4:
	ld de, v0BGMap0
	ld a, e
	ld [wdc7a], a
	ld a, d
	ld [wdc7b], a
	ld a, $0f
.asm_9401
	push af
	ld b, $14
	ld de, wd771
	call Func_b1b
	push bc
	push hl
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wd771
	ld bc, $114
	call Func_83c
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $20
	add hl, de
	ld a, l
	ld [wdc7a], a
	ld a, h
	ld [wdc7b], a
	pop hl
	pop bc
	pop af
	dec a
	jr nz, .asm_9401
	ret
; 0x9434

SECTION "Func_945c", ROMX[$545c], BANK[$2]

Func_945c:
	ld a, c
	push bc
	call Func_9473
	pop bc
	ld a, $01
	vramswitch
	ld a, b
	call Func_9473
	ld a, $00
	vramswitch
	ret

Func_9473:
	ld hl, wd771
	ld b, $20
.asm_9478
	ld [hli], a
	dec b
	jr nz, .asm_9478
	hlbgcoord 0, 15
	ld b, $11
	jp Func_94ac
; 0x9484

SECTION "Func_9484", ROMX[$5484], BANK[$2]

Func_9484:
	ld a, c
	push bc
	call Func_949b
	pop bc
	ld a, $01
	vramswitch
	ld a, b
	call Func_949b
	ld a, $00
	vramswitch
	ret

Func_949b:
	ld hl, wd771
	ld b, $20
.asm_94a0
	ld [hli], a
	dec b
	jr nz, .asm_94a0
	ld hl, v0BGMap1
	ld b, $20
	jp Func_94ac

Func_94ac:
.asm_94ac
	push bc
	push hl
	ld de, wd771
	ld bc, $120
	call Func_83c
	pop hl
	ld de, TILEMAP_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .asm_94ac
	ret
; 0x94c1

SECTION "Func_94d8", ROMX[$54d8], BANK[$2]

Func_94d8:
	xor a
	ld [wc57a], a
	ld [wdbfd], a
	ld [wdc29], a
	call Func_530
	ld a, [wdc29]
	and a
	jr z, .asm_94f5
	call Func_9523
	call $5bb9 ; Func_9bb9
	xor a
	ld [wdc29], a
.asm_94f5
	call Func_1142
	call Random
	call Func_14bf
	ld a, [wdc29]
	and a
	jr z, .asm_950a
	call Func_9523
	call $5bd1 ; Func_9bd1
.asm_950a
	ld hl, wdbfb
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call_hl
; 0x9515

SECTION "Func_9523", ROMX[$5523], BANK[$2]

Func_9523:
	ld a, [wdc29]
	dec a
	call $5a15 ; Func_9a15
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wdc29]
	dec a
	ret
; 0x9532

SECTION "Func_988e", ROMX[$588e], BANK[$2]

Func_988e:
	ld c, a
	ld a, [wdc1f]
	and a
	jr z, .asm_98a1
	xor a
	ld [wdc1f], a
	ld a, [wdc20]
	xor $01
	ld [wdc20], a
.asm_98a1
	ld a, $78
	ld de, wdc21
	call .Func_98ae
	ld a, $84
	ld de, wdc23
.Func_98ae:
	ld [hli], a
	ld a, [wdc20]
	xor $01
	add_de
	ld a, [de]
	ld [hli], a
	ld a, [wdc20]
	and a
	ld a, $24
	jr z, .asm_98c1
	ld a, $04
.asm_98c1
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

Func_98c5:
	ld hl, $5939
	call Func_935e
	ld de, $6710
	ld c, $33
	ld b, $00
	ld a, $10
	call Func_a95
	ld de, $7fb0
	ld c, $32
	ld b, $00
	ld a, $01
	call Func_a95
	ld a, $01
	ld b, $00
	call Func_af6
	ld de, $7fc0
	ld c, $32
	ld b, $00
	ld a, $01
	call Func_a95
	ld a, $01
	ld b, $00
	call Func_af6
	ld bc, $c00
	call Func_9484
	call Func_93e1
	ld hl, $594a
	ld de, wc63d
	ld b, $18
	call CopyHLtoDE
	ld a, TRUE
	ld [wd54d], a
	xor a
	ld [wd54c], a
	ld a, BANK(Func_9c91)
	ld de, Func_9c91
	ld hl, wd54e
	ld [hli], a
	ld [hl], e ; wd54f
	inc hl
	ld [hl], d
	ld de, $5a2c
	ld hl, wdbfb
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $01
	ld [wdbfa], a
	ld a, $03
	jp Func_cf2
; 0x9939

SECTION "Func_9a2c", ROMX[$5a2c], BANK[$2]

Func_9a2c:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	ld [hli], a
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
	ld a, [wdbfa]
	and a
	jr z, .asm_9a80
	ld a, [wdbfe]
	sub $28
	ld c, a
	ld a, [wdbfe]
	rrca
	rrca
	rrca
	and $1f
	ld [wdc7a], a
	ld b, $28
	call Func_9a89
	ld a, [wdbfe]
	and $07
	jr z, .asm_9a65
	cpl
	inc a
	add $08
	add b
	ld b, a
	ld a, $08
	jr .asm_9a6b
.asm_9a65
	ld a, $08
	add b
	ld b, a
	ld a, $07
.asm_9a6b
	push af
	call Func_9a89
	ld a, b
	add $08
	ld b, a
	pop af
	dec a
	jr nz, .asm_9a6b
	ld a, $68
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
.asm_9a80
	ldh a, [hff99]
	call Func_988e
	ld a, $ff
	ld [hl], a
	ret

Func_9a89:
	ld a, b
	ld [hli], a
	ld de, wdbff
	ld a, [wdc7a]
	add_de
	ld a, [de]
	and $01
	jr z, .asm_9a99
	ld a, $fc
.asm_9a99
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, $0e
	ld [hli], a
	ld a, [wdc7a]
	inc a
	and $1f
	ld [wdc7a], a
	ret
; 0x9aa9

SECTION "Func_9c91", ROMX[$5c91], BANK[$2]

Func_9c91:
	ld a, [wdbfa]
	and a
	jp z, Func_9d1a
	ld a, [wc57a]
	and $04
	jr nz, Func_9d1a
	ld a, [wdbfe]
	ld b, a
	ld a, [wdc26]
	add a
	add a
	add a
	add $28
	sub b
	ld b, a
	ld hl, wdbff
	ld a, [wdc26]
	add_hl
	ld a, [hl]
	add a
	add a
	cpl
	inc a
	add $48
	ld c, a
	ld de, $212
	push bc
	push hl
	call Func_1393
	pop hl
	pop bc
	ld a, [hl]
	add a
	add a
	add a
	add c
	add $08
	ld c, a
	ld de, $2212
	call Func_1393
;	fallthrough

Func_9cd4:
	ld a, [wdc25]
	cp $08
	jr c, Func_9d1a
	ld a, [wdbfe]
	and a
	jr z, .asm_9cf5
	ld bc, $2048
	ld e, $10
	ld d, $02
	call Func_1393
	ld bc, $2050
	ld e, $10
	ld d, $22
	call Func_1393
.asm_9cf5
	ld a, [wdc25]
	add a
	add a
	add a
	sub $40
	ld c, a
	ld a, [wdbfe]
	cp c
	jr nc, Func_9d1a
	jr z, Func_9d1a
	ld bc, $6048
	ld e, $10
	ld d, $42
	call Func_1393
	ld bc, $6050
	ld e, $10
	ld d, $62
	call Func_1393
;	fallthrough

Func_9d1a:
	ld hl, $5d38
	call .Func_9d23
	ld hl, $5d48
.Func_9d23:
	ld b, $04
.loop
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	call Func_1393
	pop hl
	pop bc
	dec b
	jr nz, .loop
	ret
; 0x9d38

SECTION "Func_a0e2", ROMX[$60e2], BANK[$2]

Func_a0e2:
	ld a, $04
.loop
	push af
	ld a, [hli]
	push af
	ld de, $6114
	add_de
	ld a, [de]
	add $03
	ld d, a
	pop af
	add a
	add a
	add $80
	ld e, a
	push hl
	push bc
	push de
	call Func_1393
	pop de
	pop bc
	ld a, c
	add $08
	ld c, a
	inc e
	inc e
	push bc
	push de
	call Func_1393
	pop de
	pop bc
	ld a, c
	add $10
	ld c, a
	pop hl
	pop af
	dec a
	jr nz, .loop
	ret
; 0xa114

SECTION "Func_a491", ROMX[$6491], BANK[$2]

Func_a491:
	ld a, $17
	call Func_1497
	jr nc, .asm_a4a0
	ld de, $15b3
	ld a, $00
	call Func_1569
.asm_a4a0
	call Func_2ca
	call Func_1e3f
	ld a, $01
	ld [wdbfd], a
	jp Func_15b3
; 0xa4ae
