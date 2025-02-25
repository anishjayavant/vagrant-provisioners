#!/bin/zsh

echo "Installing Rust sqlx CLI..."

# Variables
USER="vagrant"
USER_HOME="/home/$USER"
CARGO_ENV="$USER_HOME/.cargo/env"

# Install sqlx CLI
su - $USER -c "$USER_HOME/.cargo/bin/cargo install --version=0.8.3 sqlx-cli"
