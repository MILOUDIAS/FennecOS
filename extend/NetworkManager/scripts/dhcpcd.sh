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
