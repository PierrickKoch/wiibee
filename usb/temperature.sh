#! /bin/bash

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

for i in $(seq $N_LOOP); do
  temp=$(get_temperature)
  date=$(date +%s.%N)
  echo "$temp $date"
  sleep $T_SLEEP
done
