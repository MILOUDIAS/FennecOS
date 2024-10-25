# Ncurses Phase 4
./configure --prefix=/usr \
	--mandir=/usr/share/man \
	--with-shared \
	--without-debug \
	--without-normal \
	--with-cxx-shared \
	--enable-pc-files \
	--with-pkg-config-libdir=/usr/lib/pkgconfig

make

make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
rm -v dest/usr/lib/libncursesw.so.6.5
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
	-i dest/usr/include/curses.h
cp -av dest/* /

for lib in ncurses form panel menu; do
	ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
	ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc
done

ln -sf libncurses.so /usr/lib/libcurses.so

cp -v -R doc -T /usr/share/doc/ncurses-6.5

echo "ncurses 6.5 installed on $(date)" >>/var/log/packages.log
