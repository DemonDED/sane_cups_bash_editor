#!/bin/bash

# Down if error
set -e

# Main variables
TARGET_DIR=/usr/local/sbin
BINARY_NAME="scbe"
PROGRAM_NAME="Sane-Cups Bash Editor"
LINK_MAIN_BINARY="https://raw.githubusercontent.com/DemonDED/sane_cups_bash_editor/refs/heads/develope/scbe.sh"

echo "Download and install ${PROGRAM_NAME} by DemonDED"

if [[ "$EUID" -ne 0 ]]; then
	echo "This install must work on root!"
	exit 1
fi

curl -sSL "$LINK_MAIN_BINARY" -o "$TARGET_DIR/$BINARY_NAME"

chmod +x "$TARGET_DIR/$BINARY_NAME"

echo "Install complete!"
echo "You must use programm with command: scbe"
