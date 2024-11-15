# Texinfo Phase 4
./configure --prefix=/usr

make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

echo "texinfo 7.1 installed on $(date)" >>/var/log/packages.log
