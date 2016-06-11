#!/bin/bash
MAIN=BlitTest
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os  $MAIN.c -o $MAIN.o
avr-objcopy -j .text -j.data -O ihex $MAIN.o $MAIN.hex
