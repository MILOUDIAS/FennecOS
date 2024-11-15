./INSTALL.sh
mkdir -p /var/lib/scratchpkg/db

cat >/etc/scratchpkg.repo <<"EOF"
#
# /etc/scratchpkg.repo : scratchpkg repo file
#
# format:
#    <repo directory> <repo url> <repo branch, "main" by default>
#

/usr/ports/main		https://gitlab.com/venomlinux/ports/main
/usr/ports/community	https://gitlab.com/venomlinux/ports/community
/usr/ports/mate	  https://gitlab.com/venomlinux/ports/mate
/usr/ports/xfce	  https://gitlab.com/venomlinux/ports/xfce
/usr/ports/multilib	  https://gitlab.com/venomlinux/ports/multilib
/usr/ports/nonfree	https://gitlab.com/venomlinux/ports/nonfree
#/usr/ports/testing	https://gitlab.com/venomlinux/ports/testing
EOF
