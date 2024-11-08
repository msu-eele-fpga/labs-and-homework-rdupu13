# Lab 5: Logic Analysis with Signal Tap

## Overview
I used Signal Tap, Quartus' built-in logic analyzer, to probe the internal signals within my LED pattern design. I learned how to add nodes for sampling, configure the sampling clock, and configure a custom trigger. Overall, the lab was a quick and dirty introduction to logic analysis on the FPGA.

## Deliverables
Below is a Signal Tap waveform of a transition between states. You can see that the switch values are shown for one second before pattern 1 begins.
<img src="assets/lab_5_waveform.png">

The signal configuration is set to have a clock of 2 x base period and though it's not shown, it's triggered by the push button (not pulsed).
<img src="assets/lab_5_signal_config.png">

### Questions 
> How much FPGA on-chip memory was required to monitor your signals?

    6400 bits, or 800 bytes

