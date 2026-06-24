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
	call GameLoop
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
