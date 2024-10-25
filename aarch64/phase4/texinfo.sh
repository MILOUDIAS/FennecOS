# Texinfo Phase 4
./configure --prefix=/usr

make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

echo "texinfo installed on $(date)" >>/var/log/packages.log
