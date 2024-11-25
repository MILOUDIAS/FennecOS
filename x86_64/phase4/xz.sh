# Xz Phase 4
./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/xz-5.6.2

make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

echo "xz 5.6.2 installed on $(date)" >>/var/log/packages.log
