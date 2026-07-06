PtrTable_edd:
	dw Data_f8cf4 ; "Audio 1"
	dw $4cf4      ; "Audio 2"

Data_ee1:
	table_width 2
	db $3e, $01 ; MUSIC_TITLESCREEN
	db $3e, $02 ; MUSIC_MAIN_MENU
	db $3e, $03 ; MUSIC_BRIEFING
	db $3e, $04 ; MUSIC_MIAMI
	db $3e, $05 ; MUSIC_MISSION_COMPLETE
	db $3f, $01 ; MUSIC_LOS_ANGELES
	db $3f, $02 ; MUSIC_NEW_YORK
	db $3f, $03 ; MUSIC_MISSION_FAILED
	assert_table_length NUM_MUSICS

Func_ef1:
	ld b, AUDIOFUNC_UNK4
	ld c, a
	jp AddToAudioQueue

; input:
; - a = SFX_* constant
PlaySFX::
	and a
	ret z
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc544]
	and a
	jr z, .skip
	ld b, AUDIOFUNC_PLAY_SFX
	call AddToAudioQueue
.skip
	pop hl
	pop de
	pop bc
	ret

; input:
; - a = SFX_* constant
StopSFX::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc544]
	and a
	jr z, .asm_f1b
	ld b, AUDIOFUNC_STOP_SFX
	call AddToAudioQueue
.asm_f1b
	pop hl
	pop de
	pop bc
	ret

Func_f1f::
	push af
	call StopSFX
	pop af
	jp PlaySFX

; input:
; - a = MUSIC_* constant
PlayMusicIfNotPlaying::
	push hl
	ld hl, wc541
	cp [hl]
	pop hl
	ret z ; already playing
;	fallthrough

; input:
; - a = MUSIC_* constant
PlayMusic::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wc545]
	and a
	jr z, .skip
	ld b, AUDIOFUNC_PLAY_MUSIC
	call AddToAudioQueue
.skip
	pop hl
	pop de
	pop bc
	ret

StopSound:
	push af
	push bc
	push de
	push hl
	ld b, AUDIOFUNC_STOP_SOUND
	call AddToAudioQueue
	pop hl
	pop de
	pop bc
	pop af
	ret

; input:
; - b = AUDIOFUNC_* constant
; - c = argument to audio function
AddToAudioQueue:
	ld hl, wAudioQueueSize
	ld a, [hl]
	cp MAX_AUDIO_QUEUE_SIZE
	ret z ; no more space in queue

	; mark queue as invalid while pushing a new entry
	xor a
	ld [wAudioQueueValid], a

	; increment size
	inc [hl] ; wAudioQueueSize

	ld hl, wAudioQueueIterator
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], b ; function
	inc hl
	ld [hl], c ; argument
	inc hl
	ld a, l
	ld [wAudioQueueIterator + 0], a
	ld a, h
	ld [wAudioQueueIterator + 1], a

	; mark queue as valid again
	ld a, TRUE
	ld [wAudioQueueValid], a
	ret

ClearAudioQueue:
	ld de, wAudioQueue
	ld hl, wAudioQueueIterator
	ld [hl], e
	inc hl
	ld [hl], d
	xor a
	ld [wAudioQueueSize], a
	ret

UpdateAudio:
	; process audio queue
	ld a, [wAudioQueueValid]
	and a
	jr z, .skip_queue ; not valid

	ld a, [wAudioQueueSize]
	and a
	jr z, .skip_queue ; no entries

	ld hl, wAudioQueue
	ld b, a ; num of entries
.loop_entries
	push bc
	ld a, [hli]
	ld c, [hl]
	push hl
	ld de, .return
	push de
	jumptable
	dw Func_fba  ; AUDIOFUNC_PLAY_SFX
	dw Func_fd3  ; AUDIOFUNC_PLAY_MUSIC
	dw Func_1009 ; AUDIOFUNC_STOP_SOUND
	dw Func_1010 ; AUDIOFUNC_STOP_SFX
	dw Func_101e ; AUDIOFUNC_UNK4
.return
	pop hl
	pop bc
	inc hl
	dec b
	jr nz, .loop_entries
	call ClearAudioQueue

.skip_queue
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	jp Func_f8003

Func_fba:
	ld a, [wAudioBank]
	and a
	jr nz, .asm_fc7
	push bc
	ld c, BANK("Audio 1")
	call SetAudioBank
	pop bc
.asm_fc7
	ld a, [wAudioBank]
	bankswitch
	ld a, c
	jp Func_f800c

Func_fd3:
	push bc
	call Func_1069
	pop bc
	ld a, c
	ld [wc542], a
	and a
	ret z
	ld hl, Data_ee1 - $2
	add a
	add_hl
	ld c, [hl] ; bank
	inc hl
	ld b, [hl] ; ?
	ld a, [wAudioBank]
	cp c
	jr z, .asm_ff9
	and a
	jr z, .asm_ff4
	push bc
	call Func_1045
	pop bc
.asm_ff4
	push bc
	call SetAudioBank
	pop bc
.asm_ff9
	ld a, [wAudioBank]
	bankswitch
	ld a, b
	ld [wc541], a
	dec a
	jp Func_f800c

Func_1009:
	xor a
	ld [wc542], a
	jp Func_1058

Func_1010:
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	ld a, c
	jp Func_f800f

Func_101e:
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	ld a, c
	jp Func_f8015

; input:
; - c = audio bank to switch to
SetAudioBank:
	ld a, c
	ld [wAudioBank], a
	ld a, c
	bankswitch
	push bc
	call InitAudio
	pop bc
	ld a, c
	sub BANK("Audio 1")
	ld hl, PtrTable_edd
	get_pointer
	jp Func_f8006

Func_1045:
	call Func_1058
	ld hl, wAudioBank
	ld a, [hl]
	ld [hl], $00
	and a
	ret z
	bankswitch
	jp Func_f8003

Func_1058:
	ld a, [wAudioBank]
	and a
	ret z
	bankswitch
	xor a
	ld [wc541], a
	jp Func_f8012

Func_1069:
	ld a, [wAudioBank]
	and a
	ret z
	ld hl, wc541
	ld b, [hl]
	ld [hl], $00
	ld a, b
	and a
	ret z
	ld a, [wAudioBank]
	bankswitch
	ld a, b
	dec a
	jp Func_f800f

Func_1084:
	xor a
	ld [wAudioQueueValid], a
	ld [wAudioBank], a
	ld [wc541], a
	jp ClearAudioQueue
