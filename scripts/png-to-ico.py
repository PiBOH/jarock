#!/usr/bin/env python3
"""Convert an 8-bit RGB/RGBA PNG into a 256x256 Windows ICO."""

from __future__ import annotations

import binascii
import struct
import sys
import zlib
from pathlib import Path

PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"
TARGET_SIZE = 256


def paeth(left: int, above: int, upper_left: int) -> int:
    estimate = left + above - upper_left
    left_distance = abs(estimate - left)
    above_distance = abs(estimate - above)
    upper_left_distance = abs(estimate - upper_left)
    if left_distance <= above_distance and left_distance <= upper_left_distance:
        return left
    if above_distance <= upper_left_distance:
        return above
    return upper_left


def decode_png(data: bytes) -> tuple[int, int, int, bytes]:
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError("input is not a PNG file")
    position = len(PNG_SIGNATURE)
    width = height = bit_depth = color_type = None
    compressed = bytearray()
    while position < len(data):
        length = struct.unpack(">I", data[position : position + 4])[0]
        chunk_type = data[position + 4 : position + 8]
        chunk = data[position + 8 : position + 8 + length]
        position += 12 + length
        if chunk_type == b"IHDR":
            width, height, bit_depth, color_type, compression, filtering, interlace = struct.unpack(
                ">IIBBBBB", chunk
            )
            if bit_depth != 8 or color_type not in (2, 6) or compression or filtering or interlace:
                raise ValueError("only non-interlaced 8-bit RGB/RGBA PNGs are supported")
        elif chunk_type == b"IDAT":
            compressed.extend(chunk)
        elif chunk_type == b"IEND":
            break
    if width is None or height is None:
        raise ValueError("PNG is missing IHDR")
    channels = 3 if color_type == 2 else 4
    row_bytes = width * channels
    raw = zlib.decompress(compressed)
    expected = height * (row_bytes + 1)
    if len(raw) != expected:
        raise ValueError("PNG scanline data has an unexpected size")
    rows: list[bytes] = []
    previous = bytearray(row_bytes)
    cursor = 0
    for _ in range(height):
        filter_type = raw[cursor]
        encoded = raw[cursor + 1 : cursor + 1 + row_bytes]
        cursor += row_bytes + 1
        row = bytearray(row_bytes)
        for index, value in enumerate(encoded):
            left = row[index - channels] if index >= channels else 0
            above = previous[index]
            upper_left = previous[index - channels] if index >= channels else 0
            if filter_type == 0:
                row[index] = value
            elif filter_type == 1:
                row[index] = (value + left) & 255
            elif filter_type == 2:
                row[index] = (value + above) & 255
            elif filter_type == 3:
                row[index] = (value + ((left + above) // 2)) & 255
            elif filter_type == 4:
                row[index] = (value + paeth(left, above, upper_left)) & 255
            else:
                raise ValueError(f"unsupported PNG filter type: {filter_type}")
        rows.append(bytes(row))
        previous = row
    return width, height, channels, b"".join(rows)


def png_chunk(name: bytes, payload: bytes) -> bytes:
    return struct.pack(">I", len(payload)) + name + payload + struct.pack(">I", binascii.crc32(name + payload) & 0xFFFFFFFF)


def encode_png(width: int, height: int, channels: int, pixels: bytes) -> bytes:
    color_type = 2 if channels == 3 else 6
    header = struct.pack(">IIBBBBB", width, height, 8, color_type, 0, 0, 0)
    scanlines = b"".join(b"\x00" + pixels[row * width * channels : (row + 1) * width * channels] for row in range(height))
    return PNG_SIGNATURE + png_chunk(b"IHDR", header) + png_chunk(b"IDAT", zlib.compress(scanlines, 9)) + png_chunk(b"IEND", b"")


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {Path(sys.argv[0]).name} INPUT.png OUTPUT.ico", file=sys.stderr)
        return 2
    source = Path(sys.argv[1])
    destination = Path(sys.argv[2])
    width, height, channels, pixels = decode_png(source.read_bytes())
    output_width = output_height = TARGET_SIZE
    resized = bytearray(output_width * output_height * channels)
    for y in range(output_height):
        source_y = min(height - 1, y * height // output_height)
        for x in range(output_width):
            source_x = min(width - 1, x * width // output_width)
            source_offset = (source_y * width + source_x) * channels
            output_offset = (y * output_width + x) * channels
            resized[output_offset : output_offset + channels] = pixels[source_offset : source_offset + channels]
    png = encode_png(output_width, output_height, channels, bytes(resized))
    entry = struct.pack("<BBBBHHII", 0, 0, 0, 0, 1, 32, len(png), 22)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(struct.pack("<HHH", 0, 1, 1) + entry + png)
    print(f"Created {destination} from {source} ({width}x{height} -> 256x256)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
