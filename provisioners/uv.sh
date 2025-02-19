#!/bin/zsh

echo "Installing UV..."

# Update package list
sudo apt-get update

# Install dependencies
sudo apt-get install -y curl

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

echo "UV installation completed."