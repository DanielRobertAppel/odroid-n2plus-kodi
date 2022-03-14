#!/bin/bash

sudo apt-get --yes install \
    autoconf \
    binutils \
    build-essential \
    bzip2 \
    cmake \
    fontconfig \
    git \
    git-core \
    libaio-dev \
    libao-dev \
    libaom-dev \
    libasound2-dev \
    libass-dev \
    libavahi-compat-libdnssd-dev \
    libbluetooth-dev \
    libbluray-dev \
    libbz2-dev \
    libcap-dev \
    libcec-dev \
    libcrossguid-dev \
    libcurl4-openssl-dev \
    libdrm-dev \
    libdvdnav-dev \
    libdvdread-dev \
    libegl-dev \
    libegl1-mesa-dev \
    libflatbuffers-dev \
    libfmt-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libfstrcmp-dev \
    libgbm-dev \
    libgif-dev \
    libgles-dev \
    libgnutls28-dev \
    libidn2-dev \
    libinput-dev \
    libiso9660-dev \
    libjpeg-turbo8-dev \
    liblircclient-dev \
    libltdl-dev \
    liblzma-dev \
    liblzo2-dev \
    libmicrohttpd-dev \
    libmp3lame-dev \
    libmysqlclient-dev \
    libnfs-dev \
    libnuma-dev \
    libopenjp2-7-dev \
    libpam0g-dev \
    libplist-dev \
    libsdl2-dev \
    libsmbclient-dev \
    libspdlog-dev \
    libspeex-dev \
    libsqlite3-dev \
    libssl-dev \
    libtag1-dev \
    libtinyxml-dev \
    libtool \
    libudev-dev \
    libunistring-dev \
    libusb-1.0-0-dev \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    libxcb1-dev \
    libxkbcommon-dev \
    libxml2-dev \
    libxslt1-dev \
    libxvidcore-dev \
    lzop \
    make \
    meson \
    ncurses-term \
    ninja-build \
    openjdk-11-jre-headless \
    openssl \
    p7zip-full \
    pcre2-utils \
    pkg-config \
    python3-pip \
    rapidjson-dev \
    software-properties-common \
    speex \
    swig \
    texinfo \
#    wayland-protocols \
#    waylandpp-dev \
    wget \
    xsltproc \
    yasm \
    zlib1g \
    zlib1g-dev

sudo -H pip3 install meson mako
sudo ldconfig
sudo usermod -a -G video,input root
sudo usermod -a -G video,input odroid