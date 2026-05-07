#!/bin/bash
# Build both Chinese and English versions of the site

set -e

echo "Building Chinese version (zh)..."
QUARTO_PYTHON=.venv/bin/python quarto render

echo ""
echo "Building English version (en)..."
cd en
QUARTO_PYTHON=../.venv/bin/python quarto render
cd ..

echo ""
echo "✓ Both versions built successfully!"
echo "  - Chinese: docs/index.html"
echo "  - English: docs/en/index.html"
