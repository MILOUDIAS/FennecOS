# GMP Phase 4
./configure --prefix=/usr \
	--enable-cxx \
	--disable-static \
	--docdir=/usr/share/doc/gmp-6.3.0

make
make html

if $RUN_TESTS; then
	set +e
	make check 2>&1 | tee gmp-check-logset -e
fi

#PASS_COUNT=$(awk '/# PASS:/{total+=$3} ; END{print total}' $TESTLOG_DIR/gmp.log)
#if [ "$PASS_COUNT" != "" ];
#then
#    echo "ERROR: GMP tests failed. Check /sources/stage6/gmp_test.log for more info."
#    exit -1
#fi

make install
make install-html

echo "gmp installed on $(date)" >>/var/log/packages.log
