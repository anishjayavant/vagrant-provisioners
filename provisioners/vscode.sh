#!/bin/zsh

# Note this script assumes that dotfiles have been checked out to /tmp/dotfiles in a previous step

echo "Installing Visual Studio Code..."

# Make VSCode settings directory
mkdir -p /home/vagrant/.config/Code/User

# Change ownership of the .config directory
chown -R vagrant:vagrant /home/vagrant/.config

# Copy the VSCode settings from the dotfiles repository into the home directory
cp /tmp/dotfiles/vscode/settings.json /home/vagrant/.config/Code/User/settings.json

# Copy keybindings.json
cp /tmp/dotfiles/vscode/keybindings.json /home/vagrant/.config/Code/User/keybindings.json

# TODO install extensions

echo "Visual Studio Code setup complete."
