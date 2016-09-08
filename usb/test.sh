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

./txt2js.py temperature < temperature.txt > temperature.js
./txt2js.py wiiboard1 < wiiboard1.txt > wiiboard1.js
./txt2js.py wiiboard2 < wiiboard2.txt > wiiboard2.js

xdg-open index.html
