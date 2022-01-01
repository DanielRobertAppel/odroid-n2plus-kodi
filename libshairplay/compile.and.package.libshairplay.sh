#!/bin/bash

PROG_NAME="libshairplay"
PROG_VERSION="096b61ad14c90169f438e690d096e3fcf87e504e"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://github.com/juhovh/shairplay/archive/$PROG_VERSION.tar.gz"
PROG_DEPENDS="avahi-daemon"
PROG_DESCRIPTION="Apple airplay and raop protocol server"
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget -O $PROG_NAME.tar.gz $PROG_EXTERNAL_LOCATION
tar xvf $PROG_NAME.tar.gz
mv shairplay-$PROG_VERSION $PROG_NAME-$PROG_VERSION
cd $PROG_NAME-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr/
./autogen.sh
./configure \
	--prefix=$PKG_DESTINATION_PATH
make -j 6
make install
cd ../
mv $PKG_DESTINATION_PATH/bin $PKG_DESTINATION_PATH/usr/
mv $PKG_DESTINATION_PATH/include $PKG_DESTINATION_PATH/usr/
mv $PKG_DESTINATION_PATH/lib $PKG_DESTINATION_PATH/usr/


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
