#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")"
bundle="Netraffic.app"
mkdir -p "$bundle/Contents/MacOS"
mkdir -p "$bundle/Contents/Resources"
for arch in arm64 x86_64; do
  mkdir -p ".build/$arch/module-cache"
  CLANG_MODULE_CACHE_PATH="$PWD/.build/$arch/module-cache" swiftc \
    -target "$arch-apple-macos13.0" \
    -module-cache-path "$PWD/.build/$arch/module-cache" \
    Netraffic.swift -framework AppKit -framework SystemConfiguration \
    -o ".build/Netraffic-$arch"
done
lipo -create .build/Netraffic-arm64 .build/Netraffic-x86_64 \
  -output "$bundle/Contents/MacOS/Netraffic"
cp Info.plist "$bundle/Contents/Info.plist"
python3 make_icon.py
codesign --force --sign - "$bundle"
echo "Built $bundle"
