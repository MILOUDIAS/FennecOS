make install
install -dm755 /etc/ssl/local

systemctl enable update-pki.timer

# script is resumed in makeca_certs.sh
