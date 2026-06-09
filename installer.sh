#!/bin/bash

# Down if error
set -e

# Main variables
TARGET_DIR=/usr/local/sbin/scbe
BINARY_NAME="Sane-Cups Bash Editor"

echo "Download and install ${BINARY_NAME} by DemonDED"

if [[ "$EUID" -ne 0 ]]; then
	echo "This install must work on root!"
	exit 1
fi

curl -sSL "" -o "$TARGET_DIR/$BINARY_NAME"

chmod +x "$TARGET_DIR/$BINARY_NAME"

echo "Install complete!"
echo "You must use programm with command: scbe"
