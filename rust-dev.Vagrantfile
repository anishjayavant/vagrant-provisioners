require 'getoptlong'

# Parse command line arguments
opts = GetoptLong.new(
  ['--project-repo-url', GetoptLong::REQUIRED_ARGUMENT]
)

# Define the project repository URL
project_repo_url = nil
opts.ordering = GetoptLong::REQUIRE_ORDER
opts.each do |opt, arg|
  case opt
  when '--project-repo-url'
    project_repo_url = arg
  end
end

# Vagrantfile for Rust development using QEMU
Vagrant.configure("2") do |config|    
    # Define the Ubuntu VM (using aarch64-compatible image)
    config.vm.define "ubuntu"
    config.vm.box = "perk/ubuntu-2204-arm64"
    config.vm.hostname = "rust-dev"
  
    # Use QEMU as the provider
    config.vm.provider "qemu" do |q|
        q.ssh_port = "2201" 
        q.cpu = "host"
        q.cpus = 4
        q.memory = "4G"
        q.graphics = "none"
        q.ssh_auto_correct = true
        q.machine_type = "virt,accel=hvf,highmem=off"
    end
  
    # Provisioning scripts
    # 1. Setup SSH forwarding and clone the provisioners repository
    config.ssh.forward_agent = true
    # Set the project repo URL as an environment variable
    config.vm.provision "shell", env: { PROJECT_REPO_URL: project_repo_url }, inline: <<-SHELL
    echo "Setting up Git..."
    # Ensure SSH agent forwarding is working
    if [ -z "$SSH_AUTH_SOCK" ]; then
        echo "SSH agent forwarding is not enabled. Please ensure your SSH agent is running and forwarding is enabled."
        exit 1
    fi

    # Add Git server to known hosts
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts

    # Clone the provisioners repository
    git clone git@github.com:anishjayavant/vagrant-provisioners.git /tmp/vagrant-provisioners

    # Clone the dotfiles repository and update the gitconfig on the target machine
    git clone git@github.com:anishjayavant/dotfiles.git /tmp/dotfiles

    # Copy the .gitconfig from the dotfiles repository into the home directory
    cp /tmp/dotfiles/.gitconfig /home/vagrant/.gitconfig

    # Copy the GPG configuration from the dotfiles repository into the home directory
    cp /tmp/dotfiles/.gnupg/gpg.conf /home/vagrant/.gnupg/gpg.conf
    cp /tmp/dotfiles/.gnupg/gpg-agent-ubuntu.conf /home/vagrant/.gnupg/gpg-agent.conf

    # Clone the project repository if provided
    mkdir -p /home/vagrant/projects
    if [ -n "$PROJECT_REPO_URL" ]; then
      cd /home/vagrant/projects
      git clone "$PROJECT_REPO_URL"
      chown -R vagrant:vagrant /home/vagrant/projects
    else
      echo "No project repository URL provided. Skipping project clone."
    fi
    echo "Git setup complete."
    SHELL

    # 2. Run the provisioners
    # Zsh
    config.vm.provision "shell", inline: "/tmp/vagrant-provisioners/provisioners/zsh.sh"

    # Rust
    config.vm.provision "shell", inline: "/tmp/vagrant-provisioners/provisioners/rust.sh"

    # Docker
    config.vm.provision "shell", inline: "/tmp/vagrant-provisioners/provisioners/docker.sh"

    # Clean up
    config.vm.provision "shell", inline: <<-SHELL
    # Remove the provisioners repository
    rm -rf /tmp/vagrant-provisioners
    # Remove the dotfiles repository
    rm -rf /tmp/dotfiles

    # Run ssh-keyscan to add GitHub to known hosts for /home/vagrant/.ssh/known_hosts
    ssh-keyscan -H github.com >> /home/vagrant/.ssh/known_hosts
    # Change ownership of the .ssh directory and known_hosts file
    chown -R vagrant:vagrant /home/vagrant/.ssh
    echo "Cleanup complete."
    SHELL

    # Reboot
    config.vm.provision "shell", inline: "echo 'Rebooting...'", reboot: true

    # Print a message that provisioning is complete
    config.vm.provision "shell", inline: "echo 'Provisioning complete. You can now SSH into the VM using `vagrant ssh`. Or run the following command `vagrant ssh-config | tee -a ~/.ssh/config`'"
  
  end
  