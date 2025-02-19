#!/bin/zsh

echo "Installing UV..."

# Update package list
sudo apt-get update

# Install dependencies
sudo apt-get install -y curl

# Install uv as the vagrant user
sudo -u vagrant curl -LsSf https://astral.sh/uv/install.sh | sudo -u vagrant sh

# Add uv to the PATH
echo "source /home/vagrant/.local/bin/env" | tee -a /home/vagrant/.zshrc

echo "UV installation completed."