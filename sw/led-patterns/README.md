# LED Patterns Program

## Description
This program interacts with a custom LED Patterns component programmed on the FPGA with the
[LED Patterns Binary](../../quartus/led-patterns/led_patterns.rbf) bitstream. The user can choose
between 4 default hard-coded patterns, or they can run this program and let the HPS take control of
the LEDs. With the -p option, arguments can be given that will be displayed on the LEDs.
For example, **0xAA 1500** will display 10101010 on the LEDs for 1.5 seconds. The -f option can be
used similarly, except its argument requires a file of these pattern-time pairs. The -v option can
be envoked to produce a detailed output for debugging and the curious.

## Usage

	./led_patterns [-hv] [-b BASE_PERIOD] [-p PATTERN TIME ...] [-f FILE]
	
	Generate a custom pattern to play on the De10-Nano's external LEDs given
	hex PATTERNs and their respective TIMEs in milliseconds. Multiple of these
	PATTERN TIME pairs may be input as arguments or read from a FILE.
	
	Options:\n");
	    -h                    print this help message
	    -v                    print more information during execution
	    -b BASE_PERIOD        change the LED Patterns base period to BASE_PERIOD
		-p PATTERN TIME ...   display hex PATTERN on LEDs for TIME milliseconds
	    -f FILE               display pattern-time pairs from FILE

## Compiling

This program must be compiled with the ARM gcc compiler and copied to the [SoC filesystem](/srv/nfs/de10nano/ubuntu-rootfs/), preferrably in /home/soc/led-patterns/.
