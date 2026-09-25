"""Package PNG icon sizes into a macOS .icns file."""

from pathlib import Path
import struct

iconset = Path(__file__).parent / "AppIcon.iconset"
output = Path(__file__).parent / "Netraffic.app/Contents/Resources/AppIcon.icns"

sizes = [
    ("icp4", "icon_16x16.png"),
    ("icp5", "icon_32x32.png"),
    ("icp6", "icon_32x32@2x.png"),
    ("ic07", "icon_128x128.png"),
    ("ic08", "icon_256x256.png"),
    ("ic09", "icon_512x512.png"),
    ("ic10", "icon_512x512@2x.png"),
]
chunks = []
for kind, filename in sizes:
    data = (iconset / filename).read_bytes()
    chunks.append(kind.encode("ascii") + struct.pack(">I", len(data) + 8) + data)

body = b"".join(chunks)
output.write_bytes(b"icns" + struct.pack(">I", len(body) + 8) + body)
