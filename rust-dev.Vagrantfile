# Vagrantfile for Rust development using QEMU
Vagrant.configure("2") do |config|    
    # Define the Ubuntu VM (using aarch64-compatible image)
    config.vm.define "ubuntu"
    config.vm.box = "perk/ubuntu-2204-arm64"
    config.vm.hostname = "rust-dev"
  
    # Use QEMU as the provider
    config.vm.provider "qemu" do |q|
        q.ssh_port = "9999" 
        q.cpu = "host"
        q.cpus = 4
        q.memory = "2048"
        q.graphics = "none"
    end
  
    # Provisioning scripts
    # 1. Setup SSH forwarding and clone the provisioners repository
    config.ssh.forward_agent = true
    config.vm.provision "shell", inline: <<-SHELL
    # Ensure SSH agent forwarding is working
    if [ -z "$SSH_AUTH_SOCK" ]; then
        echo "SSH agent forwarding is not enabled. Please ensure your SSH agent is running and forwarding is enabled."
        exit 1
    fi

    # Add Git server to known hosts
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts

    # Clone the provisioners repository
    git clone git@github.com:anishjayavant/vagrant-provisioners.git /tmp/vagrant-provisioners

    # Clone the project repository if provided
    mkdir -p /home/vagrant/projects
    if [ -n "$PROJECT_REPO" ]; then
      git clone "$PROJECT_REPO" /home/vagrant/projects
      chown -R vagrant:vagrant /home/vagrant/projects
    else
      echo "No project repository URL provided. Skipping project clone."
    fi
    SHELL

    # 2. Run the provisioners
    # Zsh
    config.vm.provision "shell", inline: "/tmp/vagrant-provisioners/provisioners/zsh.sh"

    # Rust
    # config.vm.provision "shell", inline: "/tmp/vagrant-provisioners/provisioners/rust.sh"

    # Docker
    # config.vm.provision "shell", path: "/tmp/vagrant-provisioners/provisioners/docker.sh"

    # Clean up
    # config.vm.provision "shell", inline: "rm -rf /tmp/vagrant-provisioners"

  
  end
  