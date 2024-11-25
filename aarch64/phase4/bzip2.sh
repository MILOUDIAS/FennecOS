# Bzip2 Phase 4
patch -Np1 -i ../$(basename $PATCH_BZIP2)

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install

cp -a libbz2.so.* /usr/lib
if [ ! -L "/usr/lib/libbz2.so" ]; then
	# Perform operations if it's not a symbolic link
	echo "This is not a symbolic link."
	ln -s libbz2.so.1.0.8 /usr/lib/libbz2.so
fi
cp bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
	ln -sf bzip2 $i
done
rm -f /usr/lib/libbz2.a

echo "bzip2 installed on $(date)" >>/var/log/packages.log
