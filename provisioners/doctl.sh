#!/bin/zsh

# Update package lists
sudo apt update -y

# Install prerequisites
sudo apt install -y curl

# Download and install doctl
curl -sL https://github.com/digitalocean/doctl/releases/latest/download/doctl-$(uname -s)-$(uname -m).tar.gz | tar xzv
sudo mv doctl /usr/local/bin

# Verify installation
doctl version
echo "doctl installation completed."