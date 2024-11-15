# DejaGNU Phase 4
mkdir build
cd build

../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi
make install
install -dm755 /usr/share/doc/dejagnu-1.6.3
install -m644 doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

echo "dejagnu installed on $(date)" >>/var/log/packages.log
