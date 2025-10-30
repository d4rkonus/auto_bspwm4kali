#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Fail on error, undefined variables; safer IFS
set -euo pipefail
IFS=$'\n\t'

# Save working dir
ruta=$(pwd)

# Require root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\n${redColour}You must run this script as root.${endColour}\n"
    exit 1
fi

# Prefer checking for kitty binary instead of strict TERM value
if ! command -v kitty >/dev/null 2>&1; then
    echo -e "\n${redColour}kitty not found in PATH. Please install kitty before running this script.${endColour}\n"
    exit 1
fi

# Hide cursor while running and ensure it's restored on exit
tput civis || true
trap 'tput cnorm || true' EXIT

echo -e "${yellowColour}Installing all environment dependencies...${endColour}"
apt update
apt install -y \
        build-essential git vim cmake cmake-data pkg-config python3-sphinx \
        xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev \
        libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev \
        libxcb-shape0-dev libcairo2-dev libxcb-composite0-dev python3-xcbgen \
        xcb-proto libxcb-image0-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev \
        libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev \
        meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
        libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev \
        libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
        uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev \
        feh scrot scrub rofi xclip bat locate ranger neofetch wmname acpi bspwm sxhkd imagemagick


mkdir -p "$HOME/gittemp"
cd "$HOME/gittemp"

# Clone polybar if not present
if [ ! -d "$HOME/gittemp/polybar" ]; then
    git clone --recursive https://github.com/polybar/polybar
fi

# Clone picom if not present
if [ ! -d "$HOME/gittemp/picom" ]; then
    git clone https://github.com/ibhagwan/picom.git
fi

# Build polybar
cd "$HOME/gittemp/polybar"
mkdir -p build
cd build
cmake ..
make -j"$(nproc)"
make install

# Build picom
cd "$HOME/gittemp/picom"
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
ninja -C build install

# Install fonts if present
if [ -d "$ruta/fonts/HNF" ] && compgen -G "$ruta/fonts/HNF/*" >/dev/null; then
    cp -v "$ruta"/fonts/HNF/* /usr/local/share/fonts/
else
    echo -e "${yellowColour}No fonts found in $ruta/fonts/HNF, skipping font copy.${endColour}"
fi

# Install powerlevel10k for current user if not present
if [ ! -d "$HOME/.powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k"
    # add source line if not already present
    if ! grep -q "powerlevel10k.zsh-theme" "$HOME/.zshrc" 2>/dev/null; then
        echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>"$HOME/.zshrc"
    fi
fi

# Instalando p10k para root (si root usa zsh)
if [ ! -d "/root/.powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k || true
fi

tput cnorm