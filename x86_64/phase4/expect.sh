# Expect Phase 4

# because we need python to work
python3 -c 'from pty import spawn; spawn(["echo", "ok"])'

patch -Np1 -i ../$(basename $PATCH_EXPECT)

./configure --prefix=/usr \
	--with-tcl=/usr/lib \
	--enable-shared \
	--disable-rpath \
	--mandir=/usr/share/man \
	--with-tclinclude=/usr/include
make

if $RUN_TESTS; then
	set +e
	make test
	set -e
fi

make install

ln -sf expect5.45.4/libexpect5.45.4.so /usr/lib

echo "expect installed on $(date)" >>/var/log/packages.log
