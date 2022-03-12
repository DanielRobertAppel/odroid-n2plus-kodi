#!/bin/bash

if [[ $USER != root ]]; then
    printf "\nScript must be run as root\n"
	exit 0
fi

function found_old_source_dir {
	if [[ -d ./$PROG_NAME-$PROG_VERSION ]]; then
        printf "\n$PROG_NAME extracted source code already found on disk. Attempting to uninstall and rebuild from fresh source.\n"
	    cd $PROG_SRC_DIR && make uninstall
	    if [[ -d ./build ]]; then
	        cd build && make uninstall
	    fi
	    rm -rf $PROG_SRC_DIR
	fi
	rm -rf $PROG_NAME-$PROG_VERSION
}

function download_src_code_archive {
    if [[ -f $SRC_CODE_ARCHIVE_FILE ]]; then
	    printf "\nRemoving existing old source code archive and getting a fresh one.\n"
	    rm $SRC_CODE_ARCHIVE_FILE
	fi
	wget $PROG_EXTERNAL_LOCATION
}

function eval_and_extract_archive {
    case $SRC_CODE_ARCHIVE_EXT in
	    'tar.bz')
		    UNARCHIVE_CMD='tar -xvf'
		;;
		'tar.bz2')
		    UNARCHIVE_CMD='tar -xvjf'
		;;
		'tar.gz')
		    UNARCHIVE_CMD='tar -xvf'
		;;
		'tar.xz')
		    UNARCHIVE_CMD='tar -xvf'
		;;
		'zip')
		    UNARCHIVE_CMD='7z x'
		;;
	esac
	$UNARCHIVE_CMD $SRC_CODE_ARCHIVE_FILE
}

BASE_DIR=$PWD

######
# Installing Ccache
######
PROG_NAME=ccache
PROG_VERSION=3.7.12
PROG_EXTERNAL_LOCATION="https://github.com/ccache/ccache/releases/download/v$PROG_VERSION/$PROG_NAME-$PROG_VERSION.tar.xz"
SRC_CODE_ARCHIVE_EXT="tar.xz"
SRC_CODE_ARCHIVE_FILE="$PROG_NAME-$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd ccache
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd $PROG_NAME-$PROG_VERSION
./configure \
	--with-bundled-zlib \
	--prefix=/usr
make -j 4
make install
cd $BASE_DIR
ldconfig

#####
# Installing m4
#####
PROG_NAME="m4"
PROG_VERSION="1.4.19"
PROG_EXTERNAL_LOCATION="http://ftpmirror.gnu.org/m4/$PROG_NAME-$PROG_VERSION.tar.bz2"
SRC_CODE_ARCHIVE_EXT="tar.bz2"
SRC_CODE_ARCHIVE_FILE="$PROG_NAME-$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd m4
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd $PROG_NAME-$PROG_VERSION
./configure \
	gl_cv_func_gettimeofday_clobber=no \
	--prefix=/usr
make -j 4
make install
cd $BASE_DIR
ldconfig


#####
# Installing GMP
#####
PROG_NAME="gmp"
PROG_VERSION="6.2.1"
PROG_EXTERNAL_LOCATION="https://gmplib.org/download/gmp/$PROG_NAME-$PROG_VERSION.tar.xz"
SRC_CODE_ARCHIVE_EXT="tar.xz"
SRC_CODE_ARCHIVE_FILE="$PROG_NAME-$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd gmp
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd $PROG_NAME-$PROG_VERSION
./configure \
	--enable-cxx \
	--enable-static \
	--disable-shared \
	--prefix=$PKG_DESTINATION_PATH/usr
make -j 4
make install
cd $BASE_DIR
ldconfig

#####
# Installing Nettle
#####
PROG_NAME="nettle"
PROG_VERSION="3.7.2"
PROG_EXTERNAL_LOCATION="http://ftpmirror.gnu.org/gnu/nettle/nettle-$PROG_VERSION.tar.gz"
SRC_CODE_ARCHIVE_EXT="tar.gz"
SRC_CODE_ARCHIVE_FILE="$PROG_NAME-$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd nettle
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd $PROG_NAME-$PROG_VERSION
./configure \
	--disable-documentation \
    --disable-openssl \
	--enable-arm-neon \
	--prefix=/usr
make -j 4
make install
cd $BASE_DIR
ldconfig

#####
# Installing GNUTLS
#####
PROG_NAME="gnutls"
PROG_VERSION="3.7.1"
PROG_EXTERNAL_LOCATION="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/$PROG_NAME-$PROG_VERSION.tar.xz"
SRC_CODE_ARCHIVE_EXT="tar.xz"
SRC_CODE_ARCHIVE_FILE="$PROG_NAME-$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd gnutls
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd $PROG_NAME-$PROG_VERSION
./configure \
	--disable-doc \
    --disable-full-test-suite \
    --disable-guile \
    --disable-libdane \
    --disable-padlock \
    --disable-tests \
    --disable-tools \
    --disable-valgrind-tests \
    --enable-local-libopts \
    --with-idn \
    --with-included-libtasn1 \
    --with-included-unistring \
    --without-p11-kit \
    --without-tpm \
	--prefix=/usr
make -j 4
make install
cd $BASE_DIR
ldconfig

#####
# Installing LibShairplay
#####
PROG_NAME="libshairplay"
PROG_VERSION="096b61ad14c90169f438e690d096e3fcf87e504e"
PROG_EXTERNAL_LOCATION="https://github.com/juhovh/shairplay/archive/$PROG_VERSION.tar.gz"
SRC_CODE_ARCHIVE_EXT="tar.gz"
SRC_CODE_ARCHIVE_FILE="$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd libshairplay
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd shairplay-$PROG_VERSION
./autogen.sh
./configure \
	--prefix=/usr
make -j 4
make install
cd $BASE_DIR
ldconfig

#####
# Installing Dav1d
#####
PROG_NAME="dav1d"
PROG_VERSION="0.9.2"
PROG_EXTERNAL_LOCATION="https://code.videolan.org/videolan/dav1d/-/archive/$PROG_VERSION/dav1d-${PROG_VERSION}.tar.bz2"
SRC_CODE_ARCHIVE_EXT="tar.bz2"
SRC_CODE_ARCHIVE_FILE="$PROG_NAME-$PROG_VERSION.$SRC_CODE_ARCHIVE_EXT"
cd dav1d
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd $PROG_NAME-$PROG_VERSION
meson builddir/ \
	-Denable_tools=false \
	-Denable_tests=false \
	--prefix=/usr
ninja -C builddir/ install
cd $BASE_DIR
ldconfig


#####
# Installing ffmpeg
#####
PROG_NAME="ffmpeg"
PROG_VERSION="4.4"
PROG_EXTERNAL_LOCATION="https://github.com/jc-kynesim/rpi-ffmpeg/archive/refs/heads/dev/4.4/rpi_import_1.zip"
SRC_CODE_ARCHIVE_EXT="zip"
SRC_CODE_ARCHIVE_FILE="rpi_import_1.zip"
cd ffmpeg
found_old_source_dir
download_src_code_archive
eval_and_extract_archive
cd rpi-ffmpeg-dev*
git apply ../patches/libreelec/*.patch
./configure \
	--extra-ldflags="-L/usr/lib" \
    --extra-ldflags="-L/usr/include" \
	--extra-libs="-lpthread -lm" \
  	--ld="g++" \
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
	--enable-ffplay \
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
	--prefix=/usr
make -j 4
make install
cd $BASE_DIR
ldconfig