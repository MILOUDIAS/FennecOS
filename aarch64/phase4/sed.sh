# Sed Phase 4
./configure --prefix=/usr

make
make html

if $RUN_TESTS; then
	set +e
	chown -R tester .
	su tester -c "PATH=$PATH make check"
	set -e
fi

make install
install -d -m755 /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9

echo "sed 4.9 installed on $(date)" >>/var/log/packages.log
