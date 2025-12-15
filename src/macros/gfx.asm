DEF tiles EQUS "* TILE_SIZE"
DEF tile  EQUS "+ TILE_SIZE *"

DEF palettes EQUS "* PAL_SIZE"
DEF palette  EQUS "+ PAL_SIZE *"

MACRO lddmgpal
ASSERT \2 < 4 && \3 < 4 && \4 < 4 && \5 < 4
	ld \1, (\2 << 0) | (\3 << 2) | (\4 << 4) | (\5 << 6)
ENDM
