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

	read -p "Select option (1-2): " SETUP

	if [[ "$SETUP" -eq 1 ]]; then
		URL="$LINK_MAIN_BINARY"
		DIR_NAME="sane_cups_bash_editor-master"
		ZIP_NAME="master.zip"
		break
	elif [[ "$SETUP" -eq 2 ]]; then
		URL="$LINK_DEV_BUILD"
		DIR_NAME="sane_cups_bash_editor-develope"
		ZIP_NAME="develope.zip"
		break
	else
		echo -e "Invalid choice. Plese, try again.\n"
	fi
done

curl -L -o "$ZIP_NAME" "$URL"
		
unzip -q "$ZIP_NAME"
cp ${DIR_NAME}/scbe.sh "$TARGET_BIN_DIR/$BINARY_NAME"
mkdir -p "$TARGET_LIB_DIR/$BINARY_NAME"
cp ${DIR_NAME}/*_lib.sh "$TARGET_LIB_DIR/$BINARY_NAME/"
		
chmod +x "$TARGET_BIN_DIR/$BINARY_NAME"
		
rm "$ZIP_NAME"
rm -rf "$DIR_NAME"

echo "Install complete!"
echo "You must use programm with command: scbe"
	
