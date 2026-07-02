GameLoop:
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
	call UpdateUnlockedCities

.titlescreen
	homecall Titlescreen
	jr .asm_15ef
.main_menu
	homecall MainMenu
.asm_15ef
	call UpdateUnlockedCities
	homecall MissionBriefing
	call LoadMap

	ld a, $00
	ld [wd820], a
	ld a, $00
	ld [wd895], a
	xor a
	ld [wFrameCounter], a
	ld [wc579], a
.asm_1610
	call PostVBlank
	ld a, [wd820]
	cp $03
	jr z, .asm_1669
	call ResetNumberOfCopiedTiles
	call Func_1c57
	call Func_1c7b
	ld a, [wc579]
	and a
	jr nz, .asm_164d
	call UpdateEntities
	call Func_23d1
	call Func_332a
	homecall TickCarHornSFXTimer
	homecall Func_642c
	call Func_1eee
	ld hl, wFrameCounter
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
