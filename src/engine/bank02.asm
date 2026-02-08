SECTION "Titlescreen", ROMX[$4ce1], BANK[$2]

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
	ld a, $06
	ld [wd81f], a
	xor a
	ld [wResetDisabled], a
	ret

MainMenu::
	ld a, TRUE
	ld [wResetDisabled], a

	ld a, MUSIC_MAIN_MENU
	call PlayMusic

	call Func_8ddb
	call LoadMainMenu

	lb bc, 2 | BG_BANK1, $00
	call Func_945c

	xor a
	ld [wdc26], a
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
	ld a, [wd81f]
	cp $06
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
	ld de, EndTitlescreenOrMainScreen
	ld a, BANK(EndTitlescreenOrMainScreen)
	call Func_1569

	ld a, $06
	ld [wd81f], a
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
	jp EndTitlescreenOrMainScreen
.a_or_start_btn
	ld a, GOTO_MAIN_MENU
	ld [wTitlescreenTransition], a
	jp EndTitlescreenOrMainScreen

Func_8dcb:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	ld [hli], a
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
	ld a, $ff
	ld [hl], a
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
	ld b, 5 palettes
	ld de, wTempOBPals palette 3
	call FarCopy
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
	call SpawnEntity
	ld a, $03
	call InitFade
	ld a, MUSIC_BRIEFING
	call PlayMusicIfNotPlaying
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
	ld hl, wGfxBuffer
	ld bc, $20
	call ClearMemory
	pop hl
	ld de, wdbff
	ld a, [wdc25]
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
	ld de, wGfxBuffer
	lb bc, 1, SCREEN_WIDTH
	call CopyBGMapBox
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
	call CopyBGMapBox
	ld a, $00
	vramswitch
	ld hl, wdc25
	inc [hl]
	ret

Func_9292:
	push hl
	call Func_98c5
	ld hl, $52ad
	ld de, wTempBGPals palette 6
	ld b, 1 palettes
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
	ld a, $02
	ld b, V1TILES_9000
	call Func_af6
	ld de, $7960
	ld c, $33
	ld b, V1TILES_9000
	ld a, $53
	call PushTilesToVRAM
	ld de, $6830
	ld c, $33
	ld b, V1TILES_9000
	ld a, $2b
	call PushTilesToVRAM
	ld de, $6ae0
	ld c, $33
	ld b, V1TILES_8800
	ld a, $7b
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

LoadMainMenu:
	ld hl, $55a3
	call Func_935e

	ld de, Gfx_cdf50
	ld c, BANK(Gfx_cdf50)
	ld b, V0TILES_8800
	ld a, 20 ; tiles
	call PushTilesToVRAM

	lb bc, BG_BANK1, $80
	call FillBGMap1

	ld hl, wdbff
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
; 0x95a3

SECTION "Data_95b4", ROMX[$55b4], BANK[$2]

Pals_95b4:
	rgb  0,  0,  0
	rgb 31, 24,  0
	rgb 24, 18,  1
	rgb 16, 12,  2

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 31, 31, 31
; 0x95c4

SECTION "Data_95cb", ROMX[$55cb], BANK[$2]

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
; 0x95e7

SECTION "Func_961f", ROMX[$561f], BANK[$2]

Func_961f:
	xor a
	ld [wdc2a], a
.loop
	ld a, 1
	call YieldEntityUpdate
	ld a, [wFadeActive]
	and a
	jr nz, .asm_9641
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	call nz, .Func_964f
	call .Func_9680
	ld a, [wJoypadPressed]
	and PAD_RIGHT | PAD_LEFT
	call nz, .Func_96cc
.asm_9641
	call .Func_9646
	jr .loop

.Func_9646:
	call Func_9719
	call Func_972c
	jp Func_97f2

.Func_964f:
	ld a, [wdc26]
	ld hl, $55c4
	add_hl
	ld a, [hl]
	ld hl, $5611
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	ret z
	ld a, SFX_06
	call Func_ef7
	push hl
	call Func_94c1
.asm_966a
	call .Func_9646
	ld a, 1
	call YieldEntityUpdate
	ld a, [wFadeActive]
	and a
	jr nz, .asm_966a
	pop hl
	ld a, [wdc26]
	ld [wdc2b], a
	jp hl

.Func_9680:
	ld a, [wdc32]
	and $01
	ret nz
	ld a, [wdc26]
	and a
	jr nz, .asm_96c7
	ld a, [wJoypadPressed]
	and PAD_UP | PAD_DOWN
	ret z
	ld c, a
	ld a, [wdc2a]
	ld hl, $570c
	add_hl
	ld a, [hl]
	cp c
	jr nz, .asm_96c7
	ld a, [wdc2a]
	inc a
	ld [wdc2a], a
	ld hl, $570c
	add_hl
	ld a, [hl]
	and a
	ret nz
	ld hl, wdc32
	set 0, [hl]
	ld hl, $55c4
	ld c, $00
.asm_96b6
	ld a, [hli]
	cp $06
	jr z, .asm_96be
	inc c
	jr .asm_96b6
.asm_96be
	ld a, c
	ld [wdc26], a
	ld a, SFX_06
	jp Func_ef7
.asm_96c7
	xor a
	ld [wdc2a], a
	ret

.Func_96cc:
	push af
	ld a, SFX_05
	call Func_ef7
	pop af
	ld hl, wdc26
	and $20
	jr nz, .asm_96eb
.asm_96da
	ld a, [hl]
	cp $06
	jr z, .asm_96e3
	inc a
	ld [hl], a
	jr .asm_96e5
.asm_96e3
	ld [hl], $00
.asm_96e5
	call .Func_96fb
	ret nz
	jr .asm_96da
.asm_96eb
	ld a, [hl]
	and a
	jr z, .asm_96f3
	dec a
	ld [hl], a
	jr .asm_96f5
.asm_96f3
	ld [hl], $06
.asm_96f5
	call .Func_96fb
	ret nz
	jr .asm_96eb

.Func_96fb:
	ld a, [wdc32]
	and $01
	ret nz
	push hl
	ld a, [hl]
	ld hl, $55c4
	add_hl
	ld a, [hl]
	pop hl
	cp $06
	ret
; 0x970c

SECTION "Func_9719", ROMX[$5719], BANK[$2]

Func_9719:
	ld hl, $55c4
	ld a, [wdc26]
	add_hl
	ld a, [hl]
	add a
	ld hl, $5603
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Func_9aa9

Func_972c:
	ld hl, $55c4
	ld a, [wdc26]
	add_hl
	ld c, [hl]
	ld hl, $55e7
	ld a, c
	add a
	add a
	add_hl
	ld a, [hli]
	ld [wdc7a], a
	ld a, [hli]
	ld [wdc7c], a
	ld a, [hli]
	ld [wdc7d], a
	ld a, [hl]
	cp $00
	ld a, $00
	jr z, .asm_9750
	ld a, $08
.asm_9750
	ld [wdc80], a
	ld a, c
	ld hl, wdbff
	add_hl
	ld a, [hl]
	ld [wdc7e], a
	ld a, [wActiveVirtualOAM]
	ld h, a
	ld l, $00
	ld b, $10
	ld a, $12
.asm_9766
	ld c, $08
	push af
	call .Func_97b5
	ld a, $14
.asm_976e
	push af
	ld a, [de]
	inc de
	and a
	jr z, .asm_9789
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ld a, [wc57a]
	rrca
	rrca
	and $01
	or [hl]
	ld [hli], a
	ld a, l
	cp $a0
	jr nc, .asm_97b1
.asm_9789
	inc de
	ld a, c
	add $08
	ld c, a
	pop af
	dec a
	jr nz, .asm_976e
	ld a, b
	add $08
	ld b, a
	pop af
	dec a
	jr nz, .asm_9766
	ld a, $a0
	sub l
	jr z, .asm_97a7
	jr c, .asm_97a7
	ld b, a
	xor a
.asm_97a3
	ld [hli], a
	dec b
	jr nz, .asm_97a3
.asm_97a7
	ld l, $00
	ld d, h
	inc d
	ld e, l
	ld b, $a0
	jp CopyHLtoDE
.asm_97b1
	pop af
	pop af
	jr .asm_97a7

.Func_97b5:
	push bc
	push hl
	ld a, [wdc7a]
	ld c, a
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wGfxBuffer
	ld b, $14
	call FarCopy
	ld a, l
	ld [wdc7c], a
	ld a, h
	ld [wdc7d], a
	ld b, $14
	ld hl, wGfxBuffer
	ld de, wd7b1
	ld a, [wdc7e]
	ld c, a
.asm_97dd
	ld a, [hli]
	and a
	jr z, .asm_97e2
	add c
.asm_97e2
	ld [de], a
	inc de
	ld a, [wdc80]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_97dd
	pop hl
	pop bc
	ld de, wd7b1
	ret

Func_97f2:
	ld hl, $55c4
	ld a, [wdc26]
	add_hl
	ld a, [hl]
	cp $03
	jr z, .asm_9821
	ld hl, $5cfb
	ld c, $33
	call .Func_9850
	call .Func_986d
	ld hl, $5e63
	ld c, $33
	call .Func_9850
	ld a, $01
	vramswitch
	call .Func_986d
	ld a, $00
	vramswitch
	ret
.asm_9821
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
	call .Func_986d
	ld hl, $7f58
	ld c, $32
	call .Func_9865
	ld a, $01
	vramswitch
	call .Func_986d
	ld a, $00
	vramswitch
	ret

.Func_9850:
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

.Func_986d:
	ld de, wGfxBuffer
	lb bc, 4, 6
	lb hl, 6, 3
	jp Func_839
; 0x9879

SECTION "Func_9879", ROMX[$5879], BANK[$2]

Func_9879:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $02
	ld [hli], a
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
	call Func_af6

	ld de, Gfx_cbfc0
	ld c, BANK(Gfx_cbfc0)
	ld b, V0TILES_8000
	ld a, 1 ; tile
	call PushTilesToVRAM

	ld a, 1 ; tile
	ld b, V0TILES_8000
	call Func_af6

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
; 0x9962

SECTION "Func_99cb", ROMX[$59cb], BANK[$2]

Func_99cb:
	push hl
	ld hl, .return
	push hl
	ld hl, $59db
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.return
	pop hl
	ret
; 0x99db

SECTION "Func_9a15", ROMX[$5a15], BANK[$2]

Func_9a15:
	ld c, a
	ld hl, wdc27
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_9a1c
	ld a, [hli]
	call Func_99cb
	jr c, .asm_9a26
	ld a, c
	and a
	ret z
	dec c
.asm_9a26
	inc hl
	inc hl
	inc hl
	inc hl
	jr .asm_9a1c

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
	ld de, wdbff
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

Func_9aa9:
	call Func_1e57
	push hl
	ld hl, wGfxBuffer
	ld b, $28
	xor a
.asm_9ab3
	ld [hli], a
	dec b
	jr nz, .asm_9ab3
	pop hl
	call Func_9c1d
	ld a, $14
	sub c
	jr c, .asm_9b0e
.asm_9ac0
	srl a
	ld de, wGfxBuffer
	add_de
.asm_9ac6
	ld a, [hli]
	and a
	jr z, .asm_9adf
	sub $20
	jr z, .asm_9ad2
	dec a
	add a
	add $55
.asm_9ad2
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
	ld bc, $214
	call CopyBGMapBox
	ld a, $01
	ld [wdc1f], a
	ret
.asm_9b0e
	ld a, c
	cp $29
	jr c, .asm_9b29
	ld hl, $5b1d
	ld c, $0b
	ld a, $09
	jp .asm_9ac0

	db $54, $45, $58, $54, $20, $45, $52, $52, $4f, $52, $21, $00

.asm_9b29
	ld [wd8e2], a
	ld hl, wd7c4
	ld b, $14
.asm_9b31
	ld a, [hld]
	cp $20
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
	ld [wdc7c], a
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
	ld [wdc7c], a
	ld a, [wd8e2]
	sub $14
	ld [wdc7e], a
.asm_9b65
	ld hl, wd7b1
	ld de, wGfxBuffer
	ld a, [wdc7a]
	call .Func_9b96
	ld hl, wd7b1
	ld a, [wdc7c]
	add_hl
	ld de, wd785
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
	sub $20
	jr z, .asm_9ba4
	add $01
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

Func_9bb9:
	call Func_9bd1
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, v0BGMap1
	add hl, de
	ld de, wGfxBuffer
	lb bc, 1, 20
	jp CopyBGMapBox

Func_9bd1:
	push af
	call Func_1e57
	push hl
	ld hl, wGfxBuffer
	ld b, $14
	xor a
.asm_9bdc
	ld [hli], a
	dec b
	jr nz, .asm_9bdc
	pop hl
	call Func_9c1d
	ld a, $14
	sub c
	jr c, .asm_9c07
.asm_9be9
	srl a
	ld de, wGfxBuffer
	add_de
.asm_9bef
	ld a, [hli]
	and a
	jr z, .asm_9bfd
	sub $20
	jr z, .asm_9bf9
	add $01
.asm_9bf9
	ld [de], a
	inc de
	jr .asm_9bef
.asm_9bfd
	pop af
	push af
	ld de, wdbff
	add_de
	ld a, c
	ld [de], a
	pop af
	ret
.asm_9c07
	ld hl, $5c11
	ld c, $0b
	ld a, $09
	jp .asm_9be9
; 0x9c11

SECTION "Func_9c1d", ROMX[$5c1d], BANK[$2]

; input:
; - hl = ?
Func_9c1d:
	ld c, $00
	ld de, wd7b1
.loop
	ld a, [hli]
	cp $80
	jr nc, .asm_9c33
	ld [de], a
	and a
	jr z, .asm_9c2f
	inc c
	inc de
	jr .loop
.asm_9c2f
	ld hl, wd7b1
	ret
.asm_9c33
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
	dw .Func_9c54
	dw .Func_9c59
	dw .Func_9c5e
	dw .Func_9c5f
	dw .Func_9c66
	dw .Func_9c6d
	dw .Func_9c74

.Func_9c54:
	ld a, [wc545]
	jr .asm_9c7b

.Func_9c59:
	ld a, [wc544]
	jr .asm_9c7b

.Func_9c5e:
	ret

.Func_9c5f:
	ld a, [wdc32]
	and $02
	jr .asm_9c7b

.Func_9c66:
	ld a, [wdc32]
	and $04
	jr .asm_9c7b

.Func_9c6d:
	ld a, [wdc32]
	and $08
	jr .asm_9c7b

.Func_9c74:
	ld a, [wdc32]
	and $10
	jr .asm_9c7b ; useless jump

.asm_9c7b
	ld hl, $4b57
	and a
	jr z, .get_data
	ld hl, $4b4b
	jr .get_data ; useless jump
.get_data
	call Func_1e57
; copies hl to de until $00 byte
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

SECTION "EndTitlescreenOrMainScreen", ROMX[$6491], BANK[$2]

EndTitlescreenOrMainScreen:
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
