# GCC Phase 1
PKG_MPFR=$(basename $PKG_MPFR)
PKG_GMP=$(basename $PKG_GMP)
PKG_MPC=$(basename $PKG_MPC)

tar -xf ../$PKG_MPFR
mv ${PKG_MPFR%.tar*} mpfr

tar -xf ../$PKG_GMP
mv ${PKG_GMP%.tar*} gmp

tar -xf ../$PKG_MPC
mv ${PKG_MPC%.tar*} mpc

sed -e '/lp64=/s/lib64/lib/' \
	-i.orig gcc/config/aarch64/t-aarch64-linux

# case $(uname -m) in
#     x86_64)
#         sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
#     ;;
# esac

mkdir build
cd build

../configure \
	--target=$LFS_TGT \
	--prefix=$LFS/tools \
	--with-glibc-version=2.40 \
	--with-sysroot=$LFS \
	--with-newlib \
	--without-headers \
	--enable-default-pie \
	--enable-default-ssp \
	--disable-nls \
	--disable-shared \
	--disable-multilib \
	--disable-threads \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libssp \
	--disable-libvtv \
	--disable-libstdcxx \
	--enable-languages=c,c++
make
make install

#cd ..
#cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
#  $(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/install-tools/include/limits.h
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	$(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include/limits.h

#rm -f $LFS/tools/lib/gcc/$LFS_TGT/*/include-fixed/limits.h
