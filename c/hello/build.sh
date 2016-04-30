#!/bin/bash

avr-gcc -std=c99 -g -mmcu=atmega1284p  -Os  hello.c -o hello.o
avr-objcopy -j .text -j.data -O ihex hello.o hello.hex
