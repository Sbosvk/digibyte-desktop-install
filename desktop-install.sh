#!/usr/bin/env bash

# MIT License

# Copyright (c) 2022 Oliver Krilov

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ANSI Formatting
red="\e[0;91m"
blue="\e[0;94m"
green="\e[0;92m"
uline="\e[4m"
reset="\e[0m"
tab="    "

echo -e "Installing to '${blue}/usr/bin/${reset}', requires permissions..."

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

#Current Path
CURR_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# App path
echo -e "Where is the '${blue}DigiByte-Core${reset}' application installed?\n${tab}1:${tab}Current path ${blue}($CURR_PATH/)${reset}\n${tab}2:${tab}Snap install ${blue}(/snap/)${reset}\n${tab}3:${tab}Custom path"
read PATH_SELECTION

if [ $PATH_SELECTION == 1 ]; then
        APP_PATH="$CURR_PATH"
elif [ $PATH_SELECTION == 2 ]; then
        if ! command -v snap &> /dev/null; then
                echo "Snapcraft not installed, please install it and try again."
                exit 1
        else
                if ! snap list | grep digibyte-core; then
                        read -p "digibyte-core not found, install it now? (Y/n) " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
                        sudo snap install digibyte-core
                        if snap list | grep digibyte-core; then
                                APP_PATH="/snap/digibyte-core/current"
                        else
                                echo -e "${red}DigiByte-Core could not be found, was the installation aborted?${reset}"
                                exit 1
                        fi
                fi
        fi
elif [ $PATH_SELECTION == 3 ]; then
        read -p "Enter custom path: " CUSTOM_PATH
        APP_PATH="${CUSTOM_PATH}"
else
        echo -e "${red}Invalid selection, exiting.${reset}"
fi

echo -e "Continue with path '${blue}${APP_PATH}${reset}'? (Y/n) "
read confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

# Make app executable
sudo ln -nsf $APP_PATH/bin/digibyte-qt /usr/bin/$APP
echo ""

# ICON
ICON=digibyte-core.png
ICON_DIR=~/.local/share/icons
ICON_URL=https://github.com/Sbosvk/digibyte-desktop-install/raw/main/icon.png

# Check for icon path
echo "Checking for icon path.."
if ! test -d "$ICON_DIR"; then
        echo -e "${blue}Creating icon directory${reset} => ${uline}$ICON_DIR${reset}"
        mkdir $ICON_DIR
fi

if ! test -f "$ICON_DIR/$ICON"; then
    echo -e "${blue}Fetching icon to${reset} ${uline}$ICON_DIR/$ICON${reset}${blue}..${reset}"
    wget -P $ICON_DIR $ICON_URL
fi


if test -f "$ICON_DIR/$ICON"; then
        echo -e "Icon ${green}OK${reset}"
fi

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
echo "Icon=$ICON_DIR/$ICON" >>$DESK_FILE

echo -e "${blue}Installing to Application browser..${reset}"
xdg-desktop-menu install $DESK_FILE
xdg-desktop-menu forceupdate
echo ""

echo -e "${blue}Cleaning up..${reset}"
unset APP
unset CURR_PATH
unset PATH_SELECTION
unset APP_PATH
unset ICON
unset ICON_DIR
unset ICON_URL
rm $DESK_FILE
unset DESK_FILE

echo ""

echo -e "${blue}DigiByte Core${reset} ${green}has been installed on your desktop${reset}"
