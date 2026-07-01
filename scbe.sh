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


#Main colors echo
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
ORANGE="\e[38;5;208m"
RESET_COLOR="\e[0m"

ERROR_MSG="$RED[ERROR]$RESET_COLOR"
WARNING_MSG="$YELLOW[WARNING]$RESET_COLOR"

#Main funcitons
setup_menu() {
	echo -e "${GREEN}1.$RESET_COLOR Set SANE config" >&2
	echo -e "${GREEN}2.$RESET_COLOR Set ${ORANGE}CUPS$RESET_COLOR config" >&2
	echo -e "${GREEN}3.$RESET_COLOR Optimization SANE airscan (auto scan ip off)" >&2
	echo -e "${GREEN}4.$RESET_COLOR Optimization CUPS (browsed off)" >&2
}
cups_menu() {
	echo -e "${ORANGE}1.$RESET_COLOR Add new device"
	echo -e "${ORANGE}2.$RESET_COLOR Edit exist device"
	echo -e "${ORANGE}3.$RESET_COLOR Delete exist device"
	echo -e "${ORANGE}4.$RESET_COLOR Show devices list"
}

get_setup() {
	local setup_local=""

	setup_menu

	while true; do
		read -p "Please, choose setup work: " setup_local
		
		if check_setup "$setup_local"; then
			echo "$setup_local"
			return 0
		fi
	done
}

check_setup() {
	local set_loc=$1

	if [[ $set_loc -ne 1 && $set_loc -ne 2 && $set_loc -ne 3 && $set_loc -ne 4 ]]; then
		echo -e "$ERROR_MSG: Incorrect setup value!" >&2
		echo -e "$WARNING_MSG: Please, enter correct setup value!" >&2
		return 1
	else
		return 0
	fi
}

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
		echo -e "$ERROR_MSG: IP incorrect!" >&2
		echo -e "$WARNING_MSG: Please enter correct ip!" >&2
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
	echo -e "$ERROR_MSG: This command must work on root!"
	exit 1
fi

SETUP=$(get_setup)

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

		echo -e "$ERROR_MSG: This setup work only with sane-airscan backend!"
		echo -e "$WARNING_MSG: Please, install sane-airscan - sudo apt install
		sane-airscan"
		exit 1

	fi
fi

if [[ $SETUP -eq 2 ]]; then

	if command -v lpadmin >/dev/null 2>&1; then

		cups_menu

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
		echo -e "$ERROR_MSG: This setup work only with cups utility"
		echo -e "$WARNING_MSG: Please, install cups and cups-client - sudo apt install
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

if [[ $SETUP -eq 4 ]]; then
	systemctl stop cups-browsed
	systemctl disable cups-browsed

	sed -i.bak -E 's/^([[:space:]]*Browsing[[:space:]]+)(On|Yes|No)/\1Off/i' /etc/cups/cupsd.conf

	systemctl restart cups
fi
	
