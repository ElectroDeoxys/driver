SECTION "HRAM", HRAM

hff8a:: db ; ff8a

hff8b:: db ; ff8b

hff8c:: db ; ff8c

hff8d:: db ; ff8d

hff8e:: db ; ff8e

hff8f:: db ; ff8f

	ds $ff91 - $ff90

hff91:: db ; ff91

hff92:: db ; ff92

hff93:: db ; ff93

hBootUpA:: db ; ff94

hSCX::  db ; ff95
hSCY::  db ; ff96
hLCDC:: db ; ff97
hLYC::  db ; ff98

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
