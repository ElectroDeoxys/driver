import re

substrings = [
	(r"ldh \[hROMBank\], a\n\tld \[\$2150\], a", "bankswitch"),
	(r"ldh \[hWRAMBank\], a\n\tldh \[rWBK\], a", "wramswitch"),
	(r"ldh \[hVRAMBank\], a\n\tldh \[rVBK\], a", "vramswitch"),
	(r"(\..+)\n\tldh a, \[rSTAT\]\n\tand \$02\n\tjr z, \1\n(\..+)\n\tldh a, \[rSTAT\]\n\tand \$02\n\tjr nz, \2", "\twait_ppu"),
]

def process(body):
	for pattern, repl in substrings:
		body = re.sub(pattern, repl, body)
	return body
