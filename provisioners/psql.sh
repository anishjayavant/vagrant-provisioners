#!/bin/bash

set -e

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install PostgreSQL client (psql only)
echo "Installing PostgreSQL client..."
sudo apt-get install -y postgresql-client

echo "PostgreSQL client (psql) installation complete."
