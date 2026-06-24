; input:
; - a = CARSTRUCT_* constant
AddBCToStructField::
	push hl
	add_hl
	ld d, h
	ld e, l
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	pop hl
	inc de
	ld a, [de]
	bit 7, b
	jr z, .asm_1484
	ret c
	dec a
	ld [de], a
	ret
.asm_1484
	ret nc
	inc a
	ld [de], a
	ret

ClearEntities::
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
	xor a
.loop
	ld [hl], a ; ENT_FLAGS
	add hl, de
	dec b
	jr nz, .loop
	ret

; returns in hl pointer to entity with ENT_UNK05 == a
; if found, return carry, otherwise no carry
; input:
; - a = ?
FindEntity::
	push bc
	push de
	ld c, a
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit ENTF_ACTIVE_F, [hl] ; ENT_FLAGS
	jr z, .inactive
	ld a, ENT_UNK05
	add_hl
	ld a, c
	cp [hl]
	jr z, .found
	ld a, ENT_UNK05
	sub_hl
.inactive
	add hl, de
	dec b
	jr nz, .loop
	pop de
	pop bc
	and a
	ret
.found
	pop de
	pop bc
	ld a, ENT_UNK05
	sub_hl
	scf
	ret

UpdateEntities::
	ldh a, [hROMBank]
	push af
	ld b, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit ENTF_ACTIVE_F, [hl] ; ENT_FLAGS
	call nz, .Update
	add hl, de
	dec b
	jr nz, .loop
	pop af
	bankswitch
	ret

.Update:
	inc hl
	dec [hl] ; ENT_UPDATE_TIMER
	dec hl
	ret nz
	push bc
	push de
	push hl
	call StartEntityUpdate
	pop hl
	pop de
	pop bc
	ret

; expected to be called after StartEntityUpdate
; pauses current entity update function and resumes normal code execution
; sets entity's stack pointer so that next update call is set to callee
; input:
; - a = update timer for next update
YieldEntityUpdate::
	push bc
	push de
	push hl
	ld c, a
	ld a, [wEntityPtr + 0]
	ld e, a
	ld a, [wEntityPtr + 1]
	ld d, a
	inc de
	ld a, c
	ld [de], a ; ENT_UPDATE_TIMER
	inc de
	ldh a, [hROMBank]
	ld [de], a ; ENT_UPDATE_FUNC_BANK
	inc de
	ld hl, sp+$00
	ld a, l
	ld [de], a ; ENT_STACK_POINTER
	inc de     ;
	ld a, h    ;
	ld [de], a ;

	; resume main sp
	ld hl, wTempSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ret

; starts update of entity given in hl
; expects YieldEntityUpdate to be called when finished
; temporarily sets sp to ENT_STACK_POINTER
StartEntityUpdate:
	ld a, l
	ld [wEntityPtr + 0], a
	ld a, h
	ld [wEntityPtr + 1], a
	inc hl
	inc hl
	ld a, [hli] ; ENT_UPDATE_FUNC_BANK
	bankswitch
	ld a, [hli] ; ENT_STACK_POINTER
	ld h, [hl]  ;
	ld l, a
	ld [wTempSP], sp
	ld sp, hl
	pop hl
	pop de
	pop bc
	ret

DespawnEntity::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $00
	ld hl, wTempSP
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	ret

; input:
; - c:hl = update function
; - b  = ?
SpawnEntity::
	push hl
	ld a, NUM_ENTITIES
	ld hl, wEntities
	ld de, ENT_STRUCT_SIZE
.loop
	bit ENTF_ACTIVE_F, [hl] ; ENT_FLAGS
	jr z, .inactive
	add hl, de
	dec a
	jr nz, .loop
	pop hl
	scf
	ret

.inactive
	ld [hl], ENTF_ACTIVE ; ENT_FLAGS
	inc hl
	ld [hl], 1 ; ENT_UPDATE_TIMER
	inc hl
	ld [hl], c ; ENT_UPDATE_FUNC_BANK
	inc hl
	ld d, h
	ld e, l
	ld a, (ENT_STACK_BOTTOM - 8) - ENT_STACK_POINTER
	add_de
	ld [hl], e ; ENT_STACK_POINTER
	inc hl     ;
	ld [hl], d ;
	inc hl
	ld [hl], b ; ENT_UNK05
	ld a, (ENT_STACK_BOTTOM - 1) - ENT_UNK05
	add_hl
	pop de ; input hl
	ld [hl], d
	dec hl
	ld [hl], e
	ld de, -(ENT_STACK_BOTTOM - 2)
	add hl, de
	and a
	ret

; input:
; - hl   = entity
; - a:de = update function
OverwriteEntityUpdateFunc::
	inc hl
	ld [hl], 1 ; ENT_UPDATE_TIMER
	inc hl
	ld [hli], a ; ENT_UPDATE_FUNC_BANK
	push de
	ld d, h
	ld e, l
	ld a, (ENT_STACK_BOTTOM - 9) - ENT_UPDATE_FUNC_BANK
	add_de
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, (ENT_STACK_BOTTOM - 1) - (ENT_STACK_POINTER + 1)
	add_hl
	pop de ; input de
	ld [hl], d ; ENT_UNK56
	dec hl
	ld [hl], e
	ret

; input:
; - wEntityPtr = entity
; - a:de = update function
SetEntityUpdateFunc::
	bankswitch
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, ENT_STACK_BOTTOM
	add_hl
	ld sp, hl
	ld h, d
	ld l, e
	jp hl

Func_1591::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

GetEntityCarPtr::
	ld hl, wEntityPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, ENT_CAR_PTR
	add_hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

YieldEntityUpdate_BCTimes:
	ld a, c
	call YieldEntityUpdate
	ld a, b
	and a
.loop
	ret z
	xor a
	call YieldEntityUpdate
	dec b
	jr .loop

YieldEntityUpdateIndefinitely::
.loop
	ld bc, -1 ; max duration
	call YieldEntityUpdate_BCTimes
	jr .loop
