#!/bin/zsh

echo "Setting up OpenSSL configuration..."
sudo apt-get update
sudo apt-get install -y libssl-dev pkg-config
# Add the following to the .zshrc
echo 'export OPENSSL_DIR="/usr"' | tee -a /home/vagrant/.zshrc
echo 'export OPENSSL_LIB_DIR="/usr/lib/aarch64-linux-gnu"' | tee -a /home/vagrant/.zshrc
echo 'export OPENSSL_INCLUDE_DIR="/usr/include"' | tee -a /home/vagrant/.zshrc
echo 'export PKG_CONFIG_PATH="/usr/lib/aarch64-linux-gnu/pkgconfig"' | tee -a /home/vagrant/.zshrc
echo "OpenSSL configuration setup complete."
