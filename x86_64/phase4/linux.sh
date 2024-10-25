# LINUX Phase 4

CONFIGFILE=config-$KERNELVERS

make mrproper

if [ -f /boot/$CONFIGFILE ]; then
	cp -v /boot/$CONFIGFILE ./.config
	make olddefconfig
else
	make defconfig
fi

make

make modules_install

cp -v ./.config /boot/$CONFIGFILE

cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-$KERNELVERS-lfs-$LFS_VERSION

cp -v System.map /boot/System.map-$KERNELVERS

install -d /usr/share/doc/linux-$KERNELVERS
cp -r Documentation/* /usr/share/doc/linux-$KERNELVERS

echo "linux 6.10.5 installed on $(date)" >>/var/log/packages.log
