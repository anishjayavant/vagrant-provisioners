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
wget -O /tmp/vscode-server.tar.gz "https://update.code.visualstudio.com/commit:$CODE_COMMIT_HASH/server-linux-arm64/stable"
# Make the .vscode-server directory
mkdir -p /home/vagrant/.vscode-server
tar -xzf /tmp/vscode-server.tar.gz -C /home/vagrant/.vscode-server --strip-components=1
# Change ownership of the .vscode-server directory
chown -R vagrant:vagrant /home/vagrant/.vscode-server
# Remove the downloaded tarball
rm /tmp/vscode-server.tar.gz
echo "Visual Studio Code Server installed."

# Copy the extensions list; these will have to be installed
# on the integrated terminal by design. See https://github.com/microsoft/vscode-remote-release/issues/1042#issuecomment-515691156
if [ -f "$DOTFILES_REPO/vscode/extensions.txt" ]; then
    mkdir -p /home/vagrant/vscode
    cp $DOTFILES_REPO/vscode/extensions.txt /home/vagrant/vscode/extensions.txt
    cp $DOTFILES_REPO/vscode/install_extensions.sh /home/vagrant/vscode/install_extensions.sh
    chown vagrant:vagrant /home/vagrant/vscode
fi

echo "Visual Studio Code setup complete."
