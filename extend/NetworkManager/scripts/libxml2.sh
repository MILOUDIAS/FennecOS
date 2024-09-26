# patch -Np1 -i ../libxml2-2.13.3-upstream_fix-2.patch
patch -Np1 -i ../$(basename $PATCH_LIBXML2)

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--with-history \
	--with-icu \
	PYTHON=/usr/bin/python3 \
	--docdir=/usr/share/doc/libxml2-2.13.3 &&
	make

make install

rm -vf /usr/lib/libxml2.la &&
	sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config
