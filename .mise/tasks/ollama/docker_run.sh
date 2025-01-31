#!/bin/bash

set -e
set -x

if [ -z "${OLLAMA_DIR}" ]; then
    echo "OLLAMA_DIR is not set. Please set it to the directory where you want to store Ollama data"
    exit 1
fi

# If the directory doesn't exist, create it
if [ ! -d "${OLLAMA_DIR}" ]; then
    if gum confirm "Directory ${OLLAMA_DIR} does not exist. Create it?"; then
        mkdir -p "${OLLAMA_DIR}"
    else
        exit 1
    fi
fi

# If the container is already running, ask if the user wants to stop it
if sudo docker ps -a | grep -q ollama; then
    if gum confirm "Ollama container is already running. Stop it?"; then
        sudo docker stop ollama
        if gum confirm "Remove the container?"; then
            sudo docker rm ollama
        fi
    else
        exit 0
    fi
fi

if lspci | grep -i nvidia; then
    # If nvidia, run with --gpus=all
    sudo docker run --runtime=nvidia -d --gpus=all -v "${OLLAMA_DIR}":/root/.ollama -p 11434:11434  --name ollama ollama/ollama
    # Expose to LAN at your own risk lol
    #sudo docker run --runtime=nvidia -d --gpus=all -v "${OLLAMA_DIR}":/root/.ollama -p 10.0.30.10:11434:11434  --name ollama ollama/ollama
else
    sudo docker run -d --device /dev/kfd --device /dev/dri -v "${OLLAMA_DIR}":/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
fi
