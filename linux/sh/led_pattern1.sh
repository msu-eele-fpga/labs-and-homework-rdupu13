#!/bin/bash

HPS_LED_CONTROL="/sys/devices/platform/ff200000.led_patterns/hps_led_control"
LED_REG="/sys/devices/platform/ff200000.led_patterns/led_reg"
BASE_PERIOD="/sys/devices/platform/ff200000.led_patterns/base_period"

echo 1 > $HPS_LED_CONTROL

led_val=0x53

while true
do
	echo $led_val > $LED_REG
	sleep 0.15
	# Left shift led_val; wrap the value when overflows 0xFF
	led_val=$(((led_val << 1) % 0xFF))
done
