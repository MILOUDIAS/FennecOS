# M4 Phase 2
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make clean
make
make DESTDIR=$LFS install

