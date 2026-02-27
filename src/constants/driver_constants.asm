; city constants
	const_def
	const MIAMI       ; $0
	const LOS_ANGELES ; $1
	const NEW_YORK    ; $2

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
