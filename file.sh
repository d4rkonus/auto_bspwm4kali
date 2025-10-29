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
    echo -e "\n${redColour}You must install kitty before running the installation.${end.Colour}\n" 
    exit 1 
fi

if [ "$(whoami)" != "root" ]; then
    echo -e "\n${redColour}You must run this being root.${endColour}\n"
    exit 1
fi

ruta=$(pwd)

tput civis

echo -e "\nInstalling system dependencies ...\n"
sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev libxcb-shape0-dev

