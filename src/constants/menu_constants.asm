; how many frames to trigger credits in Title screen/Main Menu
DEF TITLESCREEN_CREDITS_TIMER EQU 180 ;  ~3 seconds
DEF MAIN_MENU_CREDITS_TIMER   EQU 900 ; ~18 seconds

; wTitlescreenTransition constants
DEF GOTO_CREDITS   EQU $1
DEF GOTO_MAIN_MENU EQU $2

; constants for LoadScene
	const_def
	const SCENE_GB_DISCLAIMER        ; $0
	const_skip
	const_skip
	const SCENE_CRAWFISH_INTERACTIVE ; $3
	const_skip
	const SCENE_LEGAL_INFO           ; $5
	const SCENE_LICENSED_BY_NINTENDO ; $6
	const SCENE_INFOGRAMES           ; $7
	const SCENE_REFLECTIONS          ; $8
	const SCENE_TITLESCREEN          ; $9

; wLanguage constants
	const_def
	const ENGLISH ; $0
	const FRENCH  ; $1
	const GERMAN  ; $2
	const ITALIAN ; $3
	const SPANISH ; $4

; Main Menu entries
	const_def
	const MAINMENU_TAKE_A_RIDE   ; $0
	const MAINMENU_UNDERCOVER    ; $1
	const MAINMENU_DRIVING_GAMES ; $2
	const MAINMENU_OPTIONS       ; $3
	const MAINMENU_BEST_TIMES    ; $4
	const MAINMENU_LANGUAGE      ; $5
	const MAINMENU_CHEATS        ; $6
