SECTION "Data_c4e4", ROMX[$44e4], BANK[$3]

Data_c4e4:
	db $20 ; num of tiles

SECTION "Data_c9c9", ROMX[$49c9], BANK[$3]

Data_c9c9:
	db $20 ; num of tiles

SECTION "Data_ceae", ROMX[$4eae], BANK[$3]

Data_ceae:
	db $20 ; num of tiles

SECTION "Data_d393", ROMX[$5393], BANK[$3]

Data_d393:
	db $20 ; num of tiles

SECTION "Data_d878", ROMX[$5878], BANK[$3]

Data_d878:
	db $20 ; num of tiles

SECTION "Data_dd5d", ROMX[$5d5d], BANK[$3]

Data_dd5d:
	db $20 ; num of tiles

SECTION "Data_e242", ROMX[$6242], BANK[$3]

Data_e242:
	db $20 ; num of tiles

SECTION "Data_e727", ROMX[$6727], BANK[$3]

Data_e727:
	db $20 ; num of tiles

SECTION "Data_ec0c", ROMX[$6c0c], BANK[$3]

Data_ec0c:
	db $20 ; num of tiles

SECTION "Data_f0f1", ROMX[$70f1], BANK[$3]

Data_f0f1:
	db $20 ; num of tiles

SECTION "Data_f5d6", ROMX[$75d6], BANK[$3]

Data_f5d6:
	db $20 ; num of tiles

SECTION "CarGfxTable", ROMX[$75ed], BANK[$3]

MACRO? car_gfx
	dba \1 ; graphics
	dw \2 ; pointer
ENDM

CarGfxTable::
	car_gfx Car01Gfx, Data_c4e4 ; BLACK_CAR
	car_gfx Car02Gfx, Data_c9c9 ; COP_CAR
	car_gfx Car03Gfx, Data_ceae ; TAXI
	car_gfx Car04Gfx, Data_d393 ; CAR_03
	car_gfx Car05Gfx, Data_d878 ; CAR_04
	car_gfx Car06Gfx, Data_dd5d ; CAR_05
	car_gfx Car07Gfx, Data_e242 ; BROWN_CAR
	car_gfx Car08Gfx, Data_e727 ; RED_CAR
	car_gfx Car09Gfx, Data_ec0c ; LIMOUSINE
	car_gfx Car10Gfx, Data_f0f1 ; CAR_09
	car_gfx Car11Gfx, Data_f5d6 ; CAR_10
; 0xf624

SECTION "Pals_f644", ROMX[$7644], BANK[$3]

Pals_f644::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 10, 10, 10
	rgb 27, 27, 27

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 31, 31, 31

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  8, 16, 31
	rgb 28, 28, 28

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 13, 11,  2
	rgb 25, 21,  7

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 31, 31,  0
	rgb 31, 31, 31

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0,  0, 31
	rgb 31, 31, 31

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0, 18,  5
	rgb 27, 27, 27

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 23, 17,  0
	rgb 27, 27, 27
; 0xf684
