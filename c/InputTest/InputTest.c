


#include "hwio.h"


const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};
const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint8_t spaceship_palette[] = {0x0D,0xEF,0x85,0x67,0x89,0xab,0x2D,0xEF};
const uint8_t spaceship_data[] = {0,0,0,1,32,0,0,0,0,0,0,5,56,0,0,0,0,0,0,5,56,0,0,0,0,0,0,5,56,0,0,0,0,24,0,5,56,0,6,0,1,32,0,21,58,0,1,32,5,32,0,21,30,0,1,24,5,32,0,21,30,0,1,24,5,24,0,21,30,0,5,24,217,24,0,21,214,0,5,220,219,22,1,212,202,32,21,236,219,21,17,219,241,33,21,236,6,245,21,219,241,21,214,60,1,21,21,219,241,21,21,32,0,91,21,239,252,21,91,0,0,108,0,26,43,0,108,0 };

uint8_t palette[] = {0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef};
uint8_t testSprite[] =
{ 0b00000110,0b00111111,0b00000011,0b00011011,
  0b00000110,0b00111111,0b00000011,0b00011011,
  0b00000110,0b00111111,0b00000011,0b00011011,
  0b01000110,0b01111111,0b01000011,0b01011011,
  0b01000110,0b01111111,0b01000011,0b01011011,
  0b01000110,0b01111111,0b01000011,0b01011011,
  0b10000110,0b10111111,0b10000011,0b10011011,
  0b10000110,0b10111111,0b10000011,0b10011011,
  0b10000110,0b10111111,0b10000011,0b10011011,
  0b11000110,0b11111111,0b11000011,0b11011011,
  0b11000110,0b11111111,0b11000011,0b11011011,
  0b11000110,0b11111111,0b11000011,0b11011011
};



void testBlit(uint16_t x, uint8_t y,uint8_t mode, uint8_t flags) {

    PORT_BLIT_IMAGE_START  = (uint16_t)(&testSprite);
    PORT_BLIT_BYTES_WIDE  = 4;
    PORT_BLIT_HEIGHT = 12;
    PORT_BLIT_LINE_INCREMENT = 4;
    PORT_BLIT_PALETTE_START = (uint16_t)(&palette);

    PORT_BLIT_FLAGS  = flags;

    setPixelCursor(x,y);

    PORT_DISPLAY_CONTROL = mode;

}

void drawImageData(uint16_t x, uint8_t y, uint8_t width_in_bytes, uint8_t height, const  uint8_t* image,const uint8_t* palette_table, uint8_t mode, uint8_t flags) {
  PORT_BLIT_IMAGE_START  = (uint16_t)(image);
  PORT_BLIT_BYTES_WIDE  = width_in_bytes;
  PORT_BLIT_HEIGHT = height;
  PORT_BLIT_LINE_INCREMENT = width_in_bytes;
  PORT_BLIT_PALETTE_START = (uint16_t)(palette_table);

  PORT_BLIT_FLAGS  = flags;

  setPixelCursor(x,y);

  PORT_DISPLAY_CONTROL = mode;
}

void waitForNewFrame() {
  uint8_t ticksOnEntry = PORT_TICK;
  while(ticksOnEntry==PORT_TICK);
}


void drawByteAsHex(uint16_t x, uint16_t y, uint8_t value) {
  renderChar(x,y,pgm_read_byte(&hexDigits[value >> 4]),0x0B,0x4000,44 , 20);
  renderChar(x+1,y,pgm_read_byte(&hexDigits[value & 0x0f]),0x0B,0x4000, 44 ,20);
}

int main (void)
{
  SP=0xffff;

  const int pageBase=0x4000;
  const int charsWide=44;
  const int charsHigh=20;

  const int pageEnd=pageBase+charsWide*charsHigh*6*2; //char cell is 6 bytes for pixels and  6 bytes for colour

  uint16_t shipX =150;

  uint16_t data = 0;
  uint8_t lastTime = 5;
  uint8_t mode = 0x74;
    for (;;)  {
      waitForNewFrame();
      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      if (nextStep) {
        mode+=1;
        if (mode > 0x74) mode=0x71;
      }


      //fill some memory with some changing data
      uint16_t* walk = (uint16_t*)(pageBase);
      walk=(uint16_t*)(pageBase);
  	  while (walk < (uint16_t*)(pageEnd)) {
    	   *walk++=data++;

         data=0;
      }

      // write some text into the page
      renderProgMemString(3,2,PSTR("Input Test"),0x0f,pageBase,charsWide ,charsHigh);

      renderProgMemString(3,6,PSTR("PORT $48  Arrows, Enter,ESC,CTRL,SHIFT"),0x02,pageBase,charsWide ,charsHigh);
      renderProgMemString(3,7,PSTR("PORT $49  WASD, Space, Z,X,Backspace "),0x02,pageBase,charsWide ,charsHigh);

      renderProgMemString(10,12,PSTR("PORT $4A  Mouse X"),0x02,pageBase,charsWide ,charsHigh);
      renderProgMemString(10,13,PSTR("PORT $4B  Mouse Y "),0x02,pageBase,charsWide ,charsHigh);
      renderProgMemString(10,15,PSTR("PORT $4C  Frame Ticker"),0x02,pageBase,charsWide ,charsHigh);
      renderProgMemString(10,16,PSTR("PORT $4D  Second Ticker "),0x02,pageBase,charsWide ,charsHigh);

      drawByteAsHex(35,12,PORT_MOUSEX);
      drawByteAsHex(35,13,PORT_MOUSEY);

      drawByteAsHex(35,15,PORT_TICK);
      drawByteAsHex(35,16,PORT_TIME);

      //transfer the page of 3x3 cells to the frameBuffer
      //this operation sets all pixels in the output frameBuffer
      renderMode0(pageBase,charsWide*2,charsHigh*3);

/*
      //set pixel 120,90 in the framebuffer to 2 (White)
      setPixelCursor(120,90);
      PORT_SERIAL_PIXEL_SET = 2;

      fillRect(55,35,32,32,43);

      const uint8_t flipx = 0x80;
      const uint8_t flipy = 0x40;
      const uint8_t doublex = 0x20;
      const uint8_t doubley = 0x10;

      testBlit(65,45,mode,0);
      testBlit(95,45,mode,0);

      testBlit(65,75,mode,0);
      testBlit(95,75,mode,flipx);
      testBlit(125,75,mode,flipy);
      testBlit(155,75,mode,flipx|flipy);

      testBlit(65,105,mode,doubley);
      testBlit(95,105,mode,doubley|flipx);
      testBlit(125,105,mode,doubley|flipy);
      testBlit(155,105,mode,doubley|flipx|flipy);

      testBlit(65,135,mode,doublex);
      testBlit(95,135,mode,doublex|flipx);
      testBlit(125,135,mode,doublex|flipy);
      testBlit(155,135,mode,doublex|flipx|flipy);

      testBlit(65,155,mode,doublex|doubley);
      testBlit(95,155,mode,doublex|doubley|flipx);
      testBlit(125,155,mode,doublex|doubley|flipy);
      testBlit(155,155,mode,doublex|doubley|flipx|flipy);
*/
      //write a grid of rectangles showing the serial pixel output palette
      for (uint16_t ty=0;ty <4; ty++) {
        for (uint16_t tx=0;tx <4; tx++) {
          fillRect(200+tx*6,20+ty*6,5,5,(ty<<2)+tx);
        }
      }

      uint16_t buttons = PORT_BUTTONS;
      for (uint16_t b=0;b <16; b++) {
          fillRect(100+b*6,30,5,5,(buttons & (1<<b))?2:1);
      }


      if (buttons & 1) {
        shipX-=1;
      }
      if (buttons & 4) {
        shipX+=1;
      }
      drawImageData(shipX,170,8,16,spaceship_data,spaceship_palette,0x73,0);


      //read the mouse location
      uint16_t x=PORT_MOUSEX;
      uint16_t y=PORT_MOUSEY;


      drawImageData(x,y,3,16,arrow,arrowPal,0x72,0);

      //put frame onscreen in lowres
      PORT_DISPLAY_SHIFT=0xff;
      PORT_DISPLAY_CONTROL=0x00;
    }
    return (0);
}
