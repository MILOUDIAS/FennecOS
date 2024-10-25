make install
install -dm755 /etc/ssl/local

echo "make-ca 1.14 installed on $(date)" >>/var/log/packages.log
systemctl enable update-pki.timer

# script is resumed in makeca_certs.sh
