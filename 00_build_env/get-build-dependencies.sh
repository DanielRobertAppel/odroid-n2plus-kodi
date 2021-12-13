#!/bin/bash

sudo apt-get install \
    ninja-build \
    cmake \
    make \
    speex \
    # debian-packager-package \
    python3-pip \
    libidn2-dev \
    libdrm-dev \
    libspeex-dev \
    libudev-dev \
    libbz2-dev \
    git \


sudo -H pip3 install meson
    
sudo dpkg-reconfigure keyboard #let user choose keyboard layout ffs