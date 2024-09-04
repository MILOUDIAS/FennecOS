# Pkg-config Phase 4
./configure --prefix=/usr              \
            --disable-static           \
            --docdir=/usr/share/doc/pkgconf-2.3.0
make

if $RUN_TESTS
then
    set +e
    make check
    set -e
fi

make install
if [ ! -L "/usr/bin/pkg-config" ]; then
    # Perform operations if it's not a symbolic link
    echo "This is not a symbolic link."
    ln -sv pkgconf   /usr/bin/pkg-config
fi

if [ ! -L "/usr/share/man/man1/pkg-config.1" ]; then
    # Perform operations if it's not a symbolic link
    echo "This is not a symbolic link."
    ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1
fi
