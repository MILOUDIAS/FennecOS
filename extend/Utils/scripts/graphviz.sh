sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&
	./autogen.sh &&
	./configure --prefix=/usr \
		--docdir=/usr/share/doc/graphviz-12.1.1

make

make install
