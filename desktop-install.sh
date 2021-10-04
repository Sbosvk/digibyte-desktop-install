#!/usr/bin/env bash

# Run this script from the 'digibyte-*/bin' directory.

# ANSI Formatting
red="\e[0;91m"
blue="\e[0;94m"
green="\e[0;92m"
uline="\e[4m"
reset="\e[0m"

echo -e "${blue}Installing to ${reset}${uline}/usr/bin folder${reset}${blue}, requires permissions...${reset}"

if [[ "$EUID" = 0 ]]; then
    echo -e "${green}Running as root${reset}"
else
    sudo -k # Ask for password on next sudo
    if ! sudo true; then
        echo -e "${red}Not sufficient permission, exiting${reset}"
        exit 1
    fi
fi

# App name
APP=digibyte-core

# App path
APP_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Make app executable
sudo ln -nsf $APP_PATH/digibyte-qt /usr/bin/$APP
echo ""

## Image
ICON=$APP_PATH/icon.png
ICON_DIR=$APP_PATH/../desktop
ICON_URL=https://github.com/Sbosvk/digibyte-desktop-install/raw/main/512x512-sphere.png

# Image path check/setup
echo "Checking for icon path.."
sleep 2
if ! test -d "$ICON_DIR"; then
    echo -e "${blue}Creating icon directory${reset} => {uline}$ICON_DIR${reset}"
    mkdir $ICON_DIR
    sleep 1
fi
echo -e "Icon path ${green}OK${reset}"
sleep 2

# Image check/setup
echo "Checking for icon.."
sleep 2
if ! test -f "$ICON"; then
    echo -e "${red}No icon found${reset}"
    sleep 1
    echo -e "${blue}Fetching icon to${reset} ${uline}$ICON_DIR/icon.png${reset}${blue}..${reset}"
    sleep 2
    wget -P $ICON_DIR -O icon.png $ICON_URL
else
    echo -e "${blue}Icon found, relocating to${reset} ${uline}$ICON_DIR${reset}.."
    mv $ICON $ICON_DIR/icon.png
    sleep 2
fi
echo -e "Icon ${green}OK${reset}"
sleep 1

# Create desktop entry file
DESK_FILE=$APP.desktop
touch $DESK_FILE
echo "[Desktop Entry]" >>$DESK_FILE
echo "Type=Application" >>$DESK_FILE
echo "Encoding=UTF-8" >>$DESK_FILE
echo "Name=DigiByte Core Wallet" >>$DESK_FILE
echo "Comment=Official DigiByte Core Hot Wallet for Linux" >>$DESK_FILE
echo "Categories=Crypto;Network;Qt;Blockchain;Decentralized" >>$DESK_FILE
echo "Terminal=false" >>$DESK_FILE
echo "Exec=$APP" >>$DESK_FILE
echo "Icon=$ICON" >>$DESK_FILE

echo -e "${blue}Installing to Application browser..${reset}"
xdg-desktop-menu install $DESK_FILE
xdg-desktop-menu forceupdate
echo ""
sleep 2

echo -e "${blue}Cleaning up..${reset}"
unset APP
unset APP_PATH
unset ICON
unset ICON_DIR
unset ICON_URL
rm $DESK_FILE
unset DESK_FILE
sleep 2

echo ""

echo -e "${blue}DigiByte Core${reset} ${green}has been installed on your desktop${reset}"
