#!/bin/sh
# Installs lwserve, the program that runs a Light.web site from a folder.
#   curl -fsSL https://raw.githubusercontent.com/Luishae07/lightweb/main/install.sh | sh
set -e
REPO=Luishae07/lightweb
os=$(uname -s)
arch=$(uname -m)
case "$os" in
  Linux) o=linux ;;
  Darwin) o=macos ;;
  *) echo "This installer supports Linux and macOS. For Windows, download lwserve-windows-amd64.exe from https://github.com/$REPO/releases"; exit 1 ;;
esac
case "$arch" in
  x86_64|amd64) a=amd64 ;;
  arm64|aarch64) a=arm64 ;;
  *) echo "Unsupported processor: $arch. See https://github.com/$REPO/releases"; exit 1 ;;
esac
asset="lwserve-$o-$a"
base="https://github.com/$REPO/releases/latest/download"
dest="${LWSERVE_DIR:-$HOME/.local/bin}"
mkdir -p "$dest"
tmp=$(mktemp)
echo "Downloading $asset ..."
curl -fsSL "$base/$asset" -o "$tmp"
want=$(curl -fsSL "$base/SHA256SUMS" | awk -v a="$asset" '$2==a {print $1}')
if command -v sha256sum >/dev/null 2>&1; then
  got=$(sha256sum "$tmp" | cut -d' ' -f1)
elif command -v shasum >/dev/null 2>&1; then
  got=$(shasum -a 256 "$tmp" | cut -d' ' -f1)
else
  got=""
fi
if [ -n "$got" ] && [ -n "$want" ] && [ "$got" != "$want" ]; then
  echo "The download does not match its checksum, so it was not installed."
  rm -f "$tmp"
  exit 1
fi
chmod +x "$tmp"
mv "$tmp" "$dest/lwserve"
echo "Installed $dest/lwserve"
case ":$PATH:" in
  *":$dest:"*) ;;
  *) echo "Add it to your PATH:  export PATH=\"$dest:\$PATH\"" ;;
esac
echo "Next:  lwserve -h"
