Func_110b::
	ld hl, wSprites
	ld bc, NUM_SPRITE_STRUCTS * SPRITE_STRUCT_SIZE
	call ClearMemory

	ld a, TRUE
	ld [wd54c], a
	ld [wd54d], a

	xor a
	ld hl, wd54e
	ld [hli], a
	ld [hli], a ; wd54f
	ld [hl], a
	ret

Func_1124::
	push hl
	push bc
	ld hl, wSprites
	ld de, SPRITE_STRUCT_SIZE
	ld b, NUM_SPRITE_STRUCTS
.loop
	bit SPRITEFLAG_ACTIVE_F, [hl]
	jr z, .found
	add hl, de
	dec b
	jr nz, .loop
	pop bc
	pop hl
	scf
	ret
.found
	ld [hl], SPRITEFLAG_ACTIVE
	ld d, h
	ld e, l
	pop bc
	pop hl
	and a
	ret

ResetNumberOfCopiedTiles::
	xor a
	ld [wNumCopiedTiles], a
	ret

Func_1147::
	ld a, [wd54d]
	and a
	ret z

	call ClearSprites

	ld a, [wd54c]
	and a
	jr z, .asm_116d

	ld hl, wSprites
	ld b, NUM_SPRITE_STRUCTS
.loop
	ld a, [hl]
	and SPRITEFLAG_ACTIVE | SPRITEFLAG_UNK1
	cp SPRITEFLAG_ACTIVE | SPRITEFLAG_UNK1
	jr nz, .next
	push bc
	call Func_1186
	pop bc
.next
	ld de, SPRITE_STRUCT_SIZE
	add hl, de
	dec b
	jr nz, .loop

.asm_116d
	ld a, [wd54e]
	and a
	jr z, .load_sprites
	bankswitch
	ld hl, wd54f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call_hl
.load_sprites
	jp LoadSprites

Func_1186:
	push hl
	ld a, [hli]
	ld [wSpriteFlags], a
	inc hl
	and SPRITEFLAG_UNK2
	jr z, .asm_11e6
	ld d, h
	ld e, l

	ld hl, wCameraY
	ld a, [de] ; SPRITESTRUCT_Y
	sub [hl] ; wCameraY
	ld b, a
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jr z, .asm_11b3
	cp -1
	jp nz, .asm_1242
	push de
	ld a, SPRITESTRUCT_UNK07 - (SPRITESTRUCT_Y + 1)
	add_de
	ld a, [de] ; SPRITESTRUCT_UNK07
	add b
	pop de
	jp nc, .asm_1242
	jp z, .asm_1242
	ld a, b
	jr .asm_11b9
.asm_11b3
	ld a, b
	cp $80
	jp nc, .asm_1242
.asm_11b9
	add OAM_Y_OFS
	ld b, a
	inc de
	inc de
	inc hl

	ld a, [de] ; SPRITESTRUCT_X
	sub [hl] ; wCameraX
	ld c, a
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jr z, .asm_11da
	cp -1
	jr nz, .asm_1242
	push de
	ld a, SPRITESTRUCT_UNK08 - (SPRITESTRUCT_X + 1)
	add_de
	ld a, [de]
	add c
	pop de
	jr nc, .asm_1242
	jr z, .asm_1242
	ld a, c
	jr .asm_11df
.asm_11da
	ld a, c
	cp SCREEN_WIDTH_PX
	jr nc, .asm_1242
.asm_11df
	add OAM_X_OFS
	ld c, a
	ld h, d
	ld l, e
	jr .asm_11f0
.asm_11e6
	ld a, [hli]
	add OAM_Y_OFS
	ld b, a
	inc hl
	inc hl
	ld a, [hli]
	add OAM_X_OFS
	ld c, a
.asm_11f0
	inc hl
	ld a, [hli] ; SPRITESTRUCT_UNK07
	swap a
	ld d, a
	ld a, [hli] ; SPRITESTRUCT_UNK08
	rrca
	rrca
	ld e, a ; /4
	rrca
	ld [wd54b], a ; /8
	ld a, [wSpriteFlags]
	and SPRITEFLAG_UNK7
	call nz, Func_1315
	ld a, [wSpriteFlags]
	and SPRITEFLAG_UNK4
	jr z, .asm_120f
	ld a, [hli] ; SPRITESTRUCT_UNK09
	ld h, [hl]
	ld l, a
.asm_120f
	ld a, d
	cp $01
	jr nz, .asm_1219
	ld a, e
	cp $02
	jr z, .screen_check
.asm_1219
	ld a, [wSpriteFlags]
	and SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	call nz, Func_1338
	xor a
	ld [wd548], a
.asm_1225
	ld a, b
	cp SCREEN_HEIGHT_PX
	call c, Func_1293
	add $10
	ld b, a
	ld a, e
	add l
	ld l, a
	ld a, $00
	adc h
	ld h, a
	dec d
	jr nz, .asm_1225
	ld a, [wd548]
	and a
	jr z, .asm_1242

.asm_123e
	pop hl
	res SPRITEFLAG_UNK3_F, [hl]
	ret

.asm_1242
	pop hl
	set SPRITEFLAG_UNK3_F, [hl]
	ret

.screen_check
	ld a, [wSpriteFlags]
	and SPRITEFLAG_UNK2
	jr nz, .skip_screen_check

	; are we inside screen coordinates?
	ld a, b
	and a
	jr z, .asm_1242
	cp SCREEN_HEIGHT_PX + OAM_Y_OFS
	jr nc, .asm_1242
	ld a, c
	and a
	jr z, .asm_1242
	cp SCREEN_WIDTH_PX + OAM_X_OFS
	jr nc, .asm_1242

.skip_screen_check
	ld a, [hli]
	bit 0, a
	jr nz, .asm_123e
	ld e, a ; tile ID

	ld a, [wSpriteFlags]
	and SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	xor [hl]
	ld d, a ; attributes

	ld a, b
	swap a
	and $0f
	add a ; /8
	add LOW(OAMGroupTable)
	ld l, a
	ld a, HIGH(OAMGroupTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl] ; OAM count
	cp OAM_GROUP_SIZE
	jr nc, .asm_123e ; already full

	; add to OAM array
	inc [hl]
	inc hl
	add a
	add a ; *OBJ_SIZE
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld [hl], b ; y
	inc hl
	ld [hl], c ; x
	inc hl
	ld [hl], e ; tile ID
	inc hl
	ld [hl], d ; attributes
	jr .asm_123e

; a = screen y
Func_1293:
	and a
	ret z
	push bc
	push de
	push hl
	ld d, h
	ld e, l
	swap a
	and $0f
	add a ; /8
	add LOW(OAMGroupTable)
	ld l, a
	ld a, HIGH(OAMGroupTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	ld [wTempOAMY], a
	ld a, c
	ld [wTempOAMX], a
	ld b, h
	ld c, l
	ld a, [hli]
	add a
	add a
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a

	ld a, [wd54b]
.loop
	push af
	ld a, [bc]
	cp OAM_GROUP_SIZE
	jr z, .done_pop_af
	; group not full
	ld a, [wTempOAMX]
	and a
	jr z, .next
	cp SCREEN_WIDTH_PX + OAM_X_OFS
	jr nc, .next
	ld a, $01
	ld [wd548], a
	ld a, [de]
	bit 0, a
	jr nz, .next
	ld a, [wTempOAMY]
	ld [hli], a ; y
	ld a, [wTempOAMX]
	ld [hli], a ; x
	ld a, [de]
	ld [hli], a ; tile ID
	inc de
	ld a, [de]
	ld [hli], a ; attributes
	dec de
	ld a, [bc]
	inc a
	ld [bc], a
.next
	inc de
	inc de
	ld a, [wTempOAMX]
	add 8
	ld [wTempOAMX], a
	pop af
	dec a
	jr nz, .loop
.done
	pop hl
	pop de
	pop bc
	ld a, b
	ret
.done_pop_af
	pop af
	jr .done

OAMGroupTable:
	FOR n, 1, NUM_OAM_GROUPS + 1
		dw wOAMGroup{u:n}
	ENDR

; input:
; - e = ?
; - b = OAM y
; - c = OAM x
Func_1315:
	push bc
	push de
	push hl
	ld a, e
	cp $02
	jr z, .subtract_y
	; add 4 px to x
	ld a, c
	add 4
	ld c, a
.subtract_y
	; subtract 4 px from y
	ld a, b
	sub 4
	ld b, a
	lb de, 2 | OAM_BANK1, $70
	ld a, [wc57a]
	and $04
	jr z, .asm_1331
	ld d, 3 | OAM_BANK1 | OAM_XFLIP
.asm_1331
	call Func_139b
	pop hl
	pop de
	pop bc
	ret

Func_1338:
	push bc
	push de
	ld c, a
	and $20
	jr z, .asm_1364
	ld b, d
	push bc
	ld bc, wGfxBuffer
	ld a, d
	ld d, $00
.asm_1347
	push af
	add hl, de
	ld d, e
	srl d
.asm_134c
	dec hl
	inc bc
	ld a, [hld]
	xor $20
	ld [bc], a
	dec bc
	ld a, [hl]
	ld [bc], a
	inc bc
	inc bc
	dec d
	jr nz, .asm_134c
	add hl, de
	pop af
	dec a
	jr nz, .asm_1347
	pop bc
	ld d, b
	ld hl, wGfxBuffer
.asm_1364
	ld a, c
	and $40
	jr z, .asm_1390
	ld b, d
	dec b
	jr z, .asm_1375
	ld c, d
	ld d, $00
.asm_1370
	add hl, de
	dec b
	jr nz, .asm_1370
	ld d, c
.asm_1375
	ld bc, wd7b1
.asm_1378
	push de
	srl e
.asm_137b
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	xor $40
	ld [bc], a
	inc bc
	dec e
	jr nz, .asm_137b
	pop de
	ld a, e
	add a
	sub_hl
	dec d
	jr nz, .asm_1378
	ld hl, wd7b1
.asm_1390
	pop de
	pop bc
	ret

; input:
; - b = screen y
; - c = screen x
; - e = tile id
; - d = attributes
Func_1393::
	ld a, c
	add OAM_X_OFS
	ld c, a
	ld a, b
	add OAM_Y_OFS
	ld b, a
;	fallthrough

; input:
; - b = OAM y
; - c = OAM x
; - e = tile id
; - d = attributes
Func_139b:
	; first test if it's inside screen
	ld a, b
	and a
	ret z
	cp SCREEN_HEIGHT_PX + OAM_Y_OFS
	ret nc
	ld a, c
	and a
	ret z
	cp SCREEN_WIDTH_PX + OAM_X_OFS
	ret nc
;	fallthrough

Func_13a7::
	; is inside, continue
	ld a, b
	swap a
	and $0f
	add a ; /8
	add LOW(OAMGroupTable)
	ld l, a
	ld a, HIGH(OAMGroupTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl] ; OAM count
	cp OAM_GROUP_SIZE
	ret nc ; already full
	inc [hl]
	inc hl
	add a
	add a ; *OBJ_SIZE
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld [hl], b ; y
	inc hl
	ld [hl], c ; x
	inc hl
	ld [hl], e ; tile ID
	inc hl
	ld [hl], d ; attributes
	ret

; zeroes out wOAMGroups
ClearSprites:
	ld hl, wOAMGroups
	ld de, OAM_GROUP_STRUCT_SIZE
	ld b, NUM_OAM_GROUPS
	xor a
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

; goes through wOAMGroups and loads them into Virtual OAM
LoadSprites:
	ld a, [wActiveVirtualOAM]
	ld d, a
	ld e, 0
	ld hl, wOAMGroups
	ld b, NUM_OAM_GROUPS
.loop_sprites
	ld a, [hl]
	and a
	jr nz, .asm_1401
.next_sprite
	ld a, OAM_GROUP_STRUCT_SIZE
	add_hl
	dec b
	jr nz, .loop_sprites

	; clear rest of OAM
	ld a, OAM_SIZE
	sub e
	ld b, a
	ld h, d
	ld l, e
	inc h
	xor a
.loop_clear
	ld [hli], a
	ld [de], a
	inc e
	dec b
	jr nz, .loop_clear
	ret

.asm_1401
	push bc
	push hl
	ld c, e
	cp $0b
	jr nc, .asm_1416
	ld b, a
	call .LoadSprite
	ld e, c
	pop hl
	push hl
	inc d
	ld b, [hl]
	call .LoadSprite
	jr .check_overflow
.asm_1416
	cpl
	inc a
	add $14
	jr z, .asm_1422
	push af
	ld b, a
	call .LoadSprite
	pop af
.asm_1422
	ld b, a
	pop hl
	push hl
	ld a, $28
	add_hl
	ld a, $0a
	sub b
	ld b, a
	call .LoadSprite
	ld e, c
	pop hl
	push hl
	inc d
	call .Func_1441
.check_overflow
	pop hl
	pop bc
	ld a, e
	cp OAM_SIZE
	jr c, .no_overflow
; overflow, do not process any more
	ret
.no_overflow
	dec d
	jr .next_sprite

.Func_1441:
	ld b, $0a
;	fallthrough

; sprites are made up of multiple OAMs
; load sprite pointed by hl, with OAM count given in b
; input:
; - b =  OAM count
; - hl = OAM data
; - de = virtual OAM
.LoadSprite:
	inc hl
.loop_load_oam
	ld a, [hli] ; y
	ld [de], a
	inc e
	ld a, [hli] ; x
	ld [de], a
	inc e
	ld a, [hli] ; tile ID
	ld [de], a
	inc e
	ld a, [hli] ; attibutes
	ld [de], a
	inc e
	dec b
	jr nz, .loop_load_oam
	ret

; unreferenced
Func_1454:
	push hl
	push af
	ld a, $04
	add_hl
	pop af
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ret

; unreferenced
Func_1460:
	push hl
	push af
	ld a, $01
	add_hl
	pop af
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ret
