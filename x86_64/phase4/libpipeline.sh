# Libpipeline Phase 4
./configure --prefix=/usr

make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

echo "libpipeline 1.5.8 installed on $(date)" >>/var/log/packages.log
