#!/bin/bash

# Update
sudo pacman -Syu

# Install
sudo pacman -S \
    git \
    curl \
    firefox \
    vscode \
    obsidian \
    rofi \
    steam \
    postgresql \
    docker \
    neovim \
    telegram-desktop \
    libreoffice \

# yay install
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

yay -S \
    postman \
    ttf-jetbrains-mono-nerd \

# install asdf
git clone https://aur.archlinux.org/asdf-vm.git && cd asdf-vm && makepkg -si

. "$HOME/.asdf/asdf.sh"

asdf plugin add nodejs 
asdf install nodejs latest
asdf global nodejs latest

asdf plugin add ruby 
asdf install ruby latest
asdf global ruby latest

asdf plugin add python
asdf install python latest
asdf global python latest

asdf plugin add go 
asdf install go latest
asdf global go latest
