#!/bin/zsh

# Run this only after the UV installation
echo "Installing pre-commit using UV..."

# Source the UV environment
export PATH=/home/vagrant/.local/bin:$PATH
uv pip install --system pre-commit

echo "Pre-commit installation completed."
