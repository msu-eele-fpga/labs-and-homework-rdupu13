# HW 7: Linux CLI Practice

## Overview
For this homework, I practiced using varius Linux terminal commands like wc, sort, cut, head, tail, grep, and find, along with the various ways they can be used together with redirection and regular expressions. It's worth noting that I change directories several times in between commands, so they're not all relative to the same file.

## Deliverables

### Problem 1
`wc -w lorem-ipsum.txt`
<img src="assets/hw-7/hw7_prob1.png">

### Problem 2
`wc -m lorem-ipsum.txt`
<img src="assets/hw-7/hw7_prob2.png">

### Problem 3
`wc -w lorem-ipsum.txt`
<img src="assets/hw-7/hw7_prob3.png">

### Problem 4
`wc -l lorem-ipsum.txt`
<img src="assets/hw-7/hw7_prob4.png">

### Problem 5
`sort -h -r file-sizes.txt`
<img src="assets/hw-7/hw7_prob5.png">

### Problem 6
`cut --fields=3 --delimiter=, log.csv`
<img src="assets/hw-7/hw7_prob6.png">

### Problem 7
`cut --fields=2,3 --delimiter=, log.csv`
<img src="assets/hw-7/hw7_prob7.png">

### Problem 8
`cut --fields=1,4 --delimiter=, log.csv`
<img src="assets/hw-7/hw7_prob8.png">

### Problem 9
`head --lines=3 gibberish.txt`
<img src="assets/hw-7/hw7_prob9.png">

### Problem 10
`tail --lines=2 gibberish.txt`
<img src="assets/hw-7/hw7_prob10.png">

### Problem 11
`tail --lines=-20 log.csv`
<img src="assets/hw-7/hw7_prob11.png">

### Problem 12
`grep -i -o and gibberish.txt`
<img src="assets/hw-7/hw7_prob12.png">

### Problem 13
`grep -i -o '\<we\>' gibberish.txt`
<img src="assets/hw-7/hw7_prob13.png">

### Problem 14
I couldn't get this one to work...
`grep -i -o 'to [insert correct regex]' gibberish.txt`
See: trying_to_figure_out_grep.txt

### Problem 15
`grep -c -o FPGAs fpgas.txt`
<img src="assets/hw-7/hw7_prob15.png">

### Problem 16
`grep '(.*(ot|wer|ile))' fpgas.txt`
<img src="assets/hw-7/hw7_prob16.png">

### Problem 17
`grep -r -o -c '^\-\-' ../../hdl/`
<img src="assets/hw-7/hw7_prob17.png">

### Problem 18
`ls ../ > ls-output.txt`
<img src="assets/hw-7/hw7_prob18.png">

### Problem 19
`sudo dmesg | grep 'CPU'`
<img src="assets/hw-7/hw7_prob19.png">

### Problem 20
`find hdl/ -iname '*.vhd' | wc -l`
<img src="assets/hw-7/hw7_prob20.png">

### Problem 21
`grep -r '^--' hdl/ | wc -l`
<img src="assets/hw-7/hw7_prob21.png">

### Problem 22
`grep -n FPGAs fpgas.txt | cut -c-1`
<img src="assets/hw-7/hw7_prob22.png">

### Problem 23
`du -h * | tail --lines=3`
<img src="assets/hw-7/hw7_prob23.png">

