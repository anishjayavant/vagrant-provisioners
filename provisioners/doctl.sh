#!/bin/zsh

# Update package lists
sudo apt update -y

# Install prerequisites
sudo apt install -y curl jq

# Detect architecture and normalize it for DigitalOcean naming
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
    ARCH="arm64" # Convert aarch64 to arm64 for DigitalOcean
fi

# Get the latest version of doctl from GitHub API
LATEST_VERSION=$(curl -s https://api.github.com/repos/digitalocean/doctl/releases/latest | jq -r .tag_name | sed 's/v//')

# Construct the correct download URL
DOCTL_URL="https://github.com/digitalocean/doctl/releases/download/v${LATEST_VERSION}/doctl-${LATEST_VERSION}-linux-${ARCH}.tar.gz"

echo "Downloading doctl from: $DOCTL_URL"

# Download doctl
curl -sL $DOCTL_URL -o doctl.tar.gz

# Extract and install
tar xzvf doctl.tar.gz
sudo mv doctl /usr/local/bin/
rm doctl.tar.gz

# Verify installation
doctl version
