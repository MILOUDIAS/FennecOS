# Bc Phase 4
CC=gcc ./configure --prefix=/usr -G -O3 -r

make

if $RUN_TESTS; then
	set +e
	make test
	set -e
fi

make install

echo "bc installed on $(date)" >>/var/log/packages.log
