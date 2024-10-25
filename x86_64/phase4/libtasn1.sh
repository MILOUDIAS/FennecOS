# libtasn1

./configure --prefix=/usr --disable-static
make

if $RUN_TESTS; then
	make check
fi

make install

make -C doc/reference install-data-local

echo "libtasn1 4.19.0 installed on $(date)" >>/var/log/packages.log
