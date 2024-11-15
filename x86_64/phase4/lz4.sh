# Lz4-1.10.0 Phase 4

make BUILD_STATIC=no PREFIX=/usr

make -j1 check
make BUILD_STATIC=no PREFIX=/usr install

echo "lz4 1.10.0 installed on $(date)" >>/var/log/packages.log
