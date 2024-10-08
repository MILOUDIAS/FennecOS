patch -Np1 -i ../$(basename $PATCH_GPM)
# patch -Np1 -i ../gpm-1.20.7-consolidated-1.patch                &&

./autogen.sh &&
	./configure --prefix=/usr --sysconfdir=/etc ac_cv_path_emacs=no &&
	make

make install &&
	install-info --dir-file=/usr/share/info/dir \
		/usr/share/info/gpm.info &&
	rm -fv /usr/lib/libgpm.a &&
	ln -sfv libgpm.so.2.1.0 /usr/lib/libgpm.so &&
	install -v -m644 conf/gpm-root.conf /etc &&
	install -v -m755 -d /usr/share/doc/gpm-1.20.7/support &&
	install -v -m644 doc/support/* \
		/usr/share/doc/gpm-1.20.7/support &&
	install -v -m644 doc/{FAQ,HACK_GPM,README*} \
		/usr/share/doc/gpm-1.20.7

xz -d ../$(basename $PKG_SYSTEMDUNITS)
tar -xvf ../blfs-systemd-units-20240801.tar

# tar -xvf ../$(basename $PKG_SYSTEMDUNITS)
# cd ../$(basename $PKG_SYSTEMDUNITS)

# Find the actual directory created by tar and cd into it
# extracted_dir=$(tar -xvf ../$(basename $PKG_SYSTEMDUNITS) | head -1 | cut -f1 -d"/")

cd blfs-systemd-units-20240801/
# cd "$extracted_dir"

make install-gpm
