# p11kit

sed '20,$ d' -i trust/trust-extract-compat &&
	cat >>trust/trust-extract-compat <<"EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

mkdir p11-build
cd p11-build

meson setup .. \
	--prefix=/usr \
	--buildtype=release \
	-D trust_paths=/etc/pki/anchors &&
	ninja

if $RUN_TESTS; then
	set +e
	ninja test
	set -e
fi

ninja install

ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
	/usr/bin/update-ca-certificates

ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

echo "p11kit 0.25.5 installed on $(date)" >>/var/log/packages.log
