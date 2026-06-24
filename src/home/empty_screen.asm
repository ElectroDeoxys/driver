FadeToWhite::
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb
; dmg
	lddmgpal a, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE
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

; unreferenced
UnreferencedFadeToBlack:
	ldh a, [hBootUpA]
	cp BOOTUP_A_CGB
	jr z, .cgb
; dmg
	lddmgpal a, SHADE_BLACK, SHADE_BLACK, SHADE_BLACK, SHADE_BLACK
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
	ld de, Pals_Black
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
