
//#include "ravr.c"
#include <inttypes.h>
#include <avr/io.h>

#define PORT_DISPLAY_CONTROL _SFR_IO8(0x20)
#define PORT_DISPLAY_SHIFT  _SFR_IO8(0x21)
#define PORT_SERIAL_PIXEL_ADDRESS  _SFR_IO16(0x22)
#define PORT_SERIAL_PIXEL_ADDRESS_L  _SFR_IO8(0x22)
#define PORT_SERIAL_PIXEL_ADDRESS_M  _SFR_IO8(0x23)
#define PORT_SERIAL_PIXEL_ADDRESS_H  _SFR_IO8(0x24)
#define PORT_SERIAL_PIXEL_SET  _SFR_IO8(0x25)
#define PORT_SERIAL_PIXEL_MUL  _SFR_IO8(0x26)
#define PORT_SERIAL_PIXEL_ADD  _SFR_IO8(0x27)

#define PORT_MODE0_PIXEL_DISPLAY_START  _SFR_IO16(0x28)
#define PORT_MODE0_COLOR_DISPLAY_START  _SFR_IO16(0x2A)
#define PORT_MODE0_PIXEL_INCREMENT  _SFR_IO8(0x2C)
#define PORT_MODE0_COLOR_INCREMENT  _SFR_IO8(0x2D)
#define PORT_MODE0_PIXEL_LINE_INCREMENT  _SFR_IO8(0x2E)
#define PORT_MODE0_COLOR_LINE_INCREMENT  _SFR_IO8(0x2F)


#define PORT_MOUSEX  _SFR_IO8(0x2A)
#define PORT_MOUSEY  _SFR_IO8(0x2B)

void setPixelCursor(uint16_t x,uint16_t y) {
  uint32_t addr = ((uint32_t)(y)) * 512 + x ;

  PORT_SERIAL_PIXEL_ADDRESS_H = (addr >> 16);
  PORT_SERIAL_PIXEL_ADDRESS_M =  (addr >> 8);
  PORT_SERIAL_PIXEL_ADDRESS_L =  (addr >> 0);
}

void setImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h,  uint8_t* data, uint8_t bytesPerRow) {


}

main (void)
{
  SP=0xffff;

	uint16_t* walk = (uint16_t*)(0x4000);
  uint16_t data = 0;

  uint16_t x = 128;
  uint16_t y = 200;

    for (;;)  {
    	*walk++=data++;
    	if (walk > (uint16_t*)(0x5000)) {
    		walk=(uint16_t*)(0x4000);

        PORT_DISPLAY_CONTROL=0x80;  //render mode0 to frameBuffer

        setPixelCursor(x,y);
        PORT_SERIAL_PIXEL_SET = 15;
        PORT_SERIAL_PIXEL_SET = 15;
        PORT_SERIAL_PIXEL_SET = 15;
        setPixelCursor(x,y+1);
        PORT_SERIAL_PIXEL_SET = 15;
        PORT_SERIAL_PIXEL_SET = 15;
        PORT_SERIAL_PIXEL_SET = 15;

        x=PORT_MOUSEX;
        y=PORT_MOUSEY;

        PORT_DISPLAY_CONTROL=0x00;  //put frame onscreen in lowres
    	}
    }
    return (0);
}
