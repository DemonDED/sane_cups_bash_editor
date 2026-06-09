#!/bin/bash

# Main variables

SETUP=""
IP_REGEX="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

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

echo -e "1. Set SANE config\n2. Set CUPS config\n3. Optimization SANE airscan (auto scan ip off)\n"
read -p "Please, choose setup work: " SETUP

# Enter for SANE scanner data
if [[ $SETUP -eq 1 ]]; then

	if [[ -f $PATH_TO_AIRSCAN ]]; then

		while true;do
			read -p "Enter IP to airscan add: " SCANNER_IP

			if [[ ! $SCANNER_IP =~ $IP_REGEX ]]; then
				echo "[ERROR]: IP incorrect!"
				echo "[WARNING]: Please, enter correct ip"
			else
				break
			fi
		done

		read -p "Enter Name device: " SCANNER_NAME
		read -p "Enter scaner port (if applicable) or press Enter to skip: " SCANNER_PORT

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

		#echo "Sorry, this functional do not work."
		lpstat -v

	else
		echo "[ERROR]: This setup work only with cups utility"
		echo "[WARNING]: Please, install cups and cups-client - sudo apt install
		cups cups-client"

	fi
fi

# Optimization for airscan (without auto scaning ip)
if [[ $SETUP -eq 3 ]]; then
	sed -i 's/^[^#]/#&/' /etc/sane.d/dll.conf
	mkdir /etc/sane.d/dll.d_backup

	for file in /etc/sane.d/dll.d/*; do
		if [[ -f "$file" && ! "$(basename "$file")" =~ ^airscan ]]; then
			mv "$file" /etc/sane.d/dll.d_backup/
		fi
	done
fi
