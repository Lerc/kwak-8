#!/bin/bash
MAIN=InputTest
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -c ../common/hwio.c -o hwio.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -c ../common/simplegfx.c -o simplegfx.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os $MAIN.c hwio.o simplegfx.o -o $MAIN.o
avr-objcopy -j .text -j.data -O ihex $MAIN.o  $MAIN.hex
