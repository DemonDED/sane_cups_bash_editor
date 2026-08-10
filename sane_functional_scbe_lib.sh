sane_add_new_device(){

	SCANNER_IP=$(get_ip_addr "Enter ip for airscan")

	read -p "Enter Name device: " SCANNER_NAME
	read -p "Enter scaner port (if applicable) or press Enter to skip: " SCANNER_PORT

	if [[ ${SCANNER_PORT} -ne "" ]]; then
		SCANNER_PORT=":$SCANNER_PORT"
	fi

	sed -i "/^\[devices\]$/a '$SCANNER_NAME' = http://$SCANNER_IP${SCANNER_PORT}/eSCL, escl" $PATH_TO_AIRSCAN

	echo -e "\n"
}
sane_device_list(){
	echo -e "Sorry, this functional in develope.\n"
}
sane_back_to_main_menu(){
	SANE_FLAG=0
	echo -e "\n"
}
