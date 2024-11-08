# Lab 7: Verifying Your Custom Component Using System Console and `/dev/mem`

## Overview
After a (not-so-brief) hiccup in progress during a switch of operating systems from Windows to Linux, I was ready for
this assignment. I didn't want to do it through the Linux VM because it felt ingenuine and I was wanting a better
operating system anyway. I will also admit to a lot of procrastination on my part.

The first order of business was practicing using System Console. Though the GUI coloring was slightly screwed up, I
was able to open a master service and read/write to the FPGA's registers. I took notes on some of the useful Tcl
commands in a .txt document.

Next, I copied (manually) the C program devmem.c into my git repository. Here, I compiled and test-ran it using gcc.
Once I varified it was working, I cross-compiled it for 32-bit ARM. After programming, I was able to borrow my
friend's Micro SD card adapter to flash Terasic's disk image onto the Micro SD using Balena Etcher. There were weird
and inconsistent USB visibility issues that I blame Noah's adapter for. Then, I added the executable devmem file to
the Micro SD's filesystem.

Finally, I used a PuTTY terminal to communicate with the newly-created operating system on the SoC. After logging in
as root, I saw the executable devmem file that I previously placed there. I was able to use the program to edit any
memory address, including the registers on the FPGA component.

The LED pattern changes correctly according to the control registers. The HPS control bit (bit 0 of 0xFF200000), the
LED register (bits 7:0 of 0xFF200004), and the base period control register (bits 7:0 of 0xFF200008) were manipulated
from PuTTY on my Linux machine. How cool is that?

## Deliverables
There is a 1:40 min video of me demoing the register reading/writing that I will email you.

### Questions 

> What hex value did you write to base_period to have a 0.125 second base period?

    period     fix pt bits   32-bit value
    0.125 sec = 0000 0010 = 0x00000002

> What hex value did you write to base_period to have a 0.5625 second base period? 

    period      fix pt bits   32-bit value
    0.5625 sec = 0000 1001 = 0x00000009

