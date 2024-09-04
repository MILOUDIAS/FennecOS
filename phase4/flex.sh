# Flex Phase 4
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static

make

if $RUN_TESTS
then
    set +e
    make check 
    set -e
fi

make install
if [ ! -L "/usr/bin/lex" ]; then
    # Perform operations if it's not a symbolic link
    echo "This is not a symbolic link."
    ln -sv flex   /usr/bin/lex
fi

if [ ! -L "/usr/share/man/man1/lex.1" ]; then
    # Perform operations if it's not a symbolic link
    echo "This is not a symbolic link."
    ln -sv flex.1 /usr/share/man/man1/lex.1
fi
