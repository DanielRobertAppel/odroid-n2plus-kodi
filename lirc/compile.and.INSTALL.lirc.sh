#!/bin/bash

###
# This script will compile and INSTALL lirc on your host system
###

PROG_NAME="lirc"
PROG_VERSION="0.10.1"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://sourceforge.net/projects/lirc/files/LIRC/$PROG_VERSION/$PROG_NAME-$PROG_VERSION.tar.bz2"
PROG_DEPENDS="libc6"
PROG_DESCRIPTION="LIRC is a package that allows you to decode and send infra-red signals."
wget $PROG_EXTERNAL_LOCATION
tar xvjf $PROG_NAME-$PROG_VERSION.tar.bz2
cd $PROG_NAME-$PROG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
./autogen.sh
./configure \
	--enable-devinput \
	--enable-uinput \
	--with-gnu-ld \
	--without-x \
	--runstatedir=/var/run
sudo make -j 6
sudo make install
sudo ldconfig
