mkdir build &&
	cd build &&
	meson setup --prefix=/usr --buildtype=release &&
	ninja

ninja install

echo "libpsl 0.21.5 installed on $(date)" >>/var/log/packages.log
