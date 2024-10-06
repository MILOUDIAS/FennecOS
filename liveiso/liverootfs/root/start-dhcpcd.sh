# enable network
dhcpcd enp0s3
# Check if dhcpd is running
if ! pgrep -x "dhcpd" >/dev/null; then
	echo "dhcpd is not running, starting it..."
	dhcpd enp0s3
	if [ $? -eq 0 ]; then
		echo "dhcpd started successfully."
	else
		echo "Failed to start dhcpd."
	fi
else
	echo "dhcpd is running."
fi

# Ping Google's website to check if the network is available
if ping -c 1 google.com &>/dev/null; then
	echo "Network available"
else
	echo "Network not available, please run dhcpcd"
fi
