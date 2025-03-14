#!/bin/zsh

echo "Installing Rust sqlx CLI..."

# Variables
USER="vagrant"
USER_HOME="/home/$USER"

# Install sqlx CLI
su - $USER -c "$USER_HOME/.cargo/bin/cargo install --version=0.8.3 sqlx-cli"
