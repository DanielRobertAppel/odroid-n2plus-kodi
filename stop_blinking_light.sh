#!/bin/bash

# Stop the blinking blue light

if [[ $USER != 'root' ]]; then
    printf "\nscript must be run as root\n"
    exit 0
fi

function control_blink_on_boot {
    LED_CONTROL_FILE="${2}"
    case $1 in
      n|N)
        printf "\n>Blinking LED preference will not persist on next reboot\n"
      ;;
      y|Y)
        printf "\n>Installing crontab task to turn off blinking LED...\n"
            cat >/usr/bin/stop_blue_led.sh <<EOF
#!/bin/bash
echo "none" > $LED_CONTROL_FILE
EOF
            chmod +x /usr/bin/stop_blue_led.sh
            (crontab -l; echo "@reboot /usr/bin/stop_blue_led.sh") | sort -u | crontab -
            printf "\nDone.\n"
        ;;
    esac
}


if [[ -f /sys/class/leds/blue\:heartbeat/trigger ]]; then
    echo "none" > /sys/class/leds/blue\:heartbeat/trigger
    printf "\n>Turn off Blue LED after bootup sequence? Y/N: "
    read -r stop_blink_on_boot
    control_blink_on_boot $stop_blink_on_boot /sys/class/leds/blue\:heartbeat/trigger
fi

if [[ -f /sys/class/leds/n2\:blue/trigger ]]; then
    echo "none" > /sys/class/leds/n2\:blue/trigger
    printf "\n>Turn off Blue LED after bootup sequence? Y/N: "
    read -r stop_blink_on_boot
    control_blink_on_boot $stop_blink_on_boot /sys/class/leds/n2\:blue/trigger
fi