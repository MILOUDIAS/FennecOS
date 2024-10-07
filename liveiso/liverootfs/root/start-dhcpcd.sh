#!/bin/bash
# enable network

# While loop to check if dhcpcd is running
while ! pgrep -x "dhcpcd" >/dev/null; do
	echo "dhcpcd is not running, starting it..."
	dhcpcd enp0s3
	if [ $? -eq 0 ]; then
		echo "dhcpcd started successfully."
	else
		echo "Failed to start dhcpcd. Retrying..."
	fi
	# Ping Google's website to check if the network is available
	if ping -c 1 google.com &>/dev/null; then
		echo "dhcpcd is running.\n"
		echo "Now, network is available in your system !"
	else
		echo "Network not available, please run dhcpcd"
	fi
	# Sleep for a few seconds before checking again
	sleep 2
done
