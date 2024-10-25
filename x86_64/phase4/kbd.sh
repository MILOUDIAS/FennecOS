# Kbd Phase 4
patch -Np1 -i ../$(basename $PATCH_KBD)

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

mkdir -pv /usr/share/doc/kbd-2.6.4
cp -R -v docs/doc -T /usr/share/doc/kbd-2.6.4

echo "kbd 2.6.4 installed on $(date)" >>/var/log/packages.log
