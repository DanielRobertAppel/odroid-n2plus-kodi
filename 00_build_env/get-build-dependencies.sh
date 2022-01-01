#!/bin/bash

sudo apt-get install \
    ninja-build \
    cmake \
    make \
    speex \
    pkg-config \
    python3-pip \
    libidn2-dev \
    libdrm-dev \
    libspeex-dev \
    libudev-dev \
    libbz2-dev \
    git \
    p7zip-full \
    binutils \
    bzip2 \
    libaio-dev \
    libxml2-dev \
    lzop \
    ncurses-term \
    openssl \
    libpam0g-dev \
    libtool \
    libltdl-dev \
    libao-dev \
    libavahi-compat-libdnssd-dev

sudo -H pip3 install meson
    
sudo dpkg-reconfigure keyboard #let user choose keyboard layout ffs