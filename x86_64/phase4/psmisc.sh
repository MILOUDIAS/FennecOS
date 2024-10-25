# Psmisc Phase 4
./configure --prefix=/usr

make

make install

echo "psmisc installed on $(date)" >>/var/log/packages.log
