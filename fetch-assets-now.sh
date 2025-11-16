#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p assets/css assets/js assets/webfonts

echo "Downloading Bootstrap CSS..."
if ! curl -sSL -o assets/css/bootstrap.min.css "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"; then
  echo "Failed to download Bootstrap CSS" >&2
fi

echo "Downloading Bootstrap JS..."
if ! curl -sSL -o assets/js/bootstrap.bundle.min.js "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"; then
  echo "Failed to download Bootstrap JS" >&2
fi

echo "Downloading Font Awesome CSS..."
if ! curl -sSL -o assets/css/fontawesome.min.css "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"; then
  echo "Failed to download Font Awesome CSS" >&2
fi

echo "Downloading Font Awesome webfonts (multiple formats)..."
fonts=(fa-solid-900 fa-regular-400 fa-brands-400)
exts=(woff2 woff ttf svg eot)
for f in "${fonts[@]}"; do
  for ext in "${exts[@]}"; do
    url="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/${f}.${ext}"
    out="assets/webfonts/${f}.${ext}"
    if curl -sSfL -o "$out" "$url"; then
      echo "  -> $out"
    else
      echo "  (optional) missing $out"
      rm -f "$out" || true
    fi
  done
done

echo
ls -la assets/css || true
ls -la assets/js || true
ls -la assets/webfonts || true

echo "Done. If files downloaded, open Internship.html directly (offline) or serve the folder."