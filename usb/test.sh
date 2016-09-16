#! /bin/bash

T_SLEEP=0.01
N_LOOP=20

get_temperature() {
    echo $(($RANDOM * 42 / 32767))
}
if hash awk 2>/dev/null; then
  get_temperature() {
    awk "BEGIN { print $RANDOM * 42.123 / 32767 }"
  }
fi

for i in $(seq $N_LOOP); do
    echo "$(date +%s.%N) $(get_temperature) $(get_temperature) $(get_temperature) $(get_temperature) $(get_temperature)" >> wiibee.txt
    sleep $T_SLEEP
done
python txt2js.py wiibee < wiibee.txt > wiibee.js

xdg-open index-dygraph.html
