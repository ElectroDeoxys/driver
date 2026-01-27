MACRO audio_wait
	IF _NARG == 0
		db $00
	ELIF \1 < 128
		db \1
	ELSE
		db HIGH(\1) | $80
		db LOW(\1)
	ENDC
ENDM

MACRO? note
	db \1 + C_3 ; note
	
	IF _NARG > 1
		db \2 ; ?
		IF _NARG > 2
			SHIFT 2
			audio_wait \#
		ENDC
	ENDC
ENDM

	const_def $80

	const AUDIOCMD_END ; $80
MACRO? audio_end
	db AUDIOCMD_END
	audio_wait \#
ENDM

	const AUDIOCMD_NOP1 ; $81
MACRO? audio_nop1
	db AUDIOCMD_NOP1
	audio_wait \#
ENDM

	const AUDIOCMD_UNK82 ; $82
MACRO? audio_82
	db AUDIOCMD_UNK82
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK83 ; $83
MACRO? audio_83
	db AUDIOCMD_UNK83
	audio_wait \#
ENDM

	const AUDIOCMD_UNK84 ; $84
MACRO? audio_84
	db AUDIOCMD_UNK84
	audio_wait \#
ENDM

	const AUDIOCMD_UNK85 ; $85
MACRO? audio_85
	db AUDIOCMD_UNK85
	audio_wait \#
ENDM

	const AUDIOCMD_UNK86 ; $86
MACRO? audio_86
	db AUDIOCMD_UNK86
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK87 ; $87
MACRO? audio_87
	db AUDIOCMD_UNK87
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

DEF PAN_LEFT  EQU $3f
DEF NO_PAN    EQU $40
DEF PAN_RIGHT EQU $41

	const AUDIOCMD_PAN ; $88
MACRO? pan
	db AUDIOCMD_PAN
	db \1
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK89 ; $89
MACRO? audio_89
	db AUDIOCMD_UNK89
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNUSED_8A ; $8a
	const AUDIOCMD_UNUSED_8B ; $8b
	const AUDIOCMD_UNUSED_8C ; $8c
	const AUDIOCMD_UNUSED_8D ; $8d
	const AUDIOCMD_UNUSED_8E ; $8e
	const AUDIOCMD_UNUSED_8F ; $8f

	const AUDIOCMD_UNK90 ; $90
MACRO? audio_90
	db AUDIOCMD_UNK90
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK91 ; $91
MACRO? audio_91
	db AUDIOCMD_UNK91
	dw \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK92 ; $92
MACRO? audio_92
	db AUDIOCMD_UNK92
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK93 ; $93
MACRO? audio_93
	db AUDIOCMD_UNK93
	dw \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK94 ; $94
MACRO? audio_94
	db AUDIOCMD_UNK94
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK95 ; $95
MACRO? audio_95
	db AUDIOCMD_UNK95
	dw \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK96 ; $96
MACRO? audio_96
	db AUDIOCMD_UNK96
	db \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_UNK97 ; $97
MACRO? audio_97
	db AUDIOCMD_UNK97
	dw \1 ; ?
	SHIFT
	audio_wait \#
ENDM

	const AUDIOCMD_NOP2 ; $98
MACRO? audio_nop2
	db AUDIOCMD_NOP2
	audio_wait \#
ENDM

	const AUDIOCMD_UNK99 ; $99
MACRO? audio_99
	db AUDIOCMD_UNK99
	audio_wait \#
ENDM

	const AUDIOCMD_UNUSED_9A ; $9a
	const AUDIOCMD_UNUSED_9B ; $9b
	const AUDIOCMD_UNUSED_9C ; $9c
	const AUDIOCMD_UNUSED_9D ; $9d
	const AUDIOCMD_UNUSED_9E ; $9e
	const AUDIOCMD_UNUSED_9F ; $9f

	const AUDIOCMD_UNKA0 ; $a0
MACRO? audio_a0
	db AUDIOCMD_UNKA0
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA1 ; $a1
MACRO? audio_a1
	db AUDIOCMD_UNKA1
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA2 ; $a2
MACRO? audio_a2
	db AUDIOCMD_UNKA2
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA3 ; $a3
MACRO? audio_a3
	db AUDIOCMD_UNKA3
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA4 ; $a4
MACRO? audio_a4
	db AUDIOCMD_UNKA4
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA5 ; $a5
MACRO? audio_a5
	db AUDIOCMD_UNKA5
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA6 ; $a6
MACRO? audio_a6
	db AUDIOCMD_UNKA6
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA7 ; $a7
MACRO? audio_a7
	db AUDIOCMD_UNKA7
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA8 ; $a8
MACRO? audio_a8
	db AUDIOCMD_UNKA8
	audio_wait \#
ENDM

	const AUDIOCMD_UNKA9 ; $a9
MACRO? audio_a9
	db AUDIOCMD_UNKA9
	audio_wait \#
ENDM

	const AUDIOCMD_UNKAA ; $aa
MACRO? audio_aa
	db AUDIOCMD_UNKAA
	audio_wait \#
ENDM

	const AUDIOCMD_UNKAB ; $ab
MACRO? audio_ab
	db AUDIOCMD_UNKAB
	audio_wait \#
ENDM

	const AUDIOCMD_UNKAC ; $ac
MACRO? audio_ac
	db AUDIOCMD_UNKAC
	audio_wait \#
ENDM

	const AUDIOCMD_UNKAD ; $ad
MACRO? audio_ad
	db AUDIOCMD_UNKAD
	audio_wait \#
ENDM

	const AUDIOCMD_UNKAE ; $ae
MACRO? audio_ae
	db AUDIOCMD_UNKAE
	audio_wait \#
ENDM

	const AUDIOCMD_UNKAF ; $af
MACRO? audio_af
	db AUDIOCMD_UNKAF
	audio_wait \#
ENDM

	const AUDIOCMD_LOOP1 ; $b0
MACRO? audio_loop
	db AUDIOCMD_LOOP1
	IF _NARG == 1
		db \1 ; num repetitions
	ELSE
		db 0 ; loop indefinitely
	ENDC
	db $00
ENDM

	const AUDIOCMD_LOOP2 ; $b1
MACRO? audio_loop2
	db AUDIOCMD_LOOP2
	IF _NARG == 1
		db \1 ; num repetitions
	ELSE
		db 0 ; loop indefinitely
	ENDC
	db $00
ENDM

	const AUDIOCMD_UNUSED_B2 ; $b2
	const AUDIOCMD_UNUSED_B3 ; $b3

	const AUDIOCMD_END_LOOP1 ; $b4
MACRO? audio_end_loop
	db AUDIOCMD_END_LOOP1
	audio_wait \#
ENDM

	const AUDIOCMD_END_LOOP2 ; $b5
MACRO? audio_end_loop2
	db AUDIOCMD_END_LOOP2
	audio_wait \#
ENDM
