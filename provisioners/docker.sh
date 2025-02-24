#!/bin/zsh
echo "Installing Docker and Docker Compose..."

# Install Docker and Docker Compose
sudo apt-get update
sudo apt-get install -y docker.io

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add vagrant user to the docker group
sudo usermod -aG docker vagrant

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
# Apply executable permissions to the Docker Compose binary for all users
sudo chmod +x /usr/bin/docker-compose
# Enable BuildKit for Docker Compose by adding the following line to the .zshrc file for the vagrant user
echo "export DOCKER_BUILDKIT=1" | tee -a /home/vagrant/.zshrc

echo "Docker installation completed."
