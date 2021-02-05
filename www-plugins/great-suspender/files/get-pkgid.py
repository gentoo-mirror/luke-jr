# Based on https://stackoverflow.com/questions/16993486/how-to-programmatically-calculate-chrome-extension-id/52263105#52263105
import binascii
import string
import struct
import sys

def decode(proto, data):
    index = 0
    length = len(data)
    msg = dict()
    while index < length:
        item = 128
        key = 0
        left = 0
        while item & 128:
            item = data[index]
            index += 1
            value = (item & 127) << left
            key += value
            left += 7
        field = key >> 3
        wire = key & 7
        if wire == 0:
            item = 128
            num = 0
            left = 0
            while item & 128:
                item = data[index]
                index += 1
                value = (item & 127) << left
                num += value
                left += 7
            continue
        elif wire == 1:
            index += 8
            continue
        elif wire == 2:
            item = 128
            _length = 0
            left = 0
            while item & 128:
                item = data[index]
                index += 1
                value = (item & 127) << left
                _length += value
                left += 7
            last = index
            index += _length
            item = data[last:index]
            if field not in proto:
                continue
            msg[proto[field]] = item
            continue
        elif wire == 5:
            index += 4
            continue
        raise ValueError(
            'invalid wire type: {wire}'.format(wire=wire)
        )
    return msg

def get_extension_id(crx_file):
    with open(crx_file, 'rb') as f:
      f.read(8); # 'Cr24\3\0\0\0'
      data = f.read(struct.unpack('<I', f.read(4))[0])
    crx3 = decode(
        {10000: "signed_header_data"},
        data)
    signed_header = decode(
        {1: "crx_id"},
        crx3['signed_header_data'])
    return binascii.hexlify(signed_header['crx_id']).decode('ascii').translate(
        str.maketrans('0123456789abcdef', string.ascii_lowercase[:16]))

def main():
    if len(sys.argv) != 2:
      print('usage: %s crx_file' % sys.argv[0])
    else:
      print(get_extension_id(sys.argv[1]))

if __name__ == "__main__":
    main()
