install -v -m700 -d /var/lib/dhcpcd &&
	groupadd -g 52 dhcpcd &&
	useradd -c 'dhcpcd PrivSep' \
		-d /var/lib/dhcpcd \
		-g dhcpcd \
		-s /bin/false \
		-u 52 dhcpcd &&
	chown -v dhcpcd:dhcpcd /var/lib/dhcpcd

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--libexecdir=/usr/lib/dhcpcd \
	--dbdir=/var/lib/dhcpcd \
	--runstatedir=/run \
	--disable-privsep &&
	make

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--libexecdir=/usr/lib/dhcpcd \
	--dbdir=/var/lib/dhcpcd \
	--runstatedir=/run \
	--privsepuser=dhcpcd &&
	make

make install

# cd ../$(basename $PKG_SYSTEMDUNITS) &&

tar -xvf ../$(basename $PKG_SYSTEMDUNITS)
# cd ../$(basename $PKG_SYSTEMDUNITS)

# Find the actual directory created by tar and cd into it
# extracted_dir=$(tar -xvf ../$(basename $PKG_SYSTEMDUNITS) | head -1 | cut -f1 -d"/")

# cd "$extracted_dir"
cd blfs-systemd-units-20240801/
make install-dhcpcd

systemctl start dhcpcd@enp0s3
systemctl enable dhcpcd@enp0s3
