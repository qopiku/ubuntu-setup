#!/bin/bash

# Update & upgrade packages
sudo apt update
sudo apt upgrade -y

# Install net-tools
sudo apt install -y net-tools

# Install development tools
sudo apt install -y build-essential

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js
nvm install --lts
npm i -g npm

# Install pm2
npm i -g pm2

# Install LibreOffice
sudo apt install -y libreoffice

# Install wkhtmltopdf
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb
rm -rf ./wkhtmltox_0.12.6-1.focal_amd64.deb

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean
