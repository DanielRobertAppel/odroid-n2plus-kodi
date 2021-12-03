#!/bin/bash

PROG_NAME="alsa-lib"
PROG_VERSION="1.2.5.1"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://www.alsa-project.org/files/pub/lib/$PROG_NAME-$PROG_VERSION.tar.bz2"
PROG_DEPENDS="libc6"
PROG_DESCRIPTION="ALSA (Advanced Linux Sound Architecture) is the next generation Linux Sound API."
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="ldconfig"
wget $PROG_EXTERNAL_LOCATION
tar xvjf $PROG_NAME-$PROG_VERSION.tar.bz2
cd $PROG_NAME-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/[DEBIAN][usr/config]
git apply ../patches/*.patch
./configure \
	--without-debug \
	--disable-depency-tracking \
	--with-plugindir=/usr/lib/alsa \
	--disable-python \
	--prefix=$PKG_DESTINATION_PATH
make -j 6
make install
cd ../
cp -PR config/modprobe.d $PKG_DESTINATION_PATH/usr/config/
mv $PKG_DESTINATION_PATH/share $PKG_DESTINATION_PATH/usr/
mv $PKG_DESTINATION_PATH/include $PKG_DESTINATION_PATH/usr/


# Print metadata into the control file
printf "Package: $PROG_NAME\nVersion: $PROG_VERSION\nArchitecture: $ARCHITECTURE\nEssential: no\nPriority: optional\nDepends: $PROG_DEPENDS\nMaintainer: Daniel Appel\nDescription: $PROG_DESCRIPTION\n" > $PKG_DESTINATION_PATH/DEBIAN/control


function post_install_creator {
	if [[ $POST_INSTALL = 'yes' ]]; then
		printf '#!/bin/bash\n' > $PKG_DESTINATION_PATH/DEBIAN/postinst
		printf "$POST_INSTALL_INSTRUCTIONS" >> $PKG_DESTINATION_PATH/DEBIAN/postinst
		chmod 755 $PKG_DESTINATION_PATH/DEBIAN/postinst 
	else
		printf "\nno post installation script required\n"
	fi
}


post_install_creator

# Create the deb package
dpkg-deb --build $PKG_DESTINATION_PATH
