# Acl Phase 4
./configure --prefix=/usr \
	--disable-static \
	--docdir=/usr/share/doc/acl-2.3.2

make

make install

echo "acl installed on $(date)" >>/var/log/packages.log