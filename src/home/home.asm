_Start:
	ld sp, hStackBottom
	call Init
	call EnableDoubleSpeed
Reset:
	ld sp, hStackBottom
	call InitTransferVirtualOAMAndClearWRAM
	call Func_1084
	call Func_1b5
	call Func_cc2
	call Func_333
	call EnableStatInterrupt
	call Func_1fd
	call Func_7ab
	call $1cb9
	call $15bb
	jr Reset

Init:
	ldh [hBootUpA], a
	disable_lcd
	xor a
	ldh [hff93], a
ClearWRAM:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .gb

	; clear WRAM0
	ld hl, STARTOF(WRAM0)
	ld bc, SIZEOF(WRAM0)
	call ClearMemory

	; clear WRAMX
	ld b, 7 ; num of WRAMX banks
.loop_clear_wramx
	push bc
	ld a, b
	wramswitch
	ld hl, STARTOF(WRAMX)
	ld bc, SIZEOF(WRAMX)
	call ClearMemory
	pop bc
	dec b
	jr nz, .loop_clear_wramx
	ld a, b ; 0
	wramswitch
	ret

.gb
	; clear WRAM
	ld hl, STARTOF(WRAM0)
	ld bc, SIZEOF(WRAM0) + SIZEOF(WRAMX)
	jp ClearMemory

Func_1b5:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .gb
	ld a, BANK("VRAM0")
	vramswitch
	ld a, BANK("WRAM0")
	wramswitch
.gb
	xor a
	ld [wc56e], a
	ld a, $c0
	ld [wc56f], a
	ld a, $c2
	ld [wc570], a
	ld a, LCDC_OBJ_ON | LCDC_OBJ_16
	ldh [hff99], a
	call Func_4c6

	ld a, TRUE
	ld [wResetDisabled], a
	
	call InitHardwareRegisters

	; enable serial interrupt
	ldh a, [rIE]
	set B_IE_SERIAL, a
	call SetInterrupts
	ei

	; reset all LCD flags except enable flag
	ldh a, [rLCDC]
	and LCDC_ENABLE
	ldh [rLCDC], a
	disable_lcd

	ld a, $01
	bankswitch
	jp Func_721

Func_1fd:
	call Func_320
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb

; gb
	ld a, $00
	call .Func_25c
.asm_20b
	call Func_501
	call Func_530
	jr .asm_20b

.cgb
	ld hl, hff93
	ld a, [hl]
	ld [hl], $01
	and a
	ret nz
	ld a, $01
	bankswitch
	call $7cff
	ret nz
	ld a, $06
	ld b, $3c
	ld c, $3c
	call .Func_254
	ld a, $05
	ld b, $3c
	ld c, $3c
	call .Func_254
	ld a, $07
	ld b, $3c
	ld c, $3c
	call .Func_254
	ld a, $08
	ld b, $3c
	ld c, $3c
	call .Func_254
	ld a, $03
	ld b, $3c
	ld c, $3c
	call .Func_254
	ret

.Func_254:
	push bc
	call .Func_25c
	pop bc
	jp .asm_2a1

.Func_25c:
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *16
	ld de, $33a
	add hl, de
	ldh a, [hROMBank]
	push af
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .asm_27b
	ld a, [hli]
	ld [wc5fd], a
	inc hl
	inc hl
	inc hl
	ld a, $03
	jr .asm_294
.asm_27b
	inc hl
	ld a, [hli] ; bank
	bankswitch
	ld e, [hl]  ; ptr
	inc hl      ;
	ld d, [hl]  ;
	inc hl      ;
	push hl
	ld h, d
	ld l, e
	ld de, wc5fd
	ld b, $40
	call CopyHLtoDE
	pop hl
	ld a, $01
.asm_294
	call Func_cf2
	call Func_59e
	pop af
	bankswitch
	ret

.asm_2a1
	push bc
	call Func_501
	call Func_530
	pop bc
	ld a, c
	and a
	jr nz, .asm_2b6
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr nz, .asm_2ba
	jr .asm_2b7
.asm_2b6
	dec c
.asm_2b7
	dec b
	jr nz, .asm_2a1
.asm_2ba
	call .Func_2ca
.asm_2bd
	call Func_501
	call Func_530
	ld a, [wc67d]
	and a
	jr nz, .asm_2bd
	ret

.Func_2ca:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .asm_2dd
	ld a, $00
	ld hl, wc5fd
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $03
	jp Func_cf2
.asm_2dd
	ld hl, wc5fd
	ld c, 8 + 8 ; num of BG and OB pals
.asm_2e2
	ld b, PAL_SIZE
	ld de, Pals_ecd
.asm_2e7
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .asm_2e7
	dec c
	jr nz, .asm_2e2
	ld a, $01
	jp Func_cf2
; 0x2f5

SECTION "Func_320", ROM0[$320]

Func_320:
	xor a
	ldh [hff9a], a
	ldh [hff9b], a
	lddmgpal c, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE
	ld hl, Pals_ecd
	call Func_cc9
	call Func_721
	jp ClearBGMap

Func_333:
	ldh a, [hff99]
	or LCDC_BG_ON | LCDC_ON
	ldh [rLCDC], a
	ret
; 0x33a

SECTION "Func_3da", ROM0[$3da]

_VBlank:
	push af
	push bc
	push de
	push hl
	ld hl, wFrameCounter
	inc [hl]
	ld hl, wc56d
	inc [hl]
	ld a, [wc56e]
	and a
	jr nz, .push_oam
	ld a, [hl] ; wc56d
	cp $02
	jr c, .push_oam
	xor a
	ld [hl], a
	inc a ; TRUE
	ld [wc56e], a
	call Func_43e

.push_oam
	; is it odd or even frame?
	ld a, [wFrameCounter]
	and $1
	ld d, a
	ld a, [wc570]
	or d
	ldh [hTransferVirtualOAM + $1], a
	call hTransferVirtualOAM

	call Func_4a5

	ei
	ldh a, [hROMBank]
	ldh [hTempROMBank], a
	call Func_f81
	ldh a, [hTempROMBank]
	bankswitch
	pop hl
	pop de
	pop bc

	; exit only during V-Blank
	ldh a, [rSTAT]
	and STAT_MODE
	cp STAT_VBLANK
	jr z, .done
	wait_ppu
.done
	pop af
	reti

; waits for wc56e to be TRUE
Func_434:
	ld hl, wc56e
	ld [hl], FALSE
.loop
	ld a, [hl]
	and a
	jr z, .loop
	ret

Func_43e:
	; swap wc56f and wc570
	ld hl, wc570
	ld de, wc56f
	ld c, [hl]
	ld a, [de]
	ld [hl], a
	ld a, c
	ld [de], a

	; swap wc681 and wc683
	ld hl, wc681
	ld de, wc683
	ld c, [hl]
	ld a, [de]
	ld [hli], a
	ld a, c
	ld [de], a
	inc de
	ld c, [hl]
	ld a, [de]
	ld [hl], a
	ld a, c
	ld [de], a
	ret

_Stat:
	di
	push af
	push hl
	ld hl, hSCX
	ld a, [hli]
	ldh [rSCX], a ; hSCX
	ld a, [hli]
	ldh [rSCY], a ; hSCY
	ld a, [hli]
	ldh [rLCDC], a ; hLCDC
	ld a, [hl]
	ldh [rLYC], a ; hLYC
	push bc
	call Func_487
	pop bc
	pop hl

	ldh a, [rLCDC]
	rlca
	jr nc, .done ; lcd off
	wait_ppu
.done
	pop af
	ei ; unnecessary
	reti

Func_487:
	ld hl, wLCDCSettingsPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, LOW(hSCX)
	ld a, [hli]
	ld [$ff00+c], a ; hSCX
	inc c
	ld a, [hli]
	ld [$ff00+c], a ; hSCY
	inc c
	ld a, [hli]
	or LCDC_BG_ON | LCDC_ON
	ld [$ff00+c], a ; hLCDC
	inc c
	ld a, [hli]
	ld [$ff00+c], a ; hLYC
	ld a, l
	ld [wLCDCSettingsPtr + 0], a
	ld a, h
	ld [wLCDCSettingsPtr + 1], a
	ret

Func_4a5:
	ld a, [wc681 + 0]
	ld [wLCDCSettingsPtr + 0], a
	ld a, [wc681 + 1]
	ld [wLCDCSettingsPtr + 1], a
	call Func_487

	ld hl, hSCX
	ld a, [hli]
	ldh [rSCX], a
	ld a, [hli]
	ldh [rSCY], a
	ld a, [hli]
	ldh [rLCDC], a
	ld a, [hl]
	ldh [rLYC], a
	jp Func_487

Func_4c6:
	; set wc681 and wLCDCSettingsPtr to wLCDCSettings
	ld de, wLCDCSettings
	ld hl, wc681
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wLCDCSettingsPtr
	ld [hl], e
	inc hl
	ld [hl], d

	ld de, wc6cf
	ld hl, wc683
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wLCDCSettings
	call .ClearSettings
	ld hl, wc6cf
	call .ClearSettings
	ld hl, hSCX
	call .ClearSettings

	ld hl, hLCDC
	ld a, [hl]
	or LCDC_BG_ON | LCDC_ON
	ld [hl], a
	ret

.ClearSettings:
	xor a
	ld [hli], a  ; scroll X
	ld [hli], a  ; scroll y
	ldh a, [hff99]
	ld [hli], a  ; lcdc
	ld [hl], $ff ; lyc
	ret

Func_501:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hff9b]
	ld [hli], a
	ldh a, [hff9a]
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
	ld [hl], $ff
	ret

EnableStatInterrupt:
	xor a ; clear pending interrupts
	ldh [rIF], a

	; enable Stat interrupt
	ldh a, [rIE]
	set B_IE_STAT, a
	ldh [rIE], a

	; set LY compare flag
	ldh a, [rSTAT]
	or STAT_LYC
	ldh [rSTAT], a
	ret
; 0x523

SECTION "_Timer", ROM0[$52d]

_Timer:
	reti

_Serial:
	reti

	reti ; stray ret

Func_530:
	call Func_434
	call Func_cfe
	call ReadJoypad

	ld a, [wResetDisabled]
	and a
	ret nz ; reset disabled
	ld hl, wResetDelay
	ld a, [wJoypadDown]
	and PAD_BUTTONS
	cp PAD_A | PAD_B | PAD_SELECT | PAD_START
	jr nz, .reset_delay
	dec [hl]
	ret nz

	; reset game, show all black
	; only reset when buttons are released
	ld hl, Pals_ed5
	lddmgpal c, SHADE_BLACK, SHADE_BLACK, SHADE_BLACK, SHADE_BLACK
	call Func_cc9
	call Func_f41
.wait_buttons_release
	do_frame
	call ReadJoypad
	ld a, [wJoypadDown]
	and PAD_BUTTONS
	cp PAD_A | PAD_B | PAD_SELECT | PAD_START
	jr z, .wait_buttons_release
	jp Reset
.reset_delay
	ld [hl], 5 ; wResetDelay
	ret

ReadJoypad:
	; poll directional pad
	ld a, JOYP_GET_CTRL_PAD
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOYP_INPUTS
	swap a
	ld b, a

	; poll buttons
	ld a, JOYP_GET_BUTTONS
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOYP_INPUTS
	or b
	ld c, a

	ld a, JOYP_GET_NONE
	ldh [rJOYP], a
	ld a, [wJoypadDown]
	xor c
	and c
	ld [wJoypadPressed], a
	ld a, c
	ld [wJoypadDown], a
	ret

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
	jp Func_62b

.Func_5f1:
	ld h, d
	ld l, e
	ld de, v0Tiles2
	call Func_62b
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
	jp SafeCopyHLToDE ; useless jump

SafeCopyHLToDE:
.loop
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
	jr nz, .loop
	ret

Func_62b:
	ld bc, $12
	add hl, bc
	scf
	ld a, [hli]
	adc a ; *2 + 1
	add a ; *6
	jp Decompress.asm_6ce

; the decompression algorithm is pretty complex
; it seems to obfuscate the way that command bits
; are processed and how bytes are copied literally or from lookback
Decompress:
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
	; will copy b*2^4 = 16*b bytes
	ld c, 4
.loop_get_long_copy_count
	add a
	jr z, .asm_646
.asm_64f
	rl b
	dec c
	jr nz, .loop_get_long_copy_count
	; copies 2*(3 + b) bytes
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
	jr .asm_6ce

.asm_669
	ld a, [hli]
	adc a
	jr c, .asm_6e6
.asm_66d
	add a
	jr z, .asm_636
.asm_670
	rl c
	add a
	jr z, .asm_63a
.asm_675
	jr nc, .asm_686
	add a
	jr z, .asm_63e
.asm_67a
	dec c
	push hl
	ld h, a
	ld a, c
	adc a
	ld c, a
	cp $09
	ld a, h
	pop hl
	jr z, .copy_long
.asm_686
	add a
	jr z, .asm_642
.asm_689
	jr nc, .lookback
	add a
	jr nz, .asm_690
	ld a, [hli]
	adc a
.asm_690
	rl b
	add a
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
	jr .asm_6ce
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
.asm_6ce
	add a
	jr c, .asm_6dc
	; copy byte
	push af
	call Func_d3
	ld a, [hli]
	ld [de], a
	inc de
	pop af
	add a
	jr nc, .copy_byte
.asm_6dc
	jr z, .asm_6c2

.asm_6de
	lb bc, 0, 2
	add a
	jr z, .asm_669
	jr nc, .asm_66d
.asm_6e6
	add a
	jr z, .asm_711
.asm_6e9
	jr nc, .lookback
	inc c
	add a
	jr z, .asm_715
.asm_6ef
	jr nc, .asm_686
	ld c, [hl]
	inc hl
	inc c
	dec c
	jr z, .asm_719
	push af
	ld a, c
	add $08
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
	jr c, .asm_6ce
	ret

Func_721:
	ld hl, wVirtualOAM
	ld bc, $400
;	fallthrough

; clears bc bytes starting from hl
ClearMemory:
	xor a
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
; 0x733

SECTION "Func_7ab", ROM0[$7ab]

Func_7ab:
	ld hl, .Data
	ld de, wc575
	ld b, $04
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

.Data:
	db $ff, $80, $26, $37
; 0x7be

SECTION "ClearBGMap", ROM0[$9cf]

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
; 0xa03

SECTION "EnableDoubleSpeed", ROM0[$c87]

EnableDoubleSpeed:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	ret nz ; not CGB
	ld hl, rSPD
	bit B_SPD_DOUBLE, [hl]
	ret nz ; already enabled
	set B_SPD_PREPARE, [hl]
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ld a, JOYP_GET_NONE
	ldh [rJOYP], a
	stop
	ret
; 0xca0

SECTION "Func_cc2", ROM0[$cc2]

Func_cc2:
	lddmgpal c, SHADE_WHITE, SHADE_LIGHT, SHADE_DARK, SHADE_BLACK
	ld hl, Pals_ec5
	jr Func_cc9 ; useless jump

Func_cc9:
	xor a
	ld [wc67d], a
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .gb
	ld c, 8 + 8 ; num of palettes for BG and OB
	ld de, wCGBPals
.loop_copy_pals
	push hl
	ld b, PAL_SIZE
.loop_copy_pal
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop_copy_pal
	pop hl
	dec c
	jr nz, .loop_copy_pals
	jp ApplyCGBPalettes

.gb
	ld a, c
	ld hl, wDMGPals
	ld [hli], a ; wBGP
	ld [hli], a ; wOBP0
	ld [hl], a  ; wOBP1
	jp ApplyDMGPalettes

Func_cf2:
	ld [wc67f], a
	ld [wc67e], a
	ld a, $01
	ld [wc67d], a
	ret

Func_cfe:
	ld a, [wc67d]
	and a
	ret z
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb
	ld hl, wc67e
	dec [hl]
	ret nz
	ld a, [wc67f]
	ld [hl], a
	ld hl, wDMGPals
	ld de, wc5fd
	ld b, $03
	call Func_de7
	ld [wc67d], a
	jp ApplyDMGPalettes

.cgb
	ld a, [wc67f]
	ld b, a
.asm_d27
	push bc
	call .Func_d38
	pop bc
	and a
	jr z, .asm_d32
	dec b
	jr nz, .asm_d27
.asm_d32
	ld [wc67d], a
	jp ApplyCGBPalettes

.Func_d38:
	ld hl, wCGBPals
	ld de, wc5fd
	ld b, $40
	jp Func_d43 ; useless jump

Func_d43:
	xor a
	ld [wc680], a
.asm_d47
	push bc
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	push hl
	push de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	cp l
	jr z, .asm_d71
	and $1f
	ld e, a
	ld a, l
	and $1f
	cp e
	jr z, .asm_d71
	jr c, .asm_d65
	dec a
	jr .asm_d66
.asm_d65
	inc a
.asm_d66
	ld e, a
	ld a, l
	and $e0
	or e
	ld l, a
	ld a, $01
	ld [wc680], a
.asm_d71
	ld a, l
	rlca
	rlca
	rlca
	and $07
	ld e, a
	ld a, h
	and $03
	add a
	add a
	add a
	or e
	ld e, a
	ld a, c
	rlca
	rlca
	rlca
	and $07
	ld d, a
	ld a, b
	and $03
	add a
	add a
	add a
	or d
	cp e
	jr z, .asm_db6
	jr c, .asm_d97
	ld a, e
	inc a
	jr .asm_d99
.asm_d97
	ld a, e
	dec a
.asm_d99
	ld e, a
	rrca
	rrca
	rrca
	and $03
	ld d, a
	ld a, h
	and $fc
	or d
	ld h, a
	ld a, e
	rrca
	rrca
	rrca
	and $e0
	ld d, a
	ld a, l
	and $1f
	or d
	ld l, a
	ld a, $01
	ld [wc680], a
.asm_db6
	ld a, b
	cp h
	jr z, .asm_dd6
	and $7c
	ld e, a
	ld a, h
	and $7c
	cp e
	jr z, .asm_dd6
	jr c, .asm_dc9
	sub $04
	jr .asm_dcb
.asm_dc9
	add $04
.asm_dcb
	ld e, a
	ld a, h
	and $03
	or e
	ld h, a
	ld a, $01
	ld [wc680], a
.asm_dd6
	ld b, h
	ld c, l
	pop de
	pop hl
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	pop bc
	dec b
	jp nz, .asm_d47
	ld a, [wc680]
	ret

Func_de7:
	ld c, $00
.asm_de9
	ld a, [de]
	cp [hl]
	jr z, .asm_e1c
	ld c, $01
	push bc
	push de
	push hl
	ld c, [hl]
	ld b, a
	ld d, $03
	ld e, $01
.asm_df8
	ld a, b
	and d
	ld l, a
	ld a, c
	and d
	cp l
	jr z, .asm_e0c
	jr c, .asm_e05
	sub e
	jr .asm_e06
.asm_e05
	add e
.asm_e06
	ld l, a
	ld a, d
	cpl
	and c
	or l
	ld c, a
.asm_e0c
	ld a, e
	add a
	add a
	jr c, .asm_e18
	ld e, a
	ld a, d
	add a
	add a
	ld d, a
	jr .asm_df8
.asm_e18
	pop hl
	ld [hl], c
	pop de
	pop bc
.asm_e1c
	inc hl
	inc de
	dec b
	jr nz, .asm_de9
	ld a, c
	ret

ApplyCGBPalettes:
	ld hl, wCGBPals
	; hl = wBGPals
	ld a, BGPI_AUTOINC
	ldh [rBGPI], a
	ld c, LOW(rBGPD)
	call .CopyPals
	; hl = wOBPals
	ld a, OBPI_AUTOINC
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
.CopyPals
	ld b, 8 ; num palettes
.loop_copy_pals
	call SafeCopyPalette
	dec b
	jr nz, .loop_copy_pals
	ret

ApplyDMGPalettes:
	ldh a, [rLCDC]
	rlca
	jr nc, .asm_e4f
	wait_ppu
.asm_e4f
	ld hl, wDMGPals
	ld a, [hli]
	ldh [rBGP], a
	ld a, [hli]
	ldh [rOBP0], a
	ld a, [hl]
	ldh [rOBP1], a
	ret
; 0xe5c

SECTION "SafeCopyPalette", ROM0[$e8a]

; input:
; - c = LOW(rBGPD) or LOW(rOBPD)
SafeCopyPalette:
	ldh a, [rLCDC]
	rlca
	jr nc, .copy_1
	wait_ppu
.copy_1
REPT PAL_SIZE / 2
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	ldh a, [rLCDC]
	rlca
	jr nc, .copy_2
	wait_ppu
.copy_2
REPT PAL_SIZE / 2
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	ret
; 0xebd

SECTION "Pals_ec5", ROM0[$ec5]

Pals_ec5:
	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  0,  0,  0

Pals_ecd:
	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 31, 31, 31

Pals_ed5:
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0,  0,  0
; 0xedd

SECTION "Func_f41", ROM0[$f41]

Func_f41:
	push af
	push bc
	push de
	push hl
	ld b, $02
	call Func_f4f
	pop hl
	pop de
	pop bc
	pop af
	ret

Func_f4f:
	ld hl, wc547
	ld a, [hl]
	cp $10
	ret z
	xor a
	ld [wc546], a
	inc [hl]
	ld hl, wc548
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld a, l
	ld [wc548 + 0], a
	ld a, h
	ld [wc548 + 1], a
	ld a, $01
	ld [wc546], a
	ret

Func_f73:
	ld de, wc54a
	ld hl, wc548
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld [wc547], a
	ret

Func_f81:
	ld a, [wc546]
	and a
	jr z, .asm_fad
	ld a, [wc547]
	and a
	jr z, .asm_fad
	ld hl, wc54a
	ld b, a
.asm_f91
	push bc
	ld a, [hli]
	ld c, [hl]
	push hl
	ld de, .return
	push de
	jumptable
	dw Func_fba
	dw Func_fd3
	dw Func_1009
	dw Func_1010
	dw Func_101e
.return
	pop hl
	pop bc
	inc hl
	dec b
	jr nz, .asm_f91
	call Func_f73
.asm_fad
	ld a, [wc540]
	and a
	ret z
	bankswitch
	jp $4003

Func_fba:
	ld a, [wc540]
	and a
	jr nz, .asm_fc7
	push bc
	ld c, $3e
	call Func_102c
	pop bc
.asm_fc7
	ld a, [wc540]
	bankswitch
	ld a, c
	jp $400c

Func_fd3:
	push bc
	call Func_1069
	pop bc
	ld a, c
	ld [wc542], a
	and a
	ret z
	ld hl, $edf
	add a
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [wc540]
	cp c
	jr z, .asm_ff9
	and a
	jr z, .asm_ff4
	push bc
	call Func_1045
	pop bc
.asm_ff4
	push bc
	call Func_102c
	pop bc
.asm_ff9
	ld a, [wc540]
	bankswitch
	ld a, b
	ld [wc541], a
	dec a
	jp $400c

Func_1009:
	xor a
	ld [wc542], a
	jp Func_1058

Func_1010:
	ld a, [wc540]
	and a
	ret z
	bankswitch
	ld a, c
	jp $400f

Func_101e:
	ld a, [wc540]
	and a
	ret z
	bankswitch
	ld a, c
	jp $4015

Func_102c:
	ld a, c
	ld [wc540], a
	ld a, c
	bankswitch
	push bc
	call $4000
	pop bc
	ld a, c
	sub $3e
	ld hl, $edd
	get_pointer
	jp $4006

Func_1045:
	call Func_1058
	ld hl, wc540
	ld a, [hl]
	ld [hl], $00
	and a
	ret z
	bankswitch
	jp $4003

Func_1058:
	ld a, [wc540]
	and a
	ret z
	bankswitch
	xor a
	ld [wc541], a
	jp $4012

Func_1069:
	ld a, [wc540]
	and a
	ret z
	ld hl, wc541
	ld b, [hl]
	ld [hl], $00
	ld a, b
	and a
	ret z
	ld a, [wc540]
	bankswitch
	ld a, b
	dec a
	jp $400f

Func_1084:
	xor a
	ld [wc546], a
	ld [wc540], a
	ld [wc541], a
	jp Func_f73
; 0x1091

SECTION "Func_15bb", ROM0[$15bb]

Func_15bb:

SECTION "Func_1cb9", ROM0[$1cb9]

Func_1cb9:

