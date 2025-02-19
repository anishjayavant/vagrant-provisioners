#!/bin/zsh

# Run this only after the UV installation
echo "Installing pre-commit using UV..."

# Install pre-commit as the vagrant user
sudo -u vagrant uv pip install pre-commit

echo "Pre-commit installation completed."