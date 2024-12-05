#!/bin/bash

HPS_LED_CONTROL="/sys/devices/platform/ff200000.led_patterns/hps_led_control"
LED_REG="/sys/devices/platform/ff200000.led_patterns/led_reg"
BASE_PERIOD="/sys/devices/platform/ff200000.led_patterns/base_period"

# Enable software control mode
echo 1 > $HPS_LED_CONTROL

while true
do
	echo 0x55 > $LED_REG
	sleep 0.25
	echo 0xAA > $LED_REG
	sleep 0.25
done
