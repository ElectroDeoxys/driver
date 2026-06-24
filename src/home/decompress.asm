Func_59e:
	ld a, [hli]
	bankswitch
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	call .Func_5f1
	pop hl
	ld a, [hli]
	bankswitch
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	call .Func_5e9
	pop hl
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	ret nz ; skip for DMG

	ld a, BANK("VRAM1")
	vramswitch
	ld a, [hli]
	bankswitch
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	call .Func_5f1
	pop hl
	ld a, [hli]
	bankswitch
	ld e, [hl]
	inc hl
	ld d, [hl]
	call .Func_5e9
	ld a, BANK("VRAM0")
	vramswitch
	ret

.Func_5e9:
	ld h, d
	ld l, e
	ld de, v0BGMap0
	jp Decompress

.Func_5f1:
	ld h, d
	ld l, e
	ld de, v0Tiles2
	call Decompress
	ld a, d
	cp HIGH(v0TilesEnd)
	ret c ; within tile data
	; we went over tile data, need to check how many bytes we're over
	jr nz, .copy_overfill
	; return if de == v0TilesEnd, that is, 0 tiles over tile data end
	ld a, e
	or a
	ret z
.copy_overfill
	; copies (de - v0TilesEnd) bytes to v0Tiles1
	ld hl, -v0TilesEnd
	add hl, de
	ld b, h
	ld c, l
	ld hl, v0TilesEnd
	ld de, v0Tiles1
	jp .loop_copy ; useless jump

.loop_copy
	ldh a, [rLCDC]
	rlca
	jr nc, .safe
	wait_ppu
.safe
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop_copy
	ret

; the decompression algorithm is pretty complex
; it seems to obfuscate the way that command bits
; are processed and how bytes are copied literally or from lookback
Decompress:
	ld bc, $12
	add hl, bc
	scf
	ld a, [hli]
	adc a
	add a ; *4 + 2
	jp .next_cmd_bit

.asm_636
	ld a, [hli]
	adc a
	jr .asm_670

.asm_63a
	ld a, [hli]
	adc a
	jr .asm_675

.asm_63e
	ld a, [hli]
	adc a
	jr .asm_67a

.asm_642
	ld a, [hli]
	adc a
	jr .asm_689

.asm_646
	ld a, [hli]
	adc a
	jr .asm_64f

.copy_long
	; next 4 bits in command byte dictates how many bytes to copy
	; bytes to copy = 2 * (%xxxx + 3) bytes
	ld c, 4
.loop_get_long_copy_count
	add a
	jr z, .asm_646
.asm_64f
	rl b
	dec c
	jr nz, .loop_get_long_copy_count
	; set c = 2*(3 + b)
	push af
	ld a, 3
	add b
	add a
	ld c, a ; 2*(3 + b)
.loop_copy_long
	call Func_d3
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop_copy_long
	pop af
	jr .next_cmd_bit

.asm_669
	ld a, [hli]
	adc a
	jr c, .asm_6e6
.asm_66d
	add a ; next bit set?
	jr z, .asm_636
.asm_670
	rl c ; *2 (if carry set +1)
	add a ; next bit set?
	jr z, .asm_63a
.asm_675
	jr nc, .asm_686 ; no
	; yes
	add a ; next bit set?
	jr z, .asm_63e
.asm_67a
	; do c = 2*(c - 1) (if carry set +1)
	dec c
	push hl
	ld h, a ; temp save a
	ld a, c
	adc a
	ld c, a
	cp $09
	ld a, h
	pop hl
	; for c to be 9 here, bits needed to be %10111
	jr z, .copy_long

.asm_686
	add a ; next bit set?
	jr z, .asm_642
.asm_689
	; if not set, then either do lookback with:
	; - c = 4, if cmd byte was %10000
	; - c = 5, if cmd byte was %10100
	; - c = 8, if cmd byte was %10110
	jr nc, .lookback

	add a ; next bit set?
	jr nz, .asm_690
	ld a, [hli]
	adc a
.asm_690
	rl b
	add a ; next bit set?
	jr nz, .asm_697
	ld a, [hli]
	adc a
.asm_697
	jr c, .asm_6ff
	inc b
	dec b
	jr nz, .lookback
	inc b
.asm_69e
	add a
	jr nz, .asm_6a3
	ld a, [hli]
	adc a
.asm_6a3
	rl b
.lookback
	; copies from de - [hl] - (b*$100) - 1
	; a total of c bytes
	push af
	ld a, e
	sub [hl]
	push hl
	ld l, a
	ld a, d
	sbc b
	ld h, a
	dec hl
.loop_lookback
	call Func_d3
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr z, .done_lookback
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop_lookback
.done_lookback
	pop hl
	inc hl
	pop af
	jr .next_cmd_bit

.asm_6c2
	ld a, [hli]
	adc a
	jr c, .asm_6de

.copy_byte
	push af
	call Func_d3
	ld a, [hli]
	ld [de], a
	inc de
	pop af
.next_cmd_bit
	; if top bit unset, copy byte...
	add a
	jr c, .special_cmd
	; copy byte
	push af
	call Func_d3
	ld a, [hli]
	ld [de], a
	inc de
	pop af
	; if top bit unset, copy byte...
	add a
	jr nc, .copy_byte

.special_cmd
	; bit set, set up lookback
	jr z, .asm_6c2
.asm_6de
	lb bc, 0, 2

	add a ; next bit set?
	jr z, .asm_669
	jr nc, .asm_66d ; no, was %10
.asm_6e6
	add a ; next bit set?
	jr z, .asm_711
.asm_6e9
	jr nc, .lookback ; no, was %110
	; yes, increment c
	inc c
	; is next bit set?
	add a
	jr z, .asm_715
.asm_6ef
	jr nc, .asm_686 ; no, was %1110
	; yes, then [hl] holds (lookback offset - 8)
	ld c, [hl]
	inc hl
	; is it zero?
	inc c
	dec c
	jr z, .asm_719 ; yes
	; no, add $8 to it
	push af
	ld a, c
	add $8
	ld c, a
	pop af
	jr .asm_686

.asm_6ff
	add a
	jr nz, .asm_704
	ld a, [hli]
	adc a
.asm_704
	rl b
	set 2, b
	add a
	jr nz, .asm_70d
	ld a, [hli]
	adc a
.asm_70d
	jr c, .lookback
	jr .asm_69e

.asm_711
	ld a, [hli]
	adc a
	jr .asm_6e9

.asm_715
	ld a, [hli]
	adc a
	jr .asm_6ef

.asm_719
	add a
	jr nz, .asm_71e
	ld a, [hli]
	adc a
.asm_71e
	jr c, .next_cmd_bit
	ret
