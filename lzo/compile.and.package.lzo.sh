#!/bin/bash

PROG_NAME="liblzo2-dev"
PROG_VERSION="2.10"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="http://www.oberhumer.com/opensource/lzo/download/lzo-$PROG_VERSION.tar.gz"
PROG_DEPENDS="libc6"
PROG_DESCRIPTION="A data compression library which is suitable for data de-/compression."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget $PROG_EXTERNAL_LOCATION
tar xvf lzo-$PROG_VERSION.tar.gz
cd lzo-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
./configure \
	--prefix=$PKG_DESTINATION_PATH
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
