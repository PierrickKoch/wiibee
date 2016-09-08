#! /bin/bash

DEBUG="-d" # set DEBUG="" to disable verbose log

GPIO1=16 # http://pinout.xyz/pinout/pin16_gpio23
GPIO2=18 # http://pinout.xyz/pinout/pin18_gpio24
BTADDR1="00:1e:35:fd:11:fc"
BTADDR2="00:22:4c:6e:12:6c"
N_LOOP=10
T_SLEEP=2

# `get_temperature` from `wittyPi/utilities.sh:415` without Fahrenheit
# https://github.com/uugear/Witty-Pi-2/blob/master/wittyPi/utilities.sh#L436
get_temperature()
{
  local ctrl=$(i2c_read 0x01 0x68 0x0E)
  i2c_write 0x01 0x68 0x0E $(($ctrl|0x20))
  sleep 0.2
  local t1=$(i2c_read 0x01 0x68 0x11)
  local t2=$(i2c_read 0x01 0x68 0x12)
  local sign=$(($t1&0x80))
  local c=''
  if [ $sign -ne 0 ] ; then
    c+='-'
    c+=$((($t1^0xFF)+1))
  else
    c+=$(($t1&0x7F))
  fi
  c+='.'
  c+=$(((($t2&0xC0)>>6)*25))
  echo $c
}

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
./wiiboard.py $DEBUG $BTADDR1 2>> wiiboard1.log >> wiiboard1.txt & pids="$! $pids"
./wiiboard.py $DEBUG $BTADDR2 2>> wiiboard2.log >> wiiboard2.txt & pids="$! $pids"

for i in $(seq $N_LOOP); do
  temp=$(get_temperature)
  date=$(date +%s.%N)
  echo "$date $temp"
  sleep $T_SLEEP
done >> temperature.txt & pids="$! $pids"

# https://www.kernel.org/doc/Documentation/thermal/sysfs-api.txt
for i in $(seq $N_LOOP); do
  temp=$(awk '{ print $N / 1000.0 }' /sys/class/thermal/thermal_zone0/temp)
  date=$(date +%s.%N)
  echo "$date $temp"
  sleep $T_SLEEP
done > temperature_cpu.txt & pids="$! $pids"

# http://www.elinux.org/RPI_vcgencmd_usage
for i in $(seq $N_LOOP); do
  temp=$(LD_LIBRARY_PATH=/opt/vc/lib /opt/vc/bin/vcgencmd measure_temp|cut -c6-9)
  date=$(date +%s.%N)
  echo "$date $temp"
  sleep $T_SLEEP
done > temperature_gpu.txt & pids="$! $pids"

wait $pids

./txt2js.py wiiboard1 < wiiboard1.txt > wiiboard1.js
./txt2js.py wiiboard2 < wiiboard2.txt > wiiboard2.js
./txt2js.py temperature < temperature.txt > temperature.js
./txt2js.py temperature_cpu < temperature_cpu.txt > temperature_cpu.js
./txt2js.py temperature_gpu < temperature_gpu.txt > temperature_gpu.js

# http://www.uugear.com/portfolio/use-witty-pi-2-to-build-solar-powered-time-lapse-camera/
# shutdown Raspberry Pi by pulling down GPIO-4
gpio -g mode 4 out
gpio -g write 4 0  # optional

shutdown -h now
