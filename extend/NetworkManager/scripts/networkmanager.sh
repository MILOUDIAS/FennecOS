grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'
mkdir build &&
	cd build &&
	meson setup .. \
		--prefix=/usr \
		--buildtype=release \
		-D libaudit=no \
		-D nmtui=true \
		-D ovs=false \
		-D ppp=false \
		-D selinux=false \
		-D qt=false \
		-D session_tracking=systemd \
		-D modem_manager=false &&
	ninja

ninja install &&
	mv -v /usr/share/doc/NetworkManager{,-1.48.8}

for file in $(echo ../man/*.[1578]); do
	section=${file##*.} &&
		install -vdm 755 /usr/share/man/man$section
	install -vm 644 $file /usr/share/man/man$section/
done

cp -Rv ../docs/{api,libnm} /usr/share/doc/NetworkManager-1.48.8

groupadd -fg 86 netdev &&
	/usr/sbin/usermod -a -G netdev root

cat >/usr/share/polkit-1/rules.d/org.freedesktop.NetworkManager.rules <<"EOF"
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("netdev")) {
        return polkit.Result.YES;
    }
});
EOF

systemctl disable systemd-networkd
systemctl disable systemd-resolved
systemctl enable NetworkManager
systemctl disable NetworkManager-wait-online
