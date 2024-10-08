# gzip -cd ../libpng-1.6.43-apng.patch.gz | patch -p1
./configure --prefix=/usr --disable-static &&
	make

make install &&
	mkdir -v /usr/share/doc/libpng-1.6.43 &&
	cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.43
