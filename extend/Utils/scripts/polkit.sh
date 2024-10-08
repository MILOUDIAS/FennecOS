# groupadd -fg 27 polkitd &&
# 	useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
# 		-g polkitd -s /bin/false polkitd

# Check if group 'polkitd' exists
if ! getent group polkitd >/dev/null; then
	groupadd -fg 27 polkitd
fi

# Check if user 'polkitd' exists
if ! id -u polkitd >/dev/null 2>&1; then
	useradd -c 'PolicyKit Daemon Owner' -d /etc/polkit-1 -u 27 -g polkitd -s /bin/false polkitd
fi

mkdir build &&
	cd build &&
	meson setup .. \
		--prefix=/usr \
		--buildtype=release \
		-D man=true \
		-D session_tracking=logind \
		-D tests=false

ninja
ninja install
