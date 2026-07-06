	const_def
	const C_0 ; $00
	const C#0 ; $01
	const D_0 ; $02
	const D#0 ; $03
	const E_0 ; $04
	const F_0 ; $05
	const F#0 ; $06
	const G_0 ; $07
	const G#0 ; $08
	const A_0 ; $09
	const A#0 ; $0a
	const B_0 ; $0b
	const C_1 ; $0c
	const C#1 ; $0d
	const D_1 ; $0e
	const D#1 ; $0f
	const E_1 ; $10
	const F_1 ; $11
	const F#1 ; $12
	const G_1 ; $13
	const G#1 ; $14
	const A_1 ; $15
	const A#1 ; $16
	const B_1 ; $17
	const C_2 ; $18
	const C#2 ; $19
	const D_2 ; $1a
	const D#2 ; $1b
	const E_2 ; $1c
	const F_2 ; $1d
	const F#2 ; $1e
	const G_2 ; $1f
	const G#2 ; $20
	const A_2 ; $21
	const A#2 ; $22
	const B_2 ; $23
	const C_3 ; $24
	const C#3 ; $25
	const D_3 ; $26
	const D#3 ; $27
	const E_3 ; $28
	const F_3 ; $29
	const F#3 ; $2a
	const G_3 ; $2b
	const G#3 ; $2c
	const A_3 ; $2d
	const A#3 ; $2e
	const B_3 ; $2f
	const C_4 ; $30
	const C#4 ; $31
	const D_4 ; $32
	const D#4 ; $33
	const E_4 ; $34
	const F_4 ; $35
	const F#4 ; $36
	const G_4 ; $37
	const G#4 ; $38
	const A_4 ; $39
	const A#4 ; $3a
	const B_4 ; $3b
	const C_5 ; $3c
	const C#5 ; $3d
	const D_5 ; $3e
	const D#5 ; $3f
	const E_5 ; $40
	const F_5 ; $41
	const F#5 ; $42
	const G_5 ; $43
	const G#5 ; $44
	const A_5 ; $45
	const A#5 ; $46
	const B_5 ; $47
	const C_6 ; $48
	const C#6 ; $49
	const D_6 ; $4a
	const D#6 ; $4b
	const E_6 ; $4c
	const F_6 ; $4d
	const F#6 ; $4e
	const G_6 ; $4f
	const G#6 ; $50
	const A_6 ; $51
	const A#6 ; $52
	const B_6 ; $53

RSRESET
DEF AUDIO_TRACK_UNK00 RW
DEF AUDIO_TRACK_COMMANDS_PTR RW
DEF AUDIO_TRACK_UNK04 RB
DEF AUDIO_TRACK_UNK05 RB
DEF AUDIO_TRACK_UNK06 RW
DEF AUDIO_TRACK_UNK08 RB
DEF AUDIO_TRACK_UNK09 RB
DEF AUDIO_TRACK_FLAGS RB
DEF AUDIO_TRACK_UNK0B RB
DEF AUDIO_TRACK_UNK0C RB
DEF AUDIO_TRACK_UNK0D RB
DEF AUDIO_TRACK_UNK0E RW
DEF AUDIO_TRACK_LOOP1_COUNTER RB
DEF AUDIO_TRACK_LOOP1_PTR RW
DEF AUDIO_TRACK_LOOP2_COUNTER RB
DEF AUDIO_TRACK_LOOP2_PTR RW

DEF AUDIO_TRACK_STRUCT_SIZE EQU _RS

DEF NUM_AUDIO_TRACKS EQU 8

; flags for AUDIO_TRACK_FLAGS
	const_def
	const TRACKF_ACTIVE_F    ; 0
	const TRACKF_UNK1_F      ; 1
	const TRACKF_PAN_LEFT_F  ; 2
	const TRACKF_PAN_RIGHT_F ; 3
	const TRACKF_UNK4_F      ; 4
	const TRACKF_UNK5_F      ; 5

DEF TRACKF_ACTIVE    EQU 1 << TRACKF_ACTIVE_F
DEF TRACKF_UNK1      EQU 1 << TRACKF_UNK1_F
DEF TRACKF_PAN_LEFT  EQU 1 << TRACKF_PAN_LEFT_F
DEF TRACKF_PAN_RIGHT EQU 1 << TRACKF_PAN_RIGHT_F
DEF TRACKF_UNK4      EQU 1 << TRACKF_UNK4_F
DEF TRACKF_UNK5      EQU 1 << TRACKF_UNK5_F

	const_def 1
	const CHANNEL_1 ; $1
	const CHANNEL_2 ; $2
	const CHANNEL_3 ; $3
	const CHANNEL_4 ; $4
DEF NUM_AUDIO_CHANNELS EQU const_value - 1

RSRESET
DEF AUDIO_CHANNEL_NOTE  RB
DEF AUDIO_CHANNEL_UNK01 RW
DEF AUDIO_CHANNEL_FLAGS RB
DEF AUDIO_CHANNEL_UNK04 RB
DEF AUDIO_CHANNEL_TRACK RB
DEF AUDIO_CHANNEL_PAN   RB
DEF AUDIO_CHANNEL_UNK07 RB
DEF AUDIO_CHANNEL_UNK08 RB
DEF AUDIO_CHANNEL_UNK09 RW
DEF AUDIO_CHANNEL_FREQUENCY RW
DEF AUDIO_CHANNEL_UNK0D RW
DEF AUDIO_CHANNEL_UNK0F RW
DEF AUDIO_CHANNEL_UNK11 RW
DEF AUDIO_CHANNEL_UNK13 RW
DEF AUDIO_CHANNEL_DUTY  RB
DEF AUDIO_CHANNEL_UNK16 RB
DEF AUDIO_CHANNEL_UNK17 RW
DEF AUDIO_CHANNEL_UNK19 RB
DEF AUDIO_CHANNEL_UNK1A RB

DEF AUDIO_CHANNEL_STRUCT_SIZE EQU _RS

; flags for AUDIO_CHANNEL_FLAGS
	const_def
	const CHANNELF_ACTIVE_F  ; 0
	const CHANNELF_TRIGGER_F ; 1
	const CHANNELF_2_F       ; 2
	const CHANNELF_3_F       ; 3
	const CHANNELF_4_F       ; 4
	const CHANNELF_5_F       ; 5
	const CHANNELF_6_F       ; 6
	const CHANNELF_7_F       ; 7

DEF CHANNELF_ACTIVE  EQU 1 << CHANNELF_ACTIVE_F
DEF CHANNELF_TRIGGER EQU 1 << CHANNELF_TRIGGER_F
DEF CHANNELF_2       EQU 1 << CHANNELF_2_F
DEF CHANNELF_3       EQU 1 << CHANNELF_3_F
DEF CHANNELF_4       EQU 1 << CHANNELF_4_F
DEF CHANNELF_5       EQU 1 << CHANNELF_5_F
DEF CHANNELF_6       EQU 1 << CHANNELF_6_F
DEF CHANNELF_7       EQU 1 << CHANNELF_7_F

; flags for AUDIO_CHANNEL_PAN
	const_def
	const TRACK_PAN_LEFT_F  ; 0
	const TRACK_PAN_RIGHT_F ; 1

DEF TRACK_PAN_LEFT  EQU 1 << TRACK_PAN_LEFT_F
DEF TRACK_PAN_RIGHT EQU 1 << TRACK_PAN_RIGHT_F

DEF MAX_AUDIO_QUEUE_SIZE EQU 16

	const_def
	const AUDIOFUNC_PLAY_SFX   ; $0
	const AUDIOFUNC_PLAY_MUSIC ; $1
	const AUDIOFUNC_STOP_SOUND ; $2
	const AUDIOFUNC_STOP_SFX       ; $3
	const AUDIOFUNC_UNK4       ; $4
