sed -i -e 's/GROUP="render"/GROUP="video"/' \
	-e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

mkdir build &&
	cd build &&
	meson setup .. \
		--prefix=/usr \
		--buildtype=release \
		-D default-dnssec=no \
		-D firstboot=false \
		-D install-tests=false \
		-D ldconfig=false \
		-D man=auto \
		-D sysusers=false \
		-D rpmmacrosdir=no \
		-D homed=disabled \
		-D userdb=false \
		-D mode=release \
		-D pam=enabled \
		-D pamconfdir=/etc/pam.d \
		-D dev-kvm-mode=0660 \
		-D nobody-group=nogroup \
		-D sysupdate=disabled \
		-D ukify=disabled \
		-D docdir=/usr/share/doc/systemd-256.4 &&
	ninja

ninja install

systemd-machine-id-setup
# systemctl daemon-reexec
systemctl preset-all
systemctl stop systemd-networkd
systemctl disable systemd-networkd
systemctl stop systemd-resolved
systemctl disable systemd-resolved

grep 'pam_systemd' /etc/pam.d/system-session ||
	cat >>/etc/pam.d/system-session <<"EOF"
# Begin Systemd addition

session  required    pam_loginuid.so
session  optional    pam_systemd.so

# End Systemd addition
EOF

cat >/etc/pam.d/systemd-user <<"EOF"
# Begin /etc/pam.d/systemd-user

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so

# End /etc/pam.d/systemd-user
EOF

tar -xf ../../systemd-man-pages-256.4.tar.xz \
	--no-same-owner --strip-components=1 \
	-C /usr/share/man

echo "systemd 256.4 installed on $(date)" >>/var/log/packages.log
