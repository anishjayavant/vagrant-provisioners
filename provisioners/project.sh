#!/bin/zsh

# Note this script assumes that dotfiles have been checked out to /tmp/dotfiles in a previous step

echo "Setting up project environment..."

# Clone the project repository if provided
mkdir -p /home/vagrant/projects
if [ -n "$PROJECT_REPO_URL" ]; then
    cd /home/vagrant/projects
    git clone "$PROJECT_REPO_URL"
    chown -R vagrant:vagrant /home/vagrant/projects
else
    echo "No project repository URL provided. Skipping project clone."
fi

echo "Project setup complete."
