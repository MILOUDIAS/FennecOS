# Binutils Phase 4
EXPECTOUT=$(expect -c 'spawn ls')
if [ "$EXPECTOUT" != "$(echo -ne 'spawn ls\r\n')" ]; then
	echo $EXPECTOUT
	exit 1
fi

mkdir build
cd build

../configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-gold \
	--enable-ld=default \
	--enable-plugins \
	--enable-shared \
	--disable-werror \
	--enable-64-bit-bfd \
	--enable-new-dtags \
	--with-system-zlib \
	--enable-default-hash-style=gnu
make tooldir=/usr

if $RUN_TESTS; then
	set +e
	make -k check
	set -e
fi

make tooldir=/usr install

rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a

echo "binutils installed on $(date)" >>/var/log/packages.log
