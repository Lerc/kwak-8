#!/bin/bash

avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os  spritish.c -o spritish.o
avr-objcopy -j .text -j.data -O ihex spritish.o spritish.hex
