mkdir build &&
	cd build &&
	meson setup .. \
		--prefix=/usr \
		--buildtype=release \
		-D introspection=disabled \
		-D glib_debug=disabled \
		-D man-pages=enabled \
		-D sysprof=disabled &&
	ninja

ninja install

tar -xvf ../$(basename $PKG_GOBJECT_INTROSPECTION) &&
	meson setup gobject-introspection-1.82.0 gi-build \
		--prefix=/usr --buildtype=release &&
	ninja -C gi-build

ninja -C gi-build install

meson configure -D introspection=enabled &&
	ninja

sed 's/glib-2.0/glib-2.82.0/' \
	-i ../docs/reference/meson.build &&
	meson configure -D documentation=true &&
	ninja

ninja install
