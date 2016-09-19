#! /bin/bash

DEBUG="" # set DEBUG="" to disable verbose log

GPIO1=4 # http://pinout.xyz/pinout/pin16_gpio23
GPIO2=5 # http://pinout.xyz/pinout/pin18_gpio24
BTADDR1="00:1e:35:fd:11:fc"
BTADDR2="00:22:4c:6e:12:6c"

logger "Simulate press red sync button on the Wii Board"
# http://wiringpi.com/the-gpio-utility/
gpio mode $GPIO1 out
gpio mode $GPIO2 out
gpio write $GPIO1 0
gpio write $GPIO2 0
sleep 0.2
gpio write $GPIO1 1
gpio write $GPIO2 1

logger "Start listenning to the mass measurements"
python autorun.py $DEBUG $BTADDR1 $BTADDR2 2>> wiibee.log >> wiibee.txt
logger "Stoped listenning"
python txt2js.py wiibee < wiibee.txt > wiibee.js

[ -z "$WIIBEE_SHUTDOWN" ] && exit 0
logger "Shutdown WittyPi"
# http://www.uugear.com/portfolio/use-witty-pi-2-to-build-solar-powered-time-lapse-camera/
# shutdown Raspberry Pi by pulling down GPIO-4
gpio -g mode 4 out
gpio -g write 4 0  # optional

logger "Shutdown Raspberry"
shutdown -h now
