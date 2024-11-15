./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-ssl=openssl &&
	make

make install

echo "wget 1.24.5 installed on $(date)" >>/var/log/packages.log
