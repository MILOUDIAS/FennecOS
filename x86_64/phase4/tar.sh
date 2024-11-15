# Tar Phase 4
FORCE_UNSAFE_CONFIGURE=1 \
	./configure --prefix=/usr

make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make install

make -C doc install-html docdir=/usr/share/doc/tar-1.35

echo "tar 1.35 installed on $(date)" >>/var/log/packages.log
