MACRO? dn ; nybbles
	REPT _NARG / 2
		db ((\1) << 4) | (\2)
		shift 2
	ENDR
ENDM

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
