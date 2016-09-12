#! /bin/bash

T_SLEEP=0.01
N_LOOP=20
NAMES="wiiboard1 wiiboard2 temperature"

get_temperature() {
    echo $(($RANDOM * 42 / 32767))
}
if hash awk 2>/dev/null; then
  get_temperature() {
    awk "BEGIN { print $RANDOM * 42.123 / 32767 }"
  }
fi

for i in $(seq $N_LOOP); do
  for f in $NAMES; do
    echo "$(date +%s.%N) $(get_temperature)" >> $f.txt
  done
  sleep $T_SLEEP
done

for f in *.txt; do
  n=${f%.*}
  ./txt2js.py $n < $f > $n.js
done

xdg-open index-rickshaw.html
