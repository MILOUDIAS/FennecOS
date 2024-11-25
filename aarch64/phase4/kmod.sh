# Kmod Phase 4
./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-openssl \
	--with-xz \
	--with-zstd \
	--with-zlib \
	--disable-manpages
make

make install

for target in depmod insmod modinfo modprobe rmmod; do
	ln -sf ../bin/kmod /usr/sbin/$target
done

#ln -sf kmod /usr/bin/lsmod

echo "kmod installed on $(date)" >>/var/log/packages.log
