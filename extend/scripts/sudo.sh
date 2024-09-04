./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.13p1 \
            --with-passprompt="[sudo] password for %p: "
echo "Building Sudo..."
make

env LC_ALL=C make check 2>&1 

make install
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0

echo "Creating sudoers configuration..."
 bash -c 'cat > /etc/sudoers.d/00-sudo << "EOF"
Defaults secure_path="/usr/sbin:/usr/bin"
%wheel ALL=(ALL) ALL
EOF'
chmod 440 /etc/sudoers.d/00-sudo
