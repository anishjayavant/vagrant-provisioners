#!/bin/zsh

# Run this only after the UV installation
echo "Installing pre-commit using UV..."

# Install pre-commit
uv pip install --system pre-commit

echo "Pre-commit installation completed."