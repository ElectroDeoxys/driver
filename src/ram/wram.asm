SECTION "WRAM Virtual OAM", WRAM0

wVirtualOAM1:: ; c000
	ds OAM_SIZE
	ds $60
wVirtualOAM2:: ; c100
	ds OAM_SIZE
	ds $60

wVirtualOAM3:: ; c200
	ds OAM_SIZE
	ds $60
wVirtualOAM4:: ; c300
	ds OAM_SIZE
	ds $60

SECTION "WRAM Audio", WRAM0

wAudioTracks:: ; c400
FOR n, 0, NUM_AUDIO_TRACKS
wTrack{u:n}:: audio_track_struct wTrack{u:n}
ENDR

wc4b0:: db ; c4b0

wAudioChannels:: ; c4b1
FOR n, 1, NUM_AUDIO_CHANNELS + 1
wChannel{u:n}:: audio_channel_struct wChannel{u:n}
ENDR

wc51d:: dw ; c51d
wc51f:: dw ; c51f
wc521:: dw ; c521

wc523:: dw ; c523
wc525:: dw ; c525

wc527:: dw ; c527
wc529:: db ; c529

wc52a:: db ; c52a

wc52b:: db ; c52b

	ds $c540 - $c52c

wAudioBank:: db ; c540
wc541:: db ; c541

wc542:: db ; c542

	ds $c544 - $c543

SECTION "WRAM", WRAM0

wc544:: db ; c544

wc545:: db ; c545

; variables related to audio queue
; each entry is 2 bytes in size,
; corresponding to an audio function and argument
wAudioQueueValid::    db ; c546
wAudioQueueSize::     db ; c547
wAudioQueueIterator:: dw ; c548
wAudioQueue::         ds MAX_AUDIO_QUEUE_SIZE * 2 ; c54a

; if TRUE then resetting game through A+B+START+SELECT is disabled
wResetDisabled:: db ; c56a
wResetDelay::    db ; c56b

wFrameCounter:: db ; c56c
wc56d:: db ; c56d

wVBlankExecuted:: db ; c56e
wActiveVirtualOAM:: db ; c56f
wBufferedVirtualOAM:: db ; c570

wJoypadPressed:: db ; c571
wJoypadDown::    db ; c572

wc573:: db ; c573

wc574:: db ; c574

wRNG:: ; c575
	ds $4

wc579:: db ; c579

wc57a:: db ; c57a

	ds $c57d - $c57b

; palettes either for CGB or DMG
UNION
wCGBPals::
wBGPals:: ds 8 palettes ; c57d
wOBPals:: ds 8 palettes ; c5bd
NEXTU
wDMGPals::
wBGP::  db ; c57d
wOBP0:: db ; c57e
wOBP1:: db ; c57f
ENDU

UNION
wTempCGBPals::
wTempBGPals:: ds 8 palettes ; c5fd
wTempOBPals:: ds 8 palettes ; c63d
NEXTU
wTempDMGPals::
wTempBGP::  db ; c5fd
wTempOBP0:: db ; c5fe
wTempOBP1:: db ; c5ff
ENDU

wFadeActive:: db ; c67d

wc67e:: db ; c67e
; represents number of steps done at a time when fading colours
wFadeSpeed:: db ; c67f

wFadeColourChanged:: db ; c680

wc681::           dw ; c681
wc683::           dw ; c683
wLCDSettingsPtr:: dw ; c685

wLCDSettings:: lcd_struct wLCDSettings ; c687

	ds $c6cf - $c68b

wc6cf:: lcd_struct wc6cf ; c6cf

	ds $c717 - $c6d3

wEntities:: ; c717
FOR n, 0, NUM_ENTITIES
wEntity{u:n}:: entity_struct wEntity{u:n}
ENDR

; holds main sp while executing entity update functions
wTempSP:: dw ; d217

wEntityPtr:: dw ; d219

; OAM group structs, divided up along
; 8 horizontal slices along the height of the screen
; this makes it so that each screen slice
; doesn't exceed a number of OAM data (20 each)
; (see src/constants/sprite_constants.asm)
wOAMGroups:: ; d21b
FOR n, 1, NUM_OAM_GROUPS + 1
wOAMGroup{u:n}:: oam_group_struct wOAMGroup{u:n}
ENDR

wSpriteFlags:: db ; d545

wTempOAMX:: db ; d546

wTempOAMY:: db ; d547

wd548:: db ; d548

	ds $d54b - $d549

wd54b:: db ; d54b

wd54c:: db ; d54c

wd54d:: db ; d54d

wd54e:: db ; d54e
wd54f:: dw ; d54f

wSprites:: ; d551
FOR n, 1, $20 + 1
wSprites{u:n}:: sprite_struct wSprites{u:n}
ENDR

; multipurpose buffer for temporarily
; holding tile/bg map data
wGfxBuffer:: ; d771
	ds $40

wd7b1:: ; d7b1
	ds $40

wVRAMNumTiles::
wVRAMNumTiles_v0_8000:: db ; d7f1
wVRAMNumTiles_v0_9000:: db ; d7f2
wVRAMNumTiles_v0_8800:: db ; d7f3
wVRAMNumTiles_v1_8000:: db ; d7f4
wVRAMNumTiles_v1_9000:: db ; d7f5
wVRAMNumTiles_v1_8800:: db ; d7f6

wd7f7:: db ; d7f7

wNumTilesToPush:: db ; d7f8

wd7f9:: dw ; d7f9

wd7fb:: db ; d7fb

wd7fc:: db ; d7fc

wCameraY:: dw ; d7fd
wCameraX:: dw ; d7ff

wd801:: db ; d801

wd802:: db ; d802

wd803:: db ; d803

wd804:: db ; d804

; map's dimensions
wMapWidth::  dw ; d805
wMapHeight:: dw ; d807

wd809:: db ; d809

wd80a:: db ; d80a

wd80b:: db ; d80b

wd80c:: db ; d80c

wd80d:: db ; d80d

wd80e:: db ; d80e

wd80f:: db ; d80f

	ds $d81e - $d810

wDebugModeActive:: db ; d81e

wGameMode:: db ; d81f

wd820:: db ; d820

wTitlescreenTransition:: db ; d821

wd822:: db ; d822

wCity:: db ; d823

wd824:: dw ; d824

; which CAR_* player is driving
wPlayerCar:: db ; d826
wPlayerCarOBPal::      db ; d827

wPlayerCarSpawnX:: dw ; d828
wPlayerCarSpawnY:: dw ; d82a

wPlayerCarSpawnDir:: db ; d82c

wd82d:: db ; d82d

wd82e:: dw ; d82e

wd830:: db ; d830

; every time a cop is spawned, wCopSpawnTimer is set to wCopSpawnCooldown
; and then is counted down until it reaches 0, which will spawn another cop
wCopSpawnCooldown:: db ; d831
wCopSpawnTimer::    db ; d832

wd833:: db ; d833

wd834:: db ; d834

wd835:: db ; d835

wd836:: db ; d836

wd837:: db ; d837

wd838:: db ; d838

wd839:: db ; d839

wd83a:: db ; d83a

; if non-zero, damage taken to the car
; is multiplied by this amount
wDamageMultiplier:: db ; d83b

wd83c:: db ; d83c

wd83d:: db ; d83d

	ds $d83f - $d83e

wd83f:: db ; d83f

wd840:: db ; d840

wd841:: db ; d841

	ds $d849 - $d842

wd849:: db ; d849

	ds $d84c - $d84a

wd84c:: db ; d84c

	ds $d852 - $d84d

wd852:: db ; d852

	ds $d855 - $d853

wd855:: db ; d855

	ds $d85b - $d856

wd85b:: db ; d85b

	ds $d863 - $d85c

wd863:: db ; d863

	ds $d868 - $d864

wDamage:: db ; d868
wd869::   db ; d869

wFelony:: db ; d86a
wd86b::   db ; d86b

wd86c:: db ; d86c

wd86d:: db ; d86d

wTimerActive:: db ; d86e
wTimerMode::   db ; d86f

wd870:: db ; d870

; mission timer
; all values are in decimal form
; byte 0: 100th of second
; byte 1: seconds
; byte 2: minutes
wTimer:: ; d871
	ds $3

wd874:: db ; d874

	ds $d876 - $d875

wd876:: db ; d876

wd877:: db ; d877

wd878:: db ; d878

	ds $d884 - $d879

wd884:: db ; d884

	ds $d88a - $d885

wd88a:: db ; d88a

	ds $d88c - $d88b

wd88c:: db ; d88c

	ds $d88e - $d88d

wd88e:: db ; d88e

wd88f:: db ; d88f

	ds $d891 - $d890

wd891:: db ; d891

wd892:: db ; d892

wd893:: db ; d893

wd894:: db ; d894

wd895:: db ; d895

wd896:: db ; d896

wd897:: db ; d897

wd898:: db ; d898

; holds set of characters of a given text
wCharacterSet:: ; d899
	ds CHARACTER_SET_SIZE_TWO_LINES

; after assigning a character to an index in wCharacterSet,
; this buffer holds the text to print witch each character
; replaced by its corresponding index in the set
wEncodedText:: ; d8b9
	ds $13

wd8cc:: db ; d8cc

	ds $d8e2 - $d8cd

wHUDMessageLength::
wd8e2:: ; d8e2
	db

; number of characters in wCharacterSet
wCharacterSetSize:: db ; d8e3
wIsTwoLineMessage:: db ; d8e4

wHUDMessageStep::     db ; d8e5
wHUDMessageTimer::    db ; d8e6
wHUDMessageDuration:: db ; d8e7

wd8e8:: db ; d8e8

wd8e9:: db ; d8e9

wd8ea:: db ; d8ea

wCars:: ; d8eb
FOR n, 0, MAX_NUM_CARS
wCar{u:n}:: car_struct wCar{u:n}
ENDR

wda23:: car_struct wda23 ; da23

wPlayerCarPtr:: dw ; da4a

	ds $da4d - $da4c

wda4d:: db ; da4d

wda4e:: db ; da4e

wda4f:: db ; da4f

wda50:: db ; da50

wda51:: db ; da51

wda52:: db ; da52

wda53:: db ; da53

wda54:: db ; da54

wda55:: db ; da55

wda56:: db ; da56

wda57:: db ; da57

wda58:: db ; da58

wda59:: db ; da59

wda5a:: db ; da5a

wda5b:: db ; da5b

wda5c:: db ; da5c

wda5d:: db ; da5d

wda5e:: db ; da5e

wda5f:: db ; da5f

wda60:: db ; da60

wda61:: db ; da61

wda62:: db ; da62

wda63:: db ; da63

wda64:: db ; da64

wda65:: db ; da65

wda66:: db ; da66

	ds $da68 - $da67

wda68:: db ; da68

	ds $da6c - $da69

wda6c:: db ; da6c

wda6d:: db ; da6d

wda6e:: db ; da6e

	ds $da74 - $da6f

wda74:: db ; da74

	ds $da76 - $da75

wda76:: db ; da76
wDestinationCoords::
wDestinationX:: dw ; da77
wDestinationY:: dw ; da79

wda7b:: db ; da7b

wda7c:: db ; da7c

wda7d:: db ; da7d

wda7e:: db ; da7e

wda7f:: db ; da7f

wda80:: db ; da80

wda81:: db ; da81

wda82:: db ; da82

wInitialNPCCars::   ds NUM_INITIAL_CARS ; da83
wSpawnableNPCCars:: ds NUM_SPAWNABLE_CARS ; da87

wda8f:: db ; da8f

wda90:: db ; da90

wda91:: db ; da91

wda92:: db ; da92

wda93:: db ; da93

wda94:: db ; da94

wda95:: db ; da95

wda96:: db ; da96

wda97:: db ; da97

wda98:: db ; da98

wda99:: db ; da99

wda9a:: db ; da9a

wda9b:: db ; da9b

wda9c:: db ; da9c

wda9d:: db ; da9d

	ds $db81 - $da9e

wdb81:: db ; db81

	ds $db83 - $db82

wdb83:: db ; db83

	ds $db85 - $db84

wdb85:: ; db85
	ds $40

; stores where in VRAM each CAR_* type has its gfx (starting tile ID)
; and also its attribute (OAM_BANK0 or OAM_BANK1)
wCarTileIDAndAttributeMap:: ; dbc5
	ds NUM_CAR_TYPES * $2

wPropTileIDMap:: ; dbdb
	ds (NUM_CITY_PROPS + 6) * $2

wdbf7:: dw ; dbf7

wdbf9:: db ; dbf9

wdbfa:: db ; dbfa

wMenuUpdateFunc:: dw ; dbfb

wTitleScreenFinished:: db ; dbfd

wdbfe:: db ; dbfe

wTextLineLengths:: ; dbff
	ds MAX_NUM_LINES

wdc1f:: db ; dc1f

wdc20:: db ; dc20

wdc21:: db ; dc21

	ds $dc23 - $dc22

wdc23:: db ; dc23

	ds $dc25 - $dc24

wTextLine:: db ; dc25

wMainMenuEntry:: db ; dc26

wdc27:: dw ; dc27

wdc29:: db ; dc29

; corresponds to the current entry in CheatInputCommands
; keeps track of where in the command list the player is
wMainMenuCheatInputProgress:: db ; dc2a

wdc2b:: db ; dc2b

wdc2c:: db ; dc2c

wdc2d:: dw ; dc2d

wdc2f:: db ; dc2f

wLanguage:: db ; dc30

wdc31:: db ; dc31

wActiveCheats:: db ; dc32

wUnlockedCities:: db ; dc33

wMissionCode:: ; dc34
	ds $4

wMission:: db ; dc38

wdc39:: db ; dc39

	ds $dc3c - $dc3a

wdc3c:: db ; dc3c

	ds $dc3f - $dc3d

wdc3f:: db ; dc3f

	ds $dc42 - $dc40

wdc42:: db ; dc42

	ds $dc45 - $dc43

wdc45:: db ; dc45

	ds $dc48 - $dc46

wdc48:: db ; dc48

	ds $dc4b - $dc49

wdc4b:: db ; dc4b

	ds $dc4e - $dc4c

wdc4e:: db ; dc4e

	ds $dc51 - $dc4f

wdc51:: db ; dc51

	ds $dc54 - $dc52

wdc54:: db ; dc54

	ds $dc57 - $dc55

wdc57:: db ; dc57

	ds $dc5a - $dc58

wdc5a:: db ; dc5a

	ds $dc5d - $dc5b

wdc5d:: db ; dc5d

	ds $dc60 - $dc5e

wdc60:: db ; dc60

	ds $dc63 - $dc61

wdc63:: db ; dc63

	ds $dc66 - $dc64

wdc66:: db ; dc66

	ds $dc69 - $dc67

wdc69:: db ; dc69

	ds $dc6c - $dc6a

wdc6c:: db ; dc6c

	ds $dc6f - $dc6d

wdc6f:: db ; dc6f

	ds $dc72 - $dc70

wdc72:: db ; dc72

	ds $dc75 - $dc73

wdc75:: db ; dc75

	ds $dc7a - $dc76

UNION
wdc7a:: dw ; dc7a
wdc7c:: dw ; dc7c
NEXTU
wMaxNumOfSetCharacters:: db ; dc7a
ENDU

wdc7e:: db ; dc7e

wdc7f:: db ; dc7f

wdc80:: db ; dc80

wdc81:: db ; dc81

wdc82:: db ; dc82

	ds $dc84 - $dc83

wdc84:: db ; dc84

	ds $dc86 - $dc85

wdc86:: db ; dc86

	ds $dc88 - $dc87

wdc88:: db ; dc88

	ds $dc8c - $dc89

wdc8c:: db ; dc8c

wdc8d:: db ; dc8d

; city to show on next credits scene
wCreditsCity:: db ; dc8e
; which credits text to show (Credits1Text or Credits2Text)
wWhichCreditsText:: db ; dc8f

wdc90:: db ; dc90

wdc91:: db ; dc91

wdc92:: db ; dc92

wdc93:: dw ; dc93

wdc95:: db ; dc95

	ds $dcb5 - $dc96

wdcb5:: db ; dcb5

wTextBuffer:: db ; dcb6

	ds $e000 - $dcb7
