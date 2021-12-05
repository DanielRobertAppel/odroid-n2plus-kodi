#!/bin/bash

PROG_NAME="v4l-utils"
PROG_VERSION="1.22.1"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="http://linuxtv.org/downloads/v4l-utils/$PROG_NAME-$PROG_VERSION.tar.bz2"
PROG_DEPENDS="alsa-lib, elfutils, ir-bpf-decoders, libbpf, systemd, zlib1g"
PROG_DESCRIPTION="Linux V4L2 and DVB API utilities and v4l libraries (libv4l)."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget $PROG_EXTERNAL_LOCATION
tar xvjf $PROG_NAME-$PROG_VERSION.tar.bz2
cd $PROG_NAME-$PROG_VERSION
if [ -d $PKG_DESTINATION_PATH ]; then
	rm -rf $PKG_DESTINATION_PATH
fi
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr/bin
mkdir -p $PKG_DESTINATION_PATH/usr/config
mkdir -p $PKG_DESTINATION_PATH/usr/udev/rules.d
mkdir -p $PKG_DESTINATION_PATH/usr/udev/rc_keymaps
mkdir -p $PKG_DESTINATION_PATH/usr/lib
mkdir -p $PKG_DESTINATION_PATH/etc
./configure \
	--without-jpeg \
    --enable-bpf \
    --enable-static \
    --disable-shared \
    --disable-doxygen-doc \
	--prefix=$PKG_DESTINATION_PATH
make -C utils/keytable
make -C utils/ir-ctl
make -C utils/libcecutil
make -C utils/cec-ctl
make -C lib
make -C utils/dvb
make -C utils/v4l2-ctl
make install DESTDIR=${PKG_DESTINATION_PATH} PREFIX=/usr -C utils/keytable
make install DESTDIR=${PKG_DESTINATION_PATH} PREFIX=/usr -C utils/ir-ctl
make install DESTDIR=${PKG_DESTINATION_PATH} PREFIX=/usr -C utils/cec-ctl
make install DESTDIR=${PKG_DESTINATION_PATH} PREFIX=/usr -C utils/dvb
make install DESTDIR=${PKG_DESTINATION_PATH} PREFIX=/usr -C utils/v4l2-ctl
cp contrib/lircd2toml.py $PKG_DESTINATION_PATH/usr/bin/
mv $PKG_DESTINATION_PATH/lib $PKG_DESTINATION_PATH/usr/
cp -PR ../udev.d/*.rules $PKG_DESTINATION_PATH/usr/lib/udev/rules.d
cp -PR ../config/* $PKG_DESTINATION_PATH/usr/config


# Print metadata into the control file
printf "Package: $PROG_NAME\nVersion: $PROG_VERSION\nArchitecture: $ARCHITECTURE\nEssential: no\nPriority: optional\nDepends: $PROG_DEPENDS\nMaintainer: Daniel Appel\nDescription: $PROG_DESCRIPTION\n" > $PKG_DESTINATION_PATH/DEBIAN/control

function pre_install_creator {
	if [[ $PRE_INSTALL = 'yes' ]]; then
		printf '#!/bin/bash\n' > $PKG_DESTINATION_PATH/DEBIAN/preinst
		printf "$PRE_INSTALL_INSTRUCTIONS" >> $PKG_DESTINATION_PATH/DEBIAN/preinstall
		chmod 755 $PKG_DESTINATION_PATH/DEBIAN/preinstall
	else
		printf "\nno pre installation script required\n"
	fi

}

function post_install_creator {
	if [[ $POST_INSTALL = 'yes' ]]; then
		printf '#!/bin/bash\n' > $PKG_DESTINATION_PATH/DEBIAN/postinst
		printf "$POST_INSTALL_INSTRUCTIONS" >> $PKG_DESTINATION_PATH/DEBIAN/postinst
		chmod 755 $PKG_DESTINATION_PATH/DEBIAN/postinst 
	else
		printf "\nno post installation script required\n"
	fi
}

pre_install_creator
post_install_creator

# Create the deb package
dpkg-deb --build $PKG_DESTINATION_PATH
