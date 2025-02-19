#!/bin/zsh

DOTFILES_REPO="/tmp/dotfiles"
echo "Setting up Git configuration and GPG keys..."

# Note this script assumes that dotfiles have been checked out to /tmp/dotfiles in a previous step
# Copy the .gitconfig from the dotfiles repository into the home directory
cp $DOTFILES_REPO/git/.gitconfig /home/vagrant/.gitconfig

# Copy the GPG configuration from the dotfiles repository into the home directory
mkdir -p /home/vagrant/.gnupg
# Change ownership of the .gnupg directory
chown -R vagrant:vagrant /home/vagrant/.gnupg
cp $DOTFILES_REPO/gpg/gpg.conf /home/vagrant/.gnupg/gpg.conf
cp $DOTFILES_REPO/gpg/gpg-agent-ubuntu.conf /home/vagrant/.gnupg/gpg-agent.conf
# Set permissions to 700 for the vagrant user
chmod 700 /home/vagrant/.gnupg
# Set permissions to 600 for the files
chmod 600 /home/vagrant/.gnupg/gpg.conf
chmod 600 /home/vagrant/.gnupg/gpg-agent.conf

# Copy gpg.sh to the home directory
cp $DOTFILES_REPO/gpg/gpg.sh /home/vagrant/gpg.sh
# Change ownership of the gpg.sh script
chown vagrant:vagrant /home/vagrant/gpg.sh

# Add the following to the .zshrc
echo "export GPG_TTY=$(tty)" | tee -a /home/vagrant/.zshrc
echo "gpgconf --launch gpg-agent" | tee -a /home/vagrant/.zshrc

echo "Git configuration and GPG keys setup complete."