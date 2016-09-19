#! /bin/bash

# Relay PIN, see: http://pinout.xyz/pinout/wiringpi
GPIOS="4 5" # http://pinout.xyz/pinout/pin16_gpio23
# use: hcitool scan, or: python wiiboard.py
BTADDR="00:1e:35:fd:11:fc 00:22:4c:6e:12:6c"

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
python autorun.py $BTADDR 2>> autorun.log >> wiibee.txt
logger "Stoped listenning"
python txt2js.py wiibee < wiibee.txt > wiibee.js
git commit wiibee.js -m"[data] $(date -Is)"
# TODO git push ssh master

[ -z "$WIIBEE_SHUTDOWN" ] && exit 0
logger "Shutdown WittyPi"
# http://www.uugear.com/portfolio/use-witty-pi-2-to-build-solar-powered-time-lapse-camera/
# shutdown Raspberry Pi by pulling down GPIO-4
gpio -g mode 4 out
gpio -g write 4 0  # optional

logger "Shutdown Raspberry"
shutdown -h now
