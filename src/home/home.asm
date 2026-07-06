UpdateUnlockedCities::
	ld a, [wMission]
	cp LOS_ANGELES_MISSIONS
	ret c
	ld b, LOS_ANGELES_UNLOCKED
	cp NEW_YORK_MISSIONS
	jr c, .got_bitmask
	ld b, LOS_ANGELES_UNLOCKED | NEW_YORK_UNLOCKED
.got_bitmask
	ld a, [wUnlockedCities]
	or b
	ld [wUnlockedCities], a
	ret

LoadMap:
	xor a
	ld [wCarHornSFX], a
	ld [wCarHornSFXTimer], a
	ld [wda97], a
	ld [wda98], a
	ld [wda99], a
	ld [wda82], a
	ld [wd837], a
	ld [wd838], a
	ld [wd839], a
	ld [wd83a], a
	ld [wDamageMultiplier], a

	; init means setting the city, spawning the player
	; choosing the car pool, etc
	ld a, $01
	bankswitch
	call InitGameMode

	call Func_1b4e

	; loading means setting NPC spawn rates, spawning
	; controllers, and loading any assets that are needed
	ld a, $01
	bankswitch
	call LoadGameMode
	ret

InitGameMode:
	ld a, [wGameMode]
	jumptable
	table_width 2
	dw .TakeARide  ; MODE_TAKE_A_RIDE
	dw .Checkpoint ; MODE_CHECKPOINT
	dw .GetAway    ; MODE_GET_AWAY
	dw .Pursuit    ; MODE_PURSUIT
	dw .Survival   ; MODE_SURVIVAL
	dw .Undercover ; MODE_UNDERCOVER
	dw InitCredits   ; MODE_CREDITS
	assert_table_length NUM_GAME_MODES

.TakeARide:
	call ChooseCarPool_WithCop

	ld a, [wCity]
	call SetCity

	; black palette
	ld a, OBPAL_BLACK
	ld [wPlayerCarOBPal], a
	ld a, [wPlayerCar]
	ld c, a
	cp BLACK_CAR
	jr z, .get_spawn_coords
	cp COP_CAR
	jr z, .get_spawn_coords
	cp LIMOUSINE
	jr z, .get_spawn_coords

	; red palette
	ld a, OBPAL_RED
	ld [wPlayerCarOBPal], a
	ld a, c
	cp RED_CAR
	jr z, .get_spawn_coords

	; yellow palette
	ld a, OBPAL_YELLOW
	ld [wPlayerCarOBPal], a
	ld a, c
	cp TAXI
	jr z, .get_spawn_coords

	; otherwise, var palette
	ld a, OBPAL_VAR
	ld [wPlayerCarOBPal], a

.get_spawn_coords
	ld hl, TakeARidePlayerSpawnParams
	call Func_1946
	call SetPlayerSpawnCoordinatesAndDirection
	ret

.Checkpoint:
	call ChooseCarPool_WithoutCop
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	call Func_1937
	call SetPlayerSpawnCoordinatesAndDirection
	ret

.GetAway:
	call ChooseCarPool_WithCop
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	call Func_193c
	call SetPlayerSpawnCoordinatesAndDirection
	ret

.Pursuit:
	call ChooseCarPool_WithoutCop
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	call Func_1941
	call SetPlayerSpawnCoordinatesAndDirection
	ret

.Survival:
	call ChooseCarPool_WithCop
	ld a, [wCity]
	call SetCity
	call SetDefaultPlayerCar
	ld hl, SurvivalPlayerSpawnParams
	call Func_1946
	call SetPlayerSpawnCoordinatesAndDirection
	ret

.Undercover:
	ld a, BANK(InitMission)
	bankswitch
	jp InitMission

LoadGameMode:
	ld a, [wGameMode]
	jumptable
	table_width 2
	dw .TakeARide  ; MODE_TAKE_A_RIDE
	dw .Checkpoint ; MODE_CHECKPOINT
	dw .GetAway    ; MODE_GET_AWAY
	dw .Pursuit    ; MODE_PURSUIT
	dw .Survival   ; MODE_SURVIVAL
	dw .Undercover ; MODE_UNDERCOVER
	dw LoadCredits   ; MODE_CREDITS
	assert_table_length NUM_GAME_MODES

.TakeARide:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	ld hl, EntUpdate_PlayerDamageController_TakeARide
	ld c, BANK(EntUpdate_PlayerDamageController_TakeARide)
	ld b, $0b
	call SpawnEntity
	ret

.Checkpoint:
	ld a, BANK("VRAM1")
	vramswitch
	ld hl, CheckpointGfx
	ld de, v0Tiles1 tile $4a
	ld c, BANK(CheckpointGfx)
	ld b, $10 ; tiles
	call SafeCopyFarTiles
	ld hl, Go123Gfx
	ld de, v0Tiles1 tile $5a
	ld c, BANK(Go123Gfx)
	ld b, $0a ; tiles
	call SafeCopyFarTiles
	ld a, BANK("VRAM0")
	vramswitch

	call SetDefaultMaxNumNPCCars
	ld hl, NULL
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
	ld [wNumCheckpointsReached], a
	ld c, $01
	call Func_195e

	ld hl, EntUpdate_PlayerDamageController_Checkpoint
	ld c, BANK(EntUpdate_PlayerDamageController_Checkpoint)
	ld b, $0b
	call SpawnEntity
	ret

.GetAway:
	call SetDefaultMaxNumNPCCars
	ld hl, NULL
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
	ld a, ENT_CAR_PTR
	call SetStructWord_DE
	ld hl, EntUpdate_PlayerDamageController_GetAway
	ld c, BANK(EntUpdate_PlayerDamageController_GetAway)
	ld b, $0b
	call SpawnEntity
	ret

.Pursuit:
	ld a, 4
	ld [wMaxNumNPCCars], a
	ld hl, NULL
	call Func_1eda
	xor a
	ld [wTargetCarDamage], a
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
	call LoadCarGfxAndPals
	pop hl
	homecall Func_5bce

	ld a, DESTINATION_TARGET
	ld [wDestinationType], a
	ld a, l
	ld [wDestinationTargetPtr + 0], a
	ld a, h
	ld [wDestinationTargetPtr + 1], a
	ld hl, EntUpdate_PlayerDamageController_Pursuit
	ld c, BANK(EntUpdate_PlayerDamageController_Pursuit)
	ld b, $0b
	call SpawnEntity
	ret

.Survival:
	xor a
	ld [wMaxNumNPCCars], a
	ld hl, NULL
	call Func_1eda
	ld a, MAX_FELONY
	ld [wFelony], a
	call Func_1928
	ld c, $04
	call Func_195e
	ld hl, EntUpdate_PlayerDamageController_Survival
	ld c, BANK(EntUpdate_PlayerDamageController_Survival)
	ld b, $0b
	call SpawnEntity
	ret

.Undercover:
	ld a, BANK(LoadMission)
	bankswitch
	jp LoadMission

InitCredits:
	ld a, [wCreditsCity]
	ld [wCity], a

	ld a, BLACK_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_BLACK
	ld [wPlayerCarOBPal], a

	call ChooseCarPool_WithCop

	ld a, [wCity]
	call SetCity

	ld hl, CreditsPlayerSpawnParams
	call Func_1946
	call SetPlayerSpawnCoordinatesAndDirection

	ld hl, Credits1Text
	ld a, [wWhichCreditsText]
	and %1
	jr z, .got_credits_text
	ld hl, Credits2Text
.got_credits_text
	ld a, l
	ld [wdc93 + 0], a
	ld a, h
	ld [wdc93 + 1], a
	ld hl, wWhichCreditsText
	ld a, [hl]
	xor %1
	ld [hl], a

	ld hl, wCreditsCity
	ld a, [hl]
	inc a
	cp NUM_CITIES
	jr c, .valid_city
	xor a ; MIAMI
.valid_city
	ld [hl], a
	ret

LoadCredits:
	call SetDefaultMaxNumNPCCars
	ld hl, Data_1f37
	call Func_1eda
	ld a, MAX_FELONY
	ld [wFelony], a
	ld hl, EntUpdate_CreditsController
	ld c, BANK(EntUpdate_CreditsController)
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
	ld hl, Data_7dbf
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

ChooseCarPool_WithCop::
	ld hl, NPCCarPool_WithCop
	jr ChooseCarPool
ChooseCarPool_WithoutCop::
	ld hl, NPCCarPool_WithoutCop
	jr ChooseCarPool ; useless jump
ChooseCarPool:
	call Random
	and $03
	add a
	add a
	ld c, a
	add a
	add c ; *12
	add_hl
Func_1987::
	ld de, wInitialNPCCars
	ld b, NUM_INITIAL_CARS + NUM_SPAWNABLE_CARS
	jp CopyHLtoDE

; ouptut:
; - a = EXIT_TO_* constant
Func_198f:
	ld a, [wGameMode]
	jumptable
	table_width 2
	dw .TakeARide  ; MODE_TAKE_A_RIDE
	dw .Checkpoint ; MODE_CHECKPOINT
	dw .GetAway    ; MODE_GET_AWAY
	dw .Pursuit    ; MODE_PURSUIT
	dw .Survival   ; MODE_SURVIVAL
	dw .Undercover ; MODE_UNDERCOVER
	dw .Credits    ; MODE_CREDITS
	assert_table_length NUM_GAME_MODES

.Credits:
	; if player exited via input, then
	; exit to Main Menu, otherwise go to Title screen
	ld a, [wCreditsExitedByInput]
	and a
	jr z, .exit_to_titlescreen
	jr .exit_to_main_menu

.TakeARide:
	; always exit to Main Menu
	jr .exit_to_main_menu

.Checkpoint:
.GetAway:
.Pursuit:
.Survival:
	ld a, [wTitlescreenTransition]
	cp $02
	jr nz, .try_again
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
.try_again
	homecall TryAgain
	ld a, [wTryAgainSelection]
	and a
	jr z, .exit_to_main_menu
	jr .exit_to_next_mission

.Undercover:
	ld a, [wTitlescreenTransition]
	cp $02
	jr nz, .try_again
	call .Func_19ec
	ld hl, wMission
	ld a, [hl]
	inc a
	cp NUM_MISSIONS
	jr c, .go_to_next_mission
	ld [hl], NUM_MISSIONS - 1
	jr .exit_to_titlescreen
.go_to_next_mission
	ld [hl], a
	jr .exit_to_next_mission

.Func_19ec:
	ld a, [wMission]
	ld c, MIAMI
	cp LOS_ANGELES_MISSIONS - 1
	jr z, .got_city
	ld c, LOS_ANGELES
	cp NEW_YORK_MISSIONS - 1
	jr z, .got_city
	ld c, NEW_YORK
	cp NUM_MISSIONS - 1
	ret nz
.got_city
	ld a, BANK(Func_92b5)
	bankswitch
	jp Func_92b5

.exit_to_next_mission
	xor a ; EXIT_TO_NEXT_MISSION
	ret
.exit_to_main_menu
	ld a, EXIT_TO_MAIN_MENU
	ret
.exit_to_titlescreen
	ld a, EXIT_TO_TITLESCREEN
	ret

; sets the default car as the car driven by the player
SetDefaultPlayerCar::
	ld a, BLACK_CAR
	ld [wPlayerCar], a
	ld a, OBPAL_BLACK
	ld [wPlayerCarOBPal], a
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

SetPlayerSpawnCoordinatesAndDirection::
	ld a, [hli]
	ld [wPlayerCarSpawnX + 0], a
	ld a, [hli]
	ld [wPlayerCarSpawnX + 1], a
	ld a, [hli]
	ld [wPlayerCarSpawnY + 0], a
	ld a, [hli]
	ld [wPlayerCarSpawnY + 1], a
	ld a, [hl]
	ld [wPlayerCarSpawnDir], a
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
	ld a, [wCameraX]
	ld [hli], a
	ld a, [wCameraY]
	ld [hli], a
	ldh a, [hff99]
	ld [hli], a
.asm_1aa6
	ld a, [wGameMode]
	cp MODE_CREDITS
	jr z, .asm_1adf
	ld a, [wHUDMessageStep]
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

	; spawn car spawner controller
	ld hl, EntUpdate_CarSpawner
	ld c, BANK(EntUpdate_CarSpawner)
	ld b, $03
	call SpawnEntity

	homecall SpawnPlayer

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
	ld [wDestinationType], a
	ld hl, EntUpdate_DestinationArrow
	ld c, BANK(EntUpdate_DestinationArrow)
	ld b, $07
	call SpawnEntity
	ld hl, EntUpdate_NearbyDestinationArrow
	ld c, BANK(EntUpdate_NearbyDestinationArrow)
	ld b, $08
	call SpawnEntity

	ld a, [wGameMode]
	cp MODE_CREDITS
	jr z, .skip_music
	call StopSound
	ld a, [wCity]
	ld hl, .MusicIDs
	add_hl
	ld a, [hl]
	call PlayMusic
.skip_music
	ld a, $01
	jp InitFade

.MusicIDs:
	table_width 1
	db MUSIC_MIAMI       ; MIAMI
	db MUSIC_LOS_ANGELES ; LOS_ANGELES
	db MUSIC_NEW_YORK    ; NEW_YORK
	assert_table_length NUM_CITIES

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

Func_1c57:
	ld a, [wJoypadDown]
	ld c, a
	ld a, [wc573]
	xor c
	and c
	ld [wc574], a
	ld a, c
	ld [wc573], a

	; handle input to disply debug mode
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
	; exit if not in Credits
	ld a, [wGameMode]
	cp MODE_CREDITS
	ret z

	; exit if fading active
	ld a, [wFadeActive]
	and a
	ret nz

	; exit if wd820 != 1
	ld a, [wd820]
	cp $01
	ret nz

	; exit if not pressing Start
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
	ld a, NONE
	ld [wActiveCheats], a

	ld a, MIAMI_UNLOCKED
	ld [wUnlockedCities], a

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
	ld [wMission], a ; MISSION_THE_BANK_JOB
	ld [wCreditsCity], a ; MIAMI
	ld [wWhichCreditsText], a

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
LoadCarGfxAndPals::
	push hl
	ld c, a
	ld a, $48
	ld [wVRAMNumTiles_v1_8800], a
	ld b, V1TILES_8800
	call _LoadCarGfx
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
	ld hl, wInitialNPCCars
	ld b, NUM_INITIAL_CARS
.loop_load_nps_cars
	ld a, [hli]
	push bc
	ld b, V0TILES_8000
	call LoadCarGfx
	pop bc
	dec b
	jr nz, .loop_load_nps_cars

	; load player's car graphics
	ld a, [wPlayerCar]
	ld b, V1TILES_8000
	call LoadCarGfx

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
	ld hl, wPropTileIDMap
	add_hl
	ld a, [wVRAMNumTiles_v1_8000]
	ld [hli], a
	ld a, $08
	ld [hl], a
	ld a, c
	add a
	ld hl, PropGfxTable
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
	cp BROWN_CAR
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
	ld de, wPropTileIDMap + 1
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
LoadCarGfx:
	push hl
	ld c, a
	call _LoadCarGfx
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
	ld a, BANK(Credits1Text) ; same as BANK(Credits2Text)
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
	ld [wdc93 + 0], a
	ld a, h
	ld [wdc93 + 1], a
.asm_1eb6
	ld hl, wTextBuffer
	pop af
	bankswitch
	ret

; input:
; - hl = texts pointer
; - c  = duration
ShowHUDMessage::
	ldh a, [hROMBank]
	push af
	homecall _ShowHUDMessage
	pop af
	bankswitch
	ret

; sets wMaxNumNPCCars to 5
SetDefaultMaxNumNPCCars::
	ld a, 5
	ld [wMaxNumNPCCars], a
	ret

; input:
; - hl = some data used in Func_1eee
Func_1eda::
	ld a, l
	ld [wd82e + 0], a
	ld a, h
	ld [wd82e + 1], a
	call Func_1eee
	ld a, [wCopSpawnCooldown]
	srl a ; /2
	ld [wCopSpawnTimer], a
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
	ld de, 0 * $6
	cp 18
	jr c, .add_hl_de
	ld de, 1 * $6
	cp 36
	jr c, .add_hl_de
	ld de, 2 * $6
	cp MAX_FELONY
	jr c, .add_hl_de
	ld de, 3 * $6
.add_hl_de
	add hl, de
Func_1f19::
	ld a, [hli]
	ld [wd830], a
	ld a, [hli]
	ld [wCopSpawnCooldown], a
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
	db $01, 4, $1e, $20, $b4, $00 ;  0 <= felony < 18
	db $01, 3, $15, $1c, $f0, $00 ; 18 <= felony < 36
	db $01, 2, $0f, $18, $2c, $01 ; 36 <= felony < MAX_FELONY
	db $02, 2, $07, $14, $68, $01 ; felony == MAX_FELONY

Data_1f4f::
	db $00, 0, $00, $00, $00, $00 ;  0 <= felony < 18
	db $00, 0, $00, $00, $00, $00 ; 18 <= felony < 36
	db $00, 0, $00, $00, $00, $00 ; 36 <= felony < MAX_FELONY
	db $03, 0, $07, $00, $f0, $00 ; felony == MAX_FELONY

NPCCarPool_WithoutCop:
	db CAR_03, CAR_04, CAR_05, TAXI
	db CAR_03, CAR_03, CAR_04, CAR_04, CAR_05, CAR_05, TAXI, TAXI

	db CAR_03, CAR_04, TAXI, CAR_10
	db CAR_03, CAR_03, CAR_04, CAR_04, TAXI, TAXI, CAR_10, CAR_10

	db CAR_03, CAR_09, CAR_10, TAXI
	db CAR_03, CAR_03, CAR_09, CAR_09, CAR_10, CAR_10, TAXI, TAXI

	db CAR_04, CAR_09, CAR_10, TAXI
	db CAR_04, CAR_04, CAR_09, CAR_09, CAR_10, CAR_10, TAXI, TAXI

NPCCarPool_WithCop:
	db COP_CAR, TAXI, CAR_03, CAR_04
	db CAR_03, CAR_03, CAR_03, CAR_04, CAR_04, CAR_04, TAXI, TAXI

	db COP_CAR, CAR_03, CAR_04, CAR_05
	db CAR_03, CAR_03, CAR_04, CAR_04, CAR_05, CAR_05, CAR_03, CAR_03

	db COP_CAR, CAR_03, CAR_09, TAXI
	db CAR_03, CAR_03, CAR_03, CAR_03, CAR_09, CAR_09, TAXI, TAXI

NPCCarPool_GrandCentralStation::
	db COP_CAR, CAR_05, CAR_10, TAXI
	db CAR_05, CAR_05, CAR_05, CAR_05, CAR_10, CAR_10, TAXI, TAXI

ToggleDebugMode:
	ld a, [wd895]
	and a
	ret nz

	ld hl, wDMGPals
	ld bc, 7 palettes
	ld a, $ff
	call FillMemory
	call FlushCGBPalettes

	call GetCityGfxPointer
	ld a, [wDebugModeActive]
	and a
	jr nz, .not_debug
	ld a, $8
	add_hl
.not_debug
	call LoadCityPalettesAndTiles
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

Func_200a::
	ldh a, [hROMBank]
	push af
	call GetCityGfxPointer
	ld a, [wDebugModeActive]
	and a
	jr z, .asm_2019
	ld a, $8
	add_hl
.asm_2019
	call LoadCityPalettesAndTiles
	call Func_2216
	pop af
	bankswitch
	ret

Func_2026:
	xor a
	ld [wDebugModeActive], a

	call GetCityGfxPointer
	call LoadCityPalettesAndTiles
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
	ld hl, -SCREEN_WIDTH_PX
	add hl, de
	ld a, l
	ld [wMapWidth + 0], a
	ld a, h
	ld [wMapWidth + 1], a
	pop hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	ld hl, -128
	add hl, de
	ld a, l
	ld [wMapHeight + 0], a
	ld a, h
	ld [wMapHeight + 1], a
	pop hl
	call Func_2101
	ld a, c
	ld [wCameraX + 0], a
	ld [wd7fb], a
	ld a, b
	ld [wCameraX + 1], a
	ld [wd7fc], a
	ld a, e
	ld [wCameraY + 0], a
	ld [wd7f9 + 0], a
	ld a, d
	ld [wCameraY + 1], a
	ld [wd7f9 + 1], a
	call Func_2216

	ld de, wd80f
	xor a
	ld [wdc7e], a
.asm_209c
	call .Func_20dc
	ld a, $35
	bankswitch
	ld hl, $7e0d
	lb bc, $0f, $00
.asm_20ac
	push bc
	push de
	push hl
	call .Func_20ce
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

.Func_20ce:
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

.Func_20dc:
	push bc
	push de
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *$10
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
	ld hl, wPlayerCarSpawnX
	ld de, wda23X
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, wPlayerCarSpawnY
	ld de, wda23Y
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wPlayerCarSpawnDir]
	ld [wda23Dir], a
	xor a
	ld [wda23Speed + 1], a
	ld hl, wda23
	homecall Func_43be
	push bc
	ld c, e
	ld b, d
	pop de
	ret

LoadCityPalettesAndTiles:
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
	ld a, $80 ; tiles
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

; input:
; - bc = x coordinate
; - de = y coordinate
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

; input:
; - bc = x coordinate
; - de = y coordinate
; - [hl] = bank
; output:
; - h = ?
; - l = ?
Func_21a4:
	push bc
	push hl

	; de = %bb_yyyyy_zzzzz
	; where %bb is added to [hl] to get the bank number
	; and %yyyyy is row number
	ld a, d
	rrca
	rrca
	rrca ; /8
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

	; bc = %xxxxxxxx_zzzzz
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
	; hl = %yyyyyxxxxxxxx
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
	; hl = ((de & $ffe0) << 1)
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
	ld hl, wCameraY
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
	ld de, wCameraY
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
	ld hl, wCameraY
	call Func_2438
.asm_23f1
	ld hl, wd7fb
	ld de, wCameraX
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
	ld hl, wCameraX
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
	; hl = [hl] - [de]
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
	ld hl, wCameraY
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
	ld hl, wCameraY
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
	ld hl, wCameraX
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
	ld hl, wCameraX
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

Func_254a:
	ld hl, wCameraX
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret

Func_2551:
	ld hl, wCameraY
	ld e, [hl]
	inc hl
	ld d, [hl]
	ret

; input:
; - bc = x coordinate
; - de = y coordinate
; output:
; - a  = ?
Func_2558::
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

; outputs in hl pointer to gfx related to city in wCity
GetCityGfxPointer:
	ld a, [wCity]
	ld hl, .GfxTable
	add a
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

.GfxTable:
	table_width 2
	dw .Miami      ; MIAMI
	dw .LosAngeles ; LOS_ANGELES
	dw .NewYork    ; NEW_YORK
	assert_table_length NUM_CITIES

.Miami:
	dba Pals_c5320
	dba MiamiGfx
	db $1a, $06

	dba Pals_c5450
	dba MiamiDebugGfx
	db $1c, $0b

	; width, height
	dw 8192, 8192

.LosAngeles:
	dba Pals_c6800
	dba LosAngelesGfx
	db $1e, $10

	dba Pals_c6930
	dba LosAngelesDebugGfx
	db $20, $15

	; width, height
	dw 8192, 8192

.NewYork:
	dba Pals_c7a40
	dba NewYorkGfx
	db $2c, $22

	dba Pals_c7b70
	dba NewYorkDebugGfx
	db $2e, $27

	; width, height
	dw 8192, 8192

Func_25e5:
	ld b, MAX_NUM_CARS
	ld hl, wCars
	ld de, CAR_STRUCT_SIZE
	xor a
.loop_cars
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop_cars
	ret

; returns in hl pointer to first inactive car in wCars
; returns carry if all of them are active
FindFreeCarSlot:
	push bc
	push de
	ld b, MAX_NUM_CARS
	ld hl, wCars
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
; - a  = direction
; - h  = OBPAL_* constant
; - l  = CAR_* constant
; - bc = x coordinate
; - de = y coordinate
SpawnCar::
	ld [wdc7a], a
	ld a, l
	ld [wdc7c], a
	ld a, h
	ld [wdc7e], a
	call FindFreeCarSlot
	ret c ; couldn't find free slot
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
	ld [hli], a ; CARSTRUCT_Y_FRAC
	ld [hl], e  ; CARSTRUCT_Y
	inc hl
	ld [hl], d
	inc hl
	ld [hli], a ; CARSTRUCT_X_FRAC
	ld [hl], c  ; CARSTRUCT_X
	inc hl
	ld [hl], b
	inc hl
	ld a, [wdc7a]
	ld [hl], a ; CARSTRUCT_DIR
	pop hl
	and a
	ret

; applies a brake with speed value in bc
ApplyBrakeSpeed::
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

; unreferenced
Func_2688:
	ld a, $0e
	call GetStructByte_A
	ld e, a
	and $80
	jr z, .asm_2699
	xor a
	sub c
	ld c, a
	ld a, $00
	sbc b
	ld b, a
.asm_2699
	push de
	ld a, $0d
	call AddStructWord_BC
	pop de
	ld a, $0e
	call GetStructByte_A
	xor e
	and $80
	ret z
	bit 7, e
	ld de, $7f00
	jr z, .asm_26b3
	ld de, $8000
.asm_26b3
	ld a, $0d
	jp SetStructWord_DE

; compares car's absolute speed to c
; returns carry set if abs(speed) < c
CompareCarSpeed::
	ld a, CARSTRUCT_SPEED + 1
	call GetStructByte_A
	bit 7, a
	jr z, .compare
	cpl
	inc a
.compare
	cp c
	ret

; returns nz if car's speed is at least 0.0625q12
IsCarSpeedNonZero:
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
	ld a, CARSTRUCT_DIR
	add_hl
	ld a, [hl]
	pop hl
	call Func_271b
	push hl
	push de
	ld de, CARSTRUCT_SPEED + 1
	add hl, de
	bit 7, [hl] ; negative speed?
	pop de
	pop hl
	ret z
;	fallthrough
Func_26ef::
	push hl
	ld hl, .Data
	add_hl
	ld a, [hl]
	pop hl
	ret

.Data:
	db $00, $04, $08, $0c, $01, $00, $09, $00, $02, $06, $00, $00, $03, $00, $00, $00

Func_2707::
	push hl
	ld h, d
	ld l, e
	call Func_26db
	pop hl
	ret

Func_270f::
	push hl
	ld a, CARSTRUCT_SPRITE_PTR
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]
	and SPRITEFLAG_UNK3
	pop hl
	ret

Func_271b::
	cp 90 deg
	jr c, .asm_273f
	cp 180 deg
	jr c, .asm_2737
	cp 270 deg
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
	ld hl, .data
	add_hl
	ld a, [hl]
	pop hl
	ret

.data
	db $00, $00, $40, $20, $80, $00, $60, $00, $c0, $e0, $00, $00, $a0, $00, $00, $00

Func_275f::
	push de
	push hl
	ld a, CARSTRUCT_Y
	add_hl
	ld a, [hli] ; CARSTRUCT_Y
	push hl
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_Y
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
; - hl = car struct 1
; - de = car struct 2
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

; output:
; - bc = y offset
; - de = x offset
CalculateCarSpeedOffsets::
	call IsCarSpeedNonZero
	jr nz, .non_zero
	ld b, a
	ld c, a
	ld d, a
	ld e, a
	ret
.non_zero
	call CalculateCarDirectionComponents
	ld a, b
	or c
	call nz, CalculateCarSpeedComponent
	ld a, d
	or e
	jr z, .ret_nz
	push bc
	ld b, d
	ld c, e
	call CalculateCarSpeedComponent
	ld d, b
	ld e, c
	pop bc
.ret_nz
	xor a
	dec a
	ret

CalculateCarSpeedComponent:
	ld a, CARSTRUCT_SPEED + 1
	push hl
	add_hl
	ld a, [hl]
	call CalculateSpeedComponent
	pop hl
	ret

Func_2877::
	push hl
	ld a, CARSTRUCT_0F
	add_hl
	ld a, [hl]
	call CalculateDirectionComponents
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
	call CalculateSpeedComponent
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
	ld a, CARSTRUCT_10
	call SetStructWord_BC
	pop af
	ld c, a
	ld a, CARSTRUCT_0F
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
	call CalculateDirectionComponents
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

; adds bc to y coordinate
; adds de to x coordinate
AddToCarCoordinates::
	push de
	ld a, CARSTRUCT_Y_FRAC
	call AddBCToStructField
	pop bc
	ld a, CARSTRUCT_X_FRAC
	jp AddBCToStructField

; given bc, a q8 number, multiply it
; with a, a q4 number (which is taken from the
; high byte of a q12 precision number)
; output result in bc
CalculateSpeedComponent::
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

; calculates bc = bc * (a >> 4)
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

; input:
; - hl = Car*
; output:
; - de = cos(Car->dir)
; - bc = sin(Car->dir)
CalculateCarDirectionComponents::
	push hl
	ld a, CARSTRUCT_DIR
	add_hl
	ld a, [hl]
	call CalculateDirectionComponents
	pop hl
	ret

Func_29e0::
	push hl
	ld a, CARSTRUCT_DIR
	add_hl
	ld a, [hl]
	call Func_2a7e
	pop hl
	ret

; outputs components in x and y of
; a unit vector with direction given by a
; output:
; - de = cos(a)
; - bc = sin(a)
CalculateDirectionComponents::
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
	ld hl, .PtrTable
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.PtrTable:
	dw Func_2a2c ; 0 deg < angle < 90 deg
	dw Func_2a10 ; angle == 0 deg
	dw Func_2a3c ; 90 deg < angle < 180 deg
	dw Func_2a17 ; angle == 90 deg
	dw Func_2a49 ; 180 deg < angle < 270 deg
	dw Func_2a1e ; angle == 180 deg
	dw Func_2a59 ; 270 deg < angle < 360 deg
	dw Func_2a25 ; angle == 270 deg

; outputs (-1.0, 0.0)
Func_2a10:
	ld bc, -1.0
	ld de,  0.0
	ret

; outputs (0.0, 1.0)
Func_2a17:
	ld bc, 0.0
	ld de, 1.0
	ret

; outputs (1.0, 0.0)
Func_2a1e:
	ld bc, 1.0
	ld de, 0.0
	ret

; outputs (0.0, -1.0)
Func_2a25:
	ld bc,  0.0
	ld de, -1.0
	ret

; outputs (-cos(c), sin(c))
Func_2a2c:
	call Sine
	ld e, a
	ld d, 0
	call Cosine
	ld c, a
	xor a
	sub c
	ld c, a
	ld b, -1
	ret

; outputs (cos(c), sin(c))
Func_2a3c:
	call Cosine
	ld e, a
	ld d, 0
	call Sine
	ld c, a
	ld b, 0
	ret

; outputs (cos(c), -sin(c))
Func_2a49:
	call Sine
	ld e, a
	xor a
	sub e
	ld e, a
	ld d, -1
	call Cosine
	ld c, a
	ld b, 0
	ret

; outputs (-cos(c), -sin(c))
Func_2a59:
	call Cosine
	ld e, a
	xor a
	sub e
	ld e, a
	ld d, -1
	call Sine
	ld c, a
	xor a
	sub c
	ld c, a
	ld b, -1
	ret

; returns sin((c & 64) / 64 * pi/2)
Sine:
	ld a, c
	maskbits 64
	ld hl, SineTable
	add_hl
	ld a, [hl]
	ret

; returns cos((c & 64) / 64 * pi/2)
Cosine:
	ld a, c
	maskbits 64
	; cosine table is sine table mirrored
	ld hl, SineTableEnd
	sub_hl
	ld a, [hl]
	ret

Func_2a7e:
	call CalculateDirectionComponents
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
	ld a, CARSTRUCT_SPEED + 1
	add_hl
	ld c, [hl]
	ld a, CARSTRUCT_11 - (CARSTRUCT_SPEED + 1)
	add_hl
	ld a, [hl]
	or c
	pop hl
	jr z, .done
	ld de, wda4d
	call Func_2c37
	call Func_2cbb
	call AddToCarCoordinates
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
	call CompareCarSpeed
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
	call CompareCarSpeed
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
	ld a, [wda4f]
	ld c, a
	ld a, [wda50]
	ld b, a
	ld a, [wda51]
	ld e, a
	ld a, [wda52]
	ld d, a
	jr Func_2c6b
Func_2c5b:
	ld a, [wda53]
	ld c, a
	ld a, [wda54]
	ld b, a
	ld a, [wda4d]
	ld e, a
	ld a, [wda4e]
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
	ld a, CARSTRUCT_DIR
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
	call CalculateDirectionComponents
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
	jp CalculateSpeedComponent

; unreferenced
Func_2d4d:
	push hl
	ld a, $0c
	add_hl
	ld a, [hl]
	and $0f
	cp $08
	jr nc, .asm_2d5e
	ld a, [hl]
	and $f0
	ld [hl], a
	jr .asm_2d64
.asm_2d5e
	ld a, [hl]
	and $f0
	add $10
	ld [hl], a
.asm_2d64
	pop hl
	ret

; input:
; - b = y component
; - c = x component
; - [wda59] = ?
Func_2d66::
	call Arctan
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
	ld a, 180 deg
	sub c
	ret
.asm_2d81
	ld a, c
	add 180 deg
	ret
.asm_2d85
	ld a, c
	ret

; output:
; - a = atan(c/b)
Arctan:
.loop
	ld a, c
	and a
	ret z ; exit with 0 deg
	ld a, b
	and a
	jr z, .zero_y
	cp 17
	jr nc, .halve_vals
	ld a, c
	cp 17
	jr nc, .halve_vals
	; 0 < b < 16
	; 0 < c < 16
	dec a
	dec b
	add a
	add a
	add a
	add a
	add b
	; a = (c - 1) * 16 + (b - 1)
	push hl
	ld hl, ArctanTable
	add_hl
	ld a, [hl]
	pop hl
	ret
.halve_vals
	srl c
	srl b
	jr .loop
.zero_y
	ld a, 90 deg
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

; output:
; - bc = x coordinate
; - de = y coordinate
Func_2dd5::
	ld a, [wDestinationType]
	and a
	ret z
	cp DESTINATION_COORDINATE
	jr z, .coordinate
	cp DESTINATION_SPRITE
	jr z, .sprite

; target
	push hl
	ld hl, wDestinationTargetPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, CARSTRUCT_Y
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

.coordinate
	push hl
	ld hl, wDestinationCoords
	ld c, [hl] ; x
	inc hl
	ld b, [hl]
	inc hl
	ld e, [hl] ; y
	inc hl
	ld d, [hl]
	pop hl
	scf
	ret

.sprite
	push hl
	ld hl, wDestinationSpritePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	ld e, [hl] ; SPRITESTRUCT_Y
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld c, [hl] ; SPRITESTRUCT_X
	inc hl
	ld b, [hl]
	ld a, 8
	add_de
	ld a, 8
	add_bc
	pop hl
	scf
	ret

SineTable:
	FOR x, 0.0, 0.25, 0.25 / 64
		dbmin SIN(x), $ff
	ENDR
SineTableEnd:


MACRO? dbdeg
	REPT _NARG
		db \1 deg
		SHIFT
	ENDR
ENDM

; seems like some values are slightly off from RGBDS' built-in ATAN
;	FOR x, 1.0, 17.0, 1.0
;		FOR y, 1.0, 17.0, 1.0
;			db ATAN(DIV(x, y))
;		ENDR
;	ENDR
ArctanTable:
	dbdeg 45, 27, 19, 15, 12, 10,  9,  8,  8,  6,  6,  5,  5,  5,  5,  5
	dbdeg 64, 45, 34, 27, 23, 19, 16, 15, 13, 12, 10, 10,  9,  9,  8,  8
	dbdeg 72, 57, 45, 37, 31, 27, 23, 22, 19, 17, 16, 15, 13, 13, 12, 12
	dbdeg 76, 64, 54, 45, 38, 34, 30, 27, 24, 23, 20, 19, 17, 16, 16, 15
	dbdeg 79, 68, 60, 53, 45, 40, 36, 33, 30, 27, 24, 23, 22, 20, 19, 17
	dbdeg 81, 72, 64, 57, 51, 45, 41, 37, 34, 31, 29, 27, 26, 23, 23, 22
	dbdeg 82, 75, 68, 61, 55, 50, 45, 41, 38, 36, 33, 31, 29, 27, 26, 24
	dbdeg 83, 76, 69, 64, 58, 54, 50, 45, 43, 38, 37, 34, 31, 30, 29, 27
	dbdeg 83, 78, 72, 67, 61, 57, 53, 48, 45, 43, 40, 37, 36, 33, 31, 30
	dbdeg 85, 79, 74, 68, 64, 60, 55, 53, 48, 45, 43, 40, 38, 36, 34, 33
	dbdeg 85, 81, 75, 71, 67, 62, 58, 54, 51, 48, 45, 43, 41, 38, 37, 36
	dbdeg 86, 81, 76, 72, 68, 64, 60, 57, 54, 51, 48, 45, 43, 41, 38, 37
	dbdeg 86, 82, 78, 74, 69, 65, 62, 60, 55, 53, 50, 48, 45, 43, 41, 40
	dbdeg 86, 82, 78, 75, 71, 68, 64, 61, 58, 55, 53, 50, 48, 45, 44, 41
	dbdeg 86, 83, 79, 75, 72, 68, 65, 62, 60, 57, 54, 53, 50, 47, 45, 44
	dbdeg 86, 83, 79, 76, 74, 69, 67, 64, 61, 58, 55, 54, 51, 50, 47, 45

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
	swap_hl_de
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
	ld a, CARSTRUCT_SPRITE_PTR
	call GetStructWord_DE

	push de
	push hl
	inc de
	inc de
	ld a, CARSTRUCT_Y
	add_hl
	ld a, [hli]
	sub LOW(8)
	ld [de], a ; SPRITESTRUCT_Y
	inc de
	ld a, [hli]
	sbc HIGH(8)
	ld [de], a
	inc de
	inc hl
	inc de
	ld a, [hli] ; CARSTRUCT_X
	sub LOW(8)
	ld [de], a ; SPRITESTRUCT_X
	inc de
	ld a, [hl]
	sbc HIGH(8)
	ld [de], a
	pop hl
	pop de

	ld a, CARSTRUCT_DIR
	call GetStructByte_A
	add 7 deg
	rrca
	rrca
	rrca ; /8
	and $1f
	ld c, a
	push hl
	ld hl, CarDirectionSpriteFlags
	ld b, $00
	add hl, bc
	ld a, [de]
	and ~(SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP)
	or [hl]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
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
	ld a, SPRITESTRUCT_X
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
	ld a, 2 * TILE_HEIGHT
	ld [de], a ; SPRITESTRUCT_HEIGHT
	inc de
	ld a, b
	ld [de], a ; SPRITESTRUCT_WIDTH
	inc de
	push hl
	inc hl
	ld a, [hli] ; CARSTRUCT_01
	ld b, [hl]  ; CARSTRUCT_02
	ld hl, wCarTileIDAndAttributeMap
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
	ld [hl], c ; SPRITESTRUCT_TILE_1
	inc hl
	ld [hl], b ; SPRITESTRUCT_ATTR_1
	inc hl
	inc c
	inc c
	ld [hl], c ; SPRITESTRUCT_TILE_2
	inc hl
	ld [hl], b ; SPRITESTRUCT_ATTR_2
	pop hl
	pop af
	bankswitch
	ret

; input:
; - c  = CAR_* constant
; - b  = $0 for v0Tiles0, $1 for v0Tiles2, $2 for v0Tiles1
;        $3 for v1Tiles0, $4 for v1Tiles2, $5 for v1Tiles1
_LoadCarGfx:
	ldh a, [hROMBank]
	push af
	ld a, BANK(CarGfxTable)
	bankswitch
	ld hl, wCarTileIDAndAttributeMap
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
	ld a, OAM_BANK0
	jr c, .asm_311b
	ld a, OAM_BANK1
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
	ld hl, wda23Coords
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
	call OverwriteEntityUpdateFunc
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
	call AddToCarCoordinates
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
	call CalculateDirectionComponents
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
	call AddToCarCoordinates
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
	ld hl, wCameraY
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
	ld hl, wCameraX
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
	ld hl, wCameraY
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
	ld hl, wCameraY
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
	dw .Func_34ff
	dw .Func_3506
	dw .Func_350d

.Func_34ff:
	pop hl
	ld a, [hl]
	cp e
	jr c, .no_carry
	jr .set_carry

.Func_3506:
	pop hl
	ld a, e
	cp [hl]
	jr c, .no_carry
	jr .set_carry

.Func_350d:
	pop hl
	ld a, e
	add $87
	cp [hl]
	jr c, .no_carry
	ld a, [hl]
	cp e
	jr c, .no_carry
.set_carry
	dec hl
	scf
	ret
.no_carry
	dec hl
	and a
	ret

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
	call nz, .Func_359c
	ld a, $13
	add_hl
	dec b
	jr nz, .asm_358c
	and a
.ret
	pop hl
	pop de
	pop bc
	ret

.Func_359c:
	push hl
	inc hl
	ld a, [hli]
	cp e
	jr nz, .asm_35a6
	ld a, [hl]
	cp d
	jr z, .ret_carry
.asm_35a6
	pop hl
	ret
.ret_carry
	pop hl
	pop hl
	scf
	jr .ret

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
	swap_hl_de
	ld a, CARSTRUCT_0F
	call SetStructWord_DE
	call AllocateSprite
	jr c, .asm_362e
	ld a, CARSTRUCT_11
	call SetStructWord_DE
	ld a, [de]
	or SPRITEFLAG_VISIBLE | SPRITEFLAG_FIXED
	ld [de], a
	ld a, SPRITESTRUCT_HEIGHT
	add_de
	ld a, 2 * TILE_HEIGHT
	ld [de], a ; SPRITESTRUCT_HEIGHT
	inc de
	ld a, TILE_WIDTH
	ld [de], a ; SPRITESTRUCT_WIDTH
	jp Func_3637
.asm_362b
	xor a
	ld [de], a
	ret
.asm_362e
	ld [hl], $00
	ld a, CARSTRUCT_0F
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
	ld de, wPropTileIDMap
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
	set CARFLAG_PLAYER_F, [hl]
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
	ld a, CARSTRUCT_Y + 1
	call GetStructByte_A
	rrca
	rrca
	and $3f
	ld b, a
	push hl
	ld a, CARSTRUCT_Y_FRAC
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
	ld a, CARSTRUCT_05
	call GetStructByte_A
	push hl
	call CalculateDirectionComponents
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
	ld a, CARSTRUCT_X_FRAC
	call AddBCToStructField
	pop bc
	ld a, CARSTRUCT_DIR
	jp AddBCToStructField

Func_37e3:
	ld a, CARSTRUCT_Y + 1
	call GetStructByte_A
	push de
	push hl
	call CalculateSpeedComponent
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
	ld a, CARSTRUCT_X_FRAC
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
	table_width 3
	dba Data_10000 ; MIAMI
	dba Data_14000 ; LOS_ANGELES
	dba Data_c0000 ; NEW_YORK
	assert_table_length NUM_CITIES

MACRO? data_382c
	db \1 ; num of tiles
	dba \2 ; graphics
ENDM

PropGfxTable:
	table_width 4
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
	assert_table_length NUM_PROPS

Data_3864:
    db $04, $04, $04, $02, $02, $03, $00, $02
	db $05, $02, $02, $03, $02, $02

	db $00, $ff, $40, $ff, $00, $ff, $00, $ff, $c0, $fe, $00, $fd, $00, $ff, $40, $ff
    db $40, $ff, $00, $ff, $00, $ff, $00, $ff, $c0, $fe, $00
