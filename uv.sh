#!/bin/zsh

# Update package list
sudo apt-get update

# Install dependencies
sudo apt-get install -y curl

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
uv --version
