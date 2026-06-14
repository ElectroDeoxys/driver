; city constants
	const_def
	const MIAMI       ; $0
	const LOS_ANGELES ; $1
	const NEW_YORK    ; $2
DEF NUM_CITIES EQU const_value

; wUnlockedCities flags
DEF MIAMI_UNLOCKED       EQU 1 << MIAMI
DEF LOS_ANGELES_UNLOCKED EQU 1 << LOS_ANGELES
DEF NEW_YORK_UNLOCKED    EQU 1 << NEW_YORK

; wGameMode constants
	const_def
	const MODE_TAKE_A_RIDE ; $0
	const MODE_CHECKPOINT  ; $1
	const MODE_GET_AWAY    ; $2
	const MODE_PURSUIT     ; $3
	const MODE_SURVIVAL    ; $4
	const MODE_UNDERCOVER  ; $5
	const MODE_CREDITS     ; $6

; mission constants
	const_def
DEF MIAMI_MISSIONS EQU const_value
	const MISSION_THE_BANK_JOB               ; $0
	const MISSION_HIDE_THE_EVIDENCE          ; $1
	const MISSION_BOAT_CHASE                 ; $2
	const MISSION_RAM_RAID_RACE              ; $3
	const MISSION_SUPERFLY_DRIVE             ; $4
	const MISSION_BAIT_FOR_A_TRAP            ; $5
	const MISSION_TAKE_OUT_DIANGELO          ; $6
DEF LOS_ANGELES_MISSIONS EQU const_value
	const MISSION_STEAL_A_COP_CAR            ; $7
	const MISSION_GET_LUCKY_TO_THE_DOCS      ; $8
	const MISSION_BEVERLY_HILLS_GET_AWAY     ; $9
DEF NEW_YORK_MISSIONS EQU const_value
	const MISSION_GRAND_CENTRAL_STATION      ; $a
	const MISSION_TRASH_GRANGERS_WHEELS      ; $b
	const MISSION_STOP_GRANGERS_GANG         ; $c
	const MISSION_CHASE_ONE_OF_GRANGERS_BOYS ; $d
	const MISSION_CROSS_TOWN_RECORD          ; $e
DEF NUM_MISSIONS EQU const_value

; world props
	const_def
	const PROP_0 ; $0
	const PROP_1 ; $1
	const PROP_2 ; $2
	const PROP_3 ; $3
	const PROP_4 ; $4
	const PROP_5 ; $5
	const PROP_6 ; $6
	const PROP_7 ; $7
	const PROP_8 ; $8
	const PROP_9 ; $9
	const PROP_A ; $a
	const PROP_B ; $b
	const PROP_C ; $c
	const PROP_D ; $d

; maximum damage the player's car can take
; corresponds to 8 pixels times 7 damage bar tiles
DEF MAX_DAMAGE EQU 8 * 7

; maximum felony the player can accumulate
; corresponds to 8 pixels times 7 damage bar tiles
DEF MAX_FELONY EQU 8 * 7

DEF NUM_CITY_PROPS EQU 8 ; how many props in stage

; wTimerMode constants
DEF TIMER_MODE_COUNT_DOWN EQU $1
DEF TIMER_MODE_COUNT_UP   EQU $2
