#! /bin/bash

DEBUG="-d" # set DEBUG="" to disable verbose log

GPIO1=16 # http://pinout.xyz/pinout/pin16_gpio23
GPIO2=18 # http://pinout.xyz/pinout/pin18_gpio24
BTADDR1="00:1e:35:fd:11:fc"
BTADDR2="00:22:4c:6e:12:6c"
N_LOOP=10
T_SLEEP=2

logger "Simulate press red sync button on the Wii Board"

. wtp_temp.sh # provides get_temperature()

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
python wiiboard.py $DEBUG $BTADDR1 2>> wiiboard1.log >> wiiboard1.txt & pids="$! $pids"
python wiiboard.py $DEBUG $BTADDR2 2>> wiiboard2.log >> wiiboard2.txt & pids="$! $pids"

for i in $(seq $N_LOOP); do
  echo "$(date +%s.%N) $(get_temperature)" >> temperature.txt
  # https://www.kernel.org/doc/Documentation/thermal/sysfs-api.txt
  t=$(awk '{ print $N / 1000.0 }' /sys/class/thermal/thermal_zone0/temp)
  echo "$(date +%s.%N) $t" >> temperature_cpu.txt
  # http://www.elinux.org/RPI_vcgencmd_usage
  t=$(/opt/vc/bin/vcgencmd measure_temp|cut -c6-9)
  echo "$(date +%s.%N) $t" >> temperature_gpu.txt
  sleep $T_SLEEP
done & pids="$! $pids"

wait $pids

for f in *.txt; do
  n=${f%.*}
  python txt2js.py $n < $f > $n.js
done

[ -z "$WIIBEE_SHUTDOWN" ] && exit 0
logger "Shutdown WittyPi"
# http://www.uugear.com/portfolio/use-witty-pi-2-to-build-solar-powered-time-lapse-camera/
# shutdown Raspberry Pi by pulling down GPIO-4
gpio -g mode 4 out
gpio -g write 4 0  # optional

logger "Shutdown Raspberry"
shutdown -h now
