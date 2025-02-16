#!/bin/zsh

# Variables
USER="vagrant"
USER_HOME="/home/$USER"
PROJECT_DIR="$USER_HOME/rust_python_project"
source $USER_HOME/.zshrc

# Ensure uv is installed
if ! command -v uv &> /dev/null; then
    echo "uv is not installed. Please run uv_install.sh first."
    exit 1
fi

# Install the latest Python version using uv
uv python install

# Create a virtual environment for the project
uv venv $PROJECT_DIR/venv

# Activate the virtual environment and install maturin
source $PROJECT_DIR/venv/bin/activate
uv pip install maturin

# Verify installations
python --version
maturin --version

# Deactivate the virtual environment
deactivate

echo "Pyo installation completed."
