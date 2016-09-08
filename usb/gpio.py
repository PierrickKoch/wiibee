#! /usr/bin/env python
import sys
import time
import RPi.GPIO as GPIO

T_SLEEP = 0.5

pin = int(sys.argv[1])

# set some gpio up/down to simulate press red sync button on the wii fit board
GPIO.setup(pin, GPIO.OUT)
GPIO.output(pin, GPIO.LOW) # 0V active relay
time.sleep(T_SLEEP)
GPIO.output(pin, GPIO.HIGH) # 3.3V deactivate relay
