Func_f8000:
	jp _InitAudio

Func_f8003:
	jp Func_f80f2

Func_f8006:
	jp Func_f812e
; 0xf8009

SECTION "MultiplyAByDE", ROMX[$4029], BANK[$3e]

; multiplies a by de and outputs result in hl
MultiplyAByDE:
	ld hl, 0
.loop
	srl a
	jr nc, .skip
	add hl, de
.skip
	ret z
	sla e
	rl d
	jr .loop
; 0xf8038

SECTION "ClearMemeory_Bank3e", ROMX[$4057], BANK[$3e]

ClearMemeory_Bank3e:
	ld e, 0
.loop
	ld [hl], e
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

_InitAudio:
	ld hl, wc400
	ld bc, $b0
	call ClearMemeory_Bank3e
	ld hl, wc4b1
	ld bc, $6c
	call ClearMemeory_Bank3e
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
	call Func_f8520
	ld a, l
	ld [wc523], a
	ld a, h
	ld [wc524], a
	ld a, $78
	call Func_f8520
	ld a, l
	ld [wc527], a
	ld a, h
	ld [wc528], a

	ld a, AUDENA_CH1_ON | AUDENA_CH2_ON | AUDENA_CH3_ON | AUDENA_CH4_ON | AUDENA_ON
	ldh [rAUDENA], a

	ld a, AUDVOL_RIGHT | AUDVOL_LEFT
	ldh [rAUDVOL], a
	xor a
	ldh [rAUDTERM], a

	; init channel 1
	ld a, AUD1SWEEP_DOWN
	ldh [rAUD1SWEEP], a
	ld a, AUD1LEN_DUTY_50
	ldh [rAUD1LEN], a
	xor a
	ldh [rAUD1ENV], a
	ldh [rAUD1HIGH], a

	; init channel 2
	ld a, AUD2LEN_DUTY_50
	ldh [rAUD2LEN], a
	xor a
	ldh [rAUD2ENV], a
	ldh [rAUD2HIGH], a

	; init channel 4
	xor a
	ldh [rAUD4LEN], a
	ldh [rAUD4ENV], a
	ldh [rAUD4GO], a
	ldh [rAUD4POLY], a

	; init channel 3
	ldh [rAUD3ENA], a
	ldh [rAUD3HIGH], a
	ldh [rAUD3LEN], a
	ldh [rAUD3LEVEL], a

	ld hl, .WaveSample
	ld c, LOW(_AUD3WAVERAM)
	ld b, AUD3WAVE_SIZE
.loop_copy_wave_sample
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop_copy_wave_sample

	ld a, AUD3ENA_ON
	ldh [rAUD3ENA], a
	ldh [rAUD3HIGH], a
	ret

.WaveSample:
	; square wave with two cycles
	dn 15, 15, 15, 15, 15, 15, 15, 15,  0,  0,  0,  0,  0,  0,  0,  0, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0,  0,  0,  0,  0,  0,  0

Func_f80f2:
	xor a
	ld [wc4b0], a
	ld hl, wc523
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hli], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hl], a
	xor a
	ld [wc4b0], a
	ldh [hff91], a
	ldh [hff92], a
	ld a, [wc52b]
	and $01
	jr nz, .asm_f8122
	call Func_f8232
	call $4814 ; Func_f8814
.asm_f8122
	ldh a, [hff92]
	ldh [rAUDTERM], a
	xor a
	ld [wc526], a
	ld [wc52a], a
	ret

Func_f812e:
	push hl
	push hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wc521], a
	ld a, h
	ld [wc522], a
	pop hl
	add hl, de
	ld a, l
	ld [wc51f], a
	ld a, h
	ld [wc520], a
	pop hl
	add hl, bc
	ld a, l
	ld [wc51d], a
	ld a, h
	ld [wc51e], a
	ret
; 0xf8155

SECTION "Func_f8232", ROMX[$4232], BANK[$3e]

Func_f8232:
	ld hl, wc40a
	ld b, $08
	ld de, $16
.asm_f823a
	ld a, [hl]
	bit 0, a
	push hl
	push de
	push bc
	call nz, Func_f824f
	ld hl, hff91
	inc [hl]
	pop bc
	pop de
	pop hl
	add hl, de
	dec b
	jr nz, .asm_f823a
	ret

Func_f824f:
	ldh [hff8f], a
	ld b, a
	ld a, l
	sub $0a
	ld c, a
	inc l
	ld a, [hli]
	ldh [hff8c], a
	ld a, [hl]
	ldh [hff8d], a
	ld a, c
	ldh [hff8a], a
	ld a, h
	ldh [hff8b], a
	ld a, [wc4b0]
	inc a
	ld [wc4b0], a
	ld a, $00
	add c
	ld l, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [wc526]
	bit 5, b
	jr z, .asm_f827b
	ld a, [wc52a]
.asm_f827b
	ld b, a
	ld a, e
	sub b
	ld e, a
	ld a, d
	sbc $00
	ld [hld], a
	ld [hl], e
	jr c, .asm_f8288
	or e
	ret nz
.asm_f8288
	ld a, $02
	add c
	ld l, a
	ld a, [hli]
	ld b, [hl]
	ld l, c
	ld c, a
	ld d, h
	ld e, l
	ld hl, $42c2
	push hl
	ld a, [bc]
	inc bc
	bit 7, a
	jr z, .asm_f82aa
	sla a
	add $f4
	ld l, a
	ld a, $42
	adc $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.asm_f82aa
	ld h, d
	ld l, e
	ld d, a
	ldh a, [hff8f]
	bit 1, a
	ld a, $0f
	jr z, .asm_f82b7
	ld a, [bc]
	inc bc
.asm_f82b7
	ldh [hff8e], a
	ld a, d
	push hl
	push bc
	call $476e ; Func_f876e
	pop bc
	pop hl
	ret
; 0xf82c2

SECTION "Func_f8520", ROMX[$4520], BANK[$3e]

Func_f8520:
	ld de, $125
	call MultiplyAByDE
	xor a
	add hl, hl
	rla
	add hl, hl
	rla
	ld l, h
	ld h, a
	ret
; 0xf852e
