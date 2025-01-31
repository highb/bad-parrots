#!/bin/bash

echo "This is probably too sketch to use"
exit 1

# Create ~/bin, if it doesn't exist
if [ ! -d ~/bin ]; then
    mkdir -p ~/bin
fi

# Symlink scripts to ~/bin
for script in scripts/*; do
    ln -s "$(pwd)/scripts/${script}" "${HOME}/bin/${script}"
done
