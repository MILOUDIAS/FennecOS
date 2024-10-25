# Gawk Phase 4
sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

if $RUN_TESTS; then
	set +e
	chown -R tester .
	su tester -c "PATH=$PATH make check"set -e
fi
rm -f /usr/bin/gawk-5.3.0
make install
ln -sv gawk.1 /usr/share/man/man1/awk.1
mkdir -pv /usr/share/doc/gawk-5.3.0
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.3.0

echo "gawk installed on $(date)" >>/var/log/packages.log
