# cURL

./configure --prefix=/usr \
	--disable-static \
	--with-openssl \
	--enable-threaded-resolver \
	--with-ca-path=/etc/ssl/certs &&
	make

if $RUN_TESTS; then
	set +e
	make test
	set -e
fi

make install &&
	rm -rf docs/examples/.deps &&
	find docs \( -name Makefile\* -o \
		-name \*.1 -o \
		-name \*.3 -o \
		-name CMakeLists.txt \) -delete &&
	cp -v -R docs -T /usr/share/doc/curl-8.9.1
