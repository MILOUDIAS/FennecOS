# MPC Phase 4
./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/mpc-1.3.1

make
make html

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install
make install-html

echo "mpc installed on $(date)" >>/var/log/packages.log
