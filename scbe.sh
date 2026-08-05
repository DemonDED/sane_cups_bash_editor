#!/bin/bash

source ./variables_scbe.sh
source ./colors_scbe.sh
source ./functions_scbe.sh
source ./sane_functional_scbe.sh

#loader_dot() {

#}

# Main script

echo -e 'Welcome to Sane-Cups Bash Editor (scbe)!\n'

### Status check ###########

if [ "$EUID" -eq 0 ]; then
	echo "Hello Administrator!"
	MAIN_FLAG=1
else
	echo -e "$ERROR_MSG: This command must work on root!"
	exit 1
fi

############################

### Main while cycle #######

while [ $MAIN_FLAG -eq 1 ]; do

	SETUP=$(get_setup)

	# Enter for SANE scanner data
	if [[ $SETUP -eq 1 ]]; then

	SANE_FLAG=1
	echo -e "\n"

	while [ $SANE_FLAG -eq 1 ]; do

		if [[ -f $PATH_TO_AIRSCAN ]]; then

			SANE_SETUP=$(get_sane_setup)
			echo -e "\n"

			if [[ $SANE_SETUP -eq 1 ]]; then
				sane_add_new_device
			fi
			if [[ $SANE_SETUP -eq 2 ]]; then
				sane_device_list
			fi
			if [[ $SANE_SETUP -eq 3 ]]; then
				sane_back_to_main_menu
			fi

		else

			echo -e "$ERROR_MSG: This setup work only with sane-airscan backend!"
			echo -e "$WARNING_MSG: Please, install sane-airscan - sudo apt install sane-airscan\n"
			SANE_FLAG=0
			exit 1

		fi
	done
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
			echo -e "$WARNING_MSG: Please, install cups and cups-client - sudo apt install cups cups-client"

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
	sed -i.bak -E 's/^([[:space:]]*BrowseLocalProtocols[[:space:]]+)(dnssd)/\1none/i' /etc/cups/cupsd.conf

	systemctl restart cups
fi

if [[ $SETUP -eq 5 ]]; then
	MAIN_FLAG=0
	echo -e "\n"
fi

done
