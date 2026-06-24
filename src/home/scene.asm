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
