
#include <inttypes.h>

// avr/io.h   provides the _SFR_IO macros for Port access
#include <avr/io.h>


//Normally these defines would be in an include
//but this example is meant to be self contained.
#define PORT_DISPLAY_CONTROL _SFR_IO8(0x08)
#define PORT_DISPLAY_SHIFT_X  _SFR_IO8(0x09)
#define PORT_DISPLAY_SHIFT_Y  _SFR_IO8(0x0a)
#define PORT_BLIT_CONTROL _SFR_IO8(0x0b)

#define PORT_SERIAL_PIXEL_ADDRESS  _SFR_IO16(0x00)
#define PORT_SERIAL_PIXEL_ADDRESS_L  _SFR_IO8(0x00)
#define PORT_SERIAL_PIXEL_ADDRESS_M  _SFR_IO8(0x01)
#define PORT_SERIAL_PIXEL_ADDRESS_H  _SFR_IO8(0x02)
#define PORT_SERIAL_PIXEL_MODE  _SFR_IO8(0x03)
#define PORT_SERIAL_PIXEL_BASE  _SFR_IO8(0x04)
#define PORT_SERIAL_PIXEL_ADD  _SFR_IO8(0x05)
#define PORT_SERIAL_PIXEL_SUB  _SFR_IO8(0x06)
#define PORT_SERIAL_PIXEL_MUL  _SFR_IO8(0x07)

#define PORT_MODE0_IMAGE_DATA  _SFR_IO16(0x28)
#define PORT_MODE0_CELLS_WIDE  _SFR_IO8(0x2A)
#define PORT_MODE0_CELLS_HIGH  _SFR_IO8(0x2B)
#define PORT_MODE0_LINE_INCREMENT  _SFR_IO8(0x2C)


#define PORT_MOUSEX  _SFR_IO8(0x12)
#define PORT_MOUSEY  _SFR_IO8(0x13)
#define PORT_TICKER  _SFR_IO8(0x14)


#define  FBC_SHOW_DISPLAY  0
#define  FBC_SHOW_DISPLAY_HIRES 1
  
#define  BLITCON_BLIT_8 1
#define  BLITCON_BLIT_4 2
#define  BLITCON_BLIT_3 3
#define  BLITCON_BLIT_2 4

#define  BLITCON_MODE_0 0x10
#define  BLITCON_MODE_1 0x11

//sets the serial pixel write position.
void setPixelCursor(uint16_t x,uint16_t y) {
  
  uint32_t addr = ((uint32_t)(y)) * 512 + x ;

  PORT_SERIAL_PIXEL_ADDRESS_H = (addr >> 16);
  PORT_SERIAL_PIXEL_ADDRESS_M =  (addr >> 8);
  PORT_SERIAL_PIXEL_ADDRESS_L =  (addr >> 0);
}

void waitForNextFrame() {
  uint8_t now = PORT_TICKER;
  for (;;) {
    if (PORT_TICKER != now) break;
  }
}

main (void)
{
  SP=0xffff;

	uint16_t* walk = (uint16_t*)(0x4000);
  uint16_t data = 0;

  uint16_t x = 128;
  uint16_t y = 200;

    for (;;)  {
      //incrementally write some randomish data to the display area
      *walk=*walk &0xaa0f;
    	if (++walk > (uint16_t*)(0x6580)) {
    		walk=(uint16_t*)(0x4000);
      }
      *walk=(data++ * 1997)&0xffff;
      
      // set up registers for Mode0 
      PORT_MODE0_IMAGE_DATA=0x4000;
      PORT_MODE0_CELLS_WIDE=80;
      PORT_MODE0_CELLS_HIGH=60;
      PORT_MODE0_LINE_INCREMENT=80;

      setPixelCursor(0,0);
      PORT_BLIT_CONTROL=BLITCON_MODE_0;  //render mode0 to frameBuffer


      x=PORT_MOUSEX;
      y=PORT_MOUSEY;

      // three pixels across and one above, one below, makes a tiny + 
      setPixelCursor(x-1,y);
      PORT_SERIAL_PIXEL_ADD = 2;
      PORT_SERIAL_PIXEL_ADD = 2;
      PORT_SERIAL_PIXEL_ADD = 2;
      setPixelCursor(x,y+1);
      PORT_SERIAL_PIXEL_ADD = 2;
      setPixelCursor(x,y-1);
      PORT_SERIAL_PIXEL_ADD = 2;
      
      PORT_DISPLAY_CONTROL=0x00;  //put frame onscreen in lowres

      waitForNextFrame();    	
    }
    return (0);
}
