#!/bin/bash

# save current directory to variable
CURR_DIR=$(pwd)

# change dir to /tmp
cd /tmp

# update & upgrade packages
sudo apt update
sudo apt upgrade -y

# install net-tools
sudo apt install -y net-tools

# install development tools
sudo apt install -y build-essential

# install telnet
sudo apt install -y telnet

# install zip unzip
sudo apt install -y zip unzip

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install node.js
nvm install --lts
npm i -g npm yarn

# install personal utility
yarn global add vercel typescript concurrently heroku lerna

# install libreoffice
sudo apt install -y libreoffice

# install wkhtmltopdf
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb
rm -rf ./wkhtmltox_0.12.6-1.focal_amd64.deb

# install ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok-stable-linux-amd64.tgz -C /usr/local/bin

# install ohmyzsh
sudo apt install -y wget git
sudo apt install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# .zshrc configuration
cat >> ~/.zshrc << 'END'
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
CASE_SENSITIVE="true"
zstyle ':omz:update' mode auto
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
if [ -f ${HOME}/.zplug/init.zsh ]; then
    source ${HOME}/.zplug/init.zsh
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
zplug "dracula/zsh", as:theme
END

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean

# change dir to CURR_DIR
cd ${CURR_DIR}
