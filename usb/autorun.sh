#! /bin/bash

DEBUG="-d" # set DEBUG="" to disable verbose log

GPIO1=16 # http://pinout.xyz/pinout/pin16_gpio23
GPIO2=18 # http://pinout.xyz/pinout/pin18_gpio24
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

pids=""
# https://github.com/pierriko/wiiboard
./wiiboard.py $DEBUG BTADDR1 2>> wiiboard1.log >> wiiboard1.txt & pids="$! $pids"
./wiiboard.py $DEBUG BTADDR2 2>> wiiboard2.log >> wiiboard2.txt & pids="$! $pids"
./temperature.sh >> temperature.txt & pids="$! $pids"

wait $pids
shutdown -h now
