# Procps-ng Phase 4
./configure --prefix=/usr \
	--docdir=/usr/share/doc/procps-ng-4.0.4 \
	--disable-static \
	--disable-kill \
	--with-systemd

make src_w_LDADD='$(LDADD) -lsystemd'

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

echo "procps-ng 4.0.4 installed on $(date)" >>/var/log/packages.log
