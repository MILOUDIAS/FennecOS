./configure --prefix=/usr \
	--libexecdir=/usr/lib \
	--with-secure-path \
	--with-env-editor \
	--docdir=/usr/share/doc/sudo-1.9.15p5 \
	--with-passprompt="[sudo] password for %p: " &&
	echo "Building Sudo..."
make

# env LC_ALL=C make check 2>&1

make install
# ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0

echo "Creating sudoers configuration..."
bash -c 'cat > /etc/sudoers.d/00-sudo << "EOF"
Defaults secure_path="/usr/sbin:/usr/bin"
%wheel ALL=(ALL) ALL
EOF'
chmod 440 /etc/sudoers.d/00-sudo

cat >/etc/pam.d/sudo <<"EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo

echo "sudo 1.19.15p5 installed on $(date)" >>/var/log/packages.log
