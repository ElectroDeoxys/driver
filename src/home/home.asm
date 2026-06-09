_Start:
	ld sp, hStackBottom
	call Init
	call EnableDoubleSpeed
Reset:
	ld sp, hStackBottom
	call InitTransferVirtualOAMAndClearWRAM
	call Func_1084
	call Func_1b5
	call LoadDefaultPalettes
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
	ldh [hInitialised], a
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
	ld [wVBlankExecuted], a
	
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
	ld a, SCENE_GB_DISCLAIMER
	call LoadScene
.loop_disclaimer
	call Func_501
	call PostVBlank
	jr .loop_disclaimer

.cgb
	ld hl, hInitialised
	ld a, [hl]
	ld [hl], TRUE
	and a
	ret nz

	homecall CheckSkipCompanies
	ret nz ; skip

	ld a, SCENE_LICENSED_BY_NINTENDO
	ld b, 60
	ld c, 60
	call .ShowScene

	ld a, SCENE_LEGAL_INFO
	ld b, 60
	ld c, 60
	call .ShowScene

	ld a, SCENE_INFOGRAMES
	ld b, 60
	ld c, 60
	call .ShowScene

	ld a, SCENE_REFLECTIONS
	ld b, 60
	ld c, 60
	call .ShowScene

	ld a, SCENE_CRAWFISH_INTERACTIVE
	ld b, 60
	ld c, 60
	call .ShowScene
	ret

.ShowScene:
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
	ld de, Scenes
	add hl, de
	ldh a, [hROMBank]
	push af
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .asm_27b
	ld a, [hli]
	ld [wTempBGP], a
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
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLtoDE
	pop hl
	ld a, $01
.asm_294
	call InitFade
	call Func_59e
	pop af
	bankswitch
	ret

ShowScene::
.loop_show
	push bc
	call Func_501
	call PostVBlank
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
	call FadeToWhite
.asm_2bd
	call Func_501
	call PostVBlank
	ld a, [wFadeActive]
	and a
	jr nz, .asm_2bd
	ret

FadeToWhite::
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb
; dmg
	ld a, $00
	ld hl, wTempDMGPals
	ld [hli], a ; wTempBGP
	ld [hli], a ; wTempOBP0
	ld [hl], a  ; wTempOBP1
	ld a, $03
	jp InitFade

.cgb
	ld hl, wTempCGBPals
	ld c, 8 + 8 ; num of BG and OB pals
.loop_pals
	ld b, PAL_SIZE
	ld de, Pals_White
.loop_cols
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop_cols
	dec c
	jr nz, .loop_pals
	ld a, $01
	jp InitFade
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

Scenes:
	; SCENE_GB_DISCLAIMER
	dmgpal SHADE_WHITE, SHADE_LIGHT, SHADE_DARK, SHADE_BLACK ; BGP (dgm only)
	dba NULL  ; BG palettes (CGB only)
	dbw $34, $68dd ; tiles VRAM0
	dbw $34, $6b3c ; BG map
	dba NULL  ; tiles VRAM1 (CGB only)
	dba NULL  ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d2c17 ; BG palettes (CGB only)
	dbw $34, $6c57 ; tiles VRAM0
	dbw $34, $7407 ; BG map
	dbw $32, $7fd0 ; tiles VRAM1 (CGB only)
	dbw $34, $7543 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d3567 ; BG palettes (CGB only)
	dbw $34, $75a7 ; tiles VRAM0
	dbw $34, $7cb4 ; BG map
	dbw $34, $7ddd ; tiles VRAM1 (CGB only)
	dbw $34, $7e06 ; tile attributes (CGB only)

	; SCENE_CRAWFISH_INTERACTIVE
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d3e68 ; BG palettes (CGB only)
	dbw $35, $4000 ; tiles VRAM0
	dbw $34, $7ea8 ; BG map
	dbw $35, $47f7 ; tiles VRAM1 (CGB only)
	dbw $35, $4820 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d4857 ; BG palettes (CGB only)
	dbw $35, $4897 ; tiles VRAM0
	dbw $35, $4c9d ; BG map
	dbw $35, $4d7b ; tiles VRAM1 (CGB only)
	dbw $35, $4da4 ; tile attributes (CGB only)

	; SCENE_LEGAL_INFO
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d4dcb ; BG palettes (CGB only)
	dbw $35, $4e0b ; tiles VRAM0
	dbw $35, $5086 ; BG map
	dbw $35, $511e ; tiles VRAM1 (CGB only)
	dbw $34, $7fda ; tile attributes (CGB only)

	; SCENE_LICENSED_BY_NINTENDO
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d5147 ; BG palettes (CGB only)
	dbw $35, $5187 ; tiles VRAM0
	dbw $35, $5284 ; BG map
	dbw $35, $52c9 ; tiles VRAM1 (CGB only)
	dbw $35, $52f2 ; tile attributes (CGB only)

	; SCENE_INFOGRAMES
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d61a4 ; BG palettes (CGB only)
	dbw $35, $61e4 ; tiles VRAM0
	dbw $35, $6994 ; BG map
	dbw $35, $6ad0 ; tiles VRAM1 (CGB only)
	dbw $35, $6af9 ; tile attributes (CGB only)

	; SCENE_REFLECTIONS
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d589f ; BG palettes (CGB only)
	dbw $35, $58df ; tiles VRAM0
	dbw $35, $5ff0 ; BG map
	dbw $35, $6119 ; tiles VRAM1 (CGB only)
	dbw $35, $6142 ; tile attributes (CGB only)

	; SCENE_TITLESCREEN
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d5315 ; BG palettes (CGB only)
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
	ld a, [wVBlankExecuted]
	and a
	jr nz, .push_oam
	ld a, [hl] ; wc56d
	cp $02
	jr c, .push_oam
	xor a
	ld [hl], a
	inc a ; TRUE
	ld [wVBlankExecuted], a
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
	call UpdateAudio
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

WaitForVBlank:
	ld hl, wVBlankExecuted
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
	ld hl, hLCDSettings
	ld a, [hli]
	ldh [rSCX], a  ; hLCDSettingsSCX
	ld a, [hli]
	ldh [rSCY], a  ; hLCDSettingsSCY
	ld a, [hli]
	ldh [rLCDC], a ; hLCDSettingsLCDC
	ld a, [hl]
	ldh [rLYC], a  ; hLCDSettingsLYC
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
	ld hl, wLCDSettingsPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, LOW(hLCDSettings)
	ld a, [hli]
	ld [$ff00+c], a ; hLCDSettingsSCX
	inc c
	ld a, [hli]
	ld [$ff00+c], a ; hLCDSettingsSCY
	inc c
	ld a, [hli]
	or LCDC_BG_ON | LCDC_ON
	ld [$ff00+c], a ; hLCDSettingsLCDC
	inc c
	ld a, [hli]
	ld [$ff00+c], a ; hLCDSettingsLYC
	ld a, l
	ld [wLCDSettingsPtr + 0], a
	ld a, h
	ld [wLCDSettingsPtr + 1], a
	ret

Func_4a5:
	ld a, [wc681 + 0]
	ld [wLCDSettingsPtr + 0], a
	ld a, [wc681 + 1]
	ld [wLCDSettingsPtr + 1], a
	call Func_487

	ld hl, hLCDSettings
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
	; set wc681 and wLCDSettingsPtr to wLCDSettings
	ld de, wLCDSettings
	ld hl, wc681
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wLCDSettingsPtr
	ld [hl], e
	inc hl
	ld [hl], d

	ld de, wc6cf
	ld hl, wc683
	ld [hl], e
	inc hl
	ld [hl], d

	ld hl, wLCDSettings
	call .ClearLCDSettings

	ld hl, wc6cf
	call .ClearLCDSettings

	ld hl, hLCDSettings
	call .ClearLCDSettings
	ld hl, hLCDSettingsLCDC
	ld a, [hl]
	or LCDC_BG_ON | LCDC_ON
	ld [hl], a
	ret

.ClearLCDSettings:
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

; waits for V-Blank to be executed, then updates colour fading,
; reads joypad input, and does a soft reset if A+B+START+SELECT are pressed
PostVBlank::
	call WaitForVBlank
	call UpdateFade
	call ReadJoypad

	ld a, [wResetDisabled]
	and a
	ret nz ; reset disabled

	; only reset if buttons are pressed for 5 frames
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
	ld a, [wd7f7]
	inc a
	ld [wd7f7], a
	ld a, e
	and a
	ret nz
	inc d
	ret

; returns hl = abs(hl)
GetAbsHL::
	bit 7, h ; negative?
	ret z ; is positive, exit
	push af
	xor a
	sub l
	ld l, a
	ld a, 0
	sbc h
	ld h, a
	pop af
	ret

; returns hl = hl - de
HLMinusDE::
	push af
	ld a, l
	sub e
	ld l, a
	ld a, h
	jr nc, .no_carry
	dec h
.no_carry
	ld a, h
	sub d
	ld h, a
	pop af
	ret

; returns hl = hl - bc
HLMinusBC::
	push af
	ld a, l
	sub c
	ld l, a
	ld a, h
	jr nc, .no_carry
	dec h
.no_carry
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

SECTION "CopyTilesWithAlternatingBlackTiles", ROM0[$7d5]

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
	; swap hl and de
	push de
	ld e, l
	ld d, h
	pop hl

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

ClearVRAMTiles::
	ld hl, wVRAMNumTiles
	xor a
	ld [hli], a ; V0TILES_8000
	ld [hli], a ; V0TILES_9000
	ld [hli], a ; V0TILES_8800
	ld [hli], a ; V1TILES_8000
	ld [hli], a ; V1TILES_9000
	ld [hl], a  ; V1TILES_8800
	ret

; input:
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
; - c:de = source of tiles (compressed)
PushTilesToVRAM_Compressed::
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	ld a, b
	ld hl, wVRAMNumTiles
	add_hl
	ld c, [hl] ; tile index
	push hl
	ld hl, VRAMBlockAddresses
	ld a, b
	cp V1TILES
	jr c, .vram0
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	sub V1TILES
.vram0
	add_hl
	ld h, [hl] ; high byte of dest
	ld l, $00
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ; *16
	add hl, bc

	; swap hl with de
	ld a, l
	ld l, e
	ld e, a
	ld a, h
	ld h, d
	ld d, a

	push de
	call Decompress
	ld h, d
	ld l, e
	pop de
	call HLMinusDE
	srl l
	srl l
	srl l
	srl l
	ld a, h
	add a
	add a
	add a
	add a
	add l
	pop hl
	add [hl]
	ld [hl], a
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .dmg
	ld a, BANK("VRAM0")
	vramswitch
.dmg
	pop af
	bankswitch
	ret

; input:
; - a  = number of tiles
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
; - c:de = source of tiles
PushTilesToVRAM::
	ld [wNumTilesToPush], a
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
	ld a, b
	ld hl, wVRAMNumTiles
	add_hl
	ld c, [hl] ; tile index
	push hl
	ld hl, VRAMBlockAddresses
	ld a, b
	cp V1TILES
	jr c, .vram0
	ld a, BANK("VRAM1")
	vramswitch
	ld a, b
	sub V1TILES
.vram0
	add_hl
	ld h, [hl] ; high byte of dest
	ld l, $00
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b ; *16
	add hl, bc

	; swap hl with de
	ld a, l
	ld l, e
	ld e, a
	ld a, h
	ld h, d
	ld d, a

	ld a, [wNumTilesToPush]
	ld b, a
	call SafeCopyBTiles
	pop hl

	ld a, [wNumTilesToPush]
	add [hl]
	ld [hl], a
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr nz, .dmg
	ld a, BANK("VRAM0")
	vramswitch
.dmg
	pop af
	bankswitch
	ret

; input
; - a = number of tiles
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
BlackOutVRAMTiles::
	ld c, a
	ldh a, [hROMBank]
	push af

	; black out wGfxBuffer
	push bc
	ld hl, wGfxBuffer
	ld bc, TILE_SIZE
	call ClearMemory
	pop bc

.loop_tiles
	push bc
	ld de, wGfxBuffer
	ld c, $1
	ld a, 1 ; tile
	call PushTilesToVRAM
	pop bc
	dec c
	jr nz, .loop_tiles

	pop af
	bankswitch
	ret

; copies b bytes from c:hl to de
FarCopy::
	ldh a, [hROMBank]
	push af
	ld a, c
	bankswitch
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop af
	bankswitch
	ret

VRAMBlockAddresses:
	db HIGH(v0Tiles0) ; V0TILES_8000 | V1TILES_8000
	db HIGH(v0Tiles2) ; V0TILES_9000 | V1TILES_9000
	db HIGH(v0Tiles1) ; V0TILES_8800 | V1TILES_8800
; 0xb34

SECTION "Func_bdd", ROM0[$bdd]

Func_bdd::
	push hl
	ld hl, wdc7a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, bc
	bit 7, h
	jr nz, .asm_c25
	ld a, [wdc7c + 0]
	ld c, a
	ld a, [wdc7c + 1]
	ld b, a
	ld a, h
	cp b
	jr nz, .asm_bfe
	ld a, l
	cp c
.asm_bfe
	jr nc, .asm_c25
	ld hl, wdc7e
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, de
	bit 7, h
	jr nz, .asm_c25
	ld a, [wdc80]
	ld e, a
	ld a, [wdc81]
	ld d, a
	ld a, h
	cp d
	jr nz, .asm_c20
	ld a, l
	cp e
.asm_c20
	jr nc, .asm_c25
	pop hl
	scf
	ret
.asm_c25
	pop hl
	and a
	ret

; returns de = d * e
DTimesE::
	ld a, d
	cp e ; d < e?
	jr c, ATimesE ; yes
	; d >= e, swap values
	ld a, e
	ld e, d
;	fallthrough

; returns de = a * e
; condition: a <= e
ATimesE:
	push hl
	ld d, 0
	ld h, d ; 0
	ld l, d ; 0
.loop
	srl a
	jr nc, .skip_add
	add hl, de
.skip_add
	sla e
	rl d
	and a
	jr nz, .loop
	ld d, h
	ld e, l
	pop hl
	ret

; outputs de = a * a
ASquared:
	cp 2
	jr c, .one
	ld e, a
	jr ATimesE
.one
	ld e, a
	ld d, $00
	ret

; outputs a = sqrt(de)
SquareRoot:
	push bc
	push hl
	ld hl, $4000
	ld b, l ; 0
	ld c, l ; 0
.loop
	push hl
	add hl, bc
	; hl += bc

	srl b
	rr c
	; bc /= 2

	; de < hl?
	ld a, d
	cp h
	jr nz, .check_condition
	ld a, e
	cp l
.check_condition
	jr c, .de_smaller_than_hl
	; de >= hl

	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, de
	ld d, h
	ld e, l
	; de -= hl

	pop hl
	ld a, c
	or l
	ld c, a
	ld a, b
	or h
	ld b, a
	; bc |= hl
	jr .next_iteration
.de_smaller_than_hl
	pop hl
.next_iteration
	srl h
	rr l
	srl h
	rr l
	; hl /= 4

	; hl == 0?
	ld a, h
	or l
	jr nz, .loop

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

SECTION "LoadDefaultPalettes", ROM0[$cc2]

LoadDefaultPalettes:
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
	ld [wFadeActive], a
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
	jp FlushCGBPalettes

.gb
	ld a, c
	ld hl, wDMGPals
	ld [hli], a ; wBGP
	ld [hli], a ; wOBP0
	ld [hl], a  ; wOBP1
	jp FlushDMGPalettes

; input:
; - a = fade speed
InitFade::
	ld [wFadeSpeed], a
	ld [wc67e], a
	ld a, TRUE
	ld [wFadeActive], a
	ret

UpdateFade:
	ld a, [wFadeActive]
	and a
	ret z
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb
	ld hl, wc67e
	dec [hl]
	ret nz ; no fade yet
	ld a, [wFadeSpeed]
	ld [hl], a
	ld hl, wDMGPals
	ld de, wTempDMGPals
	ld b, $03
	call Func_de7
	ld [wFadeActive], a
	jp FlushDMGPalettes

.cgb
	ld a, [wFadeSpeed]
	ld b, a
.loop
	push bc
	call .DoFadeStep
	pop bc
	and a
	jr z, .none_changed
	dec b
	jr nz, .loop
.none_changed
	ld [wFadeActive], a
	jp FlushCGBPalettes

.DoFadeStep:
	ld hl, wCGBPals
	ld de, wTempCGBPals
	ld b, 16 * PAL_COLORS ; 8 + 8 palettes
	jp FadePaletteFromHLToDE ; useless jump

; input:
; - hl = working palettes
; - de = final palettes
; - b  = number of colours
; output:
; - a = TRUE if any colours changed
FadePaletteFromHLToDE:
	xor a
	ld [wFadeColourChanged], a
.loop_cols
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
	jr z, .green
	and COLOR_RED
	ld e, a
	ld a, l
	and COLOR_RED
	cp e
	jr z, .green
	jr c, .inc_red
	dec a
	jr .got_red
.inc_red
	inc a
.got_red
	ld e, a
	ld a, l
	and COLOR_GREEN_LOW
	or e
	ld l, a
	ld a, TRUE
	ld [wFadeColourChanged], a

.green
	ld a, l
	rlca
	rlca
	rlca
	and COLOR_GREEN_LOW >> 5
	ld e, a
	ld a, h
	and COLOR_GREEN_HIGH
	add a
	add a
	add a ; << 3
	or e
	ld e, a
	ld a, c
	rlca
	rlca
	rlca
	and COLOR_GREEN_LOW >> 5
	ld d, a
	ld a, b
	and COLOR_GREEN_HIGH
	add a
	add a
	add a ; << 3
	or d
	cp e
	jr z, .blue
	jr c, .dec_green
	ld a, e
	inc a
	jr .got_green
.dec_green
	ld a, e
	dec a
.got_green
	ld e, a
	rrca
	rrca
	rrca
	and COLOR_GREEN_HIGH
	ld d, a
	ld a, h
	and ~COLOR_GREEN_HIGH
	or d
	ld h, a
	ld a, e
	rrca
	rrca
	rrca
	and COLOR_GREEN_LOW
	ld d, a
	ld a, l
	and COLOR_RED
	or d
	ld l, a
	ld a, TRUE
	ld [wFadeColourChanged], a

.blue
	ld a, b
	cp h
	jr z, .got_cols
	and COLOR_BLUE
	ld e, a
	ld a, h
	and COLOR_BLUE
	cp e
	jr z, .got_cols
	jr c, .inc_blue
	sub 1 << 2
	jr .got_blue
.inc_blue
	add 1 << 2
.got_blue
	ld e, a
	ld a, h
	and COLOR_GREEN_HIGH
	or e
	ld h, a
	ld a, TRUE
	ld [wFadeColourChanged], a

.got_cols
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
	jp nz, .loop_cols
	ld a, [wFadeColourChanged]
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

FlushCGBPalettes::
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
	db $3e, $01 ; MUSIC_TITLESCREEN
	db $3e, $02 ; MUSIC_MAIN_MENU
	db $3e, $03 ; MUSIC_BRIEFING
	db $3e, $04 ; MUSIC_MIAMI
	db $3e, $05 ; MUSIC_MISSION_COMPLETE
	db $3f, $01 ; MUSIC_LOS_ANGELES
	db $3f, $02 ; MUSIC_NEW_YORK
	db $3f, $03 ; MUSIC_MISSION_FAILED

Func_ef1:
	ld b, AUDIOFUNC_UNK4
	ld c, a
	jp AddToAudioQueue

; input:
; - a = SFX_* constant
PlaySFX::
	and a
	ret z
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc544]
	and a
	jr z, .skip
	ld b, AUDIOFUNC_PLAY_SFX
	call AddToAudioQueue
.skip
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
	ld b, AUDIOFUNC_UNK3
	call AddToAudioQueue
.asm_f1b
	pop hl
	pop de
	pop bc
	ret

Func_f1f::
	push af
	call Func_f0c
	pop af
	jp PlaySFX

; input:
; - a = MUSIC_* constant
PlayMusicIfNotPlaying::
	push hl
	ld hl, wc541
	cp [hl]
	pop hl
	ret z ; already playing
;	fallthrough

; input:
; - a = MUSIC_* constant
PlayMusic::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc545]
	and a
	jr z, .skip
	ld b, AUDIOFUNC_PLAY_MUSIC
	call AddToAudioQueue
.skip
	pop hl
	pop de
	pop bc
	ret

Func_f41:
	push af
	push bc
	push de
	push hl
	ld b, AUDIOFUNC_UNK2
	call AddToAudioQueue
	pop hl
	pop de
	pop bc
	pop af
	ret

; input:
; - b = AUDIOFUNC_* constant
; - c = argument to audio function
AddToAudioQueue:
	ld hl, wAudioQueueSize
	ld a, [hl]
	cp MAX_AUDIO_QUEUE_SIZE
	ret z ; no more space in queue

	; mark queue as invalid while pushing a new entry
	xor a
	ld [wAudioQueueValid], a

	; increment size
	inc [hl] ; wAudioQueueSize

	ld hl, wAudioQueueIterator
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], b ; function
	inc hl
	ld [hl], c ; argument
	inc hl
	ld a, l
	ld [wAudioQueueIterator + 0], a
	ld a, h
	ld [wAudioQueueIterator + 1], a

	; mark queue as valid again
	ld a, TRUE
	ld [wAudioQueueValid], a
	ret

ClearAudioQueue:
	ld de, wAudioQueue
	ld hl, wAudioQueueIterator
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld [wAudioQueueSize], a
	ret

UpdateAudio:
	; process audio queue
	ld a, [wAudioQueueValid]
	and a
	jr z, .skip_queue ; not valid

	ld a, [wAudioQueueSize]
	and a
	jr z, .skip_queue ; no entries

	ld hl, wAudioQueue
	ld b, a ; num of entries
.loop_entries
	push bc
	ld a, [hli]
	ld c, [hl]
	push hl
	ld de, .return
	push de
	jumptable
	dw Func_fba  ; AUDIOFUNC_PLAY_SFX
	dw Func_fd3  ; AUDIOFUNC_PLAY_MUSIC
	dw Func_1009 ; AUDIOFUNC_UNK2
	dw Func_1010 ; AUDIOFUNC_UNK3
	dw Func_101e ; AUDIOFUNC_UNK4
.return
	pop hl
	pop bc
	inc hl
	dec b
	jr nz, .loop_entries
	call ClearAudioQueue

.skip_queue
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
	call SetAudioBank
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
	call SetAudioBank
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

; input:
; - c = audio bank to switch to
SetAudioBank:
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
	ld [wAudioQueueValid], a
	ld [wAudioBank], a
	ld [wc541], a
	jp ClearAudioQueue

GetStructWord_BC::
	push hl
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	ret

SetStructWord_BC::
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

AddStructWord_BC:
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

AddStructWord_DE::
	push hl
	add_hl
	call Func_10b0
	pop hl
	ret
; 0x10c1

SECTION "GetStructWord_DE", ROM0[$10d0]

GetStructWord_DE::
	push hl
	add_hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret

SetStructWord_DE::
	push hl
	add_hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ret

GetStructByte_A::
	push hl
	add_hl
	ld a, [hl]
	pop hl
	ret

GetStructByte_C::
	push hl
	add_hl
	ld c, [hl]
	pop hl
	ret

GetStructByte_B::
	push hl
	add_hl
	ld b, [hl]
	pop hl
	ret

GetStructByte_E::
	push hl
	add_hl
	ld e, [hl]
	pop hl
	ret

GetStructByte_D::
	push hl
	add_hl
	ld d, [hl]
	pop hl
	ret

SetStructByte_C::
	push hl
	add_hl
	ld [hl], c
	pop hl
	ret

SetStructByte_B::
	push hl
	add_hl
	ld [hl], b
	pop hl
	ret
; 0x1101

SECTION "Func_110b", ROM0[$110b]

Func_110b::
	ld hl, wd551
	ld bc, NUM_WDC32_STRUCTS * WDC32_STRUCT_SIZE
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
	ld de, WDC32_STRUCT_SIZE
	ld b, NUM_WDC32_STRUCTS
.loop
	bit WDC32FLAG_ACTIVE_F, [hl]
	jr z, .found
	add hl, de
	dec b
	jr nz, .loop
	pop bc
	pop hl
	scf
	ret
.found
	ld [hl], WDC32FLAG_ACTIVE
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

Func_1147::
	ld a, [wd54d]
	and a
	ret z

	call ClearSprites

	ld a, [wd54c]
	and a
	jr z, .asm_116d

	ld hl, wd551
	ld b, NUM_WDC32_STRUCTS
.loop
	ld a, [hl]
	and WDC32FLAG_ACTIVE | WDC32FLAG_UNK1
	cp WDC32FLAG_ACTIVE | WDC32FLAG_UNK1
	jr nz, .next
	push bc
	call Func_1186
	pop bc
.next
	ld de, WDC32_STRUCT_SIZE
	add hl, de
	dec b
	jr nz, .loop

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
	ld [wSpriteFlags], a
	inc hl
	and WDC32FLAG_UNK2
	jr z, .asm_11e6
	ld d, h
	ld e, l

	ld hl, wd7fd
	ld a, [de] ; WDC32STRUCT_Y
	sub [hl] ; wd7fd
	ld b, a
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jr z, .asm_11b3
	cp -1
	jp nz, .asm_1242
	push de
	ld a, WDC32STRUCT_UNK07 - (WDC32STRUCT_Y + 1)
	add_de
	ld a, [de] ; WDC32STRUCT_UNK07
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
	add OAM_Y_OFS
	ld b, a
	inc de
	inc de
	inc hl

	ld a, [de] ; WDC32STRUCT_X
	sub [hl] ; wd7ff
	ld c, a
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jr z, .asm_11da
	cp -1
	jr nz, .asm_1242
	push de
	ld a, WDC32STRUCT_UNK08 - (WDC32STRUCT_X + 1)
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
	cp SCREEN_WIDTH_PX
	jr nc, .asm_1242
.asm_11df
	add OAM_X_OFS
	ld c, a
	ld h, d
	ld l, e
	jr .asm_11f0
.asm_11e6
	ld a, [hli]
	add OAM_Y_OFS
	ld b, a
	inc hl
	inc hl
	ld a, [hli]
	add OAM_X_OFS
	ld c, a
.asm_11f0
	inc hl
	ld a, [hli] ; WDC32STRUCT_UNK07
	swap a
	ld d, a
	ld a, [hli] ; WDC32STRUCT_UNK08
	rrca
	rrca
	ld e, a ; /4
	rrca
	ld [wd54b], a ; /8
	ld a, [wSpriteFlags]
	and WDC32FLAG_UNK7
	call nz, Func_1315
	ld a, [wSpriteFlags]
	and WDC32FLAG_UNK4
	jr z, .asm_120f
	ld a, [hli] ; WDC32STRUCT_UNK09
	ld h, [hl]
	ld l, a
.asm_120f
	ld a, d
	cp $01
	jr nz, .asm_1219
	ld a, e
	cp $02
	jr z, .screen_check
.asm_1219
	ld a, [wSpriteFlags]
	and WDC32FLAG_XFLIP | WDC32FLAG_YFLIP
	call nz, Func_1338
	xor a
	ld [wd548], a
.asm_1225
	ld a, b
	cp SCREEN_HEIGHT_PX
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
	res WDC32FLAG_UNK3_F, [hl]
	ret

.asm_1242
	pop hl
	set WDC32FLAG_UNK3_F, [hl]
	ret

.screen_check
	ld a, [wSpriteFlags]
	and WDC32FLAG_UNK2
	jr nz, .skip_screen_check

	; are we inside screen coordinates?
	ld a, b
	and a
	jr z, .asm_1242
	cp SCREEN_HEIGHT_PX + OAM_Y_OFS
	jr nc, .asm_1242
	ld a, c
	and a
	jr z, .asm_1242
	cp SCREEN_WIDTH_PX + OAM_X_OFS
	jr nc, .asm_1242

.skip_screen_check
	ld a, [hli]
	bit 0, a
	jr nz, .asm_123e
	ld e, a ; tile ID

	ld a, [wSpriteFlags]
	and WDC32FLAG_XFLIP | WDC32FLAG_YFLIP
	xor [hl]
	ld d, a ; attributes

	ld a, b
	swap a
	and $0f
	add a ; /8
	add LOW(OAMGroupTable)
	ld l, a
	ld a, HIGH(OAMGroupTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl] ; OAM count
	cp OAM_GROUP_SIZE
	jr nc, .asm_123e ; already full

	; add to OAM array
	inc [hl]
	inc hl
	add a
	add a ; *OBJ_SIZE
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld [hl], b ; y
	inc hl
	ld [hl], c ; x
	inc hl
	ld [hl], e ; tile ID
	inc hl
	ld [hl], d ; attributes
	jr .asm_123e

; a = screen y
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
	add a ; /8
	add LOW(OAMGroupTable)
	ld l, a
	ld a, HIGH(OAMGroupTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	ld [wTempOAMY], a
	ld a, c
	ld [wTempOAMX], a
	ld b, h
	ld c, l
	ld a, [hli]
	add a
	add a
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a

	ld a, [wd54b]
.loop
	push af
	ld a, [bc]
	cp OAM_GROUP_SIZE
	jr z, .done_pop_af
	; group not full
	ld a, [wTempOAMX]
	and a
	jr z, .next
	cp SCREEN_WIDTH_PX + OAM_X_OFS
	jr nc, .next
	ld a, $01
	ld [wd548], a
	ld a, [de]
	bit 0, a
	jr nz, .next
	ld a, [wTempOAMY]
	ld [hli], a ; y
	ld a, [wTempOAMX]
	ld [hli], a ; x
	ld a, [de]
	ld [hli], a ; tile ID
	inc de
	ld a, [de]
	ld [hli], a ; attributes
	dec de
	ld a, [bc]
	inc a
	ld [bc], a
.next
	inc de
	inc de
	ld a, [wTempOAMX]
	add 8
	ld [wTempOAMX], a
	pop af
	dec a
	jr nz, .loop
.done
	pop hl
	pop de
	pop bc
	ld a, b
	ret
.done_pop_af
	pop af
	jr .done

OAMGroupTable:
	FOR n, 1, NUM_OAM_GROUPS + 1
		dw wOAMGroup{u:n}
	ENDR

; input:
; - e = ?
; - b = OAM y
; - c = OAM x
Func_1315:
	push bc
	push de
	push hl
	ld a, e
	cp $02
	jr z, .subtract_y
	; add 4 px to x
	ld a, c
	add 4
	ld c, a
.subtract_y
	; subtract 4 px from y
	ld a, b
	sub 4
	ld b, a
	lb de, 2 | OAM_BANK1, $70
	ld a, [wc57a]
	and $04
	jr z, .asm_1331
	ld d, 3 | OAM_BANK1 | OAM_XFLIP
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
	ld bc, wGfxBuffer
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
	ld hl, wGfxBuffer
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

; input:
; - b = screen y
; - c = screen x
; - e = tile id
; - d = attributes
Func_1393::
	ld a, c
	add OAM_X_OFS
	ld c, a
	ld a, b
	add OAM_Y_OFS
	ld b, a
;	fallthrough

; input:
; - b = OAM y
; - c = OAM x
; - e = tile id
; - d = attributes
Func_139b:
	; first test if it's inside screen
	ld a, b
	and a
	ret z
	cp SCREEN_HEIGHT_PX + OAM_Y_OFS
	ret nc
	ld a, c
	and a
	ret z
	cp SCREEN_WIDTH_PX + OAM_X_OFS
	ret nc

	; is inside, continue
	ld a, b
	swap a
	and $0f
	add a ; /8
	add LOW(OAMGroupTable)
	ld l, a
	ld a, HIGH(OAMGroupTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl] ; OAM count
	cp OAM_GROUP_SIZE
	ret nc ; already full
	inc [hl]
	inc hl
	add a
	add a ; *OBJ_SIZE
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld [hl], b ; y
	inc hl
	ld [hl], c ; x
	inc hl
	ld [hl], e ; tile ID
	inc hl
	ld [hl], d ; attributes
	ret

; zeroes out wOAMGroups
ClearSprites:
	ld hl, wOAMGroups
	ld de, OAM_GROUP_STRUCT_SIZE
	ld b, NUM_OAM_GROUPS
	xor a
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

; goes through wOAMGroups and loads them into Virtual OAM
LoadSprites:
	ld a, [wActiveVirtualOAM]
	ld d, a
	ld e, 0
	ld hl, wOAMGroups
	ld b, NUM_OAM_GROUPS
.loop_sprites
	ld a, [hl]
	and a
	jr nz, .asm_1401
.next_sprite
	ld a, OAM_GROUP_STRUCT_SIZE
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

; input:
; - a = CARSTRUCT_* constant
Func_146c::
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

ClearEntities::
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

; returns in hl pointer to entity with ENT_UNK05 == a
; if found, return carry, otherwise no carry
; input:
; - a = ?
FindEntity::
	push bc
	push de
	ld c, a
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit ENTF_ACTIVE_F, [hl] ; ENT_FLAGS
	jr z, .inactive
	ld a, ENT_UNK05
	add_hl
	ld a, c
	cp [hl]
	jr z, .found
	ld a, ENT_UNK05
	sub_hl
.inactive
	add hl, de
	dec b
	jr nz, .loop
	pop de
	pop bc
	and a
	ret
.found
	pop de
	pop bc
	ld a, ENT_UNK05
	sub_hl
	scf
	ret

UpdateEntities::
	ldh a, [hROMBank]
	push af
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit ENTF_ACTIVE_F, [hl] ; ENT_FLAGS
	call nz, .Update
	add hl, de
	dec b
	jr nz, .loop
	pop af
	bankswitch
	ret

.Update:
	inc hl
	dec [hl] ; ENT_UPDATE_TIMER
	dec hl
	ret nz
	push bc
	push de
	push hl
	call StartEntityUpdate
	pop hl
	pop de
	pop bc
	ret

; expected to be called after StartEntityUpdate
; pauses current entity update function and resumes normal code execution
; sets entity's stack pointer so that next update call is set to callee
; input:
; - a = update timer for next update
YieldEntityUpdate::
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
	ld [de], a ; ENT_UPDATE_TIMER
	inc de
	ldh a, [hROMBank]
	ld [de], a ; ENT_UPDATE_FUNC_BANK
	inc de
	ld hl, sp+$00
	ld a, l
	ld [de], a ; ENT_STACK_POINTER
	inc de     ;
	ld a, h    ;
	ld [de], a ;

	; resume main sp
	ld hl, wTempSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ret

; starts update of entity given in hl
; expects YieldEntityUpdate to be called when finished
; temporarily sets sp to ENT_STACK_POINTER
StartEntityUpdate:
	ld a, l
	ld [wEntityPtr + 0], a
	ld a, h
	ld [wEntityPtr + 1], a
	inc hl
	inc hl
	ld a, [hli] ; ENT_UPDATE_FUNC_BANK
	bankswitch
	ld a, [hli] ; ENT_STACK_POINTER
	ld h, [hl]  ;
	ld l, a
	ld [wTempSP], sp
	ld sp, hl
	pop hl
	pop de
	pop bc
	ret

DespawnEntity::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $00
	ld hl, wTempSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ret

; input:
; - c:hl = update function
; - b  = ?
SpawnEntity::
	push hl
	ld a, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit ENTF_ACTIVE_F, [hl] ; ENT_FLAGS
	jr z, .inactive
	add hl, de
	dec a
	jr nz, .loop
	pop hl
	scf
	ret

.inactive
	ld [hl], ENTF_ACTIVE ; ENT_FLAGS
	inc hl
	ld [hl], 1 ; ENT_UPDATE_TIMER
	inc hl
	ld [hl], c ; ENT_UPDATE_FUNC_BANK
	inc hl
	; loads ENT_UNK50 address to ENT_STACK_POINTER
	ld d, h
	ld e, l
	ld a, ENT_UNK50 - ENT_STACK_POINTER
	add_de
	ld [hl], e ; ENT_STACK_POINTER
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

; input:
; - hl    = entity
; - a:de  = ?
Func_1569::
	inc hl
	ld [hl], 1 ; ENT_UPDATE_TIMER
	inc hl
	ld [hli], a ; ENT_UPDATE_FUNC_BANK
	push de
	ld d, h
	ld e, l
	ld a, ENT_UNK4F - ENT_UPDATE_FUNC_BANK
	add_de
	; write ENT_UNK4F address to ENT_STACK_POINTER
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, (ENT_UNK56 + 1) - (ENT_STACK_POINTER + 1)
	add_hl
	pop de ; input de
	ld [hl], d ; ENT_UNK56
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

Func_1591::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

GetEntityCarPtr::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, ENT_CAR_PTR
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

YieldEntityUpdate_BCTimes:
	ld a, c
	call YieldEntityUpdate
	ld a, b
	and a
.loop
	ret z
	xor a
	call YieldEntityUpdate
	dec b
	jr .loop

YieldEntityUpdateIndefinitely::
.loop
	ld bc, -1 ; max duration
	call YieldEntityUpdate_BCTimes
	jr .loop

Func_15bb:
	xor a
	ld [wResetDisabled], a

	call SetDefaultPlayerCar

	ld a, NEW_YORK
	ld [wCity], a

	ld a, $00
	ld [wd822], a
	ld a, MODE_UNDERCOVER
	ld [wGameMode], a
	ld a, MISSION_THE_BANK_JOB
	ld [wMission], a

	call Func_1692

.titlescreen
	homecall Titlescreen
	jr .asm_15ef
.main_menu
	homecall MainMenu
.asm_15ef
	call Func_1692
	homecall Func_90aa
	call Func_16a8

	ld a, $00
	ld [wd820], a
	ld a, $00
	ld [wd895], a
	xor a
	ld [wc57a], a
	ld [wc579], a
.asm_1610
	call PostVBlank
	ld a, [wd820]
	cp $03
	jr z, .asm_1669
	call Func_1142
	call Func_1c57
	call Func_1c7b
	ld a, [wc579]
	and a
	jr nz, .asm_164d
	call UpdateEntities
	call Func_23d1
	call Func_332a
	homecall Func_5471
	homecall Func_642c
	call Func_1eee
	ld hl, wc57a
	inc [hl]
.asm_164d
	homecall Func_8162
	homecall Func_859d
	call Func_1a71
	call Func_1147
	jr .asm_1610

.asm_1669
	ld a, [wGameMode]
	cp MODE_CREDITS
	jr z, .asm_1684
	ld a, NONE
	call PlayMusic
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
	jp z, .main_menu
	jp .titlescreen

Func_1692::
	ld a, [wMission]
	cp LOS_ANGELES_MISSIONS
	ret c
	ld b, $02
	cp NEW_YORK_MISSIONS
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
	ld [wDamageMultiplier], a

	ld a, $01
	bankswitch
	call Func_16e2

	call Func_1b4e

	ld a, $01
	bankswitch
	call Func_178e
	ret

Func_16e2:
	ld a, [wGameMode]
	jumptable
	dw Func_16f4 ; MODE_TAKE_A_RIDE
	dw Func_1735 ; MODE_CHECKPOINT
	dw Func_1748 ; MODE_GET_AWAY
	dw Func_175b ; MODE_PURSUIT
	dw Func_176e ; MODE_SURVIVAL
	dw Func_1784 ; MODE_UNDERCOVER
	dw Func_18c5 ; MODE_CREDITS

Func_16f4:
	call Func_1972
	ld a, [wCity]
	call SetCity
	ld a, $00
	ld [wd827], a
	ld a, [wPlayerCar]
	ld c, a
	cp CAR_00
	jr z, .asm_172b
	cp CAR_01
	jr z, .asm_172b
	cp CAR_08
	jr z, .asm_172b
	ld a, $02
	ld [wd827], a
	ld a, c
	cp CAR_07
	jr z, .asm_172b
	ld a, $05
	ld [wd827], a
	ld a, c
	cp CAR_02
	jr z, .asm_172b
	ld a, $01
	ld [wd827], a
.asm_172b
	ld hl, Data_7e88
	call Func_1946
	call Func_1a2e
	ret

Func_1735:
	call Func_1977
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	call Func_1937
	call Func_1a2e
	ret

Func_1748:
	call Func_1972
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	call Func_193c
	call Func_1a2e
	ret

Func_175b:
	call Func_1977
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	call Func_1941
	call Func_1a2e
	ret

Func_176e:
	call Func_1972
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	ld hl, $7e9d
	call Func_1946
	call Func_1a2e
	ret

Func_1784:
	ld a, BANK(Func_6921)
	bankswitch
	jp Func_6921

Func_178e:
	ld a, [wGameMode]
	jumptable
	dw Func_17a0 ; MODE_TAKE_A_RIDE
	dw Func_17b4 ; MODE_CHECKPOINT
	dw Func_1808 ; MODE_GET_AWAY
	dw Func_184b ; MODE_PURSUIT
	dw Func_1899 ; MODE_SURVIVAL
	dw Func_18bb ; MODE_UNDERCOVER
	dw Func_190f ; MODE_CREDITS

Func_17a0:
	call Func_1ed4
	ld hl, Data_1f37
	call Func_1eda
	ld hl, Func_65a9
	ld c, BANK(Func_65a9)
	ld b, $0b
	call SpawnEntity
	ret

Func_17b4:
	ld a, $01
	vramswitch
	ld hl, $505d
	ld de, v0Tiles1 tile $4a
	ld c, $34
	ld b, $10
	call SafeCopyFarTiles
	ld hl, $7efd
	ld de, v0Tiles1 tile $5a
	ld c, $35
	ld b, $0a
	call SafeCopyFarTiles
	ld a, $00
	vramswitch

	call Func_1ed4
	ld hl, $0
	call Func_1eda
	call Func_1928
	call Func_1937
	ld a, $05
	add_hl
	ld de, wd83d
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	xor a
	ld [wd892], a
	ld c, $01
	call Func_195e
	ld hl, Func_65b4
	ld c, BANK(Func_65b4)
	ld b, $0b
	call SpawnEntity
	ret

Func_1808:
	call Func_1ed4
	ld hl, $0
	call Func_1eda
	ld a, $01
	ld [wd839], a
	ld a, 14
	ld [wFelony], a
	xor a
	ld [wda7b], a
	call Func_1928
	ld c, $02
	call Func_195e
	ld hl, Func_5805
	ld c, BANK(Func_5805)
	ld b, $05
	call SpawnEntity
	push hl
	call Func_193c
	ld a, $05
	add_hl
	ld d, h
	ld e, l
	pop hl
	ld a, $06
	call SetStructWord_DE
	ld hl, Func_66fa
	ld c, BANK(Func_66fa)
	ld b, $0b
	call SpawnEntity
	ret

Func_184b:
	ld a, $04
	ld [wd82d], a
	ld hl, $0
	call Func_1eda
	xor a
	ld [wd86c], a
	ld [wda7b], a
	call Func_1928
	ld c, $03
	call Func_195e

	call Func_1941
	ld a, $05
	add_hl
	ld e, [hl] ; palette ptr
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl] ; car
	push hl
	ld h, d
	ld l, e
	call Func_1ced
	pop hl
	homecall Func_5bce

	ld a, $02
	ld [wda76], a
	ld a, l
	ld [wDestinationCoords + 0], a
	ld a, h
	ld [wDestinationCoords + 1], a
	ld hl, Func_6732
	ld c, BANK(Func_6732)
	ld b, $0b
	call SpawnEntity
	ret

Func_1899:
	xor a
	ld [wd82d], a
	ld hl, $0
	call Func_1eda
	ld a, MAX_FELONY
	ld [wFelony], a
	call Func_1928
	ld c, $04
	call Func_195e
	ld hl, Func_67aa
	ld c, BANK(Func_67aa)
	ld b, $0b
	call SpawnEntity
	ret

Func_18bb:
	ld a, BANK(Func_6926)
	bankswitch
	jp Func_6926

Func_18c5:
	ld a, [wdc8e]
	ld [wCity], a
	ld a, CAR_00
	ld [wPlayerCar], a
	ld a, $00
	ld [wd827], a
	call Func_1972
	ld a, [wCity]
	call SetCity
	ld hl, $7e73
	call Func_1946
	call Func_1a2e
	ld hl, $71ae
	ld a, [wdc8f]
	and $01
	jr z, .asm_18f4
	ld hl, $7354
.asm_18f4
	ld a, l
	ld [wdc93], a
	ld a, h
	ld [wdc94], a
	ld hl, wdc8f
	ld a, [hl]
	xor $01
	ld [hl], a
	ld hl, wdc8e
	ld a, [hl]
	inc a
	cp $03
	jr c, .asm_190d
	xor a
.asm_190d
	ld [hl], a
	ret

Func_190f:
	call Func_1ed4
	ld hl, Data_1f37
	call Func_1eda
	ld a, MAX_FELONY
	ld [wFelony], a
	ld hl, Func_7c17
	ld c, BANK(Func_7c17)
	ld b, $0b
	call SpawnEntity
	ret

Func_1928:
	call Func_1a43
	ld de, wd88c
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

Func_1937:
	ld hl, Data_7d05
	jr Func_194f
Func_193c:
	ld hl, $7dbf
	jr Func_194f
Func_1941:
	ld hl, Data_7e07
	jr Func_194f

Func_1946:
	ld a, [wCity]
	add a ; *2
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_194f:
	ld a, [wCity]
	add a
	add a ; *4
	add_hl
	ld a, [wd822]
	add a ; *2
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_195e::
	ldh a, [hROMBank]
	push af
	homecall Func_83b2
	pop af
	bankswitch
	ret

Func_1972::
	ld hl, Data_1f97
	jr Func_197c
Func_1977::
	ld hl, Data_1f67
	jr Func_197c ; useless jump
Func_197c:
	call Random
	and $03
	add a
	add a
	ld c, a
	add a
	add c ; *12
	add_hl
Func_1987::
	ld de, wda83
	ld b, $0c
	jp CopyHLtoDE

Func_198f:
	ld a, [wGameMode]
	jumptable
	dw .TakeARide  ; MODE_TAKE_A_RIDE
	dw .Func_19ab ; MODE_CHECKPOINT
	dw .Func_19ab ; MODE_GET_AWAY
	dw .Func_19ab ; MODE_PURSUIT
	dw .Func_19ab ; MODE_SURVIVAL
	dw .Undercover ; MODE_UNDERCOVER
	dw .Credits    ; MODE_CREDITS

.Credits:
	ld a, [wdcb5]
	and a
	jr z, .asm_1a0f
	jr .asm_1a0c
.TakeARide:
	jr .asm_1a0c
.Func_19ab:
	ld a, [wTitlescreenTransition]
	cp $02
	jr nz, .asm_19c0
	call Func_1a43
	ld de, wd88c
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
.asm_19c0
	homecall Func_8f78
	ld a, [wd898]
	and a
	jr z, .asm_1a0c
	jr .asm_1a0a

.Undercover:
	ld a, [wTitlescreenTransition]
	cp $02
	jr nz, .asm_19c0
	call .Func_19ec
	ld hl, wMission
	ld a, [hl]
	inc a
	cp NUM_MISSIONS
	jr c, .asm_19e9
	ld [hl], NUM_MISSIONS - 1
	jr .asm_1a0f
.asm_19e9
	ld [hl], a
	jr .asm_1a0a

.Func_19ec:
	ld a, [wMission]
	ld c, $00
	cp LOS_ANGELES_MISSIONS - 1
	jr z, .asm_1a00
	ld c, $01
	cp NEW_YORK_MISSIONS - 1
	jr z, .asm_1a00
	ld c, $02
	cp NUM_MISSIONS - 1
	ret nz
.asm_1a00
	ld a, BANK(Func_92b5)
	bankswitch
	jp Func_92b5

.asm_1a0a
	xor a
	ret
.asm_1a0c
	ld a, $01
	ret
.asm_1a0f
	ld a, $02
	ret

; sets the default car as the car driven by the player
SetDefaultPlayerCar::
	ld a, CAR_00
	ld [wPlayerCar], a
	ld a, $00
	ld [wd827], a
	ret

; set city to be played, and loads data related to it
; input:
; - a = city
SetCity::
	ld [wCity], a
	add a ; *2
	ld hl, Data_7c48
	add_hl
	ld de, wd824
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

Func_1a2e::
	ld a, [hli]
	ld [wd828], a
	ld a, [hli]
	ld [wd829], a
	ld a, [hli]
	ld [wd82a], a
	ld a, [hli]
	ld [wd82b], a
	ld a, [hl]
	ld [wd82c], a
	ret

Func_1a43:
	ld a, [wGameMode]
	cp MODE_SURVIVAL
	jr z, .asm_1a66
	sub $01
	ld hl, wdc39
	add a
	ld c, a
	add a
	add a
	add a
	add c
	add_hl
	ld a, [wCity]
	add a
	ld c, a
	add a
	add c
	add_hl
	ld a, [wd822]
	ld c, a
	add a
	add c
	add_hl
	ret
.asm_1a66
	ld hl, wdc6f
	ld a, [wCity]
	ld c, a
	add a
	add c
	add_hl
	ret

Func_1a71:
	ld hl, wc683
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_1b3d
	jr nc, .asm_1a85
	xor a
	ld [hli], a ; SCX
	ld [hli], a ; SCY
	ld a, LCDC_BG_9C00
	ld [hli], a ; LCDC
	ld a, 8
	ld [hli], a ; LYC
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
	ld a, [wGameMode]
	cp MODE_CREDITS
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
	call ClearVRAMTiles
	call Func_110b
	call ClearEntities
	call Func_25e5
	call Func_3565
	call Func_1d16
	call Func_2026
	call Func_32fb
	homecall LoadHUD

	ld hl, Func_4988
	ld c, BANK(Func_4988)
	ld b, $03
	call SpawnEntity

	homecall Func_4000

	ld hl, Func_42e1
	ld c, BANK(Func_42e1)
	ld b, $02
	call SpawnEntity
	ld a, [wPlayerCarPtr + 0]
	ld e, a
	ld a, [wPlayerCarPtr + 1]
	ld d, a
	ld a, ENT_CAR_PTR
	call SetStructWord_DE

	xor a
	ld [wda76], a

	ld hl, Func_5f27
	ld c, BANK(Func_5f27)
	ld b, $07
	call SpawnEntity

	ld hl, Func_5e97
	ld c, BANK(Func_5e97)
	ld b, $08
	call SpawnEntity

	ld a, [wGameMode]
	cp MODE_CREDITS
	jr z, .skip_music
	call Func_f41
	ld a, [wCity]
	ld hl, .MusicIDs
	add_hl
	ld a, [hl]
	call PlayMusic
.skip_music
	ld a, $01
	jp InitFade

.MusicIDs:
	db MUSIC_MIAMI       ; MIAMI
	db MUSIC_LOS_ANGELES ; LOS_ANGELES
	db MUSIC_NEW_YORK    ; NEW_YORK

; sets timer to b minutes and c seconds
; and timer mode given in a
StartTimer::
	push hl
	ld [wTimerMode], a
	ld a, TRUE
	ld [wTimerActive], a
	ld hl, wTimer
	ld [hl], $00
	inc hl
	ld [hl], c ; seconds
	inc hl
	ld [hl], b ; minutes
	pop hl
	ret

UpdateTimer::
	push hl
	ld a, [wTimerActive]
	and a
	jr z, .done
	ld a, [wTimerMode]
	and a
	jr z, .done
	cp TIMER_MODE_COUNT_UP
	jr z, .tick_up
; tick down
	call .TickDownTimer
	jr .done
.tick_up
	call .TickUpTimer
.done
	pop hl
	ret

.TickDownTimer:
	; subtract 3 from hundredth of seconds
	ld hl, wTimer
	ld a, [hl]
	sub $3
	daa
	ld [hl], a
	ret nc
	; hundredths are zero, are we still counting down?
	inc hl
	ld a, [hli] ; seconds
	or [hl] ; minutes
	jr nz, .decrement_minute
	xor a
	ld [wTimer], a ; hundredths
	ld [wTimerActive], a
	ret
.decrement_minute
	ld hl, wTimer + $1
	ld a, [hl] ; minutes
	and a
	jr nz, .decrement
	; roll back to 59 seconds
	ld [hl], $59
	inc hl
	ld a, [hl]
.decrement
	; decrement second/minute
	sub $1
	daa
	ld [hl], a
	ret

.TickUpTimer:
	; add 3 to hundredth of seconds
	ld hl, wTimer
	ld a, [hl]
	add $3
	daa
	ld [hl], a
	ret nc
	; hundredths overflow, increment minute
	inc hl
	ld a, [hli]
	cp $59
	jr nz, .not_at_max
	ld a, [hl]
	cp $59
	jr nz, .not_at_max
	; at maximum time, keep hundredths of seconds at 99
	ld a, $99
	ld [wTimer], a
	xor a
	ld [wTimerActive], a
	ret
.not_at_max
	ld hl, wTimer + $1
	ld a, [hl] ; seconds
	cp $59
	jr nz, .increment
	ld [hl], $00
	inc hl
	ld a, [hl]
.increment
	add $1
	daa
	ld [hl], a
	ret
; 0x1c57

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

	ld a, [wActiveCheats]
	and CHEAT_TEST_STUFF
	ret z
	ld a, [wFadeActive]
	and a
	ret nz
	ld a, [wJoypadPressed]
	and PAD_SELECT
	call nz, ToggleDebugMode
	ret

Func_1c7b:
	ld a, [wGameMode]
	cp MODE_CREDITS
	ret z
	ld a, [wFadeActive]
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
	ld [wActiveCheats], a
	ld a, $01
	ld [wdc33], a

	; set default language
	ld a, ENGLISH
	ld [wLanguage], a

	ld a, $01
	ld [wdc31], a
	ld a, $01
	ld [wc544], a
	ld a, $01
	ld [wc545], a
	xor a
	ld [wMission], a
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

; input:
; - a  = CAR_* constant
; - hl = palette to load (can be NULL)
Func_1ced::
	push hl
	ld c, a
	ld a, $48
	ld [wVRAMNumTiles_v1_8800], a
	ld b, V1TILES_8800
	call LoadCarGfx
	pop hl

	ld a, h
	or l
	ret z ; no palette
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	ld de, wTempOBPals palette 1
	ld b, 1 palettes
	call CopyHLtoDE
	pop af
	bankswitch
	ret

Func_1d16:
	ld hl, wda83
	ld b, $04
.asm_1d1b
	ld a, [hli]
	push bc
	ld b, V0TILES_8000
	call Func_1e38
	pop bc
	dec b
	jr nz, .asm_1d1b

	ld a, [wPlayerCar]
	ld b, V1TILES_8000
	call Func_1e38

	ld a, $01
	bankswitch
	ld hl, wd824
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK("VRAM1")
	vramswitch
	ld b, NUM_CITY_PROPS
.loop_load_props
	push bc
	ld a, [hli] ; which prop to load
	push hl
	add a ; *2
	ld c, a
	ld hl, wdbdb
	add_hl
	ld a, [wVRAMNumTiles_v1_8000]
	ld [hli], a
	ld a, $08
	ld [hl], a
	ld a, c
	add a
	ld hl, Data_382c
	add_hl
	ld b, [hl] ; num tiles
	inc hl
	ld c, [hl] ; bank
	inc hl
	ld a, [hli] ; pointer
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wVRAMNumTiles_v1_8000]
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
	ld a, [wVRAMNumTiles_v1_8000]
	add b
	add b ; *2
	ld [wVRAMNumTiles_v1_8000], a
	xor a
	call CopyTilesWithAlternatingBlackTiles
	pop hl
	pop bc
	dec b
	jr nz, .loop_load_props
	ld a, BANK("VRAM0")
	vramswitch

	ld de, wTempOBPals
	ld b, 8 ; palettes
.loop_load_pals
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
	ld b, PAL_SIZE
.loop_pal_copy
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop_pal_copy
	pop af
	bankswitch
	pop hl
	pop bc
	dec b
	jr nz, .loop_load_pals

	ld a, [wPlayerCar]
	cp CAR_06
	jr nz, .asm_1dd7
	push hl
	ldh a, [hROMBank]
	push af
	ld a, BANK(Pals_f644)
	bankswitch
	ld hl, Pals_f644 palette 7
	ld de, wTempOBPals palette 1
	ld b, 1 palettes
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
	ld hl, Data_3864
	ld de, wdbdb + 1
	ld b, NUM_CITY_PROPS + 6
.asm_1deb
	ld a, [de]
	or [hl]
	ld [de], a
	inc hl
	inc de
	inc de
	dec b
	jr nz, .asm_1deb

	ld a, BANK("VRAM1")
	vramswitch
	ld de, v1Tiles0 tile $70
	ld hl, Gfx_c7ff0
	ld c, BANK(Gfx_c7ff0)
	ld b, 1 ; tile
	ld a, 1
	call CopyTilesWithAlternatingBlackTiles

	ld de, v1Tiles0 tile $72
	ld hl, Gfx_d115d
	ld c, BANK(Gfx_d115d)
	ld b, 4 ; tiles
	xor a
	call CopyTilesWithAlternatingBlackTiles

	ld de, v1Tiles0 tile $7a
	ld hl, Gfx_d0f5d
	ld c, BANK(Gfx_d0f5d)
	ld b, 4 ; tiles
	call SafeCopyFarTiles

	ld de, v1Tiles1 tile $68
	ld hl, Gfx_d0f9d
	ld c, BANK(Gfx_d0f9d)
	ld b, 12 ; tiles
	call SafeCopyFarTiles
	ld a, BANK("VRAM0")
	vramswitch
	ret

; input:
; - a  = CAR_* constant
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
Func_1e38:
	push hl
	ld c, a
	call LoadCarGfx
	pop hl
	ret

YieldEntityUpdateUntilFadeEnds::
.loop
	ld a, [wFadeActive]
	and a
	ret z
	ld a, 1
	call YieldEntityUpdate
	jr .loop

; input:
; - hl = texts pointer
GetText1::
	ldh a, [hROMBank]
	push af
	ld a, BANK("Texts 1")
	bankswitch
	jr _GetTextCommon

; input:
; - hl = texts pointer
GetText2::
	ldh a, [hROMBank]
	push af
	ld a, BANK("Texts 2")
	bankswitch
;	fallthrough

_GetTextCommon:
	ld a, [wLanguage]
	add a ; *2
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	ld de, wTextBuffer
.loop_copy
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .loop_copy
	pop de
	ld hl, wTextBuffer
	pop af
	bankswitch
	ret

Func_1e7e::
	ldh a, [hROMBank]
	push af
	ld a, $3c
	bankswitch
	ld hl, wdc93
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, [hl]
	jr z, .asm_1e96
	ld b, [hl]
	inc hl
	jr .asm_1eae
.asm_1e96
	ld de, wTextBuffer
	ld b, $00
.asm_1e9b
	ld a, [hli]
	and a
	jr z, .asm_1ea4
	ld [de], a
	inc de
	inc b
	jr .asm_1e9b
.asm_1ea4
	ld a, b
	and a
	jr z, .asm_1eb6
	cp $15
	jr c, .asm_1eae
	ld b, $14
.asm_1eae
	ld a, l
	ld [wdc93], a
	ld a, h
	ld [wdc94], a
.asm_1eb6
	ld hl, wTextBuffer
	pop af
	bankswitch
	ret

; input:
; - hl = texts pointer
; - c  = ?
Func_1ec0::
	ldh a, [hROMBank]
	push af
	homecall Func_891e
	pop af
	bankswitch
	ret

Func_1ed4::
	ld a, $05
	ld [wd82d], a
	ret

; input:
; - hl = some data used in Func_1eee
Func_1eda::
	ld a, l
	ld [wd82e + 0], a
	ld a, h
	ld [wd82e + 1], a
	call Func_1eee
	ld a, [wd831]
	srl a
	ld [wd832], a
	ret

Func_1eee:
	ld hl, wd82e
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, Func_1f32
	ld a, [wd837]
	and a
	jr nz, Func_1f32
	ld a, [wFelony]
	ld de, $0
	cp 18
	jr c, .asm_1f18
	ld de, $6
	cp 36
	jr c, .asm_1f18
	ld de, $c
	cp 56
	jr c, .asm_1f18
	ld de, $12
.asm_1f18
	add hl, de
Func_1f19::
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

Func_1f32:
	xor a
	ld [wd830], a
	ret

Data_1f37::
	db $01, $04, $1e, $20, $b4, $00
	db $01, $03, $15, $1c, $f0, $00
	db $01, $02, $0f, $18, $2c, $01
	db $02, $02, $07, $14, $68, $01
; 0x1f4f

SECTION "Func_1f67", ROM0[$1f67]

Data_1f67:
	db CAR_03, CAR_04, CAR_05, CAR_02, $03, $03, $04, $04, $05, $05, $02, $02
	db CAR_03, CAR_04, CAR_02, CAR_10, $03, $03, $04, $04, $02, $02, $0a, $0a
	db CAR_03, CAR_09, CAR_10, CAR_02, $03, $03, $09, $09, $0a, $0a, $02, $02
	db CAR_04, CAR_09, CAR_10, CAR_02, $04, $04, $09, $09, $0a, $0a, $02, $02

Data_1f97:
	db CAR_01, CAR_02, CAR_03, CAR_04, $03, $03, $03, $04, $04, $04, $02, $02
	db CAR_01, CAR_03, CAR_04, CAR_05, $03, $03, $04, $04, $05, $05, $03, $03
	db CAR_01, CAR_03, CAR_09, CAR_02, $03, $03, $03, $03, $09, $09, $02, $02
	db CAR_01, CAR_05, CAR_10, CAR_02, $05, $05, $05, $05, $0a, $0a, $02, $02

ToggleDebugMode:
	ld a, [wd895]
	and a
	ret nz

	ld hl, wDMGPals
	ld bc, $38
	ld a, $ff
	call FillMemory
	call FlushCGBPalettes

	call Func_2597
	ld a, [wDebugModeActive]
	and a
	jr nz, .not_debug
	ld a, $08
	add_hl
.not_debug
	call Func_2133
	ld a, [hli]
	ld [wd80b], a
	ld a, [hli]
	ld [wd80c], a
	call Func_2216

	ld hl, wTempBGPals
	ld de, wBGPals
	ld b, 7 palettes
	call CopyHLtoDE
	call FlushCGBPalettes

	; toggle Debug Mode bool
	ld hl, wDebugModeActive
	ld a, [hl]
	xor $1
	ld [hl], a
	ret
; 0x200a

SECTION "Func_2026", ROM0[$2026]

Func_2026:
	xor a
	ld [wDebugModeActive], a
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
	ld [wdc7c + 0], a
	ld a, [hli]
	ld [wdc7c + 1], a
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
	ld [wd7ff + 0], a
	ld [wd7fb], a
	ld a, b
	ld [wd7ff + 1], a
	ld [wd7fc], a
	ld a, e
	ld [wd7fd + 0], a
	ld [wd7f9], a
	ld a, d
	ld [wd7fd + 1], a
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
	ld de, wGfxBuffer
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
	ld a, [wdc7c + 0]
	ld e, a
	ld a, [wdc7c + 1]
	ld d, a
	add hl, de
	ld a, [wdc7a]
	bankswitch
	ld de, wGfxBuffer
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
	homecall Func_43be
	push bc
	ld c, e
	ld b, d
	pop de
	ret

Func_2133:
	xor a
	ld [wVRAMNumTiles_v0_9000], a
	ld [wVRAMNumTiles_v0_8800], a
	ld [wVRAMNumTiles_v1_9000], a

	ld a, [hli]
	bankswitch
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld h, d
	ld l, e
	ld de, wTempBGPals
	ld b, 7 palettes
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
	ld b, V0TILES_9000
	ld a, $80
	call PushTilesToVRAM
	pop de
	pop bc

	ld hl, $80 tiles
	add hl, de
	ld d, h
	ld e, l
	push bc
	push de
	ld b, V0TILES_8800
	ld a, $80
	call PushTilesToVRAM
	pop de
	pop bc

	ld hl, $80 tiles
	add hl, de
	ld d, h
	ld e, l
	ld b, V1TILES_9000
	ld a, $80
	call PushTilesToVRAM
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
	ld de, wGfxBuffer
	call Func_22c2
	ld a, BANK("VRAM1")
	vramswitch
	ld de, wGfxBuffer + $15
	call Func_22c2
	ld a, BANK("VRAM0")
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
	call CopyBGMapBox_ToCoordinate
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
	jp CopyBGMapBox_ToCoordinate
.asm_22ea
	ld bc, $115
	ld l, a
	ld a, [wd802]
	ld h, a
	jp CopyBGMapBox_ToCoordinate

Func_22f5:
	push de
	ld de, wGfxBuffer
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
	ld de, wGfxBuffer
	call Func_2378
	ld a, BANK("VRAM1")
	vramswitch
	ld de, wGfxBuffer + $11
	call Func_2378
	ld a, BANK("VRAM0")
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
	call CopyBGMapBox_ToCoordinate
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
	jp CopyBGMapBox_ToCoordinate
.asm_23a0
	ld bc, $1101
	ld h, a
	ld a, [wd801]
	ld l, a
	jp CopyBGMapBox_ToCoordinate

Func_23ab:
	push de
	ld de, wGfxBuffer
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
	call HLMinusDE
	ld a, l
	or h
	ret z
	ld e, l
	ld d, h
	call GetAbsHL
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
	ld a, [wCity]
	ld hl, .PtrTable
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.PtrTable:
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK

.Miami:
	dbw $31, $5320
	dba Gfx_c4000
	db $1a, $06

	dbw $31, $5450
	dbw $31, $5360
	db $1c, $0b

	db $00, $20, $00, $20

.LosAngeles:
	dbw $31, $6800
	dbw $31, $5490
	db $1e, $10

	dbw $31, $6930
	dbw $31, $6840
	db $20, $15

	db $00, $20, $00, $20

.NewYork:
	dbw $31, $7a40
	dbw $31, $6970
	db $2c, $22

	dbw $31, $7b70
	dbw $31, $7a80
	db $2e, $27

	db $00, $20, $00, $20

Func_25e5:
	ld b, $08
	ld hl, wd8eb
	ld de, CAR_STRUCT_SIZE
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
	ld de, CAR_STRUCT_SIZE
.loop_cars
	bit CARFLAG_ACTIVE_F, [hl] ; CARSTRUCT_FLAGS
	jr z, .inactive
	add hl, de
	dec b
	jr nz, .loop_cars
	; all active
	pop de
	pop bc
	scf
	ret

.inactive
	ld [hl], CARFLAG_ACTIVE ; CARSTRUCT_FLAGS
	lb bc, 0, 0
	ld a, CARSTRUCT_22
	call SetStructByte_C
	ld a, CARSTRUCT_21
	call SetStructByte_C
	ld a, CARSTRUCT_12
	call SetStructByte_C
	ld a, CARSTRUCT_20
	call SetStructByte_C
	ld a, CARSTRUCT_SPEED
	call SetStructWord_BC
	ld a, CARSTRUCT_10
	call SetStructWord_BC
	pop de
	pop bc
	and a
	ret

; input:
; - a  = ?
; - h  = ?
; - l  = ?
; - bc = x coordinate
; - de = y coordinate
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
	ld [hli], a ; CARSTRUCT_01
	ld a, [wdc7e]
	ld [hli], a ; CARSTRUCT_02
	xor a
	ld [hli], a ; CARSTRUCT_03
	ld [hli], a ; CARSTRUCT_04
	ld [hli], a ; CARSTRUCT_05
	ld [hli], a ; CARSTRUCT_06
	ld [hl], e  ; CARSTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	ld [hli], a ; CARSTRUCT_09
	ld [hl], c  ; CARSTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld a, [wdc7a]
	ld [hl], a ; CARSTRUCT_0C
	pop hl
	and a
	ret

Func_265f::
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	ld e, a
	and $80 ; negative?
	jr nz, .negative
; positive
	xor a
	sub c
	ld c, a
	ld a, 0
	sbc b
	ld b, a
.negative
	push de
	ld a, CARSTRUCT_SPEED
	call AddStructWord_BC
	pop de
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	xor e
	and $80
	ret z
	ld de, 0
	ld a, CARSTRUCT_SPEED
	jp SetStructWord_DE
; 0x2688

SECTION "Func_26b8", ROM0[$26b8]

Func_26b8::
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	bit 7, a
	jr z, .asm_26c3
	cpl
	inc a
.asm_26c3
	cp c
	ret

Func_26c5:
	push hl
	ld a, CARSTRUCT_SPEED + 1
	add_hl
	ld a, [hl]
	and a
	pop hl
	ret

; output:
; - bc = x coordinate
; - de = y coordinate
GetCarCoordinates::
	push hl
	ld a, CARSTRUCT_Y
	add_hl
	ld e, [hl] ; CARSTRUCT_Y
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl] ; CARSTRUCT_X
	inc hl
	ld b, [hl]
	pop hl
	ret

Func_26db::
	push hl
	ld a, CARSTRUCT_0C
	add_hl
	ld a, [hl]
	pop hl
	call Func_271b
	push hl
	push de
	ld de, CARSTRUCT_SPEED + 1
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
	ld a, CARSTRUCT_25
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and $08
	pop hl
	ret

Func_271b::
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

SECTION "Func_275f", ROM0[$275f]

Func_275f::
	push de
	push hl
	ld a, CARSTRUCT_Y
	add_hl
	ld a, [hli] ; CARSTRUCT_Y
	push hl
	ld h, [hl]
	ld l, a
	ld a, $07
	add_de
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	inc de
	inc de
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, bc
	bit 7, h
	jr z, .asm_2785
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
.asm_2785
	ld a, l
	ld [wdc7a + 0], a
	ld a, h
	ld [wdc7a + 1], a
	pop hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
	add hl, bc
	bit 7, h
	jr z, .asm_27ab
	xor a
	sub l
	ld l, a
	ld a, $00
	sbc h
	ld h, a
.asm_27ab
	ld b, h
	ld c, l
	ld a, [wdc7a + 0]
	ld e, a
	ld a, [wdc7a + 1]
	ld d, a
	ld h, $00
.asm_27b7
	ld a, b
	or d
	jr z, .asm_27c6
	inc h
	srl b
	rr c
	srl d
	rr e
	jr .asm_27b7
.asm_27c6
	ld b, e
	ld a, b
	or c
	and $80
	jr z, .asm_27d2
	inc h
	srl b
	srl c
.asm_27d2
	call CalculateEuclideanDistance
	ld l, a
	ld a, h
	ld h, $00
.asm_27d9
	and a
	jr z, .asm_27e0
	add hl, hl
	dec a
	jr .asm_27d9
.asm_27e0
	ld b, h
	ld c, l
	pop hl
	pop de
	ret

; input:
; - hl = struct 1
; - de = struct 2
; output:
; - b = y distance
; - c = x distance
; - a = direction flags
Func_27e5::
	push de
	push hl
	ld a, CARSTRUCT_Y
	add_hl
	ld a, CARSTRUCT_Y
	add_de
	push de
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [de] ; CARSTRUCT_Y
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	call HLMinusBC
	ld a, l
	or h ; zero?
	jr z, .asm_2807
	ld c, $04
	bit 7, h ; negative?
	jr nz, .asm_2806
	ld c, $01
.asm_2806
	ld a, c
.asm_2807
	ld [wda59], a
	call GetAbsHL
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
	ld a, [de] ; CARSTRUCT_X
	ld c, a
	inc de
	ld a, [de]
	ld d, a
	ld e, c
	call HLMinusDE
	ld a, l
	or h ; zero?
	jr z, .asm_283b
	ld c, $02
	bit 7, h ; negative?
	jr nz, .asm_2834
	ld c, $08
.asm_2834
	ld a, [wda59]
	or c
	ld [wda59], a
.asm_283b
	call GetAbsHL
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

Func_284b::
	call Func_26c5
	jr nz, .asm_2855
	ld b, a
	ld c, a
	ld d, a
	ld e, a
	ret
.asm_2855
	call Func_29d6
	ld a, b
	or c
	call nz, Func_286d
	ld a, d
	or e
	jr z, .asm_286a
	push bc
	ld b, d
	ld c, e
	call Func_286d
	ld d, b
	ld e, c
	pop bc
.asm_286a
	xor a
	dec a
	ret

Func_286d:
	ld a, CARSTRUCT_SPEED + 1
	push hl
	add_hl
	ld a, [hl]
	call Func_2998
	pop hl
	ret

Func_2877::
	push hl
	ld a, $0f
	add_hl
	ld a, [hl]
	call Func_29ea
	pop hl
	ld a, b
	or c
	call nz, .Func_2895
	ld a, d
	or e
	jr z, .asm_2892
	push bc
	ld b, d
	ld c, e
	call .Func_2895
	ld d, b
	ld e, c
	pop bc
.asm_2892
	xor a
	dec a
	ret

.Func_2895:
	ld a, $11
	push hl
	add_hl
	ld a, [hl]
	call Func_2998
	pop hl
	ret

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
	ld a, ENT_UNK10
	call SetStructWord_BC
	pop af
	ld c, a
	ld a, ENT_UNK0F
	jp SetStructByte_C

Func_28bb::
	push hl
	add_hl
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	bit 7, h
	jr z, .capped
	ld hl, 0
.capped
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
	call CalculateEuclideanDistance
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
	jp DTimesE

Func_2967::
	ld a, CARSTRUCT_11
	call GetStructByte_A
	and a
	jr z, .asm_2978
	ld d, a
	ld a, CARSTRUCT_0F
	call GetStructByte_E
	call Func_28d1
.asm_2978
	ld a, CARSTRUCT_0F
	call SetStructByte_C
	ld c, $00
	ld a, CARSTRUCT_10
	jp SetStructWord_BC

Func_2984::
	push hl
	add_hl
	ld a, [hl]
	add $80
	ld [hl], a
	pop hl
	ret

Func_298c::
	push de
	ld a, $06
	call Func_146c
	pop bc
	ld a, $09
	jp Func_146c

Func_2998::
	ld hl, 0
	bit 7, a ; negative?
	jr z, .Func_29ac
	; get absolute value
	cpl
	inc a
	call .Func_29ac
	; output bc = -bc
	xor a
	sub c
	ld c, a
	ld a, 0
	sbc b
	ld b, a
	ret

; calculates bc = bc * (a / 16)
.Func_29ac:
	push af
	and $0f
	jr z, .asm_29c4
	call .HLPlusBC_ATimes
	sra h
	rr l
	sra h
	rr l
	sra h
	rr l
	sra h
	rr l ; / 16
.asm_29c4
	pop af
	swap a
	and $0f
	jr z, .skip
	call .HLPlusBC_ATimes
.skip
	ld b, h
	ld c, l
	ret

; does hl = hl + bc * a
.HLPlusBC_ATimes:
.asm_29d1
	add hl, bc
	dec a
	jr nz, .asm_29d1
	ret

Func_29d6::
	push hl
	ld a, CARSTRUCT_0C
	add_hl
	ld a, [hl]
	call Func_29ea
	pop hl
	ret

Func_29e0::
	push hl
	ld a, CARSTRUCT_0C
	add_hl
	ld a, [hl]
	call Func_2a7e
	pop hl
	ret

Func_29ea::
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

	; exit if either distance > 15
	ld a, 15
	cp c
	ret c ; x distance > 15
	cp b
	ret c ; y distance > 15

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

Func_2ab5::
	call GetCarCoordinates
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
	jr z, .done
	ld de, wda4d
	call Func_2c37
	call Func_2cbb
	call Func_298c
	call Func_2ab5
	jr nz, .done

	ld de, wda51
	call Func_2c37
	ld a, [wda5a]
	ld de, .done
	push de
	push hl
	jumptable
	dw .Func_2b15
	dw .Func_2b1b
	dw .Func_2b23
	dw .Func_2b2b
	dw .Func_2b1f
	dw .Func_2b15
	dw .Func_2b5d
	dw .Func_2b15
	dw .Func_2b27
	dw .Func_2bc1
	dw .Func_2b15
	dw .Func_2b15
	dw .Func_2b8f
	dw .Func_2b15
	dw .Func_2b15
	dw .Func_2b15

.Func_2b15:
	pop hl
.done
	ld a, [wda5d]
	and a
	ret

.Func_2b1b:
	pop hl
	jp Func_2c89

.Func_2b1f:
	pop hl
	jp Func_2ca2

.Func_2b23:
	pop hl
	jp Func_2c71

.Func_2b27:
	pop hl
	jp Func_2c7d

.Func_2b2b:
	pop hl
	call Func_2c49
	call z, Func_2c89
	call Func_2c5b
	call z, Func_2c71
	ld a, [wda5d]
	and a
	jr nz, .asm_2b51
	call Func_2c89
	call Func_2c71
.asm_2b44
	ld a, $0c
	call GetStructByte_A
	and $20
	jp z, Func_2c13
	jp Func_2bf2
.asm_2b51
	cp $03
	jr z, .asm_2b44
	and $02
	jp nz, Func_2c13
	jp Func_2bf2

.Func_2b5d:
	pop hl
	call Func_2c49
	call z, Func_2ca2
	call Func_2c5b
	call z, Func_2c71
	ld a, [wda5d]
	and a
	jr nz, .asm_2b83
	call Func_2ca2
	call Func_2c71
.asm_2b76
	ld a, $0c
	call GetStructByte_A
	and $20
	jp z, Func_2c13
	jp Func_2bf2
.asm_2b83
	cp $06
	jr z, .asm_2b76
	and $02
	jp nz, Func_2bf2
	jp Func_2c13

.Func_2b8f:
	pop hl
	call Func_2c49
	call z, Func_2ca2
	call Func_2c5b
	call z, Func_2c7d
	ld a, [wda5d]
	and a
	jr nz, .asm_2bb5
	call Func_2ca2
	call Func_2c7d
.asm_2ba8
	ld a, $0c
	call GetStructByte_A
	and $20
	jp z, Func_2c13
	jp Func_2bf2
.asm_2bb5
	cp $0c
	jr z, .asm_2ba8
	and $08
	jp nz, Func_2c13
	jp Func_2bf2

.Func_2bc1:
	pop hl
	call Func_2c49
	call z, Func_2c89
	call Func_2c5b
	call z, Func_2c7d
	ld a, [wda5d]
	and a
	jr nz, .asm_2be7
	call Func_2c89
	call Func_2c7d
.asm_2bda
	ld a, $0c
	call GetStructByte_A
	and $20
	jp z, Func_2c13
	jp Func_2bf2
.asm_2be7
	cp $09
	jr z, .asm_2bda
	and $08
	jp nz, Func_2bf2
	jr Func_2c13

Func_2bf2:
	ld a, [wdc7e]
	ld c, a
	call Func_26b8
	ret c
	call Func_2c34
	push hl
	ld a, $0c
	add_hl
.asm_2c01
	inc [hl]
	ld a, [hl]
	and $0f
	jr z, .asm_2c0a
	dec b
	jr nz, .asm_2c01
.asm_2c0a
	pop hl
	push hl
	ld a, $20
	add_hl
	ld [hl], $10
	pop hl
	ret

Func_2c13:
	ld a, [wdc7e]
	ld c, a
	call Func_26b8
	ret c
	call Func_2c34
	push hl
	ld a, $0c
	add_hl
.asm_2c22
	dec [hl]
	ld a, [hl]
	and $0f
	jr z, .asm_2c2b
	dec b
	jr nz, .asm_2c22
.asm_2c2b
	pop hl
	push hl
	ld a, $20
	add_hl
	ld [hl], $20
	pop hl
	ret

Func_2c34:
	ld b, $02
	ret

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

Func_2c49:
	ld a, [$da4f]
	ld c, a
	ld a, [$da50]
	ld b, a
	ld a, [wda51]
	ld e, a
	ld a, [$da52]
	ld d, a
	jr Func_2c6b
Func_2c5b:
	ld a, [$da53]
	ld c, a
	ld a, [$da54]
	ld b, a
	ld a, [wda4d]
	ld e, a
	ld a, [$da4e]
	ld d, a
Func_2c6b:
	call Func_2558
	cp $00
	ret

Func_2c71:
	ld a, [wda5d]
	or $02
	ld [wda5d], a
	ld a, $09
	jr Func_2cac

Func_2c7d:
	ld a, [wda5d]
	or $08
	ld [wda5d], a
	ld a, $09
	jr Func_2c93

Func_2c89:
	ld a, [wda5d]
	or $01
	ld [wda5d], a
	ld a, $06
Func_2c93:
	push hl
	add_hl
	xor a
	ld [hli], a
	ld a, [hl]
	and $f8
	add $08
	ld [hli], a
	jr nc, .asm_2ca0
	inc [hl]
.asm_2ca0
	pop hl
	ret

Func_2ca2:
	ld a, [wda5d]
	or $04
	ld [wda5d], a
	ld a, $06
Func_2cac:
	push hl
	add_hl
	xor a
	ld [hli], a
	ld a, [hl]
	and $f8
	sub $01
	ld [hli], a
	jr nc, .asm_2cb9
	dec [hl]
.asm_2cb9
	pop hl
	ret

Func_2cbb:
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	and a
	jr z, .asm_2cf5
	ld [wdc7a], a
	ld a, CARSTRUCT_0C
	call GetStructByte_A
	ld [wdc7c], a
	call Func_2d2c
	ld a, CARSTRUCT_11
	call GetStructByte_A
	and a
	jr z, .asm_2d08
	ld [wdc7a], a
	ld a, CARSTRUCT_0F
	call GetStructByte_A
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
	ld a, CARSTRUCT_11
	call GetStructByte_A
	ld [wdc7a], a
	ld a, CARSTRUCT_0F
	call GetStructByte_A
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
	ld a, [wdc7c + 0]
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

; outputs a = sqrt(c*c + b*b)
CalculateEuclideanDistance::
	ld a, b
	and a
	jr z, .zero_y
	ld a, c
	and a
	jr z, .zero_x

	push de
	push hl
	call ASquared
	ld h, d
	ld l, e
	ld a, b
	call ASquared
	add hl, de
	jr c, .negative
	ld d, h
	ld e, l
	call SquareRoot

.got_result
	pop hl
	pop de
	ret
.negative
	ld a, $ff
	jr .got_result
.zero_y
	ld a, c
	ret
.zero_x
	ld a, b
	ret

Func_2dd5::
	ld a, [wda76]
	and a
	ret z
	cp $01
	jr z, .asm_2df7
	cp $03
	jr z, .asm_2e05
	push hl
	ld hl, wDestinationCoords
	ld a, [hli]
	ld h, [hl]
	ld l, a
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
	scf
	ret

.asm_2df7
	push hl
	ld hl, wDestinationCoords
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	scf
	ret

.asm_2e05
	push hl
	ld hl, wda7f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $08
	add_de
	ld a, $08
	add_bc
	pop hl
	scf
	ret
; 0x2e1f

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
	ld a, CARSTRUCT_03
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
	ld a, CARSTRUCT_25
	call GetStructWord_DE

	push de
	push hl
	inc de
	inc de
	ld a, CARSTRUCT_Y
	add_hl
	ld a, [hli]
	sub $08
	ld [de], a ; WDC32STRUCT_Y
	inc de
	ld a, [hli]
	sbc $00
	ld [de], a
	inc de
	inc hl
	inc de
	ld a, [hli] ; CARSTRUCT_X
	sub $08
	ld [de], a ; WDC32STRUCT_X
	inc de
	ld a, [hl]
	sbc $00
	ld [de], a
	pop hl
	pop de

	ld a, CARSTRUCT_0C
	call GetStructByte_A
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
	and ~(WDC32FLAG_XFLIP | WDC32FLAG_YFLIP)
	or [hl]
	or WDC32FLAG_UNK1 | WDC32FLAG_UNK2
	ld [de], a
	ld a, [hl]
	pop hl

	inc hl
	ld b, [hl] ; CARSTRUCT_01
	inc hl
	inc hl
	ld [hli], a ; CARSTRUCT_03
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
	ld [hl], c ; CARSTRUCT_04
	inc hl
	ld [hl], b ; CARSTRUCT_05
	ld a, CARSTRUCT_05
	sub_hl
	ld a, [bc]
	push af
	inc bc
	ld a, [bc]
	ld b, a
	pop af
	ld c, a
	ld a, WDC32STRUCT_X
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
	ld [de], a ; WDC32STRUCT_UNK07
	inc de
	ld a, b
	ld [de], a ; WDC32STRUCT_UNK08
	inc de
	push hl
	inc hl
	ld a, [hli] ; CARSTRUCT_01
	ld b, [hl]  ; CARSTRUCT_02
	ld hl, wdbc5
	add a ; *2
	add_hl
	ld a, [hli]
	add c
	ld c, a
	ld a, [hl]
	or b
	ld b, a
	ld h, d
	ld l, e
	ld [hl], c ; WDC32STRUCT_UNK09
	inc hl
	ld [hl], b
	inc hl
	inc c
	inc c
	ld [hl], c ; WDC32STRUCT_UNK0B
	inc hl
	ld [hl], b
	pop hl
	pop af
	bankswitch
	ret

; input:
; - c  = CAR_* constant
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
LoadCarGfx:
	ldh a, [hROMBank]
	push af
	ld a, $03
	bankswitch
	ld hl, wdbc5
	ld a, c
	add a ; *2
	add_hl
	ld de, wVRAMNumTiles
	ld a, b
	add_de
	ld a, [de]
	ld [hl], a
	ld a, b
	cp V0TILES_8800
	jr z, .add_80_to_tile_id
	cp V1TILES_8800
	jr z, .add_80_to_tile_id
.asm_3111
	inc hl
	ld a, b
	cp V1TILES
	ld a, $00
	jr c, .asm_311b
	ld a, $08
.asm_311b
	ld [hl], a
	ld a, c
	add a
	add a
	add c ; *3
	ld hl, CarGfxTable
	add_hl
	ld c, [hl] ; bank
	inc hl
	ld e, [hl] ; pointer
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl] ; num of tiles
	call PushTilesToVRAM
	pop af
	bankswitch
	ret
.add_80_to_tile_id
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
	ld a, CARSTRUCT_SPEED
	call GetStructWord_BC
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
	ld de, Func_3705
	ld a, BANK(Func_3705)
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
	ld a, [wdc7a + 0]
	cp l
	jr nz, .asm_33e5
	ld a, [wdc7a + 1]
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
	ld a, [wdc7c + 0]
	cp l
	jr nz, .asm_340d
	ld a, [wdc7c + 1]
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
	ld a, [wdc7c + 0]
	cp l
	jr nz, .asm_34da
	ld a, [wdc7c + 1]
	cp h
	ret z
.asm_34da
	inc hl
	inc hl
	inc hl
	ret

Func_34de:
	ld a, [wdc7a + 0]
	cp l
	jr nz, .asm_34e9
	ld a, [wdc7a + 1]
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
	ld a, [wCity]
	ld e, a
	add a
	add e ; *3
	ld hl, PtrTable_3823
	add_hl
	ld a, [hli]
	bankswitch
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, $00
	srl d
	rr e
	; de = d * $80
	add hl, de
	ld a, b
	add a
	add a ; *4
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
	ld hl, Func_36f5
	ld c, BANK(Func_36f5)
	ld b, $0a
	call SpawnEntity
	pop de
	jr c, .asm_362b
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	push de
	ld e, l
	ld d, h
	pop hl
	ld a, CARSTRUCT_0F
	call SetStructWord_DE
	call Func_1124
	jr c, .asm_362e
	ld a, ENT_UNK11
	call SetStructWord_DE
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
	call GetStructWord_DE
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
	add a ; *2
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

Func_36ea:
	push de
	ld a, CARSTRUCT_11
	call GetStructWord_DE
	ld a, [de]
	and $08
	pop de
	ret

Func_36f5:
	call GetEntityCarPtr
.asm_36f8
	ld a, 1
	call YieldEntityUpdate
	call Func_36ea
	jp nz, Func_3815
	jr .asm_36f8

Func_3705:
	call GetEntityCarPtr
	set 1, [hl]
.asm_370a
	call Func_3773
	call Func_37be
	call Func_3743
	call Func_3637
	call Func_3798
	ld a, b
	or c
	jr z, .asm_3724
	ld a, $01
	call YieldEntityUpdate
	jr .asm_370a
.asm_3724
	ld a, $01
	call YieldEntityUpdate
	call Func_36ea
	jr z, .asm_3724
	ld c, $00
.asm_3730
	ld a, $01
	call YieldEntityUpdate
	call Func_36ea
	jr z, .asm_3724
	inc c
	ld a, $59
	cp c
	jr nc, .asm_3730
	jp Func_3815

Func_3743:
	push hl
	ld a, $0a
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
	call Func_2558
	cp $00
	ret nz
	push hl
	ld a, $06
	add_hl
	ld a, [hl]
	cpl
	ld [hld], a
	ld a, [hl]
	add $80
	ld [hl], a
	pop hl
	ld a, $07
	call GetStructWord_BC
	srl b
	rr c
	ld a, $07
	call SetStructWord_BC
	jp Func_37f0

Func_3773:
	ld a, ENT_UNK08
	call GetStructByte_A
	rrca
	rrca
	and $3f
	ld b, a
	push hl
	ld a, $06
	add_hl
	ld c, [hl]
	dec hl
	ld a, $01
	bit 7, c
	jr z, .asm_378b
	ld a, $ff
.asm_378b
	add [hl]
	ld [hld], a
	ld a, b
	bit 7, c
	jr z, .asm_3794
	cpl
	inc a
.asm_3794
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_3798:
	push hl
	ld a, $03
	add_hl
	ld a, [hl]
	add a
	ld hl, $3872
	add_hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	push hl
	ld a, $07
	add_hl
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	bit 7, h
	jr z, .asm_37b6
	ld hl, $0000
.asm_37b6
	ld b, h
	ld c, l
	pop hl
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	ret

Func_37be:
	call Func_37fb
	ld a, ENT_UNK05
	call GetStructByte_A
	push hl
	call Func_29ea
	pop hl
	push bc
	ld b, d
	ld c, e
	call Func_37e3
	ld d, b
	ld e, c
	pop bc
	call Func_37e3
	push de
	ld a, $09
	call Func_146c
	pop bc
	ld a, $0c
	jp Func_146c

Func_37e3:
	ld a, ENT_UNK08
	call GetStructByte_A
	push de
	push hl
	call Func_2998
	pop hl
	pop de
	ret

Func_37f0:
	push hl
	ld a, $09
	add_hl
	ld d, h
	ld e, l
	ld hl, wda6e
	jr Func_3802
Func_37fb:
	push hl
	ld a, $09
	add_hl
	ld de, wda6e
Func_3802:
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
	ret

Func_3815:
	call GetEntityCarPtr
	ld a, CARSTRUCT_11
	call GetStructWord_DE
	xor a
	ld [de], a
	ld [hl], a
	jp DespawnEntity

PtrTable_3823:
	dba Data_10000 ; MIAMI
	dba Data_14000 ; LOS_ANGELES
	dba Data_c0000 ; NEW_YORK

MACRO? data_382c
	db \1 ; num of tiles
	dba \2 ; graphics
ENDM

Data_382c:
	data_382c 4, Gfx_d235d ; PROP_0
	data_382c 4, Gfx_d239d ; PROP_1
	data_382c 4, Gfx_d23dd ; PROP_2
	data_382c 4, Gfx_d241d ; PROP_3
	data_382c 4, Gfx_d245d ; PROP_4
	data_382c 4, Gfx_d249d ; PROP_5
	data_382c 4, Gfx_d25cd ; PROP_6
	data_382c 4, Gfx_d260d ; PROP_7
	data_382c 4, Gfx_d264d ; PROP_8
	data_382c 4, Gfx_d26dd ; PROP_9
	data_382c 5, Gfx_d24dd ; PROP_A
	data_382c 5, Gfx_d252d ; PROP_B
	data_382c 5, Gfx_d257d ; PROP_C
	data_382c 5, Gfx_d268d ; PROP_D
; 0x382c

SECTION "Data_3864", ROM0[$3864]

Data_3864:
    db $04, $04, $04, $02, $02, $03, $00, $02
	db $05, $02, $02, $03, $02, $02
; 0x3872
