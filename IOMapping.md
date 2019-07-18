


| Address | Write                            | Read          |
|:-------:|----------------------------------|---------------|
|   0x20  | Serial Address_L                 |               |
|   0x21  | Serial Address_M                 |               |
|   0x22  | Serial Address_H                 |               |
|   0x23  | Serial Pixel mode                |               |
|   0x24  | Serial Pixel BaseColour          |               |
|   0x25  | Serial Pixel Add                 |               |
|   0x26  | Serial Pixel Sub                 |               |
|   0x27  | Serial Pixel mul                 |               |
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
