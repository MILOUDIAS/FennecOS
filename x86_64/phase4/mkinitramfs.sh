cd mkinitramfs-12.2
chmod +x setup_initramfs.sh
./setup_initramfs.sh
sahl -i cpio
mkinitramfs $KERNEL_VERSION
cp initrd.img-$KERNEL_VERSION /boot/
