#!/bin/zsh

# Note this script assumes that dotfiles have been checked out to /tmp/dotfiles in a previous step

echo "Setting up project environment..."

# Clone the project repository if provided
mkdir -p /home/vagrant/projects
if [ -n "$PROJECT_REPO_URL" ]; then
    cd /home/vagrant/projects
    git clone "$PROJECT_REPO_URL"
    chown -R vagrant:vagrant /home/vagrant/projects
    # Add a zshrc alias called 'ph' to change to the project directory
    echo "alias ph='cd /home/vagrant/projects/$(basename $PROJECT_REPO_URL .git)'" | tee -a /home/vagrant/.zshrc
    echo "Project repository cloned to /home/vagrant/projects/$(basename $PROJECT_REPO_URL .git)"
    # Run pre-commit install in the project directory
    cd /home/vagrant/projects/$(basename $PROJECT_REPO_URL .git)
    pre-commit install
    echo "Pre-commit installed in the project repository."
else
    echo "No project repository URL provided. Skipping project clone."
fi

echo "Project setup complete."
