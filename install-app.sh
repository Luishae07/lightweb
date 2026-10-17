#!/bin/sh
# Installs the Light.web browser (Light.web.app) on a Mac.
#   curl -fsSL https://raw.githubusercontent.com/Luishae07/lightweb/main/install-app.sh | sh
set -e
REPO=Luishae07/lightweb
if [ "$(uname -s)" != "Darwin" ]; then
  echo "The Light.web app is for macOS. On other systems, see https://github.com/$REPO"
  exit 1
fi
case "$(uname -m)" in
  arm64) asset="Light.web-macos-apple-silicon.zip" ;;
  *) asset="Light.web-macos-intel.zip" ;;
esac
base="https://github.com/$REPO/releases/latest/download"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
echo "Downloading $asset ..."
curl -fsSL "$base/$asset" -o "$tmp/app.zip"
want=$(curl -fsSL "$base/SHA256SUMS" | awk -v a="$asset" '$2==a {print $1}')
got=$(shasum -a 256 "$tmp/app.zip" | cut -d' ' -f1)
if [ -n "$want" ] && [ "$got" != "$want" ]; then
  echo "The download does not match its checksum, so it was not installed."
  exit 1
fi
unzip -q "$tmp/app.zip" -d "$tmp/out"
dest="/Applications"
[ -w "$dest" ] || { dest="$HOME/Applications"; mkdir -p "$dest"; }
rm -rf "$dest/Light.web.app"
mv "$tmp/out/Light.web.app" "$dest/Light.web.app"
xattr -dr com.apple.quarantine "$dest/Light.web.app" 2>/dev/null || true
echo "Installed $dest/Light.web.app"
echo "Open it from Launchpad or Spotlight, then press Cmd+L and type a name such as blog.nerd"
