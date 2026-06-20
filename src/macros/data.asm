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

MACRO? dba
	db BANK(\1)
	dw \1
ENDM

MACRO? rgb
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

MACRO? offset_table
DEF _offs = @
ENDM

MACRO? offset
	dw \1 - _offs
ENDM

MACRO? menu_item
	db \1 ; print text type
	dw \2 ; text
	dw \3 ; handler function
ENDM

MACRO? coords_dir
	dw \1 ; x
	dw \2 ; y
	db \3 ; direction
ENDM
