mv -v tests/test_gdbus.py{,.nouse} &&
	mv -v tests/test_overrides_gtk.py{,.nouse}

mkdir build &&
	cd build &&
	meson setup --prefix=/usr --buildtype=release .. &&
	ninja

ninja install
