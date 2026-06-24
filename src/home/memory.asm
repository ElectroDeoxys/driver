ClearVirtualOAM:
	ld hl, STARTOF("WRAM Virtual OAM")
	ld bc, SIZEOF("WRAM Virtual OAM")
;	fallthrough

; clears bc bytes starting from hl
ClearMemory::
	xor a
FillMemory::
.loop
	ld [hli], a
	dec bc
	inc c
	dec c
	jr nz, .loop
	inc b
	dec b
	jr nz, .loop
	ret

; copies b tiles from hl to de
SafeCopyBTiles:
.loop
	push bc
	call SafeCopyTile
	pop bc
	dec b
	jr nz, .loop
	ret

; copies 1 tile from hl to de
SafeCopyTile:
	ld b, TILE_SIZE
	call SafeCopyHLToDE
	ld a, [wNumCopiedTiles]
	inc a
	ld [wNumCopiedTiles], a
	ld a, e
	and a
	ret nz
	inc d
	ret
