pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools

echo "setuptools installed on $(date)" >>/var/log/packages.log
