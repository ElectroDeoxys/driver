Scenes:
	table_width 16

	; SCENE_GB_DISCLAIMER
	dmgpal SHADE_WHITE, SHADE_LIGHT, SHADE_DARK, SHADE_BLACK ; BGP (dgm only)
	dba NULL  ; BG palettes (CGB only)
	dbw $34, $68dd ; tiles VRAM0
	dbw $34, $6b3c ; BG map
	dba NULL  ; tiles VRAM1 (CGB only)
	dba NULL  ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d2c17 ; BG palettes (CGB only)
	dbw $34, $6c57 ; tiles VRAM0
	dbw $34, $7407 ; BG map
	dbw $32, $7fd0 ; tiles VRAM1 (CGB only)
	dbw $34, $7543 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d3567 ; BG palettes (CGB only)
	dbw $34, $75a7 ; tiles VRAM0
	dbw $34, $7cb4 ; BG map
	dbw $34, $7ddd ; tiles VRAM1 (CGB only)
	dbw $34, $7e06 ; tile attributes (CGB only)

	; SCENE_CRAWFISH_INTERACTIVE
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d3e68 ; BG palettes (CGB only)
	dbw $35, $4000 ; tiles VRAM0
	dbw $34, $7ea8 ; BG map
	dbw $35, $47f7 ; tiles VRAM1 (CGB only)
	dbw $35, $4820 ; tile attributes (CGB only)

	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d4857 ; BG palettes (CGB only)
	dbw $35, $4897 ; tiles VRAM0
	dbw $35, $4c9d ; BG map
	dbw $35, $4d7b ; tiles VRAM1 (CGB only)
	dbw $35, $4da4 ; tile attributes (CGB only)

	; SCENE_LEGAL_INFO
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d4dcb ; BG palettes (CGB only)
	dbw $35, $4e0b ; tiles VRAM0
	dbw $35, $5086 ; BG map
	dbw $35, $511e ; tiles VRAM1 (CGB only)
	dbw $34, $7fda ; tile attributes (CGB only)

	; SCENE_LICENSED_BY_NINTENDO
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d5147 ; BG palettes (CGB only)
	dbw $35, $5187 ; tiles VRAM0
	dbw $35, $5284 ; BG map
	dbw $35, $52c9 ; tiles VRAM1 (CGB only)
	dbw $35, $52f2 ; tile attributes (CGB only)

	; SCENE_INFOGRAMES
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d61a4 ; BG palettes (CGB only)
	dbw $35, $61e4 ; tiles VRAM0
	dbw $35, $6994 ; BG map
	dbw $35, $6ad0 ; tiles VRAM1 (CGB only)
	dbw $35, $6af9 ; tile attributes (CGB only)

	; SCENE_REFLECTIONS
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d589f ; BG palettes (CGB only)
	dbw $35, $58df ; tiles VRAM0
	dbw $35, $5ff0 ; BG map
	dbw $35, $6119 ; tiles VRAM1 (CGB only)
	dbw $35, $6142 ; tile attributes (CGB only)

	; SCENE_TITLESCREEN
	dmgpal SHADE_WHITE, SHADE_WHITE, SHADE_WHITE, SHADE_WHITE ; BGP (dgm only)
	dba Pals_d5315 ; BG palettes (CGB only)
	dbw $35, $5355 ; tiles VRAM0
	dbw $35, $5770 ; BG map
	dbw $35, $584f ; tiles VRAM1 (CGB only)
	dbw $35, $5878 ; tile attributes (CGB only)

	assert_table_length NUM_SCENES
