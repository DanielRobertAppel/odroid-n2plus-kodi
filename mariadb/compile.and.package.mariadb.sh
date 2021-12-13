#!/bin/bash

PROG_NAME="mariadb"
PROG_VERSION="10.4.21"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://downloads.mariadb.com/MariaDB/$PROG_NAME-$PROG_VERSION/source/$PROG_NAME-$PROG_VERSION.tar.gz"
PROG_DEPENDS="binutils, bzip2, libaio1, libxml2, lzop, ncurses-term, openssl, systemd, zlib1g"
PROG_DESCRIPTION="MariaDB is a community-developed fork of the MySQL."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget $PROG_EXTERNAL_LOCATION
tar xvf $PROG_NAME-$PROG_VERSION.tar.gz
cd $PROG_NAME-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
./configure \
    -DCMAKE_INSTALL_MESSAGE=NEVER \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_CONFIG=mysql_release \
    -DFEATURE_SET=classic \
    -DSTACK_DIRECTION=1 \
    -DDISABLE_LIBMYSQLCLIENT_SYMBOL_VERSIONING=ON \
    -DCMAKE_CROSSCOMPILING=ON \
    -DWITHOUT_AWS_KEY_MANAGEMENT=ON \
    -DWITH_EXTRA_CHARSETS=complex \
    -DWITH_SSL=system \
    -DWITH_SSL=/usr \
    -DWITH_JEMALLOC=OFF \
    -DWITH_PCRE=bundled \
    -DWITH_ZLIB=bundled \
    -DWITH_EDITLINE=bundled \
    -DWITH_LIBEVENT=bundled \
    -DCONNECT_WITH_LIBXML2=bundled \
    -DSKIP_TESTS=ON \
    -DWITH_DEBUG=OFF \
    -DWITH_UNIT_TESTS=OFF \
    -DENABLE_DTRACE=OFF \
    -DSECURITY_HARDENED=OFF \
    -DWITH_EMBEDDED_SERVER=OFF \
    -DWITHOUT_SERVER=OFF \
    -DPLUGIN_AUTH_SOCKET=STATIC \
    -DDISABLE_SHARED=NO \
    -DENABLED_PROFILING=OFF \
    -DENABLE_STATIC_LIBS=OFF \
    -DMYSQL_UNIX_ADDR=/var/run/mysqld/mysqld.sock \
    -DWITH_SAFEMALLOC=OFF \
    -DWITHOUT_AUTH_EXAMPLES=ON \
	--prefix=$PKG_DESTINATION_PATH/usr
ninja
ninja install
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
