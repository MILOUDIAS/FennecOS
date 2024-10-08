install -v -g sys -m700 -d /var/lib/sshd &&
	groupadd -g 50 sshd &&
	useradd -c 'sshd PrivSep' \
		-d /var/lib/sshd \
		-g sshd \
		-s /bin/false \
		-u 50 sshd

./configure --prefix=/usr \
	--sysconfdir=/etc/ssh \
	--with-privsep-path=/var/lib/sshd \
	--with-default-path=/usr/bin \
	--with-superuser-path=/usr/sbin:/usr/bin \
	--with-pid-dir=/run &&
	make

make install &&
	install -v -m755 contrib/ssh-copy-id /usr/bin &&
	install -v -m644 contrib/ssh-copy-id.1 \
		/usr/share/man/man1 &&
	install -v -m755 -d /usr/share/doc/openssh-9.8p1 &&
	install -v -m644 INSTALL LICENCE OVERVIEW README* \
		/usr/share/doc/openssh-9.8p1

echo "PermitRootLogin no" >>/etc/ssh/sshd_config

echo "PasswordAuthentication no" >>/etc/ssh/sshd_config &&
	echo "KbdInteractiveAuthentication no" >>/etc/ssh/sshd_config

# if linux-PAM is installed
sed 's@d/login@d/sshd@g' /etc/pam.d/login >/etc/pam.d/sshd &&
	chmod 644 /etc/pam.d/sshd &&
	echo "UsePAM yes" >>/etc/ssh/sshd_config

tar -xvf ../$(basename $PKG_SYSTEMDUNITS)
# cd ../$(basename $PKG_SYSTEMDUNITS)

# Find the actual directory created by tar and cd into it
# extracted_dir=$(tar -xvf ../$(basename $PKG_SYSTEMDUNITS) | head -1 | cut -f1 -d"/")

# cd "$extracted_dir"
cd blfs-systemd-units-20240801/
make install-sshd
