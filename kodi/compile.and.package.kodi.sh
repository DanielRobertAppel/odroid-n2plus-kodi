#!/bin/bash

PROG_NAME="kodi"
PROG_VERSION="08b7599d63e063545e34a24bb17fc3738cd4dde7"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://github.com/xbmc/xbmc/archive/$PROG_VERSION.tar.gz"
PROG_DEPENDS="libc6"
PROG_DESCRIPTION="A free and open source cross-platform media player."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget -O $PROG_NAME-$PROG_VERSION.tar.gz $PROG_EXTERNAL_LOCATION
tar xvf $PROG_NAME-$PROG_VERSION.tar.gz
cd xbmc-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
mkdir build
cd build
cmake \
	-DCMAKE_BUILD_TYPE="Release" \
	-DCMAKE_INSTALL_PREFIX=$PKG_DESTINATION_PATH \
	-DFFMPEG_PATH=/usr/lib \
	-DENABLE_INTERNAL_FFMPEG=OFF \
	-DENABLE_INTERNAL_CROSSGUID=OFF \
	-DENABLE_INTERNAL_UDFREAD=OFF \
	-DENABLE_INTERNAL_SPDLOG=OFF \
	-DENABLE_UDEV=ON \
	-DENABLE_DBUS=ON \
	-DENABLE_XSLT=ON \
	-DENABLE_CCACHE=ON \
	-DENABLE_LIRCCLIENT=ON \
	-DENABLE_EVENTCLIENTS=ON \
	-DENABLE_LDGOLD=ON \
	-DENABLE_DEBUGFISSION=OFF \
	-DENABLE_APP_AUTONAME=OFF \
	-DENABLE_TESTING=OFF \
	-DENABLE_INTERNAL_FLATBUFFERS=OFF \
	-DENABLE_LCMS2=OFF \
	-DENABLE_NEON=ON \
	-DENABLE_VDPAU=OFF \
	-DENABLE_VAAPI=OFF \
	-DENABLE_CEC=ON \
	-DCORE_PLATFORM_NAME=gbm \
	-DAPP_RENDER_SYSTEM=gles \
	-DENABLE_SMBCLIENT=ON \
	-DENABLE_NFS=ON \
	-DENABLE_DVDCSS=ON \
	-DENABLE_OPTICAL=ON \
	-DENABLE_PULSEAUDIO=OFF \
	-DENABLE_ALSA=ON \
	-DENABLE_AVAHI=ON \
	-DENABLE_UPNP=ON \
	-DENABLE_MARIADBCLIENT=OFF \
	-DENABLE_MYSQLCLIENT=ON \
	-DENABLE_PLIST=ON \
	-DENABLE_AIRTUNES=ON \
	-DENABLE_BLURAY=ON \
	-DWITH_CPU=cortex-a73.cortex-a53 \
	-DWITH_ARCH=aarch64 \
	../
make -j 6
make install
cd ../../


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
