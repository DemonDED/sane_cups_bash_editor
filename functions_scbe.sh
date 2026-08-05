#Main funcitons
setup_menu() {
	echo -e "${GREEN}1.$RESET_COLOR Set ${BLUE}SANE$RESET_COLOR config" >&2
	echo -e "${GREEN}2.$RESET_COLOR Set ${ORANGE}CUPS$RESET_COLOR config" >&2
	echo -e "${GREEN}3.$RESET_COLOR Optimization SANE airscan (auto scan ip off)" >&2
	echo -e "${GREEN}4.$RESET_COLOR Optimization CUPS (browsed off)" >&2
	echo -e "${GREEN}5.$RESET_COLOR Exit" >&2
}
cups_menu() {
	echo -e "${ORANGE}1.$RESET_COLOR Add new device" >&2
	echo -e "${ORANGE}2.$RESET_COLOR Edit exist device" >&2
	echo -e "${ORANGE}3.$RESET_COLOR Delete exist device" >&2
	echo -e "${ORANGE}4.$RESET_COLOR Show devices list" >&2
	echo -e "${ORANGE}5.$RESET_COLOR Back to main menu"
}
sane_menu() {
	echo -e "${BLUE}1.$RESET_COLOR Add new device" >&2
	echo -e "${BLUE}2.$RESET_COLOR Show device list" >&2
	echo -e "${BLUE}3.$RESET_COLOR Back to main menu" >&2
}
###
get_setup() {
	local setup_local=""

	setup_menu

	while true; do
		read -p "Please, choose setup work: " setup_local
		
		if check_setup "$setup_local"; then
			echo -e "$setup_local"
			return 0
		fi
	done
}

check_setup() {
	local set_loc=$1

	if [[ $set_loc -ne 1 && $set_loc -ne 2 && $set_loc -ne 3 && $set_loc -ne 4 && $set_loc -ne 5 ]]; then
		echo -e "$ERROR_MSG: Incorrect setup value!" >&2
		echo -e "$WARNING_MSG: Please, enter correct setup value!\n" >&2
		return 1
	else
		return 0
	fi
}
###
get_sane_setup(){
	local sane_setup_local=""

	sane_menu

	while true; do
		read -p "Please, choose setup work: " sane_setup_local

		if check_sane_setup "$sane_setup_local"; then
			echo -e "$sane_setup_local"
			return 0
		fi
	done
}

check_sane_setup(){
	local sane_loc=$1

	if [[ $sane_loc -ne 1 && $sane_loc -ne 2 && $sane_loc -ne 3 ]]; then
		echo -e "$ERROR_MSG: Incorrect setup value!" >&2
		echo -e "$WARNING_MSG: Please, enter correct setup value!\n" >&2
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
