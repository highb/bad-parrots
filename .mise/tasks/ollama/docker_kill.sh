#!/bin/bash

set -e
set -x

# If the container is already running, ask if the user wants to stop it
if gum confirm "Stop ollama?"; then
    sudo docker stop ollama
    if gum confirm "Remove the container?"; then
        sudo docker rm ollama
    fi
fi
