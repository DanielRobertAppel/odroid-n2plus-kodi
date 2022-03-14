#!/bin/bash

# Stop the blinking blue light

if [[ $USER != 'root' ]]; then
    printf "\nscript must be run as root\n"
    exit 0
fi


if [[ -d /sys/class/leds/blue\:heartbeat/trigger ]]; then
    echo "none" > /sys/class/leds/blue\:heartbeat/trigger
    printf "\n>Turn off Blue LED after bootup sequence? Y/N: "
    read -p stop_blink_on_boot
    STOP_BLINK_ON_BOOT=$stop_blink_on_boot
    case $STOP_BLINK_ON_BOOT in
        n|N)
            printf "\n>Blinking LED preference will not persist on next reboot\n"
            exit 0
        ;;
        y|Y)
            printf "\n>Installing crontab task to turn off blinking LED...\n"
            cat >/usr/bin/stop_blue_led.sh <<EOF
                #!/bin/bash
                echo "none" > /sys/class/leds/blue\:heartbeat/trigger

EOF
            chmod +x /usr/bin/stop_blue_led.sh
            (crontab -l; echo "@reboot /usr/bin/stop_blue_led.sh") | sort -u | crontab -
            printf "\nDone.\n"
        ;;
    esac
fi

if [[ -d /sys/class/leds/n2\:blue/trigger ]]; then
    echo "none" > /sys/class/leds/n2\:blue/trigger
    printf "\n>Turn off Blue LED after bootup sequence? Y/N: "
    read -p stop_blink_on_boot
    STOP_BLINK_ON_BOOT=$stop_blink_on_boot
    case $STOP_BLINK_ON_BOOT in
        n|N)
            printf "\n>Blinking LED preference will not persist on next reboot\n"
            exit 0
        ;;
        y|Y)
            printf "\n>Installing crontab task to turn off blinking LED...\n"
            cat >/usr/bin/stop_blue_led.sh <<EOF
                #!/bin/bash
                echo "none" > /sys/class/leds/n2\:blue/trigger

EOF
            chmod +x /usr/bin/stop_blue_led.sh
            (crontab -l; echo "@reboot /usr/bin/stop_blue_led.sh") | sort -u | crontab -
            printf "\nDone.\n"
        ;;
    esac
fi