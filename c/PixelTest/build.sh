#!/bin/bash
MAIN=PixelTest
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -O2 -c hwio.c -o hwio.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -O2 -c simplegfx.c -o simplegfx.o
avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os -O2 $MAIN.c simplegfx.o hwio.o -o $MAIN.o
avr-objcopy -j .text -j.data -O ihex $MAIN.o  $MAIN.hex
