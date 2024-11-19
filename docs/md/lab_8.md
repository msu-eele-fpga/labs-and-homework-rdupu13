# Lab 8: LED Patterns Program

## Overview
This lab was a difficult one, but I was determined enough to finish it.

I decided to start with devmem.c as a template, stripping it of all the long comments and extra steps
between the important ones. I hard-coded the address 0xFF200000 as the page-aligned address. After, I
began work on the argument parsing. I tried using getopt() like all the cool kids, but I wasn't able
to get it to work. It was recommended in the book as a solution to parsing multiple arguments, but I
found it to be especially bad at doing that.

Anyway, I settled on writing the argument parser myself in the main function and I found success.
There were more challenges to tackle, however, including: reading from a file, converting arguments to
integers, adding specific delays, and Ctl+C handling, all of which required extra review of the C
programming material I regret skipping.

When the debugging fiasco was over, I demoed my program, wrote this report, and wrote the README.md.



I didn't calculate the physical addresses of the component's registers, mmap() and /dev/mem did. I got
0xFF200000 from the textbooks memory diagram, which says the Avalon bridge is at that address.

## Deliverables
[Led Patterns README](../../sw/led-patterns/README.md)


