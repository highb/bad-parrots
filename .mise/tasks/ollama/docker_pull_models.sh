#!/bin/bash

set -e
set -x

# Loads the modesl I'm using for Ollama, in roughly increasing size order so
# that I can start using smaller models immediately.
models=(
    "nomic-embed-text:latest"
    "deepseek-r1:1.5b"
    "qwen2.5-coder:1.5b-base"
    "deepseek-r1:7b"
    "mistral:7b"
    "dolphin-mixtral:8x7b"
    "gemma:7b"
    "deepseek-r1:8b"
    "phi4:14b"
    "deepseek-r1:14b"
    "deepseek-coder-v2:16b"
    "deepseek-r1:32b"
    "llama3.2-vision"
    "llama3.3:70b"
)

for model in "${models[@]}"; do
    gum log "Pulling model ${model}..."
    sudo docker exec -it ollama ollama pull "${model}"
done
