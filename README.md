WiiBee
======

Manage beehives with RaspberryPi 3, Wii Fit Balance Board, and a WittyPi.

The shutdown command is located on the USB autorun script, this way if you want
to use the Raspberry, you can simply remove the USB drive.

The balance power consumtion is around 160mW.

| mode \\ voltage |  6V  |  5V  |
| --------------- | ---- | ---- |
|    stream       | 27mA | 32mA |
|    status       | 25mA | 30mA |


* http://www.uugear.com/product/wittypi2/
* http://www.uugear.com/portfolio/use-witty-pi-2-to-build-solar-powered-time-lapse-camera/
* https://www.leboncoin.fr/consoles_jeux_video/offres?q=wii+fit&pe=3


TODO
----

Studdy the Wii Fit Balance Board battery and sync button connector electric
wiring, see if can get rid of the relay and short-circuit the red sync button
directly with the Raspberry Pi GPIO. See if the GPIO's 3.3V are enough.

* https://www.ifixit.com/Guide/Disassembling+Wii+Balance+Board/6474#s27965
* https://www.ifixit.com/Guide/Wii+Balance+Board+Frame+Replacement/30899
* https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/

Check if other thermal sensor are available:

```
watch -n1 "cat /sys/class/hwmon/hwmon*/temp*_input"
watch -n1 "cat /sys/class/thermal/thermal_zone*/temp"
```
