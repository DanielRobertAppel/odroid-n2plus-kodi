#!/bin/bash

# first time run after fresh OS flash/install
if [[ $USER != 'root' ]]; then
    printf "\nscript must be run as root\n"
    exit 0
fi

apt-get update
apt-get --yes upgrade
bash ./setup_keyboard.sh
bash ./stop_blinking_light.sh
cd 00_build_env && bash ./get-build-dependencies.sh
cd ../
bash install-ffmpeg-from-scratch.sh
printf "\nSystem rebooting in 5 seconds\n"
sleep 5
reboot