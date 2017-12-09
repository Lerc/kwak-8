Web page --> http://lerc.github.io/kwak-8/
	
Emulator for an 8 bit machine that never existed
===================================================

Hardware Specifications
-----------------------
  * 8-bit AVR compatible instruction set.
  * 128k Program memory
  * 64k RAM
  * Display lowres(240x180) Hires(480x360)
  * Predominantly 16 color (more available in some circumstances)

The Emulator aims to occupy a middle ground between 8-bit hardware of old and
efficient emulation.

Most emulators that emulate real systems have to emulate all of the timing and
hardware of a video beam based display. A Video beam output could be considered
a write only display, with the limitation that the image must be written serially
and with precice timing.

This emulator reduces the emulation cost by providing a write-only framebuffer
which must be updated every frame.  The framebuffer does not need precice timing
for each pixel, nor do the pixels need to be written in any particular order.

The framebuffer reduces the workload of the emulator greatly.  It does come at
a cost in that an entire class of tricks that old computers could do are not
available in this emulator.  There are no raster interrupts and there is no
beam-racing.

In compensation, what is provided is an emulated harware mechanism more
appropriate to a frame-buffer output.  You may think of this as a kind of blitter
if you wish.

There are 'display mode' operations that update the entire display from RAM and
hardware register settings.  There are image drawing fuctions that work analogous
to sprites, they get drawn on top of the dispaly mode with additional harware
operations.

There is a 256 colour serial output mode with some rudimentary blending options,
A clever person should be able to get 24 bit images out of the system, but not
likely at interactive speeds.

How To Develop for it?
----------------------
The emulator supports hex files.  You can write programs in assembler or compile
 c programs with avr-gcc.   

You can see a guide to developing C for AVR microcontrollers [here](http://www.tldp.org/HOWTO/Avr-Microcontrollers-in-Linux-Howto/x207.html)

avr-gcc seems to need a commandline option to specify the architecture.  Since
this is a device from my own imagination, it is not explicitly supported.  I use
`-mmcu=atmega1284p` which is close.

There are some example programs in the c directory.  There are examples that contain
the entire program in the .c file so you can see exactly what is needed.

Hardware Registers
------------------
While the Instruction set is 8-bit AVR compatible.  The port mapped hardware is not intended to match any particular microcontroller.

The main Display output control is on port 0x40.  Writing 0x00 to that port puts the framebuffer onscreen in lowres mode.  Writing 0x01 displays hires mode.
Current Display control Operations are  
```
    0x00 = Show Lowres display  (240x160)
    0x01 = Show Highres display (480x360);
    0x71 = blit 8 pixels per byte
    0x72 = blit 4 pixels per byte
    0x73 = blit 3 pixels per byte
    0x74 = blit 2 pixels per byte
    0x80 = Generate Mode 0   (fill framebuffer with 1.777bit per pixel data ( 16 bits per 9 pixels) )
```
*The file IOMapping.txt lists all hardware ports.  Should there be an
inconsistancy in the documentation,  IOMapping.txt should be taken as
the correct form.*

You may write byte sized pixels (one of 256 colours in a fixed palette)
to the framebuffer serially.
Logically the frameBuffer is 512x392 and addressed with a 18 bit address in
Ports 0x42,0x43,0x44  for SerialPixel address Low, Middle and High respectively.

Writing to port 0x45 sets the pixel at the pixel adrress to the colour of the value
written and advances the pixel address.

Writing to port 0x46 multiplies the pixel at the pixel adrress by the colour of the value
written and **does not** advance the pixel address.\

Writing to port 0x47 adds the pixel at the pixel adrress to the colour of the value
written and advances the pixel address.

You cannot write directly from Program Memory to the display.  Serial output must
be conveyed by the CPU. Display mode generators and blitting operations read from
RAM.  Consequently, image data will usually be transferred from Program Memory
to RAM before it can be actively used.

Input
-----

Reading from ports 0x48 to 0x4f provides state based inputs

````
  input base = 0x48
  button_state_0 = input base + 0  Left Up Right Down Enter Esc Ctrl Shift  
  button_state_1 = input base + 1  A W D S SPACE Mouse1 Mouse2 Mouse3
  mouseX = input base +2
  mouseY = input base +3   mouse coordinates are in lowres pixels
  ticker = input base +4   increments on each frame of host device.
  timer  = input base +5   increments once per second
````

A serial input buffer is planned for keydown/keyup events but as yet no port
is assigned.
