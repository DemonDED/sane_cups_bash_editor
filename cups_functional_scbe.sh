cups_add_new_device(){
	
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
	
	echo -e "\n"
}

cups_delete_exist_device(){
	echo -e "Sorry, this in develope\n"
}

cups_edit_exist_device(){
	echo -e "Sorry, this in develope\n"
}

cups_show_devices_list(){

	CUPS_DATA_DEVICES=$(lpstat -v 2>&1)
	echo -e "\nExist data of devices:\n"
	echo "$CUPS_DATA_DEVICES"
	echo -e "\n"

}

cups_back_to_main_menu(){
	CUPS_FLAG=0
	echo -e "\n"
}
