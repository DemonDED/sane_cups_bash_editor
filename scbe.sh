#!/bin/bash

# Main variables

PATH_TO_AIRSCAN="/etc/sane.d/airscan.conf"
SCANNER_IP=""
SCANNER_NAME=""

# Main script

echo -e 'Welcome to Sane-Cups Bash Editor (scbe)!\n'

## Status check

if [ "$EUID" -eq 0 ]; then
	echo "Hello Administrator!"
else
	echo "[ERROR]: This command must work on root!"
	exit 1
fi

#if ! command -v cups &> /dev/null; then
#	echo "[ERROR]: CUPS do not install on system"
#	echo "[WARNING]: Please, install CUPS and restart command"
#	exit 1
#fi

#if ! command -v scanimage &> /dev/null; then
#	echo "[ERROR]: SANE do not install on system"
#	echo "[WARNING]: Please, install SANE and restart command"
#fi

read -p "Enter IP to airscan add: " SCANNER_IP

read -p "Enter Name device: " SCANNER_NAME

sed -i "/^\[devices\]$/a '$SCANNER_NAME' = http://$SCANNER_IP:631/eSCL, escl" $PATH_TO_AIRSCAN
