#!/usr/bin/bash

if [[ "$USER" != "andreas" ]]; then
    echo "Expected user to be andreas!"
    exit 1
fi

h="/home/andreas/"

# LiberationMono Nerd Font (LiterationMono)
if [[ ! -d ~/.fonts ]]; then
    curl "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/LiberationMono.zip" -L --output "/tmp/LiberationMono.zip" && \
        mkdir ${h}.fonts && \
        unzip /tmp/LiberationMono.zip -d ${h}.fonts && \
        fc-cache -fv
fi

if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ln -s ${h}dotfiles/.oh-my-zsh/custom/themes/sunaku-zapling.zsh-theme ${h}.oh-my-zsh/custom/themes/

ln -s ${h}dotfiles/.zshrc ${h}
ln -s ${h}dotfiles/.zshenv ${h}
ln -s ${h}dotfiles/.gitconfig ${h}
ln -s ${h}dotfiles/.psqlrc ${h}

ln -s ${h}.config/git ${h}.config/
ln -s ${h}.config/sway ${h}.config/
ln -s ${h}.config/alacritty ${h}.config/
