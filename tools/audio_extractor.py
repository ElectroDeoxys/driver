import reader
import argparse

parser = argparse.ArgumentParser(description='Parse audio data.')
parser.add_argument('offsets', metavar='offsets', type=str, nargs='+',
                    help='offsets of audio data')

args = parser.parse_args()

notes = [
    "C_0", # 0x00
    "C#0", # 0x01
    "D_0", # 0x02
    "D#0", # 0x03
    "E_0", # 0x04
    "F_0", # 0x05
    "F#0", # 0x06
    "G_0", # 0x07
    "G#0", # 0x08
    "A_0", # 0x09
    "A#0", # 0x0a
    "B_0", # 0x0b
    "C_1", # 0x0c
    "C#1", # 0x0d
    "D_1", # 0x0e
    "D#1", # 0x0f
    "E_1", # 0x10
    "F_1", # 0x11
    "F#1", # 0x12
    "G_1", # 0x13
    "G#1", # 0x14
    "A_1", # 0x15
    "A#1", # 0x16
    "B_1", # 0x17
    "C_2", # 0x18
    "C#2", # 0x19
    "D_2", # 0x1a
    "D#2", # 0x1b
    "E_2", # 0x1c
    "F_2", # 0x1d
    "F#2", # 0x1e
    "G_2", # 0x1f
    "G#2", # 0x20
    "A_2", # 0x21
    "A#2", # 0x22
    "B_2", # 0x23
    "C_3", # 0x24
    "C#3", # 0x25
    "D_3", # 0x26
    "D#3", # 0x27
    "E_3", # 0x28
    "F_3", # 0x29
    "F#3", # 0x2a
    "G_3", # 0x2b
    "G#3", # 0x2c
    "A_3", # 0x2d
    "A#3", # 0x2e
    "B_3", # 0x2f
    "C_4", # 0x30
    "C#4", # 0x31
    "D_4", # 0x32
    "D#4", # 0x33
    "E_4", # 0x34
    "F_4", # 0x35
    "F#4", # 0x36
    "G_4", # 0x37
    "G#4", # 0x38
    "A_4", # 0x39
    "A#4", # 0x3a
    "B_4", # 0x3b
    "C_5", # 0x3c
    "C#5", # 0x3d
    "D_5", # 0x3e
    "D#5", # 0x3f
    "E_5", # 0x40
    "F_5", # 0x41
    "F#5", # 0x42
    "G_5", # 0x43
    "G#5", # 0x44
    "A_5", # 0x45
    "A#5", # 0x46
    "B_5", # 0x47
    "C_6", # 0x48
    "C#6", # 0x49
    "D_6", # 0x4a
    "D#6", # 0x4b
    "E_6", # 0x4c
    "F_6", # 0x4d
    "F#6", # 0x4e
    "G_6", # 0x4f
    "G#6", # 0x50
    "A_6", # 0x51
    "A#6", # 0x52
    "B_6", # 0x53
]

commands = {
    0x80: ("audio_end", 0),
    0x81: ("audio_nop1", 0),
    0x82: ("audio_82", 1),
    0x83: ("audio_83", 0),
    0x84: ("audio_84", 0),
    0x85: ("audio_85", 0),
    0x86: ("audio_86", 1),
    0x87: ("audio_87", 1),
    0x88: ("pan", 1),
    0x89: ("audio_89", 1),
    0x90: ("audio_90", 1),
    0x91: ("audio_91", 2),
    0x92: ("audio_92", 1),
    0x93: ("audio_93", 2),
    0x94: ("audio_94", 1),
    0x95: ("audio_95", 2),
    0x96: ("audio_96", 1),
    0x97: ("audio_97", 2),
    0x98: ("audio_nop2", 0),
    0x99: ("audio_99", 0),
    0xa0: ("audio_a0", 0),
    0xa1: ("audio_a1", 0),
    0xa2: ("audio_a2", 0),
    0xa3: ("audio_a3", 0),
    0xa4: ("audio_a4", 0),
    0xa5: ("audio_a5", 0),
    0xa6: ("audio_a6", 0),
    0xa7: ("audio_a7", 0),
    0xa8: ("audio_a8", 0),
    0xa9: ("audio_a9", 0),
    0xaa: ("audio_aa", 0),
    0xab: ("audio_ab", 0),
    0xac: ("audio_ac", 0),
    0xad: ("audio_ad", 0),
    0xae: ("audio_ae", 0),
    0xaf: ("audio_af", 0),
    0xb0: ("audio_loop", 1),
    0xb1: ("audio_loop2", 1),
    0xb4: ("audio_end_loop", 0),
    0xb5: ("audio_end_loop2", 0),
}

def parse_track(offset):
    orig_offset = offset
    print(f"Audio_{orig_offset:0x}:")

    while True:
        cmd = reader.get_rom_byte(offset)

        if cmd in commands:
            tx, len = commands[cmd]
            arg = None
            wait = None
            if len == 1:
                arg = reader.get_rom_byte(offset + 1)
                offset += 2
            elif len == 2:
                lo = reader.get_rom_byte(offset + 1)
                hi = reader.get_rom_byte(offset + 2)
                arg = (hi << 8) + lo
                offset += 3

            wait = reader.get_rom_byte(offset)
            offset += 1
            if wait & 0x80 != 0:
                wait = ((wait & 0x7f) << 8) + reader.get_rom_byte(offset)
                offset += 1

            if tx in ["audio_loop", "audio_loop2"] and arg == 0:
                arg = None

            if arg != None and wait != 0:
                print(f"\t{tx} ${arg:02x}, {wait}")
            elif arg != None:
                print(f"\t{tx} ${arg:02x}")
            else:
                print(f"\t{tx}")

            if tx == "audio_end":
                break
        else:
            note = notes[cmd - 0x24]
            arg = reader.get_rom_byte(offset + 1)
            len = reader.get_rom_byte(offset + 2)
            if len & 0x80 != 0:
                len = ((len & 0x7f) << 8) + reader.get_rom_byte(offset + 3)
                offset += 4
            else:
                offset += 3
            print(f"\tnote {note}, ${arg:02x}, {len}")

    print("\tdb $80")
    offset += 1
    return offset

offsets = set([int(s, 16) for s in args.offsets])
offsets = [o for o in offsets]
offsets = sorted(offsets)

for data_offs in offsets:
    print(f"Data_{data_offs:0x}:\n\toffset_table")
    num_tracks = reader.get_rom_byte(data_offs)
    print(f"\tdb {num_tracks} ; num of tracks")
    unk_arg = reader.get_rom_byte(data_offs + 1)
    print(f"\tdb ${unk_arg:02x} ; ?")

    track_offsets = []
    for i in range(num_tracks):
        l1 = reader.get_rom_byte(data_offs + 2 + 2*i + 0)
        l2 = reader.get_rom_byte(data_offs + 2 + 2*i + 1)
        l = l1 + (l2 << 8)
        track_offsets.append(data_offs + l)
        print(f"\toffset Audio_{track_offsets[-1]:02x}")

    print("")

    for offset in track_offsets:
        end_off = parse_track(offset)
        if offset != track_offsets[-1]:
            print("")
        else:
            print(f"; 0x{end_off:0x}")
