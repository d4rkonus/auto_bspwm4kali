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


if [ "$(whoami)" != "root" ]; then
    echo -e "\n${redColour}You must run this being root.${endColour}\n"
    exit 1
fi

ruta=$(pwd)

tput civis

installation_1(){
    echo -e "${yellowColour}Installing environment dependencies ...${endColour}\n"
    apt install -y build-essential git xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev > /dev/null 2>&1
}

installation_2(){
    echo -e "${yellowColour}Installing polybar requirements ...${endColour}\n"
    apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev libuv1-dev libnl-genl-3-dev > /dev/null 2>&1
}

installation_3(){
    echo -e "${yellowColour}Installing additional tools ...${endColour}\n"
    apt install -y feh scrot scrub rofi xclip bat locate ranger neofetch wmname acpi bspwm sxhkd > /dev/null 2>&1
}


installation_4(){
    echo -e "${yellowColour}Installing Picom dependencies ...${endColour}\n"
    apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3 libpcre3-dev > /dev/null 2>&1
}

github_temporal_folder(){
    echo -e "${yellowColour}Cloning and configuring repositories ...${endColour}\n"
    mkdir -p /home/$USER/gittemp > /dev/null 2>&1
    cd /home/$USER/gittemp || exit 1
    git clone --recursive https://github.com/polybar/polybar > /dev/null 2>&1
    git clone https://github.com/ibhagwan/picom.git > /dev/null 2>&1
    cd polybar || exit 1
    mkdir -p build && cd build || exit 1
    cmake .. > /dev/null 2>&1
    make -j"$(nproc)" > /dev/null 2>&1
    make install > /dev/null 2>&1
}

install_picom(){
    cd /home/$USER/gittemp/picom || exit 1
    git submodule update --init --recursive > /dev/null 2>&1
    meson --buildtype=release . build > /dev/null 2>&1
    ninja -C build > /dev/null 2>&1
    ninja -C build install > /dev/null 2>&1
}

install_kitty(){
    apt install -y kitty
}

move_fonts(){
    cp -v $ruta/fonts/* /usr/share/fonts/
}

kitty_4_root(){
    sudo cp -rv $ruta/kitty /root/.config/

}

p10k_install(){
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k
}

plugins_install(){
    sudo apt install -y zsh-syntax-highlighting zsh-autosuggestions
    sudo mkdir /usr/share/zsh-sudo
    cd /usr/share/zsh-sudo
    sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
}

p10k_on(){
    zsh
    rm -rf ~/.zshrc
    cp -v $ruta/.zshrc ~/.zshrc

    cp -v $ruta/.p10k.zsh ~/.p10k.zsh
    sudo cp -v $ruta/.p10k.zsh /root/.p10k.zsh
}

final_script(){
    echo -e "\n${greenColour}✔ Hasta ahora todo bien.${endColour}\n"
}

# Run
installation_1
installation_2
installation_3
installation_4
github_temporal_folder
install_picom
install_kitty
move_fonts
kitty_4_root
p10k_install
plugins_install
p10k_on
final_script
