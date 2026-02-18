SECTION "HRAM", HRAM

hTrackPtr:: dw ; ff8a

hff8c:: db ; ff8c

hff8d:: db ; ff8d

hff8e:: db ; ff8e

hTrackFlags:: db ; ff8f

hff90:: db ; ff90

; which track is currently being updated [0, NUM_AUDIO_TRACKS - 1]
hTrackIndex:: db ; ff91

hChannelMixing:: db ; ff92

; is set to TRUE at the start
; when game is soft-reset, this variable is checked
; so that game skips to titlescreen
hInitialised:: db ; ff93

hBootUpA:: db ; ff94

; these are applied in Stat and V-Blank interrupts
hLCDSettings:: lcd_struct hLCDSettings ; ff95

hff99:: db ; ff99
hff9a:: db ; ff9a
hff9b:: db ; ff9b

hROMBank::     db ; ff9c
hTempROMBank:: db ; ff9d
hVRAMBank::    db ; ff9e
hWRAMBank::    db ; ff9f

	ds $ffe0 - $ffa0

SECTION "Stack", HRAM

hStack:: ; ffe0
	ds $1e
hStackBottom:: ; fffe
