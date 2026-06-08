#!/bin/bash

# Main variables

SETUP=""

PATH_TO_AIRSCAN="/etc/sane.d/airscan.conf"
SCANNER_IP=""
SCANNER_NAME=""
SCANNER_TYPE=""
SCANNER_PORT=""


# Main script

echo -e 'Welcome to Sane-Cups Bash Editor (scbe)!\n'

## Status check

if [ "$EUID" -eq 0 ]; then
	echo "Hello Administrator!"
else
	echo "[ERROR]: This command must work on root!"
	exit 1
fi

echo -e "1. Set SANE config\n2. Set CUPS config\n"
read -p "Please, choose setup work: " SETUP

#if ! command -v cups &> /dev/null; then
#	echo "[ERROR]: CUPS do not install on system"
#	echo "[WARNING]: Please, install CUPS and restart command"
#	exit 1
#fi

#if ! command -v scanimage &> /dev/null; then
#	echo "[ERROR]: SANE do not install on system"
#	echo "[WARNING]: Please, install SANE and restart command"
#fi

# Enter for SANE scanner data
if [[ $SETUP -eq 1 ]]; then

	if [[ -f $PATH_TO_AIRSCAN ]]; then

		read -p "Enter IP to airscan add: " SCANNER_IP
		read -p "Enter Name device: " SCANNER_NAME
		read -p "Enter scaner port (if exist): " SCANNER_PORT

		if [[ ${SCANNER_PORT} -ne "" ]]; then
			SCANNER_PORT=":$SCANNER_PORT"
		fi


		sed -i "/^\[devices\]$/a '$SCANNER_NAME' = http://$SCANNER_IP${SCANNER_PORT}/eSCL, escl" $PATH_TO_AIRSCAN

	else

		echo "[ERROR]: This setup work only with sane-airscan backend!"
		echo "[WARNING]: Please, install sane-airscan - sudo apt install
		sane-airscan"
		exit 1

	fi
fi

if [[ $SETUP -eq 2 ]]; then

	if command -v lpadmin >/dev/null 2>&1; then

		echo "Sorry, this functional do not work."
	else
		echo "[ERROR]: This setup work only with cups utility"
		echo "[WARNING]: Please, install cups and cups-client - sudo apt install
		cups cups-client"

	fi
fi
