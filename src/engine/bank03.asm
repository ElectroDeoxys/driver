; byte 1: index
; byte 2: sprite width
; byte 3: x component
; byte 4: y component

Data_c000:
	; index, width
	db $00,  8

	db    3,    8
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0

Data_c084:
	; index, width
	db $02,  8

	db    4,    8
	db    0,    0
	db  -32,    1
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db -128,    7
	db    0,    0
	db -128,    7
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -32,    1
	db -128,    7
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -32,    1
	db    0,    0
	db  -32,    1
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db -128,    7
	db    0,    0

Data_c108:
	; index, width
	db $04, 16

	db    5,    8
	db    0,    0
	db   96,    0
	db  -16,    1
	db   -8,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   15
	db    0,    6
	db    0,    0
	db    0,    6
	db -128,   15
	db -128,   31
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db  -16,    1
	db   96,    0
	db    0,    6
	db -128,   15
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db   -8,    1
	db  -16,    1
	db   96,    0
	db    0,    0
	db   96,    0
	db  -16,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   31
	db -128,   15
	db    0,    6
	db    0,    0

Data_c18c:
	; index, width
	db $08, 16

	db    6,    8
	db    0,    0
	db   32,    0
	db   -8,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   31
	db    0,   15
	db    0,    4
	db    0,    0
	db    0,    4
	db    0,   31
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -8,    0
	db  -16,    0
	db   32,    0
	db    0,    4
	db    0,   15
	db    0,   31
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db   -8,    0
	db   32,    0
	db    0,    0
	db   32,    0
	db  -16,    0
	db   -8,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   31
	db    0,    4
	db    0,    0

Data_c210:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_c294:
	; index, width
	db $10, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    1
	db   -2,    3
	db   -4,   15
	db   -4,   31
	db  -16,  127
	db  -32,  127
	db -128,   -1
	db    0,  126
	db    0,   60
	db    0,   24
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db -128,   63
	db  -64,  127
	db  -16,   63
	db   -8,   63
	db   -2,   15
	db   -2,    7
	db   -1,    1
	db  126,    0
	db   60,    0
	db   24,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   24
	db    0,   60
	db    0,  126
	db -128,   -1
	db  -32,  127
	db  -16,  127
	db   -4,   31
	db   -4,   15
	db   -2,    3
	db   -4,    1
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   24,    0
	db   60,    0
	db  126,    0
	db   -1,    1
	db   -2,    7
	db   -2,   15
	db   -8,   63
	db  -16,   63
	db  -64,  127
	db -128,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_c318:
	; index, width
	db $14, 16

	db    8,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db   -4,    0
	db   -2,    3
	db   -2,   31
	db   -4,  127
	db   -4,   -1
	db  -16,   -1
	db -128,   -1
	db    0,  126
	db    0,   48
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   63
	db  -64,  127
	db   -8,  127
	db   -2,   63
	db   -1,   63
	db   -1,   15
	db   -1,    1
	db  126,    0
	db   12,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   48
	db    0,  126
	db -128,   -1
	db  -16,   -1
	db   -4,   -1
	db   -4,  127
	db   -2,   31
	db   -2,    3
	db   -4,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   12,    0
	db  126,    0
	db   -1,    1
	db   -1,   15
	db   -1,   63
	db   -2,   63
	db   -8,  127
	db  -64,  127
	db    0,   63
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,    0

Data_c39c:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db   -2,    7
	db   -2,  127
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db  -64,   -1
	db    0,   56
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db  -32,  127
	db   -2,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db   -1,    3
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db  -64,   -1
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,  127
	db   -2,    7
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   28,    0
	db   -1,    3
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -2,  127
	db  -32,  127
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_c420:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,  127
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -2,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,  127
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -2,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_c4a4:
	dw Data_c000
	dw Data_c084
	dw Data_c108
	dw Data_c18c
	dw Data_c210
	dw Data_c294
	dw Data_c318
	dw Data_c39c
	dw Data_c420
	dw Data_c39c
	dw Data_c318
	dw Data_c294
	dw Data_c210
	dw Data_c18c
	dw Data_c108
	dw Data_c084
	dw Data_c000
	dw Data_c084
	dw Data_c108
	dw Data_c18c
	dw Data_c210
	dw Data_c294
	dw Data_c318
	dw Data_c39c
	dw Data_c420
	dw Data_c39c
	dw Data_c318
	dw Data_c294
	dw Data_c210
	dw Data_c18c
	dw Data_c108
	dw Data_c084

Data_c4e4:
	db $20 ; num of tiles

Data_c4e5:
	; index, width
	db $00,  8

	db    3,    8
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0

Data_c569:
	; index, width
	db $02,  8

	db    4,    8
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0

Data_c5ed:
	; index, width
	db $04, 16

	db    5,    8
	db    0,    0
	db  -32,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,    7
	db    0,    0
	db    0,    7
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db  -32,    0
	db    0,    0
	db  -32,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,    7
	db    0,    0

Data_c671:
	; index, width
	db $08, 16

	db    6,    8
	db    0,    0
	db   96,    0
	db   -8,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   15
	db    0,    6
	db    0,    0
	db    0,    6
	db    0,   31
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db  -16,    0
	db   96,    0
	db    0,    6
	db    0,   15
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db   -8,    0
	db   96,    0
	db    0,    0
	db   96,    0
	db  -16,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   31
	db    0,    6
	db    0,    0

Data_c6f5:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db   16,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0
	db    0,    8
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db   16,    0
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    8
	db    0,    0

Data_c779:
	; index, width
	db $10, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    1
	db   -2,    3
	db   -2,   15
	db   -4,   31
	db  -16,  127
	db  -32,   -1
	db -128,   -1
	db    0,  126
	db    0,   60
	db    0,   56
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db -128,   63
	db  -64,  127
	db  -16,  127
	db   -8,   63
	db   -2,   15
	db   -1,    7
	db   -1,    1
	db  126,    0
	db   60,    0
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db    0,   60
	db    0,  126
	db -128,   -1
	db  -32,   -1
	db  -16,  127
	db   -4,   31
	db   -2,   15
	db   -2,    3
	db   -4,    1
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   28,    0
	db   60,    0
	db  126,    0
	db   -1,    1
	db   -1,    7
	db   -2,   15
	db   -8,   63
	db  -16,  127
	db  -64,  127
	db -128,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_c7fd:
	; index, width
	db $14, 16

	db    8,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -4,    0
	db   -2,    3
	db   -2,   31
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db -128,   -1
	db    0,  126
	db    0,  112
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db    0,   63
	db  -64,  127
	db   -8,  127
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    1
	db  126,    0
	db   14,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  112
	db    0,  126
	db -128,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -2,   31
	db   -2,    3
	db   -4,    0
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   14,    0
	db  126,    0
	db   -1,    1
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db   -8,  127
	db  -64,  127
	db    0,   63
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0

Data_c881:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -2,    7
	db   -2,  127
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db  -64,   -1
	db    0,  120
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db  -32,  127
	db   -2,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db   -1,    3
	db   30,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  120
	db  -64,   -1
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,  127
	db   -2,    7
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   30,    0
	db   -1,    3
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -2,  127
	db  -32,  127
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_c905:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_c989:
	dw Data_c4e5
	dw Data_c569
	dw Data_c5ed
	dw Data_c671
	dw Data_c6f5
	dw Data_c779
	dw Data_c7fd
	dw Data_c881
	dw Data_c905
	dw Data_c881
	dw Data_c7fd
	dw Data_c779
	dw Data_c6f5
	dw Data_c671
	dw Data_c5ed
	dw Data_c569
	dw Data_c4e5
	dw Data_c569
	dw Data_c5ed
	dw Data_c671
	dw Data_c6f5
	dw Data_c779
	dw Data_c7fd
	dw Data_c881
	dw Data_c905
	dw Data_c881
	dw Data_c7fd
	dw Data_c779
	dw Data_c6f5
	dw Data_c671
	dw Data_c5ed
	dw Data_c569

Data_c9c9:
	db $20 ; num of tiles

Data_c9ca:
	; index, width
	db $00,  8

	db    3,    8
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0

Data_ca4e:
	; index, width
	db $02,  8

	db    4,    8
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db    0,    0
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db    0,    0
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0

Data_cad2:
	; index, width
	db $04, 16

	db    5,    8
	db    0,    0
	db  -32,    0
	db  -16,    1
	db   -8,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,    7
	db    0,    0
	db    0,    7
	db -128,   15
	db -128,   31
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db   -8,    1
	db  -16,    1
	db  -32,    0
	db    0,    0
	db  -32,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   31
	db -128,   15
	db    0,    7
	db    0,    0

Data_cb56:
	; index, width
	db $08, 16

	db    6,    8
	db    0,    0
	db   32,    0
	db   -8,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   63
	db    0,   63
	db    0,   15
	db    0,    6
	db    0,    0
	db    0,    4
	db    0,   31
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -4,    1
	db   -4,    0
	db  -16,    0
	db   96,    0
	db    0,    6
	db    0,   15
	db    0,   63
	db -128,   63
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db   -8,    0
	db   32,    0
	db    0,    0
	db   96,    0
	db  -16,    0
	db   -4,    0
	db   -4,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   31
	db    0,    4
	db    0,    0

Data_cbda:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0

Data_cc5e:
	; index, width
	db $10, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    1
	db   -2,    3
	db   -4,   15
	db   -4,   31
	db  -16,  127
	db  -32,   -1
	db -128,   -1
	db    0,  126
	db    0,   56
	db    0,   48
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db -128,   63
	db  -64,  127
	db  -16,   63
	db   -8,   63
	db   -2,   15
	db   -1,    7
	db   -1,    1
	db  126,    0
	db   28,    0
	db   12,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   48
	db    0,   56
	db    0,  126
	db -128,   -1
	db  -32,   -1
	db  -16,  127
	db   -4,   31
	db   -4,   15
	db   -2,    3
	db   -4,    1
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   12,    0
	db   28,    0
	db  126,    0
	db   -1,    1
	db   -1,    7
	db   -2,   15
	db   -8,   63
	db  -16,   63
	db  -64,  127
	db -128,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_cce2:
	; index, width
	db $14, 16

	db    8,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db   -4,    0
	db   -2,    7
	db   -2,   31
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db -128,   -1
	db    0,  126
	db    0,  112
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   63
	db  -32,  127
	db   -8,  127
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    1
	db  126,    0
	db   14,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  112
	db    0,  126
	db -128,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -2,   31
	db   -2,    7
	db   -4,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   14,    0
	db  126,    0
	db   -1,    1
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db   -8,  127
	db  -32,  127
	db    0,   63
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,    0

Data_cd66:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -2,    7
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db  -64,   -1
	db    0,  120
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db  -32,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db   -1,    3
	db   30,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  120
	db  -64,   -1
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,    7
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   30,    0
	db   -1,    3
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db  -32,  127
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_cdea:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_ce6e:
	dw Data_c9ca
	dw Data_ca4e
	dw Data_cad2
	dw Data_cb56
	dw Data_cbda
	dw Data_cc5e
	dw Data_cce2
	dw Data_cd66
	dw Data_cdea
	dw Data_cd66
	dw Data_cce2
	dw Data_cc5e
	dw Data_cbda
	dw Data_cb56
	dw Data_cad2
	dw Data_ca4e
	dw Data_c9ca
	dw Data_ca4e
	dw Data_cad2
	dw Data_cb56
	dw Data_cbda
	dw Data_cc5e
	dw Data_cce2
	dw Data_cd66
	dw Data_cdea
	dw Data_cd66
	dw Data_cce2
	dw Data_cc5e
	dw Data_cbda
	dw Data_cb56
	dw Data_cad2
	dw Data_ca4e

Data_ceae:
	db $20 ; num of tiles

Data_ceaf:
	; index, width
	db $00,  8

	db    3,    8
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3

Data_cf33:
	; index, width
	db $02,  8

	db    4,    8
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7

Data_cfb7:
	; index, width
	db $04, 16

	db    6,    8
	db   96,    0
	db   -8,    0
	db   -4,    1
	db   -4,    1
	db   -8,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   63
	db -128,   31
	db    0,    7
	db    0,    6
	db    0,   31
	db -128,   63
	db -128,   63
	db  -64,   31
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   63
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -8,    3
	db   -4,    1
	db   -4,    1
	db   -8,    0
	db   96,    0
	db  -32,    0
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   31
	db -128,   63
	db -128,   63
	db    0,   31
	db    0,    6

Data_d03b:
	; index, width
	db $08, 16

	db    7,    8
	db   32,    0
	db  120,    0
	db   -4,    0
	db   -4,    1
	db   -4,    1
	db   -8,    3
	db   -8,    7
	db  -16,    7
	db  -32,   15
	db  -32,   31
	db  -64,   31
	db -128,   63
	db    0,  127
	db    0,   63
	db    0,   30
	db    0,    6
	db    0,    4
	db    0,   30
	db    0,   63
	db -128,   63
	db -128,   63
	db  -64,   31
	db  -32,   31
	db  -32,   15
	db  -16,    7
	db   -8,    7
	db   -8,    3
	db   -4,    1
	db   -2,    0
	db   -4,    0
	db  120,    0
	db   96,    0
	db    0,    6
	db    0,   30
	db    0,   63
	db    0,  127
	db -128,   63
	db  -64,   31
	db  -32,   31
	db  -32,   15
	db  -16,    7
	db   -8,    7
	db   -8,    3
	db   -4,    1
	db   -4,    1
	db   -4,    0
	db  120,    0
	db   32,    0
	db   96,    0
	db  120,    0
	db   -4,    0
	db   -2,    0
	db   -4,    1
	db   -8,    3
	db   -8,    7
	db  -16,    7
	db  -32,   15
	db  -32,   31
	db  -64,   31
	db -128,   63
	db -128,   63
	db    0,   63
	db    0,   30
	db    0,    4

Data_d0bf:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    0

Data_d143:
	; index, width
	db $10, 16

	db    8,    7
	db    0,    0
	db    0,    0
	db   28,    0
	db  126,    0
	db   -2,    0
	db   -1,    3
	db   -2,    7
	db   -4,   15
	db   -8,   63
	db  -32,   -1
	db  -64,   -1
	db    0,  127
	db    0,  126
	db    0,   56
	db    0,   16
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db    0,  126
	db    0,  127
	db  -64,   -1
	db  -32,  127
	db  -16,   63
	db   -4,   31
	db   -1,    7
	db   -1,    3
	db   -2,    0
	db  126,    0
	db   28,    0
	db    8,    0
	db    0,    0
	db    0,    0
	db    0,   16
	db    0,   56
	db    0,  126
	db    0,  127
	db  -64,   -1
	db  -32,   -1
	db   -8,   63
	db   -4,   15
	db   -2,    7
	db   -1,    3
	db   -2,    0
	db  126,    0
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    8,    0
	db   28,    0
	db  126,    0
	db   -2,    0
	db   -1,    3
	db   -1,    7
	db   -4,   31
	db  -16,   63
	db  -32,  127
	db  -64,   -1
	db    0,  127
	db    0,  126
	db    0,   56
	db    0,    0
	db    0,    0

Data_d1c7:
	; index, width
	db $14, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   12,    0
	db   62,    0
	db   -2,    0
	db   -1,    3
	db   -1,   15
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db  -64,   -1
	db    0,  126
	db    0,  120
	db    0,   32
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   48
	db    0,  124
	db    0,  127
	db  -64,   -1
	db  -16,   -1
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    3
	db  126,    0
	db   30,    0
	db    4,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   32
	db    0,  120
	db    0,  126
	db  -64,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -1,   15
	db   -1,    3
	db   -2,    0
	db   62,    0
	db   12,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    4,    0
	db   30,    0
	db  126,    0
	db   -1,    3
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db  -16,   -1
	db  -64,   -1
	db    0,  127
	db    0,  124
	db    0,   48
	db    0,    0
	db    0,    0

Data_d24b:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_d2cf:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_d353:
	dw Data_ceaf
	dw Data_cf33
	dw Data_cfb7
	dw Data_d03b
	dw Data_d0bf
	dw Data_d143
	dw Data_d1c7
	dw Data_d24b
	dw Data_d2cf
	dw Data_d24b
	dw Data_d1c7
	dw Data_d143
	dw Data_d0bf
	dw Data_d03b
	dw Data_cfb7
	dw Data_cf33
	dw Data_ceaf
	dw Data_cf33
	dw Data_cfb7
	dw Data_d03b
	dw Data_d0bf
	dw Data_d143
	dw Data_d1c7
	dw Data_d24b
	dw Data_d2cf
	dw Data_d24b
	dw Data_d1c7
	dw Data_d143
	dw Data_d0bf
	dw Data_d03b
	dw Data_cfb7
	dw Data_cf33

Data_d393:
	db $20 ; num of tiles

Data_d394:
	; index, width
	db $00,  8

	db    3,    7
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db    0,    0
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0

Data_d418:
	; index, width
	db $02,  8

	db    4,    7
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db    0,    0
	db    0,    0
	db    0,    0
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db    0,    0
	db    0,    0
	db    0,    0
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0

Data_d49c:
	; index, width
	db $04, 16

	db    5,    7
	db    0,    0
	db  -32,    1
	db  -16,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db -128,    7
	db -128,   15
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db  -64,    1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db -128,    3
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db  -16,    1
	db  -32,    1
	db    0,    0
	db    0,    0
	db    0,    0
	db  -64,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   15
	db -128,    7
	db    0,    0

Data_d520:
	; index, width
	db $08, 16

	db    6,    7
	db    0,    0
	db   96,    0
	db  -16,    0
	db   -8,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   31
	db    0,   15
	db    0,    6
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    6
	db    0,   15
	db -128,   31
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -8,    1
	db  -16,    0
	db   96,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    6
	db    0,   15
	db -128,   31
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -8,    1
	db  -16,    0
	db   96,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   96,    0
	db  -16,    0
	db   -8,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   31
	db    0,   15
	db    0,    6
	db    0,    0

Data_d5a4:
	; index, width
	db $0c, 16

	db    6,    7
	db    0,    0
	db   32,    0
	db  112,    0
	db   -8,    0
	db   -4,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,   63
	db    0,   31
	db    0,   14
	db    0,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    4
	db    0,   14
	db    0,   31
	db -128,   63
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -4,    1
	db   -8,    0
	db  112,    0
	db   32,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    4
	db    0,   14
	db    0,   31
	db -128,   63
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -4,    1
	db   -8,    0
	db  112,    0
	db   32,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   32,    0
	db  112,    0
	db   -8,    0
	db   -4,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,   63
	db    0,   31
	db    0,   14
	db    0,    4
	db    0,    0

Data_d628:
	; index, width
	db $10, 16

	db    7,    6
	db    0,    0
	db    0,    0
	db   16,    0
	db   56,    0
	db   -4,    0
	db   -2,    1
	db   -2,    7
	db   -4,   15
	db   -8,   31
	db  -16,   63
	db  -64,   63
	db    0,   31
	db    0,   14
	db    0,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    8
	db    0,   28
	db    0,   63
	db -128,  127
	db  -32,  127
	db  -16,   63
	db   -8,   31
	db   -4,   15
	db   -4,    3
	db   -8,    0
	db  112,    0
	db   32,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    4
	db    0,   14
	db    0,   31
	db  -64,   63
	db  -16,   63
	db   -8,   31
	db   -4,   15
	db   -2,    7
	db   -2,    1
	db   -4,    0
	db   56,    0
	db   16,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   32,    0
	db  112,    0
	db   -8,    0
	db   -4,    3
	db   -4,   15
	db   -8,   31
	db  -16,   63
	db  -32,  127
	db -128,  127
	db    0,   63
	db    0,   28
	db    0,    8
	db    0,    0
	db    0,    0

Data_d6ac:
	; index, width
	db $14, 16

	db    7,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   24,    0
	db  124,    0
	db   -2,    3
	db   -2,   15
	db   -2,   63
	db   -2,   63
	db   -8,   63
	db  -64,   31
	db    0,   31
	db    0,   24
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   24
	db    0,   62
	db  -64,  127
	db  -16,  127
	db   -4,  127
	db   -4,  127
	db   -4,   31
	db   -8,    3
	db   -8,    0
	db   24,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   24
	db    0,   31
	db  -64,   31
	db   -8,   63
	db   -2,   63
	db   -2,   63
	db   -2,   15
	db   -2,    3
	db  124,    0
	db   24,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   24,    0
	db   -8,    0
	db   -8,    3
	db   -4,   31
	db   -4,  127
	db   -4,  127
	db  -16,  127
	db  -64,  127
	db    0,   62
	db    0,   24
	db    0,    0
	db    0,    0
	db    0,    0

Data_d730:
	; index, width
	db $18, 16

	db    7,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   28,    0
	db   -2,    3
	db   -2,   63
	db   -2,   63
	db   -2,   63
	db   -4,   63
	db  -32,   63
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db  -64,  127
	db   -4,  127
	db   -4,  127
	db   -4,  127
	db   -4,   63
	db   -4,    7
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db  -32,   63
	db   -4,   63
	db   -2,   63
	db   -2,   63
	db   -2,   63
	db   -2,    3
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db   -4,    7
	db   -4,   63
	db   -4,  127
	db   -4,  127
	db   -4,  127
	db  -64,  127
	db    0,   56
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_d7b4:
	; index, width
	db $1c, 16

	db    7,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   63
	db   -2,   63
	db   -2,   63
	db   -2,   63
	db   -2,   63
	db   -4,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   63
	db   -4,  127
	db   -4,  127
	db   -4,  127
	db   -4,  127
	db   -4,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   63
	db   -2,   63
	db   -2,   63
	db   -2,   63
	db   -2,   63
	db   -4,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   63
	db   -4,  127
	db   -4,  127
	db   -4,  127
	db   -4,  127
	db   -4,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_d838:
	dw Data_d394
	dw Data_d418
	dw Data_d49c
	dw Data_d520
	dw Data_d5a4
	dw Data_d628
	dw Data_d6ac
	dw Data_d730
	dw Data_d7b4
	dw Data_d730
	dw Data_d6ac
	dw Data_d628
	dw Data_d5a4
	dw Data_d520
	dw Data_d49c
	dw Data_d418
	dw Data_d394
	dw Data_d418
	dw Data_d49c
	dw Data_d520
	dw Data_d5a4
	dw Data_d628
	dw Data_d6ac
	dw Data_d730
	dw Data_d7b4
	dw Data_d730
	dw Data_d6ac
	dw Data_d628
	dw Data_d5a4
	dw Data_d520
	dw Data_d49c
	dw Data_d418

Data_d878:
	db $20 ; num of tiles

Data_d879:
	; index, width
	db $00,  8

	db    3,    8
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0

Data_d8fd:
	; index, width
	db $02,  8

	db    4,    8
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db    0,    0
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db    0,    0
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0

Data_d981:
	; index, width
	db $04, 16

	db    5,    8
	db    0,    0
	db  -32,    0
	db  -16,    1
	db   -8,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,    7
	db    0,    0
	db    0,    7
	db -128,   15
	db -128,   31
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db   -8,    1
	db  -16,    1
	db  -32,    0
	db    0,    0
	db  -32,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   31
	db -128,   15
	db    0,    7
	db    0,    0

Data_da05:
	; index, width
	db $08, 16

	db    6,    8
	db    0,    0
	db   32,    0
	db   -8,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   15
	db    0,    6
	db    0,    0
	db    0,    4
	db    0,   31
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db  -16,    0
	db   96,    0
	db    0,    6
	db    0,   15
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db   -8,    0
	db   32,    0
	db    0,    0
	db   96,    0
	db  -16,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   31
	db    0,    4
	db    0,    0

Data_da89:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_db0d:
	; index, width
	db $10, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    1
	db   -2,    3
	db   -4,   15
	db   -4,   31
	db  -16,  127
	db  -32,   -1
	db -128,   -1
	db    0,  126
	db    0,   60
	db    0,   56
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db -128,   63
	db  -64,  127
	db  -16,   63
	db   -8,   63
	db   -2,   15
	db   -1,    7
	db   -1,    1
	db  126,    0
	db   60,    0
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db    0,   60
	db    0,  126
	db -128,   -1
	db  -32,   -1
	db  -16,  127
	db   -4,   31
	db   -4,   15
	db   -2,    3
	db   -4,    1
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   28,    0
	db   60,    0
	db  126,    0
	db   -1,    1
	db   -1,    7
	db   -2,   15
	db   -8,   63
	db  -16,   63
	db  -64,  127
	db -128,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_db91:
	; index, width
	db $14, 16

	db    8,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db   -4,    0
	db   -2,    7
	db   -2,   31
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db -128,   -1
	db    0,  126
	db    0,  112
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   63
	db  -32,  127
	db   -8,  127
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    1
	db  126,    0
	db   14,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  112
	db    0,  126
	db -128,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -2,   31
	db   -2,    7
	db   -4,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   14,    0
	db  126,    0
	db   -1,    1
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db   -8,  127
	db  -32,  127
	db    0,   63
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,    0

Data_dc15:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -2,    7
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db  -64,   -1
	db    0,  120
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db  -32,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db   -1,    3
	db   30,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  120
	db  -64,   -1
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,    7
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   30,    0
	db   -1,    3
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db  -32,  127
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_dc99:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_dd1d:
	dw Data_d879
	dw Data_d8fd
	dw Data_d981
	dw Data_da05
	dw Data_da89
	dw Data_db0d
	dw Data_db91
	dw Data_dc15
	dw Data_dc99
	dw Data_dc15
	dw Data_db91
	dw Data_db0d
	dw Data_da89
	dw Data_da05
	dw Data_d981
	dw Data_d8fd
	dw Data_d879
	dw Data_d8fd
	dw Data_d981
	dw Data_da05
	dw Data_da89
	dw Data_db0d
	dw Data_db91
	dw Data_dc15
	dw Data_dc99
	dw Data_dc15
	dw Data_db91
	dw Data_db0d
	dw Data_da89
	dw Data_da05
	dw Data_d981
	dw Data_d8fd

Data_dd5d:
	db $20 ; num of tiles

Data_dd5e:
	; index, width
	db $00,  8

	db    3,    8
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db    0,    0

Data_dde2:
	; index, width
	db $02,  8

	db    4,    8
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db    0,    0
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7
	db    0,    0

Data_de66:
	; index, width
	db $04, 16

	db    5,    8
	db    0,    0
	db  -32,    0
	db  -16,    1
	db   -8,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   15
	db    0,    7
	db    0,    0
	db    0,    7
	db -128,   15
	db -128,   31
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db  -16,    1
	db  -32,    0
	db    0,    7
	db -128,   15
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db   -8,    1
	db  -16,    1
	db  -32,    0
	db    0,    0
	db  -32,    0
	db  -16,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   31
	db -128,   15
	db    0,    7
	db    0,    0

Data_deea:
	; index, width
	db $08, 16

	db    6,    8
	db    0,    0
	db   32,    0
	db  120,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   31
	db  -64,   31
	db -128,   63
	db    0,   31
	db    0,   14
	db    0,    4
	db    0,    0
	db    0,    4
	db    0,   30
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db   -8,    3
	db   -8,    3
	db   -4,    1
	db   -8,    0
	db  112,    0
	db   32,    0
	db    0,    4
	db    0,   14
	db    0,   31
	db -128,   63
	db  -64,   31
	db  -64,   31
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db  120,    0
	db   32,    0
	db    0,    0
	db   32,    0
	db  112,    0
	db   -8,    0
	db   -4,    1
	db   -8,    3
	db   -8,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   30
	db    0,    4
	db    0,    0

Data_df6e:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   30
	db    0,   12
	db    0,    0
	db    0,    0

Data_dff2:
	; index, width
	db $10, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    1
	db   -2,    3
	db   -4,   15
	db   -8,   31
	db  -16,   63
	db  -32,  127
	db -128,   -1
	db    0,  126
	db    0,   60
	db    0,   16
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db -128,   63
	db  -64,  127
	db  -16,   63
	db   -8,   31
	db   -4,   15
	db   -2,    7
	db   -1,    1
	db  126,    0
	db   60,    0
	db    8,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   16
	db    0,   60
	db    0,  126
	db -128,   -1
	db  -32,  127
	db  -16,   63
	db   -8,   31
	db   -4,   15
	db   -2,    3
	db   -4,    1
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    8,    0
	db   60,    0
	db  126,    0
	db   -1,    1
	db   -2,    7
	db   -4,   15
	db   -8,   31
	db  -16,   63
	db  -64,  127
	db -128,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_e076:
	; index, width
	db $14, 16

	db    8,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db   -4,    0
	db   -2,    3
	db   -2,   31
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db -128,   -1
	db    0,  126
	db    0,   48
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   63
	db  -64,  127
	db   -8,  127
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    1
	db  126,    0
	db   12,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   48
	db    0,  126
	db -128,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -2,   31
	db   -2,    3
	db   -4,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   12,    0
	db  126,    0
	db   -1,    1
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db   -8,  127
	db  -64,  127
	db    0,   63
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,    0

Data_e0fa:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -2,    7
	db   -2,  127
	db   -2,   -1
	db   -2,   -1
	db   -4,   -1
	db  -64,   -1
	db    0,  120
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db  -32,  127
	db   -2,  127
	db   -1,  127
	db   -1,  127
	db   -1,   63
	db   -1,    3
	db   30,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  120
	db  -64,   -1
	db   -4,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,  127
	db   -2,    7
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   30,    0
	db   -1,    3
	db   -1,   63
	db   -1,  127
	db   -1,  127
	db   -2,  127
	db  -32,  127
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_e17e:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,  127
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -2,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -4,  127
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -4,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   63
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -2,   63
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_e202:
	dw Data_dd5e
	dw Data_dde2
	dw Data_de66
	dw Data_deea
	dw Data_df6e
	dw Data_dff2
	dw Data_e076
	dw Data_e0fa
	dw Data_e17e
	dw Data_e0fa
	dw Data_e076
	dw Data_dff2
	dw Data_df6e
	dw Data_deea
	dw Data_de66
	dw Data_dde2
	dw Data_dd5e
	dw Data_dde2
	dw Data_de66
	dw Data_deea
	dw Data_df6e
	dw Data_dff2
	dw Data_e076
	dw Data_e0fa
	dw Data_e17e
	dw Data_e0fa
	dw Data_e076
	dw Data_dff2
	dw Data_df6e
	dw Data_deea
	dw Data_de66
	dw Data_dde2

Data_e242:
	db $20 ; num of tiles

Data_e243:
	; index, width
	db $00,  8

	db    3,    8
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3

Data_e2c7:
	; index, width
	db $02,  8

	db    4,    8
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7

Data_e34b:
	; index, width
	db $04, 16

	db    6,    8
	db   96,    0
	db   -8,    0
	db   -4,    1
	db   -4,    1
	db   -8,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   63
	db -128,   31
	db    0,    7
	db    0,    6
	db    0,   31
	db -128,   63
	db -128,   63
	db  -64,   31
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   63
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -8,    3
	db   -4,    1
	db   -4,    1
	db   -8,    0
	db   96,    0
	db  -32,    0
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   31
	db -128,   63
	db -128,   63
	db    0,   31
	db    0,    6

Data_e3cf:
	; index, width
	db $08, 16

	db    7,    8
	db   32,    0
	db  120,    0
	db   -4,    0
	db   -4,    1
	db   -4,    1
	db   -8,    3
	db   -8,    7
	db  -16,    7
	db  -32,   15
	db  -32,   31
	db  -64,   31
	db -128,   63
	db    0,  127
	db    0,   63
	db    0,   30
	db    0,    6
	db    0,    4
	db    0,   30
	db    0,   63
	db -128,   63
	db -128,   63
	db  -64,   31
	db  -32,   31
	db  -32,   15
	db  -16,    7
	db   -8,    7
	db   -8,    3
	db   -4,    1
	db   -2,    0
	db   -4,    0
	db  120,    0
	db   96,    0
	db    0,    6
	db    0,   30
	db    0,   63
	db    0,  127
	db -128,   63
	db  -64,   31
	db  -32,   31
	db  -32,   15
	db  -16,    7
	db   -8,    7
	db   -8,    3
	db   -4,    1
	db   -4,    1
	db   -4,    0
	db  120,    0
	db   32,    0
	db   96,    0
	db  120,    0
	db   -4,    0
	db   -2,    0
	db   -4,    1
	db   -8,    3
	db   -8,    7
	db  -16,    7
	db  -32,   15
	db  -32,   31
	db  -64,   31
	db -128,   63
	db -128,   63
	db    0,   63
	db    0,   30
	db    0,    4

Data_e453:
	; index, width
	db $0c, 16

	db    7,    7
	db    0,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    0

Data_e4d7:
	; index, width
	db $10, 16

	db    8,    7
	db    0,    0
	db    0,    0
	db   28,    0
	db  126,    0
	db   -2,    0
	db   -1,    3
	db   -2,    7
	db   -4,   15
	db   -8,   63
	db  -32,   -1
	db  -64,   -1
	db    0,  127
	db    0,  126
	db    0,   56
	db    0,   16
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db    0,  126
	db    0,  127
	db  -64,   -1
	db  -32,  127
	db  -16,   63
	db   -4,   31
	db   -1,    7
	db   -1,    3
	db   -2,    0
	db  126,    0
	db   28,    0
	db    8,    0
	db    0,    0
	db    0,    0
	db    0,   16
	db    0,   56
	db    0,  126
	db    0,  127
	db  -64,   -1
	db  -32,   -1
	db   -8,   63
	db   -4,   15
	db   -2,    7
	db   -1,    3
	db   -2,    0
	db  126,    0
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    8,    0
	db   28,    0
	db  126,    0
	db   -2,    0
	db   -1,    3
	db   -1,    7
	db   -4,   31
	db  -16,   63
	db  -32,  127
	db  -64,   -1
	db    0,  127
	db    0,  126
	db    0,   56
	db    0,    0
	db    0,    0

Data_e55b:
	; index, width
	db $14, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   12,    0
	db   62,    0
	db   -2,    0
	db   -1,    3
	db   -1,   15
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db  -64,   -1
	db    0,  126
	db    0,  120
	db    0,   32
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   48
	db    0,  124
	db    0,  127
	db  -64,   -1
	db  -16,   -1
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    3
	db  126,    0
	db   30,    0
	db    4,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   32
	db    0,  120
	db    0,  126
	db  -64,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -1,   15
	db   -1,    3
	db   -2,    0
	db   62,    0
	db   12,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    4,    0
	db   30,    0
	db  126,    0
	db   -1,    3
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db  -16,   -1
	db  -64,   -1
	db    0,  127
	db    0,  124
	db    0,   48
	db    0,    0
	db    0,    0

Data_e5df:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_e663:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_e6e7:
	dw Data_e243
	dw Data_e2c7
	dw Data_e34b
	dw Data_e3cf
	dw Data_e453
	dw Data_e4d7
	dw Data_e55b
	dw Data_e5df
	dw Data_e663
	dw Data_e5df
	dw Data_e55b
	dw Data_e4d7
	dw Data_e453
	dw Data_e3cf
	dw Data_e34b
	dw Data_e2c7
	dw Data_e243
	dw Data_e2c7
	dw Data_e34b
	dw Data_e3cf
	dw Data_e453
	dw Data_e4d7
	dw Data_e55b
	dw Data_e5df
	dw Data_e663
	dw Data_e5df
	dw Data_e55b
	dw Data_e4d7
	dw Data_e453
	dw Data_e3cf
	dw Data_e34b
	dw Data_e2c7

Data_e727:
	db $20 ; num of tiles

Data_e728:
	; index, width
	db $00,  8

	db    3,    8
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,    3

Data_e7ac:
	; index, width
	db $02,  8

	db    4,    8
	db  -32,    1
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db -128,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    1
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db -128,    7

Data_e830:
	; index, width
	db $04, 16

	db    6,    8
	db   96,    0
	db   -8,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   63
	db -128,   31
	db    0,    7
	db    0,    6
	db    0,   31
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   63
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db   -8,    0
	db   96,    0
	db  -32,    0
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,   31
	db    0,    6

Data_e8b4:
	; index, width
	db $08, 16

	db    7,    8
	db   48,    0
	db  120,    0
	db   -4,    0
	db   -4,    1
	db   -4,    1
	db   -8,    3
	db   -8,    7
	db  -16,    7
	db  -32,   15
	db  -32,   31
	db  -64,   31
	db -128,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,    6
	db    0,   12
	db    0,   30
	db    0,   63
	db -128,   63
	db -128,   63
	db  -64,   31
	db  -32,   31
	db  -32,   15
	db  -16,    7
	db   -8,    7
	db   -8,    3
	db   -4,    1
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   96,    0
	db    0,    6
	db    0,   30
	db    0,   63
	db -128,  127
	db -128,   63
	db  -64,   31
	db  -32,   31
	db  -32,   15
	db  -16,    7
	db   -8,    7
	db   -8,    3
	db   -4,    1
	db   -4,    1
	db   -4,    0
	db  120,    0
	db   48,    0
	db   96,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    1
	db   -8,    3
	db   -8,    7
	db  -16,    7
	db  -32,   15
	db  -32,   31
	db  -64,   31
	db -128,   63
	db -128,   63
	db    0,   63
	db    0,   30
	db    0,   12

Data_e938:
	; index, width
	db $0c, 16

	db    8,    8
	db    0,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,   -1
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    8
	db    0,    0
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -1,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db   16,    0
	db    0,    8
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,   -1
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db    0,    0
	db   16,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -1,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    0

Data_e9bc:
	; index, width
	db $10, 16

	db    8,    7
	db    0,    0
	db    0,    0
	db   28,    0
	db  126,    0
	db   -1,    0
	db   -1,    3
	db   -2,    7
	db   -4,   31
	db   -8,   63
	db  -32,   -1
	db  -64,   -1
	db    0,  127
	db    0,  126
	db    0,   56
	db    0,   16
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db    0,  126
	db    0,   -1
	db  -64,   -1
	db  -32,  127
	db   -8,   63
	db   -4,   31
	db   -1,    7
	db   -1,    3
	db   -2,    0
	db  126,    0
	db   28,    0
	db    8,    0
	db    0,    0
	db    0,    0
	db    0,   16
	db    0,   56
	db    0,  126
	db    0,  127
	db  -64,   -1
	db  -32,   -1
	db   -8,   63
	db   -4,   31
	db   -2,    7
	db   -1,    3
	db   -1,    0
	db  126,    0
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    8,    0
	db   28,    0
	db  126,    0
	db   -2,    0
	db   -1,    3
	db   -1,    7
	db   -4,   31
	db   -8,   63
	db  -32,  127
	db  -64,   -1
	db    0,   -1
	db    0,  126
	db    0,   56
	db    0,    0
	db    0,    0

Data_ea40:
	; index, width
	db $14, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db    4,    0
	db   30,    0
	db   -2,    0
	db   -1,    3
	db   -1,   15
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db  -64,   -1
	db    0,  126
	db    0,  120
	db    0,   32
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   32
	db    0,  120
	db    0,  127
	db  -64,   -1
	db  -16,   -1
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    3
	db  126,    0
	db   30,    0
	db    4,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   32
	db    0,  120
	db    0,  126
	db  -64,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -1,   15
	db   -1,    3
	db   -2,    0
	db   30,    0
	db    4,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    4,    0
	db   30,    0
	db  126,    0
	db   -1,    3
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db  -16,   -1
	db  -64,   -1
	db    0,  127
	db    0,  120
	db    0,   32
	db    0,    0
	db    0,    0

Data_eac4:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_eb48:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_ebcc:
	dw Data_e728
	dw Data_e7ac
	dw Data_e830
	dw Data_e8b4
	dw Data_e938
	dw Data_e9bc
	dw Data_ea40
	dw Data_eac4
	dw Data_eb48
	dw Data_eac4
	dw Data_ea40
	dw Data_e9bc
	dw Data_e938
	dw Data_e8b4
	dw Data_e830
	dw Data_e7ac
	dw Data_e728
	dw Data_e7ac
	dw Data_e830
	dw Data_e8b4
	dw Data_e938
	dw Data_e9bc
	dw Data_ea40
	dw Data_eac4
	dw Data_eb48
	dw Data_eac4
	dw Data_ea40
	dw Data_e9bc
	dw Data_e938
	dw Data_e8b4
	dw Data_e830
	dw Data_e7ac

Data_ec0c:
	db $20 ; num of tiles

Data_ec0d:
	; index, width
	db $00,  8

	db    3,    8
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db    0,    0

Data_ec91:
	; index, width
	db $02,  8

	db    4,    8
	db    0,    0
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db    0,    0
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db    0,    0
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db    0,    0

Data_ed15:
	; index, width
	db $04, 16

	db    5,    8
	db    0,    0
	db  -32,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,    7
	db    0,    0
	db    0,    7
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    3
	db   -8,    1
	db   -8,    1
	db  -32,    0
	db    0,    0
	db  -32,    0
	db   -8,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db  -64,   31
	db -128,   31
	db -128,   31
	db    0,    7
	db    0,    0

Data_ed99:
	; index, width
	db $08, 16

	db    6,    8
	db    0,    0
	db   96,    0
	db   -8,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -16,    7
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   15
	db    0,    6
	db    0,    0
	db    0,    6
	db    0,   31
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -32,   15
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db  -16,    0
	db   96,    0
	db    0,    6
	db    0,   15
	db    0,   63
	db -128,   63
	db  -64,   63
	db  -64,   31
	db  -32,   15
	db  -16,    7
	db  -16,    7
	db   -8,    3
	db   -4,    3
	db   -4,    1
	db   -4,    0
	db   -8,    0
	db   96,    0
	db    0,    0
	db   96,    0
	db  -16,    0
	db   -4,    0
	db   -4,    1
	db   -4,    3
	db   -8,    3
	db  -16,    7
	db  -32,   15
	db  -32,   15
	db  -64,   31
	db  -64,   63
	db -128,   63
	db    0,   63
	db    0,   31
	db    0,    6
	db    0,    0

Data_ee1d:
	; index, width
	db $0c, 16

	db    7,    8
	db    0,    0
	db   16,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    8
	db    0,    0
	db    0,    8
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db   16,    0
	db    0,    8
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db   16,    0
	db    0,    0
	db   16,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    8
	db    0,    0

Data_eea1:
	; index, width
	db $10, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db   56,    0
	db  124,    0
	db   -4,    1
	db   -2,    3
	db   -2,   15
	db   -4,   31
	db  -16,  127
	db  -32,   -1
	db -128,   -1
	db    0,  126
	db    0,   60
	db    0,   56
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   28
	db    0,   62
	db -128,   63
	db  -64,  127
	db  -16,  127
	db   -8,   63
	db   -2,   15
	db   -1,    7
	db   -1,    1
	db  126,    0
	db   60,    0
	db   28,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   56
	db    0,   60
	db    0,  126
	db -128,   -1
	db  -32,   -1
	db  -16,  127
	db   -4,   31
	db   -2,   15
	db   -2,    3
	db   -4,    1
	db  124,    0
	db   56,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   28,    0
	db   60,    0
	db  126,    0
	db   -1,    1
	db   -1,    7
	db   -2,   15
	db   -8,   63
	db  -16,  127
	db  -64,  127
	db -128,   63
	db    0,   62
	db    0,   28
	db    0,    0
	db    0,    0

Data_ef25:
	; index, width
	db $14, 16

	db    8,    5
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -4,    0
	db   -2,    7
	db   -2,   31
	db   -2,  127
	db   -4,   -1
	db  -16,   -1
	db -128,   -1
	db    0,  126
	db    0,  112
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db    0,   63
	db  -32,  127
	db   -8,  127
	db   -2,  127
	db   -1,   63
	db   -1,   15
	db   -1,    1
	db  126,    0
	db   14,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  112
	db    0,  126
	db -128,   -1
	db  -16,   -1
	db   -4,   -1
	db   -2,  127
	db   -2,   31
	db   -2,    7
	db   -4,    0
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   14,    0
	db  126,    0
	db   -1,    1
	db   -1,   15
	db   -1,   63
	db   -2,  127
	db   -8,  127
	db  -32,  127
	db    0,   63
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0

Data_efa9:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   60,    0
	db   -2,    7
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db  -64,   -1
	db    0,  120
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   60
	db  -32,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,    3
	db   30,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  120
	db  -64,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,    7
	db   60,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   30,    0
	db   -1,    3
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db  -32,  127
	db    0,   60
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_f02d:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db   -2,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db   -1,  127
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_f0b1:
	dw Data_ec0d
	dw Data_ec91
	dw Data_ed15
	dw Data_ed99
	dw Data_ee1d
	dw Data_eea1
	dw Data_ef25
	dw Data_efa9
	dw Data_f02d
	dw Data_efa9
	dw Data_ef25
	dw Data_eea1
	dw Data_ee1d
	dw Data_ed99
	dw Data_ed15
	dw Data_ec91
	dw Data_ec0d
	dw Data_ec91
	dw Data_ed15
	dw Data_ed99
	dw Data_ee1d
	dw Data_eea1
	dw Data_ef25
	dw Data_efa9
	dw Data_f02d
	dw Data_efa9
	dw Data_ef25
	dw Data_eea1
	dw Data_ee1d
	dw Data_ed99
	dw Data_ed15
	dw Data_ec91

Data_f0f1:
	db $20 ; num of tiles

Data_f0f2:
	; index, width
	db $00,  8

	db    3,    8
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7

Data_f176:
	; index, width
	db $02,  8

	db    4,    8
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -64,    7
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -32,    3
	db  -32,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,   15
	db  -64,    7

Data_f1fa:
	; index, width
	db $04, 16

	db    6,    8
	db  -32,    0
	db   -8,    0
	db   -4,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   63
	db -128,   31
	db    0,    7
	db    0,    7
	db    0,   31
	db -128,   63
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db  -32,    0
	db    0,    7
	db -128,   31
	db -128,   63
	db -128,   31
	db  -64,   31
	db  -64,   15
	db  -32,   15
	db  -32,    7
	db  -16,    7
	db  -16,    7
	db  -16,    3
	db   -8,    3
	db   -8,    1
	db   -4,    1
	db   -8,    0
	db  -32,    0
	db  -32,    0
	db   -8,    1
	db   -4,    1
	db   -8,    1
	db   -8,    3
	db  -16,    3
	db  -16,    7
	db  -32,    7
	db  -32,   15
	db  -32,   15
	db  -64,   15
	db  -64,   31
	db -128,   31
	db -128,   63
	db    0,   31
	db    0,    7

Data_f27e:
	; index, width
	db $08, 16

	db    7,    8
	db   32,    0
	db  120,    0
	db  124,    0
	db   -2,    0
	db   -2,    1
	db   -4,    3
	db   -8,    7
	db  -16,    7
	db  -16,   15
	db  -32,   31
	db  -64,   63
	db -128,   63
	db -128,  127
	db    0,   63
	db    0,   30
	db    0,    4
	db    0,    4
	db    0,   30
	db    0,   62
	db    0,  127
	db -128,  127
	db  -64,   63
	db  -32,   31
	db  -32,   15
	db  -16,   15
	db   -8,    7
	db   -4,    3
	db   -4,    1
	db   -2,    1
	db   -4,    0
	db  120,    0
	db   32,    0
	db    0,    4
	db    0,   30
	db    0,   63
	db -128,  127
	db -128,   63
	db  -64,   63
	db  -32,   31
	db  -16,   15
	db  -16,    7
	db   -8,    7
	db   -4,    3
	db   -2,    1
	db   -2,    0
	db  124,    0
	db  120,    0
	db   32,    0
	db   32,    0
	db  120,    0
	db   -4,    0
	db   -2,    1
	db   -4,    1
	db   -4,    3
	db   -8,    7
	db  -16,   15
	db  -32,   15
	db  -32,   31
	db  -64,   63
	db -128,  127
	db    0,  127
	db    0,   62
	db    0,   30
	db    0,    4

Data_f302:
	; index, width
	db $0c, 16

	db    8,    8
	db   16,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -1,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,   -1
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    8
	db    0,    8
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,   -1
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -1,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db   16,    0
	db    0,    8
	db    0,   28
	db    0,   62
	db    0,  127
	db -128,   -1
	db  -64,  127
	db  -32,   63
	db  -16,   31
	db   -8,   15
	db   -4,    7
	db   -2,    3
	db   -1,    1
	db   -2,    0
	db  124,    0
	db   56,    0
	db   16,    0
	db   16,    0
	db   56,    0
	db  124,    0
	db   -2,    0
	db   -1,    1
	db   -2,    3
	db   -4,    7
	db   -8,   15
	db  -16,   31
	db  -32,   63
	db  -64,  127
	db -128,   -1
	db    0,  127
	db    0,   62
	db    0,   28
	db    0,    8

Data_f386:
	; index, width
	db $10, 16

	db    8,    7
	db    0,    0
	db   24,    0
	db   60,    0
	db  126,    0
	db   -2,    1
	db   -1,    3
	db   -2,    7
	db   -8,   31
	db  -16,   63
	db  -32,  127
	db  -64,   -1
	db    0,  127
	db    0,  126
	db    0,   60
	db    0,   16
	db    0,    0
	db    0,    0
	db    0,   24
	db    0,   60
	db    0,  126
	db -128,  127
	db  -64,   -1
	db  -32,  127
	db   -8,   31
	db   -4,   15
	db   -2,    7
	db   -1,    3
	db   -2,    0
	db  126,    0
	db   60,    0
	db    8,    0
	db    0,    0
	db    0,    0
	db    0,   16
	db    0,   60
	db    0,  126
	db    0,  127
	db  -64,   -1
	db  -32,  127
	db  -16,   63
	db   -8,   31
	db   -2,    7
	db   -1,    3
	db   -2,    1
	db  126,    0
	db   60,    0
	db   24,    0
	db    0,    0
	db    0,    0
	db    8,    0
	db   60,    0
	db  126,    0
	db   -2,    0
	db   -1,    3
	db   -2,    7
	db   -4,   15
	db   -8,   31
	db  -32,  127
	db  -64,   -1
	db -128,  127
	db    0,  126
	db    0,   60
	db    0,   24
	db    0,    0

Data_f40a:
	; index, width
	db $14, 16

	db    8,    6
	db    0,    0
	db    0,    0
	db    4,    0
	db   30,    0
	db   -2,    0
	db   -1,    3
	db   -1,   15
	db   -1,  127
	db   -4,   -1
	db  -16,   -1
	db  -64,   -1
	db    0,  126
	db    0,  120
	db    0,   32
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   32
	db    0,  120
	db    0,  127
	db  -64,   -1
	db  -16,   -1
	db   -2,   -1
	db   -1,   63
	db   -1,   15
	db   -1,    3
	db  126,    0
	db   30,    0
	db    4,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,   32
	db    0,  120
	db    0,  126
	db  -64,   -1
	db  -16,   -1
	db   -4,   -1
	db   -1,  127
	db   -1,   15
	db   -1,    3
	db   -2,    0
	db   30,    0
	db    4,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    4,    0
	db   30,    0
	db  126,    0
	db   -1,    3
	db   -1,   15
	db   -1,   63
	db   -2,   -1
	db  -16,   -1
	db  -64,   -1
	db    0,  127
	db    0,  120
	db    0,   32
	db    0,    0
	db    0,    0

Data_f48e:
	; index, width
	db $18, 16

	db    8,    4
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,  124
	db  -32,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,    7
	db   62,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   62,    0
	db   -1,    7
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db  -32,   -1
	db    0,  124
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

Data_f512:
	; index, width
	db $1c, 16

	db    8,    3
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db   -1,   -1
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0
	db    0,    0

PtrTable_f596:
	dw Data_f0f2
	dw Data_f176
	dw Data_f1fa
	dw Data_f27e
	dw Data_f302
	dw Data_f386
	dw Data_f40a
	dw Data_f48e
	dw Data_f512
	dw Data_f48e
	dw Data_f40a
	dw Data_f386
	dw Data_f302
	dw Data_f27e
	dw Data_f1fa
	dw Data_f176
	dw Data_f0f2
	dw Data_f176
	dw Data_f1fa
	dw Data_f27e
	dw Data_f302
	dw Data_f386
	dw Data_f40a
	dw Data_f48e
	dw Data_f512
	dw Data_f48e
	dw Data_f40a
	dw Data_f386
	dw Data_f302
	dw Data_f27e
	dw Data_f1fa
	dw Data_f176

Data_f5d6:
	db $20 ; num of tiles

PtrTable_f5d7::
	dw PtrTable_c4a4
	dw PtrTable_c989
	dw PtrTable_ce6e
	dw PtrTable_d353
	dw PtrTable_d838
	dw PtrTable_dd1d
	dw PtrTable_e202
	dw PtrTable_e6e7
	dw PtrTable_ebcc
	dw PtrTable_f0b1
	dw PtrTable_f596

MACRO? car_gfx
	dba \1 ; graphics
	dw \2 ; pointer
ENDM

CarGfxTable::
	table_width 5
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
	assert_table_length NUM_CAR_TYPES

CarDirectionSpriteFlags::
	db NONE
	db NONE
	db NONE
	db NONE
	db NONE
	db NONE
	db NONE
	db NONE
	db NONE
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP | SPRITEFLAG_YFLIP
	db SPRITEFLAG_XFLIP
	db SPRITEFLAG_XFLIP
	db SPRITEFLAG_XFLIP
	db SPRITEFLAG_XFLIP
	db SPRITEFLAG_XFLIP
	db SPRITEFLAG_XFLIP
	db SPRITEFLAG_XFLIP

Pals_f644::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 10, 10, 10
	rgb 27, 27, 27

Pals_f64c::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 28,  0,  0
	rgb 31, 31, 31

Pals_f654::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  8, 16, 31
	rgb 28, 28, 28

Pals_f65c::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 13, 11,  2
	rgb 25, 21,  7

Pals_f664::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 31, 31,  0
	rgb 31, 31, 31

Pals_f66c::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0,  0, 31
	rgb 31, 31, 31

Pals_f674::
	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb  0, 18,  5
	rgb 27, 27, 27

	rgb  0,  0,  0
	rgb  0,  0,  0
	rgb 23, 17,  0
	rgb 27, 27, 27
