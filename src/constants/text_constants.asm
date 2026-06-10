DEF MAX_LINE_SIZE EQU 20
DEF MAX_NUM_LINES EQU TILEMAP_HEIGHT

; how many different characters to load
; when printing one or two lines
DEF CHARACTER_SET_SIZE_ONE_LINE  EQU 16
DEF CHARACTER_SET_SIZE_TWO_LINES EQU 32

	const_def 1
	const HUDMSG_INIT ; $1
	const HUDMSG_LOAD_CHARS ; $2
	const HUDMSG_PRINT_TEXT ; $3
