#!/bin/bash
MAIN=AudioTest

avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -O2 -c ../common/hwio.c -o hwio.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -O2 -c ../common/simplegfx.c -o simplegfx.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -O2 $MAIN.c simplegfx.o hwio.o -o $MAIN.o
avr-objcopy -j .text -j.data -O ihex $MAIN.o  $MAIN.hex
