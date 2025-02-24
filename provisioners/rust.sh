#!/bin/zsh

echo "Installing Rust toolchain..."

# Variables
USER="vagrant"
USER_HOME="/home/$USER"
CARGO_ENV="$USER_HOME/.cargo/env"

# Update package list
sudo apt-get update

# Install dependencies
sudo apt-get install -y curl build-essential

# Install rustup (Rust installer and version manager) as the vagrant user
su - $USER -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"

# Install sqlx CLI
su - $USER -c "$USER_HOME/.cargo/bin/cargo install --version=0.8.3 sqlx-cli"

# Source the cargo environment for the current session
if [ -f "$CARGO_ENV" ]; then
  source "$CARGO_ENV"
fi

echo "Rust toolchain installation completed."
