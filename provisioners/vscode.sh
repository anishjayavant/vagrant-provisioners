#!/bin/zsh

# Note this script assumes that dotfiles have been checked out to /tmp/dotfiles in a previous step

echo "Setting up Visual Studio Code on the VM..."

if [ -z "$CODE_COMMIT_HASH" ]; then
  echo "Error: Commit hash for Visual Studio Code Server is required."
  exit 1
fi

DOTFILES_REPO="/tmp/dotfiles"

# Install wget
echo "Installing wget..."
apt-get install -y wget

# Installing dependencies
echo "Installing dependencies..."
apt-get install -y libx11-xcb1 libxcb-dri3-0 libdrm2 libgbm1 libnss3 libxkbfile1 libsecret-1-0 libgtk-3-0 libxss1 libasound2

# Make VSCode settings directory
mkdir -p /home/vagrant/.config/Code/User

# Change ownership of the .config directory
chown -R vagrant:vagrant /home/vagrant/.config

# Copy the VSCode settings from the dotfiles repository into the home directory
cp $DOTFILES_REPO/vscode/settings.json /home/vagrant/.config/Code/User/settings.json

# Copy keybindings.json
cp $DOTFILES_REPO/vscode/keybindings.json /home/vagrant/.config/Code/User/keybindings.json

# Install VSCode server
echo "Installing Visual Studio Code Server..."
wget -O /tmp/vscode-server.tar.gz 'https://update.code.visualstudio.com/commit:$CODE_COMMIT_HASH/server-linux-arm64/stable'
# Make the .vscode-server directory
mkdir -p /home/vagrant/.vscode-server
tar -xzf /tmp/vscode-server.tar.gz -C /home/vagrant/.vscode-server --strip-components=1
# Change ownership of the .vscode-server directory
chown -R vagrant:vagrant /home/vagrant/.vscode-server
# Remove the downloaded tarball
rm /tmp/vscode-server.tar.gz
echo "Visual Studio Code Server installed."

# Install extensions
if [ -f "$DOTFILES_REPO/vscode/extensions.txt" ]; then
    echo "Installing VSCode extensions..."
    # Locate the code binary
    CODE_BIN=$(find /home/vagrant/.vscode-server/bin -name "code" -type f)

    if [ -z "$CODE_BIN" ]; then
        echo "VSCode Server binary not found!"
        exit 1
    fi

    # Install extensions using the code binary
    while IFS= read -r extension; do
        echo "Installing VSCode extension $extension..."
        sudo -u vagrant $CODE_BIN --install-extension "$extension" --force
    done <"$DOTFILES_REPO/vscode/extensions.txt"
else
    echo "No extensions list found in the dotfiles repository."
fi

echo "Visual Studio Code setup complete."
