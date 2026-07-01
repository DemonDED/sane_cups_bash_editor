#!/bin/bash

# Main variables

SETUP=""
IP_REGEX="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

PATH_TO_AIRSCAN="/etc/sane.d/airscan.conf"
SCANNER_IP=""
SCANNER_NAME=""
SCANNER_TYPE=""
SCANNER_PORT=""

ACTION_FOR_CUPS=""


#Main funcitons

get_ip_addr() {
	local text_local=$1
	local ip_local=""

	while true; do
		read -p "$text_local: " ip_local

		if check_ip_entered "$ip_local"; then
			echo "$ip_local"
			return 0
		fi
	done
}

check_ip_entered() {
	local check_ip=$1

	if [[ ! $check_ip =~ $IP_REGEX ]]; then
		echo "[ERROR]: IP incorrect!" >&2
		echo "[WARNING]: Please enter correct ip!" >&2
		return 1
	else
		return 0	
	fi
}


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

		SCANNER_IP=$(get_ip_addr "Enter ip for airscan")

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

		echo -e "1. Add new device\n2. Edit exist device\n3. Delete exist device\n4. Show devices list\n"
		
		read -p "Choose action: " ACTION_FOR_CUPS

		CUPS_DATA_DEVICES=$(lpstat -v 2>&1)

		if [[ $ACTION_FOR_CUPS -eq 4 ]]; then
			echo -e "\nExist data of devices:\n"
			echo "$CUPS_DATA_DEVICES"
		fi

		#lpstat -v
		if [[ $ACTION_FOR_CUPS -eq 1 ]]; then
			NAME_NEW_CUPS_DEVICE=""
			IP_NEW_CUPS_DEVICE=""
			DESCRIPTION_NEW_CUPS_DEVICE=""
			LOCATION_NEW_CUPS_DEVICE=""

			#lpadmin -p "My name" -E (activate) -v socket://192.168.229.***:9100
			#-m everywhere -D описание опционально -L расположение опционально
			read -p "Enter name new device: " NAME_NEW_CUPS_DEVICE
			

			#read -p "Enter ip new device: " IP_NEW_CUPS_DEVICE
			IP_NEW_CUPS_DEVICE=$(get_ip_addr "Enter ip for new device CUPS")


			read -p "Enter description (if need): " DESCRIPTION_NEW_CUPS_DEVICE
			read -p "Enter location (if need): " LOCATION_NEW_CUPS_DEVICE


			lpadmin -p "$NAME_NEW_CUPS_DEVICE" -E \
			-v ipp://$IP_NEW_CUPS_DEVICE:9100 \
			-m everywhere \
			-D "$DESCRIPTION_NEW_CUPS_DEVICE" \
			-L "$LOCATION_NEW_CUPS_DEVICE"
		fi
		if [[ $ACTION_FOR_CUPS -eq 2 ]]; then
			echo "You choose 2"
		fi
		if [[ $ACTION_FOR_CUPS -eq 3 ]]; then
			echo "You choose 3"
		fi

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
