#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
	echo "This install must work in root!"
	exit 1
fi


echo -e "Welcome! Start install local...\n"

mkdir -p /usr/local/lib/scbe

for file_lib in *_lib.sh
	do
		[ -e "$file_lib" ] || continue
		cp "$file_lib" /usr/local/lib/scbe
	done

cp scbe.sh /usr/local/bin/scbe

chmod +x /usr/local/bin/scbe

echo "Installation completed successfully!"
