#!/bin/bash

PROG_NAME="lirc"
PROG_VERSION="0.10.1"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://sourceforge.net/projects/lirc/files/LIRC/$PROG_VERSION/$PROG_NAME-$PROG_VERSION.tar.bz2"
PROG_DEPENDS="libc6"
PROG_DESCRIPTION="LIRC is a package that allows you to decode and send infra-red signals."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget $PROG_EXTERNAL_LOCATION
tar xvjf $PROG_NAME-$PROG_VERSION.tar.bz2
cd $PROG_NAME-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
mkdir -p $PKG_DESTINATION_PATH/etc
./autogen.sh
./configure \
	--enable-devinput \
	--enable-uinput \
	--with-gnu-ld \
	--without-x \
	--runstatedir=/var/run
	--prefix=$PKG_DESTINATION_PATH/usr
	--sysconfigdir=$PKG_DESTINATION_PATH/etc
make -j 6
make install
cd ../


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
