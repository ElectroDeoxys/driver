SECTION "Bank32", ROMX, BANK[$32]

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

SECTION "Gfx_cdf50", ROMX[$5f50], BANK[$33]
Gfx_cdf50:: INCBIN "gfx/gfx_cdf50.2bpp"

SECTION "Gfx_ce090", ROMX[$6090], BANK[$33]
Gfx_ce090:: INCBIN "gfx/gfx_ce090.2bpp"
Tilemap_ce440:: INCBIN "gfx/bg_ce440.tilemap"
Attrmap_ce5a8:: INCBIN "gfx/bg_ce5a8.attrmap"

SECTION "Gfx_ce710", ROMX[$6710], BANK[$33]
Gfx_ce710:: INCBIN "gfx/gfx_ce710.2bpp"

SECTION "Bank36", ROMX, BANK[$36]

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
