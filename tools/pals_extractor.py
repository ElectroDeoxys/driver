import reader
import argparse

parser = argparse.ArgumentParser(description='Parse palette data.')
parser.add_argument('offsets', metavar='offsets', type=str, nargs='+',
                    help='offsets of pal data')
parser.add_argument('-n', metavar='num', dest='num', type=int, nargs=1, default=[1],
                    help='number of pals for each offset')

args = parser.parse_args()

def getRGB(data):
    red = data[0] & 0b00011111
    green = ((data[0] & 0b11100000) >> 5) + ((data[1] & 0b00000011) << 3)
    blue = (data[1] & 0b01111100) >> 2
    return [red, green, blue]

for offsetStr in args.offsets:
    offset = int(offsetStr, 16)
    cur_offset = offset
    out_str = ''

    for x in range(args.num[0]):
        for col in range(4):
            red, green, blue = getRGB(reader.get_rom_bytes(cur_offset, 2))
            out_str += '\trgb ' + '{0:2}, '.format(red) + '{0:2}, '.format(green) + '{0:2}\n'.format(blue)
            cur_offset += 2

        if x != args.num[0] - 1:
            out_str += '\n'

    print(f"Pals_{offset:0x}:\n{out_str}; 0x{cur_offset:0x}")
