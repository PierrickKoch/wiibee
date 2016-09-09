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

pids=""

for i in $(seq $N_LOOP); do
  echo "$(date +%s.%N) $(get_temperature)"
  sleep $T_SLEEP
done > wiiboard1.txt & pids="$! $pids"

for i in $(seq $N_LOOP); do
  echo "$(date +%s.%N) $(get_temperature)"
  sleep $T_SLEEP
done > wiiboard2.txt & pids="$! $pids"

for i in $(seq $N_LOOP); do
  echo "$(date +%s.%N) $(get_temperature)"
  sleep $T_SLEEP
done > temperature.txt & pids="$! $pids"

wait $pids

for f in *.txt; do
  n=${f%.*}
  ./txt2js.py $n < $f > $n.js
done

xdg-open index.html
