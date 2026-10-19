#!/usr/bin/env bash
# Build the Beamer presentation.
#   - Intermediate artifacts go to ./build/
#   - Final PDF is copied to ./main.pdf
#
# Usage:
#   ./build.sh           # build main.tex
#   ./build.sh foo.tex   # build foo.tex (output: foo.pdf)
#   ./build.sh clean     # remove build/ and copied PDF

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$ROOT_DIR/build"

cd "$ROOT_DIR"

if [[ "${1:-}" == "clean" ]]; then
    rm -rf "$BUILD_DIR"
    rm -f ./*.pdf
    echo "Cleaned."
    exit 0
fi

SRC="${1:-main.tex}"
if [[ ! -f "$SRC" ]]; then
    echo "Error: $SRC not found" >&2
    exit 1
fi

BASENAME="$(basename "$SRC" .tex)"

mkdir -p "$BUILD_DIR"

# xelatex: faster than lualatex on this deck (~30% locally, more on
# Overleaf cold starts) and produces a smaller PDF. Both engines
# satisfy `fontspec` and the `pdfpc` package's note encoding (UTF-16BE
# for CJK). Do NOT enable `\setbeameroption{show notes on second
# screen=...}` under xelatex -- known bug drops body content of every
# frame after the first; we sidestep it by using \pdfpcnote instead.
# latexmk handles the two passes the navbar needs (frame counts round-trip
# through the .aux file). Without it, run xelatex twice by hand.
if command -v latexmk >/dev/null 2>&1; then
    latexmk -xelatex -interaction=nonstopmode -halt-on-error \
        -output-directory="$BUILD_DIR" "$SRC"
else
    echo "latexmk not found; running xelatex twice instead."
    for pass in 1 2; do
        xelatex -interaction=nonstopmode -halt-on-error \
            -output-directory="$BUILD_DIR" "$SRC"
    done
fi

cp "$BUILD_DIR/$BASENAME.pdf" "$ROOT_DIR/$BASENAME.pdf"
echo "==> $ROOT_DIR/$BASENAME.pdf"
