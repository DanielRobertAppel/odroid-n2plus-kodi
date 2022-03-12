#!/bin/bash

#####
# Kodi Build Dependencies Ubuntu 20.04
#####

if [[ $USER != 'root' ]]; then
    printf "\nscript must be run as root\n"
	exit 0
fi

apt-get install -y libasound2-dev \
liblircclient-dev \
liblzo2-dev \
libssl-dev \
libtag1-dev \
libegl-dev \
libgles-dev \
libmysqlclient-dev \
wayland-protocols \
waylandpp-dev \
libmicrohttpd-dev
