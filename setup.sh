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
source ~/.bashrc
nvm install --lts

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean
