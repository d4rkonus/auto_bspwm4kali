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

if [ "$TERM" != "xterm-kitty" ]; then 
    echo -e "\n${redColour}You must install kitty before running the installation.${endColour}\n" 
    exit 1 
fi

if [ "$(whoami)" != "root" ]; then
    echo -e "\n${redColour}You must run this being root.${endColour}\n"
    exit 1
fi

ruta=$(pwd)

tput civis


echo -e "${yellowColour}Installing all environment dependencies...${endColour}"
sudo apt install -y \
        build-essential git vim cmake cmake-data pkg-config python3-sphinx \
        xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev \
        libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev \
        libxcb-shape0-dev libcairo2-dev libxcb-composite0-dev python3-xcbgen \
        xcb-proto libxcb-image0-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev \
        libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev \
        meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev \
        libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev \
        libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
        uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev \
        kitty feh scrot scrub rofi xclip bat locate ranger neofetch wmname acpi bspwm sxhkd imagemagick \
    > /dev/null 2>&1

mkdir ~/gittemp

cd ~/gittemp
git clone --recursive https://github.com/polybar/polybar
git clone https://github.com/ibhagwan/picom.git

cd ~/gittemp/polybar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install

cd ~/github/picom
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install

tput cnorm