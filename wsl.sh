#!/bin/bash

# save current directory to variable
CURR_DIR=$(pwd)

# change dir to /tmp
cd /tmp

# update & upgrade packages
sudo apt update
sudo apt upgrade -y

# install initial dependencies
sudo apt install -y net-tools build-essential telnet zip unzip cmake

sudo cat >> /etc/wsl.conf << 'END'
[boot]
systemd=true
END

# generate missing locale
sudo locale-gen id_ID.UTF-8

# install docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" -y
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce

# enable docker service
sudo systemctl start docker
sudo systemctl enable docker

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install node.js
nvm install --lts
npm i -g npm yarn

# install personal utility
yarn global add typescript concurrently nodemon vercel heroku lerna

# install php7.4
sudo add-apt-repository --yes ppa:ondrej/php
sudo apt update
sudo apt install -y php7.4
sudo apt install -y php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

# install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# install mariadb
sudo apt install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation

# install apache2
sudo apt install apache2 libapache2-mod-php

# install phpmyadmin
sudo apt install phpmyadmin

# install bun
curl -fsSL https://bun.sh/install | bash

# install rust & cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# install prettyping
wget https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping
chmod +x ./prettyping
mv ./prettyping /usr/local/bin

# install bat
git clone --recursive https://github.com/sharkdp/bat
cd bat && cargo build --bins && cargo test
cargo install --path . --locked
bash assets/create.sh
cargo install --path . --locked --force

# install oh-my-zsh
sudo apt install -y wget git
sudo apt install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# .zshrc configuration
mv ~/.zshrc ~/.zshrc.bak && cat >> ~/.zshrc << 'END'
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode auto

CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="false"
DISABLE_MAGIC_FUNCTIONS="false"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd-mm-yyyy"

plugins=(
    git
    docker
    docker-compose
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
export MANPATH="/usr/local/man:$MANPATH"
export LANG=id_ID.UTF-8
export ARCHFLAGS="-arch x86_64"

if [[ -z "$skip_global_compinit" ]]; then
    autoload -U compinit
fi

export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${(%):-%m}-${ZSH_VERSION}"

if [[ $ZSH_DISABLE_COMPFIX != true ]]; then
    handle_completion_insecurities
    compinit -i -C -d "${ZSH_COMPDUMP}"
else
    compinit -u -C -d "${ZSH_COMPDUMP}"
fi

# zplug init
if [ -f ${HOME}/.zplug/init.zsh ]; then
    source ${HOME}/.zplug/init.zsh
fi

# zplug loader
zplug "dracula/zsh", as:theme
ZSH_THEME="dracula"
zplug load

# dracula theme configuration
DRACULA_DISPLAY_GIT=1
DRACULA_DISPLAY_TIME=0
DRACULA_DISPLAY_CONTEXT=1
DRACULA_DISPLAY_FULL_CWD=0
DRACULA_ARROW_ICON="\-> "
DRACULA_DISPLAY_NEW_LINE=0

# gpg
export GPG_TTY=$(tty)

# nvm & yarn
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH="$PATH:`yarn global bin`"

# cargo
. "$HOME/.cargo/env"

# custom alias
alias cls="clear"
alias ping="prettyping"
alias cat="bat"
alias nace="node ace"
alias grep="grep --color --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=.git"

# bun completions
[ -s "/home/suluh/.bun/_bun" ] && source "/home/suluh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
END

# set zsh as default shell
sudo chsh -s $(which zsh) $(whoami)

# install zsh-syntax-higlighting
export ZSH_CUSTOM=~/.oh-my-zsh/custom
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# load zplug
zplug load

# install dracula theme for zsh
zplug install "dracula/zsh"

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean

# change dir to CURR_DIR
cd ${CURR_DIR}
