# Inetutils Phase 4
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

./configure --prefix=/usr \
	--bindir=/usr/bin \
	--localstatedir=/var \
	--disable-logger \
	--disable-whois \
	--disable-rcp \
	--disable-rexec \
	--disable-rlogin \
	--disable-rsh \
	--disable-servers
make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

mv -v /usr/{,s}bin/ifconfig

echo "inetutils installed on $(date)" >>/var/log/packages.log
