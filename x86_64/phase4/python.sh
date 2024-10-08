# Python Phase 4
./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations

make

make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

install -v -dm755 /usr/share/doc/python-3.12.5/html
tar --strip-components=1  \
    --no-same-owner       \
    -xvf ../$(basename $PKG_PYTHONDOCS)
#cp -R --no-preserve=mode python-3.12.5-docs-html/* \
#    /usr/share/doc/python-3.12.5/html
