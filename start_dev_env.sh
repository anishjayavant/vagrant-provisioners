#!/bin/zsh

# Default values
PROJECT_REPO_URL=""
PROVIDER="qemu"
VAGRANT_VAGRANTFILE=""
CODE_COMMIT_HASH="e54c774e0add60467559eb0d1e229c6452cf8447"

# Function to display usage
usage() {
  echo "Usage: $0 [-u <project_repo_url>] [-r <provider>] [-f <vagrantfile_path>]"
  echo "  -u    Git URL of the project repository"
  echo "  -r    Vagrant provider to use (default: qemu)"
  echo "  -f    Path to the Vagrantfile being loaded"
  exit 1
}

# Function to copy GPG keys to the VM
gpg_copy_to_vm() {

  echo "Importing GPG keys..."
  # TODO add interactive prompt with 5s timeout

  GPG_SECRET_KEY="$HOME/gpg-secret-key.asc"
  GPG_PUBLIC_KEY="$HOME/gpg-public-key.asc"

  # Export GPG keys if they don't exist
  if [ ! -f "$GPG_SECRET_KEY" ]; then
    echo "Exporting GPG keys..."
    gpg --export-secret-keys --armor --output "$GPG_SECRET_KEY"
    gpg --export --armor --output "$GPG_PUBLIC_KEY"
  fi

  # Copy GPG keys to the VM using vagrant file provisioner
  echo "Copying GPG keys to the Vagrant VM..."
  vagrant ssh -c "mkdir -p /home/vagrant/.gnupg"
  vagrant ssh -c "cat > /home/vagrant/gpg-secret-key.asc" <"$GPG_SECRET_KEY"
  vagrant ssh -c "cat > /home/vagrant/gpg-public-key.asc" <"$GPG_PUBLIC_KEY"

  # Import the GPG keys inside the VM
  vagrant ssh -c "
    gpg --import /home/vagrant/gpg-public-key.asc && \
    gpg --allow-secret-key-import --import /home/vagrant/gpg-secret-key.asc && \
    rm /home/vagrant/gpg-public-key.asc /home/vagrant/gpg-secret-key.asc
  "
}

# Parse command-line options
while getopts ":u:r:f:h" opt; do
  case ${opt} in
  u)
    PROJECT_REPO_URL=$OPTARG
    ;;
  r)
    PROVIDER=$OPTARG
    ;;
  f)
    VAGRANT_VAGRANTFILE=$OPTARG
    ;;
  h)
    usage
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    usage
    ;;
  :)
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

# Validate Code commit hash
if [ -z "$CODE_COMMIT_HASH" ]; then
  echo "Error: Commit hash for Visual Studio Code Server is required."
  exit 1
fi

# Validate Vagrantfile path
if [ -z "$VAGRANT_VAGRANTFILE" ]; then
  echo "Error: Path to the Vagrantfile is required."
  exit 1
fi

# Get the commit hash for the Visual Studio Code Server
CODE_COMMIT_HASH=$(code --version | sed -n '2p')

# Start the Vagrant environment with the specified provider
echo "Starting development environment..."
echo "Project Repository URL: $PROJECT_REPO_URL"
echo "Vagrant Provider: $PROVIDER"
echo "Vagrantfile Path: $VAGRANT_VAGRANTFILE"
echo "VSCode Commit Hash: $CODE_COMMIT_HASH"

# Retry vagrant up up to 5 times if it fails
MAX_RETRIES=5
attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
  echo "Attempt $attempt of $MAX_RETRIES to start Vagrant environment..."
  if vagrant --project-repo-url=$PROJECT_REPO_URL --code-commit-hash=$CODE_COMMIT_HASH up --provider=$PROVIDER; then
    echo "Vagrant environment started successfully."
    echo "Copying GPG keys to the Vagrant VM..."
    gpg_copy_to_vm
    echo "GPG keys copied successfully."
    echo "Run $(echo "test" | gpg --clearsign --pinentry-mode loopback) on the VM one-time to enter the passphrase and enable signing."
    echo "Vagrant environment is ready for use."
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
