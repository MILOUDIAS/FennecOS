# Grep Phase 2
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make DESTDIR=$LFS install

