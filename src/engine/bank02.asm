SECTION "Func_8ce1", ROMX[$4ce1], BANK[$2]

Func_8ce1::
	ld a, $01
	call Func_f27
	ld a, TRUE
	ld [wResetDisabled], a
	call $4d7d ; Func_8d7d
	ld a, [wd821]
	cp $02
	jr z, .asm_8cff
	ld a, $06
	ld [wd81f], a
	xor a
	ld [wResetDisabled], a
	ret

.asm_8cff
	ld a, TRUE
	ld [wResetDisabled], a
	ld a, $02
	call Func_f2e
	call $4ddb ; Func_8ddb
	call $5532 ; Func_9532
	ld bc, $a00
	call $545c ; Func_945c
	xor a
	ld [wdc26], a
	xor a
	ld [wdc2f], a
	ld hl, $561f
	ld c, $02
	ld b, $13
	call Func_1536
	ld hl, $4d45
	ld c, $02
	ld b, $17
	call Func_1536
	call $54d8 ; Func_94d8
	ld a, [wd81f]
	cp $06
	jr nz, .asm_8d40
	ld a, $01
	call Func_f27
.asm_8d40
	xor a
	ld [wResetDisabled], a
	ret
; 0x8d45
