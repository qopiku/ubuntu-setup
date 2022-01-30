#!/bin/bash

# Update & upgrade packages
sudo apt update
sudo apt upgrade -y

# Install net-tools
sudo apt-get install -y net-tools

# Install development tools
sudo apt install -y build-essential

# Install Node.js
# via NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
npm i -g npm

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean
