#!/bin/bash

PROG_NAME="libmali"
PROG_VERSION="d4000def121b818ae0f583d8372d57643f723fdc"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://github.com/LibreELEC/libmali/archive/$PROG_VERSION.tar.gz"
PROG_DEPENDS="libdrm"
PROG_DESCRIPTION="OpenGL ES user-space binary for the ARM Mali GPU family"
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo chmod +x /usr/bin/libmali-setup && sudo systemctl daemon-reload && sudo systemctl enable libmali-setup && sudo ldconfig"
wget $PROG_EXTERNAL_LOCATION
tar xvf $PROG_VERSION.tar.gz
cd $PROG_NAME-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr/bin
mkdir -p $PKG_DESTINATION_PATH/etc/system.d/system/
cmake \
	-DMALI_VARIANT="mali-bifrost" \
	-DMALI_ARCH=aarch64-linux-gnu
make -j 6
make install
cp -v scripts/libmali-setup $PKG_DESTINATION_PATH/usr/bin/
cp -v system.d/*.service $PKG_DESTINATION_PATH/etc/system.d/system/ 
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
