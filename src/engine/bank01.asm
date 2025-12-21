Func_4000::
	xor a
	ld [wd868], a
	ld [wd86a], a
	ld a, $00
	ld [wd83f], a
	ld a, [wd828]
	ld c, a
	ld a, [wd829]
	ld b, a
	ld a, [wd82a]
	ld e, a
	ld a, [wd82b]
	ld d, a
	ld hl, wd826
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd82c]
	call Func_2631
	set 1, [hl]
	ld a, l
	ld [wda4a], a
	ld a, h
	ld [wda4b], a
	push hl
	ld hl, Func_4066
	ld c, $01
	ld b, $01
	call Func_1536
	pop de
	ld a, ENT_UNK06
	call Func_10d7

	; swap hl and de
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, ENT_UNK23
	call Func_10d7

	call Func_1124
	ld a, ENT_UNK25
	call Func_10d7

	jp Func_3047
; 0x4057

SECTION "Func_4066", ROMX[$4066], BANK[$1]

Func_4066:
	call Func_1598
	xor a
	ld [wda94], a
	ld [wda95], a
	ld [wda96], a
	ld a, [wd81f]
	cp $06
	call nz, Func_475f
.asm_407b
	ld a, $01
	call Func_14e8
	ld a, [wd820]
	cp $00
	jr z, .asm_407b
	ld de, $4446
	ld a, $01
	jp Func_157f
; 0x408f

SECTION "Func_468a", ROMX[$468a], BANK[$1]

Func_468a:
	push hl
	ld a, $0e
	add_hl
	bit 7, [hl]
	ld a, $02
	jr z, .asm_4696
	ld a, $01
.asm_4696
	ld hl, wJoypadDown
	and [hl]
	pop hl
	ret
; 0x469c

SECTION "Func_475f", ROMX[$475f], BANK[$1]

Func_475f:
	ld a, [wd83f]
	cp $00
	ret nz
	call .Func_4772
	call .Func_479f
	call .Func_4781
	call .Func_47e9
	ret

.Func_4772:
	ld a, [wda96]
	and a
	jr nz, .asm_477c
	ld [wda95], a
	ret
.asm_477c
	dec a
	ld [wda96], a
	ret

.Func_4781:
	ld a, [wda97]
	and a
	jr z, .asm_4799
	ld a, [wda99]
	and a
	jr z, .asm_4793
	call .Func_483b
	jp .Func_4829
.asm_4793
	call .Func_4830
	jp .Func_4834
.asm_4799
	call .Func_4830
	jp .Func_483b

.Func_479f:
	ld a, [wJoypadDown]
	and $30
	jr z, .asm_47c3
	ld a, $11
	call Func_10de
	cp $08
	jr c, .asm_47c3
	cp $14
	jr c, .asm_47bc
	call Func_468a
	jr z, .asm_47bc
	call .Func_4855
	ret
.asm_47bc
	call .Func_485c
	call .Func_484a
	ret
.asm_47c3
	call Func_468a
	jr z, .asm_47df
	ld a, $0e
	call Func_10de
	cp $10
	jr c, .asm_47df
	cp $20
	jr nc, .asm_47bc
	call .Func_485c
	call .Func_4851
	call .Func_483f
	ret
.asm_47df
	call .Func_4846
	call .Func_4851
	call .Func_485c
	ret

.Func_47e9:
	ld a, [wda95]
	and a
	ret nz
	ld a, $0e
	call Func_10de
	bit 7, a
	jr z, .asm_47f9
	cpl
	inc a
.asm_47f9
	rrca
	rrca
	and $0f
	cp $0d
	jr c, .asm_480f
	call Func_774
	and $01
	ld a, $0c
	jr z, .asm_480f
	ld a, $22
	ld c, a
	jr .asm_4812
.asm_480f
	add $0d
	ld c, a
.asm_4812
	ld a, [wda94]
	cp c
	ret z
	call .Func_489c
	ld a, c
	ld [wda94], a
	call Func_ef7
	xor a
	ld [wda95], a
	ld [wda96], a
	ret

.Func_4829:
	ld a, $24
	ld bc, $108
	jr .asm_4860
.Func_4830:
	ld a, $24
	jr .asm_4885
.Func_4834:
	ld a, $25
	ld bc, $108
	jr .asm_4860
.Func_483b:
	ld a, $25
	jr .asm_4885
.Func_483f:
	ld a, $1a
	ld bc, $207
	jr .asm_4860
.Func_4846:
	ld a, $1a
	jr .asm_4885
.Func_484a:
	ld a, $1b
	ld bc, $30a
	jr .asm_4860
.Func_4851:
	ld a, $1b
	jr .asm_4885
.Func_4855:
	ld a, $1c
	ld bc, $41e
	jr .asm_4860
.Func_485c:
	ld a, $1c
	jr .asm_4885
.asm_4860
	ld e, a
	ld a, [wda95]
	cp b
	jr c, .asm_486f
	jr z, .asm_486a
	ret
.asm_486a
	ld a, [wda94]
	cp e
	ret z
.asm_486f
	ld a, [wda94]
	call .Func_489c
	ld a, e
	ld [wda94], a
	call Func_ef7
	ld a, b
	ld [wda95], a
	ld a, c
	ld [wda96], a
	ret
.asm_4885
	and a
	ret z
	push hl
	ld hl, wda94
	cp [hl]
	pop hl
	ret nz
	call Func_f0c
	xor a
	ld [wda94], a
	ld [wda95], a
	ld [wda96], a
	ret

.Func_489c:
	and a
	ret z
	jp Func_f0c
; 0x48a1

SECTION "CheckSkipCompanies", ROMX[$7cff], BANK[$1]

; whether to skip showing the initial companies screens
; always returns z
CheckSkipCompanies::
	ld a, [.Value]
	and a
	ret

.Value:
	db FALSE
; 0x7d05
