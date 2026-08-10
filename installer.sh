#!/bin/bash

#Variables

TARGET_BIN_DIR=/usr/local/bin
TARGET_LIB_DIR=/usr/local/lib

BINARY_NAME="scbe"
PROGRAM_NAME="Sane-Cups Bash Editor"

SETUP=""

LINK_MAIN_BINARY="https://github.com/DemonDED/sane_cups_bash_editor/archive/refs/heads/master.zip"
LINK_DEV_BUILD="https://github.com/DemonDED/sane_cups_bash_editor/archive/refs/heads/develope.zip"

#Main script

echo -e "Download and install ${PROGRAM_NAME} by DemonDED\n"

if [[ "$EUID" -ne 0 ]]; then
	echo "This install must work in root!"
	exit 1
fi

while true; do

	echo -e "Welcome! Please choose:"
	echo -e "1. Install stable version"
	echo -e "2. Install develope build"

	read -p "" SETUP

	if [[ "$SETUP" -eq 1 ]]; then
		curl -L -O "$LINK_MAIN_BINARY"
		
		unzip master.zip
		cd ./sane_cups_bash_editor-master
		cp scbe.sh "$TARGET_BIN_DIR/$BINARY_NAME"

		cp *.sh

		chmod +x "$TARGET_DIR/$BINARY_NAME"

		echo "Install complete!"
		echo "You must use programm with command: scbe"

		return 0
	fi

	if [[ "$SETUP" -eq 2 ]]; then
		curl -L -O "$LINK_DEV_BUILD"

		unzip develope.zip
		cd ./sane_cups_bash_editor-develope
		cp scbe.sh "$TARGET_BIN_DIR/$BINARY_NAME"

		cp *.sh

		chmod +x "$TARGET_DIR/$BINARY_NAME"

		echo "Install complete!"
		echo "You must use programm with command: scbe"

		return 0
	fi

done
