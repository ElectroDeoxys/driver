Pals_8000:
	rgb  0,  0,  0
	rgb 27,  0,  0
	rgb 11, 11, 11
	rgb 31, 31, 31

GetHUDGfxPointer:
	push af
	push hl
	ld a, [wLanguage]
	ld l, a
	add a
	add l ; *3
	ld hl, .HUDGfx
	add_hl
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	pop af
	ret

.HUDGfx:
	dba EnglishHUDGfx ; ENGLISH
	dba FrenchHUDGfx  ; FRENCH
	dba GermanHUDGfx  ; GERMAN
	dba ItalianHUDGfx ; ITALIAN
	dba SpanishHUDGfx ; SPANISH

; loads HUD that occupies the 2 bottom rows of the screen
LoadHUD::
	ld hl, Pals_8000
	ld de, wTempBGPals palette 7
	ld b, 1 palettes
	call CopyHLtoDE

	ld a, 0
	ld [wVRAMNumTiles_v1_8800], a
	ld a, 1 ; tile
	ld b, V1TILES_8800
	call BlackOutVRAMTiles

	call GetHUDGfxPointer
	; skip over number gfx
	ld hl, 16 tiles
	add hl, de
	ld d, h
	ld e, l
	ld b, V1TILES_8800
	ld a, 26 ; tiles
	call PushTilesToVRAM

	ld hl, .BoxTilemap
	ld de, wd840
	ld b, 2 * SCREEN_WIDTH
.asm_805a
	ld a, [hli]
	add $80
	ld [de], a
	inc de
	dec b
	jr nz, .asm_805a

	hlbgcoord 0, 16, v0BGMap1
	ld de, wd840
	lb bc, 2, SCREEN_WIDTH
	call CopyBGMapBox
	ld a, BANK("VRAM1")
	vramswitch
	hlbgcoord 0, 16, v0BGMap1
	ld de, .BoxAttrmap
	lb bc, 2, SCREEN_WIDTH
	call CopyBGMapBox
	ld a, BANK("VRAM0")
	vramswitch

	ld a, $80
	call .FillRows
	ld a, BANK("VRAM1")
	vramswitch
	ld a, 7 | BG_BANK1
	call .FillRows
	ld a, BANK("VRAM0")
	vramswitch

	xor a
	ld [wd869], a
	ld [wd86b], a
	ld [wTimerMode], a
	ld [wTimerActive], a
	ld [wd870], a
	ld [wd8e5], a
	ld [wd8ea], a
	ld [wd8e8], a
	ld [wd8e9], a
	ld [wd877], a
	ld [wd894], a

	ld hl, wd874
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld a, [wdc32]
	and WDC32_UNK4
	jr z, .skip_numbers
	; load number gfx
	ld a, BANK("VRAM1")
	vramswitch
	call GetHUDGfxPointer
	ld h, d
	ld l, e
	ld de, v0Tiles1 tile $0b
	ld b, 10 ; tiles
	call SafeCopyFarTiles
	ld a, BANK("VRAM0")
	vramswitch

.skip_numbers
	ld a, [wGameMode]
	cp MODE_CREDITS
	jp z, Func_8bef
	ret

; fills 4 rows with value given in a
; starting from row 18 (to VRAM0 or VRAM1)
.FillRows:
	ld hl, wGfxBuffer
	ld bc, TILEMAP_WIDTH
	call FillMemory
	hlbgcoord 0, 18, v0BGMap1
	ld b, 4
.loop_rows
	push bc
	ld de, wGfxBuffer
	lb bc, 1, TILEMAP_WIDTH
	push hl
	call CopyBGMapBox
	pop hl
	ld de, TILEMAP_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .loop_rows
	ret

.BoxTilemap:
	; DAMAGE and FELONY bars/text tiles
	db $01, $02, $02, $02, $02, $02, $02, $02, $01, $00, $00, $01, $02, $02, $02, $02, $02, $02, $02, $01
	db $00, $0b, $0c, $0d, $0e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $10, $11, $12, $00

.BoxAttrmap:
	; DAMAGE and FELONY bars/text attributes
	db 7 | BG_BANK1, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1 | BG_XFLIP, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1 | BG_XFLIP
	db 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1, 7 | BG_BANK1

Func_8162::
	ld a, [wGameMode]
	cp MODE_CREDITS
	jp z, Func_8c64
	ld a, [wc579]
	and a
	jr nz, .asm_8185
	call UpdateTimer
	call Func_8189
	call Func_8273
	call Func_829d
	call Func_8220
	call Func_81cd
	call Func_8318
.asm_8185
	call Func_8977
	ret

Func_8189:
	ld a, [wdc32]
	and WDC32_UNK4
	ret z
	ld c, $8b
	ld de, wd855
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_0A
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_82db
	ld de, wd863
	ld hl, wPlayerCarPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_07
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_82db
	hlbgcoord 1, 17, v0BGMap1
	ld de, wd855
	lb bc, 1, 4
	call CopyBGMapBox
	hlbgcoord 15, 17, v0BGMap1
	ld de, wd863
	lb bc, 1, 4
	jp CopyBGMapBox

Func_81cd:
	ld a, [wTimerMode]
	and a
	jr z, .no_timer
	ld de, wTimer
	ld hl, wd874
	ld a, [de]
	cp [hl]
	jr nz, .asm_81e2
	inc hl
	inc de
	ld a, [de]
	cp [hl]
	ret z
.asm_81e2
	ld b, $9c
	ld hl, wTimer + $2
	ld de, wd876
	call Func_84a7
	ld hl, wd85b
	ld a, $9c
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	jr .asm_8214
.no_timer
	ld hl, wd874
	ld a, $ff
	cp [hl]
	ret z
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wd85b
	ld a, $80
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.asm_8214
	hlbgcoord 7, 17, v0BGMap1
	ld de, wd85b
	lb bc, 1, 6
	jp CopyBGMapBox

Func_8220:
	ld a, [wdc32]
	and WDC32_UNK4
	ret nz
	ld a, [wTimerMode]
	and a
	jr z, .asm_8256
	cp TIMER_MODE_COUNT_UP
	jr z, .asm_8249
	ld a, [wTimerActive]
	and a
	jr z, .asm_8249
	ld hl, wTimer + $2
	ld a, [hld]
	and a
	jr nz, .asm_8249
	ld a, [hl]
	cp $10
	jr nc, .asm_8249
	ld a, [wc57a]
	and $08
	jr z, .asm_8256
.asm_8249
	ld hl, wd870
	ld a, [hl]
	and a
	ret nz
	ld [hl], $01
	lb bc, $94, $93
	jr .asm_8261
.asm_8256
	ld hl, wd870
	ld a, [hl]
	and a
	ret z
	ld [hl], $00
	lb bc, $80, $80
.asm_8261
	ld hl, wd849
	ld [hl], c
	inc hl
	ld [hl], b
	hlbgcoord 9, 16, v0BGMap1
	ld de, wd849
	lb bc, 1, 2
	jp CopyBGMapBox

Func_8273:
	ld hl, wd868
	call Func_82c7
	ret z
	ld hl, wd841
	ld b, $07
.asm_827f
	sub $08
	jr c, .asm_8287
	ld [hl], $8a
	jr .asm_828d
.asm_8287
	add $08
	add $82
	ld [hl], a
	xor a
.asm_828d
	inc hl
	dec b
	jr nz, .asm_827f
	hlbgcoord 1, 16, v0BGMap1
	ld de, wd841
	lb bc, 1, 7
	jp CopyBGMapBox

Func_829d:
	ld hl, wd86a
	call Func_82c7
	ret z
	ld hl, wd852
	ld b, $07
.asm_82a9
	sub $08
	jr c, .asm_82b1
	ld [hl], $8a
	jr .asm_82b7
.asm_82b1
	add $08
	add $82
	ld [hl], a
	xor a
.asm_82b7
	dec hl
	dec b
	jr nz, .asm_82a9
	hlbgcoord 12, 16, v0BGMap1
	ld de, wd84c
	lb bc, 1, 7
	jp CopyBGMapBox

Func_82c7:
	ld a, [hli]
	cp [hl]
	ret z
	jr c, .asm_82cf
	inc [hl]
	jr .asm_82d0
.asm_82cf
	dec [hl]
.asm_82d0
	ld a, [hl]
	cp $39
	jr c, .asm_82d7
	ld [hl], $38
.asm_82d7
	xor a
	dec a
	ld a, [hl]
	ret

Func_82db:
	push de
	ld b, c
.asm_82dd
	ld de, -$3e8
	add hl, de
	bit 7, h
	jr nc, .asm_82e8
	inc b
	jr .asm_82dd
.asm_82e8
	ld de, $3e8
	add hl, de
	pop de
	ld a, b
	ld [de], a
	inc de
	push de
	ld b, c
.asm_82f2
	ld de, hROMBank
	add hl, de
	bit 7, h
	jr nc, .asm_82fd
	inc b
	jr .asm_82f2
.asm_82fd
	ld de, $64
	add hl, de
	pop de
	ld a, b
	ld [de], a
	inc de
	ld b, c
	ld a, l
.asm_8307
	sub $0a
	jr c, .asm_830e
	inc b
	jr .asm_8307
.asm_830e
	add $0a
	ld l, a
	ld a, b
	ld [de], a
	inc de
	ld a, l
	add c
	ld [de], a
	ret

Func_8318:
	ld a, [wd877]
	and a
	ret z
	dec a
	jumptable
; 0x831f

SECTION "Func_83b2", ROMX[$43b2], BANK[$2]

Func_83b2::
	ld a, c
	ld [wd877], a
	and a
	ret z
	push af
	call Func_88b1
	pop af
	dec a
	jumptable
; 0x83bf

SECTION "Func_84a7", ROMX[$44a7], BANK[$2]

Func_84a7:
	ld a, [hl]
	and $f0 ; tens
	ld c, a
	ld a, [de]
	and $f0
	cp c
	jr z, .asm_84be
	ld a, [de]
	and $0f ; ones
	or c
	ld [de], a
	ld a, c
	swap a
	ld c, $00
	call .Func_8530
.asm_84be
	inc b
	ld a, [hl]
	and $0f
	ld c, a
	ld a, [de]
	and $0f
	cp c
	jr z, .asm_84d4
	ld a, [de]
	and $f0
	or c
	ld [de], a
	ld a, c
	ld c, $0b
	call .Func_8530
.asm_84d4
	inc b
	dec hl
	dec de
	ld a, [hl]
	and $f0
	ld c, a
	ld a, [de]
	and $f0
	cp c
	jr z, .asm_84ee
	ld a, [de]
	and $0f
	or c
	ld [de], a
	ld a, c
	swap a
	ld c, $00
	call .Func_8530
.asm_84ee
	inc b
	ld a, [hl]
	and $0f
	ld c, a
	ld a, [de]
	and $0f
	cp c
	jr z, .asm_8504
	ld a, [de]
	and $f0
	or c
	ld [de], a
	ld a, c
	ld c, $0b
	call .Func_8530
.asm_8504
	inc b
	dec hl
	dec de
	ld a, [hl]
	and $f0
	ld c, a
	ld a, [de]
	and $f0
	cp c
	jr z, .asm_851e
	ld a, [de]
	and $0f
	or c
	ld [de], a
	ld a, c
	swap a
	ld c, $00
	call .Func_8530
.asm_851e
	inc b
	ld a, [hl]
	and $0f
	ld c, a
	ld a, [de]
	and $0f
	cp c
	ret z
	ld a, [de]
	and $f0
	or c
	ld [de], a
	ld a, c
	ld c, $16
.Func_8530:
	push de
	push hl
	ld l, a
	ld a, $0a
	sub l
	add c
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	push bc
	call GetHUDGfxPointer
	; skip over number and hud gfx
	add hl, de
	ld de, (16 + 26) tiles
	add hl, de
	push hl
	ld l, b
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	add $80
	ld h, a
	ld d, h
	ld e, l
	pop hl
	ld a, BANK("VRAM1")
	vramswitch
	ld b, 1 ; tile
	call SafeCopyFarTiles
	ld a, BANK("VRAM0")
	vramswitch
	pop bc
	pop hl
	pop de
	ret
; 0x856b

SECTION "Func_859d", ROMX[$459d], BANK[$2]

Func_859d::
	ld a, [wd895]
	jumptable
; 0x85a1

SECTION "Func_88b1", ROMX[$48b1], BANK[$2]

Func_88b1:
	ld hl, wGfxBuffer
	ld a, $80
	ld bc, $14
	call FillMemory
	ld de, wGfxBuffer
	call .Func_88e0
	ld hl, wGfxBuffer
	ld a, $0f
	ld bc, $14
	call FillMemory
	ld de, wGfxBuffer
	ld a, $01
	vramswitch
	call .Func_88e0
	ld a, $00
	vramswitch
	ret

.Func_88e0:
	ld hl, v0BGMap1
	lb bc, $1, $14
	jp CopyBGMapBox
; 0x88e9

SECTION "Func_891e", ROMX[$491e], BANK[$2]

Func_891e::
	call GetText2
	push bc
	call .Func_8930
	ld a, $01
	ld [wd8e5], a
	pop bc
	ld a, c
	ld [wd8e7], a
	ret

.Func_8930:
	xor a
	ld [wd8e4], a
	ld a, $10
	push hl
	call Func_8b94
	pop hl
	ld a, [wCharacterSetSize]
	cp $11
	jr nc, .asm_8948
	ld a, [wd8e2]
	; return if < 21
	cp 21
	ret c
.asm_8948
	ld a, $01
	ld [wd8e4], a
	ld a, $20
	call Func_8b94
	ld a, [wCharacterSetSize]
	cp $21
	jr nc, .text_error
	ld a, [wd8e2]
	; return if < 41
	cp $29
	ret c
.text_error
	ld hl, .TextErrorText
	xor a
	ld [wd8e4], a
	ld a, $10
	jp Func_8b94

.TextErrorText:
	db "TEXT ERROR!\0"

Func_8977:
	ld a, [wd8e5]
	and a
	ret z
	dec a
	jumptable
	dw .Func_8986 ; $1
	dw .Func_89a1 ; $2
	dw .Func_89ef ; $3
	dw .Func_8a52 ; $4

.Func_8986:
	ld a, $80
	call .Func_8a76
	call .Func_8a7f
	xor a
	ld [wd8ea], a
	ld [wd8e8], a
	ld [wd8e9], a
	ld [wd8e6], a
	ld a, $02
	ld [wd8e5], a
	ret

.Func_89a1:
	ld a, [wd8e4]
	and $01
	jp nz, .asm_8a8b

	; load tiles that are in the character set
	ld a, [wd8e6]
	ld c, a
	ld hl, wCharacterSet
	add_hl
	ld a, [hl]
	and a
	jr nz, .asm_89bb
	ld a, $03
	ld [wd8e5], a
	ret
.asm_89bb
	ld l, a
	ld h, $00
	ld de, $521d
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *32
	add hl, de
	push hl
	ld l, c
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *32
	ld de, v0Tiles1 tile $28
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld c, $34
	ld b, 2 ; tiles
	ld a, $01
	vramswitch
	call SafeCopyFarTiles
	ld a, $00
	vramswitch
	ld hl, wd8e6
	inc [hl]
	ret

.Func_89ef:
	ld a, $0f
	call .Func_8a76
	ld a, $01
	vramswitch
	call .Func_8a7f
	ld a, $00
	vramswitch
	ld a, $80
	call .Func_8a76
	ld a, [wd8e4]
	and a
	jp nz, .Func_8ada
	ld a, [wd8e2]
	ld c, a
	and $01
	jr z, .asm_8a19
	ld a, $fc
.asm_8a19
	ld [wd8e8], a
	ld [wd8e9], a
	ld a, c
	cpl
	inc a
	add $14
	srl a
	ld de, wGfxBuffer
	add_de
	ld hl, wd8b9
.asm_8a2d
	ld a, [hli]
	cp $ff
	jr z, .asm_8a46
	and a
	jr z, .asm_8a43
	dec a
	add a
	add $a8
	ld [de], a
	ld c, a
	push de
	ld a, $14
	add_de
	ld a, c
	inc a
	ld [de], a
	pop de
.asm_8a43
	inc de
	jr .asm_8a2d

.asm_8a46
	xor a
	ld [wd8e6], a
	ld a, $04
	ld [wd8e5], a
	call .Func_8a7f
.Func_8a52:
	ld hl, wd8e6
	inc [hl]
	ld a, [hl]
	and $08
	ld a, $10
	jr z, .asm_8a5f
	ld a, $20
.asm_8a5f
	ld [wd8ea], a
	ld a, [hl]
	ld hl, wd8e7
	cp [hl]
	ret c
	xor a
	ld [wd8ea], a
	ld [wd8e8], a
	ld [wd8e9], a
	ld [wd8e5], a
	ret

.Func_8a76:
	ld hl, wGfxBuffer
	ld bc, 2 * SCREEN_WIDTH
	jp FillMemory

.Func_8a7f:
	ld de, wGfxBuffer
	hlbgcoord 0, 18, v0BGMap1
	lb bc, 2, SCREEN_WIDTH
	jp CopyBGMapBox

.asm_8a8b
	ld b, $02
.asm_8a8d
	; load tiles that are in the character set
	ld a, [wd8e6]
	ld c, a
	ld hl, wCharacterSet
	add_hl
	ld a, [hl]
	and a
	jr z, .asm_8aa2
	push bc
	call .Func_8aa8
	pop bc
	dec b
	jr nz, .asm_8a8d
	ret
.asm_8aa2
	ld a, $03
	ld [wd8e5], a
	ret

.Func_8aa8:
	ld de, $5e1d
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *16
	add hl, de
	push hl
	ld l, c
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *16
	ld de, v0Tiles1 tile $28
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld c, $34
	ld b, 1 ; tile
	ld a, $01
	vramswitch
	call SafeCopyFarTiles
	ld a, $00
	vramswitch
	ld hl, wd8e6
	inc [hl]
	ret

.Func_8ada:
	ld a, [wd8e2]
	cp $15
	jr nc, .asm_8b17
	ld hl, wd8b9
	ld de, wGfxBuffer
	call .Func_8afa
	ld a, [wd8e2]
	ld hl, wd8e8
	call .Func_8b0f
	xor a
	ld [wd8e9], a
	jp .asm_8a46

.Func_8afa:
	cpl
	inc a
	add $14
	srl a
	add_de
.asm_8b01
	ld a, [hli]
	cp $ff
	ret z
	and a
	jr z, .asm_8b0c
	dec a
	add $a8
	ld [de], a
.asm_8b0c
	inc de
	jr .asm_8b01

.Func_8b0f:
	and $01
	jr z, .asm_8b15
	ld a, $fc
.asm_8b15
	ld [hl], a
	ret
.asm_8b17
	ld hl, wd8cc
	ld b, $14
.asm_8b1c
	ld a, [hld]
	and a
	jr z, .asm_8b23
	dec b
	jr nz, .asm_8b1c
.asm_8b23
	ld a, b
	and a
	jr z, .asm_8b3f
	dec a
	jr z, .asm_8b3f
	ld [wdc7a], a
	inc a
	ld [wdc7c], a
	ld b, a
	ld a, [wd8e2]
	sub b
	cp $15
	jr nc, .asm_8b3f
	ld [wdc7e], a
	jr .asm_8b4f
.asm_8b3f
	ld a, $14
	ld [wdc7a], a
	ld [wdc7c], a
	ld a, [wd8e2]
	sub $14
	ld [wdc7e], a
.asm_8b4f
	ld hl, wd8b9
	ld de, wGfxBuffer
	ld a, [wdc7a]
	call .Func_8b80
	ld hl, wd8b9
	ld a, [wdc7c]
	add_hl
	ld de, wGfxBuffer + $14
	ld a, [wdc7e]
	call .Func_8b80
	ld a, [wdc7a]
	ld hl, wd8e8
	call .Func_8b0f
	ld a, [wdc7e]
	ld hl, wd8e9
	call .Func_8b0f
	jp .asm_8a46

.Func_8b80:
	push af
	push de
	ld de, wd7b1
	ld b, a
	call CopyHLtoDE
	ld a, $ff
	ld [de], a
	pop de
	pop af
	ld hl, wd7b1
	jp .Func_8afa

; input:
; - a = ?
Func_8b94:
	ld [wdc7a], a
	push hl

	; clear character set
	ld b, a
	ld hl, wCharacterSet
	xor a
.loop_clear
	ld [hli], a
	dec b
	jr nz, .loop_clear
	pop hl

	xor a
	ld [wCharacterSetSize], a
	ld de, wd8b9
.loop_chars
	ld a, [hli]
	and a
	jr z, .null_terminator
	push de
	call .AddToSet
	pop de
	ld [de], a ; add char index
	inc de
	jr .loop_chars
.null_terminator
	ld a, $ff
	ld [de], a

	ld hl, -wd8b9
	add hl, de
	; hl = size of wd8b9 (excluding terminating byte)
	ld a, l
	ld [wd8e2], a
	ret

.AddToSet:
	sub ' '
	ret z ; is space
	; non-space character
	ld c, a
	ld de, wCharacterSet
	ld b, 0
.loop_character_set
	; is this index taken already?
	ld a, [de]
	and a
	jr nz, .compare_chars
	; not taken, we can add this character to the set
	ld a, c
	ld [de], a
	ld a, [wCharacterSetSize]
	inc a
	ld [wCharacterSetSize], a
.return_index
	ld a, b
	inc a
	ret
.compare_chars
	; if it's the same as current character,
	; just return its index (nothing to add)
	cp c
	jr z, .return_index
	; is different, let's continue comparing
	; with rest of the set...
	inc de
	inc b ; increment index
	; are we at maximum size alread?
	ld a, [wdc7a]
	cp b
	jr nz, .loop_character_set ; no
	; yes, return 0 index
	ld a, [wCharacterSetSize]
	inc a
	ld [wCharacterSetSize], a
	xor a
	ret

Func_8bef:
	xor a
	ld [wVRAMNumTiles_v1_8800], a

	ld a, 1 ; tile
	ld b, V1TILES_8800
	call BlackOutVRAMTiles

	ld de, FontGfx
	ld c, BANK(FontGfx)
	ld b, V1TILES_8800
	ld a, $53 ; tiles
	call PushTilesToVRAM

	ld hl, Pals_8c5c
	ld de, wTempBGPals palette 7
	ld b, 1 palettes
	call CopyHLtoDE

	lb bc, 7 | BG_BANK1, $80
	call .FillBGMap

	xor a
	ld [wdc90], a
	ld [wdc91], a
	ld [wdc92], a
	ret

.FillBGMap:
	ld a, c
	push bc
	call .FillRows
	pop bc
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	call .FillRows
	ld a, BANK("VRAM0")
	vramswitch
	ret

.FillRows:
	ld hl, wGfxBuffer
	ld b, TILEMAP_WIDTH
.loop_fill
	ld [hli], a
	dec b
	jr nz, .loop_fill

	hlbgcoord 0, 0, v0BGMap1
	ld b, TILEMAP_HEIGHT
.loop_rows
	push bc
	push hl
	ld de, wGfxBuffer
	lb bc, 1, TILEMAP_WIDTH
	call CopyBGMapBox
	pop hl
	ld de, TILEMAP_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .loop_rows
	ret

Pals_8c5c:
	rgb 31, 31, 31
	rgb  0,  0, 31
	rgb  0,  0, 28
	rgb  0,  0, 24

Func_8c64:
	ld hl, wdc91
	ld a, [hl]
	and a
	jr z, .asm_8c78
	dec [hl]
	ret
.asm_8c6d
	ld hl, wdc90
	dec [hl]
	ld a, b
	and $7f
	ld [wdc91], a
	ret
.asm_8c78
	ld hl, wdc90
	ld a, [hl]
	inc a
	ld [hl], a
	and $07
	cp $02
	ret nz
	ld hl, wGfxBuffer
	ld a, $80
	ld bc, $14
	call FillMemory
	call Func_1e7e
	bit 7, b
	jr nz, .asm_8c6d
	ld c, b
	ld a, b
	and a
	jr z, .asm_8cda
	ld a, $14
	sub b
	srl a
	ld de, wGfxBuffer
	add_de
.asm_8ca3
	ld a, [hli]
	add $60
	ld [de], a
	inc de
	dec b
	jr nz, .asm_8ca3
.asm_8cab
	ld hl, wdc95
	ld a, [wdc90]
	add $10
	rrca
	rrca
	rrca
	and $1f
	add_hl
	xor a
	bit 0, c
	jr z, .asm_8cc0
	ld a, $fc
.asm_8cc0
	ld [hl], a
	ld a, [wdc90]
	add $10
	and $f8
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	ld de, v0BGMap1
	add hl, de
	ld de, wGfxBuffer
	lb bc, 1, 20
	jp CopyBGMapBox
.asm_8cda
	ld a, $01
	ld [wdc92], a
	jr .asm_8cab

Titlescreen::
	ld a, MUSIC_TITLESCREEN
	call PlayMusicIfNotPlaying
	ld a, TRUE
	ld [wResetDisabled], a
	call Func_8d7d
	ld a, [wTitlescreenTransition]
	cp GOTO_MAIN_MENU
	jr z, MainMenu

; start credits
	ld a, MODE_CREDITS
	ld [wGameMode], a
	xor a
	ld [wResetDisabled], a
	ret

MainMenu::
	ld a, TRUE
	ld [wResetDisabled], a

	ld a, MUSIC_MAIN_MENU
	call PlayMusic

	call Func_8ddb
	call InitMainMenu

	lb bc, 2 | BG_BANK1, $00
	call Func_945c

	xor a
	ld [wMainMenuEntry], a
	xor a
	ld [wdc2f], a

	ld hl, Func_961f
	ld c, BANK(Func_961f)
	ld b, $13
	call SpawnEntity

	ld hl, EntUpdate_MainMenuTimer
	ld c, BANK(EntUpdate_MainMenuTimer)
	ld b, $17
	call SpawnEntity

	call Func_94d8

	ld a, [wGameMode]
	cp MODE_CREDITS
	jr nz, .asm_8d40
	ld a, MUSIC_TITLESCREEN
	call PlayMusicIfNotPlaying
.asm_8d40
	xor a
	ld [wResetDisabled], a
	ret

EntUpdate_MainMenuTimer:
	call YieldEntityUpdateUntilFadeEnds

	ld bc, MAIN_MENU_CREDITS_TIMER
.reset_timer
	ld hl, 0
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wdc2f]
	and a
	jr nz, .reset_timer
	ld a, [wJoypadDown]
	and a
	jr nz, .reset_timer
	inc hl
	ld a, h
	cp b
	jr nz, .compare_timer
	ld a, l
	cp c
.compare_timer
	jr c, .loop

	ld a, $13
	call FindEntity
	ld de, ExitTitlescreenOrMainScreen
	ld a, BANK(ExitTitlescreenOrMainScreen)
	call Func_1569

	ld a, MODE_CREDITS
	ld [wGameMode], a
	jp YieldEntityUpdateIndefinitely

Func_8d7d:
	call Func_8ddb

	ld de, Func_8dcb
	ld hl, wMenuUpdateFunc
	ld [hl], e
	inc hl
	ld [hl], d

	xor a
	ld [wd54d], a

	ld a, SCENE_TITLESCREEN
	call LoadScene

	ld a, $01
	call InitFade

	ld hl, EntUpdate_TitlescreenTimer
	ld c, BANK(EntUpdate_TitlescreenTimer)
	ld b, $16
	call SpawnEntity
	jp Func_94d8

EntUpdate_TitlescreenTimer:
	call YieldEntityUpdateUntilFadeEnds
	ld bc, TITLESCREEN_CREDITS_TIMER
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr nz, .a_or_start_btn
	dec bc
	ld a, b
	or c
	jr nz, .loop
; trigger credits
	ld a, GOTO_CREDITS
	ld [wTitlescreenTransition], a
	jp ExitTitlescreenOrMainScreen
.a_or_start_btn
	ld a, GOTO_MAIN_MENU
	ld [wTitlescreenTransition], a
	jp ExitTitlescreenOrMainScreen

Func_8dcb:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	ld [hli], a ; SCX
	ld [hli], a ; SCY
	ldh a, [hff99]
	ld [hli], a ; LCDC
	ld a, $ff
	ld [hl], a ; LYC
	ret

Func_8ddb:
	call EmptyScreen
	call ClearVRAMTiles
	call Func_110b
	call ClearEntities
	call Func_93b5
	xor a
	ld [wdc20], a
	ret
; 0x8def

SECTION "Func_90aa", ROMX[$50aa], BANK[$2]

Func_90aa::
	ld a, [wGameMode]
	cp MODE_UNDERCOVER
	ret nz
	call Func_8ddb

	ld a, [wMission]
	ld hl, MissionTextTable
	get_pointer
	call GetText1
	call Func_9177
	call Func_a096

	ld hl, Pals_da3a0
	ld c, BANK(Pals_da3a0)
	ld b, 5 palettes
	ld de, wTempOBPals palette 3
	call FarCopy

	call LoadMissionCode

	lb bc, 2 | BG_BANK1, $00
	call Func_945c

	ld hl, CodeTexts
	call ProcessTitleText

	ld a, BANK(Func_9159)
	ld de, Func_9159
	ld hl, wd54e
	ld [hli], a
	ld [hl], e ; wd54f
	inc hl
	ld [hl], d
	ld hl, Func_9102
	ld c, BANK(Func_9102)
	ld b, $15
	call SpawnEntity
	ld a, $03
	call InitFade
	ld a, MUSIC_BRIEFING
	call PlayMusicIfNotPlaying
	jp Func_94d8

Func_9102:
	call YieldEntityUpdateUntilFadeEnds
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr z, .asm_9119
	ld a, SFX_06
	call PlaySFX
	jp ExitTitlescreenOrMainScreen
.asm_9119
	call .Func_911e
	jr .loop

.Func_911e:
	ld a, [wTextLine]
	cp $09
	ret c
	ld hl, wdbfe
	ld a, [wJoypadPressed]
	and PAD_UP | PAD_DOWN
	and PAD_UP
	jr nz, .d_up
	ld a, [wJoypadPressed]
	and PAD_DOWN
	jr nz, .d_down
	ret
.d_up
	ld a, [hl]
	and a
	ret z
	sub $08
	ld [hl], a
	ld a, SFX_05
	jp PlaySFX
.d_down
	ld a, [wTextLine]
	add a
	add a
	add a ; *8
	sub 64
	ld c, a
	; c = 8 * lines - 64
	ld a, [hl]
	cp c
	ret nc
	ret z
	ld a, [hl]
	add $08
	ld [hl], a
	ld a, SFX_05
	jp PlaySFX

Func_9159:
	ld hl, wMissionCode
	ld c, 56 ; x
	ld a, [wLanguage]
	cp GERMAN + 1
	jr c, .got_x
	ld c, 64 ; x
.got_x
	; for English/French/German, x = 56
	; for Italian/Spanish,       x = 64
	ld b, 126 ; y
	call LoadMissionCodeOAM
	ld a, [wc57a]
	and $04
	jp z, Func_9d1a
	jp Func_9cd4

Func_9177:
	call Func_9292
.loop_lines
	push hl
	call .GetLineSize
	pop hl
	ld a, c
	and a
	ret z ; no more characters
	push bc
	push hl
	call .ProcessTextLine
	pop hl
	pop bc
	ld a, b
	add_hl
	jr .loop_lines

.GetLineSize:
	ld c, 0
	ld b, 0
.loop_text
	; do we still have space in current line?
	; we only accept (MAX_LINE_SIZE - 1) characters
	ld a, c
	cp MAX_LINE_SIZE - 1
	jr c, .still_has_space
	; no more space, the last character will be set to \0
	; returns b = c + 1
	ld c, b
	inc b
	ret
.still_has_space
	ld a, [hli]
	and a
	jr z, .terminator
	cp '\n'
	jr z, .new_line
	cp ' '
	jr nz, .not_space
	; space
	ld b, c
.not_space
	inc c
	jr .loop_text
.terminator
	; returns b = c
	ld b, c
	ret
.new_line
	; returns b = c + 1
	ld b, c
	inc b
	ret

; input:
; - a  = ?
; - hl = text to be processed
.ProcessTextLine:
	push af
	push hl
	ld hl, wGfxBuffer
	ld bc, $20
	call ClearMemory
	pop hl
	ld de, wTextLineLengths
	ld a, [wTextLine]
	add_de
	pop af
	ld [de], a

	push af
	ld de, wGfxBuffer
	ld b, a
	ld a, $14
	sub b
	srl a
	add_de
	ld a, b
	ld bc, wd7b1
.loop_chars
	push af
	ld a, [hli]
	cp '\"' ; "
	jr z, .white_char
	cp '<\'>'
	jr nz, .highlighted_full_stop
	ld a, '\''
	jr .white_char
.highlighted_full_stop
	cp '<.>'
	jr nz, .highlighted_dash
	ld a, '.'
	jr .white_char
.highlighted_dash
	cp '<->'
	jr nz, .highlighted_five
	ld a, '-'
	jr .white_char
.highlighted_five
	cp '<5>'
	jr nz, .highlighted_comma
	ld a, '5'
	jr .white_char
.highlighted_comma
	cp '<,>'
	jr nz, .highlighted_exclamation_mark
	ld a, ','
	jr .white_char
.highlighted_exclamation_mark
	cp '<!>'
	jr nz, .highlighted_reversed_exclamation_mark
	ld a, '!'
	jr .white_char
.highlighted_reversed_exclamation_mark
	cp '<¡>'
	jr nz, .normal_diacritics
	ld a, '¡'
	jr .white_char

.normal_diacritics
	cp 'Á'
	jr c, .highlighted_diacritics
	cp 'ß' + 1
	jr nc, .highlighted_diacritics
	sub $40
	jr .yellow_char
.highlighted_diacritics
	cp 'á'
	jr c, .normal_chars
	cp '<ß>' + 1
	jr nc, .normal_chars
	sub $80
	jr .white_char

.normal_chars
	; everything between 'a' and 'z' is white
	cp 'a'
	jr c, .yellow_char
	cp 'z' + 1
	jr nc, .yellow_char
	; transform to uppercase ASCII
	sub 'a' - 'A'
.white_char
	push af
	ld a, 6 | BG_BANK1
	ld [bc], a
	pop af
	jr .convert_to_tile
.yellow_char
	push af
	ld a, 4 | BG_BANK1
	ld [bc], a
	pop af
.convert_to_tile
	; to get conversion, we subtract $20 (ASCII space) and add 1
	; (except for the space character)
	sub ' '
	jr z, .space
	add 1
.space
	ld [de], a
	inc de
	inc bc
	pop af
	dec a
	jr nz, .loop_chars

	; copy over character tiles to BGMap1
	ld a, [wTextLine]
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *TILEMAP_WIDTH
	ld de, v0BGMap1
	add hl, de
	ld de, wGfxBuffer
	lb bc, 1, SCREEN_WIDTH
	call CopyBGMapBox
	pop af

	; copy over attribute data to BGMap1
	ld c, a
	ld a, $14
	sub c
	srl a
	ld e, a
	ld d, HIGH(v1BGMap1)
	ld a, BANK("VRAM1")
	vramswitch
	ld a, [wTextLine]
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *TILEMAP_WIDTH
	add hl, de
	ld b, 1 ; row
	ld de, wd7b1
	call CopyBGMapBox
	ld a, BANK("VRAM0")
	vramswitch

	; increment line number
	ld hl, wTextLine
	inc [hl]
	ret

Func_9292:
	push hl
	call Func_98c5
	ld hl, Pals_92ad
	ld de, wTempBGPals palette 6
	ld b, 1 palettes
	call CopyHLtoDE
	pop hl
	xor a
	ld [wMainMenuEntry], a
	ld [wTextLine], a
	ld [wdbfe], a
	ret

Pals_92ad:
	rgb  6,  6,  6
	rgb 31, 31, 31
	rgb 24, 24, 24
	rgb 16, 16, 16
; 0x92b5

SECTION "Func_935e", ROMX[$535e], BANK[$2]

Func_935e:
	push hl
	call ClearVRAMTiles
	pop hl

	; v0Tiles0
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	push hl
	ld b, V0TILES_9000
	call PushTilesToVRAM
	pop hl

	; v0Tiles1
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
	ld b, V0TILES_8800
	call PushTilesToVRAM
	pop hl

.asm_9382
	; tile map
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

	; attribute map
	ld a, BANK("VRAM1")
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
	ld a, BANK("VRAM0")
	vramswitch

	; bg palettes
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wTempBGPals
	ld b, 8 palettes
	jp FarCopy

Func_93b5:
	ld a, 2 ; tiles
	ld b, V1TILES_9000
	call BlackOutVRAMTiles

	ld de, FontCheckboxGfx
	ld c, BANK(FontCheckboxGfx)
	ld b, V1TILES_9000
	ld a, $53 ; tiles
	call PushTilesToVRAM

	ld de, FontBigGfx
	ld c, BANK(FontBigGfx)
	ld b, V1TILES_9000
	ld a, $2b ; tiles
	call PushTilesToVRAM

	ld de, FontBigGfx tile $2b
	ld c, BANK(FontBigGfx)
	ld b, V1TILES_8800
	ld a, $7b ; tiles
	call PushTilesToVRAM
	ret

Func_93e1:
	ld hl, Pals_93ec
	ld de, wTempBGPals palette 2
	ld b, 1 palettes
	jp CopyHLtoDE

Pals_93ec:
	rgb  0,  0,  0
	rgb 31, 24,  0
	rgb 24, 18,  1
	rgb 16, 12,  2

; copies 20x15 box from c:hl to coordinate (0, 0) in BG map
; input:
; - c:hl = BG map data
Func_93f4:
	debgcoord 0, 0
	ld a, e
	ld [wdc7a + 0], a
	ld a, d
	ld [wdc7a + 1], a
	ld a, 15 ; number of rows
.loop_rows
	push af
	ld b, SCREEN_WIDTH
	ld de, wGfxBuffer
	call FarCopy
	push bc
	push hl
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wGfxBuffer
	lb bc, 1, SCREEN_WIDTH
	call CopyBGMapBox
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, TILEMAP_WIDTH ; next row
	add hl, de
	ld a, l
	ld [wdc7a + 0], a
	ld a, h
	ld [wdc7a + 1], a
	pop hl
	pop bc
	pop af
	dec a
	jr nz, .loop_rows
	ret
; 0x9434

SECTION "Func_945c", ROMX[$545c], BANK[$2]

; fills v0BGMap1 with c
; and   v1BGMap1 with b
Func_945c:
	ld a, c
	push bc
	call Func_9473
	pop bc
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	call Func_9473
	ld a, BANK("VRAM0")
	vramswitch
	ret

Func_9473:
	ld hl, wGfxBuffer
	ld b, TILEMAP_WIDTH
.loop_fill
	ld [hli], a
	dec b
	jr nz, .loop_fill

	hlbgcoord 0, 15
	ld b, 17 ; rows
	jp Func_94ac
; 0x9484

SECTION "FillBGMap1", ROMX[$5484], BANK[$2]

; fills v0BGMap1 with c
; and   v1BGMap1 with b
FillBGMap1:
	ld a, c
	push bc
	call .FillBGMap
	pop bc
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	call .FillBGMap
	ld a, BANK("VRAM0")
	vramswitch
	ret

.FillBGMap:
	; fill a single row in wGfxBuffer
	ld hl, wGfxBuffer
	ld b, TILEMAP_WIDTH
.loop_fill
	ld [hli], a
	dec b
	jr nz, .loop_fill

	hlbgcoord 0, 0, v0BGMap1 ; or v1BGMap1
	ld b, TILEMAP_WIDTH
	jp Func_94ac ; useless jump

; fills b rows with row data given in wGfxBuffer
; input:
; - b  = number of rows
; - hl = destination in bg map
; - wGfxBuffer = row data
Func_94ac:
.loop_rows
	push bc
	push hl
	ld de, wGfxBuffer
	lb bc, 1, TILEMAP_WIDTH
	call CopyBGMapBox
	pop hl
	ld de, TILEMAP_WIDTH
	add hl, de
	pop bc
	dec b
	jr nz, .loop_rows
	ret

Func_94c1:
	ld hl, wTempBGPals
	ld bc, 2 palettes
	call ClearMemory
	ld hl, wTempBGPals palette 3
	ld bc, (5 + 8) palettes
	call ClearMemory
	ld a, $03
	jp InitFade
; 0x94d8

SECTION "Func_94d8", ROMX[$54d8], BANK[$2]

Func_94d8:
	xor a
	ld [wc57a], a
	ld [wTitleScreenFinished], a
	ld [wdc29], a

.loop
	call PostVBlank
	ld a, [wdc29]
	and a
	jr z, .asm_94f5
	call Func_9523
	call Func_9bb9
	xor a
	ld [wdc29], a
.asm_94f5
	call Func_1142
	call Random ; advance RNG
	call UpdateEntities
	ld a, [wdc29]
	and a
	jr z, .asm_950a
	call Func_9523
	call Func_9bd1
.asm_950a
	; call update function
	ld hl, wMenuUpdateFunc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call_hl
	call Func_1147

	ld hl, wc57a
	inc [hl]

	; loop while !(wTitleScreenFinished)
	ld a, [wTitleScreenFinished]
	and a
	jr z, .loop
	ret

Func_9523:
	ld a, [wdc29]
	dec a
	call Func_9a15
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wdc29]
	dec a
	ret

InitMainMenu:
	ld hl, .GfxData
	call Func_935e

	ld de, Gfx_cdf50
	ld c, BANK(Gfx_cdf50)
	ld b, V0TILES_8800
	ld a, 20 ; tiles
	call PushTilesToVRAM

	lb bc, BG_BANK1, $80
	call FillBGMap1

	ld hl, wTextLineLengths
	ld a, l
	ld [wdc7a + 0], a
	ld a, h
	ld [wdc7a + 1], a

	ld hl, Data_95cb
	ld b, 7
.loop
	push bc
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld b, [hl]
	inc hl
	push hl
	ld hl, wVRAMNumTiles
	ld a, b
	add_hl
	ld a, [hl]
	push af
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld [hli], a
	ld a, l
	ld [wdc7a + 0], a
	ld a, h
	ld [wdc7a + 1], a
	call PushTilesToVRAM_Compressed
	pop hl
	pop bc
	dec b
	jr nz, .loop

	call Func_93e1

	ld hl, Pals_95b4
	ld de, wTempOBPals
	ld b, 2 palettes
	call CopyHLtoDE

	ld de, Func_9879
	ld hl, wMenuUpdateFunc
	ld [hl], e
	inc hl
	ld [hl], d

	xor a
	ld [wd54d], a

	ld a, $03
	jp InitFade

.GfxData:
	dba Gfx_cd000
	db 128 ; tiles

	dba Gfx_cd800
	db 72 ; tiles

	dba Tilemap_cdc80
	dba Attrmap_cdde8
	dba Pals_cbec0

Pals_95b4:
	rgb  0,  0,  0
	rgb 31, 24,  0
	rgb 24, 18,  1
	rgb 16, 12,  2

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 31, 31, 31

MainMenuEntryTable:
	db MAINMENU_UNDERCOVER    ; $0
	db MAINMENU_LANGUAGE      ; $1
	db MAINMENU_CHEATS        ; $2
	db MAINMENU_DRIVING_GAMES ; $3
	db MAINMENU_TAKE_A_RIDE   ; $4
	db MAINMENU_OPTIONS       ; $5
	db MAINMENU_BEST_TIMES    ; $6

Data_95cb:
	dbw $33, $7e90
	db V0TILES_8000

	dbw $34, $4168
	db V0TILES_8000

	dbw $34, $43c3
	db V0TILES_8000

	dbw $34, $4650
	db V0TILES_8000

	dbw $34, $48a3
	db V0TILES_8000

	dbw $34, $4add
	db V1TILES_8000

	dbw $34, $4d11
	db V1TILES_8000

MACRO? oam_map
	dba \1 ; oam map
	db  \2 ; if non-zero, then tile source is VRAM1
ENDM

MainMenuCursorOAMMaps:
	oam_map MainMenuTakeARideOAMMap,    0 ; MAINMENU_TAKE_A_RIDE
	oam_map MainMenuUndercoverOAMMap,   0 ; MAINMENU_UNDERCOVER
	oam_map MainMenuDrivingGamesOAMMap, 0 ; MAINMENU_DRIVING_GAMES
	oam_map MainMenuOptionsOAMMap,      0 ; MAINMENU_OPTIONS
	oam_map MainMenuBestTimesOAMMap,    0 ; MAINMENU_BEST_TIMES
	oam_map MainMenuLanguageOAMMap,     3 ; MAINMENU_LANGUAGE
	oam_map MainMenuCheatsOAMMap,       3 ; MAINMENU_CHEATS

PtrTable_9603:
	dw TakeARideTexts    ; MAINMENU_TAKE_A_RIDE
	dw UndercoverTexts   ; MAINMENU_UNDERCOVER
	dw DrivingGamesTexts ; MAINMENU_DRIVING_GAMES
	dw OptionsTexts      ; MAINMENU_OPTIONS
	dw BestTimesTexts    ; MAINMENU_BEST_TIMES
	dw LanguageTexts     ; MAINMENU_LANGUAGE
	dw CheatsTexts       ; MAINMENU_CHEATS

MainMenuFunctionTable:
	dw TakeARideMenu ; MAINMENU_TAKE_A_RIDE
	dw UndercoverMenu ; MAINMENU_UNDERCOVER
	dw $5d7a ; MAINMENU_DRIVING_GAMES
	dw $5d58 ; MAINMENU_OPTIONS
	dw $4def ; MAINMENU_BEST_TIMES
	dw $5d69 ; MAINMENU_LANGUAGE
	dw $5dac ; MAINMENU_CHEATS

Func_961f:
	xor a
	ld [wMainMenuCheatInputProgress], a
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wFadeActive]
	and a
	jr nz, .skip_input
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	call nz, .SelectEntry
	call .HandleCheatsInput
	ld a, [wJoypadPressed]
	and PAD_RIGHT | PAD_LEFT
	call nz, .HandleLeftRightInput
.skip_input
	call .UpdateGraphics
	jr .loop

.UpdateGraphics:
	call LoadMainMenuEntryText
	call LoadMainMenuCursorOAM
	jp Func_97f2

.SelectEntry:
	ld a, [wMainMenuEntry]
	ld hl, MainMenuEntryTable
	add_hl
	ld a, [hl]
	ld hl, MainMenuFunctionTable
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z ; invalid entry

	ld a, SFX_06
	call PlaySFX
	push hl
	call Func_94c1
.asm_966a
	call .UpdateGraphics
	ld a, 1
	call YieldEntityUpdate
	ld a, [wFadeActive]
	and a
	jr nz, .asm_966a
	pop hl
	ld a, [wMainMenuEntry]
	ld [wdc2b], a
	jp hl

; keeps track of player input for
; unlocking the cheats option
.HandleCheatsInput:
	ld a, [wdc32]
	and CHEATS_UNLOCKED
	ret nz ; already unlocked
	ld a, [wMainMenuEntry]
	and a
	jr nz, .reset_input_progress ; not in Undercover entry
	ld a, [wJoypadPressed]
	and PAD_UP | PAD_DOWN
	ret z ; not relevant input
	ld c, a
	ld a, [wMainMenuCheatInputProgress]
	ld hl, CheatInputCommands
	add_hl
	ld a, [hl]
	cp c
	jr nz, .reset_input_progress ; incorrect input
	; increment progress in commands
	ld a, [wMainMenuCheatInputProgress]
	inc a
	ld [wMainMenuCheatInputProgress], a
	; are we done?
	ld hl, CheatInputCommands
	add_hl
	ld a, [hl]
	and a
	ret nz ; still awaiting rest of input
	; yes we are done, unlock
	ld hl, wdc32
	set CHEATS_UNLOCKED_F, [hl]
	ld hl, MainMenuEntryTable
	ld c, 0
.loop_find_cheats_item
	ld a, [hli]
	cp MAINMENU_CHEATS
	jr z, .found_cheats
	inc c
	jr .loop_find_cheats_item
.found_cheats
	; set current entry to Cheats
	ld a, c
	ld [wMainMenuEntry], a
	ld a, SFX_06
	jp PlaySFX

.reset_input_progress
	xor a
	ld [wMainMenuCheatInputProgress], a
	ret

.HandleLeftRightInput:
	push af
	ld a, SFX_05
	call PlaySFX
	pop af
	ld hl, wMainMenuEntry
	and PAD_LEFT
	jr nz, .go_left
.go_right
	ld a, [hl]
	cp 6
	jr z, .warp_around_right
	inc a
	ld [hl], a
	jr .got_entry_right
.warp_around_right
	ld [hl], 0
.got_entry_right
	call .CheckIfCheatsUnlocked
	ret nz
	; keep going if in locked Cheats entry
	jr .go_right

.go_left
	ld a, [hl]
	and a
	jr z, .warp_around_left
	dec a
	ld [hl], a
	jr .got_entry_left
.warp_around_left
	ld [hl], 6
.got_entry_left
	call .CheckIfCheatsUnlocked
	ret nz
	; keep going if in locked Cheats entry
	jr .go_left

; checks if cheats were unlocked
; if no, checks if current entry is Cheats
; if yes, then return z
.CheckIfCheatsUnlocked:
	ld a, [wdc32]
	and CHEATS_UNLOCKED
	ret nz ; unlocked Cheats
	push hl
	ld a, [hl]
	ld hl, MainMenuEntryTable
	add_hl
	ld a, [hl]
	pop hl
	cp MAINMENU_CHEATS
	ret

CheatInputCommands:
	db PAD_UP
	db PAD_UP
	db PAD_DOWN
	db PAD_DOWN
	db PAD_UP
	db PAD_DOWN
	db PAD_UP
	db PAD_DOWN
	db PAD_UP
	db PAD_UP
	db PAD_DOWN
	db PAD_DOWN
	db $00 ; end

LoadMainMenuEntryText:
	ld hl, MainMenuEntryTable
	ld a, [wMainMenuEntry]
	add_hl
	ld a, [hl]
	add a ; *2
	ld hl, PtrTable_9603
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp ProcessTitleText

LoadMainMenuCursorOAM:
	ld hl, MainMenuEntryTable
	ld a, [wMainMenuEntry]
	add_hl
	ld c, [hl]
	ld hl, MainMenuCursorOAMMaps
	ld a, c
	add a
	add a ; *4
	add_hl
	ld a, [hli]
	ld [wdc7a], a
	ld a, [hli]
	ld [wdc7c + 0], a
	ld a, [hli]
	ld [wdc7c + 1], a
	ld a, [hl]
	cp 0
	ld a, OAM_BANK0
	jr z, .vram0
	ld a, OAM_BANK1
.vram0
	ld [wdc80], a
	ld a, c
	ld hl, wTextLineLengths
	add_hl
	ld a, [hl]
	ld [wdc7e], a

	; de points to a 20x18 byte structure
	; where each byte is an OAM tile
	; if 0, then that tile is skipped in OAM
	ld a, [wActiveVirtualOAM]
	ld h, a
	ld l, $00
	ld b, OAM_Y_OFS ; y
	ld a, 18
.loop_rows
	ld c, OAM_X_OFS ; x
	push af
	call .GetOAMRowData
	ld a, SCREEN_WIDTH
.loop_cols
	push af
	ld a, [de]
	inc de
	and a
	jr z, .skip ; empty tile
	ld [hl], b ; y
	inc hl
	ld [hl], c ; x
	inc hl
	ld [hli], a ; tile
	ld a, [de]
	ld [hl], a ; attribute
	ld a, [wc57a]
	rrca
	rrca
	and $01
	or [hl]
	ld [hli], a
	ld a, l
	cp OAM_SIZE
	jr nc, .exceeded
.skip
	inc de
	ld a, c
	add 8
	ld c, a
	pop af
	dec a
	jr nz, .loop_cols
	ld a, b
	add 8
	ld b, a
	pop af
	dec a
	jr nz, .loop_rows

	ld a, OAM_SIZE
	sub l
	jr z, .asm_97a7
	jr c, .asm_97a7
	ld b, a
	xor a
.loop_clear_rest
	ld [hli], a
	dec b
	jr nz, .loop_clear_rest
.asm_97a7
	ld l, $00
	ld d, h
	inc d
	ld e, l
	ld b, OAM_SIZE
	jp CopyHLtoDE
.exceeded
	pop af
	pop af
	jr .asm_97a7

.GetOAMRowData:
	push bc
	push hl
	ld a, [wdc7a]
	ld c, a
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wGfxBuffer
	ld b, SCREEN_WIDTH
	call FarCopy
	ld a, l
	ld [wdc7c + 0], a
	ld a, h
	ld [wdc7c + 1], a

	ld b, SCREEN_WIDTH
	ld hl, wGfxBuffer
	ld de, wd7b1
	ld a, [wdc7e]
	ld c, a
.loop_copy_tiles
	ld a, [hli]
	and a
	jr z, .empty_tile
	add c
.empty_tile
	ld [de], a
	inc de
	ld a, [wdc80]
	ld [de], a
	inc de
	dec b
	jr nz, .loop_copy_tiles
	pop hl
	pop bc
	ld de, wd7b1
	ret

Func_97f2:
	ld hl, MainMenuEntryTable
	ld a, [wMainMenuEntry]
	add_hl
	ld a, [hl]
	cp MAINMENU_OPTIONS
	jr z, .options

	ld hl, $5cfb
	ld c, $33
	call .LoadToBuffer
	call .CopyToBGMap

	ld hl, $5e63
	ld c, $33
	call .LoadToBuffer
	ld a, BANK("VRAM1")
	vramswitch
	call .CopyToBGMap
	ld a, BANK("VRAM0")
	vramswitch
	ret

.options
	ld hl, $7f40
	ld c, $32
	call .Func_9865
	ld hl, wGfxBuffer
	ld b, $18
.asm_982e
	ld a, [hl]
	add $c8
	ld [hli], a
	dec b
	jr nz, .asm_982e
	call .CopyToBGMap
	ld hl, $7f58
	ld c, $32
	call .Func_9865
	ld a, BANK("VRAM1")
	vramswitch
	call .CopyToBGMap
	ld a, BANK("VRAM0")
	vramswitch
	ret

.LoadToBuffer:
	ld de, wGfxBuffer
	ld a, $04
.asm_9855
	push af
	push hl
	ld b, $06
	call FarCopy
	pop hl
	ld a, $14
	add_hl
	pop af
	dec a
	jr nz, .asm_9855
	ret

.Func_9865:
	ld de, wGfxBuffer
	ld b, $18
	jp FarCopy

.CopyToBGMap:
	ld de, wGfxBuffer
	lb bc, 4, 6
	lb hl, 6, 3
	jp CopyBGMapBox_ToCoordinate

Func_9879:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	ld [hli], a ; SCX
	ld [hli], a ; SCY
	ld a, LCDC_OBJ_ON
	ld [hli], a ; LCDC
	ld a, $02
	call Func_988e
	ld a, $ff
	ld [hl], a
	ret

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
	ld hl, .GfxData
	call Func_935e

	ld de, Gfx_ce710
	ld c, BANK(Gfx_ce710)
	ld b, V0TILES_8000
	ld a, 16 ; tiles
	call PushTilesToVRAM

	ld de, Gfx_cbfb0
	ld c, BANK(Gfx_cbfb0)
	ld b, V0TILES_8000
	ld a, 1 ; tile
	call PushTilesToVRAM

	ld a, 1 ; tile
	ld b, V0TILES_8000
	call BlackOutVRAMTiles

	ld de, Gfx_cbfc0
	ld c, BANK(Gfx_cbfc0)
	ld b, V0TILES_8000
	ld a, 1 ; tile
	call PushTilesToVRAM

	ld a, 1 ; tile
	ld b, V0TILES_8000
	call BlackOutVRAMTiles

	lb bc, 4 | BG_BANK1, $00
	call FillBGMap1

	call Func_93e1

	ld hl, Pals_994a
	ld de, wTempOBPals
	ld b, 3 palettes
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

	ld de, Func_9a2c
	ld hl, wMenuUpdateFunc
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $01
	ld [wdbfa], a

	ld a, $03
	jp InitFade

.GfxData:
	dba Gfx_ce090
	db 75 ; tiles

	db $00, $00, $00, $00

	dba Tilemap_ce440
	dba Attrmap_ce5a8
	dba Pals_cbf70

Pals_994a:
	rgb  0,  0,  0
	rgb 24, 24, 23
	rgb 14, 14, 14
	rgb  0,  0,  0

	rgb  0,  0,  0
	rgb 30, 30, 30
	rgb 24, 24, 23
	rgb  0,  0,  0

	rgb  0,  0,  0
	rgb 31, 31,  0
	rgb  0,  0,  0
	rgb  0,  0,  0

Func_9962:
	xor a
	ld [wMainMenuEntry], a
	push hl
	ld hl, wTextLineLengths
	ld b, MAX_NUM_LINES
	xor a
.asm_996d
	ld [hli], a
	dec b
	jr nz, .asm_996d
	pop hl

	ld a, [hli]
	ld [wdc2d + 0], a
	ld a, [hli]
	ld [wdc2d + 1], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld h, d
	ld l, e
	call ProcessTitleText
	pop hl
	ld a, l
	ld [wdc27 + 0], a
	ld a, h
	ld [wdc27 + 1], a
	ld c, $00
.asm_998f
	ld a, [hli]
	cp -1
	jr z, .asm_99b2
	call Func_99cb
	jr nc, .asm_999f
	inc hl
	inc hl
	inc hl
	inc hl
	jr .asm_998f
.asm_999f
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push bc
	push hl
	ld h, d
	ld l, e
	ld a, c
	call Func_9bb9
	pop hl
	pop bc
	inc c
	inc hl
	inc hl
	jr .asm_998f
.asm_99b2
	ld a, c
	ld [wTextLine], a
	cp $08
	jr nc, .asm_99c6
	add a
	add a
	cpl
	inc a
	add $20
	cpl
	inc a
	ld [wdbfe], a
	ret
.asm_99c6
	xor a
	ld [wdbfe], a
	ret

Func_99cb:
	push hl
	ld hl, .return
	push hl
	ld hl, .PtrTable
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.return
	pop hl
	ret

.PtrTable:
	dw .Func_99e3
	dw .Func_99e5
	dw .Func_99f5
	dw .Func_9a05

.Func_99e3:
	and a
	ret

.Func_99e5:
	ld a, [wdc32]
	and WDC32_UNK3
	jr nz, .Func_99e3
	ld a, [wdc33]
	and $01
	jr nz, .Func_99e3
	scf
	ret

.Func_99f5:
	ld a, [wdc32]
	and WDC32_UNK3
	jr nz, .Func_99e3
	ld a, [wdc33]
	and $02
	jr nz, .Func_99e3
	scf
	ret

.Func_9a05:
	ld a, [wdc32]
	and WDC32_UNK3
	jr nz, .Func_99e3
	ld a, [wdc33]
	and $04
	jr nz, .Func_99e3
	scf
	ret

Func_9a15:
	ld c, a
	ld hl, wdc27
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop
	ld a, [hli]
	call Func_99cb
	jr c, .next
	ld a, c
	and a
	ret z
	dec c
.next
	inc hl
	inc hl
	inc hl
	inc hl
	jr .loop

Func_9a2c:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	ld [hli], a ; SCX
	ld [hli], a ; SCY
	ldh a, [hff99]
	ld [hli], a ; LCDC
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
	ld [wdc7a + 0], a
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
	ld de, wTextLineLengths
	ld a, [wdc7a + 0]
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
	ld a, [wdc7a + 0]
	inc a
	and $1f
	ld [wdc7a + 0], a
	ret

; title texts are usually 2 bytes high
; if the text is long enough, then it's split
; into 2 lines with regular characters
; input:
; - hl = texts pointer
ProcessTitleText:
	call GetText2

	push hl
	ld hl, wGfxBuffer
	ld b, MAX_LINE_SIZE * 2
	xor a
.loop_clear_buffer
	ld [hli], a
	dec b
	jr nz, .loop_clear_buffer
	pop hl

	call Func_9c1d

	ld a, MAX_LINE_SIZE
	sub c
	jr c, .check_space_for_two_lines
.got_big_text
	; left pad = half of empty characters
	srl a
	ld de, wGfxBuffer
	add_de
.asm_9ac6
	ld a, [hli]
	and a
	jr z, .asm_9adf
	sub ' '
	jr z, .space
	; get tile of this character
	dec a
	add a
	add $55
.space
	push de
	ld [de], a
	ld b, a
	ld a, $14
	add_de
	ld a, b
	inc a
	ld [de], a
	pop de
	inc de
	jr .asm_9ac6

.asm_9adf
	ld a, c
	and $01
	ld c, $00
	jr z, .asm_9ae8
	ld c, $fc
.asm_9ae8
	ld a, [wdc20]
	ld hl, wdc21
	add_hl
	ld [hl], c
	inc hl
	inc hl
	ld [hl], c

.asm_9af3
	hlbgcoord 0, 16
	ld a, [wdc20]
	and a
	jr z, .asm_9aff
	hlbgcoord 0, 20
.asm_9aff
	ld de, wGfxBuffer
	lb bc, 2, $14
	call CopyBGMapBox
	ld a, $01
	ld [wdc1f], a
	ret

.check_space_for_two_lines
	ld a, c
	cp MAX_LINE_SIZE * 2 + 1
	jr c, .two_lines
	; print error text
	ld hl, .TextErrorText
	ld c, 11 ; length
	ld a, $14 - 11
	jp .got_big_text

.TextErrorText:
	db "TEXT ERROR!\0"

.two_lines
	; we will use 2 lines
	ld [wd8e2], a
	ld hl, wd7b1 + $13
	ld b, MAX_LINE_SIZE
.asm_9b31
	ld a, [hld]
	cp ' '
	jr z, .asm_9b39
	dec b
	jr nz, .asm_9b31
.asm_9b39
	ld a, b
	and a
	jr z, .asm_9b55
	dec a
	jr z, .asm_9b55
	ld [wdc7a], a
	inc a
	ld [wdc7c + 0], a
	ld b, a
	ld a, [wd8e2]
	sub b
	cp $15
	jr nc, .asm_9b55
	ld [wdc7e], a
	jr .asm_9b65
.asm_9b55
	ld a, $14
	ld [wdc7a], a
	ld [wdc7c + 0], a
	ld a, [wd8e2]
	sub $14
	ld [wdc7e], a
.asm_9b65
	ld hl, wd7b1
	ld de, wGfxBuffer
	ld a, [wdc7a]
	call .Func_9b96
	ld hl, wd7b1
	ld a, [wdc7c + 0]
	add_hl
	ld de, wGfxBuffer + $14
	ld a, [wdc7e]
	call .Func_9b96
	ld a, [wdc7a]
	ld hl, wdc21
	call .Func_9baa
	ld a, [wdc7e]
	ld hl, wdc23
	call .Func_9baa
	jp .asm_9af3

.Func_9b96:
	ld b, a
	ld a, $14
	sub b
	srl a
	add_de
.asm_9b9d
	ld a, [hli]
	sub ' '
	jr z, .asm_9ba4
	add 1
.asm_9ba4
	ld [de], a
	inc de
	dec b
	jr nz, .asm_9b9d
	ret

.Func_9baa:
	ld c, a
	and $01
	ld c, $00
	jr z, .asm_9bb3
	ld c, $fc
.asm_9bb3
	ld a, [wdc20]
	add_hl
	ld [hl], c
	ret

; input:
; - a  = line number
; - hl = texts pointer
Func_9bb9:
	call Func_9bd1
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *TILEMAP_WIDTH
	ld de, v0BGMap1
	add hl, de
	ld de, wGfxBuffer
	lb bc, 1, MAX_LINE_SIZE
	jp CopyBGMapBox

; input:
; - a  = line number
; - hl = texts pointer
Func_9bd1:
	push af
	call GetText2

	push hl
	ld hl, wGfxBuffer
	ld b, MAX_LINE_SIZE
	xor a
.loop_clear_buffer
	ld [hli], a
	dec b
	jr nz, .loop_clear_buffer
	pop hl

	call Func_9c1d
	; if exceeds MAX_LINE_SIZE, print error text
	ld a, MAX_LINE_SIZE
	sub c
	jr c, .error_text
.got_text
	; centered
	srl a
	ld de, wGfxBuffer
	add_de
.loop_chars
	ld a, [hli]
	and a
	jr z, .null_terminator
	; get character tile
	sub ' '
	jr z, .got_tile
	add 1
.got_tile
	ld [de], a
	inc de
	jr .loop_chars

.null_terminator
	pop af
	push af
	ld de, wTextLineLengths
	add_de
	ld a, c
	ld [de], a
	pop af
	ret

.error_text
	ld hl, .TextErrorText
	ld c, 11 ; text length
	ld a, MAX_LINE_SIZE - 11
	jp .got_text

.TextErrorText:
	db "TEXT ERROR!\0"

; copies text from hl to wd7b1
; input:
; - hl = ?
; output:
; - wd7b1 = text
; - c = length of text (excluding \0)
Func_9c1d:
	ld c, 0
	ld de, wd7b1
.loop
	ld a, [hli]
	cp $80
	jr nc, .control_character
	ld [de], a
	and a
	jr z, .null_terminator
	inc c
	inc de
	jr .loop

.null_terminator
	ld hl, wd7b1
	ret

.control_character
	sub $80
	push hl
	ld hl, .return
	push hl
	add a
	ld hl, .PtrTable
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.return
	pop hl
	jr .loop

.PtrTable:
	dw .Func_9c54 ; $80
	dw .Func_9c59 ; $81
	dw .Func_9c5e ; $82
	dw .Func_9c5f ; $83
	dw .Func_9c66 ; $84
	dw .Func_9c6d ; $85
	dw .Func_9c74 ; $86

.Func_9c54:
	ld a, [wc545]
	jr .insert_arrow

.Func_9c59:
	ld a, [wc544]
	jr .insert_arrow

.Func_9c5e:
	ret

.Func_9c5f:
	ld a, [wdc32]
	and WDC32_UNK1
	jr .insert_arrow

.Func_9c66:
	ld a, [wdc32]
	and WDC32_UNK2
	jr .insert_arrow

.Func_9c6d:
	ld a, [wdc32]
	and WDC32_UNK3
	jr .insert_arrow

.Func_9c74:
	ld a, [wdc32]
	and WDC32_UNK4
	jr .insert_arrow ; useless jump

.insert_arrow
	ld hl, RightArrowTexts ; ">"
	and a
	jr z, .get_text
	ld hl, LeftArrowTexts ; "<"
	jr .get_text ; useless jump
.get_text
	call GetText2
; copies hl to de until \0
.loop_copy
	ld a, [hli]
	and a
	ret z
	ld [de], a
	inc de
	inc c
	jr .loop_copy

Func_9c91:
	ld a, [wdbfa]
	and a
	jp z, Func_9d1a
	ld a, [wc57a]
	and $04
	jr nz, Func_9d1a
	ld a, [wdbfe]
	ld b, a
	ld a, [wMainMenuEntry]
	add a
	add a
	add a
	add $28
	sub b
	ld b, a
	ld hl, wTextLineLengths
	ld a, [wMainMenuEntry]
	add_hl
	ld a, [hl]
	add a
	add a
	cpl
	inc a
	add 72
	ld c, a
	; c = 72 - 4 * (line length)
	lb de, 2 | OAM_BANK0, $12
	push bc
	push hl
	call Func_1393
	pop hl
	pop bc
	ld a, [hl]
	add a
	add a
	add a ; *8
	add c
	add 8
	ld c, a
	; c = 72 + 4 * (line length) + 8
	lb de, 2 | OAM_BANK0 | OAM_XFLIP, $12
	call Func_1393
;	fallthrough

Func_9cd4:
	ld a, [wTextLine]
	cp $08
	jr c, Func_9d1a
	ld a, [wdbfe]
	and a
	jr z, .asm_9cf5
	lb bc, 32, 72 ; y, x
	ld e, $10
	ld d, 2 | OAM_BANK0
	call Func_1393
	lb bc, 32, 80 ; y, x
	ld e, $10
	ld d, 2 | OAM_BANK0 | OAM_XFLIP
	call Func_1393
.asm_9cf5
	ld a, [wTextLine]
	add a
	add a
	add a ; *8
	sub 64
	ld c, a
	; c = 8 * lines - 64
	ld a, [wdbfe]
	cp c
	jr nc, Func_9d1a
	jr z, Func_9d1a
	lb bc, 96, 72 ; y, x
	ld e, $10
	ld d, 2 | OAM_BANK0 | OAM_YFLIP
	call Func_1393
	lb bc, 96, 80 ; y, x
	ld e, $10
	ld d, 2 | OAM_BANK0 | OAM_XFLIP | OAM_YFLIP
	call Func_1393
;	fallthrough

Func_9d1a:
	ld hl, .OAMData1
	call .LoadOAM
	ld hl, .OAMData2
.LoadOAM:
	ld b, 4
.loop
	push bc
	ld c, [hl] ; x
	inc hl
	ld b, [hl] ; y
	inc hl
	ld e, [hl] ; tile id
	inc hl
	ld d, [hl] ; attributes
	inc hl
	push hl
	call Func_1393
	pop hl
	pop bc
	dec b
	jr nz, .loop
	ret

.OAMData1:
	db   0, 40, $00, 1 | OAM_BANK0
	db   0, 56, $02, 1 | OAM_BANK0
	db   0, 72, $04, 1 | OAM_BANK0
	db   0, 88, $06, 1 | OAM_BANK0

.OAMData2:
	db 152, 40, $08, 0 | OAM_BANK0
	db 152, 56, $0a, 0 | OAM_BANK0
	db 152, 72, $0c, 0 | OAM_BANK0
	db 152, 88, $0e, 0 | OAM_BANK0
; 0x9d58

SECTION "TakeARideMenu", ROMX[$5d8b], BANK[$2]

TakeARideMenu:
	ld hl, NULL
	ld a, l
	ld [wdbf7 + 0], a
	ld a, h
	ld [wdbf7 + 1], a
	ld a, MODE_TAKE_A_RIDE
	ld [wGameMode], a
	call Func_98c5
	ld hl, Data_a654
	call Func_9962
	ld de, Func_9dce
	ld a, BANK(Func_9dce)
	jp Func_157f
; 0x9dac

SECTION "UndercoverMenu", ROMX[$5dbd], BANK[$2]

UndercoverMenu:
	call Func_98c5
	ld hl, Data_a622
	call Func_9962
	ld de, Func_9dce
	ld a, $02
	jp Func_157f

Func_9dce:
	call YieldEntityUpdateUntilFadeEnds
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wJoypadPressed]
	and PAD_UP | PAD_DOWN
	jr z, .asm_9de2
	call .HandleUpDownInput
	jr .asm_9dfa
.asm_9de2
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START | PAD_RIGHT | PAD_LEFT
	jr z, .asm_9dee
	call .HandleBtnsAndLeftRightInput
	jr .asm_9dfa
.asm_9dee
	ld a, [wJoypadPressed]
	and PAD_B
	jr z, .asm_9dfa
	call .HandleBInput
	jr .asm_9dfa ; useless jump
.asm_9dfa
	jr .loop

.HandleBInput:
	ld hl, wdc2d
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, SFX_06
	call PlaySFX
	jp hl

.HandleBtnsAndLeftRightInput:
	ld a, [wMainMenuEntry]
	call Func_9a15
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	jp hl

.HandleUpDownInput:
	ld hl, wMainMenuEntry
	and PAD_UP
	jr nz, .move_up
	ld a, [wJoypadPressed]
	and PAD_DOWN
	jr nz, .move_down
	ret
.move_up
	ld a, [hl]
	and a
	ret z ; already at first entry
	ld a, SFX_05
	call PlaySFX
	dec [hl]
	ld a, [wTextLine]
	cp $08
	ret c
	ret z
	ld a, [wdbfe]
	ld b, a
	ld a, [hl]
	add a
	add a
	add a
	cp b
	ret nc
	ld a, b
	sub $08
	ld [wdbfe], a
	ret

.move_down
	ld a, [wTextLine]
	dec a
	cp [hl]
	ret z
	push af
	ld a, SFX_05
	call PlaySFX
	pop af
	inc [hl]
	cp $08
	ret c
	ld a, [wdbfe]
	ld b, a
	ld a, [hl]
	add a
	add a
	add a
	sub b
	cp $40
	ret c
	ld a, b
	add $08
	ld [wdbfe], a
	ret
; 0x9e6c

SECTION "Func_a096", ROMX[$6096], BANK[$2]

Func_a096:
	ld hl, Gfx_da0e0
	ld c, BANK(Gfx_da0e0)
	ld de, v0Tiles1
	ld b, 44 ; tiles
	jp SafeCopyFarTiles
; 0xa0a3

SECTION "LoadMissionCodeOAM", ROMX[$60e2], BANK[$2]

; input:
; - hl = mission code
; - b = screen y
; - c = screen x
LoadMissionCodeOAM:
	ld a, 4 ; num code symbols
.loop
	push af
	ld a, [hli]
	push af
	ld de, .OAMPals
	add_de
	ld a, [de]
	add 3
	ld d, a ; attribute
	pop af
	add a
	add a ; *4
	add $80
	ld e, a ; tile
	push hl
	push bc
	push de
	call Func_1393
	pop de
	pop bc

	; add 8 px to x
	ld a, c
	add 8
	ld c, a
	inc e
	inc e
	push bc
	push de
	call Func_1393
	pop de
	pop bc

	; add 16 px to x
	ld a, c
	add 16
	ld c, a
	pop hl
	pop af
	dec a
	jr nz, .loop
	ret

.OAMPals:
	db 3 ; BADGE
	db 2 ; RED_SIREN
	db 0 ; TIRE_MARK
	db 0 ; WRENCH
	db 0 ; FACE
	db 4 ; BLUE_SIREN
	db 2 ; CONE
	db 1 ; TRAFFIC_LIGHT
; 0xa11c

SECTION "LoadMissionCode", ROMX[$614c], BANK[$2]

LoadMissionCode:
	ld a, [wMission]
	add a
	add a ; *4
	ld hl, MissionCodes
	add_hl
	ld de, wMissionCode
	ld b, 4
.loop_copy
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop_copy
	ret
; 0xa161

SECTION "MissionCodes", ROMX[$6189], BANK[$2]

MissionCodes:
	db FACE,          FACE,       FACE,          FACE          ; MISSION_THE_BANK_JOB
	db TIRE_MARK,     BADGE,      CONE,          RED_SIREN     ; MISSION_HIDE_THE_EVIDENCE
	db TRAFFIC_LIGHT, WRENCH,     WRENCH,        BLUE_SIREN    ; MISSION_BOAT_CHASE
	db CONE,          CONE,       CONE,          BADGE         ; MISSION_RAM_RAID_RACE
	db WRENCH,        RED_SIREN,  RED_SIREN,     TRAFFIC_LIGHT ; MISSION_SUPERFLY_DRIVE
	db WRENCH,        BADGE,      TIRE_MARK,     BLUE_SIREN    ; MISSION_BAIT_FOR_A_TRAP
	db BADGE,         CONE,       BADGE,         RED_SIREN     ; MISSION_TAKE_OUT_DIANGELO
	db RED_SIREN,     BADGE,      WRENCH,        TIRE_MARK     ; MISSION_STEAL_A_COP_CAR
	db CONE,          BLUE_SIREN, RED_SIREN,     RED_SIREN     ; MISSION_GET_LUCKY_TO_THE_DOCS
	db BADGE,         BADGE,      TRAFFIC_LIGHT, CONE          ; MISSION_BEVERLY_HILLS_GET_AWAY
	db BLUE_SIREN,    WRENCH,     WRENCH,        WRENCH        ; MISSION_GRAND_CENTRAL_STATION
	db TRAFFIC_LIGHT, TIRE_MARK,  RED_SIREN,     BADGE         ; MISSION_TRASH_GRANGERS_WHEELS
	db WRENCH,        BADGE,      BADGE,         CONE          ; MISSION_STOP_GRANGERS_GANG
	db RED_SIREN,     BLUE_SIREN, RED_SIREN,     BLUE_SIREN    ; MISSION_CHASE_ONE_OF_GRANGERS_BOYS
	db TIRE_MARK,     WRENCH,     CONE,          TRAFFIC_LIGHT ; MISSION_CROSS_TOWN_RECORD
; 0xa1c5

SECTION "Func_a3cc", ROMX[$63cc], BANK[$2]

Func_a3cc:
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr z, .a_btn_or_start_btn
	ld a, SFX_06
	jp PlaySFX
.a_btn_or_start_btn
	; skip rest of execution of callee
	pop hl
	ret

Func_a3da:
	call Func_a3cc
	; being here means A or Start was pressed
	jp Func_a47a

Func_a3e0:
	call Func_a3cc
	; being here means A or Start was pressed
Func_a3e3:
	ld hl, wdbf7
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .null
	ld hl, wdbf7
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $0000
	ld a, [wdbf9]
	jp Func_a58b
.null
	ld hl, EmptyTexts
	call ProcessTitleText
	jp Func_a47a
; 0xa404

SECTION "Func_a429", ROMX[$6429], BANK[$2]

Func_a429:
	call Func_a3cc
	; being here means A or Start was pressed
	ld a, MIAMI
	jp Func_a467
; 0xa431

SECTION "Func_a444", ROMX[$6444], BANK[$2]

Func_a444:
	call Func_a3cc
	; being here means A or Start was pressed
	ld a, LOS_ANGELES
	jp Func_a467
; 0xa44c

SECTION "Func_a45f", ROMX[$645f], BANK[$2]

Func_a45f:
	call Func_a3cc
	; being here means A or Start was pressed
	ld a, NEW_YORK
	jp Func_a467

Func_a467:
	ld [wCity], a
	ld a, [wGameMode]
	cp MODE_TAKE_A_RIDE
	jp nz, ExitTitlescreenOrMainScreen
	ld de, $61c5
	ld a, $02
	jp Func_157f

Func_a47a:
	call Func_94c1
	call YieldEntityUpdateUntilFadeEnds
	call InitMainMenu
	ld a, [wdc2b]
	ld [wMainMenuEntry], a
	ld de, Func_961f
	ld a, BANK(Func_961f)
	jp Func_157f

ExitTitlescreenOrMainScreen:
	ld a, $17
	call FindEntity
	jr nc, .asm_a4a0
	ld de, YieldEntityUpdateIndefinitely
	ld a, BANK(YieldEntityUpdateIndefinitely)
	call Func_1569
.asm_a4a0
	call FadeToWhite
	call YieldEntityUpdateUntilFadeEnds
	ld a, TRUE
	ld [wTitleScreenFinished], a
	jp YieldEntityUpdateIndefinitely
; 0xa4ae

SECTION "Func_a56c", ROMX[$656c], BANK[$2]

Func_a56c:
	call Func_a3cc
	; being here means A or Start was pressed
	ld de, $5eb2
	ld a, $02
	jp Func_157f

Func_a577:
	call Func_a3cc
	; being here means A or Start was pressed
	ld a, MODE_UNDERCOVER
	ld [wGameMode], a
	xor a ; MISSION_THE_BANK_JOB
	ld [wMission], a
	ld de, ExitTitlescreenOrMainScreen
	ld a, BANK(ExitTitlescreenOrMainScreen)
	jp Func_157f

Func_a58b:
	push af
	ld a, e
	ld [wdbf7 + 0], a
	ld a, d
	ld [wdbf7 + 1], a
	ld a, [wMainMenuEntry]
	ld [wdbf9], a
	push hl
	xor a
	ld [wdbfa], a
	ld hl, EmptyTexts
	call ProcessTitleText
	ld a, 4
	call YieldEntityUpdate
	lb bc, $c, $00
	call FillBGMap1
	pop hl
	call Func_9962
	ld a, $01
	ld [wdbfa], a
	pop af
	ld [wMainMenuEntry], a
	ld de, Func_9dce
	ld a, BANK(Func_9dce)
	jp Func_157f
; 0xa5c5

SECTION "Data_a622", ROMX[$6622], BANK[$2]

Data_a622:
	dw Func_a47a
	dw UndercoverTexts
	db $00
	dw NewGameTexts, Func_a577
	db $00
	dw ContinueGameTexts, Func_a56c
	db $00
	dw BackTexts, Func_a3da
	db -1 ; end

SECTION "Data_a654", ROMX[$6654], BANK[$2]

Data_a654:
	dw Func_a3e3
	dw ChooseACityTexts
	db $01
	dw MiamiTexts, Func_a429
	db $02
	dw LosAngelesTexts, Func_a444
	db $03
	dw NewYorkTexts, Func_a45f
	db $00
	dw BackTexts, Func_a3e0
	db -1 ; end
; 0xa66d

SECTION "MissionTextTable", ROMX[$66cc], BANK[$2]

MissionTextTable:
	dw TheBankJobTexts             ; MISSION_THE_BANK_JOB
	dw HideTheEvidenceTexts        ; MISSION_HIDE_THE_EVIDENCE
	dw BoatChaseTexts              ; MISSION_BOAT_CHASE
	dw RamRaidRaceTexts            ; MISSION_RAM_RAID_RACE
	dw SuperflyDriveTexts          ; MISSION_SUPERFLY_DRIVE
	dw BaitForATrapTexts           ; MISSION_BAIT_FOR_A_TRAP
	dw TakeOutDiAngeloTexts        ; MISSION_TAKE_OUT_DIANGELO
	dw StealACopCarTexts           ; MISSION_STEAL_A_COP_CAR
	dw GetLuckyToTheDocsTexts      ; MISSION_GET_LUCKY_TO_THE_DOCS
	dw BeverlyHillsGetAwayTexts    ; MISSION_BEVERLY_HILLS_GET_AWAY
	dw GrandCentralStationTexts    ; MISSION_GRAND_CENTRAL_STATION
	dw TrashGrangersWheelsTexts    ; MISSION_TRASH_GRANGERS_WHEELS
	dw StopGrangersGangTexts       ; MISSION_STOP_GRANGERS_GANG
	dw ChaseOneOfGrangersBoysTexts ; MISSION_CHASE_ONE_OF_GRANGERS_BOYS
	dw CrossTownRecordTexts        ; MISSION_CROSS_TOWN_RECORD

