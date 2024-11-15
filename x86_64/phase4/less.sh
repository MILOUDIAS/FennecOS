# Less Phase 4
./configure --prefix=/usr --sysconfdir=/etc

make

make install

echo "less installed on $(date)" >>/var/log/packages.log
