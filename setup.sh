#!/usr/bin/bash

if [[ "$USER" != "andreas" ]]; then
    echo "Expected user to be andreas!"
    exit 1
fi

h="/home/andreas/"

# LiberationMono Nerd Font (LiterationMono)
if [[ ! -d ${h}.fonts ]]; then
    curl "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/LiberationMono.zip" -L --output "/tmp/LiberationMono.zip" && \
        mkdir ${h}.fonts && \
        unzip /tmp/LiberationMono.zip -d ${h}.fonts && \
        fc-cache -fv
fi

if [[ ! -d ${h}.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    rm ${h}.zshrc
    rm ${h}.zshrc.pre-oh-my-zsh
fi

ln -s ${h}dotfiles/.oh-my-zsh/custom/themes/sunaku-zapling.zsh-theme ${h}.oh-my-zsh/custom/themes/

[[ ! -d ${h}.ssh ]] && mkdir ${h}.ssh
ln -s ${h}dotfiles/.ssh/config ${h}.ssh/

ln -s ${h}dotfiles/.zshrc ${h}
ln -s ${h}dotfiles/.zshenv ${h}
ln -s ${h}dotfiles/.gitconfig ${h}
ln -s ${h}dotfiles/.psqlrc ${h}

[[ ! -d ${h}.local ]] && mkdir ${h}.local
ln -s ${h}dotfiles/.local/bin ${h}.local/

ln -s ${h}dotfiles/.config/git ${h}.config/
ln -s ${h}dotfiles/.config/sway ${h}.config/
ln -s ${h}dotfiles/.config/alacritty ${h}.config/
ln -s ${h}dotfiles/.config/fontconfig ${h}.config/
