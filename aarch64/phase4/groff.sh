# Groff Phase 4
PAGE=A4 ./configure --prefix=/usr

make -j1

make install

echo "groff installed on $(date)" >>/var/log/packages.log
