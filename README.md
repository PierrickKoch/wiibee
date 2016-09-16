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

Studdy the Wii Fit Balance Board electric wiring,
find how can we read mass directly from the strain gauges.

* https://www.ifixit.com/Guide/Disassembling+Wii+Balance+Board/6474#s27965
* https://www.ifixit.com/Guide/Wii+Balance+Board+Frame+Replacement/30899
* https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/

Display data with https://github.com/firehol/netdata
