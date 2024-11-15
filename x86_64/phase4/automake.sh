# Automake Phase 4
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.17
make

if $RUN_TESTS; then
	set +e
	make -j4 check
	set -e
fi

make install

echo "automake installed on $(date)" >>/var/log/packages.log
