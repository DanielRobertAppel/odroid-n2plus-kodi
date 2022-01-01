# Common Apt Issues
## Need to overwrite an existing config file:
<code>sudo apt-get -o Dpkg::Options::="--force-overwrite" install $PKG_NAME</code>