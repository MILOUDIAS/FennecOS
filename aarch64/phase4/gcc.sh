# GCC Phase 4

case $(uname -m) in
x86_64)
	sed -e '/m64=/s/lib64/lib/' \
		-i.orig gcc/config/i386/t-linux64
	;;
esac

mkdir -v build
cd build

../configure --prefix=/usr \
	LD=ld \
	--enable-languages=c,c++ \
	--enable-default-pie \
	--enable-default-ssp \
	--enable-host-pie \
	--disable-multilib \
	--disable-bootstrap \
	--disable-fixincludes \
	--with-system-zlib
make

ulimit -s -H unlimited
if $RUN_TESTS; then
	set +e
	sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
	sed -e 's/no-pic /&-no-pie /' -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
	sed -e 's/300000/(1|300000)/' -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
	sed -e 's/{ target nonpic } //' \
		-e '/GOTPCREL/d' -i ../gcc/testsuite/gcc.target/i386/fentryname3.c
	chown -Rv tester .
	su tester -c "PATH=$PATH make -k check"
	../contrib/test_summary
	set -e
fi

make install

chown -v -R root:root \
	/usr/lib/gcc/$(gcc -dumpmachine)/14.2.0/include{,-fixed}

ln -sr /usr/bin/cpp /usr/lib
ln -sv gcc.1 /usr/share/man/man1/cc.1

ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/14.2.0/liblto_plugin.so \
	/usr/lib/bfd-plugins/

mkdir -p /usr/share/gdb/auto-load/usr/lib
mv /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

echo "gcc 14.2.0 installed on $(date)" >>/var/log/packages.log
