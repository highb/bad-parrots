#!/bin/bash

set -x
set -e

# If not arguments, pass help flag to ollama
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [--help]"
    sudo docker exec -it ollama ollama --help
    exit 0
fi

# Pass all args to the ollama container
sudo docker exec -it ollama ollama $@
