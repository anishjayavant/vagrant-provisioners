#!/bin/zsh
echo "Installing Docker and Docker Compose..."

# Install Docker and Docker Compose
sudo apt update
sudo apt install -y docker.io docker-compose

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add vagrant user to the docker group
sudo usermod -aG docker vagrant

echo "Docker installation completed."
