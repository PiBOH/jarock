#!/usr/bin/env python3
"""Convert an 8-bit RGB/RGBA PNG into a legacy multi-resolution Windows ICO."""

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


def resize_nearest(width: int, height: int, channels: int, pixels: bytes, target_size: int) -> bytes:
    resized = bytearray(target_size * target_size * channels)
    for y in range(target_size):
        source_y = min(height - 1, y * height // target_size)
        for x in range(target_size):
            source_x = min(width - 1, x * width // target_size)
            source_offset = (source_y * width + source_x) * channels
            output_offset = (y * target_size + x) * channels
            resized[output_offset : output_offset + channels] = pixels[
                source_offset : source_offset + channels
            ]
    return bytes(resized)


def encode_dib_frame(size: int, channels: int, pixels: bytes) -> bytes:
    """Encode one 32-bit BGRA DIB frame plus its 1-bit AND mask."""
    xor_rows: list[bytes] = []
    and_row_size = ((size + 31) // 32) * 4
    and_mask = b"\0" * (and_row_size * size)
    for y in range(size - 1, -1, -1):
        row = bytearray()
        for x in range(size):
            offset = (y * size + x) * channels
            red, green, blue = pixels[offset : offset + 3]
            alpha = pixels[offset + 3] if channels == 4 else 255
            row.extend((blue, green, red, alpha))
        xor_rows.append(bytes(row))
    xor_bitmap = b"".join(xor_rows)
    header = struct.pack(
        "<IiiHHIIiiII",
        40,                 # BITMAPINFOHEADER size
        size,
        size * 2,           # XOR bitmap plus AND mask
        1,                  # planes
        32,                 # BGRA pixels
        0,                  # BI_RGB
        len(xor_bitmap),
        0,
        0,
        0,
        0,
    )
    return header + xor_bitmap + and_mask


def encode_legacy_ico(channels: int, width: int, height: int, pixels: bytes) -> bytes:
    """Encode conventional Windows icon sizes with a Bun-safe 48px first frame.

    Bun's Windows resource updater historically used the first ICO image when
    building the executable's associated icon. A 48px legacy DIB is a broadly
    supported primary frame for Explorer, cmd.exe and PowerShell; the remaining
    resolutions are retained for shell scaling and high-DPI selection.
    """
    sizes = (48, 256, 128, 64, 32, 16)
    frames = [(size, encode_dib_frame(size, channels, resize_nearest(width, height, channels, pixels, size))) for size in sizes]
    directory_size = 6 + 16 * len(frames)
    entries: list[bytes] = []
    offset = directory_size
    for size, frame in frames:
        dimension = 0 if size == 256 else size
        entries.append(struct.pack("<BBBBHHII", dimension, dimension, 0, 0, 1, 32, len(frame), offset))
        offset += len(frame)
    return struct.pack("<HHH", 0, 1, len(frames)) + b"".join(entries) + b"".join(frame for _, frame in frames)


def main() -> int:
    if len(sys.argv) != 3:
        print(f"usage: {Path(sys.argv[0]).name} INPUT.png OUTPUT.ico", file=sys.stderr)
        return 2
    source = Path(sys.argv[1])
    destination = Path(sys.argv[2])
    width, height, channels, pixels = decode_png(source.read_bytes())
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(encode_legacy_ico(channels, width, height, pixels))
    print(f"Created {destination} from {source} ({width}x{height} -> 48/256/128/64/32/16 legacy DIB ICO)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
