#!/bin/bash

MAIN_LIB_DIR="/usr/local/lib/scbe"

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

if [[ "$SCRIPT_DIR" == *"/sane_cups_bash_editor" ]]; then

	source ${SCRIPT_DIR}/variables_scbe_lib.sh
	source ${SCRIPT_DIR}/colors_scbe_lib.sh
	source ${SCRIPT_DIR}/functions_scbe_lib.sh
	source ${SCRIPT_DIR}/sane_functional_scbe_lib.sh
	source ${SCRIPT_DIR}/cups_functional_scbe_lib.sh

fi

if [[ "$SCRIPT_DIR" == "/usr/local/bin" ]]; then
	
	source ${MAIN_LIB_DIR}/variables_scbe_lib.sh
	source ${MAIN_LIB_DIR}/colors_scbe_lib.sh
	source ${MAIN_LIB_DIR}/functions_scbe_lib.sh
	source ${MAIN_LIB_DIR}/sane_functional_scbe_lib.sh
	source ${MAIN_LIB_DIR}/cups_functional_scbe_lib.sh

fi

#loader_dot() {

#}

# Main script

echo -e 'Welcome to Sane-Cups Bash Editor (scbe)!\n'

### Status check #############################

if [ "$EUID" -eq 0 ]; then
	echo "Hello Administrator!"
	MAIN_FLAG=1
else
	echo -e "$ERROR_MSG: This command must work on root!"
	exit 1
fi

###############################################

### Main while cycle ##########################

while [ $MAIN_FLAG -eq 1 ]; do

	SETUP=$(get_setup)

### Set SANE config ############################
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
######################################################

### Set CUPS config ##################################

	if [[ $SETUP -eq 2 ]]; then
		
		CUPS_FLAG=1
		echo -e "\n"

		while [ $CUPS_FLAG -eq 1 ]; do

		if command -v lpadmin >/dev/null 2>&1; then
			
				
				CUPS_SETUP=$(get_cups_setup)
				echo -e "\n"

				if [[ $CUPS_SETUP -eq 4 ]]; then
					cups_show_devices_list
				fi

				#lpstat -v
				if [[ $CUPS_SETUP -eq 1 ]]; then
					cups_add_new_device
				fi

				if [[ $CUPS_SETUP -eq 2 ]]; then
					cups_delete_exist_device
				fi

				if [[ $CUPS_SETUP -eq 3 ]]; then
					cups_edit_exist_device
				fi

				if [[ $CUPS_SETUP -eq 5 ]]; then
					cups_back_to_main_menu
				fi
		
		else

			echo -e "$ERROR_MSG: This setup work only with cups utility"
			echo -e "$WARNING_MSG: Please, install cups and cups-client - sudo apt install cups cups-client"
			CUPS_FLAG=0

		fi
		done
	fi
##############################################################

# Optimization for airscan (without auto scaning ip) #########

	if [[ $SETUP -eq 3 ]]; then
		sed -i 's/^[^#]/#&/' /etc/sane.d/dll.conf
		mkdir /etc/sane.d/dll.d_backup

		for file in /etc/sane.d/dll.d/*; do
			if [[ -f "$file" && ! "$(basename "$file")" =~ ^airscan ]]; then
				mv "$file" /etc/sane.d/dll.d_backup/
			fi
		done
	fi
###############################################################

# Optimization CUPS (browsed off) #############################

	if [[ $SETUP -eq 4 ]]; then
		systemctl stop cups-browsed
		systemctl disable cups-browsed

		sed -i.bak -E 's/^([[:space:]]*Browsing[[:space:]]+)(On|Yes|No)/\1Off/i' /etc/cups/cupsd.conf
		sed -i.bak -E 's/^([[:space:]]*BrowseLocalProtocols[[:space:]]+)(dnssd)/\1none/i' /etc/cups/cupsd.conf

		systemctl restart cups
	fi
###############################################################

# Optimization CUPS (avahi off) ###############################

if [[ $SETUP -eq 5 ]]; then
	systemctl mask avahi.service
	systemctl mask avahi.socket

	systemctl stop avahi.service
	systemctl stop avahi.socket
	echo -e "\n"
	echo -e "\e[33m$(systemctl status avahi.service)\e[0m"
	echo -e "\n"
fi

###############################################################

### Exit of script ############################################
	if [[ $SETUP -eq 6 ]]; then
		MAIN_FLAG=0
		echo -e "\n"
	fi
###############################################################

done
