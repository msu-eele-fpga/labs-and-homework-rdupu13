# Lab 6: Custom Component on Platform Designer

## Overview

This was a long and arduous lab, full of misunderstanding and procrastination. Nevertheless, it's finally finished and working.

### Learning About the HPS

The HPS is the solid portion of the FPGA chip, which is a 32 bit ARM CPU. This can communicate with our FPGA designs through a lightweight bus using the avalon protocol. The CPU can read and write to/from registers that exist within our design this way.

### Using Platform Designer

Platform designer makes this process much easier but generating VHDL code for us. After a lot of configuring and misreading directions, I made a custom component, connected it through GUI to the Avalon interface, and corrected any errors that appeared along the way so that Quartus was happy. Overall, it's going to take a while to get used to Platform Designer.

## Deliverables

### System Architecture

*--------------------------------------------------------------------------*
| ARM Hard Processor System       | FPGA Fabric                            |
|                                 |                                        |
| *--------------------------*    |       *--------------------*   *-----* |
| |                          |    |       |                    |   |  C  | |
| | Lightweight HPS-to-FPGA  |------------| +0 HPS LED Control |---|  o  | |
| | Base Address: 0xFF200000 |    |   |   |                    |   |  m  | |
| |                          |    |   |   *--------------------*   |  p  | |
| *--------------------------*    |   |                            |  o  | |
|              |                  |   |   *--------------------*   |  n  | |
|              |                  |   |   |                    |   |  e  | |
|              |                  |   |---|   +4 LED register  |---|  n  | |
|              |                  |   |   |                    |   |  t  | |
| *--------------------------*    |   |   *--------------------*   |     | |
| |                          |    |   |                            |  L  | |
| |         ARM CPUs         |    |   |   *--------------------*   |  o  | |
| |                          |    |   |   |                    |   |  g  | |
| *--------------------------*    |   ----|   +8 Base Period   |---|  i  | |
|                                 |       |                    |   |  c  | |
|                                 |       *--------------------*   *-----* |
|                                 |                                        |
*--------------------------------------------------------------------------*

### Register Map

The interface is simple, only containing three registers: register 0 is for deferring to hps control, register 1 is for the CPU to display any pattern that it generates, and register 2 is for changing the rate at which the leds are updated by the FPGA pattern generator.

### Platform Designer Questions

> How did you connect these registers to the ARM CPUs in the HPS?

    Register 0 is hps_control (lsb only)
    Register 1 is the LED register (lower 8 bits)
    Register 2 is the base period (8 bit fixed point, def: 0000.0010)

> What is the base address of your component in your Platform Designer system?

    According to the textbook, which says the base address of the lightweight bridge is 0xFF200000, the addresses are:

    0xFF2000000: hps_led_control
    0XFF2000004: led_reg
    0xFF2000008: base_period
