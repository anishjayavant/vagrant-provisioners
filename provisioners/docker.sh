#!/bin/zsh
echo "Installing Docker and Docker Compose..."
USER="vagrant"

# Install Docker and Docker Compose
sudo apt-get update
sudo apt-get install -y docker.io

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add vagrant user to the docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
# Apply executable permissions to the Docker Compose binary for all users
sudo chmod +x /usr/bin/docker-compose
# Enable BuildKit for Docker Compose by adding the following line to the .zshrc file for the vagrant user
echo "export DOCKER_BUILDKIT=1" | tee -a /home/$USER/.zshrc

# Install buildx for the vagrant user
curl -fsSL https://github.com/docker/buildx/releases/download/v0.21.0/buildx-v0.21.0.linux-arm64 -o /home/$USER/.docker/cli-plugins/docker-buildx
# Grant executable permissions to the buildx binary for the vagrant user
chmod +x /home/$USER/.docker/cli-plugins/docker-buildx

echo "Docker installation completed."
