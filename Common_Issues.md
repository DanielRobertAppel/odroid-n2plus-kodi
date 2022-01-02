# Common Apt Issues
## Need to overwrite an existing config file:
<code>sudo apt-get -o Dpkg::Options::="--force-overwrite" install $PKG_NAME</code>
## No keyboard or mouse input after launching kodi
<code>sudo usermod -a -G video,input odroid</code>