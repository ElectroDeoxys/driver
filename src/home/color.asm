; unreferenced
Func_ca0:
	ld de, wGfxBuffer
	push bc
.asm_ca4
	push bc
.asm_ca5
	ld [de], a
	inc de
	dec b
	jr nz, .asm_ca5
	pop bc
	dec c
	jr nz, .asm_ca4
	pop bc
	ld a, BANK("VRAM1")
	vramswitch
	ld de, wGfxBuffer
	call CopyBGMapBox_ToCoordinate
	ld a, BANK("VRAM0")
	vramswitch
	ret

LoadDefaultPalettes:
	lddmgpal c, SHADE_WHITE, SHADE_LIGHT, SHADE_DARK, SHADE_BLACK
	ld hl, Pals_Gray
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

; unreferenced
Func_e5c:
	push af
	push hl
	call .Func_e6f
	pop hl
	pop af
	add a
	add a
	add a
	or OBPI_AUTOINC
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
	jp SafeCopyPalette

.Func_e6f:
	add a
	add a
	add a
	push af
	push hl
	ld de, wOBPals
	add_de
	call .Func_e81
	pop hl
	pop af
	ld de, wTempOBPals
	add_de
.Func_e81:
	ld b, 1 palettes
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

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

UnreferencedPals_GrayInverted: INCLUDE "gfx/gray_inverted.pal"
Pals_Gray:  INCLUDE "gfx/gray.pal"
Pals_White: INCLUDE "gfx/white.pal"
Pals_Black: INCLUDE "gfx/black.pal"
