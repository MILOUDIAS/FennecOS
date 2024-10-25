pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Jinja2

echo "jinja2 installed on $(date)" >>/var/log/packages.log
