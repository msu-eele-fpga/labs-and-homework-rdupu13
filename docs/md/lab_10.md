# Lab 10: Device Trees

## Overview

This lab had me familiarize myself with device trees in Linux. Device trees are data structures that represent an
arrangement of an embedded system's peripherals and how they're connected. This allows the operating system to know
what's connected at boot. I used the sysfs pseuo filesystem, which provides access to kernel-related system
information including device parameters, filesystems, etc.

I used the files in the sysfs to change the user LED on the DE10-Nano to be controlled by a trigger source such as a
timer. There is a heartbeat option that I wasn't able to get working. Each time the device tree files are updated, I must recompile the Linux kernel and copy over its zImage to the TFTP server that the DE10-Nano boots from.

## Deliverables

I don't have any of the deliverables. Maybe I'll do a demo on Monday of what I was able to get working (timer option).

### Questions 

> What is the purpose of a device tree?

Device trees allow the Linux system to know what the structure and configuration of all of the devices that may be
connected to it at boot. Since there's no way to know what the system looks like preemptively, these data structures
allow Linux to figure out what's connected.
