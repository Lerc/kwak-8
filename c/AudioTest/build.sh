#!/bin/bash
MAIN=AudioTest
avr-gcc -std=c99 -g -mmcu=atmega1284p  -O3 -c hwio.c -o hwio.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -O3 $MAIN.c hwio.o -o $MAIN.o
avr-objcopy -j .text -j.data -O ihex $MAIN.o  $MAIN.hex
