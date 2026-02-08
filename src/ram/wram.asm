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
wOBPals:: ds 8 palettes ; c58d
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

wc681::            dw ; c681
wc683::            dw ; c683
wLCDCSettingsPtr:: dw ; c685

wLCDCSettings:: ; c687
	ds $4

	ds $c6cf - $c68b

wc6cf:: db ; c6cf

	ds $c717 - $c6d0

wEntities:: ; c717
FOR n, 0, NUM_ENTITIES
wEntity{u:n}:: entity_struct wEntity{u:n}
ENDR

; holds main sp while executing entity update functions
wTempSP:: dw ; d217

wEntityPtr:: dw ; d219

; sprite structs with OAM data
; see (src/constants/sprite_constants.asm)
wSprites:: ; d21b
FOR n, 0, NUM_SPRITES
wSprite{u:n}:: sprite_struct wSprite{u:n}
ENDR

wd545:: db ; d545

wd546:: db ; d546

wd547:: db ; d547

wd548:: db ; d548

	ds $d54b - $d549

wd54b:: db ; d54b

wd54c:: db ; d54c

wd54d:: db ; d54d

wd54e:: db ; d54e
wd54f:: dw ; d54f

wd551:: db ; d551

	ds $d771 - $d552

; multipurpose buffer for temporarily
; holding tile/bg map data
wGfxBuffer:: db ; d771

	ds $d782 - $d772

wd782:: db ; d782

	ds $d785 - $d783

wd785:: db ; d785

wd786:: db ; d786

	ds $d7b1 - $d787

wd7b1:: db ; d7b1

	ds $d7c4 - $d7b2

wd7c4:: db ; d7c4

	ds $d7f1 - $d7c5

wVRAMNumTiles::
wVRAMNumTiles_v0_8000:: db ; d7f1
wVRAMNumTiles_v0_9000:: db ; d7f2
wVRAMNumTiles_v0_8800:: db ; d7f3
wVRAMNumTiles_v1_8000:: db ; d7f4
wVRAMNumTiles_v1_9000:: db ; d7f5
wVRAMNumTiles_v1_8800:: db ; d7f6

wd7f7:: db ; d7f7

wNumTilesToPush:: db ; d7f8

wd7f9:: db ; d7f9

wd7fa:: db ; d7fa

wd7fb:: db ; d7fb

wd7fc:: db ; d7fc

wd7fd:: db ; d7fd

wd7fe:: db ; d7fe

wd7ff:: db ; d7ff

wd800:: db ; d800

wd801:: db ; d801

wd802:: db ; d802

wd803:: db ; d803

wd804:: db ; d804

wd805:: db ; d805

wd806:: db ; d806

wd807:: db ; d807

wd808:: db ; d808

	ds $d80b - $d809

wd80b:: db ; d80b

wd80c:: db ; d80c

wd80d:: db ; d80d

wd80e:: db ; d80e

wd80f:: db ; d80f

	ds $d81e - $d810

wd81e:: db ; d81e

wd81f:: db ; d81f

wd820:: db ; d820

wTitlescreenTransition:: db ; d821

wd822:: db ; d822

wCity:: db ; d823

wd824:: db ; d824

	ds $d826 - $d825

wd826:: db ; d826

wd827:: db ; d827

wd828:: db ; d828

wd829:: db ; d829

wd82a:: db ; d82a

wd82b:: db ; d82b

wd82c:: db ; d82c

	ds $d82e - $d82d

wd82e:: db ; d82e

	ds $d830 - $d82f

wd830:: db ; d830

wd831:: db ; d831

	ds $d833 - $d832

wd833:: db ; d833

wd834:: db ; d834

wd835:: db ; d835

wd836:: db ; d836

wd837:: db ; d837

wd838:: db ; d838

wd839:: db ; d839

wd83a:: db ; d83a

wd83b:: db ; d83b

	ds $d83f - $d83c

wd83f:: db ; d83f

	ds $d868 - $d840

wd868:: db ; d868

	ds $d86a - $d869

wd86a:: db ; d86a

	ds $d86c - $d86b

wd86c:: db ; d86c

	ds $d877 - $d86d

wd877:: db ; d877

	ds $d895 - $d878

wd895:: db ; d895

wd896:: db ; d896

wd897:: db ; d897

	ds $d8e2 - $d898

wd8e2:: db ; d8e2

	ds $d8e5 - $d8e3

wd8e5:: db ; d8e5

	ds $d8e8 - $d8e6

wd8e8:: db ; d8e8

wd8e9:: db ; d8e9

wd8ea:: db ; d8ea

wd8eb:: db ; d8eb

	ds $da23 - $d8ec

wda23:: db ; da23

	ds $da29 - $da24

wda29:: db ; da29

wda2a:: db ; da2a

	ds $da2d - $da2b

wda2d:: db ; da2d

	ds $da2f - $da2e

wda2f:: db ; da2f

	ds $da31 - $da30

wda31:: db ; da31

	ds $da4a - $da32

wda4a:: db ; da4a

wda4b:: db ; da4b

	ds $da4d - $da4c

wda4d:: db ; da4d

	ds $da51 - $da4e

wda51:: db ; da51

	ds $da59 - $da52

wda59:: db ; da59

wda5a:: db ; da5a

	ds $da5d - $da5b

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

	ds $da6e - $da69

wda6e:: db ; da6e

	ds $da76 - $da6f

wda76:: db ; da76

	ds $da7b - $da77

wda7b:: db ; da7b

	ds $da82 - $da7c

wda82:: db ; da82

wda83:: db ; da83

	ds $da8f - $da84

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

	ds $da9b - $da9a

wda9b:: db ; da9b

wda9c:: db ; da9c

wda9d:: db ; da9d

	ds $db81 - $da9e

wdb81:: db ; db81

	ds $db83 - $db82

wdb83:: db ; db83

	ds $db85 - $db84

wdb85:: db ; db85

	ds $dbc5 - $db86

wdbc5:: db ; dbc5

	ds $dbdb - $dbc6

wdbdb:: db ; dbdb

wdbdc:: db ; dbdc

	ds $dbfa - $dbdd

wdbfa:: db ; dbfa

wMenuUpdateFunc:: dw ; dbfb

wTitleScreenFinished:: db ; dbfd

wdbfe:: db ; dbfe

wdbff:: db ; dbff

	ds $dc1f - $dc00

wdc1f:: db ; dc1f

wdc20:: db ; dc20

wdc21:: db ; dc21

	ds $dc23 - $dc22

wdc23:: db ; dc23

	ds $dc25 - $dc24

wdc25:: db ; dc25

wdc26:: db ; dc26

wdc27:: dw ; dc27

wdc29:: db ; dc29

wdc2a:: db ; dc2a

wdc2b:: db ; dc2b

	ds $dc2f - $dc2c

wdc2f:: db ; dc2f

wdc30:: db ; dc30

wdc31:: db ; dc31

wdc32:: db ; dc32

wdc33:: db ; dc33

wdc34:: db ; dc34

	ds $dc38 - $dc35

wdc38:: db ; dc38

wdc39:: db ; dc39

	ds $dc7a - $dc3a

wdc7a:: dw ; dc7a

wdc7c:: db ; dc7c

wdc7d:: db ; dc7d

wdc7e:: db ; dc7e

	ds $dc80 - $dc7f

wdc80:: db ; dc80

	ds $dc82 - $dc81

wdc82:: db ; dc82

	ds $dc8e - $dc83

wdc8e:: db ; dc8e

wdc8f:: db ; dc8f

wdc90:: db ; dc90

	ds $dc95 - $dc91

wdc95:: db ; dc95

	ds $dcb6 - $dc96

wdcb6:: db ; dcb6

	ds $e000 - $dcb7
