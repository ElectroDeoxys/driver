Func_fc000:
	jp Func_fc061
; 0xfc003

SECTION "Func_fc061", ROMX[$4061], BANK[$3f]

Func_fc061:
	ld hl, wc400
	ld bc, $b0
	call $4057 ; Func_fc057
	ld hl, wc4b1
	ld bc, $6c
	call $4057 ; Func_fc057
	xor a
	ld hl, wc525
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wc529
	ld [hli], a
	ld [hl], a
	ld [wc52b], a
	ld a, $78
	call $4520 ; Func_fc520
	ld a, l
	ld [wc523], a
	ld a, h
	ld [wc524], a
	ld a, $78
	call $4520 ; Func_fc520
	ld a, l
	ld [wc527], a
	ld a, h
	ld [wc528], a
	ld a, $8f
	ldh [rAUDENA], a
	ld a, $77
	ldh [rAUDVOL], a
	xor a
	ldh [rAUDTERM], a
	ld a, $08
	ldh [AUD1RAM], a
	ld a, $80
	ldh [rAUD1LEN], a
	xor a
	ldh [rAUD1ENV], a
	ldh [rAUD1HIGH], a
	ld a, $80
	ldh [rAUD2LEN], a
	xor a
	ldh [rAUD2ENV], a
	ldh [rAUD2HIGH], a
	xor a
	ldh [rAUD4LEN], a
	ldh [rAUD4ENV], a
	ldh [rAUD4GO], a
	ldh [rAUD4POLY], a
	ldh [AUD3RAM], a
	ldh [rAUD3HIGH], a
	ldh [rAUD3LEN], a
	ldh [rAUD3LEVEL], a
	ld hl, $40e2
	ld c, $30
	ld b, $10
.asm_fc0d5
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_fc0d5
	ld a, $80
	ldh [AUD3RAM], a
	ldh [rAUD3HIGH], a
	ret
; 0xfc0e2
