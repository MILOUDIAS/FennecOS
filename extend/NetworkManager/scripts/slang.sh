./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-readline=gnu &&
	make -j1 RPATH=

make install_doc_dir=/usr/share/doc/slang-2.3.3 \
	SLSH_DOC_DIR=/usr/share/doc/slang-2.3.3/slsh \
	RPATH= install
