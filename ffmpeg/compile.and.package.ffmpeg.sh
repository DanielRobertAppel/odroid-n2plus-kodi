#!/bin/bash

PROG_NAME="ffmpeg"
PROG_VERSION="4.4-custom-amlogic"
PKG_VERSION="9f237dd0247797f89860302dac60c32cda48a9f9"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://github.com/jc-kynesim/rpi-ffmpeg/archive/$PKG_VERSION.tar.gz"
PROG_DEPENDS="zlib, bzip2, gnutls, speex"
PROG_DESCRIPTION="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget -O $PROG_NAME-$PROG_VERSION.tar.gz $PROG_EXTERNAL_LOCATION
tar xvf $PROG_NAME-$PROG_VERSION.tar.gz
cd rpi-ffmpeg-$PKG_VERSION
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
git apply ../patches/libreelec/*.patch
git apply ../patches/rpi/*.patch
git apply ../patches/v4l2-drmprime/*.patch
git apply ../patches/v4l2-request/*.patch
./configure \
	--enable-hwaccels \
	--enable-v4l2_m2m \
	--enable-libdrm \
	--enable-libudev \
	--enable-v4l2-request \
	--enable-neon \
	--enable-libdav1d \
	--disable-static \
	--enable-shared \
	--enable-gpl \
	--disable-version3 \
	--enable-logging \
	--disable-doc \
	--enable-pic \
	--enable-optimizations \
    --disable-extra-warnings \
    --disable-programs \
    --enable-avdevice \
    --enable-avcodec \
    --enable-avformat \
    --enable-swscale \
    --enable-postproc \
    --enable-avfilter \
    --disable-devices \
    --enable-pthreads \
    --enable-network \
    --enable-gnutls \
	--disable-openssl \
    --disable-gray \
    --enable-swscale-alpha \
    --disable-small \
    --enable-dct \
    --enable-fft \
    --enable-mdct \
    --enable-rdft \
    --disable-crystalhd \
	--enable-runtime-cpudetect \
    --disable-hardcoded-tables \
    --disable-encoders \
    --enable-encoder=ac3 \
    --enable-encoder=aac \
    --enable-encoder=wmav2 \
    --enable-encoder=mjpeg \
    --enable-encoder=png \
	--disable-muxers \
    --enable-muxer=spdif \
    --enable-muxer=adts \
    --enable-muxer=asf \
    --enable-muxer=ipod \
    --enable-muxer=mpegts \
    --enable-demuxers \
    --enable-parsers \
    --enable-bsfs \
    --enable-protocol=http \
    --disable-indevs \
    --disable-outdevs \
    --enable-filters \
    --disable-avisynth \
    --enable-bzlib \
    --disable-lzma \
    --disable-alsa \
    --disable-frei0r \
    --disable-libopencore-amrnb \
    --disable-libopencore-amrwb \
    --disable-libopencv \
    --disable-libdc1394 \
    --disable-libfreetype \
    --disable-libgsm \
    --disable-libmp3lame \
    --disable-libopenjpeg \
    --disable-librtmp \
	--enable-libspeex \
    --disable-libtheora \
    --disable-libvo-amrwbenc \
    --disable-libvorbis \
    --disable-libvpx \
    --disable-libx264 \
    --disable-libxavs \
    --disable-libxvid \
    --enable-zlib \
    --enable-asm \
    --disable-altivec \
	--disable-symver \
	--prefix=$PKG_DESTINATION_PATH/usr
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
