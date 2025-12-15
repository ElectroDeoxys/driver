SECTION "HRAM", HRAM

	ds $ff93 - $ff8a

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

hVRAMBank:: db ; ff9e

hWRAMBank:: db ; ff9f

SECTION "Stack", HRAM

hStack:: ; ffe0
	ds $1e
hStackBottom:: ; fffe
