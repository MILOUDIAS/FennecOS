# Util-linux Phase 4
./configure --bindir=/usr/bin \
	--libdir=/usr/lib \
	--runstatedir=/run \
	--sbindir=/usr/sbin \
	--disable-chfn-chsh \
	--disable-login \
	--disable-nologin \
	--disable-su \
	--disable-setpriv \
	--disable-runuser \
	--disable-pylibmount \
	--disable-liblastlog2 \
	--disable-static \
	--without-python \
	--without-systemd \
	--without-systemdsystemunitdir \
	ADJTIME_PATH=/var/lib/hwclock/adjtime \
	--docdir=/usr/share/doc/util-linux-2.40.2
make

if $RUN_TESTS; then
	set +e
	chown -Rv tester .
	su tester -c "make -k check"
	set -e
fi

make install

echo "util-linux 2.40.2 installed on $(date)" >>/var/log/packages.log
