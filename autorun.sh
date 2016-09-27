#! /bin/bash

# Relay PIN, see: http://pinout.xyz/pinout/wiringpi
GPIOS="4 5" # http://pinout.xyz/pinout/pin16_gpio23
# Bluetooth MAC, use: hcitool scan, or: python wiiboard.py
BTADDR="00:1e:35:fd:11:fc 00:22:4c:6e:12:6c"
#      "00:1e:35:fd:11:fc 00:22:4c:6e:12:6c 00:1e:35:ff:b0:04"

sleep 12 # FIXME "wait" for dhcpd timeout
# if BT failed: sudo systemctl status hciuart.service
hciconfig hci0 || hciattach /dev/serial1 bcm43xx 921600 noflow -
# try /dev/ttyAMA0 or /dev/ttyS0 ?
# try to install raspberrypi-sys-mods
# try apt-get install --reinstall pi-bluetooth
# try rpi-update ?

# try remove miniuart from /boot/config added by wittyPi install ?
# https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=141195
X=0
until hciconfig hci0 up; do
    if [ "$X" > 3 ]; then
        systemctl restart hciuart
    elif [ "$X" > 10 ]; then
        echo "failed to bring up HCI, rebooting"
        /sbin/reboot
    fi
    X=$((X+1))
    sleep 0.2
done

logger "Simulate press red sync button on the Wii Board"
# http://wiringpi.com/the-gpio-utility/
for ngpio in $GPIOS; do
    gpio mode $ngpio out
    gpio write $ngpio 0
done
sleep 0.2
for ngpio in $GPIOS; do
    gpio write $ngpio 1
done

logger "Start listenning to the mass measurements"
python autorun.py $BTADDR >> wiibee.txt
logger "Stoped listenning"
python txt2js.py wiibee < wiibee.txt > wiibee.js
# git commit wiibee.js -m"[data] $(date -Is)"
# TODO git push ssh master

[ -z "$WIIBEE_SHUTDOWN" ] && exit 0
logger "Shutdown WittyPi"
# shutdown Raspberry Pi by pulling down GPIO-4
gpio -g mode 4 out
gpio -g write 4 0  # optional
logger "Shutdown Raspberry"
shutdown -h now # in case WittyPi did not shutdown
