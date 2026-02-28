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

	const_def
	const MODE_TAKE_A_RIDE ; $0
	const MODE_UNK1        ; $1
	const MODE_UNK2        ; $2
	const MODE_UNK3        ; $3
	const MODE_UNK4        ; $4
	const MODE_UNDERCOVER  ; $5
	const MODE_CREDITS     ; $6

; car constants
	const_def
	const CAR_00 ; $0
	const CAR_01 ; $1
	const CAR_02 ; $2
	const CAR_03 ; $3
	const CAR_04 ; $4
	const CAR_05 ; $5
	const CAR_06 ; $6
	const CAR_07 ; $7
	const CAR_08 ; $8
	const CAR_09 ; $9
	const CAR_10 ; $a

RSRESET
DEF CARSTRUCT_0 RB ; $0
DEF CARSTRUCT_1 RB ; $1
DEF CARSTRUCT_2 RB ; $2
DEF CARSTRUCT_3 RB ; $3
DEF CARSTRUCT_4 RB ; $4
DEF CARSTRUCT_5 RB ; $5
DEF CARSTRUCT_6 RB ; $6
DEF CARSTRUCT_7 RB ; $7
DEF CARSTRUCT_8 RB ; $8
DEF CARSTRUCT_9 RB ; $9
DEF CARSTRUCT_A RB ; $a
DEF CARSTRUCT_B RW ; $b
DEF CARSTRUCT_D RW ; $d
DEF CARSTRUCT_F RW ; $f

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

DEF NUM_CITY_PROPS EQU 8 ; how many props in stage
