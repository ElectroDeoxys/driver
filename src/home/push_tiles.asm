ClearVRAMTiles::
	ld hl, wVRAMNumTiles
	xor a
	ld [hli], a ; V0TILES_8000
	ld [hli], a ; V0TILES_9000
	ld [hli], a ; V0TILES_8800
	ld [hli], a ; V1TILES_8000
	ld [hli], a ; V1TILES_9000
	ld [hl], a  ; V1TILES_8800
	ret

; input:
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
; - c:de = source of tiles (compressed)
PushTilesToVRAM_Compressed::
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	ld a, b
	ld hl, wVRAMNumTiles
	add_hl
	ld c, [hl] ; tile index
	push hl
	ld hl, VRAMBlockAddresses
	ld a, b
	cp V1TILES
	jr c, .vram0
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	sub V1TILES
.vram0
	add_hl
	ld h, [hl] ; high byte of dest
	ld l, $00
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ; *16
	add hl, bc

	; swap hl with de
	ld a, l
	ld l, e
	ld e, a
	ld a, h
	ld h, d
	ld d, a

	push de
	call Decompress
	ld h, d
	ld l, e
	pop de
	call HLMinusDE
	srl l
	srl l
	srl l
	srl l
	ld a, h
	add a
	add a
	add a
	add a
	add l
	pop hl
	add [hl]
	ld [hl], a
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .dmg
	ld a, BANK("VRAM0")
	vramswitch
.dmg
	pop af
	bankswitch
	ret

; input:
; - a  = number of tiles
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
; - c:de = source of tiles
PushTilesToVRAM::
	ld [wNumTilesToPush], a
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	ld a, b
	ld hl, wVRAMNumTiles
	add_hl
	ld c, [hl] ; tile index
	push hl
	ld hl, VRAMBlockAddresses
	ld a, b
	cp V1TILES
	jr c, .vram0
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	sub V1TILES
.vram0
	add_hl
	ld h, [hl] ; high byte of dest
	ld l, $00
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ; *16
	add hl, bc

	; swap hl with de
	ld a, l
	ld l, e
	ld e, a
	ld a, h
	ld h, d
	ld d, a

	ld a, [wNumTilesToPush]
	ld b, a
	call SafeCopyBTiles
	pop hl

	ld a, [wNumTilesToPush]
	add [hl]
	ld [hl], a
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .dmg
	ld a, BANK("VRAM0")
	vramswitch
.dmg
	pop af
	bankswitch
	ret

; input
; - a = number of tiles
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
BlackOutVRAMTiles::
	ld c, a
	ldh a, [hROMBank]
	push af

	; black out wGfxBuffer
	push bc
	ld hl, wGfxBuffer
	ld bc, TILE_SIZE
	call ClearMemory
	pop bc

.loop_tiles
	push bc
	ld de, wGfxBuffer
	ld c, $1
	ld a, 1 ; tile
	call PushTilesToVRAM
	pop bc
	dec c
	jr nz, .loop_tiles

	pop af
	bankswitch
	ret

; copies b bytes from c:hl to de
FarCopy::
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop af
	bankswitch
	ret

VRAMBlockAddresses:
	db HIGH(v0Tiles0) ; V0TILES_8000 | V1TILES_8000
	db HIGH(v0Tiles2) ; V0TILES_9000 | V1TILES_9000
	db HIGH(v0Tiles1) ; V0TILES_8800 | V1TILES_8800

; unreferenced
Func_b34:
	ld a, [hli]
	cp [hl]
	ret z
	push hl
	ld a, [hli]
	add a
	ld e, a
	add a
	add e
	ld e, a
	ld d, $00
	ld a, [hli]
	ld [wNumTilesToPush], a
	add hl, de
	ld a, [hl]
	bankswitch
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld h, b
	ld l, c
	ld a, [wNumTilesToPush]
	ld b, a
	call SafeCopyBTiles
	ld b, h
	ld c, l
	pop hl
	ld a, [wNumTilesToPush]
	dec a
	cpl
	add [hl]
	ld [hl], a
	jr z, .asm_b77
	dec hl
	ld [hl], d
	dec hl
	ld [hl], e
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	pop hl
	ld a, $01
	and a
	ret
.asm_b77
	pop hl
	inc [hl]
	ld a, [hld]
	cp [hl]
	ret

; unreferenced
Func_b7c:
	push hl
	ld l, $00
.asm_b7f
	sub 100
	jr c, .asm_b86
	inc l
	jr .asm_b7f
.asm_b86
	add 100
	call .Func_b9e
	ld l, $00
.asm_b8d
	sub 10
	jr c, .asm_b94
	inc l
	jr .asm_b8d
.asm_b94
	add 10
	call .Func_b9e
	add c
	ld [de], a
	inc de
	pop hl
	ret

.Func_b9e:
	push af
	ld a, l
	and a
	jr nz, .asm_ba8
	ld a, b
	and a
	jr nz, .asm_baf
	ld a, l
.asm_ba8
	add c
	ld [de], a
	inc de
	ld b, $00
	pop af
	ret
.asm_baf
	pop af
	ret

; unreferenced
Func_bb1:
	ld b, a
	swap a
	and $0f
	add c
	ld [de], a
	inc de
	ld a, b
	and $0f
	add c
	ld [de], a
	inc de
	ret

; unreferenced
Func_bc0:
	ld a, h
	swap a
	and $0f
	add c
	ld [de], a
	inc de
	ld a, h
	and $0f
	add c
	ld [de], a
	inc de
	ld a, l
	swap a
	and $0f
	add c
	ld [de], a
	inc de
	ld a, l
	and $0f
	add c
	ld [de], a
	inc de
	ret
