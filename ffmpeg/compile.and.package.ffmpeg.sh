#!/bin/bash

PROG_NAME="ffmpeg"
PROG_VERSION="4.4"
ARCHITECTURE="arm64"
PKG_DESTINATION_PATH="$HOME/debpkgs/${PROG_NAME}_${PROG_VERSION}_${ARCHITECTURE}"
PROG_EXTERNAL_LOCATION="https://github.com/jc-kynesim/rpi-ffmpeg/archive/refs/heads/dev/4.4/rpi_import_1.zip"
PROG_DEPENDS="zlib1g, bzip2, gnutls, speex"
PROG_DESCRIPTION="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
PRE_INSTALL="no"
PRE_INSTALL_INSTRUCTIONS=""
POST_INSTALL="yes"
POST_INSTALL_INSTRUCTIONS="sudo ldconfig"
wget $PROG_EXTERNAL_LOCATION
7z x rpi_import_1.zip
cd rpi-ffmpeg-dev*
mkdir -p $PKG_DESTINATION_PATH/DEBIAN
mkdir -p $PKG_DESTINATION_PATH/usr
git apply ../patches/libreelec/*.patch
./configure \
    --disable-alsa \
    --disable-altivec \
    --disable-avisynth \
    --disable-crystalhd \
    --disable-devices \
    --disable-doc \
    --disable-encoders \
    --disable-extra-warnings \
    --disable-frei0r \
    --disable-gray \
    --disable-hardcoded-tables \
    --disable-indevs \
    --disable-libdc1394 \
    --disable-libfreetype \
    --disable-libgsm \
    --disable-libmp3lame \
    --disable-libopencore-amrnb \
    --disable-libopencore-amrwb \
    --disable-libopencv \
    --disable-libopenjpeg \
    --disable-librtmp \
    --disable-libtheora \
    --disable-libvo-amrwbenc \
    --disable-libvorbis \
    --disable-libvpx \
    --disable-libx264 \
    --disable-libxavs \
    --disable-libxvid \
    --disable-lzma \
    --disable-muxers \
    --disable-openssl \
    --disable-outdevs \
    --disable-programs \
    --disable-small \
    --disable-static \
    --disable-symver \
    --disable-version3 \
    --enable-asm \
    --enable-avcodec \
    --enable-avdevice \
    --enable-avfilter \
    --enable-avformat \
    --enable-bsfs \
    --enable-bzlib \
    --enable-dct \
    --enable-demuxers \
    --enable-encoder=aac \
    --enable-encoder=ac3 \
    --enable-encoder=mjpeg \
    --enable-encoder=png \
    --enable-encoder=wmav2 \
    --enable-fft \
    --enable-filters \
    --enable-gnutls \
    --enable-gpl \
    --enable-hwaccels \
    --enable-libdav1d \
    --enable-libdrm \
    --enable-libspeex \
    --enable-libudev \
    --enable-logging \
    --enable-mdct \
    --enable-muxer=adts \
    --enable-muxer=asf \
    --enable-muxer=ipod \
    --enable-muxer=mpegts \
    --enable-muxer=spdif \
    --enable-neon \
    --enable-network \
    --enable-optimizations \
    --enable-parsers \
    --enable-pic \
    --enable-postproc \
    --enable-protocol=http \
    --enable-pthreads \
    --enable-rdft \
    --enable-runtime-cpudetect \
    --enable-shared \
    --enable-swscale \
    --enable-swscale-alpha \
    --enable-v4l2_m2m \
    --enable-v4l2-request \
    --enable-zlib \
    --extra-ldflags="-L/usr/include" \
    --extra-ldflags="-L/usr/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
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
