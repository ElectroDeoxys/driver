; copies b tiles from hl to de
; but alternating with a black tile
; if a == 0, then interleave after tiles
; if a == 1, then interleave before tiles
; input:
; - c:hl = source gfx
; - de = destination
CopyTilesWithAlternatingBlackTiles::
	push bc
	push hl
	ld hl, wGfxBuffer
	lb bc, TILE_SIZE, $00
.asm_7dd
	ld [hl], c
	inc hl
	dec b
	jr nz, .asm_7dd
	pop hl
	pop bc

	and a
	jr nz, .pre

; post
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.loop_copy_post
	push bc
	call SafeCopyTile
	call .CopyBlackTile
	pop bc
	dec b
	jr nz, .loop_copy_post
	pop af
	bankswitch
	ret

.pre
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.loop_copy_pre
	push bc
	call .CopyBlackTile
	call SafeCopyTile
	pop bc
	dec b
	jr nz, .loop_copy_pre
	pop af
	bankswitch
	ret

.CopyBlackTile:
	push hl
	ld hl, wGfxBuffer
	call SafeCopyTile
	pop hl
	ret

; copies b tiles from c:hl to de
SafeCopyFarTiles::
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	call SafeCopyBTiles
	pop af
	bankswitch
	ret

CopyBGMapBox_ToCoordinate::
	call CoordinateToBGMapPtr
;	falltrough

; copies data from de to bg map hl
; in shape of box with dimensions bxc
; input:
; - hl = bg map pointer
; - de = bg map data
; - (b, c) = (rows, columns)
CopyBGMapBox::
	swap_hl_de

	ld a, c
	add a ; *2
	cp b
	jr c, .loop_copy_cols
.loop_copy_rows
	push bc
	push de
	ld b, c
	call SafeCopyHLToDE
	pop de
	pop bc
	; next row
	ld a, TILEMAP_WIDTH
	add_de
	dec b
	jr nz, .loop_copy_rows
	ret

.loop_copy_cols
	push bc
	push de
	call SafeCopyColumn
	pop de
	pop bc
	inc e
	dec c
	jr nz, .loop_copy_cols
	ret

SafeCopyColumn:
	; CGB can copy 6 bytes
	ld c, 6
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .loop_copy
	; DMG can copy 3 bytes
	ld c, 3
.loop_copy
	; does it exceed c bytes?
	ld a, b
	sub c
	jr nc, .asm_891
	add c
	ret z ; nothing to copy

	; copies b bytes
	push hl
	ld hl, .PtrTable
	dec a
	add a
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	push bc
	ld bc, TILEMAP_WIDTH
	ldh a, [rLCDC]
	rlca
	jr nc, .asm_890
	wait_ppu
.asm_890
	ret
.asm_891
	ld b, a
	ld a, c
	cp $06
	jr z, .asm_89e
	push bc
	call .CopyDMG
	pop bc
	jr .loop_copy
.asm_89e
	push bc
	call .CopyCGB
	pop bc
	jr .loop_copy

.PtrTable:
	dw .copy_1
	dw .copy_2
	dw .copy_3
	dw .copy_4
	dw .copy_5

.CopyCGB:
	ld bc, TILEMAP_WIDTH
	ldh a, [rLCDC]
	rlca
	jr nc, .copy_6
	wait_ppu
.copy_6
	ld a, [hli]
	ld [de], a
	ld a, e
	add c
	ld e, a
	ld a, d
	adc b
	ld d, a
FOR n, 1, 6
DEF x = 6 - n
.copy_{u:x}
	ld a, [hli]
	ld [de], a
	ld a, e
	add c
	ld e, a
	ld a, d
	adc b
	ld d, a
ENDR
	ret

.CopyDMG:
	ld bc, TILEMAP_WIDTH
	ldh a, [rLCDC]
	rlca
	jr nc, .asm_908
	wait_ppu
.asm_908
REPT 3
	ld a, [hli]
	ld [de], a
	ld a, e
	add c
	ld e, a
	ld a, d
	adc b
	ld d, a
ENDR
	ret

; copies b bytes from hl to de,
; only when PPU is not busy
SafeCopyHLToDE:
	; CGB can copy 12 bytes
	ld c, 12
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .loop_copy
	; DMG can copy  6 bytes
	ld c, 6
.loop_copy
	; does it exceed c bytes?
	ld a, b
	sub c
	jr nc, .copy_c_bytes
	add c
	ret z ; nothing to copy

	; copies b bytes
	push hl
	ld hl, .PtrTable
	dec a
	add a
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	push bc
	ldh a, [rLCDC]
	rlca
	jr nc, .asm_94e
	wait_ppu
.asm_94e
	ret ; jumps to bc

.copy_c_bytes
	ld b, a
	ld a, c
	cp 12
	jr z, .copy_12
	call .CopyDMG
	jr .loop_copy
.copy_12
	call .CopyCGB
	jr .loop_copy

.PtrTable:
	dw .copy_1
	dw .copy_2
	dw .copy_3
	dw .copy_4
	dw .copy_5
	dw .copy_6
	dw .copy_7
	dw .copy_8
	dw .copy_9
	dw .copy_10
	dw .copy_11

.CopyCGB:
	ldh a, [rLCDC]
	rlca
	jr nc, .asm_986
	wait_ppu
.asm_986
	ld a, [hli]
	ld [de], a
	inc e
	FOR n, 1, 12
	DEF x = 12 - n
	.copy_{u:x}
		ld a, [hli]
		ld [de], a
		inc e
	ENDR
	ret

.CopyDMG:
	ldh a, [rLCDC]
	rlca
	jr nc, .asm_9bc
	wait_ppu
.asm_9bc
	REPT 6
		ld a, [hli]
		ld [de], a
		inc e
	ENDR
	ret

ClearBGMap:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .Clear
	ld a, BANK("VRAM1")
	vramswitch
	call .Clear
	ld a, BANK("VRAM0")
	vramswitch
.Clear:
	ld hl, v0BGMap0 ; v1BGMap0
	ld b, 0 ; $100
.loop_clear
	ldh a, [rLCDC]
	rlca
	jr nc, .clear_bytes
	wait_ppu
.clear_bytes
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .loop_clear
	ret
