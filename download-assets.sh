#!/usr/bin/env bash
# Download Bootstrap and Font Awesome into ./assets for offline use
# Usage: bash download-assets.sh
set -euo pipefail

ASSETS_DIR="assets"
CSS_DIR="$ASSETS_DIR/css"
JS_DIR="$ASSETS_DIR/js"
FONTS_DIR="$ASSETS_DIR/webfonts"

mkdir -p "$CSS_DIR" "$JS_DIR" "$FONTS_DIR"

echo "Downloading Bootstrap..."
curl -sSL -o "$CSS_DIR/bootstrap.min.css" "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
curl -sSL -o "$JS_DIR/bootstrap.bundle.min.js" "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"

echo "Downloading Font Awesome via npm (temporary)..."
# Use npm to fetch fontawesome package and copy the dist files
TMP=$(mktemp -d)
cd "$TMP"
npm pack @fortawesome/fontawesome-free@6.4.0 --silent > /dev/null
TARGZ=$(ls *.tgz | head -n1)
mkdir -p pkg
tar -xzf "$TARGZ" -C pkg
# files are under package/dist
cp pkg/package/dist/css/all.min.css "$CSS_DIR/fontawesome.min.css"
cp -r pkg/package/dist/webfonts/* "$FONTS_DIR/"

# cleanup
cd - >/dev/null
rm -rf "$TMP"

echo "Done. Local assets saved under $ASSETS_DIR. Open Internship.html directly or serve the folder."