# Man Pages Phase 4
rm -v man3/crypt*
make prefix=/usr install

echo "manpages installed on $(date)" >>/var/log/packages.log
