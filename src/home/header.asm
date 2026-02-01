SECTION "RST00", ROM0

; jumps to ath entry in following pointer table
JumpTable::
	pop hl
	add a ; *2
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
; 0x7

SECTION "RST08", ROM0

; ouput ath pointer in following
; pointer table in hl registers
GetPointer::
	add a ; *2
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 0xe

SECTION "RST10", ROM0

DoFrame:
	jp _DoFrame
; 0x13

SECTION "RST18", ROM0

; adds a to hl
AddHL::
	add l
	ld l, a
	ret nc
	inc h
	ret
; 0x1d

SECTION "RST20", ROM0

; subs a to hl
SubHL::
	cpl
	inc a
	add l
	ld l, a
	ret c
	dec h
	ret
; 0x27

SECTION "RST28", ROM0

; adds a to de
AddDE::
	add e
	ld e, a
	ret nc
	inc d
	ret
; 0x2d

SECTION "RST30", ROM0

DisableLCD::
	ldh a, [rLCDC]
	rlca
	; carry set means LCD is on
	ret nc ; lcd off
	ldh a, [rIE]
	jr _DisableLCD
; 0x38

SECTION "RST38", ROM0

; adds a to bc
AddBC::
	add c
	ld c, a
	ret nc
	inc b
	ret
; 0x3d

SECTION "VBlank", ROM0

VBlank:
	jp _VBlank
; 0x43

SECTION "Stat", ROM0

Stat:
	jp _Stat
; 0x4b

SECTION "Timer", ROM0

Timer:
	jp _Timer
; 0x53

SECTION "Serial", ROM0

Serial:
	jp _Serial

_DisableLCD:
	push af
	; disable V-Blank
	res B_IE_VBLANK, a
	call SetInterrupts
.wait_vblank
	ldh a, [rLY]
	cp LY_VBLANK + 1
	jr c, .wait_vblank

	; turn off Window and LCD
	ldh a, [rLCDC]
	and ~(LCDC_WINDOW | LCDC_ENABLE)
	ldh [rLCDC], a
	pop af
;	fallthrough

SetInterrupts:
	ld b, a
	xor a ; reset all pending interrupts
	ldh [rIF], a
	ld a, b ; set enabled interrupts
	ldh [rIE], a
	ret

InitTransferVirtualOAMAndClearWRAM:
	; disable interrupts
	di
	xor a
	call SetInterrupts

	ld a, $01
	bankswitch

	; enables and immediately disables LCD
	ld a, LCDC_ON
	ldh [rLCDC], a
	disable_lcd

	call ClearWRAM

	ld c, LOW(hTransferVirtualOAM)
	ld b, SIZEOF("DMA Transfer")
	ld hl, TransferVirtualOAM
.loop_copy
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop_copy
	ret

TransferVirtualOAM:
LOAD "DMA Transfer", HRAM
hTransferVirtualOAM::
	ld a, HIGH(wVirtualOAM1)
	ldh [rDMA], a ; start DMA transfer (starts right after instruction)
	ld a, 160 / (1 + 3) ; delay for a total of 160 cycles
.loop
	dec a        ; 1 cycle
	jr nz, .loop ; 3 cycles
	ret
ENDL

InitHardwareRegisters:
	ld hl, .RegisterValues
.loop
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	jr nz, .loop
	ret

.RegisterValues:
	db LOW(rSB),   $00
	db LOW(rSC),   $00
	db LOW(rSCY),  0
	db LOW(rSCX),  0
	db LOW(rBGP),  $e4
	db LOW(rOBP0), $e4
	db LOW(rOBP1), $e4
	db LOW(rLYC),  111
	db LOW(rSTAT), STAT_LYC
	db LOW(rIF),   $00
	db LOW(rIE),   IE_VBLANK
; 0xc3

SECTION "CopyHLtoDE", ROM0[$cc]

; copies b bytes from hl to de
CopyHLtoDE::
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

Func_d3:
	ldh a, [rLCDC]
	rlca
	jr nc, .safe
	wait_ppu
.safe
	ret

; waits for wFrameCounter to change 
_DoFrame:
	push af
	push hl
	ld hl, wFrameCounter
	ld a, [hl]
.loop
	cp [hl]
	jr z, .loop
	pop hl
	pop af
	ret
; 0xf1

SECTION "Start", ROM0

Start:
	nop
	jp _Start
; 0x104
