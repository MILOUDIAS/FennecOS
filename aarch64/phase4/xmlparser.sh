# XML::Parser Phase 4
perl Makefile.PL

make

if $RUN_TESTS; then
	set +e
	make test
	set -e
fi

make install

echo "xmlparser installed on $(date)" >>/var/log/packages.log
