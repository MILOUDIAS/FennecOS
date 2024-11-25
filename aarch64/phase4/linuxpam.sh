autoreconf -fi

./configure --prefix=/usr \
	--sbindir=/usr/sbin \
	--sysconfdir=/etc \
	--libdir=/usr/lib \
	--enable-securedir=/usr/lib/security \
	--docdir=/usr/share/doc/Linux-PAM-1.6.1 &&
	make

install -v -m755 -d /etc/pam.d &&
	cat >/etc/pam.d/other <<"EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF

make install &&
	chmod -v 4755 /usr/sbin/unix_chkpwd

install -vdm755 /etc/pam.d &&
	cat >/etc/pam.d/system-account <<"EOF" &&
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF
	cat >/etc/pam.d/system-auth <<"EOF" &&
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF
	cat >/etc/pam.d/system-session <<"EOF" &&
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF
	cat >/etc/pam.d/system-password <<"EOF"
# Begin /etc/pam.d/system-password

# use yescrypt hash for encryption, use shadow, and try to use any
# previously defined authentication token (chosen password) set by any
# prior module.
password  required    pam_unix.so       yescrypt shadow try_first_pass

# End /etc/pam.d/system-password
EOF

echo "linux-pam installed on $(date)" >>/var/log/packages.log
