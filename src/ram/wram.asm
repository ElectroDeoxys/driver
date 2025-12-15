SECTION "WRAM0", WRAM0

wVirtualOAM:: ; c000
	ds OAM_SIZE

	ds $c540 - $c0a0

wc540:: db ; c540
wc541:: db ; c541

wc542:: db ; c542

	ds $c546 - $c543

wc546:: db ; c546

wc547:: db ; c547
wc548:: dw ; c548
wc54a:: db ; c54a

	ds $c56a - $c54b

; if TRUE then resetting game through A+B+START+SELECT is disabled
wResetDisabled:: db ; c56a

wResetDelay:: db ; c56b

wFrameCounter:: db ; c56c
wc56d:: db ; c56d

wc56e:: db ; c56e
wc56f:: db ; c56f
wc570:: db ; c570

wJoypadPressed:: db ; c571
wJoypadDown::    db ; c572

	ds $c575 - $c573

wc575:: db ; c575

	ds $c57d - $c576

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

wc5fd:: db ; c5fd

	ds $c67d - $c5fe

wc67d:: db ; c67d

wc67e:: db ; c67e
wc67f:: db ; c67f

wc680:: db ; c680

wc681::            dw ; c681
wc683::            dw ; c683
wLCDCSettingsPtr:: dw ; c685

wLCDCSettings:: ; c687
	ds $4

	ds $c6cf - $c68b

wc6cf:: db ; c6cf

SECTION "WRAM1", WRAMX

