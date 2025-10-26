#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "You must run this beeing root."
    exit 1
fi

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m

ruta=$(pwd)

installation_1(){
    echo -e "${yellowColour}Installing environment dependencies ...\n${endColour}"
    sudo apt install -y build-essential git xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev > /dev/null 2>&1
}

installation_2(){
    echo -e "${yellowColour}Installing polybar requirements ...\n${endColour}"
    sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev > /dev/null 2>&1
}

installation_3(){
    echo -e "${yellowColour}Installing additional tools ...\n${endColour}"
    sudo apt install -y kitty feh scrot scrub rofi xclip bat locate ranger neofetch wmname acpi bspwm sxhkd > /dev/null 2>&1
}

installation_4(){
    echo -e "${yellowColour}Installing Picom ...\n${endColour}"
    sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev > /dev/null 2>&1
}

github_temporal_folder(){
    echo -e "${yellowColour}Cloning and configuring repositories ...\n${endColour}"
    mkdir -p /home/$USER/gittemp > /dev/null 2>&1
    cd ~/github > /dev/null 2>&1
    git clone --recursive https://github.com/polybar/polybar > /dev/null 2>&1
    git clone https://github.com/ibhagwan/picom.git > /dev/null 2>&1
    cd polybar/build > /dev/null 2>&1
    cmake .. > /dev/null 2>&1
    make -j"$(nproc)" > /dev/null 2>&1
    sudo make install > /dev/null 2>&1
}

install_picom(){

    cd /gittemp/picom
    git submodule update --init --recursive > /dev/null 2>&1
    meson --buildtype=release . build > /dev/null 2>&1
    ninja -C build > /dev/null 2>&1
    sudo ninja -C build install > /dev/null 2>&1
}

final_script(){
    echo "\nHasta ahora todo bien\n"
}


installation_1()
installation_2()
installation_3()
installation_4()
github_temporal_folder()
install_picom()
final_script()