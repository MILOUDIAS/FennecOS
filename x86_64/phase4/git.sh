./configure --prefix=/usr \
	--with-gitconfig=/etc/gitconfig \
	--with-python=python3 &&
	make

if $RUN_TESTS; then
	set +e
	make check
	set -e
fi

make perllibdir=/usr/lib/perl5/5.40/site_perl install

echo "git 2.64 installed on $(date)" >>/var/log/packages.log
