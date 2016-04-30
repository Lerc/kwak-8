#!/bin/bash

avr-gcc -mmcu=atmega1284p  -Os minimal.c -o minimal.o
avr-objcopy -j .text -j.data -O ihex minimal.o minimal.hex
