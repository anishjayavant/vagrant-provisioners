# Development Environment Setup
This repository contains Vagrant provisioners to automate development environment setup. It includes scripts for configuring various tools, an example [`Vagrantfile` for Rust development](./rust-dev.Vagrantfile), and a [`start_dev_env`](./start_dev_env.sh) script for easy provisioning. The goal is to create reproducible environments that can be spun up or torn down on demand, avoiding reliance on local machine configurations.


# Provisioners Repository
The scripts use [Hashicorp Vagrant](https://www.vagrantup.com/docs) and my [dotfiles](https://github.com/anishjayavant/dotfiles)

## Provisioners

### Git configuration 
---
[git.sh](./provisioners/git.sh) sets up Git with your user information and preferred settings. It includes:

- Configuring your name and email for Git commits.
- Setting up aliases for common Git commands.
- Enabling useful Git settings like color output and credential caching.
- Sets up import of any GPG signing keys for commit verification on GitHub

The setup requires [SSH access to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) and uses agent forwarding for Git operations.

### Zsh setup
---
[zsh.sh](./provisioners/zsh.sh) sets up the Z shell (Zsh) environment using Oh My Zsh, a popular framework for managing Zsh configuration. This setup includes a couple of standard Zsh plugins to enhance your shell experience:

- **git**: Provides useful aliases and functions for Git.
- **fzf**: A general-purpose command-line fuzzy finder.
- **zsh-autosuggestions**: Suggests commands as you type based on your command history.

With these plugins, your Zsh environment will be more powerful and user-friendly.

### OpenSSL configuration
---
[openssl.sh](./provisioners/openssl.sh) sets up OpenSSL by installing the necessary packages and configuring the environment. This provisioner ensures that your development environment has the required cryptographic libraries and tools for secure communication and data encryption.

### Docker setup
---
[docker.sh](./provisioners/docker.sh) sets up Docker by installing the Docker Engine and Docker Compose. This provisioner ensures that your development environment is capable of running containerized applications. It includes:

- Installing the latest version of Docker Engine.
- Installing Docker Compose for managing multi-container Docker applications.
- Adding your user to the Docker group to allow running Docker commands without sudo.

With this provisioner, you can easily build, run, and manage Docker containers in your development environment.

### Rust environment
---
[rust.sh](./provisioners/rust.sh) sets up a complete Rust development environment. It includes:

- Installing Rust using `rustup`, the Rust toolchain installer.
- Setting up Cargo, the Rust package manager.
- Installing common Rust tools and libraries, such as `clippy` for linting and `rustfmt` for code formatting.
- Configuring the environment to include the Rust toolchain in the system PATH.

With this provisioner, you can start developing Rust applications with all the necessary tools and configurations in place.

### UV setup
---
`uv` is an extremely fast Python package and project manager, written in Rust and fully compatible with existing Python package managers such as pip, pip-tools, pipx, poetry, pyenv, twine, virtualenv, and more
[uv.sh](./provisioners/uv.sh) installs uv on the dev system and adds it to the `PATH`

### VSCode 
---
[vscode.sh](./provisioners/vscode.sh) installs a matching version of VSCode server on the development VM. Note that extensions have to be enabled through the integrated terminal or the UI once you connect to the devbox via SSH

### PreCommit
---
[pre-commit.sh](./provisioners/pre-commit.sh) installs [pre-commit](https://pre-commit.com/). Configurations for desired hooks should be enabled in the target repository that will be worked upon

### Project checkout
---
[project.sh](./provisioners/project.sh) checks out the project of your choice


## Vagrantfile
The `rust-dev` Vagrantfile is configured to create a virtual machine with all the necessary tools for Rust development. It uses the Rust provisioner in concert with a few of the other provisioners listed above to ensure the environment is ready for development as soon as the VM is up and running.

## Start Development Environment Script
The `start_dev_env` is a wrapper script that automates the process of starting the development environment. It initializes the Vagrant VM and runs the appropriate provisioners to set up the environment. 

```bash
./start_dev_env.sh -u git@github.com:anishjayavant/prodcast.git -r qemu -f ./rust-dev.Vagrantfile
```

### Parameters
---
- `-u`: Specifies the URL of the Git repository to clone. In this case, it is `git@github.com:anishjayavant/prodcast.git`.
- `-r`: Specifies the provider to use for the Vagrant VM. Here, `qemu` is used as the provider. See the [Vagrant provider docs page](https://developer.hashicorp.com/vagrant/docs/providers) for more information.
- `-f`: Specifies the path to the Vagrantfile to use. In this example, it is `./rust-dev.Vagrantfile`.

### SSH to the box
---
Once provisioning completes, you'll see a message like this:
```bash
Provisioning complete. You can now SSH into the VM using `vagrant ssh`. Or run the following command `vagrant ssh-config | tee -a ~/.ssh/config`
```
Append or replace the configuration to `~/.ssh/config` and run `ssh rust-dev` !

### Tearing down the environment
---
Simply run the following commands
```bash
export VAGRANT_VAGRANTFILE=rust-dev.Vagrantfile
## Ensure name passed to `vagrant destroy` matches the configuration in the Vagrantfile 
vagrant destroy rust-dev -f
```