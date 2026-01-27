InitAudio::
	jp _InitAudio

Func_f8003::
	jp Func_f80f2

; input:
; - hl = ?
Func_f8006::
	jp Func_f812e

; unreferenced
Func_f8009:
	jp Func_f8155

Func_f800c::
	jp Func_f8159

Func_f800f::
	jp Func_f8186

Func_f8012::
	jp Func_f81aa

Func_f8015::
	jp Func_f81c4

; input:
; - a = ?
; unreferenced
Func_f8018:
	jp Func_f81d6

; copies bc bytes from hl to de
; unreferenced
Func_f801b:
	inc b
	inc c
	jr .start
.loop
	ld a, [hli]
	ld [de], a
	inc de
.start
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

; multiplies a by de and outputs result in hl
ATimesDE:
	ld hl, 0
.loop
	srl a
	jr nc, .skip
	add hl, de
.skip
	ret z
	sla e
	rl d
	jr .loop

; multiplies a by c and outputs result in a
; both c and b must be < 0x10
ATimesC:
	ld b, a
	xor a
	srl c
	ret z
	jr nc, .asm_f8040
	ld a, b
.asm_f8040
	sla b
	srl c
	ret z
	jr nc, .asm_f8048
	add b
.asm_f8048
	sla b
	srl c
	ret z
	jr nc, .asm_f8050
	add b
.asm_f8050
	sla b
	srl c
	ret nc
	add b
	ret

ClearMemory_Bank3e:
	ld e, 0
.loop
	ld [hl], e
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

_InitAudio:
	; clear audio tracks RAM
	ld hl, wAudioTracks
	ld bc, NUM_AUDIO_TRACKS * AUDIO_TRACK_STRUCT_SIZE
	call ClearMemory_Bank3e

	; clear audio channels RAM
	ld hl, wAudioChannels
	ld bc, NUM_AUDIO_CHANNELS * AUDIO_CHANNEL_STRUCT_SIZE
	call ClearMemory_Bank3e

	xor a
	ld hl, wc525
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wc529
	ld [hli], a
	ld [hl], a
	ld [wc52b], a

	ld a, 0.47q8
	call Func_f8520
	ld a, l
	ld [wc523 + 0], a
	ld a, h
	ld [wc523 + 1], a

	ld a, 0.47q8
	call Func_f8520
	ld a, l
	ld [wc527 + 0], a
	ld a, h
	ld [wc527 + 1], a

	ld a, AUDENA_CH1_ON | AUDENA_CH2_ON | AUDENA_CH3_ON | AUDENA_CH4_ON | AUDENA_ON
	ldh [rAUDENA], a

	ld a, AUDVOL_RIGHT | AUDVOL_LEFT
	ldh [rAUDVOL], a
	xor a
	ldh [rAUDTERM], a

	; init channel 1
	ld a, AUD1SWEEP_DOWN
	ldh [rAUD1SWEEP], a
	ld a, AUD1LEN_DUTY_50
	ldh [rAUD1LEN], a
	xor a
	ldh [rAUD1ENV], a
	ldh [rAUD1HIGH], a

	; init channel 2
	ld a, AUD2LEN_DUTY_50
	ldh [rAUD2LEN], a
	xor a
	ldh [rAUD2ENV], a
	ldh [rAUD2HIGH], a

	; init channel 4
	xor a
	ldh [rAUD4LEN], a
	ldh [rAUD4ENV], a
	ldh [rAUD4GO], a
	ldh [rAUD4POLY], a

	; init channel 3
	ldh [rAUD3ENA], a
	ldh [rAUD3HIGH], a
	ldh [rAUD3LEN], a
	ldh [rAUD3LEVEL], a

	ld hl, .WaveSample
	ld c, LOW(_AUD3WAVERAM)
	ld b, AUD3WAVE_SIZE
.loop_copy_wave_sample
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop_copy_wave_sample

	ld a, AUD3ENA_ON
	ldh [rAUD3ENA], a
	ldh [rAUD3HIGH], a
	ret

.WaveSample:
	; square wave with two cycles
	dn 15, 15, 15, 15, 15, 15, 15, 15,  0,  0,  0,  0,  0,  0,  0,  0, 15, 15, 15, 15, 15, 15, 15, 15,  0,  0,  0,  0,  0,  0,  0,  0

Func_f80f2:
	xor a
	ld [wc4b0], a

	ld hl, wc523
	ld a, [hli] ; wc523
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl] ; wc525
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hli], a

	ld a, [hli] ; wc527
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl] ; wc529
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hl], a

	xor a
	ld [wc4b0], a
	ldh [hTrackIndex], a
	ldh [hChannelMixing], a
	ld a, [wc52b]
	and $01
	jr nz, .apply_term
	call Func_f8232
	call UpdateChannels
.apply_term
	ldh a, [hChannelMixing]
	ldh [rAUDTERM], a
	xor a
	ld [wc525 + 1], a
	ld [wc52a], a
	ret

Func_f812e:
	push hl
	push hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wc521 + 0], a
	ld a, h
	ld [wc521 + 1], a
	pop hl
	add hl, de
	ld a, l
	ld [wc51f + 0], a
	ld a, h
	ld [wc51f + 1], a
	pop hl
	add hl, bc
	ld a, l
	ld [wc51d + 0], a
	ld a, h
	ld [wc51d + 1], a
	ret

Func_f8155:
	ld a, [wc4b0]
	ret

; input:
; - a = entry in wc51d
Func_f8159:
	ld b, $ff
	ldh [hff90], a
	ld e, a
	ld d, $00
	ld hl, wc51d
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	add hl, de
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	pop hl
	add hl, de
	ld d, h
	ld e, l
	ld c, [hl] ; num of tracks
.loop_tracks
	inc hl
	inc hl
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	push de
	rrc b
	push bc
	call c, InitTrack
	pop bc
	pop de
	pop hl
	dec c
	jr nz, .loop_tracks
	ret

; input:
; - a = ?
Func_f8186:
	ld e, a
	ld hl, wAudioTracks + AUDIO_TRACK_FLAGS
	ld b, NUM_AUDIO_TRACKS
.loop_tracks
	bit TRACKF_ACTIVE_F, [hl]
	jr z, .next_track
	ld c, l
	ld a, AUDIO_TRACK_UNK0D - AUDIO_TRACK_FLAGS
	add l
	ld l, a
	ld a, [hl] ; AUDIO_TRACK_UNK0D
	ld l, c
	cp e
	jr nz, .next_track
	res TRACKF_ACTIVE_F, [hl] ; AUDIO_TRACK_FLAGS
	ld a, NUM_AUDIO_TRACKS
	sub b
	call Func_f8796
.next_track
	ld a, AUDIO_TRACK_STRUCT_SIZE
	add l
	ld l, a
	dec b
	jr nz, .loop_tracks
	ret

Func_f81aa:
	; deactivate all tracks
	ld hl, wAudioTracks + AUDIO_TRACK_FLAGS
	ld b, NUM_AUDIO_TRACKS
.loop_tracks
	res TRACKF_ACTIVE_F, [hl]
	ld a, AUDIO_TRACK_STRUCT_SIZE
	add l
	ld l, a
	dec b
	jr nz, .loop_tracks

	xor a
	call Func_f81c4
	ld a, $ff
	call Func_f8796
	jp UpdateChannels

; if a is 1, then turns off volume
; else, turns volume to max
Func_f81c4:
	ld hl, wc52b
	dec a
	jr z, .turn_off_volume
; set volume to max
	res 0, [hl] ; wc52b
	ld a, $77
	ldh [rAUDVOL], a
	ret
.turn_off_volume
	set 0, [hl] ; wc52b
	ldh [rAUDVOL], a
	ret

Func_f81d6:
	ld e, a
	ld d, 0
	ld hl, wAudioTracks + AUDIO_TRACK_FLAGS
	ld b, NUM_AUDIO_TRACKS
.loop_tracks
	bit TRACKF_ACTIVE_F, [hl]
	jr z, .next_track
	ld a, AUDIO_TRACK_UNK0D - AUDIO_TRACK_FLAGS
	add l
	ld l, a
	ld a, [hl] ; AUDIO_TRACK_UNK0D
	cp e
	jr nz, .next_track
	inc d
.next_track
	ld a, AUDIO_TRACK_STRUCT_SIZE
	add l
	ld l, a
	dec b
	jr nz, .loop_tracks
	ld a, d
	ret

; finds first inactive audio track, and returns its pointer in hl
; if none are available, return carry
GetNextAvailableTrack:
	ld hl, wAudioTracks + AUDIO_TRACK_FLAGS
	ld b, NUM_AUDIO_TRACKS
	ld de, AUDIO_TRACK_STRUCT_SIZE
.loop_tracks
	bit TRACKF_ACTIVE_F, [hl]
	jr z, .found
	add hl, de
	dec b
	jr nz, .loop_tracks
	scf
	ret
.found
	; set it as active and both left/right pan set
	ld [hl], TRACKF_ACTIVE | TRACKF_PAN_LEFT | TRACKF_PAN_RIGHT
	ld a, l
	sub AUDIO_TRACK_FLAGS
	ld l, a
	and a
	ret

InitTrack:
	push hl
	call GetNextAvailableTrack
	pop de
	ret c ; no tracks available
	xor a
	ld c, l
	ld [hli], a ; AUDIO_TRACK_UNK00
	ld [hli], a
	ld a, e
	ld [hli], a ; AUDIO_TRACK_COMMANDS_PTR
	ld [hl], d  ;
	ld a, AUDIO_TRACK_UNK0E
	add c
	ld l, a
	xor a
	ld [hli], a ; AUDIO_TRACK_UNK0E
	ld [hl], a 
	ld a, AUDIO_TRACK_UNK0B
	add c
	ld l, a
	xor a
	ld [hli], a ; AUDIO_TRACK_UNK0B
	ld [hl], $10 ; AUDIO_TRACK_UNK0C
	ld a, AUDIO_TRACK_UNK0D
	add c
	ld l, a
	ldh a, [hff90]
	ld [hl], a ; AUDIO_TRACK_UNK0D
	ret

Func_f8232:
	ld hl, wAudioTracks + AUDIO_TRACK_FLAGS
	ld b, NUM_AUDIO_TRACKS
	ld de, AUDIO_TRACK_STRUCT_SIZE
.loop_tracks
	ld a, [hl] ; AUDIO_TRACK_FLAGS
	bit TRACKF_ACTIVE_F, a
	push hl
	push de
	push bc
	call nz, Func_f824f
	ld hl, hTrackIndex
	inc [hl]
	pop bc
	pop de
	pop hl
	add hl, de
	dec b
	jr nz, .loop_tracks
	ret

; input:
; - a  = AUDIO_TRACK_FLAGS
; - hl = pointer to wTrack*Flags
Func_f824f:
	ldh [hTrackFlags], a
	ld b, a
	ld a, l
	sub AUDIO_TRACK_FLAGS
	ld c, a
	inc l
	ld a, [hli] ; AUDIO_TRACK_UNK0B
	ldh [hff8c], a
	ld a, [hl] ; AUDIO_TRACK_UNK0C
	ldh [hff8d], a
	ld a, c
	ldh [hTrackPtr + 0], a
	ld a, h
	ldh [hTrackPtr + 1], a
	ld a, [wc4b0]
	inc a
	ld [wc4b0], a
	ld a, AUDIO_TRACK_UNK00
	add c
	ld l, a
	ld a, [hli] ; AUDIO_TRACK_UNK00
	ld d, [hl]
	ld e, a
	ld a, [wc525 + 1]
	bit 5, b
	jr z, .asm_f827b
	ld a, [wc52a]
.asm_f827b
	ld b, a
	ld a, e
	sub b
	ld e, a
	ld a, d
	sbc 0
	ld [hld], a ; AUDIO_TRACK_UNK00
	ld [hl], e
	jr c, .asm_f8288
	or e
	ret nz
.asm_f8288
	ld a, AUDIO_TRACK_COMMANDS_PTR
	add c
	ld l, a
	ld a, [hli]
	ld b, [hl]
	ld l, c
	ld c, a
.next_command
	ld d, h
	ld e, l
.loop
	ld hl, .return
	push hl
	ld a, [bc]
	inc bc
	bit 7, a
	jr z, .note
	sla a
	add LOW(.CommandTable)
	ld l, a
	ld a, HIGH(.CommandTable)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.note
	ld h, d
	ld l, e
	ld d, a
	ldh a, [hTrackFlags]
	bit TRACKF_UNK1_F, a
	ld a, $0f
	jr z, .asm_f82b7
	ld a, [bc]
	inc bc
.asm_f82b7
	ldh [hff8e], a
	ld a, d
	push hl
	push bc
	call Func_f876e
	pop bc
	pop hl
	ret

.return
	ld d, $00
	ld a, [bc]
	inc bc
	cp d
	jr z, .next_command
	bit 7, a
	jr z, .asm_f82d2
	and $7f
	ld d, a
	ld a, [bc]
	inc bc
.asm_f82d2
	ld e, a
	push hl
	ld a, AUDIO_TRACK_UNK00
	add l
	ld l, a
	ld a, [hl] ; AUDIO_TRACK_UNK00
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hl], a
	pop de
	and $80
	jp nz, .loop
	ld a, AUDIO_TRACK_COMMANDS_PTR
	add e
	ld l, a
	ld h, d
	ld a, c
	ld [hli], a ; AUDIO_TRACK_COMMANDS_PTR
	ld [hl], b
	ld a, AUDIO_TRACK_FLAGS
	add e
	ld l, a
	ldh a, [hTrackFlags]
	ld [hl], a ; AUDIO_TRACK_FLAGS
	ret

.CommandTable:
	dw AudioCmd_End ; AUDIOCMD_END
	dw AudioCmd_Nop1 ; AUDIOCMD_NOP1
	dw Func_f83bf ; AUDIOCMD_UNK82
	dw Func_f83e7 ; AUDIOCMD_UNK83
	dw Func_f83df ; AUDIOCMD_UNK84
	dw Func_f83ef ; AUDIOCMD_UNK85
	dw Func_f83f7 ; AUDIOCMD_UNK86
	dw Func_f8403 ; AUDIOCMD_UNK87
	dw AudioCmd_Pan ; AUDIOCMD_PAN
	dw Func_f836c ; AUDIOCMD_UNK89
	dw NULL ; AUDIOCMD_UNUSED_8A
	dw NULL ; AUDIOCMD_UNUSED_8B
	dw NULL ; AUDIOCMD_UNUSED_8C
	dw NULL ; AUDIOCMD_UNUSED_8D
	dw NULL ; AUDIOCMD_UNUSED_8E
	dw NULL ; AUDIOCMD_UNUSED_8F
	dw Func_f836f ; AUDIOCMD_UNK90
	dw Func_f837b ; AUDIOCMD_UNK91
	dw Func_f8388 ; AUDIOCMD_UNK92
	dw Func_f8394 ; AUDIOCMD_UNK93
	dw Func_f83a1 ; AUDIOCMD_UNK94
	dw Func_f83aa ; AUDIOCMD_UNK95
	dw Func_f842f ; AUDIOCMD_UNK96
	dw Func_f843b ; AUDIOCMD_UNK97
	dw AudioCmd_Nop2 ; AUDIOCMD_NOP2
	dw Func_f8497 ; AUDIOCMD_UNK99
	dw NULL ; AUDIOCMD_UNUSED_9A
	dw NULL ; AUDIOCMD_UNUSED_9B
	dw NULL ; AUDIOCMD_UNUSED_9C
	dw NULL ; AUDIOCMD_UNUSED_9D
	dw NULL ; AUDIOCMD_UNUSED_9E
	dw NULL ; AUDIOCMD_UNUSED_9F
	dw Func_f84a3 ; AUDIOCMD_UNKA0
	dw Func_f84a7 ; AUDIOCMD_UNKA1
	dw Func_f84ab ; AUDIOCMD_UNKA2
	dw Func_f84af ; AUDIOCMD_UNKA3
	dw Func_f84b3 ; AUDIOCMD_UNKA4
	dw Func_f84b7 ; AUDIOCMD_UNKA5
	dw Func_f84bb ; AUDIOCMD_UNKA6
	dw Func_f84bf ; AUDIOCMD_UNKA7
	dw Func_f84c3 ; AUDIOCMD_UNKA8
	dw Func_f84c7 ; AUDIOCMD_UNKA9
	dw Func_f84cb ; AUDIOCMD_UNKAA
	dw Func_f84cf ; AUDIOCMD_UNKAB
	dw Func_f84d3 ; AUDIOCMD_UNKAC
	dw Func_f84d7 ; AUDIOCMD_UNKAD
	dw Func_f84db ; AUDIOCMD_UNKAE
	dw Func_f84df ; AUDIOCMD_UNKAF
	dw AudioCmd_SetLoop1 ; AUDIOCMD_LOOP1
	dw AudioCmd_SetLoop2 ; AUDIOCMD_LOOP2
	dw NULL ; AUDIOCMD_UNUSED_B2
	dw NULL ; AUDIOCMD_UNUSED_B3
	dw AudioCmd_EndLoop1 ; AUDIOCMD_END_LOOP1
	dw AudioCmd_EndLoop2 ; AUDIOCMD_END_LOOP2

AudioCmd_Nop1:
; audio_nop1
	ld h, d
	ld l, e
	ret

AudioCmd_End:
; audio_end
	ld a, AUDIO_TRACK_FLAGS
	add e
	ld l, a
	ld h, d
	res TRACKF_ACTIVE_F, [hl]
	pop hl
	ret

Func_f836c:
; audio_89
	ld a, [bc]
	inc bc
	ret

Func_f836f:
; audio_90
	ld a, AUDIO_TRACK_UNK06
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hli], a
	xor a
	ld [hl], a
	ld l, e
	ret

Func_f837b:
; audio_91
	ld a, AUDIO_TRACK_UNK06
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hli], a
	ld a, [bc]
	inc bc
	ld [hl], a
	ld l, e
	ret

Func_f8388:
; audio_92
	ld a, AUDIO_TRACK_UNK00
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hli], a
	xor a
	ld [hl], a
	ld l, e
	ret

Func_f8394:
; audio_93
	ld a, AUDIO_TRACK_UNK00
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hli], a
	ld a, [bc]
	inc bc
	ld [hl], a
	ld l, e
	ret

Func_f83a1:
; audio_94
	ld h, d
	ld l, e
	ld a, [bc]
	ld e, a
	inc bc
	ld d, $00
	jr Func_f83b2
Func_f83aa:
; audio_95
	ld h, d
	ld l, e
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
Func_f83b2:
	push hl
	call Func_f852e
	ld a, AUDIO_TRACK_UNK08
	add l
	ld l, a
	ld a, e
	ld [hli], a
	ld [hl], d
	pop hl
	ret

Func_f83bf:
; audio_82
	push de
	ld a, [bc]
	inc bc
	call Func_f8520
	ldh a, [hTrackFlags]
	and TRACKF_UNK5
	jr nz, .asm_f83d5
	ld a, l
	ld [wc523 + 0], a
	ld a, h
	ld [wc523 + 1], a
	pop hl
	ret
.asm_f83d5
	ld a, l
	ld [wc527 + 0], a
	ld a, h
	ld [wc527 + 1], a
	pop hl
	ret

Func_f83df:
; audio_84
	ld hl, hTrackFlags
	set TRACKF_UNK1_F, [hl]
	ld l, e
	ld h, d
	ret

Func_f83e7:
; audio_83
	ld hl, hTrackFlags
	set TRACKF_UNK5_F, [hl]
	ld l, e
	ld h, d
	ret

Func_f83ef:
; audio_85
	ld hl, hTrackFlags
	res TRACKF_UNK1_F, [hl]
	ld l, e
	ld h, d
	ret

Func_f83f7:
; audio_86
	ld a, AUDIO_TRACK_UNK0B
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hl], a ; AUDIO_TRACK_UNK0B
	ldh [hff8c], a
	ld l, e
	ret

Func_f8403:
; audio_87
	ld a, AUDIO_TRACK_UNK0C
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hl], a ; AUDIO_TRACK_UNK0C
	ldh [hff8d], a
	ld l, e
	ret

AudioCmd_Pan:
; pan
	ld l, e
	ld h, d
	ld a, [bc]
	inc bc
	ld e, $00
	cp PAN_RIGHT
	jr nc, .pan_right
	cp NO_PAN
	jr z, .both_left_and_right
	; a == PAN_LEFT
	ld e, TRACKF_PAN_LEFT
	jr .got_pan
.both_left_and_right
	ld e, TRACKF_PAN_LEFT | TRACKF_PAN_RIGHT
	jr .got_pan
.pan_right
	ld e, TRACKF_PAN_RIGHT
.got_pan
	ldh a, [hTrackFlags]
	and ~(TRACKF_PAN_LEFT | TRACKF_PAN_RIGHT)
	or e
	ldh [hTrackFlags], a
	ret

Func_f842f:
; audio_96
	ld l, e
	ld h, d
	ld a, [bc]
	ld e, a
	xor a
	bit 7, e
	jr z, Func_f8441
	dec a ; -1
	jr Func_f8441
Func_f843b:
; audio_97
	ld l, e
	ld h, d
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
Func_f8441:
	inc bc
	ld d, a
	push bc
	push hl
	ld a, AUDIO_TRACK_UNK0E
	add l
	ld l, a
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh a, [hTrackIndex]
	ld c, a
	ld hl, wChannel1Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .channel_2
	ld a, [wChannel1Track]
	cp c
	jr nz, .channel_2
	set CHANNELF_6_F, [hl]
	ld hl, wChannel1Unk11
	ld a, e
	ld [hli], a
	ld [hl], d
	ld b, $01 ; unused
.channel_2
	ld hl, wChannel2Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .channel_3
	ld a, [wChannel2Track]
	cp c
	jr nz, .channel_3
	set CHANNELF_6_F, [hl]
	ld hl, wChannel2Unk11
	ld a, e
	ld [hli], a
	ld [hl], d
	ld b, $02 ; unused
.channel_3
	ld hl, wChannel3Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .done
	ld a, [wChannel3Track]
	cp c
	jr nz, .done
	set CHANNELF_6_F, [hl]
	ld hl, wChannel3Unk11
	ld a, e
	ld [hli], a
	ld [hl], d
	ld b, $03 ; unused
.done
	pop hl
	pop bc
	ret

Func_f8497:
; audio_99
	ld l, e
	ld h, d
	ldh a, [hTrackFlags]
	set TRACKF_UNK4_F, a
	ldh [hTrackFlags], a
	ret

AudioCmd_Nop2:
; audio_nop2
	ld l, e
	ld h, d
	ret

Func_f84a3:
; audio_a0
	ld l, $00
	jr Func_f84e1
Func_f84a7:
; audio_a1
	ld l, $02
	jr Func_f84e1
Func_f84ab:
; audio_a2
	ld l, $04
	jr Func_f84e1
Func_f84af:
; audio_a3
	ld l, $06
	jr Func_f84e1
Func_f84b3:
; audio_a4
	ld l, $08
	jr Func_f84e1
Func_f84b7:
; audio_a5
	ld l, $0a
	jr Func_f84e1
Func_f84bb:
; audio_a6
	ld l, $0c
	jr Func_f84e1
Func_f84bf:
; audio_a7
	ld l, $0e
	jr Func_f84e1
Func_f84c3:
; audio_a8
	ld l, $10
	jr Func_f84e1
Func_f84c7:
; audio_a9
	ld l, $12
	jr Func_f84e1
Func_f84cb:
; audio_aa
	ld l, $14
	jr Func_f84e1
Func_f84cf:
; audio_ab
	ld l, $16
	jr Func_f84e1
Func_f84d3:
; audio_ac
	ld l, $18
	jr Func_f84e1
Func_f84d7:
; audio_ad
	ld l, $1a
	jr Func_f84e1
Func_f84db:
; audio_ae
	ld l, $1c
	jr Func_f84e1
Func_f84df:
; audio_af
	ld l, $1e
Func_f84e1:
	push de
	ld a, AUDIO_TRACK_UNK06
	add e
	ld e, a
	ld a, [wc521 + 0]
	add l
	ld l, a
	ld a, [wc521 + 1]
	adc 0
	ld h, a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	ret

AudioCmd_SetLoop1:
; audio_loop
	ld a, AUDIO_TRACK_LOOP1_COUNTER
AudioCmd_SetLoop_Common:
	add e
	ld l, a
	ld h, d
	ld a, [bc]
	inc bc
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	ld l, e
	ret
AudioCmd_SetLoop2:
; audio_loop2
	ld a, AUDIO_TRACK_LOOP2_COUNTER
	jr AudioCmd_SetLoop_Common

AudioCmd_EndLoop1:
; audio_end_loop
	ld a, AUDIO_TRACK_LOOP1_COUNTER
AudioCmd_EndLoop_Common:
	add e
	ld l, a
	ld h, d
	ld a, [hl]
	and a
	jr z, .goto_loop
	dec a
	ld [hl], a
	jr z, .no_loop
.goto_loop
	inc l
	ld a, [hli]
	ld b, [hl]
	ld c, a
.no_loop
	ld l, e
	ret
AudioCmd_EndLoop2:
; audio_end_loop2
	ld a, AUDIO_TRACK_LOOP2_COUNTER
	jr AudioCmd_EndLoop_Common

; multiplies input by 4.58
Func_f8520:
	ld de, 4.58q6
	call ATimesDE
	xor a
	add hl, hl
	rla
	add hl, hl
	rla
	ld l, h
	ld h, a
	; hl = hl >> 6
	ret

; input:
; - de = entry in wc51f
; output:
; - de = ?
Func_f852e:
	push hl
	sla e
	rl d ; *2
	ld hl, wc51f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ret

NoteFrequencies:
	dw $02c ;   65.4 Hz C_0
	dw $09d ;   69.3 Hz C#0
	dw $107 ;   73.4 Hz D_0
	dw $16b ;   77.7 Hz D#0
	dw $1c9 ;   82.3 Hz E_0
	dw $223 ;   87.3 Hz F_0
	dw $277 ;   92.4 Hz F#0
	dw $2c7 ;   98.0 Hz G_0
	dw $312 ;  103.8 Hz G#0
	dw $358 ;  109.9 Hz A_0
	dw $39b ;  116.5 Hz A#0
	dw $3da ;  123.4 Hz B_0
	dw $416 ;  130.8 Hz C_1
	dw $44e ;  138.5 Hz C#1
	dw $483 ;  146.7 Hz D_1
	dw $4b5 ;  155.4 Hz D#1
	dw $4e5 ;  164.8 Hz E_1
	dw $511 ;  174.5 Hz F_1
	dw $53b ;  184.8 Hz F#1
	dw $563 ;  195.9 Hz G_1
	dw $589 ;  207.7 Hz G#1
	dw $5ac ;  219.9 Hz A_1
	dw $5ce ;  233.2 Hz A#1
	dw $5ed ;  246.8 Hz B_1
	dw $60b ;  261.6 Hz C_2
	dw $627 ;  277.1 Hz C#2
	dw $642 ;  293.8 Hz D_2
	dw $65b ;  311.3 Hz D#2
	dw $672 ;  329.3 Hz E_2
	dw $689 ;  349.5 Hz F_2
	dw $69e ;  370.2 Hz F#2
	dw $6b2 ;  392.4 Hz G_2
	dw $6c4 ;  414.7 Hz G#2
	dw $6d6 ;  439.8 Hz A_2
	dw $6e7 ;  466.4 Hz A#2
	dw $6f7 ;  494.6 Hz B_2
	dw $705 ;  522.1 Hz C_3
	dw $714 ;  555.3 Hz C#3
	dw $721 ;  587.7 Hz D_3
	dw $72d ;  621.1 Hz D#3
	dw $739 ;  658.6 Hz E_3
	dw $744 ;  697.1 Hz F_3
	dw $74f ;  740.5 Hz F#3
	dw $759 ;  784.8 Hz G_3
	dw $762 ;  829.5 Hz G#3
	dw $76b ;  879.6 Hz A_3
	dw $773 ;  929.5 Hz A#3
	dw $77b ;  985.5 Hz B_3
	dw $783 ; 1048.5 Hz C_4
	dw $78a ; 1110.7 Hz C#4
	dw $790 ; 1170.2 Hz D_4
	dw $797 ; 1248.3 Hz D#4
	dw $79d ; 1323.9 Hz E_4
	dw $7a2 ; 1394.3 Hz F_4
	dw $7a7 ; 1472.7 Hz F#4
	dw $7aa ; 1524.0 Hz G_4
	dw $7b1 ; 1659.1 Hz G#4
	dw $7b6 ; 1771.2 Hz A_4
	dw $7ba ; 1872.4 Hz A#4
	dw $7be ; 1985.9 Hz B_4
	dw $7c1 ; 2080.5 Hz C_5
	dw $7c5 ; 2221.5 Hz C#5
	dw $7c8 ; 2340.5 Hz D_5
	dw $7cb ; 2473.0 Hz D#5
	dw $7ce ; 2621.4 Hz E_5
	dw $7d1 ; 2788.7 Hz F_5
	dw $7d4 ; 2978.9 Hz F#5
	dw $7d5 ; 3048.1 Hz G_5
	dw $7d9 ; 3360.8 Hz G#5
	dw $7db ; 3542.4 Hz A_5
	dw $7dd ; 3744.9 Hz A#5
	dw $7df ; 3971.8 Hz B_5
	dw $7e1 ; 4228.1 Hz C_6
	dw $7e2 ; 4369.0 Hz C#6
	dw $7e4 ; 4681.1 Hz D_6
	dw $7e6 ; 5041.2 Hz D#6
	dw $7e7 ; 5242.8 Hz E_6
	dw $7e9 ; 5698.7 Hz F_6
	dw $7ea ; 5957.8 Hz F#6
	dw $7eb ; 6241.5 Hz G_6
	dw $7ec ; 6553.6 Hz G#6
	dw $7ed ; 6898.5 Hz A_6
	dw $7ee ; 7281.7 Hz A#6
	dw $7ef ; 7710.1 Hz B_6

; input:
; - a  = base note
; - de = pitch offset (in $100th of a note)
; output:
; - de = frequency
GetNoteFrequency:
	push hl
	push bc
	ld h, a
	ld l, $00
	add hl, de
	push hl
	ld l, h
	ld h, $00
	add hl, hl
	ld de, NoteFrequencies
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	sub c
	ld e, a
	ld a, [hl]
	sbc b
	ld d, a
	; bc = this entry
	; de = difference between this and next entry
	pop hl
	ld a, l
	call ATimesDE
	ld a, h
	; a = l*de / $100
	add c
	ld e, a
	ld a, b
	adc 0
	ld d, a
	pop bc
	pop hl
	ret

Func_f8614:
	push af
	push de
	lb bc, -1, -1
	ld d, a
	ldh a, [hff8c]
	ld e, a
	ld a, d
	ld d, b ; -1
	bit 2, l
	jr z, .asm_f8647
	ld a, [wChannel3Flags]
	bit CHANNELF_ACTIVE_F, a
	jp z, .channel_3
	bit CHANNELF_5_F, a
	jr nz, .asm_f863c
.asm_f862f
	ld a, [wChannel3Unk08]
	cp e
	jr z, .asm_f8637
	jr nc, .asm_f8647
.asm_f8637
	ld e, a
	ld d, CHANNEL_3
	jr .asm_f8647
.asm_f863c
	ld a, [wChannel3Unk09 + 1]
	cp c
	jr z, .asm_f8644
	jr nc, .asm_f862f
.asm_f8644
	ld c, a
	ld b, CHANNEL_3
.asm_f8647
	bit 1, l
	jr z, .asm_f866f
	ld a, [wChannel2Flags]
	bit CHANNELF_ACTIVE_F, a
	jp z, .channel_2
	bit CHANNELF_5_F, a
	jr nz, .asm_f8664
.asm_f8657
	ld a, [wChannel2Unk08]
	cp e
	jr z, .asm_f865f
	jr nc, .asm_f866f
.asm_f865f
	ld e, a
	ld d, CHANNEL_2
	jr .asm_f866f
.asm_f8664
	ld a, [wChannel2Unk09 + 1]
	cp c
	jr z, .asm_f866c
	jr nc, .asm_f8657
.asm_f866c
	ld c, a
	ld b, CHANNEL_2
.asm_f866f
	bit 0, l
	jr z, .asm_f8697
	ld a, [wChannel1Flags]
	bit CHANNELF_ACTIVE_F, a
	jp z, .channel_1
	bit CHANNELF_5_F, a
	jr nz, .asm_f868c
.asm_f867f
	ld a, [wChannel1Unk08]
	cp e
	jr z, .asm_f8687
	jr nc, .asm_f8697
.asm_f8687
	ld e, a
	ld d, CHANNEL_1
	jr .asm_f8697
.asm_f868c
	ld a, [wChannel1Unk09 + 1]
	cp c
	jr z, .asm_f8694
	jr nc, .asm_f867f
.asm_f8694
	ld c, a
	ld b, CHANNEL_1
.asm_f8697
	bit 3, l
	jr z, .assign_channel
	ld a, [wChannel4Flags]
	bit CHANNELF_ACTIVE_F, a
	jp z, .channel_4
	bit CHANNELF_5_F, a
	jr nz, .asm_f86b4
.asm_f86a7
	ld a, [wChannel4Unk08]
	cp e
	jr z, .asm_f86af
	jr nc, .assign_channel
.asm_f86af
	ld e, a
	ld d, CHANNEL_4
	jr .assign_channel
.asm_f86b4
	ld a, [wChannel4Unk09 + 1]
	cp c
	jr z, .asm_f86bc
	jr nc, .asm_f86a7
.asm_f86bc
	ld c, a
	ld b, CHANNEL_4

.assign_channel
	dec b
	jr z, .channel_1 ; == CHANNEL_1
	dec b
	jr z, .channel_2 ; == CHANNEL_2
	dec b
	jr z, .channel_3 ; == CHANNEL_3
	dec b
	jr z, .channel_4 ; == CHANNEL_4

	ldh a, [hff8c]
	cp e
	jr c, .set_carry
	dec d
	jr z, .channel_1 ; == CHANNEL_1
	dec d
	jr z, .channel_2 ; == CHANNEL_2
	dec d
	jr z, .channel_3 ; == CHANNEL_3
	dec d
	jr z, .channel_4 ; == CHANNEL_4

.set_carry
	pop de
	pop af
	scf
	ret

.channel_1
	ld bc, wChannel1
	jr .got_channel
.channel_2
	ld bc, wChannel2
	jr .got_channel
.channel_3
	ld bc, wChannel3
	jr .got_channel
.channel_4
	ld bc, wChannel4
.got_channel
	pop de
	pop af
	and a
	ret

; input:
; - a  = note
; - hl = track ptr
; - bc = channel ptr
; - de = ?
InitChannel:
	push hl
	push hl
	ld h, b
	ld l, c
	sub $24
	ld [hli], a ; AUDIO_CHANNEL_NOTE
	ld a, e
	ld [hli], a ; AUDIO_CHANNEL_UNK01
	ld a, d
	ld [hli], a
	ld a, [de]
	bit 1, a
	ld a, CHANNELF_ACTIVE | CHANNELF_TRIGGER | CHANNELF_2 | CHANNELF_6
	jr z, .got_flags
	or CHANNELF_7
.got_flags
	ld [hli], a ; AUDIO_CHANNEL_FLAGS
	ldh a, [hff8e]
	ld c, a
	ldh a, [hff8d]
	call ATimesC
	swap a
	and $0f
	ld [hli], a ; AUDIO_CHANNEL_UNK04
	ldh a, [hTrackIndex]
	ld [hli], a ; AUDIO_CHANNEL_TRACK

	; initialize pan according to track flags
	ldh a, [hTrackFlags]
	ld b, a
	xor a
	bit TRACKF_PAN_LEFT_F, b
	jr z, .check_pan_right
	or TRACK_PAN_LEFT
.check_pan_right
	bit TRACKF_PAN_RIGHT_F, b
	jr z, .got_pan
	or TRACK_PAN_RIGHT
.got_pan
	ld [hli], a ; AUDIO_CHANNEL_PAN

	ld a, $ff
	ld [hli], a ; AUDIO_CHANNEL_UNK07
	ldh a, [hff8c]
	ld [hli], a ; AUDIO_CHANNEL_UNK08
	xor a
	ld [hli], a ; AUDIO_CHANNEL_UNK09
	ld [hli], a
	ld [hli], a ; AUDIO_CHANNEL_UNK0B
	ld [hli], a
	ld [hli], a ; AUDIO_CHANNEL_UNK0D
	ld [hli], a
	ld [hli], a ; AUDIO_CHANNEL_UNK0F
	ld [hli], a
	pop bc
	ld a, AUDIO_TRACK_UNK0E
	add c
	ld c, a
	ld a, [bc] ; AUDIO_TRACK_UNK0E
	inc c
	ld [hli], a ; AUDIO_CHANNEL_UNK11
	ld a, [bc]
	ld [hli], a
	pop bc
	ld a, AUDIO_TRACK_UNK06
	add c
	ld c, a
	ld a, [bc] ; AUDIO_TRACK_UNK06
	inc c
	ld [hli], a ; AUDIO_CHANNEL_UNK13
	ld a, [bc]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a ; AUDIO_CHANNEL_DUTY
	inc de
	ld a, [de]
	ld [hli], a ; AUDIO_CHANNEL_UNK16
	dec de
	dec de
	ld a, [de]
	ld b, a
	xor a
	bit 0, b
	jr z, .asm_f8769
	ld a, $0a
	add e
	ld [hli], a ; AUDIO_CHANNEL_UNK17
	ld a, d
	adc $00
	ld [hli], a
	ld [hl], $01 ; AUDIO_CHANNEL_UNK19
	ret
.asm_f8769
	xor a
	ld [hli], a ; AUDIO_CHANNEL_UNK17
	ld [hli], a
	ld [hl], a ; AUDIO_CHANNEL_UNK19
	ret

Func_f876e:
	ld c, a
	ldh a, [hTrackFlags]
	bit TRACKF_UNK4_F, a
	jr z, .asm_f877f
	ld d, $00
	ld e, c
	call Func_f852e
	ld c, $40
	jr .asm_f8788
.asm_f877f
	ld e, l
	ld a, AUDIO_TRACK_UNK08
	add l
	ld l, a
	ld a, [hli] ; AUDIO_TRACK_UNK08
	ld d, [hl]
	ld l, e
	ld e, a
.asm_f8788
	ld a, [de]
	push hl
	swap a
	ld l, a
	ld a, c
	call Func_f8614
	pop hl
	call nc, InitChannel
	ret

; input:
; - a = track index
Func_f8796:
	push hl
	push bc
	ld c, a

	ld hl, wChannel1Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .asm_f87b7
	; is active
	bit 7, c ; input negative?
	jr nz, .asm_f87aa
	; input is valid track index
	ld a, [wChannel1Track]
	cp c ; playing same track as input?
	jr nz, .asm_f87b7
.asm_f87aa
	ld [hl], CHANNELF_ACTIVE | CHANNELF_TRIGGER | CHANNELF_5 ; wChannel1Flags
	xor a
	ld hl, wChannel1Unk13
	ld [hli], a
	ld [hl], a
	ld hl, wChannel1Unk09
	ld [hli], a
	ld [hl], a

.asm_f87b7
	ld hl, wChannel2Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .asm_f87d5
	; is active
	bit 7, c ; input negative?
	jr nz, .asm_f87c8
	; input is valid track index
	ld a, [wChannel2Track]
	cp c ; playing same track as input?
	jr nz, .asm_f87d5
.asm_f87c8
	ld [hl], CHANNELF_ACTIVE | CHANNELF_TRIGGER | CHANNELF_5 ; wChannel2Flags
	xor a
	ld hl, wChannel2Unk13
	ld [hli], a
	ld [hl], a
	ld hl, wChannel2Unk09
	ld [hli], a
	ld [hl], a

.asm_f87d5
	ld hl, wChannel3Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .asm_f87f3
	; is active
	bit 7, c ; input negative?
	jr nz, .asm_f87e6
	; input is valid track index
	ld a, [wChannel3Track]
	cp c ; playing same track as input?
	jr nz, .asm_f87f3
.asm_f87e6
	ld [hl], CHANNELF_ACTIVE | CHANNELF_TRIGGER | CHANNELF_5 ; wChannel3Flags
	xor a
	ld hl, wChannel3Unk13
	ld [hli], a
	ld [hl], a
	ld hl, wChannel3Unk09
	ld [hli], a
	ld [hl], a

.asm_f87f3
	ld hl, wChannel4Flags
	bit CHANNELF_ACTIVE_F, [hl]
	jr z, .done
	; is active
	bit 7, c ; input negative?
	jr nz, .asm_f8804
	; input is valid track index
	ld a, [wChannel4Track]
	cp c ; playing same track as input?
	jr nz, .done
.asm_f8804
	ld [hl], CHANNELF_ACTIVE | CHANNELF_TRIGGER | CHANNELF_5 ; wChannel4Flags
	xor a
	ld hl, wChannel4Unk13
	ld [hli], a
	ld [hl], a
	ld hl, wChannel4Unk09
	ld [hli], a
	ld [hl], a
.done
	pop bc
	pop hl
	ret

UpdateChannels:
	ld a, [wChannel1Flags]
	and CHANNELF_ACTIVE
	jp z, .channel_2
	ld a, [wChannel1Unk04]
	ldh [hff8e], a
	ld a, [wChannel1Unk19]
	and a
	jr z, .asm_f886b
	dec a
	jr nz, .asm_f8854
	ld hl, wChannel1Unk17
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld e, a
	and a
	jr nz, .asm_f8842
	ld a, [wChannel1Flags]
	and CHANNELF_7
	jr z, .asm_f8854
	ld de, -$19
	add hl, de
	ld a, [hli]
	ld e, a
.asm_f8842
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	ld a, l
	ld d, h
	ld hl, wChannel1Unk17
	ld [hli], a
	ld [hl], d
	ld hl, wChannel1Unk0d
	ld a, c
	ld [hli], a
	ld [hl], b
	ld a, e
.asm_f8854
	ld [wChannel1Unk19], a
	ld hl, wChannel1Unk0d
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel1Unk0f
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hli], a
	ld hl, wChannel1Flags
	set CHANNELF_6_F, [hl]
.asm_f886b
	ld hl, wChannel1Unk09
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel1Unk01
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wChannel1Flags]
	ld c, a
	ld a, [wChannel1Unk16]
	ld b, a
	inc hl
	inc hl
	inc hl
	bit CHANNELF_2_F, c
	jr z, .asm_f8899
	ld a, [hli]
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	dec b
	jp nz, .asm_f88cd
	res CHANNELF_2_F, c
	set CHANNELF_3_F, c
	inc hl
	ld b, [hl]
	jp .asm_f88cd
.asm_f8899
	inc hl
	inc hl
	inc hl
	bit CHANNELF_3_F, c
	jr z, .asm_f88bb
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jr c, .asm_f88b2
	dec b
	jr nz, .asm_f88cd
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f88cd
.asm_f88b2
	ld de, $0000
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f88cd
.asm_f88bb
	bit CHANNELF_4_F, c
	jr z, .asm_f88c1
	jr .asm_f88cd
.asm_f88c1
	inc hl
	inc hl
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jp c, .switch_off_channel_1
.asm_f88cd
	ld a, c
	ld [wChannel1Flags], a
	ld a, b
	ld [wChannel1Unk16], a
	ld hl, wChannel1Unk09
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh a, [hff8e]
	ld e, d
	ld d, $00
	call ATimesDE
	ld a, l
	and AUD1ENV_INIT_VOLUME
	ld hl, wChannel1Unk07
	cp [hl]
	jr z, .asm_f88f4
	ldh [rAUD1ENV], a
	ld [hl], a ; AUDIO_CHANNEL_UNK07
	ld hl, wChannel1Flags
	set CHANNELF_TRIGGER_F, [hl]
.asm_f88f4
	ld hl, wChannel1Flags
	bit CHANNELF_6_F, [hl]
	res CHANNELF_6_F, [hl]
	jr z, .asm_f8918
	ld hl, wChannel1Unk0f
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc hl
	ld a, [hli] ; AUDIO_CHANNEL_UNK11
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	ld a, [wChannel1Note]
	call GetNoteFrequency
	ld hl, wChannel1Frequency
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh [rAUD1LOW], a
.asm_f8918
	ld a, [wChannel1Frequency + 1]
	and AUD1HIGH_PERIOD_HIGH
	ld hl, wChannel1Flags
	bit CHANNELF_TRIGGER_F, [hl]
	jr z, .asm_f8928
	res CHANNELF_TRIGGER_F, [hl]
	or AUD1HIGH_RESTART
.asm_f8928
	ldh [rAUD1HIGH], a

	ld a, [wChannel1Duty]
	ldh [rAUD1LEN], a

	ld a, [wChannel1Pan]
	ld hl, hChannelMixing
	bit TRACK_PAN_LEFT_F, a
	jr z, .asm_f893b
	set B_AUDTERM_1_LEFT, [hl]
.asm_f893b
	bit TRACK_PAN_RIGHT_F, a
	jr z, .asm_f8941
	set B_AUDTERM_1_RIGHT, [hl]
.asm_f8941
	ld hl, wChannel1Unk13
	ld a, [wc525 + 1]
	ld c, a
	ld a, [hl]
	sub c
	ld [hli], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	jr nc, .channel_2
	ld hl, wChannel1Flags
	ld a, [hl]
	and ~(CHANNELF_2 | CHANNELF_3 | CHANNELF_4)
	or CHANNELF_5
	ld [hl], a
	jr .channel_2

.switch_off_channel_1
	ld hl, wChannel1Flags
	res CHANNELF_ACTIVE_F, [hl]
	xor a
	ldh [rAUD1ENV], a
	ld a, AUD1HIGH_RESTART
	ldh [rAUD1HIGH], a

.channel_2
	ld a, [wChannel2Flags]
	and CHANNELF_ACTIVE
	jp z, .channel_3
	ld a, [wChannel2Unk04]
	ldh [hff8e], a
	ld a, [wChannel2Unk19]
	and a
	jr z, .asm_f89bf
	dec a
	jr nz, .asm_f89a8
	ld hl, wChannel2Unk17
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld e, a
	and a
	jr nz, .asm_f8996
	ld a, [wChannel2Flags]
	and CHANNELF_7
	jr z, .asm_f89a8
	ld de, -$19
	add hl, de
	ld a, [hli]
	ld e, a
.asm_f8996
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	ld a, l
	ld d, h
	ld hl, wChannel2Unk17
	ld [hli], a
	ld [hl], d
	ld hl, wChannel2Unk0d
	ld a, c
	ld [hli], a
	ld [hl], b
	ld a, e
.asm_f89a8
	ld [wChannel2Unk19], a
	ld hl, wChannel2Unk0d
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel2Unk0f
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hli], a
	ld hl, wChannel2Flags
	set CHANNELF_6_F, [hl]
.asm_f89bf
	ld hl, wChannel2Unk09
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel2Unk01
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wChannel2Flags]
	ld c, a
	ld a, [wChannel2Unk16]
	ld b, a
	inc hl
	inc hl
	inc hl
	bit CHANNELF_2_F, c
	jr z, .asm_f89ed
	ld a, [hli]
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	dec b
	jp nz, .asm_f8a21
	res CHANNELF_2_F, c
	set CHANNELF_3_F, c
	inc hl
	ld b, [hl]
	jp .asm_f8a21
.asm_f89ed
	inc hl
	inc hl
	inc hl
	bit CHANNELF_3_F, c
	jr z, .asm_f8a0f
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jr c, .asm_f8a06
	dec b
	jr nz, .asm_f8a21
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f8a21
.asm_f8a06
	ld de, $0000
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f8a21
.asm_f8a0f
	bit CHANNELF_4_F, c
	jr z, .asm_f8a15
	jr .asm_f8a21
.asm_f8a15
	inc hl
	inc hl
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jp c, .switch_off_channel_2
.asm_f8a21
	ld a, c
	ld [wChannel2Flags], a
	ld a, b
	ld [wChannel2Unk16], a
	ld hl, wChannel2Unk09
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh a, [hff8e]
	ld e, d
	ld d, $00
	call ATimesDE
	ld a, l
	and AUD2ENV_INIT_VOLUME
	ld hl, wChannel2Unk07
	cp [hl]
	jr z, .asm_f8a48
	ldh [rAUD2ENV], a
	ld [hl], a ; AUDIO_CHANNEL_UNK07
	ld hl, wChannel2Flags
	set CHANNELF_TRIGGER_F, [hl]
.asm_f8a48
	ld hl, wChannel2Flags
	bit CHANNELF_6_F, [hl]
	res CHANNELF_6_F, [hl]
	jr z, .asm_f8a6c
	ld hl, wChannel2Unk0f
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc hl
	ld a, [hli] ; AUDIO_CHANNEL_UNK11
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	ld a, [wChannel2Note]
	call GetNoteFrequency
	ld hl, wChannel2Frequency
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh [rAUD2LOW], a
.asm_f8a6c
	ld a, [wChannel2Frequency + 1]
	and AUD2HIGH_PERIOD_HIGH
	ld hl, wChannel2Flags
	bit CHANNELF_TRIGGER_F, [hl]
	jr z, .asm_f8a7c
	res CHANNELF_TRIGGER_F, [hl]
	or AUD2HIGH_RESTART
.asm_f8a7c
	ldh [rAUD2HIGH], a

	ld a, [wChannel2Duty]
	ldh [rAUD2LEN], a

	ld a, [wChannel2Pan]
	ld hl, hChannelMixing
	bit TRACK_PAN_LEFT_F, a
	jr z, .asm_f8a8f
	set B_AUDTERM_2_LEFT, [hl]
.asm_f8a8f
	bit TRACK_PAN_RIGHT_F, a
	jr z, .asm_f8a95
	set B_AUDTERM_2_RIGHT, [hl]
.asm_f8a95
	ld hl, wChannel2Unk13
	ld a, [wc525 + 1]
	ld c, a
	ld a, [hl]
	sub c
	ld [hli], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	jr nc, .channel_3
	ld hl, wChannel2Flags
	ld a, [hl]
	and ~(CHANNELF_2 | CHANNELF_3 | CHANNELF_4)
	or CHANNELF_5
	ld [hl], a
	jr .channel_3

.switch_off_channel_2
	ld hl, wChannel2Flags
	res CHANNELF_ACTIVE_F, [hl]
	xor a
	ldh [rAUD2ENV], a
	ld a, AUD2HIGH_RESTART
	ldh [rAUD2HIGH], a

.channel_3
	ld a, [wChannel3Flags]
	and CHANNELF_ACTIVE
	jp z, .channel_4
	ld a, [wChannel3Unk04]
	ldh [hff8e], a
	ld a, [wChannel3Unk19]
	and a
	jr z, .asm_f8b13
	dec a
	jr nz, .asm_f8afc
	ld hl, wChannel3Unk17
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld e, a
	and a
	jr nz, .asm_f8aea
	ld a, [wChannel3Flags]
	and CHANNELF_7
	jr z, .asm_f8afc
	ld de, -$19
	add hl, de
	ld a, [hli]
	ld e, a
.asm_f8aea
	ld a, [hli]
	ld b, [hl]
	ld c, a
	inc hl
	ld a, l
	ld d, h
	ld hl, wChannel3Unk17
	ld [hli], a
	ld [hl], d
	ld hl, wChannel3Unk0d
	ld a, c
	ld [hli], a
	ld [hl], b
	ld a, e
.asm_f8afc
	ld [wChannel3Unk19], a
	ld hl, wChannel3Unk0d
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel3Unk0f
	ld a, [hl]
	add e
	ld [hli], a
	ld a, [hl]
	adc d
	ld [hli], a
	ld hl, wChannel3Flags
	set CHANNELF_6_F, [hl]
.asm_f8b13
	ld hl, wChannel3Unk09
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel3Unk01
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wChannel3Flags]
	ld c, a
	ld a, [wChannel3Unk16]
	ld b, a
	inc hl
	inc hl
	inc hl
	bit CHANNELF_2_F, c
	jr z, .asm_f8b41
	ld a, [hli]
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	dec b
	jp nz, .asm_f8b75
	res CHANNELF_2_F, c
	set CHANNELF_3_F, c
	inc hl
	ld b, [hl]
	jp .asm_f8b75
.asm_f8b41
	inc hl
	inc hl
	inc hl
	bit CHANNELF_3_F, c
	jr z, .asm_f8b63
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jr c, .asm_f8b5a
	dec b
	jr nz, .asm_f8b75
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f8b75
.asm_f8b5a
	ld de, $0000
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f8b75
.asm_f8b63
	bit CHANNELF_4_F, c
	jr z, .asm_f8b69
	jr .asm_f8b75
.asm_f8b69
	inc hl
	inc hl
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jp c, .switch_off_channel_3
.asm_f8b75
	ld a, c
	ld [wChannel3Flags], a
	ld a, b
	ld [wChannel3Unk16], a
	ld hl, wChannel3Unk09
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh a, [hff8e]
	ld e, d
	ld d, $00
	call ATimesDE
	ld a, l
	bit 6, a
	jr z, .asm_f8b92
	xor $80
.asm_f8b92
	rrca
	and AUD3LEVEL_VOLUME
	ld hl, wChannel3Unk07
	cp [hl]
	jr z, .asm_f8ba3
	ldh [rAUD3LEVEL], a
	ld [hl], a ; AUDIO_CHANNEL_UNK07
	ld hl, wChannel3Flags
	set CHANNELF_TRIGGER_F, [hl]
.asm_f8ba3
	ld hl, wChannel3Flags
	bit CHANNELF_6_F, [hl]
	res CHANNELF_6_F, [hl]
	jr z, .asm_f8bc7
	ld hl, wChannel3Unk0f
	ld a, [hli]
	ld d, [hl]
	ld e, a
	inc hl
	ld a, [hli] ; AUDIO_CHANNEL_UNK11
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	ld a, [wChannel3Note]
	call GetNoteFrequency
	ld hl, wChannel3Frequency
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh [rAUD3LOW], a
.asm_f8bc7
	ld a, [wChannel3Frequency + 1]
	and AUD3HIGH_PERIOD_HIGH
	ld hl, wChannel3Flags
	bit CHANNELF_TRIGGER_F, [hl]
	jr z, .asm_f8bd5
	res CHANNELF_TRIGGER_F, [hl]
.asm_f8bd5
	ldh [rAUD3HIGH], a
	xor a
	ldh [rAUD3LEN], a

	ld a, [wChannel3Pan]
	ld hl, hChannelMixing
	bit TRACK_PAN_LEFT_F, a
	jr z, .asm_f8be6
	set B_AUDTERM_3_LEFT, [hl]
.asm_f8be6
	bit TRACK_PAN_RIGHT_F, a
	jr z, .asm_f8bec
	set B_AUDTERM_3_RIGHT, [hl]
.asm_f8bec
	ld hl, wChannel3Unk13
	ld a, [wc525 + 1]
	ld c, a
	ld a, [hl]
	sub c
	ld [hli], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	jr nc, .channel_4
	ld hl, wChannel3Flags
	ld a, [hl]
	and ~(CHANNELF_2 | CHANNELF_3 | CHANNELF_4)
	or CHANNELF_5
	ld [hl], a
	jr .channel_4

.switch_off_channel_3
	ld hl, wChannel3Flags
	res CHANNELF_ACTIVE_F, [hl]
	xor a
	ldh [rAUD3LEVEL], a

.channel_4
	ld a, [wChannel4Flags]
	and CHANNELF_ACTIVE
	jp z, .done
	ld a, [wChannel4Unk04]
	ldh [hff8e], a
	ld hl, wChannel4Unk09
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wChannel4Unk01
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wChannel4Flags]
	ld c, a
	ld a, [wChannel4Unk16]
	ld b, a
	inc hl
	inc hl
	inc hl
	bit CHANNELF_2_F, c
	jr z, .asm_f8c4a
	ld a, [hli]
	add e
	ld e, a
	ld a, [hl]
	adc d
	ld d, a
	dec b
	jp nz, .asm_f8c7e
	res CHANNELF_2_F, c
	set CHANNELF_3_F, c
	inc hl
	ld b, [hl]
	jp .asm_f8c7e
.asm_f8c4a
	inc hl
	inc hl
	inc hl
	bit CHANNELF_3_F, c
	jr z, .asm_f8c6c
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jr c, .asm_f8c63
	dec b
	jr nz, .asm_f8c7e
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f8c7e
.asm_f8c63
	ld de, $0000
	res CHANNELF_3_F, c
	set CHANNELF_4_F, c
	jr .asm_f8c7e
.asm_f8c6c
	bit CHANNELF_4_F, c
	jr z, .asm_f8c72
	jr .asm_f8c7e
.asm_f8c72
	inc hl
	inc hl
	ld a, e
	sub [hl]
	inc hl
	ld e, a
	ld a, d
	sbc [hl]
	ld d, a
	jp c, .switch_off_channel_4
.asm_f8c7e
	ld a, c
	ld [wChannel4Flags], a
	ld a, b
	ld [wChannel4Unk16], a
	ld hl, wChannel4Unk09
	ld a, e
	ld [hli], a
	ld [hl], d
	ldh a, [hff8e]
	ld e, d
	ld d, $00
	call ATimesDE
	ld a, l
	and AUD4ENV_INIT_VOLUME
	ld hl, wChannel4Unk07
	cp [hl]
	jr z, .asm_f8ca5
	ldh [rAUD4ENV], a
	ld [hl], a ; AUDIO_CHANNEL_UNK07
	ld hl, wChannel4Flags
	set CHANNELF_TRIGGER_F, [hl]
.asm_f8ca5
	ld hl, wChannel4Flags
	bit CHANNELF_TRIGGER_F, [hl]
	jr z, .asm_f8cb2
	res CHANNELF_TRIGGER_F, [hl]
	ld a, AUD4GO_RESTART
	ldh [rAUD4GO], a
.asm_f8cb2
	xor a
	ldh [rAUD4LEN], a

	ld a, [wChannel4Duty]
	ldh [rAUD4POLY], a

	ld a, [wChannel4Pan]
	ld hl, hChannelMixing
	bit TRACK_PAN_LEFT_F, a
	jr z, .asm_f8cc6
	set B_AUDTERM_4_LEFT, [hl]
.asm_f8cc6
	bit TRACK_PAN_RIGHT_F, a
	jr z, .asm_f8ccc
	set B_AUDTERM_4_RIGHT, [hl]
.asm_f8ccc
	ld hl, wChannel4Unk13
	ld a, [wc525 + 1]
	ld c, a
	ld a, [hl]
	sub c
	ld [hli], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	jr nc, .done
	ld hl, wChannel4Flags
	ld a, [hl]
	and ~(CHANNELF_2 | CHANNELF_3 | CHANNELF_4)
	or CHANNELF_5
	ld [hl], a
	jr .done

.switch_off_channel_4
	ld hl, wChannel4Flags
	res CHANNELF_ACTIVE_F, [hl]
	xor a
	ldh [rAUD4ENV], a
	ld a, AUD4GO_RESTART
	ldh [rAUD4GO], a

.done
	ret

Data_f8cf4::
	offset_table
	offset Data_f8d18
	offset Data_f924e

Data_f8cf8:
	dw $e0
	dw $d0
	dw $c0
	dw $a1
	dw $a0
	dw $90
	dw $80
	dw $70
	dw $10
	dw $60
	dw $40
	dw $30
	dw $58
	dw $33
	dw $32
	dw $20

Data_f8d18:
	offset_table
	offset Data_f8d8a
	dw $095
	dw $0b8
	dw $0c2
	dw $0e5
	dw $108
	dw $12b
	dw $14e
	dw $171
	dw $194
	dw $19e
	dw $1c1
	dw $1e4
	dw $207
	dw $22a
	dw $24d
	dw $257
	dw $27a
	dw $29d
	dw $2a7
	dw $2b1
	dw $2bb
	dw $2c5
	dw $2cf
	dw $2d9
	dw $2e3
	dw $2ed
	dw $2f7
	dw $301
	dw $324
	dw $32e
	dw $338
	dw $35b
	dw $365
	dw $388
	dw $392
	dw $3b5
	dw $3d8
	dw $3fb
	dw $405
	dw $40f
	dw $432
	dw $43c
	dw $45f
	dw $482
	dw $48c
	dw $496
	dw $4b9
	dw $4dc
	dw $4e6
	dw $4f0
	dw $4fa
	dw $504
	dw $50e
	dw $518
	dw $522
	dw $52c

Data_f8d8a:
	db $43, $80, $01
; 0xf8d8a

SECTION "Data_f924e", ROMX[$524e], BANK[$3e]

Data_f924e:
	offset_table
	offset Data_f92aa
	offset Data_f9ec1
	offset Data_faad8
	offset Data_fb020
	offset Data_fb92d
	offset Data_fba3b
	offset Data_fba55
	offset Data_fba6e
	offset Data_fba87
	offset Data_fbaa1
	offset Data_fbabb
	offset Data_fbad4
	offset Data_fbaf2
	offset Data_fbb0b
	offset Data_fbb29
	offset Data_fbb46
	offset Data_fbb63
	offset Data_fbb80
	offset Data_fbb9d
	offset Data_fbbba
	offset Data_fbbd7
	offset Data_fbbf4
	offset Data_fbc11
	offset Data_fbc2e
	offset Data_fbc4b
	offset Data_fbc68
	offset Data_fbc85
	offset Data_fbc9e
	offset Data_fbcb6
	offset Data_fbcce
	offset Data_fbcfa
	offset Data_fbd12
	offset Data_fbd2a
	offset Data_fbd55
	offset Data_fbd75
	offset Data_fbd92
	offset Data_fbdaf
	offset Data_fbdc7
	offset Data_fbddf
	offset Data_fbdf7
	offset Data_fbe10
	offset Data_fbe29
	offset Data_fbe43
	offset Data_fbe5c
	offset Data_fbe76
	offset Data_fbea5

Data_f92aa:
	offset_table
	db 7 ; num of tracks
	db $00 ; ?
	offset Audio_f92ba
	offset Audio_f9505
	offset Audio_f9795
	offset Audio_f9a5c
	offset Audio_f9b3f
	offset Audio_f9c8a
	offset Audio_f9dff

Audio_f92ba:
	audio_84
	audio_82 $78
	audio_loop
	audio_94 $00
	audio_a8
	note C#1, $0f, 16
	note C#1, $0a, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	audio_af
	note E_1, $0f, 32
	audio_a8
	note C#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0a, 16
	note G_1, $0f, 16
	note G_1, $0a, 16
	note G#1, $0f, 16
	note G#1, $0a, 16
	note C#1, $0f, 16
	audio_a4
	note B_1, $0f, 160
	audio_aa
	note A#1, $0f, 64
	note A_1, $0f, 64
	audio_a8
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note C#1, $0f, 16
	note G#1, $0f, 32
	note G_1, $0f, 32
	note E_1, $0f, 32
	note F#1, $0f, 32
	note E_1, $0f, 16
	note B_0, $0f, 32
	note B_0, $0f, 32
	note D_1, $0f, 32
	note B_0, $0f, 16
	note F_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note C#1, $0f, 16
	note G#1, $0f, 32
	note G_1, $0f, 32
	note E_1, $0f, 32
	note F#1, $0f, 32
	note E_1, $0f, 16
	note B_0, $0f, 32
	note B_0, $0f, 32
	note D_1, $0f, 32
	note B_0, $0f, 16
	note F_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	audio_a9
	note C#2, $0f, 96
	note C_2, $0f, 96
	note B_1, $0f, 96
	note A#1, $0f, 96
	audio_aa
	note A_1, $0f, 64
	note G#1, $0f, 64
	audio_a8
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	audio_a9
	note C#2, $0f, 96
	note C_2, $0f, 96
	note B_1, $0f, 96
	note A#1, $0f, 96
	audio_aa
	note A_1, $0f, 64
	note G#1, $0f, 64
	audio_a8
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $09, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note F_1, $0f, 16
	note F_1, $09, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $09, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note F_1, $0f, 16
	note F_1, $09, 16
	audio_end_loop
	audio_end
	db $80

Audio_f9505:
	audio_84
	audio_loop
	audio_94 $02
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $0a, 16
	note C#3, $0f, 16
	note F#3, $0f, 16
	note F#3, $0a, 16
	note G_3, $0f, 16
	note G_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note A#3, $0f, 16
	note A#3, $0f, 16
	note A#3, $0f, 16
	note A#3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	audio_94 $05
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $0a, 32
	note A_2, $07, 32
	audio_a5
	note B_2, $0f, 144
	audio_a8
	note B_2, $0b, 16
	note D_3, $0f, 32
	note D_3, $09, 32
	note D_3, $06, 32
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $0a, 32
	note A_2, $07, 32
	audio_a5
	note B_2, $0f, 144
	audio_a8
	note B_2, $0b, 16
	note D_3, $0f, 32
	note D_3, $09, 32
	note D_3, $06, 32
	audio_94 $02
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_94 $01
	audio_a9
	note G#1, $0f, 96
	note G_1, $0f, 96
	note F#1, $0f, 96
	note F_1, $0f, 96
	audio_aa
	note E_1, $0f, 64
	note D#1, $0f, 64
	audio_94 $02
	audio_a8
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0b, 8
	note G_3, $0d, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_94 $01
	audio_a9
	note G#1, $0f, 96
	note G_1, $0f, 96
	note F#1, $0f, 96
	note F_1, $0f, 96
	audio_aa
	note E_1, $0f, 64
	note D#1, $0f, 64
	audio_94 $02
	audio_a8
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0b, 8
	note G_3, $0d, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_94 $04
	audio_a4
	note F#3, $0f, 160
	audio_a8
	note C#3, $0f, 16
	note C#3, $09, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	audio_a2
	note C#3, $0f, 192
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	audio_a4
	note F#4, $0f, 160
	audio_a8
	note C#4, $0f, 16
	note C#4, $09, 16
	note E_4, $0f, 16
	note E_4, $09, 16
	audio_a2
	note C#4, $0f, 192
	audio_a8
	note C#4, $0f, 16
	note C#4, $0a, 16
	note E_4, $0f, 16
	note E_4, $09, 16
	note C#4, $0f, 16
	note C#4, $09, 16
	audio_end_loop
	audio_end
	db $80

Audio_f9795:
	audio_84
	audio_loop
	audio_94 $03
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $0a, 16
	note C#3, $0f, 16
	note F#3, $0f, 16
	note F#3, $0a, 16
	note G_3, $0f, 16
	note G_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	audio_a4
	note B_3, $0f, 160
	audio_aa
	note A#3, $0f, 64
	note A_3, $0f, 64
	audio_94 $06
	audio_a5
	note C#2, $0f, 144
	audio_a8
	note C#2, $0b, 16
	note E_2, $0f, 32
	note E_2, $0a, 32
	note E_2, $07, 32
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $09, 32
	note A_2, $06, 32
	audio_a5
	note C#2, $0f, 144
	audio_a8
	note C#2, $0b, 16
	note E_2, $0f, 32
	note E_2, $0a, 32
	note E_2, $07, 32
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $09, 32
	note A_2, $06, 32
	audio_94 $03
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_ab
	note C#3, $0f, 48
	audio_a8
	note B_2, $0f, 16
	note C#3, $0f, 16
	note B_2, $0f, 16
	audio_ab
	note G#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G#3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note G_3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note F#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note F#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 32
	note B_2, $0f, 32
	note C#3, $0f, 32
	note E_3, $0f, 16
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0e, 8
	note G_3, $0f, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_ab
	note C#3, $0f, 48
	audio_a8
	note B_2, $0f, 16
	note C#3, $0f, 16
	note B_2, $0f, 16
	audio_ab
	note G#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G#3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note G_3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note F#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note F#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 32
	note B_2, $0f, 32
	note C#3, $0f, 32
	note E_3, $0f, 16
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0e, 8
	note G_3, $0f, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_a4
	note C#4, $0f, 160
	audio_a8
	note G#3, $0f, 16
	note G#3, $0a, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	audio_a2
	note G#3, $0f, 192
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $0a, 16
	audio_a4
	note C#4, $0f, 160
	audio_a8
	note G#3, $0f, 16
	note G#3, $0a, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	audio_a2
	note G#3, $0f, 192
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $0a, 16
	audio_end_loop
	audio_end
	db $80

Audio_f9a5c:
	audio_84
	audio_loop
	audio_94 $12
	audio_a8
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	audio_end_loop
	audio_end
	db $80

Audio_f9b3f:
	audio_84
	audio_loop
	audio_94 $13, 16
	audio_a8
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 192
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 128
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 128
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 144
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 32
	audio_end_loop
	audio_end
	db $80

Audio_f9c8a:
	audio_84
	audio_loop
	audio_94 $14, 64
	audio_a8
	note D_4, $0f, 128
	note D_4, $0f, 128
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 128
	note D_4, $0f, 128
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 128
	note D_4, $0f, 128
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 16
	audio_end_loop
	audio_end
	db $80

Audio_f9dff:
	audio_84
	audio_loop
	audio_94 $15, 32
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 192
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 192
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 192
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 192
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 192
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 160
	audio_end_loop
	audio_end
	db $80

Data_f9ec1:
	offset_table
	db 7 ; num of tracks
	db $00 ; ?
	offset Audio_f9ed1
	offset Audio_fa11c
	offset Audio_fa3ac
	offset Audio_fa673
	offset Audio_fa756
	offset Audio_fa8a1
	offset Audio_faa16

Audio_f9ed1:
	audio_84
	audio_82 $78
	audio_loop
	audio_94 $07
	audio_a8
	note C#1, $0f, 16
	note C#1, $0a, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	audio_af
	note E_1, $0f, 32
	audio_a8
	note C#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0a, 16
	note G_1, $0f, 16
	note G_1, $0a, 16
	note G#1, $0f, 16
	note G#1, $0a, 16
	note C#1, $0f, 16
	audio_a4
	note B_1, $0f, 160
	audio_aa
	note A#1, $0f, 64
	note A_1, $0f, 64
	audio_a8
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note C#1, $0f, 16
	note G#1, $0f, 32
	note G_1, $0f, 32
	note E_1, $0f, 32
	note F#1, $0f, 32
	note E_1, $0f, 16
	note B_0, $0f, 32
	note B_0, $0f, 32
	note D_1, $0f, 32
	note B_0, $0f, 16
	note F_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note C#1, $0f, 16
	note G#1, $0f, 32
	note G_1, $0f, 32
	note E_1, $0f, 32
	note F#1, $0f, 32
	note E_1, $0f, 16
	note B_0, $0f, 32
	note B_0, $0f, 32
	note D_1, $0f, 32
	note B_0, $0f, 16
	note F_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 32
	note E_1, $0f, 32
	note D_1, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	audio_a9
	note C#2, $0f, 96
	note C_2, $0f, 96
	note B_1, $0f, 96
	note A#1, $0f, 96
	audio_aa
	note A_1, $0f, 64
	note G#1, $0f, 64
	audio_a8
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	audio_a9
	note C#2, $0f, 96
	note C_2, $0f, 96
	note B_1, $0f, 96
	note A#1, $0f, 96
	audio_aa
	note A_1, $0f, 64
	note G#1, $0f, 64
	audio_a8
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note C#1, $0f, 32
	note C#1, $0f, 32
	note E_1, $0f, 32
	note E_1, $0f, 16
	note F#1, $0f, 32
	note G_1, $0f, 32
	note G#1, $0f, 32
	note B_1, $0f, 32
	note C#2, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $09, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note F_1, $0f, 16
	note F_1, $09, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $09, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	note E_1, $0f, 16
	note E_1, $09, 16
	note F_1, $0f, 16
	note F_1, $09, 16
	audio_end_loop
	audio_end
	db $80

Audio_fa11c:
	audio_84
	audio_loop
	audio_94 $09
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $0a, 16
	note C#3, $0f, 16
	note F#3, $0f, 16
	note F#3, $0a, 16
	note G_3, $0f, 16
	note G_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note B_3, $0f, 16
	note A#3, $0f, 16
	note A#3, $0f, 16
	note A#3, $0f, 16
	note A#3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	audio_94 $0c
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $0a, 32
	note A_2, $07, 32
	audio_a5
	note B_2, $0f, 144
	audio_a8
	note B_2, $0b, 16
	note D_3, $0f, 32
	note D_3, $09, 32
	note D_3, $06, 32
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $0a, 32
	note A_2, $07, 32
	audio_a5
	note B_2, $0f, 144
	audio_a8
	note B_2, $0b, 16
	note D_3, $0f, 32
	note D_3, $09, 32
	note D_3, $06, 32
	audio_94 $09
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_94 $08
	audio_a9
	note G#1, $0f, 96
	note G_1, $0f, 96
	note F#1, $0f, 96
	note F_1, $0f, 96
	audio_aa
	note E_1, $0f, 64
	note D#1, $0f, 64
	audio_94 $09
	audio_a8
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0b, 8
	note G_3, $0d, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_94 $08
	audio_a9
	note G#1, $0f, 96
	note G_1, $0f, 96
	note F#1, $0f, 96
	note F_1, $0f, 96
	audio_aa
	note E_1, $0f, 64
	note D#1, $0f, 64
	audio_94 $09
	audio_a8
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0b, 8
	note G_3, $0d, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_94 $0b
	audio_a4
	note F#3, $0f, 160
	audio_a8
	note C#3, $0f, 16
	note C#3, $09, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	audio_a2
	note C#3, $0f, 192
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	audio_a4
	note F#4, $0f, 160
	audio_a8
	note C#4, $0f, 16
	note C#4, $09, 16
	note E_4, $0f, 16
	note E_4, $09, 16
	audio_a2
	note C#4, $0f, 192
	audio_a8
	note C#4, $0f, 16
	note C#4, $0a, 16
	note E_4, $0f, 16
	note E_4, $09, 16
	note C#4, $0f, 16
	note C#4, $09, 16
	audio_end_loop
	audio_end
	db $80

Audio_fa3ac:
	audio_84
	audio_loop
	audio_94 $0a
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $0a, 16
	note C#3, $0f, 16
	note F#3, $0f, 16
	note F#3, $0a, 16
	note G_3, $0f, 16
	note G_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	audio_a4
	note B_3, $0f, 160
	audio_aa
	note A#3, $0f, 64
	note A_3, $0f, 64
	audio_94 $0d
	audio_a5
	note C#2, $0f, 144
	audio_a8
	note C#2, $0b, 16
	note E_2, $0f, 32
	note E_2, $0a, 32
	note E_2, $07, 32
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $09, 32
	note A_2, $06, 32
	audio_a5
	note C#2, $0f, 144
	audio_a8
	note C#2, $0b, 16
	note E_2, $0f, 32
	note E_2, $0a, 32
	note E_2, $07, 32
	audio_a5
	note F#2, $0f, 144
	audio_a8
	note F#2, $0b, 16
	note A_2, $0f, 32
	note A_2, $09, 32
	note A_2, $06, 32
	audio_94 $0a
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_ab
	note C#3, $0f, 48
	audio_a8
	note B_2, $0f, 16
	note C#3, $0f, 16
	note B_2, $0f, 16
	audio_ab
	note G#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G#3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note G_3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note F#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note F#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 32
	note B_2, $0f, 32
	note C#3, $0f, 32
	note E_3, $0f, 16
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0e, 8
	note G_3, $0f, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_ab
	note C#3, $0f, 48
	audio_a8
	note B_2, $0f, 16
	note C#3, $0f, 16
	note B_2, $0f, 16
	audio_ab
	note G#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G#3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note G_3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	audio_ab
	note F#3, $0f, 48
	audio_a8
	note C#3, $0f, 16
	note F#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 32
	note B_2, $0f, 32
	note C#3, $0f, 32
	note E_3, $0f, 16
	note C#3, $0e, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note G_3, $0f, 16
	note G_3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note C#3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note C#3, $0f, 16
	audio_90 $08
	note F#3, $0e, 8
	note G_3, $0f, 8
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note C#3, $09, 16
	note G_3, $0f, 16
	note C#3, $0f, 16
	note E_3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	audio_a4
	note C#4, $0f, 160
	audio_a8
	note G#3, $0f, 16
	note G#3, $0a, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	audio_a2
	note G#3, $0f, 192
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $0a, 16
	audio_a4
	note C#4, $0f, 160
	audio_a8
	note G#3, $0f, 16
	note G#3, $0a, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	audio_a2
	note G#3, $0f, 192
	audio_a8
	note G#3, $0f, 16
	note G#3, $09, 16
	note B_3, $0f, 16
	note B_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $0a, 16
	audio_end_loop
	audio_end
	db $80

Audio_fa673:
	audio_84
	audio_loop
	audio_94 $16
	audio_a8
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 48
	note C_4, $0f, 80
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 128
	note C_4, $0f, 96
	audio_end_loop
	audio_end
	db $80

Audio_fa756:
	audio_84
	audio_loop
	audio_94 $17, 16
	audio_a8
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 192
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 128
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 64
	note C#4, $0f, 128
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 144
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 16
	note C#4, $0f, 48
	note C#4, $0f, 32
	note C#4, $0f, 32
	note C#4, $0f, 48
	note C#4, $0f, 96
	note C#4, $0f, 32
	audio_end_loop
	audio_end
	db $80

Audio_fa8a1:
	audio_84
	audio_loop
	audio_94 $18, 64
	audio_a8
	note D_4, $0f, 128
	note D_4, $0f, 128
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 128
	note D_4, $0f, 128
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 128
	note D_4, $0f, 128
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 32
	audio_90 $08
	note D_4, $0b, 8
	note D_4, $0b, 8
	audio_a8
	note D_4, $0f, 16
	note D_4, $0f, 32
	note D_4, $0f, 16
	audio_end_loop
	audio_end
	db $80

Audio_faa16:
	audio_84
	audio_loop
	audio_94 $19, 32
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 192
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 192
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 192
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 192
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 64
	audio_af
	note D#4, $0f, 64
	audio_a8
	note D#4, $0f, 192
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 256
	note D#4, $0f, 144
	note D#4, $0f, 112
	note D#4, $0f, 160
	audio_end_loop
	audio_end
	db $80

Data_faad8:
	offset_table
	db 7 ; num of tracks
	db $00 ; ?
	offset Audio_faae8
	offset Audio_fac2c
	offset Audio_fad8a
	offset Audio_fae9b
	offset Audio_faefe
	offset Audio_faf9d
	offset Audio_fb000

Audio_faae8:
	audio_84
	audio_82 $af
	audio_loop
	audio_94 $00
	audio_90 $18
	note A_0, $0f, 64
	audio_a8
	note A_0, $0f, 32
	audio_90 $18
	note A_0, $0f, 32
	note C_1, $0f, 32
	note A_0, $0f, 64
	audio_af
	note A_0, $0f, 64
	audio_a8
	note A_0, $0f, 32
	note A_0, $0f, 32
	note A_0, $0f, 32
	note C_1, $0f, 32
	audio_90 $18
	note A_0, $0f, 32
	audio_a8
	note D_1, $0f, 32
	note A_0, $0f, 32
	audio_90 $18
	note A_0, $0f, 64
	audio_a8
	note A_0, $0f, 32
	audio_90 $18
	note A_0, $0f, 32
	note C_1, $0f, 32
	note A_0, $0f, 64
	audio_af
	note A_0, $0f, 64
	audio_a8
	note A_0, $0f, 32
	note A_0, $0f, 32
	note A_0, $0f, 32
	note C_1, $0f, 32
	audio_90 $18
	note A_0, $0f, 32
	audio_a8
	note D_1, $0f, 32
	note A_0, $0f, 32
	audio_af
	note B_0, $0f, 64
	note B_0, $0f, 32
	note B_0, $0f, 32
	note A_0, $0f, 32
	note B_0, $0f, 64
	note B_0, $0f, 64
	note B_0, $0f, 32
	note A_0, $0f, 32
	note A#0, $0f, 32
	note B_0, $0f, 32
	note D_1, $0f, 32
	audio_a8
	note E_1, $0f, 16
	note F_1, $0f, 16
	note E_1, $0f, 16
	note D_1, $0f, 16
	audio_af
	note B_0, $0f, 64
	note B_0, $0f, 32
	note B_0, $0f, 32
	note A_0, $0f, 32
	note B_0, $0f, 64
	note B_0, $0f, 64
	note B_0, $0f, 32
	note A_0, $0f, 32
	note A#0, $0f, 32
	note B_0, $0f, 32
	note D_1, $0f, 32
	audio_a8
	note E_1, $0f, 16
	note F_1, $0f, 16
	note E_1, $0f, 16
	note D_1, $0f, 16
	audio_af
	note D_1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note C_1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note D_1, $09, 32
	note D_1, $0f, 32
	note D_1, $09, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note D#1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note D_1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note C_1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note D_1, $09, 32
	note D_1, $0f, 32
	note D_1, $09, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note D#1, $0f, 32
	note C_1, $0f, 32
	note D_1, $0f, 32
	note D_1, $0f, 32
	note C_1, $0f, 32
	audio_end_loop
	audio_end
	db $80

Audio_fac2c:
	audio_84
	audio_loop
	audio_94 $02
	audio_90 $08
	note A_3, $0f, 24
	note A_3, $0a, 40
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note C_4, $0f, 24
	note C_4, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 40
	note A_3, $0f, 24
	note A_3, $0a, 40
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note C_4, $0f, 24
	note C_4, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note D_4, $0f, 24
	note D_4, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 40
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note C_4, $0f, 24
	note C_4, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 40
	note A_3, $0f, 24
	note A_3, $0a, 40
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	note C_4, $0f, 24
	note C_4, $0a, 8
	note A_3, $0f, 24
	note A_3, $0a, 8
	audio_94 $04
	audio_a8
	note F#3, $0e, 16
	note G#3, $0e, 16
	note A_3, $0e, 16
	note B_3, $0f, 16
	note F#3, $0f, 32
	note F#3, $0a, 32
	audio_90 $08
	note E_3, $0f, 8
	audio_af
	note F_3, $0f, 56
	note E_3, $0f, 32
	note D_3, $0f, 32
	note B_2, $0f, 32
	note D_3, $0f, 64
	audio_aa
	note E_3, $0f, 64
	audio_af
	note A_2, $0f, 32
	note A_2, $0f, 32
	note A_2, $0f, 32
	note A#2, $0f, 32
	note A#2, $0f, 32
	audio_a8
	note E_3, $0d, 32
	note F#3, $0e, 32
	audio_90 $08
	note E_3, $0f, 8
	audio_af
	note F_3, $0f, 56
	note E_3, $0f, 32
	note D_3, $0f, 32
	note B_2, $0f, 32
	note D_3, $0f, 32
	note D_3, $0a, 32
	note E_3, $0f, 32
	note B_2, $0f, 32
	note B_2, $0a, 32
	audio_a8
	note F#3, $0b, 16
	note G#3, $0b, 16
	note A_3, $0b, 16
	note B_3, $0b, 16
	note C#4, $0c, 16
	note D_4, $0c, 16
	note E_4, $0c, 16
	note F#4, $0c, 16
	audio_a2
	note D_4, $0e, 192
	audio_af
	note A#3, $0e, 32
	audio_a0
	note C#4, $0e, 224
	audio_af
	note A_3, $0e, 32
	audio_a0
	note C_4, $0e, 224
	audio_af
	note G#3, $0e, 32
	audio_a4
	note B_3, $0e, 160
	audio_af
	note F_3, $0f, 32
	note A_3, $0f, 32
	note G_3, $0e, 32
	note A#3, $0e, 32
	audio_end_loop
	audio_end
	db $80

Audio_fad8a:
	audio_84
	audio_loop
	audio_94 $03
	audio_af
	note A_2, $0f, 32
	note A_2, $0a, 32
	note A_2, $0f, 32
	note C_3, $0f, 32
	note C_3, $0a, 32
	note C_3, $0f, 32
	note D_3, $0f, 32
	note D_3, $0a, 32
	note D_3, $0f, 32
	note E_3, $0f, 32
	note E_3, $0b, 32
	note E_3, $0f, 32
	note G_3, $0f, 32
	note G_3, $0f, 32
	note A_3, $0f, 32
	note A_3, $0f, 32
	note A_2, $0f, 32
	note A_2, $0a, 32
	note A_2, $0f, 32
	note C_3, $0f, 32
	note C_3, $0a, 32
	note C_3, $0f, 32
	note D_3, $0f, 32
	note D_3, $0a, 32
	note D_3, $0f, 32
	note E_3, $0f, 32
	note E_3, $0b, 32
	note E_3, $0f, 32
	note G_3, $0f, 32
	note G_3, $0f, 32
	audio_a8
	note B_3, $0f, 16
	note C#4, $0f, 16
	note D_4, $0f, 16
	note E_4, $0f, 16
	note B_3, $0f, 32
	note B_3, $0b, 32
	audio_af
	note B_3, $0f, 32
	note B_3, $0a, 32
	note B_3, $0f, 32
	note A_3, $0f, 32
	note F#3, $0f, 32
	note A_3, $0f, 32
	note A_3, $0a, 32
	audio_ac
	note B_3, $0f, 224
	audio_a8
	note A_3, $0d, 32
	note B_3, $0d, 32
	audio_af
	note B_3, $0f, 32
	note B_3, $0a, 32
	note B_3, $0f, 32
	note A_3, $0f, 32
	note F#3, $0f, 32
	note A_3, $0f, 32
	note A_3, $0a, 32
	note B_3, $0f, 32
	note F#3, $0f, 32
	note F#3, $0b, 32
	audio_a8
	note B_2, $0d, 16
	note C#3, $0d, 16
	note D_3, $0e, 16
	note E_3, $0e, 16
	note F#3, $0e, 16
	note G_3, $0d, 16
	note A_3, $0d, 16
	note B_3, $0e, 16
	audio_a2
	note F#3, $0e, 192
	audio_af
	note D_3, $0e, 32
	audio_a0
	note F_3, $0e, 224
	audio_af
	note C#3, $0e, 32
	audio_a0
	note E_3, $0e, 224
	audio_af
	note C_3, $0e, 32
	audio_a4
	note D#3, $0e, 160
	audio_af
	note A_2, $0f, 32
	note C_3, $0f, 32
	note B_2, $0e, 32
	note D_3, $0e, 32
	audio_end_loop
	audio_end
	db $80

Audio_fae9b:
	audio_84
	audio_loop
	audio_94 $12
	audio_a8
	note C_4, $0f, 96
	note C_4, $0f, 192
	note C_4, $0f, 32
	note C_4, $0f, 192
	note C_4, $0f, 96
	note C_4, $0f, 192
	note C_4, $0f, 32
	note C_4, $0f, 192
	note C_4, $0f, 96
	note C_4, $0f, 192
	note C_4, $0f, 32
	note C_4, $0f, 192
	note C_4, $0f, 96
	note C_4, $0f, 192
	note C_4, $0f, 32
	note C_4, $0f, 192
	note C_4, $0f, 96
	note C_4, $0f, 192
	note C_4, $0f, 32
	note C_4, $0f, 192
	note C_4, $0f, 96
	note C_4, $0f, 192
	note C_4, $0f, 32
	note C_4, $0f, 192
	audio_end_loop
	audio_end
	db $80

Audio_faefe:
	audio_84
	audio_loop
	audio_94 $13, 32
	audio_a8
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 96
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 96
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 96
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 96
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 96
	note C#4, $0f, 64
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 96
	note C#4, $0f, 32
	note C#4, $0f, 64
	note C#4, $0f, 96
	note C#4, $0f, 64
	note C#4, $0f, 48
	note C#4, $0f, 48
	audio_end_loop
	audio_end
	db $80

Audio_faf9d:
	audio_84
	audio_loop
	audio_94 $14, 128
	audio_a8
	note D_4, $0f, 96
	note D_4, $0f, 160
	note D_4, $0f, 256
	note D_4, $0f, 96
	note D_4, $0f, 160
	note D_4, $0f, 256
	note D_4, $0f, 96
	note D_4, $0f, 160
	note D_4, $0f, 256
	note D_4, $0f, 96
	note D_4, $0f, 160
	note D_4, $0f, 96
	note D_4, $0f, 16
	note D_4, $0f, 144
	note D_4, $0f, 96
	note D_4, $0f, 160
	note D_4, $0f, 256
	note D_4, $0f, 96
	note D_4, $0f, 160
	note D_4, $0c, 16
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0c, 16
	note D_4, $0f, 16
	audio_end_loop
	audio_end
	db $80

Audio_fb000:
	audio_84
	audio_loop
	audio_94 $15, 480
	audio_af
	note D#4, $0f, 512
	note D#4, $0f, 512
	note D#4, $0f, 1024
	note D#4, $0f, 544
	audio_end_loop
	audio_end
	db $80

Data_fb020:
	offset_table
	db 5 ; num of tracks
	db $00 ; ?
	offset Audio_fb02c
	offset Audio_fb389
	offset Audio_fb6d1
	offset Audio_fb79f
	offset Audio_fb867

Audio_fb02c:
	audio_84
	audio_82 $69
	audio_loop
	audio_94 $00
	audio_90 $08
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F_1, $0f, 48
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 32
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F#1, $0f, 16
	note F_1, $0f, 32
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note G#1, $0f, 16
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F_1, $0f, 48
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 32
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F#1, $0f, 16
	note F_1, $0f, 32
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note G#1, $0f, 16
	note F_1, $0f, 16
	note F#0, $0f, 16
	note F#0, $0f, 16
	audio_a8
	note G#0, $0f, 32
	note B_0, $0f, 32
	note C#1, $0f, 16
	audio_90 $18
	note B_0, $0f, 32
	audio_90 $08
	note B_0, $0f, 16
	audio_a8
	note G#0, $0f, 32
	note F#0, $0f, 16
	audio_af
	note G#0, $0f, 32
	audio_a8
	note G#0, $0f, 16
	note F#1, $0f, 16
	note G#1, $0f, 16
	note G#0, $0f, 16
	note G#0, $0f, 16
	note D_1, $0f, 32
	note F#1, $0f, 16
	note G#0, $0f, 16
	note G#1, $0f, 16
	note G#0, $0f, 16
	note B_1, $0f, 32
	note F#1, $0f, 16
	note G#0, $0f, 16
	note B_1, $0f, 16
	note C#2, $0f, 16
	audio_90 $08
	note F#0, $0f, 16
	note F#0, $0f, 16
	audio_a8
	note G#0, $0f, 32
	note B_0, $0f, 32
	note C#1, $0f, 16
	audio_90 $18
	note B_0, $0f, 32
	audio_90 $08
	note B_0, $0f, 16
	audio_a8
	note G#0, $0f, 32
	note F#0, $0f, 16
	audio_af
	note G#0, $0f, 32
	audio_a8
	note G#0, $0f, 16
	note F#0, $0f, 16
	audio_90 $08
	note G#0, $0f, 16
	note G#0, $0f, 16
	note G#0, $0f, 16
	audio_a8
	note B_0, $0f, 16
	audio_90 $08
	note B_0, $0f, 16
	audio_a8
	note G#0, $0f, 16
	note A#0, $0f, 16
	audio_90 $08
	note A#0, $0f, 16
	note A#0, $0f, 16
	audio_a8
	note D#1, $0f, 16
	audio_90 $08
	note D#1, $0f, 16
	audio_a8
	note F#1, $0f, 16
	audio_90 $08
	note G#1, $0f, 16
	note G#1, $0f, 16
	note G#1, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 32
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 32
	note F_0, $0f, 16
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F#1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note A#1, $0f, 16
	note G_1, $0f, 16
	note G#0, $0f, 16
	note G#1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note G#1, $0f, 16
	note A#1, $0f, 16
	note C_2, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_1, $0f, 16
	note D#1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 32
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 32
	note F_0, $0f, 16
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_0, $0f, 16
	note D#1, $0f, 16
	note F_1, $0f, 16
	note F_0, $0f, 16
	note F_0, $0f, 16
	note F#1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note A#1, $0f, 16
	note G_1, $0f, 16
	note G#0, $0f, 16
	note G#1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note G#1, $0f, 16
	note A#1, $0f, 16
	note C_2, $0f, 16
	audio_a8
	note C_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	note D_1, $0f, 16
	note D_1, $0f, 16
	audio_a8
	note F_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	audio_a8
	note D_1, $09, 16
	audio_90 $08
	note D_1, $0f, 16
	audio_a8
	note C_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	note D_1, $0f, 16
	note D_1, $0f, 16
	audio_a8
	note G#1, $0f, 16
	audio_90 $08
	note G_1, $0f, 16
	audio_a8
	note G_1, $09, 16
	audio_90 $08
	note C_1, $0f, 16
	audio_a8
	note C_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	note D_1, $0f, 16
	note D_1, $0f, 16
	audio_a8
	note F_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	audio_a8
	note D_1, $09, 16
	audio_90 $08
	note F_1, $0f, 16
	audio_a8
	note G_1, $0f, 16
	note G#1, $0f, 16
	note G_1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note F_1, $0f, 16
	note D_1, $0f, 16
	note F_1, $0f, 16
	note C_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	note D_1, $0f, 16
	note D_1, $0f, 16
	audio_a8
	note F_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	audio_a8
	note D_1, $09, 16
	audio_90 $08
	note D_1, $0f, 16
	audio_a8
	note C_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	note D_1, $0f, 16
	note D_1, $0f, 16
	audio_a8
	note G#1, $0f, 16
	audio_90 $08
	note G_1, $0f, 16
	audio_a8
	note G_1, $09, 16
	audio_90 $08
	note C_1, $0f, 16
	audio_a8
	note C_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	note D_1, $0f, 16
	note D_1, $0f, 16
	audio_a8
	note F_1, $0f, 16
	audio_90 $08
	note D_1, $0f, 16
	audio_a8
	note D_1, $09, 16
	audio_90 $08
	note F_1, $0f, 16
	audio_a8
	note G_1, $0f, 16
	note G#1, $0f, 16
	note G_1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note F_1, $0f, 16
	note D_1, $0f, 16
	note F_1, $0f, 16
	audio_end_loop
	audio_end
	db $80

Audio_fb389:
	audio_84
	audio_loop
	audio_94 $11
	audio_ae
	note F_3, $0f, 48
	audio_ad
	note G#3, $0f, 48
	audio_a3
	note C_4, $0f, 160
	audio_94 $02
	audio_90 $08
	note D#3, $0f, 8
	note D#3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F#3, $0f, 8
	note F#3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 24
	note F_3, $0f, 8
	note F_3, $0a, 8
	note D#3, $0f, 8
	note D#3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note C#4, $0f, 8
	note C#4, $0a, 8
	note C_4, $0f, 8
	note C_4, $0a, 24
	note C_4, $0f, 8
	note C_4, $0a, 8
	audio_94 $10, 32
	audio_90 $0a
	note D#4, $0f, 32
	note D#4, $09, 16
	audio_90 $0b
	note D#4, $0f, 32
	note D#4, $0d, 16
	audio_90 $09
	note D#4, $0f, 32
	note D#4, $09, 32
	note D#4, $06, 32
	note D#4, $05, 32
	audio_94 $02
	audio_90 $08
	note D#3, $0f, 8
	note D#3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F#3, $0f, 8
	note F#3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 24
	note F_3, $0f, 8
	note F_3, $0a, 8
	note D#3, $0f, 8
	note D#3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note F_3, $0f, 8
	note F_3, $0a, 8
	note C#4, $0f, 8
	note C#4, $0a, 8
	note C_4, $0f, 8
	note C_4, $0a, 24
	note C_4, $0f, 8
	note C_4, $0a, 8
	audio_94 $11
	audio_ab
	note G#3, $0f, 48
	note B_3, $0f, 48
	audio_aa
	note D#4, $0f, 64
	audio_a9
	note D_4, $0f, 96
	audio_94 $02
	audio_a8
	note F#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note G#3, $0f, 16
	note F#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note C#4, $0f, 16
	note G#3, $0f, 16
	note G#3, $0a, 16
	note G#3, $0f, 16
	audio_94 $10, 32
	audio_90 $0a
	note D_4, $0f, 32
	note D_4, $09, 16
	audio_90 $0b
	note D_4, $0f, 32
	note D_4, $0d, 16
	audio_90 $09
	note D_4, $0f, 32
	note D_4, $09, 32
	note D_4, $06, 32
	note D_4, $05, 32
	audio_94 $02
	audio_a8
	note F#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note B_3, $0f, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note G#3, $0f, 16
	note F#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note G#3, $0f, 16
	note C#4, $0f, 16
	note G#3, $0f, 16
	note G#3, $0a, 16
	note G#3, $0f, 16
	audio_94 $10
	note C_4, $0f, 32
	note C_4, $0a, 16
	note A#3, $0f, 32
	note A#3, $0a, 16
	note F_3, $0f, 32
	note F_3, $0b, 32
	note G_3, $0f, 16
	note A#3, $0f, 16
	note C_4, $0f, 16
	note A#3, $0f, 16
	note C_4, $0f, 16
	note D#4, $0f, 16
	audio_94 $02
	audio_90 $08
	note D#3, $0f, 8
	note D#3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F#3, $0f, 8
	note F#3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 24
	note F_3, $0f, 8
	note F_3, $09, 8
	note D#3, $0f, 8
	note D#3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note C#4, $0f, 8
	note C#4, $09, 8
	note C_4, $0f, 8
	note C_4, $09, 24
	note C_4, $0f, 8
	note C_4, $09, 8
	audio_94 $10
	audio_a8
	note C_4, $0f, 32
	note C_4, $0a, 16
	note A#3, $0f, 32
	note A#3, $0a, 16
	note F_3, $0f, 32
	note F_3, $0b, 32
	note C_4, $0f, 16
	note D#4, $0f, 16
	note F_4, $0f, 16
	note D#4, $0f, 16
	note F_4, $0f, 16
	note G#4, $0f, 16
	audio_94 $02
	audio_90 $08
	note D#3, $0f, 8
	note D#3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F#3, $0f, 8
	note F#3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 24
	note F_3, $0f, 8
	note F_3, $09, 8
	note D#3, $0f, 8
	note D#3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note F_3, $0f, 8
	note F_3, $09, 8
	note C#4, $0f, 8
	note C#4, $09, 8
	note C_4, $0f, 8
	note C_4, $09, 24
	note C_4, $0f, 8
	note C_4, $09, 8
	audio_94 $11
	audio_ab
	note D_3, $0f, 48
	note F_3, $0f, 48
	audio_90 $08
	note G_3, $0f, 8
	audio_90 $18
	note G#3, $0f, 24
	audio_a6
	note G_3, $0f, 128
	audio_94 $02
	audio_a8
	note G_3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	note A_3, $0f, 16
	note D_4, $0f, 16
	note A_3, $0f, 32
	note A_3, $0f, 16
	audio_94 $10
	note D_3, $0f, 16
	note D#3, $0f, 16
	note D_3, $0f, 16
	note C_3, $0f, 16
	note D_3, $0f, 16
	note C_3, $0f, 16
	note A_2, $0f, 16
	audio_90 $08
	note G_3, $0f, 8
	note G#3, $0f, 8
	audio_94 $11
	audio_ab
	note A_3, $0f, 48
	note C_4, $0f, 48
	audio_90 $08
	note D_4, $0f, 8
	audio_90 $18
	note D#4, $0f, 24
	audio_a7
	note D_4, $0f, 112
	audio_a8
	note D_4, $0a, 16
	audio_94 $02
	note C_3, $0f, 16
	note D_3, $0f, 16
	note D_3, $0f, 16
	note D_3, $0f, 16
	note F_3, $0f, 16
	note D_3, $0f, 32
	note D_3, $0f, 16
	audio_94 $10
	note G_3, $0f, 16
	note G#3, $0f, 16
	note G_3, $0f, 16
	note F_3, $0f, 16
	note G_3, $0f, 16
	note F_3, $0f, 16
	note C_3, $0f, 16
	note D_3, $0f, 16
	audio_end_loop
	audio_end
	db $80

Audio_fb6d1:
	audio_84
	audio_loop
	audio_94 $12
	audio_a8
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 32
	note C_4, $0f, 96
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 32
	note C_4, $0f, 96
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 32
	note C_4, $0f, 96
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 32
	note C_4, $0f, 96
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 32
	note C_4, $0f, 80
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 112
	note C_4, $0f, 16
	note C_4, $0f, 128
	note C_4, $0e, 32
	note C_4, $0f, 96
	note C_4, $0f, 32
	note C_4, $0f, 96
	audio_end_loop
	audio_end
	db $80

Audio_fb79f:
	audio_84
	audio_loop
	audio_94 $14, 64
	audio_a8
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0d, 80
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 16
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 128
	note D_4, $0f, 48
	note D_4, $0d, 80
	note D_4, $0f, 48
	note D_4, $0f, 32
	note D_4, $0f, 48
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 16
	note D_4, $0f, 16
	audio_end_loop
	audio_end
	db $80

Audio_fb867:
	audio_84
	audio_loop
	audio_94 $15, 32
	audio_a8
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 80
	note D#4, $0f, 48
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 112
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 80
	note D#4, $0f, 48
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 112
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 64
	note D#4, $0f, 48
	note D#4, $0f, 80
	note D#4, $0f, 80
	note D#4, $0f, 80
	audio_end_loop
	audio_end
	db $80

Data_fb92d:
	offset_table
	db 4 ; num of tracks
	db $00 ; ?
	offset Audio_fb937
	offset Audio_fb97b
	offset Audio_fb9bb
	offset Audio_fb9fb

Audio_fb937:
	audio_84
	audio_82 $78
	audio_94 $00
	audio_a8
	note C#1, $0f, 16
	note C#1, $0a, 16
	note C#1, $0f, 16
	note C#1, $0a, 16
	audio_af
	note E_1, $0f, 32
	audio_a8
	note C#1, $0f, 16
	note F#1, $0f, 16
	note F#1, $0a, 16
	note G_1, $0f, 16
	note G_1, $0a, 16
	note G#1, $0f, 16
	note G#1, $0a, 16
	note C#1, $0f, 16
	note B_1, $0f, 16
	note C_2, $0f, 16
	note C#2, $0f, 16
	note C#2, $09, 0
	audio_end
	db $80

Audio_fb97b:
	audio_84
	audio_94 $02
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $0a, 16
	note C#3, $0f, 16
	note F#3, $0f, 16
	note F#3, $0a, 16
	note G_3, $0f, 16
	note G_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note B_3, $0f, 16
	note C_4, $0f, 16
	note C#4, $0f, 16
	note C#4, $09, 0
	audio_end
	db $80

Audio_fb9bb:
	audio_84
	audio_94 $03
	audio_a8
	note C#3, $0f, 16
	note C#3, $0a, 16
	note C#3, $0f, 16
	note C#3, $0a, 16
	note E_3, $0f, 16
	note E_3, $0a, 16
	note C#3, $0f, 16
	note F#3, $0f, 16
	note F#3, $0a, 16
	note G_3, $0f, 16
	note G_3, $0a, 16
	note G#3, $0f, 16
	note G#3, $09, 16
	note C#3, $0f, 16
	note B_3, $0f, 16
	note C_4, $0f, 16
	note C#4, $0f, 16
	note C#4, $09, 0
	audio_end
	db $80

Audio_fb9fb:
	audio_84
	audio_99
	audio_90 $0f
	note F_1, $0f, 16
	note F#1, $0f, 16
	note G#1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note F#1, $0f, 16
	audio_90 $1f
	note G#1, $0f, 32
	audio_90 $0f
	note F_1, $0f, 16
	note F#1, $0f, 16
	note G#1, $0f, 16
	note F_1, $0f, 16
	note G_1, $0f, 16
	note G_1, $0f, 16
	note G_1, $0f, 16
	note G_1, $0f, 16
	note G_1, $0f, 0
	audio_end
	db $80

Data_fba3b:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fba3f

Audio_fba3f:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $0a
	audio_94 $1b
	audio_90 $08
	note C_3, $0f, 0
	audio_end
	db $80

Data_fba55:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fba59

Audio_fba59:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $0a
	audio_94 $1c
	audio_a7
	note C_0, $0f, 0
	audio_end
	db $80

Data_fba6e:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fba72

Audio_fba72:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $04
	audio_94 $1d
	audio_ab
	note C_2, $0f, 0
	audio_end
	db $80

Data_fba87:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fba8b

Audio_fba8b:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $05
	audio_94 $1e
	audio_90 $28
	note D#2, $0f, 0
	audio_end
	db $80

Data_fbaa1:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbaa5

Audio_fbaa5:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $06
	audio_94 $1f
	audio_90 $28
	note A#1, $0f, 0
	audio_end
	db $80

Data_fbabb:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbabf

Audio_fbabf:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $07
	audio_94 $20
	audio_a7
	note A#1, $0f, 0
	audio_end
	db $80

Data_fbad4:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbad8

Audio_fbad8:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $05
	audio_94 $1e
	audio_a8
	note D#2, $0f, 32
	audio_af
	note D#2, $0f, 0
	audio_end
	db $80

Data_fbaf2:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbaf6

Audio_fbaf6:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $0a
	audio_94 $1c
	audio_a7
	note C_0, $0f, 0
	audio_end
	db $80

Data_fbb0b:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbb0f

Audio_fbb0f:
	audio_84
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $21
	audio_a8
	note C_0, $0f, 16
	audio_end_loop
	audio_end
	db $80

Data_fbb29:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbb2d

Audio_fbb2d:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note C#0, $10, 13312
	audio_end
	db $80

Data_fbb46:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbb4a

Audio_fbb4a:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note D_0, $10, 13312
	audio_end
	db $80

Data_fbb63:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbb67

Audio_fbb67:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note D#0, $10, 13312
	audio_end
	db $80

Data_fbb80:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbb84

Audio_fbb84:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note E_0, $10, 13312
	audio_end
	db $80

Data_fbb9d:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbba1

Audio_fbba1:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note F_0, $10, 13312
	audio_end
	db $80

Data_fbbba:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbbbe

Audio_fbbbe:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note F#0, $10, 13312
	audio_end
	db $80

Data_fbbd7:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbbdb

Audio_fbbdb:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note G_0, $10, 13312
	audio_end
	db $80

Data_fbbf4:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbbf8

Audio_fbbf8:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note G#0, $10, 13312
	audio_end
	db $80

Data_fbc11:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbc15

Audio_fbc15:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note A_0, $10, 13312
	audio_end
	db $80

Data_fbc2e:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbc32

Audio_fbc32:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note A#0, $10, 13312
	audio_end
	db $80

Data_fbc4b:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbc4f

Audio_fbc4f:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note B_0, $10, 13312
	audio_end
	db $80

Data_fbc68:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbc6c

Audio_fbc6c:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $22
	audio_a8
	note C_1, $10, 13312
	audio_end
	db $80

Data_fbc85:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbc89

Audio_fbc89:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $05
	audio_94 $23
	audio_90 $1f
	note F#3, $00
	audio_end
	db $80

Data_fbc9e:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbca2

Audio_fbca2:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $05
	audio_94 $24
	audio_aa
	note E_3, $00
	audio_end
	db $80

Data_fbcb6:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbcba

Audio_fbcba:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $05
	audio_94 $25
	audio_a6
	note E_3, $00
	audio_end
	db $80

Data_fbcce:
	offset_table
	db 2 ; num of tracks
	db $00 ; ?
	offset Audio_fbcd4
	offset Audio_fbce9

Audio_fbcd4:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $05
	audio_94 $23
	audio_90 $17
	note E_3, $00
	audio_end
	db $80

Audio_fbce9:
	audio_nop1
	audio_83
	audio_86 $05
	audio_94 $26, 24
	audio_aa
	note C_3, $00
	audio_end
	db $80

Data_fbcfa:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbcfe

Audio_fbcfe:
	audio_nop1
	audio_83
	audio_82 $78
	audio_94 $27
	audio_86 $01
	audio_a8
	note D_4, $00
	audio_end
	db $80

Data_fbd12:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbd16

Audio_fbd16:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $04
	audio_94 $28
	audio_af
	note G_3, $00
	audio_end
	db $80

Data_fbd2a:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbd2e

Audio_fbd2e:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $03
	audio_94 $29
	audio_a8
	note G_3, $0f, 16
	note G_3, $0e, 16
	note G_3, $0c, 16
	note G_3, $0a, 16
	note G_3, $09, 16
	note G_3, $07, 16
	note G_3, $05, 0
	audio_end
	db $80

Data_fbd55:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbd59

Audio_fbd59:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $03
	audio_94 $2a
	audio_a6
	note G_3, $80, 148
	note G_0, $00, 8448
	note E_3, $00
	audio_end
	db $80

Data_fbd75:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbd79

Audio_fbd79:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $2c
	audio_a8
	note C_1, $10, 13312
	audio_end
	db $80

Data_fbd92:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbd96

Audio_fbd96:
	audio_nop1
	audio_83
	audio_82 $78
	audio_loop
	audio_86 $03
	audio_94 $2d
	audio_a8
	note C_1, $10, 13312
	audio_end
	db $80

Data_fbdaf:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbdb3

Audio_fbdb3:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $04
	audio_94 $2e
	audio_af
	note G_3, $00
	audio_end
	db $80

Data_fbdc7:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbdcb

Audio_fbdcb:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $04
	audio_94 $2f
	audio_af
	note G_3, $00
	audio_end
	db $80

Data_fbddf:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbde3

Audio_fbde3:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $14
	audio_94 $30
	audio_af
	note C_3, $00
	audio_end
	db $80

Data_fbdf7:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbdfb

Audio_fbdfb:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $14
	audio_94 $30
	audio_af
	note C_3, $0a, 0
	audio_end
	db $80

Data_fbe10:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbe14

Audio_fbe14:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $14
	audio_94 $31
	audio_90 $28
	note C_3, $00
	audio_end
	db $80

Data_fbe29:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbe2d

Audio_fbe2d:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $14
	audio_94 $31
	audio_90 $28
	note C_3, $0a, 0
	audio_end
	db $80

Data_fbe43:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbe47

Audio_fbe47:
	audio_nop1
	audio_83
	audio_82 $78
	audio_86 $14
	audio_94 $32
	audio_90 $28
	note C_3, $00
	audio_end
	db $80

Data_fbe5c:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbe60

Audio_fbe60:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $14
	audio_94 $32
	audio_90 $28
	note C_3, $09, 0
	audio_end
	db $80

Data_fbe76:
	offset_table
	db 1 ; num of tracks
	db $00 ; ?
	offset Audio_fbe7a

Audio_fbe7a:
	audio_84
	audio_83
	audio_82 $78
	audio_86 $13
	audio_94 $33
	audio_90 $08
	note G_2, $0f, 8
	note C_3, $0f, 8
	note F_3, $0f, 8
	note G_3, $0f, 8
	note G_2, $0b, 8
	note C_3, $0b, 8
	note F_3, $0b, 8
	note G_3, $0b, 0
	audio_end
	db $80

Data_fbea5:
	offset_table
	db 2 ; num of tracks
	db $00 ; ?
	offset Audio_fbeab
	offset Audio_fbeb3

Audio_fbeab:
	audio_84
	audio_83
	audio_82 $a0
	db $80

Audio_fbeb3:
	audio_84
	audio_83
	audio_86 $12
	audio_94 $34
	audio_90 $08
	note C_3, $0f, 8
	note G_3, $0f, 8
	note C_4, $0f, 8
	note C_3, $09, 8
	note G_3, $09, 8
	note C_4, $09, 0
	audio_end
	db $80
; 0xfbed5
