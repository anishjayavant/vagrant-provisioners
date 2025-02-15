#!/bin/bash

# Variables
USER="vagrant"
USER_HOME="/home/$USER"
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"

# Update package list
sudo apt-get update

# Install Zsh
sudo apt-get install -y zsh

# Install curl and git if not present
sudo apt-get install -y curl git

# Install Oh My Zsh for the vagrant user
su - $USER -c "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" --unattended"

# Change default shell to Zsh for the vagrant user
sudo chsh -s $(which zsh) $USER

# Set ownership of .zshrc to vagrant user
sudo chown $USER:$USER $USER_HOME/.zshrc

# Install fzf (Command-line fuzzy finder)
su - $USER -c "git clone --depth 1 https://github.com/junegunn/fzf.git $USER_HOME/.fzf"
su - $USER -c "$USER_HOME/.fzf/install --all"

# Install zsh-autosuggestions plugin
su - $USER -c "git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Install zsh-syntax-highlighting plugin
su - $USER -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Add plugins to .zshrc if not already present
if ! grep -q "plugins=(.*fzf.*zsh-autosuggestions.*zsh-syntax-highlighting.*)" $USER_HOME/.zshrc; then
  sed -i 's/plugins=(/plugins=(fzf zsh-autosuggestions zsh-syntax-highlighting /' $USER_HOME/.zshrc
fi

# Source the plugins in .zshrc
echo "source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $USER_HOME/.zshrc
echo "source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $USER_HOME/.zshrc

# Set ownership of .oh-my-zsh directory to vagrant user
sudo chown -R $USER:$USER $ZSH_CUSTOM

# Reload .zshrc to apply changes
su - $USER -c "source $USER_HOME/.zshrc"
