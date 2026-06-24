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

; unreferenced
Func_523:
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	res B_IE_STAT, a
	ldh [rIE], a
	ret
