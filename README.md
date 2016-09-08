WiiBee
======

Manage bee hives with RaspberryPi 3, Wii Fit Balance Board, and a WittyPi.

The shutdown command is located on the USB autorun script, this way if you want
to use the Raspberry, you can simply remove the USB drive.

```
wbb 6V 27mA: stream
       25mA: status
    5V 32mA: stream
       30mA: status
```

* https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/
* https://www.leboncoin.fr/consoles_jeux_video/offres/midi_pyrenees/haute_garonne?q=wii+fit&pe=3
* http://www.uugear.com/product/wittypi2/
* http://www.uugear.com/portfolio/use-witty-pi-2-to-build-solar-powered-time-lapse-camera/


TODO
----

Studdy the Wii Fit Balance Board battery and sync button connector electic
wiring, see if can get rid of the relay and short-circuit the red sync button
directly with the Raspberry Pi GPIO.

* https://www.ifixit.com/Guide/Disassembling+Wii+Balance+Board/6474#s27965
* https://www.ifixit.com/Guide/Wii+Balance+Board+Frame+Replacement/30899

Log temperature using `get_temperature` from `wittyPi/utilities.sh:415`
* https://github.com/uugear/Witty-Pi-2/blob/master/wittyPi/utilities.sh#L415

```
. wittyPi/utilities.sh
for i in $(seq $NLOOP); do
  temp=$(get_temperature)
  date=$(date +%s.%N)
  echo "$temp $date" >> temperature.txt
  sleep 0.1
done
```


* https://www.mjmwired.net/kernel/Documentation/thermal/sysfs-api.txt

```
watch -n1 "cat /sys/class/hwmon/hwmon*/temp*_input"
watch -n1 "cat /sys/class/thermal/thermal_zone*/temp"
```
