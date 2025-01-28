#!/bin/bash

set -e
# set -x

function install_configure_docker_nvidia {
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
    gum log "Installing nvidia-container-toolkit..."
    sudo apt-get install -y nvidia-container-toolkit
    gum log "Configuring nvidia-container-runtime..."
    sudo nvidia-ctk runtime configure --runtime=docker
}

function install_configure_docker_amd {
    # Install rocm-docker
    curl -s -L https://rocmdocs.amd.com/en/latest/Installation_Guide/Installation-Guide.html#installing-rocm-docker \
        | sudo bash
}

# If --help is passed, show help
if [ "$1" == "--help" ]; then
    gum log "Usage: $0 [--uninstall]"
    exit 0
fi

# If --uninstall is passed, uninstall nvidia-docker
if [ "$1" == "--uninstall" ]; then
    gum log "Uninstalling nvidia-docker..."
    set +e
    sudo apt-get purge -y nvidia-container-toolkit
    sudo rm /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo rm /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    exit 0
fi

# If not on debian, bail out
if [ ! -f /etc/debian_version ]; then
    gum log --level fatal "This script is only for debian based systems"
    exit 1
fi

# Bail if docker isn't already installed
if ! [ -x "$(command -v docker)" ]; then
    gum log --level fatal "Docker is not installed. Please install docker first"
    exit 1
fi

# Bail if curl isn't already installed
if ! [ -x "$(command -v curl)" ]; then
    gum log --level fatal "curl is not installed. Please install curl first"
    exit 1
fi

# Detect nvidia vs amd
if lspci | grep -i nvidia; then
    gum log "Nvidia GPU detected"
    # Install nvidia-docker
    install_configure_docker_nvidia
else
    gum log "Guessing that it's an AMD GPU :shrug:"
    # Install rocm-docker
    install_configure_docker_amd
fi
sudo systemctl restart docker
