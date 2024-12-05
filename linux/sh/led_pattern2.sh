#!/bin/bash

HPS_LED_CONTROL="/sys/devices/platform/ff200000.led_patterns/hps_led_control"
LED_REG="/sys/devices/platform/ff200000.led_patterns/led_reg"
BASE_PERIOD="/sys/devices/platform/ff200000.led_patterns/base_period"

echo 1 > $HPS_LED_CONTROL

RATE=0.1

while true
do
	echo 0x03 > $LED_REG
	sleep $RATE
	echo 0x06 > $LED_REG
	sleep $RATE
	echo 0x0C > $LED_REG
	sleep $RATE
	echo 0x18 > $LED_REG
	sleep $RATE
	echo 0x30 > $LED_REG
	sleep $RATE
	echo 0x60 > $LED_REG
	sleep $RATE
	echo 0xC0 > $LED_REG
	sleep $RATE
	echo 0xA0 > $LED_REG
	sleep $RATE
	echo 0x90 > $LED_REG
	sleep $RATE
	echo 0x88 > $LED_REG
	sleep $RATE
	echo 0x84 > $LED_REG
	sleep $RATE
	echo 0x82 > $LED_REG
	sleep $RATE
	echo 0x81 > $LED_REG
	sleep $RATE
	echo 0x82 > $LED_REG
	sleep $RATE
	echo 0x84 > $LED_REG
	sleep $RATE
	echo 0x88 > $LED_REG
	sleep $RATE
	echo 0x90 > $LED_REG
	sleep $RATE
	echo 0xA0 > $LED_REG
	sleep $RATE
	echo 0xC0 > $LED_REG
	sleep $RATE
	echo 0xE0 > $LED_REG
	sleep $RATE
	echo 0xD0 > $LED_REG
	sleep $RATE
	echo 0xC8 > $LED_REG
	sleep $RATE
	echo 0xC4 > $LED_REG
	sleep $RATE
	echo 0xC2 > $LED_REG
	sleep $RATE
	echo 0xC1 > $LED_REG
	sleep $RATE
	echo 0xC2 > $LED_REG
	sleep $RATE
	echo 0xC4 > $LED_REG
	sleep $RATE
	echo 0xC8 > $LED_REG
	sleep $RATE
	echo 0xD0 > $LED_REG
	sleep $RATE
	echo 0xE0 > $LED_REG
	sleep $RATE
	echo 0xF0 > $LED_REG
	sleep $RATE
	echo 0xE8 > $LED_REG
	sleep $RATE
	echo 0xE4 > $LED_REG
	sleep $RATE
	echo 0xE2 > $LED_REG
	sleep $RATE
	echo 0xE1 > $LED_REG
	sleep $RATE
	echo 0xE2 > $LED_REG
	sleep $RATE
	echo 0xE4 > $LED_REG
	sleep $RATE
	echo 0xE8 > $LED_REG
	sleep $RATE
	echo 0xF0 > $LED_REG
	sleep $RATE
	echo 0xF8 > $LED_REG
	sleep $RATE
	echo 0xF4 > $LED_REG
	sleep $RATE
	echo 0xF2 > $LED_REG
	sleep $RATE
	echo 0xF1 > $LED_REG
	sleep $RATE
	echo 0xF2 > $LED_REG
	sleep $RATE
	echo 0xF4 > $LED_REG
	sleep $RATE
	echo 0xF8 > $LED_REG
	sleep $RATE
	echo 0xFC > $LED_REG
	sleep $RATE
	echo 0xFA > $LED_REG
	sleep $RATE
	echo 0xF9 > $LED_REG
	sleep $RATE
	echo 0xFA > $LED_REG
	sleep $RATE
	echo 0xFC > $LED_REG
	sleep $RATE
	echo 0xFE > $LED_REG
	sleep $RATE
	echo 0xFF > $LED_REG
	sleep $RATE
	echo 0xFE > $LED_REG
	sleep $RATE
	echo 0xFF > $LED_REG
	
	sleep 1.0
	
	echo 0x7F > $LED_REG
	sleep $RATE
	echo 0x3F > $LED_REG
	sleep $RATE
	echo 0x1F > $LED_REG
	sleep $RATE
	echo 0x0F > $LED_REG
	sleep $RATE
	echo 0x07 > $LED_REG
	sleep $RATE
	echo 0x03 > $LED_REG
	sleep $RATE
	echo 0x01 > $LED_REG
	sleep $RATE
	echo 0x00 > $LED_REG
	sleep $RATE
	sleep $RATE
	sleep $RATE
	echo 0x01 > $LED_REG
	sleep $RATE
	
done
