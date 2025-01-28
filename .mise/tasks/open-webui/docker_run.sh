#!/bin/bash

set -x
set -e

# If required env are unset, fail
if [ -z "${OPEN_WEBUI_DIR}" ]; then
    echo "OPEN_WEBUI_DIR is not set. Please set it to the directory where you want to store Open WebUI data"
    exit 1
fi

if [ -z "${OPEN_WEBUI_VERSION}" ]; then
    echo "OPEN_WEBUI_VERSION is not set. Please set it to the version of Open WebUI you want to run"
    exit 1
fi

# Create volume dir, if it doesn't exist
if [ ! -d "${OPEN_WEBUI_DIR}" ]; then
    if gum confirm "Directory ${OPEN_WEBUI_DIR} does not exist. Create it?"; then
        mkdir -p "${OPEN_WEBUI_DIR}"
    else
        exit 1
    fi
fi

# If the container is already running, ask if the user wants to stop it
if sudo docker ps -a | grep -q open-webui; then
    if gum confirm "Open WebUI container is already running. Stop it?"; then
        sudo docker stop open-webui
        if gum confirm "Remove the container?"; then
            sudo docker rm open-webui
        fi
    else
        exit 0
    fi
fi

sudo docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v "${OPEN_WEBUI_DIR}":/app/backend/data --name open-webui --restart always "ghcr.io/open-webui/open-webui:${OPEN_WEBUI_VERSION}"
