# Homework 9: PWM Controller in VHDL

## Overview
In this lab, I designed and compiled a pulse width modulation controller omponent in VHDL. The design
required 7-total-11-fractional-bit (u17.11) fixed point period and another 12-total-11-fractional-bit
(u12.11) fixed point duty cycle. The period can range from 0.00 to 63.99 seconds and the duty cycle
can range only from 0.00 to 1.00. The property that the most significant bit of the duty cycle is the
one's place means that we can treat it as an edge condition and put it into a boolean. The fractional
bits were converted to counts of CPU cycles by dividing by 2048 (they represent a fraction of 2^11),
muliplying by the number of cycles in a second, and casting it all to an integer. The counts are used
to decide when the output signal should be 1 or 0, where the duty-cycle cycle count is a fraction of the
period cycle count. Once the period count is reached, the counter is reset back to 1.

I debugged and compiled the design so I could program the FPGA with it. I used the Analog Discovery as
an oscilloscope to show that the waveform behaved as it should. I also made a testbench that I'm not
actually sure works.

## Deliverables
<img src="../assets/hw-9/">


<img src="../assets/hw-9/">

