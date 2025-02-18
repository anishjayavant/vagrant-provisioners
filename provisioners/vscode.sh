#!/bin/zsh

# Note this script assumes that dotfiles have been checked out to /tmp/dotfiles in a previous step

echo "Installing Visual Studio Code..."
DOTFILES_REPO="/tmp/dotfiles"

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
curl -fsSL https://code.visualstudio.com/sha/download?build=stable &
os=linux-x64 | tar -xz -C /home/vagrant/.vscode-server
# Change ownership of the .vscode-server directory
chown -R vagrant:vagrant /home/vagrant/.vscode-server
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
        $CODE_BIN --install-extension "$extension" --force
    done <"$DOTFILES_REPO/vscode/extensions.txt"
else
    echo "No extensions list found in the dotfiles repository."
fi

echo "Visual Studio Code setup complete."
