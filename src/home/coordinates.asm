; unreferenced
UnreferencedPixelToBGMapPtr:
	srl l
	srl l
	srl l
	srl h
	srl h
	srl h
;	fallthrough

; converts tile coordinate (h, l) into
; pointer to its tile in BGMap
; input:
; - l = x tile coordinate (0 - 31)
; - h = y tile coordinate (0 - 31)
CoordinateToBGMapPtr:
	push bc
	ld c, l
	ld l, h
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *32
	ld b, HIGH(v0BGMap0)
	add hl, bc
	pop bc
	; hl = (h * TILEMAP_WIDTH) + l + v0BGMap0
	ret
