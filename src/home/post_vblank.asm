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

	call StopSound

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
