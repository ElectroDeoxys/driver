SECTION "Bank31", ROMX, BANK[$31]

SECTION "Gfx_c7ff0", ROMX[$7ff0], BANK[$31]
Gfx_cdff0:: INCBIN "gfx/gfx_c7ff0.2bpp"


SECTION "Bank32", ROMX, BANK[$32]

SECTION "Pals_cbec0", ROMX[$7ec0], BANK[$32]
Pals_cbec0::
	rgb 28, 28, 28
	rgb 19, 19, 19
	rgb 12, 12, 12
	rgb  0,  0,  0

	rgb 28, 28, 28
	rgb 12, 12, 12
	rgb  9,  9,  9
	rgb  0,  0,  0

	rgb  0, 31,  0
	rgb  0, 31,  0
	rgb  0, 31,  0
	rgb  0, 31,  0

	rgb 31, 25,  0
	rgb 19, 19, 19
	rgb 12, 12, 12
	rgb  0,  0,  0

	rgb 28, 28, 28
	rgb 19, 19, 19
	rgb 12, 12, 12
	rgb  9,  9,  9

	rgb  0,  0,  0
	rgb 31, 25,  0
	rgb 24, 19,  0
	rgb 16, 12,  0

	rgb 31, 25,  0
	rgb 28, 28, 28
	rgb 19, 19, 19
	rgb  0,  0,  0

	rgb 19, 19, 19
	rgb 12, 12, 12
	rgb  9,  9,  9
	rgb  0,  0,  0
; 0xcbf00

SECTION "Pals_cbf70", ROMX[$7f70], BANK[$32]
Pals_cbf70::
	rgb 31, 25,  0
	rgb 23, 23, 23
	rgb  6,  6,  6
	rgb  0,  0,  0

	rgb 23, 23, 23
	rgb 15, 15, 15
	rgb  6,  6,  6
	rgb  0,  0,  0

	rgb  0, 31,  0
	rgb  0, 31,  0
	rgb  0, 31,  0
	rgb  0, 31,  0

	rgb 31, 25,  0
	rgb  6,  6,  6
	rgb 15, 15, 15
	rgb  0,  0,  0

	rgb  6,  6,  6
	rgb 31, 25,  0
	rgb 20, 17,  4
	rgb 14, 13,  6

	rgb  0,  0,  0
	rgb 31, 25,  0
	rgb 15, 12,  0
	rgb  7,  6,  0

	rgb  0, 31,  0
	rgb  0, 31,  0
	rgb  0, 31,  0
	rgb  0, 31,  0

	rgb 23, 23, 23
	rgb 15, 15, 15
	rgb  6,  6,  6
	rgb  0,  0,  0

Gfx_cbfb0:: INCBIN "gfx/gfx_cbfb0.2bpp"
Gfx_cbfc0:: INCBIN "gfx/gfx_cbfc0.2bpp"
; 0xcbfd0


SECTION "Bank33", ROMX, BANK[$33]

SECTION "Gfx_cd000", ROMX[$5000], BANK[$33]
Gfx_cd000:: INCBIN "gfx/gfx_cd000.2bpp"
Gfx_cd800:: INCBIN "gfx/gfx_cd800.2bpp"
Tilemap_cdc80:: INCBIN "gfx/bg_cdc80.tilemap"
Attrmap_cdde8:: INCBIN "gfx/bg_cdde8.attrmap"

SECTION "Gfx_cdf50", ROMX[$5f50], BANK[$33]
Gfx_cdf50:: INCBIN "gfx/gfx_cdf50.2bpp"

SECTION "Gfx_ce090", ROMX[$6090], BANK[$33]
Gfx_ce090:: INCBIN "gfx/gfx_ce090.2bpp"
Tilemap_ce440:: INCBIN "gfx/bg_ce440.tilemap"
Attrmap_ce5a8:: INCBIN "gfx/bg_ce5a8.attrmap"

SECTION "Gfx_ce710", ROMX[$6710], BANK[$33]
Gfx_ce710:: INCBIN "gfx/gfx_ce710.2bpp"

SECTION "FontBigGfx", ROMX[$6830], BANK[$33]
FontBigGfx:: INCBIN "gfx/font_big.2bpp"

SECTION "FontGfx", ROMX[$7420], BANK[$33]
FontGfx:: INCBIN "gfx/font.2bpp"

SECTION "FontCheckmarkGfx", ROMX[$7960], BANK[$33]
FontCheckboxGfx:: INCBIN "gfx/font_checkbox.2bpp"


SECTION "Bank34", ROMX, BANK[$34]

SECTION "Gfx_d0f5d", ROMX[$4f5d], BANK[$34]
Gfx_d0f5d:: INCBIN "gfx/gfx_d0f5d.2bpp"
Gfx_d0f9d:: INCBIN "gfx/gfx_d0f9d.2bpp"

SECTION "Gfx_d115d", ROMX[$515d], BANK[$34]
Gfx_d115d:: INCBIN "gfx/gfx_d115d.2bpp"


SECTION "Bank35", ROMX, BANK[$35]

SECTION "EnglishHUD", ROMX[$6b1d], BANK[$35]

EnglishHUDGfx::
	INCBIN "gfx/hud/numbers.2bpp"
	INCBIN "gfx/hud/en/hud.2bpp"
	INCBIN "gfx/hud/en/pause.2bpp"

FrenchHUDGfx::
	INCBIN "gfx/hud/numbers.2bpp"
	INCBIN "gfx/hud/fr/hud.2bpp"
	INCBIN "gfx/hud/fr/pause.2bpp"

GermanHUDGfx::
	INCBIN "gfx/hud/numbers.2bpp"
	INCBIN "gfx/hud/de/hud.2bpp"
	INCBIN "gfx/hud/de/pause.2bpp"


SECTION "Bank36", ROMX, BANK[$36]

ItalianHUDGfx::
	INCBIN "gfx/hud/numbers.2bpp"
	INCBIN "gfx/hud/it/hud.2bpp"
	INCBIN "gfx/hud/it/pause.2bpp"

SpanishHUDGfx::
	INCBIN "gfx/hud/numbers.2bpp"
	INCBIN "gfx/hud/es/hud.2bpp"
	INCBIN "gfx/hud/es/pause.2bpp"

SECTION "Gfx_da0e0", ROMX[$60e0], BANK[$36]
Gfx_da0e0:: INCBIN "gfx/gfx_da0e0.2bpp"

Pals_da3a0::
	rgb  0,  0,  0
	rgb  6,  6,  6
	rgb 15, 15, 15
	rgb 25, 25, 25

	rgb  0,  0,  0
	rgb  0, 29,  0
	rgb 31, 20,  0
	rgb 26,  5,  0

	rgb  0,  0,  0
	rgb 15, 15, 15
	rgb 26,  5,  0
	rgb 25, 25, 25

	rgb  0,  0,  0
	rgb  7,  6,  0
	rgb 15, 12,  0
	rgb 31, 25,  0

	rgb  0,  0,  0
	rgb 15, 15, 15
	rgb  0, 11, 31
	rgb 25, 25, 25
; 0xda3c8
