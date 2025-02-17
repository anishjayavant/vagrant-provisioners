#!/bin/bash

# Default values
PROJECT_REPO_URL=""
PROVIDER="qemu"
VAGRANT_VAGRANTFILE=""

# Function to display usage
usage() {
  echo "Usage: $0 [-u <project_repo_url>] [-r <provider>] [-f <vagrantfile_path>]"
  echo "  -u    Git URL of the project repository"
  echo "  -r    Vagrant provider to use (default: qemu)"
  echo "  -f    Path to the Vagrantfile being loaded"
  exit 1
}

# Parse command-line options
while getopts ":u:r:f:h" opt; do
  case ${opt} in
    u )
      PROJECT_REPO_URL=$OPTARG
      ;;
    r )
      PROVIDER=$OPTARG
      ;;
    f )
      VAGRANT_VAGRANTFILE=$OPTARG
      ;;
    h )
      usage
      ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

# Validate project repository URL
if [ -z "$PROJECT_REPO_URL" ]; then
  echo "Error: Project repository URL is required."
  exit 1
fi

# Validate Vagrantfile path
if [ -z "$VAGRANT_VAGRANTFILE" ]; then
  echo "Error: Path to the Vagrantfile is required."
  exit 1
fi

# Pass environment variables explicitly to Vagrant
VAGRANT_ENV="PROJECT_REPO_URL=$PROJECT_REPO_URL"

# Start the Vagrant environment with the specified provider
echo "Starting development environment..."
echo "Project Repository URL: $PROJECT_REPO_URL"
echo "Vagrant Provider: $PROVIDER"
echo "Vagrantfile Path: $VAGRANT_VAGRANTFILE"

# Retry vagrant up up to 5 times if it fails
MAX_RETRIES=5
attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
  echo "Attempt $attempt of $MAX_RETRIES to start Vagrant environment..."
  if vagrant --project-repo-url=$PROJECT_REPO_URL up --provider=$PROVIDER; then
    echo "Vagrant environment started successfully."
    break
  else
    echo "Failed to start Vagrant environment. Retrying in 5 seconds..."
    sleep 5
  fi
  ((attempt++))
done

if [ $attempt -gt $MAX_RETRIES ]; then
  echo "Error: Failed to start Vagrant environment after $MAX_RETRIES attempts."
  vagrant destroy -f
  exit 1
fi
