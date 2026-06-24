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
