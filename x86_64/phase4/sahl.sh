# the package manager

cat >.xorg_env.sh <<EOF
export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"
EOF
wget --no-check-certificate https://raw.githubusercontent.com/abdurahman-harouat/sahl/main/sahl_installer.sh -O sahl_installer.sh

# if you have already setup bash startup files
bash sahl_installer.sh

source ~/.bashrc
source ~/.profile

# now install libarchive as some packages require it
sahl -i libarchive
