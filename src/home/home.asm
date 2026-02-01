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
	call ShowCompanies
	call SetRNGSeed
	call Func_1cb9
	call Func_15bb
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
	ld bc, $1000
	call ClearMemory

	; clear WRAMX
	ld b, 7 ; num of WRAMX banks
.loop_clear_wramx
	push bc
	ld a, b
	wramswitch
	ld hl, STARTOF(WRAMX)
	ld bc, $1000
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
	ld bc, SIZEOF(WRAM0)
	jp ClearMemory

Func_1b5:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .gb
	ld a, BANK("VRAM0")
	vramswitch
	ld a, BANK("WRAM")
	wramswitch
.gb
	xor a
	ld [wc56e], a
	
	ld a, HIGH(wVirtualOAM1)
	ld [wActiveVirtualOAM], a
	ld a, HIGH(wVirtualOAM3)
	ld [wBufferedVirtualOAM], a

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
	jp ClearVirtualOAM

ShowCompanies:
	call EmptyScreen

	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb

; gb
	ld a, $00
	call LoadScene
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

	homecall CheckSkipCompanies
	ret nz ; skip

	ld a, $06
	ld b, 60
	ld c, 60
	call .Func_254
	ld a, $05
	ld b, 60
	ld c, 60
	call .Func_254
	ld a, $07
	ld b, 60
	ld c, 60
	call .Func_254
	ld a, $08
	ld b, 60
	ld c, 60
	call .Func_254
	ld a, $03
	ld b, 60
	ld c, 60
	call .Func_254
	ret

.Func_254:
	push bc
	call LoadScene
	pop bc
	jp ShowScene

LoadScene::
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *16
	ld de, Data_33a
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

ShowScene::
.loop_show
	push bc
	call Func_501
	call Func_530
	pop bc
	ld a, c
	and a
	jr nz, .decrement_input_delay
	ld a, [wJoypadPressed]
	and PAD_A | PAD_START
	jr nz, .next_screen
	jr .decrement_screen_delay
.decrement_input_delay
	dec c
.decrement_screen_delay
	dec b
	jr nz, .loop_show

.next_screen
	call Func_2ca
.asm_2bd
	call Func_501
	call Func_530
	ld a, [wc67d]
	and a
	jr nz, .asm_2bd
	ret

Func_2ca::
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
	ld de, Pals_White
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

SECTION "EmptyScreen", ROM0[$320]

; clears OAM, BG map and sets all palettes to white
EmptyScreen::
	xor a
	ldh [hff9a], a
	ldh [hff9b], a

	; fill palettes with white
	lddmgpal c, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE
	ld hl, Pals_White
	call FillPalettes

	call ClearVirtualOAM
	jp ClearBGMap

Func_333:
	ldh a, [hff99]
	or LCDC_BG_ON | LCDC_ON
	ldh [rLCDC], a
	ret

Data_33a:
	dmgpal SHADE_WHITE, SHADE_LIGHT, SHADE_DARK, SHADE_BLACK ; BGP (dgm only)
	dbw $00, NULL  ; BG palettes (CGB only)
	dbw $34, $68dd ; tiles VRAM0
	dbw $34, $6b3c ; BG map
	dbw $00, NULL  ; tiles VRAM1 (CGB only)
	dbw $00, NULL  ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $34, $6c17 ; BG palettes (CGB only)
	dbw $34, $6c57 ; tiles VRAM0
	dbw $34, $7407 ; BG map
	dbw $32, $7fd0 ; tiles VRAM1 (CGB only)
	dbw $34, $7543 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $34, $7567 ; BG palettes (CGB only)
	dbw $34, $75a7 ; tiles VRAM0
	dbw $34, $7cb4 ; BG map
	dbw $34, $7ddd ; tiles VRAM1 (CGB only)
	dbw $34, $7e06 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $34, $7e68 ; BG palettes (CGB only)
	dbw $35, $4000 ; tiles VRAM0
	dbw $34, $7ea8 ; BG map
	dbw $35, $47f7 ; tiles VRAM1 (CGB only)
	dbw $35, $4820 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $35, $4857 ; BG palettes (CGB only)
	dbw $35, $4897 ; tiles VRAM0
	dbw $35, $4c9d ; BG map
	dbw $35, $4d7b ; tiles VRAM1 (CGB only)
	dbw $35, $4da4 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $35, $4dcb ; BG palettes (CGB only)
	dbw $35, $4e0b ; tiles VRAM0
	dbw $35, $5086 ; BG map
	dbw $35, $511e ; tiles VRAM1 (CGB only)
	dbw $34, $7fda ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $35, $5147 ; BG palettes (CGB only)
	dbw $35, $5187 ; tiles VRAM0
	dbw $35, $5284 ; BG map
	dbw $35, $52c9 ; tiles VRAM1 (CGB only)
	dbw $35, $52f2 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $35, $61a4 ; BG palettes (CGB only)
	dbw $35, $61e4 ; tiles VRAM0
	dbw $35, $6994 ; BG map
	dbw $35, $6ad0 ; tiles VRAM1 (CGB only)
	dbw $35, $6af9 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $35, $589f ; BG palettes (CGB only)
	dbw $35, $58df ; tiles VRAM0
	dbw $35, $5ff0 ; BG map
	dbw $35, $6119 ; tiles VRAM1 (CGB only)
	dbw $35, $6142 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dbw $35, $5315 ; BG palettes (CGB only)
	dbw $35, $5355 ; tiles VRAM0
	dbw $35, $5770 ; BG map
	dbw $35, $584f ; tiles VRAM1 (CGB only)
	dbw $35, $5878 ; tile attributes (CGB only)

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
	; we take value in wBufferedVirtualOAM
	; which was just swapped with wActiveVirtualOAM
	ld a, [wBufferedVirtualOAM]
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
	; swap wActiveVirtualOAM and wBufferedVirtualOAM
	ld hl, wBufferedVirtualOAM
	ld de, wActiveVirtualOAM
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

Func_530::
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
	ld hl, Pals_Black
	lddmgpal c, SHADE_BLACK, SHADE_BLACK, SHADE_BLACK, SHADE_BLACK
	call FillPalettes
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

ClearVirtualOAM:
	ld hl, STARTOF("WRAM Virtual OAM")
	ld bc, SIZEOF("WRAM Virtual OAM")
;	fallthrough

; clears bc bytes starting from hl
ClearMemory::
	xor a
FillMemory:
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

Func_733:
.asm_733
	push bc
	call Func_73c
	pop bc
	dec b
	jr nz, .asm_733
	ret

Func_73c:
	ld b, $10
	call SafeCopyRow
	ld a, [wd7f7]
	inc a
	ld [wd7f7], a
	ld a, e
	and a
	ret nz
	inc d
	ret

Func_74d:
	bit 7, h
	ret z
	push af
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	pop af
	ret

Func_75a:
	push af
	ld a, l
	sub e
	ld l, a
	ld a, h
	jr nc, .asm_762
	dec h
.asm_762
	ld a, h
	sub d
	ld h, a
	pop af
	ret

Func_767:
	push af
	ld a, l
	sub c
	ld l, a
	ld a, h
	jr nc, .asm_76f
	dec h
.asm_76f
	ld a, h
	sub b
	ld h, a
	pop af
	ret

Random::
	push hl
	ld a, [wRNG]
	and $48
	adc $38
	sla a
	sla a
	ld hl, wRNG + $3
	rl [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	dec hl
	rl [hl]
	ld a, [hl]
	pop hl
	ret
; 0x791

SECTION "SetRNGSeed", ROM0[$7ab]

; initialises wRNG with a seed
SetRNGSeed:
	ld hl, .Seed
	ld de, wRNG
	ld b, $4
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

.Seed:
	db $ff, $80, $26, $37
; 0x7be

SECTION "Func_7d5", ROM0[$7d5]

Func_7d5:
	push bc
	push hl
	ld hl, wd771
	ld bc, $1000
.asm_7dd
	ld [hl], c
	inc hl
	dec b
	jr nz, .asm_7dd
	pop hl
	pop bc
	and a
	jr nz, .asm_802
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.asm_7f0
	push bc
	call Func_73c
	call Func_81d
	pop bc
	dec b
	jr nz, .asm_7f0
	pop af
	bankswitch
	ret
.asm_802
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.asm_80b
	push bc
	call Func_81d
	call Func_73c
	pop bc
	dec b
	jr nz, .asm_80b
	pop af
	bankswitch
	ret

Func_81d:
	push hl
	ld hl, wd771
	call Func_73c
	pop hl
	ret

Func_826:
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	call Func_733
	pop af
	bankswitch
	ret

Func_839:
	call CoordinateToBGMapPtr
Func_83c::
	; swap hl and de
	push de
	ld e, l
	ld d, h
	pop hl

	ld a, c
	add a ; *2
	cp b
	jr c, .asm_854
.asm_845
	push bc
	push de
	ld b, c
	call SafeCopyRow
	pop de
	pop bc
	; next row
	ld a, TILEMAP_WIDTH
	add_de
	dec b
	jr nz, .asm_845
	ret
.asm_854
	push bc
	push de
	call SafeCopyColumn
	pop de
	pop bc
	inc e
	dec c
	jr nz, .asm_854
	ret

SafeCopyColumn:
	; CGB can copy 6 bytes
	ld c, 6
	ldh a, [hBootUpA]
	cp $11
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

SafeCopyRow:
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
; 0xa03

SECTION "CoordinateToBGMapPtr", ROM0[$a0f]

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

Func_a1e::
	ld hl, wd7f1
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret
; 0xa29

SECTION "Func_a95", ROM0[$a95]

Func_a95::
	ld [wd7f8], a
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	ld a, b
	ld hl, wd7f1
	add_hl
	ld c, [hl]
	push hl
	ld hl, $b31
	ld a, b
	cp $03
	jr c, .asm_ab9
	ld a, $01
	vramswitch
	ld a, b
	sub $03
.asm_ab9
	add_hl
	ld h, [hl]
	ld l, $00
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ld a, l
	ld l, e
	ld e, a
	ld a, h
	ld h, d
	ld d, a
	ld a, [wd7f8]
	ld b, a
	call Func_733
	pop hl
	ld a, [wd7f8]
	add [hl]
	ld [hl], a
	ldh a, [hBootUpA]
	cp $11
	jr nz, .asm_aef
	ld a, $00
	vramswitch
.asm_aef
	pop af
	bankswitch
	ret

Func_af6::
	ld c, a
	ldh a, [hROMBank]
	push af
	push bc
	ld hl, wd771
	ld bc, DoFrame
	call ClearMemory
	pop bc
.asm_b05
	push bc
	ld de, wd771
	ld c, $01
	ld a, $01
	call Func_a95
	pop bc
	dec c
	jr nz, .asm_b05
	pop af
	bankswitch
	ret

Func_b1b::
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.asm_b24
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_b24
	pop af
	bankswitch
	ret
; 0xb31

SECTION "Func_c28", ROM0[$c28]

Func_c28::
	ld a, d
	cp e
	jr c, Func_c2e
	ld a, e
	ld e, d
Func_c2e:
	push hl
	ld d, $00
	ld h, d
	ld l, d
.asm_c33
	srl a
	jr nc, .asm_c38
	add hl, de
.asm_c38
	sla e
	rl d
	and a
	jr nz, .asm_c33
	ld d, h
	ld e, l
	pop hl
	ret

Func_c43:
	cp $02
	jr c, .asm_c4a
	ld e, a
	jr Func_c2e
.asm_c4a
	ld e, a
	ld d, $00
	ret

Func_c4e:
	push bc
	push hl
	ld hl, $4000
	ld b, l
	ld c, l
.asm_c55
	push hl
	add hl, bc
	srl b
	rr c
	ld a, d
	cp h
	jr nz, .asm_c61
	ld a, e
	cp l
.asm_c61
	jr c, .asm_c76
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, c
	or l
	ld c, a
	ld a, b
	or h
	ld b, a
	jr .asm_c77
.asm_c76
	pop hl
.asm_c77
	srl h
	rr l
	srl h
	rr l
	ld a, h
	or l
	jr nz, .asm_c55
	ld a, c
	pop hl
	pop bc
	ret

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
	jr FillPalettes ; useless jump

; fills BG/OB palettes with palette
; given by c (DMG) or pointed by hl (CGB)
; input:
; - c  = BG and OB palettes for DMG
; - hl = BG and OB palettes for CGB
FillPalettes:
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
	jp FluchCGBPalettes

.gb
	ld a, c
	ld hl, wDMGPals
	ld [hli], a ; wBGP
	ld [hli], a ; wOBP0
	ld [hl], a  ; wOBP1
	jp FlushDMGPalettes

Func_cf2::
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
	jp FlushDMGPalettes

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
	jp FluchCGBPalettes

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

FluchCGBPalettes:
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

FlushDMGPalettes:
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

Pals_White:
	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 31, 31, 31

Pals_Black:
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0,  0,  0

PtrTable_edd:
	dw Data_f8cf4 ; "Audio 1"
	dw $4cf4      ; "Audio 2"

Data_ee1:
	db $3e, $01
	db $3e, $02
	db $3e, $03
	db $3e, $04
	db $3e, $05
	db $3f, $01
	db $3f, $02
	db $3f, $03

Func_ef1:
	ld b, $04
	ld c, a
	jp Func_f4f

Func_ef7::
	and a
	ret z
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc544]
	and a
	jr z, .asm_f08
	ld b, $00
	call Func_f4f
.asm_f08
	pop hl
	pop de
	pop bc
	ret

Func_f0c::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc544]
	and a
	jr z, .asm_f1b
	ld b, $03
	call Func_f4f
.asm_f1b
	pop hl
	pop de
	pop bc
	ret
; 0xf1f

SECTION "Func_f27", ROM0[$f27]

Func_f27::
	push hl
	ld hl, wc541
	cp [hl]
	pop hl
	ret z
Func_f2e::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc545]
	and a
	jr z, .asm_f3d
	ld b, $01
	call Func_f4f
.asm_f3d
	pop hl
	pop de
	pop bc
	ret

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

; input:
; - b = ?
; - c = ?
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
	dw Func_fba  ; $0
	dw Func_fd3  ; $1
	dw Func_1009 ; $2
	dw Func_1010 ; $3
	dw Func_101e ; $4
.return
	pop hl
	pop bc
	inc hl
	dec b
	jr nz, .asm_f91
	call Func_f73
.asm_fad
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	jp Func_f8003

Func_fba:
	ld a, [wAudioBank]
	and a
	jr nz, .asm_fc7
	push bc
	ld c, BANK("Audio 1")
	call Func_102c
	pop bc
.asm_fc7
	ld a, [wAudioBank]
	bankswitch
	ld a, c
	jp Func_f800c

Func_fd3:
	push bc
	call Func_1069
	pop bc
	ld a, c
	ld [wc542], a
	and a
	ret z
	ld hl, Data_ee1 - $2
	add a
	add_hl
	ld c, [hl] ; bank
	inc hl
	ld b, [hl] ; ?
	ld a, [wAudioBank]
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
	ld a, [wAudioBank]
	bankswitch
	ld a, b
	ld [wc541], a
	dec a
	jp Func_f800c

Func_1009:
	xor a
	ld [wc542], a
	jp Func_1058

Func_1010:
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	ld a, c
	jp Func_f800f

Func_101e:
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	ld a, c
	jp Func_f8015

Func_102c:
	ld a, c
	ld [wAudioBank], a
	ld a, c
	bankswitch
	push bc
	call InitAudio
	pop bc
	ld a, c
	sub BANK("Audio 1")
	ld hl, PtrTable_edd
	get_pointer
	jp Func_f8006

Func_1045:
	call Func_1058
	ld hl, wAudioBank
	ld a, [hl]
	ld [hl], $00
	and a
	ret z
	bankswitch
	jp Func_f8003

Func_1058:
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	xor a
	ld [wc541], a
	jp Func_f8012

Func_1069:
	ld a, [wAudioBank]
	and a
	ret z
	ld hl, wc541
	ld b, [hl]
	ld [hl], $00
	ld a, b
	and a
	ret z
	ld a, [wAudioBank]
	bankswitch
	ld a, b
	dec a
	jp Func_f800f

Func_1084:
	xor a
	ld [wc546], a
	ld [wAudioBank], a
	ld [wc541], a
	jp Func_f73

GetEntityWordField_BC::
	push hl
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ret

SetEntityWordField_BC::
	push hl
	add_hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	ret

Func_109f:
	ld a, c
	add [hl]
	ld [hli], a
	ld a, b
	jr nc, .asm_10a6
	inc a
.asm_10a6
	add [hl]
	ld [hld], a
	ret

AddEntityWordField_BC:
	push hl
	add_hl
	call Func_109f
	pop hl
	ret

Func_10b0:
	ld a, e
	add [hl]
	ld [hli], a
	ld a, d
	jr nc, .asm_10b7
	inc a
.asm_10b7
	add [hl]
	ld [hld], a
	ret

AddEntityWordField_DE::
	push hl
	add_hl
	call Func_10b0
	pop hl
	ret
; 0x10c1

SECTION "GetEntityWordField_DE", ROM0[$10d0]

GetEntityWordField_DE:
	push hl
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret

SetEntityWordField_DE::
	push hl
	add_hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ret

GetEntityByteField_A::
	push hl
	add_hl
	ld a, [hl]
	pop hl
	ret

GetEntityByteField_C::
	push hl
	add_hl
	ld c, [hl]
	pop hl
	ret

GetEntityByteField_B::
	push hl
	add_hl
	ld b, [hl]
	pop hl
	ret

GetEntityByteField_E::
	push hl
	add_hl
	ld e, [hl]
	pop hl
	ret

GetEntityByteField_D::
	push hl
	add_hl
	ld d, [hl]
	pop hl
	ret

SetEntityByteField_C::
	push hl
	add_hl
	ld [hl], c
	pop hl
	ret
; 0x10fc

SECTION "Func_110b", ROM0[$110b]

Func_110b::
	ld hl, wd551
	ld bc, $220
	call ClearMemory
	ld a, TRUE
	ld [wd54c], a
	ld [wd54d], a
	xor a
	ld hl, wd54e
	ld [hli], a
	ld [hli], a ; wd54f
	ld [hl], a
	ret

Func_1124::
	push hl
	push bc
	ld hl, wd551
	ld de, $11
	ld b, $20
.asm_112e
	bit 0, [hl]
	jr z, .asm_113a
	add hl, de
	dec b
	jr nz, .asm_112e
	pop bc
	pop hl
	scf
	ret
.asm_113a
	ld [hl], $01
	ld d, h
	ld e, l
	pop bc
	pop hl
	and a
	ret

Func_1142::
	xor a
	ld [wd7f7], a
	ret

Func_1147:
	ld a, [wd54d]
	and a
	ret z

	call ClearSprites

	ld a, [wd54c]
	and a
	jr z, .asm_116d

	ld hl, wd551
	ld b, $20
.asm_115a
	ld a, [hl]
	and $03
	cp $03
	jr nz, .asm_1166
	push bc
	call Func_1186
	pop bc
.asm_1166
	ld de, $11
	add hl, de
	dec b
	jr nz, .asm_115a

.asm_116d
	ld a, [wd54e]
	and a
	jr z, .load_sprites
	bankswitch
	ld hl, wd54f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call_hl
.load_sprites
	jp LoadSprites

Func_1186:
	push hl
	ld a, [hli]
	ld [wd545], a
	inc hl
	and $04
	jr z, .asm_11e6
	ld d, h
	ld e, l
	ld hl, wd7fd
	ld a, [de]
	sub [hl]
	ld b, a
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jr z, .asm_11b3
	cp $ff
	jp nz, .asm_1242
	push de
	ld a, $04
	add_de
	ld a, [de]
	add b
	pop de
	jp nc, .asm_1242
	jp z, .asm_1242
	ld a, b
	jr .asm_11b9
.asm_11b3
	ld a, b
	cp $80
	jp nc, .asm_1242
.asm_11b9
	add $10
	ld b, a
	inc de
	inc de
	inc hl
	ld a, [de]
	sub [hl]
	ld c, a
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jr z, .asm_11da
	cp $ff
	jr nz, .asm_1242
	push de
	ld a, $02
	add_de
	ld a, [de]
	add c
	pop de
	jr nc, .asm_1242
	jr z, .asm_1242
	ld a, c
	jr .asm_11df
.asm_11da
	ld a, c
	cp $a0
	jr nc, .asm_1242
.asm_11df
	add $08
	ld c, a
	ld h, d
	ld l, e
	jr .asm_11f0
.asm_11e6
	ld a, [hli]
	add $10
	ld b, a
	inc hl
	inc hl
	ld a, [hli]
	add $08
	ld c, a
.asm_11f0
	inc hl
	ld a, [hli]
	swap a
	ld d, a
	ld a, [hli]
	rrca
	rrca
	ld e, a
	rrca
	ld [wd54b], a
	ld a, [wd545]
	and $80
	call nz, Func_1315
	ld a, [wd545]
	and $10
	jr z, .asm_120f
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_120f
	ld a, d
	cp $01
	jr nz, .asm_1219
	ld a, e
	cp $02
	jr z, .asm_1246
.asm_1219
	ld a, [wd545]
	and $60
	call nz, Func_1338
	xor a
	ld [wd548], a
.asm_1225
	ld a, b
	cp $90
	call c, Func_1293
	add $10
	ld b, a
	ld a, e
	add l
	ld l, a
	ld a, $00
	adc h
	ld h, a
	dec d
	jr nz, .asm_1225
	ld a, [wd548]
	and a
	jr z, .asm_1242
.asm_123e
	pop hl
	res 3, [hl]
	ret
.asm_1242
	pop hl
	set 3, [hl]
	ret
.asm_1246
	ld a, [wd545]
	and $04
	jr nz, .asm_125d
	ld a, b
	and a
	jr z, .asm_1242
	cp $a0
	jr nc, .asm_1242
	ld a, c
	and a
	jr z, .asm_1242
	cp $a8
	jr nc, .asm_1242
.asm_125d
	ld a, [hli]
	bit 0, a
	jr nz, .asm_123e
	ld e, a
	ld a, [wd545]
	and $60
	xor [hl]
	ld d, a
	ld a, b
	swap a
	and $0f
	add a
	add $01
	ld l, a
	ld a, $13
	adc $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	cp $14
	jr nc, .asm_123e
	inc [hl]
	inc hl
	add a
	add a
	add l
	ld l, a
	ld a, $00
	adc h
	ld h, a
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	jr .asm_123e

Func_1293:
	and a
	ret z
	push bc
	push de
	push hl
	ld d, h
	ld e, l
	swap a
	and $0f
	add a
	add $01
	ld l, a
	ld a, $13
	adc $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	ld [wd547], a
	ld a, c
	ld [wd546], a
	ld b, h
	ld c, l
	ld a, [hli]
	add a
	add a
	add l
	ld l, a
	ld a, $00
	adc h
	ld h, a
	ld a, [wd54b]
.asm_12c0
	push af
	ld a, [bc]
	cp $14
	jr z, .asm_12fe
	ld a, [wd546]
	and a
	jr z, .asm_12eb
	cp $a8
	jr nc, .asm_12eb
	ld a, $01
	ld [wd548], a
	ld a, [de]
	bit 0, a
	jr nz, .asm_12eb
	ld a, [wd547]
	ld [hli], a
	ld a, [wd546]
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	dec de
	ld a, [bc]
	inc a
	ld [bc], a
.asm_12eb
	inc de
	inc de
	ld a, [wd546]
	add $08
	ld [wd546], a
	pop af
	dec a
	jr nz, .asm_12c0
.asm_12f9
	pop hl
	pop de
	pop bc
	ld a, b
	ret
.asm_12fe
	pop af
	jr .asm_12f9
; 0x1301

SECTION "Func_1315", ROM0[$1315]

Func_1315:
	push bc
	push de
	push hl
	ld a, e
	cp $02
	jr z, .asm_1321
	ld a, c
	add $04
	ld c, a
.asm_1321
	ld a, b
	sub $04
	ld b, a
	ld de, $a70
	ld a, [wc57a]
	and $04
	jr z, .asm_1331
	ld d, $2b
.asm_1331
	call Func_139b
	pop hl
	pop de
	pop bc
	ret

Func_1338:
	push bc
	push de
	ld c, a
	and $20
	jr z, .asm_1364
	ld b, d
	push bc
	ld bc, wd771
	ld a, d
	ld d, $00
.asm_1347
	push af
	add hl, de
	ld d, e
	srl d
.asm_134c
	dec hl
	inc bc
	ld a, [hld]
	xor $20
	ld [bc], a
	dec bc
	ld a, [hl]
	ld [bc], a
	inc bc
	inc bc
	dec d
	jr nz, .asm_134c
	add hl, de
	pop af
	dec a
	jr nz, .asm_1347
	pop bc
	ld d, b
	ld hl, wd771
.asm_1364
	ld a, c
	and $40
	jr z, .asm_1390
	ld b, d
	dec b
	jr z, .asm_1375
	ld c, d
	ld d, $00
.asm_1370
	add hl, de
	dec b
	jr nz, .asm_1370
	ld d, c
.asm_1375
	ld bc, wd7b1
.asm_1378
	push de
	srl e
.asm_137b
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	xor $40
	ld [bc], a
	inc bc
	dec e
	jr nz, .asm_137b
	pop de
	ld a, e
	add a
	sub_hl
	dec d
	jr nz, .asm_1378
	ld hl, wd7b1
.asm_1390
	pop de
	pop bc
	ret

Func_1393::
	ld a, c
	add $08
	ld c, a
	ld a, b
	add $10
	ld b, a
Func_139b:
	ld a, b
	and a
	ret z
	cp $a0
	ret nc
	ld a, c
	and a
	ret z
	cp $a8
	ret nc
	ld a, b
	swap a
	and $0f
	add a
	add $01
	ld l, a
	ld a, $13
	adc $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	cp $14
	ret nc
	inc [hl]
	inc hl
	add a
	add a
	add l
	ld l, a
	ld a, $00
	adc h
	ld h, a
	ld [hl], b
	inc hl
	ld [hl], c
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	ret

; zeroes out wSprites
ClearSprites:
	ld hl, wSprites
	ld de, SPRITE_STRUCT_SIZE
	ld b, NUM_SPRITES
	xor a
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

; goes through wSprites and loads them into Virtual OAM
LoadSprites:
	ld a, [wActiveVirtualOAM]
	ld d, a
	ld e, 0
	ld hl, wSprites
	ld b, NUM_SPRITES
.loop_sprites
	ld a, [hl]
	and a
	jr nz, .asm_1401
.next_sprite
	ld a, SPRITE_STRUCT_SIZE
	add_hl
	dec b
	jr nz, .loop_sprites

	; clear rest of OAM
	ld a, OAM_SIZE
	sub e
	ld b, a
	ld h, d
	ld l, e
	inc h
	xor a
.loop_clear
	ld [hli], a
	ld [de], a
	inc e
	dec b
	jr nz, .loop_clear
	ret

.asm_1401
	push bc
	push hl
	ld c, e
	cp $0b
	jr nc, .asm_1416
	ld b, a
	call .LoadSprite
	ld e, c
	pop hl
	push hl
	inc d
	ld b, [hl]
	call .LoadSprite
	jr .check_overflow
.asm_1416
	cpl
	inc a
	add $14
	jr z, .asm_1422
	push af
	ld b, a
	call .LoadSprite
	pop af
.asm_1422
	ld b, a
	pop hl
	push hl
	ld a, $28
	add_hl
	ld a, $0a
	sub b
	ld b, a
	call .LoadSprite
	ld e, c
	pop hl
	push hl
	inc d
	call .Func_1441
.check_overflow
	pop hl
	pop bc
	ld a, e
	cp OAM_SIZE
	jr c, .no_overflow
; overflow, do not process any more
	ret
.no_overflow
	dec d
	jr .next_sprite

.Func_1441:
	ld b, $0a
;	fallthrough

; sprites are made up of multiple OAMs
; load sprite pointed by hl, with OAM count given in b
; input:
; - b =  OAM count
; - hl = OAM data
; - de = virtual OAM
.LoadSprite:
	inc hl
.loop_load_oam
	ld a, [hli] ; y
	ld [de], a
	inc e
	ld a, [hli] ; x
	ld [de], a
	inc e
	ld a, [hli] ; tile ID
	ld [de], a
	inc e
	ld a, [hli] ; attibutes
	ld [de], a
	inc e
	dec b
	jr nz, .loop_load_oam
	ret
; 0x1454

SECTION "Func_146c", ROM0[$146c]

Func_146c:
	push hl
	add_hl
	ld d, h
	ld e, l
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	pop hl
	inc de
	ld a, [de]
	bit 7, b
	jr z, .asm_1484
	ret c
	dec a
	ld [de], a
	ret
.asm_1484
	ret nc
	inc a
	ld [de], a
	ret

Func_1488::
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
	xor a
.loop
	ld [hl], a ; ENT_FLAGS
	add hl, de
	dec b
	jr nz, .loop
	ret

Func_1497::
	push bc
	push de
	ld c, a
	ld b, $20
	ld hl, wEntities
	ld de, $58
.asm_14a2
	bit 0, [hl]
	jr z, .asm_14b0
	ld a, $05
	add_hl
	ld a, c
	cp [hl]
	jr z, .asm_14b8
	ld a, $05
	sub_hl
.asm_14b0
	add hl, de
	dec b
	jr nz, .asm_14a2
	pop de
	pop bc
	and a
	ret
.asm_14b8
	pop de
	pop bc
	ld a, $05
	sub_hl
	scf
	ret

Func_14bf::
	ldh a, [hROMBank]
	push af
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit 0, [hl] ; ENT_FLAGS
	call nz, .Func_14da
	add hl, de
	dec b
	jr nz, .loop
	pop af
	bankswitch
	ret

.Func_14da:
	inc hl
	dec [hl] ; ENT_UNK01
	dec hl
	ret nz
	push bc
	push de
	push hl
	call Func_150b
	pop hl
	pop de
	pop bc
	ret

Func_14e8::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wEntityPtr + 0]
	ld e, a
	ld a, [wEntityPtr + 1]
	ld d, a
	inc de
	ld a, c
	ld [de], a ; ENT_UNK01
	inc de
	ldh a, [hROMBank]
	ld [de], a ; ENT_UNK02
	inc de
	ld hl, sp+$00
	ld a, l
	ld [de], a ; ENT_UNK03
	inc de     ;
	ld a, h    ;
	ld [de], a ;
	ld hl, wd217
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ret

Func_150b:
	ld a, l
	ld [wEntityPtr + 0], a
	ld a, h
	ld [wEntityPtr + 1], a
	inc hl
	inc hl
	ld a, [hli] ; ENT_UNK02
	bankswitch
	ld a, [hli] ; ENT_UNK03
	ld h, [hl]  ;
	ld l, a
	ld [wd217], sp
	ld sp, hl
	pop hl
	pop de
	pop bc
	ret
; 0x1526

SECTION "Func_1536", ROM0[$1536]

; input:
; - hl = ?
; - b  = ?
; - c  = ?
Func_1536::
	push hl
	ld a, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit 0, [hl] ; ENT_FLAGS
	jr z, .inactive
	add hl, de
	dec a
	jr nz, .loop
	pop hl
	scf
	ret

.inactive
	ld [hl], $01 ; ENT_FLAGS
	inc hl
	ld [hl], $01 ; ENT_UNK01
	inc hl
	ld [hl], c ; ENT_UNK02
	inc hl
	; loads ENT_UNK50 address to ENT_UNK03
	ld d, h
	ld e, l
	ld a, ENT_UNK50 - ENT_UNK03
	add_de
	ld [hl], e ; ENT_UNK03
	inc hl     ;
	ld [hl], d ;
	inc hl
	ld [hl], b ; ENT_UNK05
	ld a, (ENT_UNK56 + 1) - ENT_UNK05
	add_hl
	pop de ; input hl
	ld [hl], d ; ENT_UNK56
	dec hl     ;
	ld [hl], e ;
	ld de, -ENT_UNK56
	add hl, de
	and a
	ret

Func_1569::
	inc hl
	ld [hl], $01
	inc hl
	ld [hli], a
	push de
	ld d, h
	ld e, l
	ld a, $4d
	add_de
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $53
	add_hl
	pop de
	ld [hl], d
	dec hl
	ld [hl], e
	ret

Func_157f::
	bankswitch
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $58
	add_hl
	ld sp, hl
	ld h, d
	ld l, e
	jp hl
; 0x1591

SECTION "Func_1598", ROM0[$1598]

Func_1598::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, ENT_UNK06
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_15a5:
	ld a, c
	call Func_14e8
	ld a, b
	and a
.loop
	ret z
	xor a
	call Func_14e8
	dec b
	jr .loop

Func_15b3::
.loop
	ld bc, $ffff
	call Func_15a5
	jr .loop

Func_15bb:
	xor a
	ld [wResetDisabled], a

	call Func_1a12

	ld a, $02
	ld [wd823], a
	ld a, $00
	ld [wd822], a
	ld a, $05
	ld [wd81f], a
	ld a, $00
	ld [wdc38], a

	call Func_1692

.asm_15d9
	homecall Func_8ce1
	jr .asm_15ef
.asm_15e5
	homecall Func_8cff
.asm_15ef
	call Func_1692

	ld a, $02
	bankswitch
	call $50aa
	call Func_16a8
	ld a, $00
	ld [wd820], a
	ld a, $00
	ld [wd895], a
	xor a
	ld [wc57a], a
	ld [wc579], a
.asm_1610
	call Func_530
	ld a, [wd820]
	cp $03
	jr z, .asm_1669
	call Func_1142
	call Func_1c57
	call Func_1c7b
	ld a, [wc579]
	and a
	jr nz, .asm_164d
	call Func_14bf
	call Func_23d1
	call Func_332a
	ld a, $01
	bankswitch
	call $5471
	ld a, $01
	bankswitch
	call $642c
	call Func_1eee
	ld hl, wc57a
	inc [hl]
.asm_164d
	ld a, $02
	bankswitch
	call $4162
	ld a, $02
	bankswitch
	call $459d
	call Func_1a71
	call Func_1147
	jr .asm_1610
.asm_1669
	ld a, [wd81f]
	cp $06
	jr z, .asm_1684
	ld a, $00
	call Func_f2e
	ld hl, wc579
	ld a, [hl]
	and a
	jr z, .asm_1681
	xor a
	ld [hl], a
	call Func_ef1
.asm_1681
	call Func_f41
.asm_1684
	call Func_198f
	and a
	jp z, .asm_15ef
	dec a
	jp z, .asm_15e5
	jp .asm_15d9

Func_1692:
	ld a, [wdc38]
	cp $07
	ret c
	ld b, $02
	cp $0a
	jr c, .asm_16a0
	ld b, $06
.asm_16a0
	ld a, [wdc33]
	or b
	ld [wdc33], a
	ret

Func_16a8:
	xor a
	ld [wda9b], a
	ld [wda9c], a
	ld [wda97], a
	ld [wda98], a
	ld [wda99], a
	ld [wda82], a
	ld [wd837], a
	ld [wd838], a
	ld [wd839], a
	ld [wd83a], a
	ld [wd83b], a
	ld a, $01
	bankswitch
	call Func_16e2
	call Func_1b4e
	ld a, $01
	bankswitch
	call Func_178e
	ret

Func_16e2:
	ld a, [wd81f]
	jumptable
; 0x16e6

SECTION "Func_178e", ROM0[$178e]

Func_178e:
	ld a, [wd81f]
	jumptable
; 0x1792

SECTION "Func_198f", ROM0[$198f]

Func_198f:
	ld a, [wd81f]
	jumptable
; 0x1993

SECTION "Func_1a12", ROM0[$1a12]

Func_1a12:
	ld a, $00
	ld [wd826], a
	ld a, $00
	ld [wd827], a
	ret
; 0x1a1d

SECTION "Func_1a71", ROM0[$1a71]

Func_1a71:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_1b3d
	jr nc, .asm_1a85
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $08
	ld [hli], a
	ld a, $08
	ld [hli], a
.asm_1a85
	ld a, [wd895]
	cp $03
	jr c, .asm_1a9b
	ld a, [wd896]
	ld [hli], a
	ld a, [wd897]
	sub $08
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
	jr .asm_1aa6
.asm_1a9b
	ld a, [wd7ff]
	ld [hli], a
	ld a, [wd7fd]
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
.asm_1aa6
	ld a, [wd81f]
	cp $06
	jr z, .asm_1adf
	ld a, [wd8e5]
	cp $04
	jr nz, .asm_1ad2
	ld a, $80
	ld [hli], a
	ld a, [wd8e8]
	ld [hli], a
	ld a, [wd8ea]
	ld [hli], a
	ld a, $08
	ld [hli], a
	ld a, $88
	ld [hli], a
	ld a, [wd8e9]
	ld [hli], a
	ld a, [wd8ea]
	ld [hli], a
	ld a, $08
	ld [hli], a
	jr .asm_1adb
.asm_1ad2
	ld a, $80
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $08
	ld [hli], a
.asm_1adb
	ld a, $ff
	ld [hl], a
	ret
.asm_1adf
	ld a, $80
	ld [hli], a
	ld a, [wdc90]
	call Func_1b32
	ld [hli], a
	ld a, [wdc90]
	add $80
	ld [hli], a
	ld a, $08
	ld [hli], a
	ld a, [wdc90]
	and $07
	cpl
	inc a
	add $08
	add $80
	ld [hli], a
	ld a, [wdc90]
	add $08
	call Func_1b32
	ld [hli], a
	ld a, [wdc90]
	add $80
	ld [hli], a
	ld a, $08
	ld [hli], a
	ld a, [wdc90]
	and $07
	jr z, .asm_1adb
	cpl
	inc a
	add $08
	add $88
	ld [hli], a
	ld a, [wdc90]
	add $10
	call Func_1b32
	ld [hli], a
	ld a, [wdc90]
	add $80
	ld [hli], a
	ld a, $08
	ld [hli], a
	jr .asm_1adb

Func_1b32:
	rrca
	rrca
	rrca
	and $1f
	ld de, wdc95
	add_de
	ld a, [de]
	ret

Func_1b3d:
	ld a, [wd877]
	and a
	jr nz, .asm_1b4a
	ld a, [wd895]
	cp $03
	jr c, .asm_1b4c
.asm_1b4a
	scf
	ret
.asm_1b4c
	and a
	ret

Func_1b4e:
	call EmptyScreen
	call Func_a1e
	call Func_110b
	call Func_1488
	call Func_25e5
	call Func_3565
	call Func_1d16
	call Func_2026
	call Func_32fb
	ld a, $02
	bankswitch
	call $402b
	ld hl, $4988
	ld c, $01
	ld b, $03
	call Func_1536
	homecall Func_4000
	ld hl, $42e1
	ld c, $01
	ld b, $02
	call Func_1536
	ld a, [wda4a]
	ld e, a
	ld a, [wda4b]
	ld d, a
	ld a, $06
	call SetEntityWordField_DE
	xor a
	ld [wda76], a
	ld hl, $5f27
	ld c, $01
	ld b, $07
	call Func_1536
	ld hl, $5e97
	ld c, $01
	ld b, $08
	call Func_1536
	ld a, [wd81f]
	cp $06
	jr z, .asm_1bcb
	call Func_f41
	ld a, [wd823]
	ld hl, .Data
	add_hl
	ld a, [hl]
	call Func_f2e
.asm_1bcb
	ld a, $01
	jp Func_cf2

.Data:
	db $04, $06, $07
; 0x1bd3

SECTION "Func_1c57", ROM0[$1c57]

Func_1c57:
	ld a, [wJoypadDown]
	ld c, a
	ld a, [wc573]
	xor c
	and c
	ld [wc574], a
	ld a, c
	ld [wc573], a
	ld a, [wdc32]
	and $10
	ret z
	ld a, [wc67d]
	and a
	ret nz
	ld a, [wJoypadPressed]
	and PAD_SELECT
	call nz, Func_1fc7
	ret

Func_1c7b:
	ld a, [wd81f]
	cp $06
	ret z
	ld a, [wc67d]
	and a
	ret nz
	ld a, [wd820]
	cp $01
	ret nz
	ld a, [wc574]
	and PAD_START
	ret z
	ld a, [wc579]
	and a
	jr nz, .asm_1ca9
	ld hl, wd895
	ld a, [hl]
	cp $00
	ret nz
	ld [hl], $01
	ld a, $01
	ld [wc579], a
	jp Func_ef1
.asm_1ca9
	ld hl, wd895
	ld a, [hl]
	cp $03
	ret nz
	ld [hl], $07
	xor a
	ld [wc579], a
	jp Func_ef1

Func_1cb9:
	ld a, $00
	ld [wdc32], a
	ld a, $01
	ld [wdc33], a
	ld a, $00
	ld [wdc30], a
	ld a, $01
	ld [wdc31], a
	ld a, $01
	ld [wc544], a
	ld a, $01
	ld [wc545], a
	xor a
	ld [wdc38], a
	ld [wdc8e], a
	ld [wdc8f], a

	; fill wdc39 with $aa
	ld hl, wdc39
	ld b, $3f
	ld a, $aa
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret
; 0x1ced

SECTION "Func_1d16", ROM0[$1d16]

Func_1d16:
	ld hl, wda83
	ld b, $04
.asm_1d1b
	ld a, [hli]
	push bc
	ld b, $00
	call Func_1e38
	pop bc
	dec b
	jr nz, .asm_1d1b
	ld a, [wd826]
	ld b, $03
	call Func_1e38
	ld a, $01
	bankswitch
	ld hl, wd824
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	vramswitch
	ld b, $08
.asm_1d43
	push bc
	ld a, [hli]
	push hl
	add a
	ld c, a
	ld hl, wdbdb
	add_hl
	ld a, [wd7f4]
	ld [hli], a
	ld a, $08
	ld [hl], a
	ld a, c
	add a
	ld hl, $382c
	add_hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wd7f4]
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, v0Tiles0
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, [wd7f4]
	add b
	add b
	ld [wd7f4], a
	xor a
	call Func_7d5
	pop hl
	pop bc
	dec b
	jr nz, .asm_1d43
	ld a, $00
	vramswitch
	ld de, wc63d
	ld b, $08
.asm_1d8e
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	push hl
	ld h, b
	ld l, c
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	ld b, $08
.asm_1da2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_1da2
	pop af
	bankswitch
	pop hl
	pop bc
	dec b
	jr nz, .asm_1d8e
	ld a, [wd826]
	cp $06
	jr nz, .asm_1dd7
	push hl
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	ld hl, $767c
	ld de, wc645
	ld b, $08
	call CopyHLtoDE
	pop af
	bankswitch
	pop hl
.asm_1dd7
	ld de, wdb85
.asm_1dda
	ld a, [hli]
	cp $ff
	jr z, .asm_1de3
	ld [de], a
	inc de
	jr .asm_1dda
.asm_1de3
	ld hl, $3864
	ld de, wdbdc
	ld b, $0e
.asm_1deb
	ld a, [de]
	or [hl]
	ld [de], a
	inc hl
	inc de
	inc de
	dec b
	jr nz, .asm_1deb
	ld a, $01
	vramswitch
	ld de, v1Tiles0 tile $70
	ld hl, $7ff0
	ld c, $31
	ld b, $01
	ld a, $01
	call Func_7d5
	ld de, v1Tiles0 tile $72
	ld hl, $515d
	ld c, $34
	ld b, $04
	xor a
	call Func_7d5
	ld de, v1Tiles0 tile $7a
	ld hl, $4f5d
	ld c, $34
	ld b, $04
	call Func_826
	ld de, v1Tiles1 tile $68
	ld hl, $4f9d
	ld c, $34
	ld b, $0c
	call Func_826
	ld a, $00
	vramswitch
	ret

Func_1e38:
	push hl
	ld c, a
	call Func_30f1
	pop hl
	ret

Func_1e3f::
.asm_1e3f
	ld a, [wc67d]
	and a
	ret z
	ld a, $01
	call Func_14e8
	jr .asm_1e3f

Func_1e4b::
	ldh a, [hROMBank]
	push af
	ld a, $3c
	bankswitch
	jr Func_1e61
	
	ldh a, [hROMBank]
	push af
	ld a, $3d
	bankswitch
;	fallthrough

Func_1e61:
	ld a, [wdc30]
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	ld de, wdcb6
.asm_1e6d
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .asm_1e6d
	pop de
	ld hl, wdcb6
	pop af
	bankswitch
	ret
; 0x1e7e

SECTION "Func_1eee", ROM0[$1eee]

Func_1eee:
	ld hl, wd82e
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_1f32
	ld a, [wd837]
	and a
	jr nz, .asm_1f32
	ld a, [wd86a]
	ld de, $0
	cp $12
	jr c, .asm_1f18
	ld de, $6
	cp $24
	jr c, .asm_1f18
	ld de, $c
	cp $38
	jr c, .asm_1f18
	ld de, $12
.asm_1f18
	add hl, de
	ld a, [hli]
	ld [wd830], a
	ld a, [hli]
	ld [wd831], a
	ld a, [hli]
	ld [wd833], a
	ld a, [hli]
	ld [wd834], a
	ld a, [hli]
	ld [wd835], a
	ld a, [hl]
	ld [wd836], a
	ret
.asm_1f32
	xor a
	ld [wd830], a
	ret
; 0x1f37

SECTION "Func_1fc7", ROM0[$1fc7]

Func_1fc7:
	ld a, [wd895]
	and a
	ret nz
	ld hl, wDMGPals
	ld bc, $38
	ld a, $ff
	call FillMemory
	call FluchCGBPalettes
	call Func_2597
	ld a, [wd81e]
	and a
	jr nz, .asm_1fe6
	ld a, $08
	add_hl
.asm_1fe6
	call Func_2133
	ld a, [hli]
	ld [wd80b], a
	ld a, [hli]
	ld [wd80c], a
	call Func_2216
	ld hl, wc5fd
	ld de, wDMGPals
	ld b, $38
	call CopyHLtoDE
	call FluchCGBPalettes
	ld hl, wd81e
	ld a, [hl]
	xor $01
	ld [hl], a
	ret
; 0x200a

SECTION "Func_2026", ROM0[$2026]

Func_2026:
	xor a
	ld [wd81e], a
	call Func_2597
	call Func_2133
	ld a, [hli]
	ld [wd80b], a
	ld a, [hli]
	ld [wd80c], a
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld [wdc7a], a
	ld a, [hli]
	ld [wdc7c], a
	ld a, [hli]
	ld [wdc7d], a
	ld a, [hli]
	ld [wd80d], a
	ld a, [hli]
	ld [wd80e], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld hl, $ff60
	add hl, de
	ld a, l
	ld [wd805], a
	ld a, h
	ld [wd806], a
	pop hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld hl, -$80
	add hl, de
	ld a, l
	ld [wd807], a
	ld a, h
	ld [wd808], a
	pop hl
	call Func_2101
	ld a, c
	ld [wd7ff], a
	ld [wd7fb], a
	ld a, b
	ld [wd800], a
	ld [wd7fc], a
	ld a, e
	ld [wd7fd], a
	ld [wd7f9], a
	ld a, d
	ld [wd7fe], a
	ld [wd7fa], a
	call Func_2216
	ld de, wd80f
	xor a
	ld [wdc7e], a
.asm_209c
	call Func_20dc
	ld a, $35
	bankswitch
	ld hl, $7e0d
	ld bc, $f00
.asm_20ac
	push bc
	push de
	push hl
	call Func_20ce
	pop hl
	pop de
	pop bc
	jr z, .asm_20c0
	ld a, $10
	add_hl
	inc c
	dec b
	jr nz, .asm_20ac
	ld c, $01
.asm_20c0
	ld a, c
	ld [de], a
	inc de
	ld hl, wdc7e
	ld a, [hl]
	inc a
	ld [hl], a
	cp $0f
	jr nz, .asm_209c
	ret

Func_20ce:
	ld de, wd771
	ld b, $10
.asm_20d3
	ld a, [de]
	cp [hl]
	ret nz
	inc hl
	inc de
	dec b
	jr nz, .asm_20d3
	ret

Func_20dc:
	push bc
	push de
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [wdc7c]
	ld e, a
	ld a, [wdc7d]
	ld d, a
	add hl, de
	ld a, [wdc7a]
	bankswitch
	ld de, wd771
	ld b, $10
	call CopyHLtoDE
	pop de
	pop bc
	ret

Func_2101:
	ld hl, wd828
	ld de, wda2d
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wd82a
	ld de, wda2a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wd82c]
	ld [wda2f], a
	xor a
	ld [wda31], a
	ld hl, wda23
	ld a, $01
	bankswitch
	call $43be
	push bc
	ld c, e
	ld b, d
	pop de
	ret

Func_2133:
	xor a
	ld [wd7f2], a
	ld [wd7f3], a
	ld [wd7f5], a
	ld a, [hli]
	bankswitch
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld h, d
	ld l, e
	ld de, wc5fd
	ld b, $38
	call CopyHLtoDE
	pop hl
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	push bc
	push de
	ld b, $01
	ld a, $80
	call Func_a95
	pop de
	pop bc
	ld hl, $800
	add hl, de
	ld d, h
	ld e, l
	push bc
	push de
	ld b, $02
	ld a, $80
	call Func_a95
	pop de
	pop bc
	ld hl, $800
	add hl, de
	ld d, h
	ld e, l
	ld b, $04
	ld a, $80
	call Func_a95
	pop hl
	ret

Func_2185:
	ld hl, wd80c
	call Func_21a4
	ld a, [wd80b]
	bit 1, h
	jr z, .asm_2195
	inc a
	res 1, h
.asm_2195
	bankswitch
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	add $40
	ld h, a
	ret

Func_21a4:
	push bc
	push hl
	ld a, d
	rrca
	rrca
	rrca
	and $03
	add [hl]
	bankswitch
	ld a, d
	and $07
	ld h, a
	ld a, e
	and $e0
	ld l, a
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, c
	swap a
	rrca
	and $07
	ld c, a
	ld a, b
	add a
	add a
	add a
	and $f8
	or c
	add l
	ld l, a
	ld a, $40
	add h
	ld h, a
	ld a, [hl]
	pop hl
	pop bc
	push af
	ld a, [hl]
	add $04
	bankswitch
	ld h, d
	ld a, e
	and $e0
	ld l, a
	add hl, hl
	ld a, $40
	add h
	ld h, a
	ld a, b
	add a
	bit 7, c
	jr z, .asm_21ee
	inc a
.asm_21ee
	add l
	ld l, a
	ld a, c
	swap a
	rrca
	and $03
	jr z, .asm_220f
	dec a
	jr z, .asm_220a
	dec a
	jr z, .asm_2205
	ld a, [hl]
	swap a
	rrca
	rrca
	jr .asm_2210
.asm_2205
	ld a, [hl]
	swap a
	jr .asm_2210
.asm_220a
	ld a, [hl]
	rrca
	rrca
	jr .asm_2210
.asm_220f
	ld a, [hl]
.asm_2210
	and $03
	ld h, a
	pop af
	ld l, a
	ret

Func_2216:
	ld hl, wd7fd
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, c
	rrca
	rrca
	rrca
	and $1f
	ld [wd801], a
	ld a, e
	rrca
	rrca
	rrca
	and $1f
	ld [wd802], a
	ld a, $11
.asm_2234
	push af
	push bc
	push de
	call Func_225d
	ld a, $01
	call Func_2255
	pop de
	pop bc
	ld a, $08
	add_de
	pop af
	dec a
	jr nz, .asm_2234
	ld a, $ef
	jp Func_2255

Func_224d:
	ld hl, wd801
	add [hl]
	and $1f
	ld [hl], a
	ret

Func_2255:
	ld hl, wd802
	add [hl]
	and $1f
	ld [hl], a
	ret

Func_225d:
	xor a
	ld [wd803], a
	ld a, c
	and $18
	jr z, .asm_228f
	rrca
	rrca
	rrca
	ld l, a
	ld a, $04
	sub l
	ld [wd804], a
	call Func_230c
	ld a, c
	rrca
	rrca
	and $06
	add l
	ld l, a
.asm_227a
	call Func_22f5
	ld a, [wd804]
	dec a
	ld [wd804], a
	jr nz, .asm_227a
	ld a, c
	and $e0
	add $20
	ld c, a
	jr nc, .asm_228f
	inc b
.asm_228f
	call Func_230c
	ld a, $04
.asm_2294
	ld [wd804], a
	call Func_22f5
	cp $15
	jr z, .asm_22a9
	ld a, [wd804]
	dec a
	jr nz, .asm_2294
	ld a, $20
	add_bc
	jr .asm_228f
.asm_22a9
	ld de, wd771
	call Func_22c2
	ld a, $01
	vramswitch
	ld de, wd786
	call Func_22c2
	ld a, $00
	vramswitch
	ret

Func_22c2:
	ld a, [wd801]
	cp $0c
	jr c, .asm_22ea
	ld l, a
	ld a, $20
	sub l
	ld c, a
	ld b, $01
	ld a, [wd802]
	ld h, a
	push bc
	push de
	call Func_839
	pop de
	pop bc
	ld a, c
	add_de
	ld a, $15
	sub c
	ld c, a
	ld l, $00
	ld a, [wd802]
	ld h, a
	jp Func_839
.asm_22ea
	ld bc, $115
	ld l, a
	ld a, [wd802]
	ld h, a
	jp Func_839

Func_22f5:
	push de
	ld de, wd771
	ld a, [wd803]
	add_de
	ld a, [hli]
	ld [de], a
	ld a, $15
	add_de
	ld a, [hli]
	ld [de], a
	ld de, wd803
	ld a, [de]
	inc a
	ld [de], a
	pop de
	ret

Func_230c:
	call Func_2185
	ld a, e
	and $18
	add l
	ld l, a
	ret

Func_2315:
	xor a
	ld [wd803], a
	ld a, e
	and $18
	jr z, .asm_2345
	rrca
	rrca
	rrca
	ld l, a
	ld a, $04
	sub l
	ld [wd804], a
	call Func_23c6
	ld a, e
	and $18
	add l
	ld l, a
.asm_2330
	call Func_23ab
	ld a, [wd804]
	dec a
	ld [wd804], a
	jr nz, .asm_2330
	ld a, e
	and $e0
	add $20
	ld e, a
	jr nc, .asm_2345
	inc d
.asm_2345
	call Func_23c6
	ld a, $04
.asm_234a
	ld [wd804], a
	call Func_23ab
	cp $11
	jr z, .asm_235f
	ld a, [wd804]
	dec a
	jr nz, .asm_234a
	ld a, $20
	add_de
	jr .asm_2345
.asm_235f
	ld de, wd771
	call Func_2378
	ld a, $01
	vramswitch
	ld de, wd782
	call Func_2378
	ld a, $00
	vramswitch
	ret

Func_2378:
	ld a, [wd802]
	cp $10
	jr c, .asm_23a0
	ld h, a
	ld a, $20
	sub h
	ld b, a
	ld c, $01
	ld a, [wd801]
	ld l, a
	push bc
	push de
	call Func_839
	pop de
	pop bc
	ld a, b
	add_de
	ld a, $11
	sub b
	ld b, a
	ld h, $00
	ld a, [wd801]
	ld l, a
	jp Func_839
.asm_23a0
	ld bc, $1101
	ld h, a
	ld a, [wd801]
	ld l, a
	jp Func_839

Func_23ab:
	push de
	ld de, wd771
	ld a, [wd803]
	add_de
	ld a, [hli]
	ld [de], a
	ld a, $11
	add_de
	ld a, [hl]
	ld [de], a
	ld a, $07
	add l
	ld l, a
	ld de, wd803
	ld a, [de]
	inc a
	ld [de], a
	pop de
	ret

Func_23c6:
	call Func_2185
	ld a, c
	rrca
	rrca
	and $06
	add l
	ld l, a
	ret

Func_23d1:
	ld hl, wd7f9
	ld de, wd7fd
	call Func_2410
	and a
	jr z, .asm_23f1
	push af
	bit 7, a
	jr nz, .asm_23e7
	call Func_2443
	jr .asm_23ea
.asm_23e7
	call Func_2479
.asm_23ea
	pop af
	ld hl, wd7fd
	call Func_2438
.asm_23f1
	ld hl, wd7fb
	ld de, wd7ff
	call Func_2410
	and a
	ret z
	push af
	bit 7, a
	jr nz, .asm_2406
	call Func_24af
	jr .asm_2409
.asm_2406
	call Func_24e5
.asm_2409
	pop af
	ld hl, wd7ff
	jp Func_2438

Func_2410:
	ld a, [de]
	push af
	inc de
	ld a, [de]
	ld d, a
	pop af
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_75a
	ld a, l
	or h
	ret z
	ld e, l
	ld d, h
	call Func_74d
	ld a, h
	and a
	jr nz, .asm_2430
	ld a, l
	cp $21
	jr nc, .asm_2430
	ld a, e
	ret
.asm_2430
	ld a, $20
	bit 7, d
	ret z
	ld a, $e0
	ret

Func_2438:
	ld d, $00
	ld e, a
	and $80
	jr z, .asm_2440
	dec d
.asm_2440
	jp Func_10b0

Func_2443:
	ld hl, wd7fd
	call Func_251b
	ret z
	push af
	call Func_254a
	call Func_2551
	ld hl, $88
	add hl, de
	ld d, h
	ld e, l
	ld a, $11
	call Func_2255
	pop af
.asm_245d
	push af
	push bc
	push de
	call Func_225d
	ld a, $01
	call Func_2255
	pop de
	pop bc
	pop af
	ld hl, $8
	add hl, de
	ld d, h
	ld e, l
	dec a
	jr nz, .asm_245d
	ld a, $ef
	jp Func_2255

Func_2479:
	ld hl, wd7fd
	call Func_2531
	ret z
	push af
	call Func_254a
	call Func_2551
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	ld a, $ff
	call Func_2255
	pop af
.asm_2493
	push af
	push bc
	push de
	call Func_225d
	ld a, $ff
	call Func_2255
	pop de
	pop bc
	pop af
	ld hl, -$8
	add hl, de
	ld d, h
	ld e, l
	dec a
	jr nz, .asm_2493
	ld a, $01
	jp Func_2255

Func_24af:
	ld hl, wd7ff
	call Func_251b
	ret z
	push af
	call Func_2551
	call Func_254a
	ld hl, $a8
	add hl, bc
	ld b, h
	ld c, l
	ld a, $15
	call Func_224d
	pop af
.asm_24c9
	push af
	push bc
	push de
	call Func_2315
	ld a, $01
	call Func_224d
	pop de
	pop bc
	ld hl, $8
	add hl, bc
	ld b, h
	ld c, l
	pop af
	dec a
	jr nz, .asm_24c9
	ld a, $eb
	jp Func_224d

Func_24e5:
	ld hl, wd7ff
	call Func_2531
	ret z
	push af
	call Func_2551
	call Func_254a
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	ld a, $ff
	call Func_224d
	pop af
.asm_24ff
	push af
	push bc
	push de
	call Func_2315
	ld a, $ff
	call Func_224d
	pop de
	pop bc
	ld hl, -$8
	add hl, bc
	ld b, h
	ld c, l
	pop af
	dec a
	jr nz, .asm_24ff
	ld a, $01
	jp Func_224d

Func_251b:
	ld c, a
	rrca
	rrca
	rrca
	and $07
	ld b, a
	ld a, c
	and $07
	ld c, a
	ld a, [hl]
	add c
	xor [hl]
	and $08
	jr z, .asm_252e
	inc b
.asm_252e
	ld a, b
	and a
	ret

Func_2531:
	ld c, a
	xor a
	sub c
	ld c, a
	rrca
	rrca
	rrca
	and $07
	ld b, a
	ld a, c
	and $07
	ld c, a
	ld a, [hl]
	sub c
	xor [hl]
	and $08
	jr z, .asm_2547
	inc b
.asm_2547
	ld a, b
	and a
	ret
; 0x254a

SECTION "Func_254a", ROM0[$254a]

Func_254a:
	ld hl, wd7ff
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret

Func_2551:
	ld hl, wd7fd
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

Func_2558:
	push bc
	push hl
	ldh a, [hROMBank]
	push af
	ld hl, wd80e
	call Func_21a4
	ld a, [wd80d]
	bit 1, h
	jr z, .asm_256d
	inc a
	res 1, h
.asm_256d
	bankswitch
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, h
	add $40
	ld h, a
	ld a, c
	rrca
	rrca
	and $06
	add l
	ld l, a
	ld a, e
	and $18
	add l
	ld l, a
	ld c, [hl]
	pop af
	bankswitch
	ld hl, wd80f
	ld a, c
	add_hl
	ld a, [hl]
	pop hl
	pop bc
	ret

Func_2597:
	ld a, [wd823]
	ld hl, $25a3
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 0x25a3

SECTION "Func_25e5", ROM0[$25e5]

Func_25e5:
	ld b, $08
	ld hl, wd8eb
	ld de, $27
	xor a
.asm_25ee
	ld [hl], a
	add hl, de
	dec b
	jr nz, .asm_25ee
	ret

Func_25f4:
	push bc
	push de
	ld b, $08
	ld hl, wd8eb
	ld de, $27
.asm_25fe
	bit 0, [hl]
	jr z, .asm_260a
	add hl, de
	dec b
	jr nz, .asm_25fe
	pop de
	pop bc
	scf
	ret
.asm_260a
	ld [hl], $01
	lb bc, 0, 0
	ld a, $22
	call SetEntityByteField_C
	ld a, $21
	call SetEntityByteField_C
	ld a, $12
	call SetEntityByteField_C
	ld a, $20
	call SetEntityByteField_C
	ld a, $0d
	call SetEntityWordField_BC
	ld a, $10
	call SetEntityWordField_BC
	pop de
	pop bc
	and a
	ret

Func_2631::
	ld [wdc7a], a
	ld a, l
	ld [wdc7c], a
	ld a, h
	ld [wdc7e], a
	call Func_25f4
	ret c
	push hl
	inc hl
	ld a, [wdc7c]
	ld [hli], a
	ld a, [wdc7e]
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld a, [wdc7a]
	ld [hl], a
	pop hl
	and a
	ret

Func_265f::
	ld a, $0e
	call GetEntityByteField_A
	ld e, a
	and $80
	jr nz, .asm_2670
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
.asm_2670
	push de
	ld a, $0d
	call AddEntityWordField_BC
	pop de
	ld a, $0e
	call GetEntityByteField_A
	xor e
	and $80
	ret z
	ld de, $0000
	ld a, $0d
	jp SetEntityWordField_DE
; 0x2688

SECTION "Func_26b8", ROM0[$26b8]

Func_26b8::
	ld a, $0e
	call GetEntityByteField_A
	bit 7, a
	jr z, .asm_26c3
	cpl
	inc a
.asm_26c3
	cp c
	ret
; 0x26c5

SECTION "Func_26cd", ROM0[$26cd]

Func_26cd::
	push hl
	ld a, $07
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ret

Func_26db:
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	pop hl
	call Func_271b
	push hl
	push de
	ld de, $e
	add hl, de
	bit 7, [hl]
	pop de
	pop hl
	ret z
	push hl
	ld hl, $26f7
	add_hl
	ld a, [hl]
	pop hl
	ret
; 0x26f7

SECTION "Func_270f", ROM0[$270f]

Func_270f::
	push hl
	ld a, $25
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and $08
	pop hl
	ret

Func_271b:
	cp $40
	jr c, .asm_273f
	cp $80
	jr c, .asm_2737
	cp $c0
	jr c, .asm_272f
	and $3f
	ld a, $08
	ret z
	ld a, $09
	ret
.asm_272f
	and $3f
	ld a, $04
	ret z
	ld a, $0c
	ret
.asm_2737
	and $3f
	ld a, $02
	ret z
	ld a, $06
	ret
.asm_273f
	and $3f
	ld a, $01
	ret z
	ld a, $03
	ret

Func_2747::
	push hl
	ld hl, $274f
	add_hl
	ld a, [hl]
	pop hl
	ret
; 0x274f

SECTION "Func_27e5", ROM0[$27e5]

Func_27e5:
	push de
	push hl
	ld a, $07
	add_hl
	ld a, $07
	add_de
	push de
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	call Func_767
	ld a, l
	or h
	jr z, .asm_2807
	ld c, $04
	bit 7, h
	jr nz, .asm_2806
	ld c, $01
.asm_2806
	ld a, c
.asm_2807
	ld [wda59], a
	call Func_74d
	ld b, l
	ld a, h
	and a
	jr z, .asm_2814
	ld b, $ff
.asm_2814
	pop hl
	pop de
	inc hl
	inc hl
	inc hl
	inc de
	inc de
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld d, a
	ld e, c
	call Func_75a
	ld a, l
	or h
	jr z, .asm_283b
	ld c, $02
	bit 7, h
	jr nz, .asm_2834
	ld c, $08
.asm_2834
	ld a, [wda59]
	or c
	ld [wda59], a
.asm_283b
	call Func_74d
	ld c, l
	ld a, h
	and a
	jr z, .asm_2845
	ld c, $ff
.asm_2845
	ld a, [wda59]
	pop hl
	pop de
	ret
; 0x284b

SECTION "Func_289f", ROM0[$289f]

Func_289f::
	bit 7, b
	jr z, .asm_28ae
	add $80
	push af
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
	pop af
.asm_28ae
	push af
	ld a, $10
	call SetEntityWordField_BC
	pop af
	ld c, a
	ld a, $0f
	jp SetEntityByteField_C

Func_28bb::
	push hl
	add_hl
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	bit 7, h
	jr z, .asm_28c9
	ld hl, $0000
.asm_28c9
	ld b, h
	ld c, l
	pop hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	ret

Func_28d1::
	push hl
	push de
	call Func_292a
	ld hl, wdc7a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop bc
	call Func_292a
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld b, h
	ld c, d
	ld a, b
	or c
	jr z, .asm_2928
	ld hl, wda59
	ld [hl], $00
	ld a, b
	and a
	jr z, .asm_290e
	bit 7, a
	jr z, .asm_290c
	ld [hl], $01
	cpl
	ld b, a
	jr .asm_290e
.asm_290c
	ld [hl], $04
.asm_290e
	ld a, c
	and a
	jr z, .asm_291e
	bit 7, a
	jr z, .asm_291c
	set 3, [hl]
	cpl
	ld c, a
	jr .asm_291e
.asm_291c
	set 1, [hl]
.asm_291e
	call Func_2daf
	push af
	call Func_2d66
	ld c, a
	pop af
	ld b, a
.asm_2928
	pop hl
	ret

Func_292a:
	ld a, b
	and a
	jr nz, .asm_2934
	ld d, $00
	ld e, d
	ld b, d
	ld c, d
	ret
.asm_2934
	ld l, b
	push hl
	ld a, c
	call Func_29ea
	pop hl
	push de
	ld d, b
	ld e, c
	call Func_2944
	ld b, d
	ld c, e
	pop de
Func_2944:
	bit 7, d
	jr z, .Func_295a
	xor a
	sub e
	ld e, a
	ld a, $00
	sbc d
	ld d, a
	call .Func_295a
	xor a
	sub e
	ld e, a
	ld a, $00
	sbc d
	ld d, a
	ret
.Func_295a:
	ld a, d
	and a
	jr z, .asm_2960
	ld d, l
	ret
.asm_2960
	ld a, e
	and a
	ret z
	ld d, l
	jp Func_c28

Func_2967::
	ld a, $11
	call GetEntityByteField_A
	and a
	jr z, .asm_2978
	ld d, a
	ld a, $0f
	call GetEntityByteField_E
	call Func_28d1
.asm_2978
	ld a, $0f
	call SetEntityByteField_C
	ld c, $00
	ld a, $10
	jp SetEntityWordField_BC
; 0x2984

SECTION "Func_298c", ROM0[$298c]

Func_298c:
	push de
	ld a, $06
	call Func_146c
	pop bc
	ld a, $09
	jp Func_146c

Func_2998:
	ld hl, $0000
	bit 7, a
	jr z, .Func_29ac
	cpl
	inc a
	call .Func_29ac
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
	ret
.Func_29ac:
	push af
	and $0f
	jr z, .asm_29c4
	call Func_29d1
	sra h
	rr l
	sra h
	rr l
	sra h
	rr l
	sra h
	rr l
.asm_29c4
	pop af
	swap a
	and $0f
	jr z, .asm_29ce
	call Func_29d1
.asm_29ce
	ld b, h
	ld c, l
	ret

Func_29d1:
.asm_29d1
	add hl, bc
	dec a
	jr nz, .asm_29d1
	ret
; 0x29d6

SECTION "Func_29ea", ROM0[$29ea]

Func_29ea:
	ld c, a
	swap a
	and $0c
	ld b, a
	ld a, c
	and $3f
	jr nz, .asm_29f7
	inc b
	inc b
.asm_29f7
	ld a, b
	ld hl, $2a00
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
; 0x2a00

SECTION "Func_2a7e", ROM0[$2a7e]

Func_2a7e:
	call Func_29ea
	xor a
	sub e
	ld e, a
	ld a, $00
	sbc d
	ld d, a
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
	ret

Func_2a90::
	call Func_27e5
	ld a, $0f
	cp c
	ret c
	cp b
	ret c
	call Func_2f8e
	push hl
	ld hl, wda5e
	ld a, [wda62]
	add [hl]
	pop hl
	cp c
	ret c
	push hl
	ld hl, wda5f
	ld a, [wda63]
	add [hl]
	pop hl
	cp b
	ret c
	jp Func_2fc1

Func_2ab5:
	call Func_26cd
	call Func_2558
	cp $00
	ret

Func_2abe::
	ld [wdc7e], a
	xor a
	ld [wda5d], a
	ld [wda5a], a
	push hl
	ld a, $0e
	add_hl
	ld c, [hl]
	ld a, $03
	add_hl
	ld a, [hl]
	or c
	pop hl
	jr z, .asm_2b16
	ld de, wda4d
	call Func_2c37
	call Func_2cbb
	call Func_298c
	call Func_2ab5
	jr nz, .asm_2b16
	ld de, wda51
	call Func_2c37
	ld a, [wda5a]
	ld de, $2b16
	push de
	push hl
	jumptable
	dec d
	dec hl
	dec de
	dec hl
	inc hl
	dec hl
	dec hl
	dec hl
	rra
	dec hl
	dec d
	dec hl
	ld e, l
	dec hl
	dec d
	dec hl
	daa
	dec hl
	pop bc
	dec hl
	dec d
	dec hl
	dec d
	dec hl
	adc a
	dec hl
	dec d
	dec hl
	dec d
	dec hl
	dec d
	dec hl
	pop hl
.asm_2b16
	ld a, [wda5d]
	and a
	ret
; 0x2b1b

SECTION "Func_2c37", ROM0[$2c37]

Func_2c37:
	push hl
	ld a, $07
	add_hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop hl
	ret
; 0x2c49

SECTION "Func_2cbb", ROM0[$2cbb]

Func_2cbb:
	ld a, $0e
	call GetEntityByteField_A
	and a
	jr z, .asm_2cf5
	ld [wdc7a], a
	ld a, $0c
	call GetEntityByteField_A
	ld [wdc7c], a
	call Func_2d2c
	ld a, $11
	call GetEntityByteField_A
	and a
	jr z, .asm_2d08
	ld [wdc7a], a
	ld a, $0f
	call GetEntityByteField_A
	ld [wdc7c], a
	push hl
	push de
	push bc
	call Func_2d2c
	pop hl
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	add hl, de
	ld d, h
	ld e, l
	pop hl
	jr .asm_2d08
.asm_2cf5
	ld a, $11
	call GetEntityByteField_A
	ld [wdc7a], a
	ld a, $0f
	call GetEntityByteField_A
	ld [wdc7c], a
	call Func_2d2c
.asm_2d08
	push hl
	ld hl, wda5a
	ld [hl], $00
	ld a, e
	or d
	jr z, .asm_2d1c
	bit 7, d
	jr nz, .asm_2d1a
	set 1, [hl]
	jr .asm_2d1c
.asm_2d1a
	set 3, [hl]
.asm_2d1c
	ld a, c
	or b
	jr z, .asm_2d2a
	bit 7, b
	jr nz, .asm_2d28
	set 2, [hl]
	jr .asm_2d2a
.asm_2d28
	set 0, [hl]
.asm_2d2a
	pop hl
	ret

Func_2d2c:
	push hl
	ld a, [wdc7c]
	call Func_29ea
	ld a, b
	or c
	call nz, Func_2d47
	ld a, d
	or e
	jr z, .asm_2d45
	push bc
	ld b, d
	ld c, e
	call Func_2d47
	ld d, b
	ld e, c
	pop bc
.asm_2d45
	pop hl
	ret

Func_2d47:
	ld a, [wdc7a]
	jp Func_2998
; 0x2d4d

SECTION "Func_2d66", ROM0[$2d66]

Func_2d66::
	call Func_2d87
	ld c, a
	ld a, [wda59]
	and $0c
	jr z, .asm_2d85
	cp $0c
	jr z, .asm_2d81
	cp $04
	jr z, .asm_2d7d
	ld a, c
	cpl
	inc a
	ret
.asm_2d7d
	ld a, $80
	sub c
	ret
.asm_2d81
	ld a, c
	add $80
	ret
.asm_2d85
	ld a, c
	ret

Func_2d87:
.asm_2d87
	ld a, c
	and a
	ret z
	ld a, b
	and a
	jr z, .asm_2dac
	cp $11
	jr nc, .asm_2da6
	ld a, c
	cp $11
	jr nc, .asm_2da6
	dec a
	dec b
	add a
	add a
	add a
	add a
	add b
	push hl
	ld hl, $2e5f
	add_hl
	ld a, [hl]
	pop hl
	ret
.asm_2da6
	srl c
	srl b
	jr .asm_2d87
.asm_2dac
	ld a, $40
	ret

Func_2daf:
	ld a, b
	and a
	jr z, .asm_2dd1
	ld a, c
	and a
	jr z, .asm_2dd3
	push de
	push hl
	call Func_c43
	ld h, d
	ld l, e
	ld a, b
	call Func_c43
	add hl, de
	jr c, .asm_2dcd
	ld d, h
	ld e, l
	call Func_c4e
.asm_2dca
	pop hl
	pop de
	ret
.asm_2dcd
	ld a, $ff
	jr .asm_2dca
.asm_2dd1
	ld a, c
	ret
.asm_2dd3
	ld a, b
	ret
; 0x2dd5

SECTION "Func_2f5f", ROM0[$2f5f]

Func_2f5f::
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	push hl
	ld a, $03
	add_hl
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld a, [hli]
	ld [wda5e], a
	ld a, [hli]
	ld [wda5f], a
	ld a, c
	add_hl
	ld a, l
	ld [wda60], a
	ld a, h
	ld [wda61], a
	pop hl
	pop af
	bankswitch
	ret

Func_2f8e:
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	push de
	push hl
	ld h, d
	ld l, e
	ld a, $03
	add_hl
	ld e, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld a, [hli]
	ld [wda62], a
	ld a, [hli]
	ld [wda63], a
	ld a, e
	add_hl
	ld a, l
	ld [wda64], a
	ld a, h
	ld [wda65], a
	pop hl
	pop de
	pop af
	bankswitch
	ret

Func_2fc1:
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	push de
	push hl
	ld hl, wda60
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wda64]
	ld e, a
	ld a, [wda65]
	ld d, a
	ld a, [wda59]
	and $01
	jr z, .asm_2fe7
	ld a, b
	add a
	add_de
	jr .asm_2fea
.asm_2fe7
	ld a, b
	add a
	add_hl
.asm_2fea
	ld a, [wda59]
	and $08
	jr z, .asm_2ff5
	push de
	ld e, l
	ld d, h
	pop hl
.asm_2ff5
	ld a, $10
	sub b
.asm_2ff8
	push af
	push de
	push hl
	ld a, [de]
	push af
	inc de
	ld a, [de]
	ld d, a
	pop af
	ld e, a
	or d
	jr z, .asm_3026
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_3026
	ld a, c
	and a
	jr z, .asm_301e
	cp $08
	jr c, .asm_301a
	ld h, l
	ld l, $00
	sub $08
	jr z, .asm_301e
.asm_301a
	add hl, hl
	dec a
	jr nz, .asm_301a
.asm_301e
	ld a, h
	and d
	jr nz, .asm_303a
	ld a, l
	and e
	jr nz, .asm_303a
.asm_3026
	pop hl
	pop de
	inc hl
	inc hl
	inc de
	inc de
	pop af
	dec a
	jr nz, .asm_2ff8
	pop hl
	pop de
	pop af
	bankswitch
	scf
	ret
.asm_303a
	pop af
	pop af
	pop af
	pop hl
	pop de
	pop af
	bankswitch
	and a
	ret

Func_3047::
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	ld a, $25
	call GetEntityWordField_DE
	push de
	push hl
	inc de
	inc de
	ld a, $07
	add_hl
	ld a, [hli]
	sub $08
	ld [de], a
	inc de
	ld a, [hli]
	sbc $00
	ld [de], a
	inc de
	inc hl
	inc de
	ld a, [hli]
	sub $08
	ld [de], a
	inc de
	ld a, [hl]
	sbc $00
	ld [de], a
	pop hl
	pop de
	ld a, $0c
	call GetEntityByteField_A
	add $04
	rrca
	rrca
	rrca
	and $1f
	ld c, a
	push hl
	ld hl, $7624
	ld b, $00
	add hl, bc
	ld a, [de]
	and $9f
	or [hl]
	or $06
	ld [de], a
	ld a, [hl]
	pop hl
	inc hl
	ld b, [hl]
	inc hl
	inc hl
	ld [hli], a
	push hl
	ld a, b
	add a
	ld hl, $75d7
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	add a
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, $05
	sub_hl
	ld a, [bc]
	push af
	inc bc
	ld a, [bc]
	ld b, a
	pop af
	ld c, a
	ld a, $05
	add_de
	bit 4, b
	jr nz, .asm_30c6
	ld a, [de]
	add $04
	ld [de], a
	inc de
	ld a, [de]
	adc $00
	ld [de], a
	jr .asm_30c7
.asm_30c6
	inc de
.asm_30c7
	inc de
	ld a, $10
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	push hl
	inc hl
	ld a, [hli]
	ld b, [hl]
	ld hl, wdbc5
	add a
	add_hl
	ld a, [hli]
	add c
	ld c, a
	ld a, [hl]
	or b
	ld b, a
	ld h, d
	ld l, e
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	inc c
	inc c
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	pop af
	bankswitch
	ret

Func_30f1:
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	ld hl, wdbc5
	ld a, c
	add a
	add_hl
	ld de, wd7f1
	ld a, b
	add_de
	ld a, [de]
	ld [hl], a
	ld a, b
	cp $02
	jr z, .asm_3138
	cp $05
	jr z, .asm_3138
.asm_3111
	inc hl
	ld a, b
	cp $03
	ld a, $00
	jr c, .asm_311b
	ld a, $08
.asm_311b
	ld [hl], a
	ld a, c
	add a
	add a
	add c
	ld hl, $75ed
	add_hl
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	call Func_a95
	pop af
	bankswitch
	ret
.asm_3138
	ld a, [hl]
	add $80
	ld [hl], a
	jr .asm_3111

Func_313e::
	call Func_2f5f
	call Func_26db
	ld [wda5a], a
	xor a
	ld [wda5d], a
	ld de, wda9d
	ld b, $0c
.asm_3150
	ld a, [de]
	and $01
	call nz, Func_3161
	ld a, $13
	add_de
	dec b
	jr nz, .asm_3150
	ld a, [wda5d]
	and a
	ret

Func_3161:
	push bc
	push de
	push hl
	ld a, $09
	add_de
	ld hl, wda29
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop hl
	ld de, wda23
	call Func_27e5
	pop de
	ld a, $09
	cp c
	jr c, .asm_31f9
	cp b
	jr c, .asm_31f9
	ld a, [wda5e]
	add $02
	cp c
	jr c, .asm_31f9
	ld a, [wda5f]
	add $02
	cp b
	jr c, .asm_31f9
	push de
	ld a, $04
	add_de
	call Func_2d66
	ld [wda66], a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld c, a
	ld a, [wda5a]
	sub c
	cp $80
	ld a, $ff
	jr c, .asm_31b6
	ld a, $01
.asm_31b6
	ld [de], a
	inc de
	ld a, $0d
	call GetEntityWordField_BC
	bit 7, b
	jr z, .asm_31c8
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
.asm_31c8
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	ld a, $0f
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $3705
	ld a, $00
	call Func_1569
	pop hl
	pop de
	ld a, [de]
	and $02
	jr z, .asm_31f4
	ld a, [wda5d]
	and a
	jr nz, .asm_31f9
	ld a, $01
	ld [wda5d], a
	jr .asm_31f9
.asm_31f4
	ld a, $02
	ld [wda5d], a
.asm_31f9
	pop bc
	ret

Func_31fb::
	push de
	push hl
	call Func_2a7e
	ld hl, wda68
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	pop de
	call Func_3259
.asm_320f
	call .Func_322a
	call Func_2a90
	jr c, .asm_3221
	push de
	call Func_2ab5
	pop de
	call nz, Func_3259
	jr .asm_320f
.asm_3221
	push de
	call Func_2ab5
	pop de
	jr z, .asm_323c
	and a
	ret

.Func_322a:
	push de
	push hl
	ld hl, wda68
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	call Func_298c
	pop de
	ret

.asm_323c
	push de
	push hl
	ld a, $06
	add_hl
	ld de, wda6e
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop hl
	pop de
	scf
	ret

Func_3259:
	push de
	push hl
	ld de, wda6e
	ld a, $06
	add_hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop hl
	pop de
	ret

Func_3275::
	push de
	push hl
	call Func_29ea
	ld hl, wda68
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	pop de
	call Func_32dd
.asm_3289
	call .Func_32aa
	call Func_2a90
	jr c, .asm_3299
	call .Func_32a0
	call nz, Func_32dd
	jr .asm_3289
.asm_3299
	call .Func_32a0
	jr z, .asm_32be
	and a
	ret

.Func_32a0:
	push de
	push hl
	ld h, d
	ld l, e
	call Func_2ab5
	pop hl
	pop de
	ret

.Func_32aa:
	push hl
	push de
	ld hl, wda68
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	call Func_298c
	ld d, h
	ld e, l
	pop hl
	ret

.asm_32be
	push de
	push hl
	ld h, d
	ld l, e
	ld a, $06
	add_hl
	ld de, wda6e
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop hl
	pop de
	scf
	ret

Func_32dd:
	push de
	push hl
	ld h, d
	ld l, e
	ld de, wda6e
	ld a, $06
	add_hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop hl
	pop de
	ret

Func_32fb:
	call Func_33b4
	ld hl, wdb81
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, e
	and $f8
	ld e, a
	ld hl, -$4
	add hl, bc
	ld b, h
	ld c, l
	ld hl, -$4
	add hl, de
	ld d, h
	ld e, l
	ld a, $11
.asm_331a
	push af
	push bc
	push de
	call Func_33bf
	pop de
	pop bc
	ld a, $08
	add_de
	pop af
	dec a
	jr nz, .asm_331a
	ret

Func_332a:
	ld hl, wd7fd
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wdb81
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp d
	jr nz, .asm_333c
	ld a, l
	cp e
.asm_333c
	jr z, .asm_3348
	jr c, .asm_3345
	call Func_3378
	jr .asm_3348
.asm_3345
	call Func_3384
.asm_3348
	ld hl, wd7ff
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wdb83
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	cp d
	jr nz, .asm_335a
	ld a, l
	cp e
.asm_335a
	jr z, .asm_3366
	jr c, .asm_3363
	call Func_3396
	jr .asm_3366
.asm_3363
	call Func_33a2
.asm_3366
	ld hl, wd7fd
	ld de, wdb81
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

Func_3378:
	call Func_33b4
	ld hl, -$4
	add hl, bc
	ld b, h
	ld c, l
	jp Func_33bf

Func_3384:
	call Func_33b4
	ld hl, -$4
	add hl, bc
	ld b, h
	ld c, l
	ld hl, $80
	add hl, de
	ld d, h
	ld e, l
	jp Func_33bf

Func_3396:
	call Func_33b4
	ld hl, -$4
	add hl, de
	ld d, h
	ld e, l
	jp Func_342f

Func_33a2:
	call Func_33b4
	ld hl, $a0
	add hl, bc
	ld b, h
	ld c, l
	ld hl, -$4
	add hl, de
	ld d, h
	ld e, l
	jp Func_342f

Func_33b4:
	ld hl, wd7fd
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret

Func_33bf:
	ld a, c
	add $a7
	jr nc, .asm_3412
	call Func_351e
	jr z, .asm_33ea
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_33cf
	ld a, [hl]
	cp c
	jr c, .asm_33ea
	call Func_3425
	call c, Func_3574
	ld a, [wdc7a]
	cp l
	jr nz, .asm_33e5
	ld a, [wdc7b]
	cp h
	jr z, .asm_33ea
.asm_33e5
	dec hl
	dec hl
	dec hl
	jr .asm_33cf
.asm_33ea
	ld a, c
	add $a8
	ld c, a
	inc b
	call Func_351e
	ret z
.asm_33f3
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_33f9
	ld a, [hl]
	cp c
	ret nc
	call Func_3425
	call c, Func_3574
	ld a, [wdc7c]
	cp l
	jr nz, .asm_340d
	ld a, [wdc7d]
	cp h
	ret z
.asm_340d
	inc hl
	inc hl
	inc hl
	jr .asm_33f9
.asm_3412
	call Func_351e
	ret z
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	cp c
	ret c
	ld a, c
	add $a8
	ld c, a
	jr .asm_33f3

Func_3425:
	inc hl
	ld a, [hld]
	sub e
	jr nc, .asm_342c
	cpl
	inc a
.asm_342c
	cp $04
	ret

Func_342f:
	ld a, e
	add $87
	jr nc, .asm_3447
	xor a
	ld [wdc82], a
	call .Func_344c
	ld a, e
	add $88
	ld e, a
	inc d
	ld a, $01
	ld [wdc82], a
	jr .Func_344c

.asm_3447
	ld a, $02
	ld [wdc82], a
.Func_344c:
	call Func_351e
	ret z
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_34ed
	ld [wdc7e], a
	ld hl, wdc7c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_34ed
	ld [wdc80], a
	push hl
	ld hl, wdc7e
	cp [hl]
	pop hl
	jr c, .asm_34a4
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wdc7e]
.asm_3479
	cp $04
	jr c, .asm_3492
	call Func_34cf
	ret z
	call Func_34ed
	push hl
	ld hl, wdc7e
	cp [hl]
	pop hl
	jr z, .asm_3479
	ret nc
	ld [wdc7e], a
	jr .asm_3479
.asm_3492
	call Func_34f3
	call c, Func_3574
	call Func_34cf
	ret z
	call Func_34ed
	cp $04
	ret nc
	jr .asm_3492
.asm_34a4
	cp $04
	jr c, .asm_34bd
	call Func_34de
	ret z
	call Func_34ed
	push hl
	ld hl, wdc80
	cp [hl]
	pop hl
	jr z, .asm_34a4
	ret nc
	ld [wdc80], a
	jr .asm_34a4
.asm_34bd
	call Func_34f3
	call c, Func_3574
	call Func_34de
	ret z
	call Func_34ed
	cp $04
	ret nc
	jr .asm_34bd

Func_34cf:
	ld a, [wdc7c]
	cp l
	jr nz, .asm_34da
	ld a, [wdc7d]
	cp h
	ret z
.asm_34da
	inc hl
	inc hl
	inc hl
	ret

Func_34de:
	ld a, [wdc7a]
	cp l
	jr nz, .asm_34e9
	ld a, [wdc7b]
	cp h
	ret z
.asm_34e9
	dec hl
	dec hl
	dec hl
	ret

Func_34ed:
	ld a, [hl]
	sub c
	ret nc
	cpl
	inc a
	ret

Func_34f3:
	ld a, [wdc82]
	inc hl
	push hl
	jumptable
; 0x34f9

SECTION "Func_351e", ROM0[$351e]

Func_351e:
	ld a, b
	cp $20
	jr nc, .asm_3542
	ld a, d
	cp $20
	jr nc, .asm_3542
	call Func_3544
	ld a, [hli]
	or [hl]
	ret z
	push de
	dec hl
	ld de, wdc7a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	xor a
	dec a
	pop de
	ret
.asm_3542
	xor a
	ret

Func_3544:
	push de
	ld a, [wd823]
	ld e, a
	add a
	add e
	ld hl, $3823
	add_hl
	ld a, [hli]
	bankswitch
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, $00
	srl d
	rr e
	add hl, de
	ld a, b
	add a
	add a
	add_hl
	pop de
	ret

Func_3565:
	ld hl, wda9d
	ld b, $0c
	ld de, $13
	xor a
.asm_356e
	ld [hl], a
	add hl, de
	dec b
	jr nz, .asm_356e
	ret

Func_3574:
	call Func_3582
	ret c
	push bc
	push de
	push hl
	call Func_35ad
	pop hl
	pop de
	pop bc
	ret

Func_3582:
	push bc
	push de
	push hl
	ld d, h
	ld e, l
	ld hl, wda9d
	ld b, $0c
.asm_358c
	bit 0, [hl]
	call nz, Func_359c
	ld a, $13
	add_hl
	dec b
	jr nz, .asm_358c
	and a
Func_3598:
	pop hl
	pop de
	pop bc
	ret

Func_359c:
	push hl
	inc hl
	ld a, [hli]
	cp e
	jr nz, .asm_35a6
	ld a, [hl]
	cp d
	jr z, .asm_35a8
.asm_35a6
	pop hl
	ret
.asm_35a8
	pop hl
	pop hl
	scf
	jr Func_3598

Func_35ad:
	push hl
	ld hl, wda9d
	ld c, $0c
.asm_35b3
	bit 0, [hl]
	jr z, .asm_35bf
	ld a, $13
	add_hl
	dec c
	jr nz, .asm_35b3
	pop hl
	ret
.asm_35bf
	ld [hl], $01
	inc hl
	ld c, d
	pop de
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld a, [de]
	inc de
	push af
	ld a, [de]
	inc de
	push af
	push hl
	ld hl, wdb85
	ld a, [de]
	add a
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	inc hl
	inc hl
	xor a
	ld [hli], a
	ld [hli], a
	pop af
	ld e, a
	ld d, c
	pop af
	ld c, a
	xor a
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, $0e
	sub_hl
	push hl
	ld hl, $36f5
	ld c, $00
	ld b, $0a
	call Func_1536
	pop de
	jr c, .asm_362b
	ld a, $06
	call SetEntityWordField_DE
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, $0f
	call SetEntityWordField_DE
	call Func_1124
	jr c, .asm_362e
	ld a, $11
	call SetEntityWordField_DE
	ld a, [de]
	or $06
	ld [de], a
	ld a, $07
	add_de
	ld a, $10
	ld [de], a
	inc de
	ld a, $08
	ld [de], a
	jp Func_3637
.asm_362b
	xor a
	ld [de], a
	ret
.asm_362e
	ld [hl], $00
	ld a, $0f
	call GetEntityWordField_DE
	jr .asm_362b

Func_3637:
	push hl
	ld e, [hl]
	inc hl
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $0d
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and $9f
	ld [hl], a
	push hl
	ld a, $09
	add_hl
	ld a, e
	push af
	ld a, c
	add a
	ld de, wdbdb
	add_de
	pop af
	and $02
	jr z, .asm_368e
	ld a, c
	cp $0a
	ld c, $02
	jr c, .asm_3663
	inc c
	inc c
.asm_3663
	ld a, [de]
	add c
	ld c, a
	ld a, b
	add $10
	ld b, a
	push hl
	swap a
	and $0e
	ld hl, .Data1
	add_hl
	ld a, [hli]
	add c
	ld b, [hl]
	pop hl
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	ld a, b
	jr .asm_36b6

.Data1:
	db $00, $00
	db $02, $00
	db $04, $00
	db $02, $40
	db $00, $40
	db $02, $60
	db $04, $20
	db $02, $20

.asm_368e
	ld a, c
	cp $0a
	jr c, .asm_36b0
	ld a, [de]
	bit 6, b
	jr z, .asm_369a
	add $02
.asm_369a
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	ld a, b
	swap a
	rrca
	rrca
	and $03
	ld hl, .Data2
	add_hl
	ld a, [hl]
	jr .asm_36b6

.Data2:
	db $00, $00
	db $40, $20

.asm_36b0
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	xor a
.asm_36b6
	pop hl
	ld b, a
	or [hl]
	ld [hl], a
	ld d, h
	ld e, l
	ld a, $02
	add_de
	pop hl
	push hl
	ld a, $0a
	add_hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $04
	sub_hl
	push hl
	ld h, d
	ld l, e
	ld a, $04
	bit 6, b
	jr z, .asm_36db
	ld a, $0c
.asm_36db
	sub_hl
	ld d, h
	ld e, l
	pop bc
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	ret
; 0x36ea
