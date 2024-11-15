# zstd phase 4

make prefix=/usr

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make prefix=/usr install
rm /usr/lib/libzstd.a

echo "zstd installed on $(date)" >>/var/log/packages.log
