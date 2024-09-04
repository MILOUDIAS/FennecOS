./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-7.2 &&
make

make install &&
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-7.2