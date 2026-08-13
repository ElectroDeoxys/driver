; car structure (see constants/car_constants.asm)
MACRO? car_struct
\1Flags:: db
\1Unk01:: db
\1Unk02:: db
\1Unk03:: db
\1Unk04:: dw
\1Coords::
\1Unk06:: db
\1Y:: dw
\1Unk09:: db
\1X:: dw
\1Dir:: db
\1Speed:: dw
\1Unk0F:: db
\1Unk10:: db
\1Unk11:: db
\1Unk12:: db
\1Unk13:: db
\1Unk14:: db
\1Unk15:: db
\1Unk16:: db
\1Unk17:: db
\1Unk18:: db
\1Unk19:: db
\1Unk1A:: db
\1Unk1B:: db
\1Unk1C:: db
\1Unk1D:: db
\1Unk1E:: db
\1Unk1F:: db
\1Unk20:: db
\1Unk21:: db
\1Unk22:: db
\1EntPtr:: dw
\1SpritePtr:: dw
ENDM

; entity structure (see constants/entity_constants.asm)
MACRO? entity_struct
\1Flags::          db
\1UpdateTimer::    db
\1UpdateFuncBank:: db
\1StackPointer::   dw
\1Unk05::          db
\1CarPtr::         dw
\1Stack::          ds $50
ENDM

MACRO? sprite_struct
\1OAMFlags:: db
	ds $10
ENDM

; OAM group structs (see src/constants/sprite_constants.asm)
MACRO? oam_group_struct
\1OAMCount:: db
\1OAMArray:: ds OBJ_SIZE * OAM_GROUP_SIZE
ENDM

MACRO? wda9d_struct
	ds $13
ENDM

; unk audio structure (see constants/audio_constants.asm)
MACRO? audio_track_struct
\1Unk00:: dw
\1CommandsPtr:: dw
\1Unk04:: db
\1Unk05:: db
\1Unk06:: dw
\1Unk08:: db
\1Unk09:: db
\1Flags:: db
\1Unk0b:: db
\1Unk0c:: db
\1Unk0d:: db
\1Unk0e:: dw
\1Loop1Counter:: db
\1Loop1Ptr:: dw
\1Loop2Counter:: db
\1Loop2Ptr:: dw
ENDM

MACRO? audio_channel_struct
\1Note::  db
\1Unk01:: dw
\1Flags:: db
\1Unk04:: db
\1Track:: db
\1Pan::   db
\1Unk07:: db
\1Unk08:: db
\1Unk09:: dw
\1Frequency:: dw
\1Unk0d:: dw
\1Unk0f:: dw
\1Unk11:: dw
\1Unk13:: dw
\1Duty::  db
\1Unk16:: db
\1Unk17:: dw
\1Unk19:: db
\1Unk1a:: db
ENDM

MACRO? lcd_struct
\1SCX::  db
\1SCY::  db
\1LCDC:: db
\1LYC::  db
ENDM
