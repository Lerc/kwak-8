
| Address | Write                            | Read          |
|:-------:|----------------------------------|---------------|
|   0x20  | Serial Address_L                 |               |
|   0x21  | Serial Address_M                 |               |
|   0x22  | Serial Address_H                 |               |
|   0x23  | Serial Pixel Control             |               |
|   0x24  | Serial Pixel BaseColour          |               |
|   0x25  | Serial Pixel Add                 |               |
|   0x26  | Serial Pixel Sub                 |               |
|   0x27  | Serial Pixel Mul                 |               |
|   0x28  | Display Control                  |               |
|   0x29  | Display Shift X                  |               |
|   0x2a  | Display Shift Y                  |               |
|   0x2b  | Blit Control                     |               |
|   0x2c  | Voice Select                     |               |
|   0x2d  | Master Volume                    |               |
|   0x2e  |                                  |               |
|   0x2f  |                                  |               |
|         |                                  |               |
|   0x30  |                                  | Buttons_0     |
|   0x31  |                                  | Buttons_1     |
|   0x32  |                                  | Mouse X       |
|   0x33  |                                  | Mouse Y       |
|   0x34  |                                  | Frame Ticker  |
|   0x35  |                                  | Second Ticker |
|   0x36  |                                  | keybuffer     |
|   0x37  |                                  |               |
|   0x38  | Debug Console                    |               |
|   0x39  |                                  |               |
|   0x3a  |                                  |               |
|   0x3b  |                                  |               |
|   0x3c  |                                  |               |
|   0x3d  |                                  |               |
|   0x3e  |                                  |               |
|   0x3f  |                                  |               |
|         |                                  |               |
|   0z41  |                                  |               |
|   0x42  |                                  |               |
|   0x43  |                                  |               |
|   0x44  |                                  |               |
|   0x45  |                                  |               |
|   0x46  |                                  |               |
|   0x47  |                                  |               |
|         |                                  |               |
|   0x48  | Blit Parameter area              |               |
|   0x49  | Blit Parameter area              |               |
|   0x4a  | Blit Parameter area              |               |
|   0x4b  | Blit Parameter area              |               |
|   0x4c  | Blit Parameter area              |               |
|   0x4e  | Blit Parameter area              |               |
|   0x4f  | Blit Parameter area              |               |
|         |                                  |               |
|   0x50  | Voice Freq L                     |               |
|   0x51  | Voice Freq H                     |               |
|   0x52  | Voice Volume                     |               |
|   0x53  | Voice Shape (Base:4 Shift:4)     |               |
|   0x54  | Voice Bend (duration:5 phase:3)  |               |
|   0x55  | Voice Bend Amplitude             |               |
|   0x56  | Voice Noise:4  Hold:4            |               |
|   0x57  | Voice Play (attack:4 release:4)  |               |
|         |                                  |               |
|   0x58  |                                  |               |
|   0x59  |                                  |               |
|   0x5A  |                                  |               |
|   0x5B  |                                  |               |
|   0x5C  |                                  |               |
|   0x5D  | Stack Pointer    SPL             | SPL           |
|   0x5E  | Stack Pointer    SPH             | SPH           |
|   0x5F  | Status Register  SREG            | SREG          |
|         |                                  |               |
|   0x60  |  Palette Mapping                 |               |
|   ....  |  16 entries from a table of 256  |               |
|   0x6f  |  predefined colors               |               |


Display is a 512x392 write only buffer.  
The visible region is a window(480x360 or 240x180) into FrameBuffer

# Serial Pixel Mode

Pixels can be written to the buffer one at a time through a serial interface


    0x20...0x22:
        The serial write address is a 24 bit offset into the display buffer  
    
    0x23:
        The Serial Pixel Control register contains flags indicating how the serial write operations behave.

The serial pixel pointer may be auto incremented on any of the serial write operations.

        bit 0x10   increment serial write address after ADD operation
        bit 0x20   increment serial write address after SUB operation
        bit 0x40   increment serial write address after MUL operation 

The value written from a serial write operation will be the value writeent to the operator port ADD,SUB or MUL combined with either the existing colour at that pixel location or a base colour holding a colour index into the 256 colour palette.   

        bit 0x01  if set ADD uses the baseColour
        bit 0x02  if set SUB uses the baseColour
        bit 0x04  if set MUL uses the baseColour
    
    0x24: 
        Serial Pixel Base colour.  
        Index to the coloour in the fixed 256 colour palette

To set a serial pixel to a fixed colour,  using the ADD operation combined with Black in  the BaseColour will result in a simple SET operation  ( x+0=x )

    0x25:
        Serial write ADD
        When writing 8 bit value V to the port
        The pixel at the serial write address DEST will set by
        
            DEST = DEST + Palette256[V] 

        or - if bit 0x01 is set in the Serial Pixel Control Register
        
            DEST = Palette256[BaseColour] + Palette256[V] 

        Red, Green, Blue levels are added seperately and do not pass their max value.


    0x26:
        Serial write SUB
        When writing 8 bit value V to the port
        The pixel at the serial write address DEST will set by
        
            DEST = DEST - Palette256[V] 

        or - if bit 0x02 is set in the Serial Pixel Control Register
        
            DEST = Palette256[BaseColour] - Palette256[V] 

        Red, Green, Blue levels are subtracted seperately and do not pass their min value.

    0x26:
        Serial write MUL
        When writing 8 bit value V to the port
        The pixel at the serial write address DEST will set by
        
            DEST = DEST * Palette256[V] 

        or - if bit 0x04 is set in the Serial Pixel Control Register
        
            DEST = Palette256[BaseColour] * Palette256[V] 

        Red, Green, Blue levels are multiplied seperately and considered to be in the range from zero to one. 


# Display Control

    0x28:
        Display Control
        writing 0x00 places the buffer image on screen in lowres mode
        writing 0x01 places the buffer image on screen in hires mode

    0x29:
        Display Shift X
        The position of the left edge of the screen within the display buffer

    0x2A:
        Display Shift Y
        The position of the top edge of the screen within the display buffer

# The Blitter

The display buffer can also be written to via the blitter.  The Blitter reads from RAM 
and translates a variety of formats to screen writes.  The top left corner of the blit operation is the pixel specified by the current serial pixel address.

Blit operations utilize up to 16 colours from a colour table at `0x60...0x6f`  each 
value in the colour table is an index into the fixed 256 colour palette.


The address range `0x40...0x4f` holds the blitter parameter space which can be different
for different blit formats.  

Writing to Blit Control at  `0x2b` selects the format and triggers the blit operation.
Blit formats `0x01...0x04` utilize micro palettes and can render some colours with 
additive blending (and by extension by addive blending black, transparancy).   

    0x2B:
        Blitter Control, starts the blit operation
        0x01    8 pixels per byte.  2 colours
        0x02    4 pixels per byte.  4 colours
        0x03    3 pixels per byte.  16 colours with each set 
                of 3 pixels limited to one of four sets of 4 colours
        0x04    2 pixels per byte.  16 colours

        0x10    Mode 0  3x3 cell mode. 2 bytes per cell.  
                Cells have any 2 of 16 colours.

        0x11    Mode 1  8x8 cell mode. 2 bytes per cell.
                Cell images from 256 four-colour tiles. 
                NES mode.  X and Y tile Flipping availabe


For Blit formats `0x01...0x04` the Blitter parameters are the same with the only differences being the size of the output image and the number of colours available.

    0x40:   ImageData_L    
    0x41:   ImageData_H
        RAM location of the image data.

    0x42:   Width of the blit operation in bytes 
    0x43:   height of the blit operation in pixels

    0x44:   Line increment.
        The distance in bytes between one line of image data and the next.         

    0x45:   Palette_L
    0x46:   Palette_H
        RAM location of the MicroPalette 16 four bit entries 
        totalling 8 bytes. Each MicroPalette entry is an index to 
        the 16 entry colour table at `0x60...0x6f`
        If MicroPalette entry equals its position the colour 
        is additive blended otherwise the blitter performs a 
        straight overwrite of the destination pixel.

        This means a pointer to a MicroPalette containing

            0x01,0x23,0x45,0x67,0x89,0xAB,0xCD,0xEF

        Would render all pixels with additive blending, whereas

            0x01,0x23,0x45,0x67,0xEF,0xCD,0x89,0xAB
        
        refers to the same colours in a different order, causing
        only the first 8 to be blended.

        To achieve the traditional sprite colour zero transparancy
        set the first micropalette entry to zero and the first 
        colour table entry to zero(black),  for exampe,

            0x0F,0xED,0xCB,0xA9,0x87,0x65,0x43,0x21

        would provide colour zero transparancy and the remaining 
        16 colours in the reverse order but solid.

    0x4f:   Blit Flags
        bit 0x80 Blit is X flipped , right to left 
        bit 0x40 Blit is Y flipped, updide down
        bit 0x20 Blit is scaled to double width
        bit 0x10 blit is scaled to double height

        bits 0x0f reserved for expansion

Blit Mode0 is a 3x3 cell mode where each cell is represented by two bytes.  Cells may use any 2 colours of 16.  

The bits in the first byte define the 8 pixels in the 3x3 cell in the following order

| | | |
|-|-|-|
|0|1|2|
|3|4|5|
|6|7|-|

The second byte provides two 4 bit indexes into the colour table indicating which two colours to use for the cell.   Consider these to be Colour A and Colour B.  A clear bit in the first byte denotes Colour A and a set bit denotes colour B.  The bottom right pixel in the cell is always Colour A.  

While the Bottom right corner is not bit addressable, all combinations of pixels are available in this format. Swapping the values Of Colour A and Colour B, while inverting the first byte,  results in a change to the bottom right pixel without changing the appearance of the rest of the cell.

For instance for a cell in yellow (in palette entry 14) and blue(in palette entry 15) with this pattern

| | | |
|-|-|-|
|Y|B|Y|
|B|B|B|
|Y|B|Y|

Would be encoded as 0x9E, 0xEF 

To change the image to

| | | |
|-|-|-|
|Y|B|Y|
|B|B|B|
|Y|B|B|

The image would be encoded as 0x61, 0xFE which is a logical not of the first byte and a swap of the top and bottom 4 bits of the second byte.


Mode 0 Parameters are

    0x40    ImageData_L
    0x41    ImageData_H
            Address in ram of the image data.

    0x42    Width of the Blit operation in Cells
    0x43    Height of the Blit operation in Cells
    0x44    Line increment. The distance in Cells between one line
            of image data and the next. As cells are two bytes, the
            distance in bytes is this value doubled.


Mode 1 is a 8x8 cell - index tile mode. Each cell is two bytes, a 8 bit tile index
followed by an attribute byte to specify colours, xflip and yflip.

The index can be one of 256 tiles.  Tile data is 8x8 two bits per pixel making them 16 bytes per entry and providing 4 colours per tile. The attribute byte can specify one of 16 MicroPalettes for each cell. 

The attribute byte is encoded as

    XY..PPPP
            X (bit 0x80) flip cell X
            Y (bit 0x40) flip cell Y
            P (bits 0x0F) MicroPalette number.
            bits labeled . are unused at this time.


Mode 1 parameters are

    0x40    MapData_L
    0x41    MapData_H
            Address in RAM of the map cells
    
    0x42    Blit Size 
            the top 4 bits indicate the width in cells of the Blit
            the bottom 4 bits indicate the Height in cells of the blit.
            the size from each 4 bit value is decoded as
            if v==0 then 1 else v*2;
            conseqently the only odd size provided is 1
    
    0x43    Line increment. The distance in Cells between one line
            of image data and the next. As cells are two bytes, the
            distance in bytes is this value doubled.

    0x44    PaletteData_L
    0x45    PaletteData_H
            Address in RAM of the 16 MicroPalettes totaling 32 bytes

    0x46    TileData_L
    0x47    TileData_H
            Address in RAM of the Tile Set.  256*16 bytes (4k in total)


# Audio

There are 8 independant voice chennels available each with identical abilities.
The voices provide a variety of base waveforms, Pitch Bend, an Attack/Hold/Release envelope and individual noise and volume control.

All voices share the same hardware registers at `0x50...0x57` writing 0...7 to `0x2c` Selects which voice the register range controls. There is a Master volume at `0x2e` 

The Attack/Hold/Release cycle is triggered by writing to `0x57` Thus it is possible
to play a 'canned' sound effect by writing to the eight voice registers in turn and
upon witing the last value the sound will play.

Voice registers are:

    0x50    Freq_L
    0x51    Freq_H 
            Frequency is the Int16 value multiplied by 0.0596 Hz

    0x52    Volume 
            Int8 value ranging from 0:silent  to 255:Max volume
            
    0x53    Wave Shape
            Low 4 bits Wave Base: 
            0000 square, 1000 = Sine, 1111 = Triangle.
            intermediate values interpolate.
            square and triangle waves are scaled to have same area
            under curve as Sine preserving volume

 	        High 4 Bits Wave shift: 
            1000 no shift, Applies a gamma curve in the time domain

    0x54    Pitch Bend
    	    low 5 Bits: Bend Duration	 ((Int5_Value+1)/33)² * 30 Hz 
 	        high 3 bits: Bend phase 000=0 100=Pi,   

    0x55    Bend Amplitude
            Frequency range of the bend.  
            A value of 0 indicates no bend
            A value of 255 will occilate frequency between 
                voice_freq - voice_freq/2
            and 
                voice_freq + voice_freq/2

    0x56    Noise Level and Envelope Hold Duration 

        	low 4 bits: Noise level
                A value of 0 indicates no added noise
                A value of 15 indicates the wave will be all noise

        	high 4 bits: HoldTime:
                Envelope Release starts at (Int4_Value / 8)² Seconds
                0000 is Immediate release
                0001 is release after 1/64th of a second
                1000 is release after 1 second
                1111 is release after 3.51625 seconds

    0x57    Play, Attack and Release Envelope control

            low 4 bits for attack:
            high 4 bits for release:

            Duration for both is (Int4_Value / 8)² Seconds

            Writing to the this Register triggers the start of the
            Attack,Hold,Release Cycle.
