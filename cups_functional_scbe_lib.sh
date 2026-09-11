cups_add_menu_list(){
	echo -e "${BLUE}1.$RESET_COLOR Pantum"
	echo -e "${BLUE}2.$RESET_COLOR Kyocera"
}

cups_add_new_device(){
	
	#lpadmin -p "My name" -E (activate) -v socket://192.168.229.***:9100
	#-m everywhere -D описание опционально -L расположение опционально
	read -p "Enter name new device: " NAME_NEW_CUPS_DEVICE

	#read -p "Enter ip new device: " IP_NEW_CUPS_DEVICE
	IP_NEW_CUPS_DEVICE=$(get_ip_addr "Enter ip for new device CUPS")
	
	read -p "Enter description (if need): " DESCRIPTION_NEW_CUPS_DEVICE
	read -p "Enter location (if need): " LOCATION_NEW_CUPS_DEVICE

	while true; do
		cups_add_menu_list

		read -p "Enter device model: " CUPS_DEVICE_MODEL

		if [[ $CUPS_DEVICE_MODEL -eq 1 ]]; then
			# Pantum
			CUPS_NETWORK_PATH_DEVICE="ipp://${IP_NEW_CUPS_DEVICE}/ipp/print"
			break
		elif [[ $CUPS_DEVICE_MODEL -eq 2 ]]; then
			# Kyocera
			CUPS_NETWORK_PATH_DEVICE="ipp://${IP_NEW_CUPS_DEVICE}:631/ipp"
			break
		else
			echo -e "$ERROR_MSG: Incorrect entered data!"
			echo -e "$WARNING_MSG: Please, enter correct data."
		fi
	done
	
	lpadmin -p "$NAME_NEW_CUPS_DEVICE" -E \
	-v "$CUPS_NETWORK_PATH_DEVICE" \
	-m everywhere \
	-D "$DESCRIPTION_NEW_CUPS_DEVICE" \
	-L "$LOCATION_NEW_CUPS_DEVICE"
	
	echo -e "\n"
}

cups_show_devices_list(){

	CUPS_DATA_DEVICES=$(lpstat -v 2>&1)
	echo -e "\nExist data of devices:\n"
	echo "$CUPS_DATA_DEVICES"
	echo -e "\n"

}

cups_delete_exist_device(){
	echo -e "Sorry, this in develope\n"
	
	cups_show_devices_list
	
	mapfile -t devices < <(lpstat -v 2>&1)

	echo "Найденные устройства:"
	for i in "${!devices[@]}"; do
		echo "$i) ${devices[$i]}"
	done

	#read -p "Choose device for delete: " CUPS_CHOOSE_DELETE_DEVICE
		
}

cups_edit_exist_device(){
	echo -e "Sorry, this in develope\n"

	# read -e -p "test: " -i "TEST_VALUE" TEST
}

cups_back_to_main_menu(){
	CUPS_FLAG=0
	echo -e "\n"
}
