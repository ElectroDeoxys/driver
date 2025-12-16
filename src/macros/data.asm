MACRO? dbw
	db \1
	dw \2
ENDM

MACRO? dwb
	dw \1
	db \2
ENDM

MACRO? rgb
	dw (\3 << 10 | \2 << 5 | \1)
ENDM
