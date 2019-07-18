


#include "../common/hwio.h"
#include "../common/simplegfx.h"


const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};
const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint8_t spaceship_palette[] = {0x0D,0xEF,0x85,0x67,0x89,0xab,0x2D,0xEF};
const uint8_t spaceship_data[] = {0,0,0,1,32,0,0,0,0,0,0,5,56,0,0,0,0,0,0,5,56,0,0,0,0,0,0,5,56,0,0,0,0,24,0,5,56,0,6,0,1,32,0,21,58,0,1,32,5,32,0,21,30,0,1,24,5,32,0,21,30,0,1,24,5,24,0,21,30,0,5,24,217,24,0,21,214,0,5,220,219,22,1,212,202,32,21,236,219,21,17,219,241,33,21,236,6,245,21,219,241,21,214,60,1,21,21,219,241,21,21,32,0,91,21,239,252,21,91,0,0,108,0,26,43,0,108,0 };

TextPage_t page_data;
TextPage_t* page = &page_data; 

char hexDigit(uint8_t val) {
  if (val < 10) return val+48;
  if (val < 16) return val+55; 
  return '_';
}

void drawByteAsHex(uint16_t x, uint16_t y, uint8_t value, uint8_t color) {
  write_char_xy(x,y,hexDigit(value >> 4),color,page);
  write_char_xy(x+1,y,hexDigit(value & 0x0f),color,page);
}


int main (void)
{
  SP=0xffff;
  page_data = makeTextPage(0xC000,40,20,0,0);

  uint16_t shipX =150;

  uint16_t data = 0;
  uint8_t lastTime = 5;
  uint8_t mode = 0x74;
    for (;;)  {
      wait_frame();
      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      // write some text into the page
      write_romstring_xy(1,1,PSTR("Input Test"),0x0f,page);

      write_romstring_xy(1,5,PSTR("PORT $48  Arrows, Enter,ESC,CTRL,SHIFT"),0x02,page);
      write_romstring_xy(1,6,PSTR("PORT $49  WASD, Space, Z,X,Backspace "),0x02,page);

      write_romstring_xy(8,11,PSTR("PORT $4A  Mouse X"),0x02,page);
      write_romstring_xy(8,12,PSTR("PORT $4B  Mouse Y "),0x02,page);
      write_romstring_xy(8,14,PSTR("PORT $4C  Frame Ticker"),0x02,page);
      write_romstring_xy(8,15,PSTR("PORT $4D  Second Ticker "),0x02,page);

      drawByteAsHex(33,11,PORT_MOUSE_X,0x02);
      drawByteAsHex(33,12,PORT_MOUSE_Y,0x02);

      drawByteAsHex(33,14,PORT_TICK,0x02);
      drawByteAsHex(33,15,PORT_TIME,0x02);

      //transfer the page of 3x3 cells to the frameBuffer
      //this operation sets all pixels in the output frameBuffer
      renderMode0(0,0,(uint16_t)page->cells.start,page->cells.width,page->cells.height);

      //write a grid of rectangles showing the serial pixel output palette
      for (uint16_t ty=0;ty <4; ty++) {
        for (uint16_t tx=0;tx <4; tx++) {
          serial_fill_rect(200+tx*6,10+ty*6,5,5,(ty<<2)+tx);
        }
      }

      uint16_t buttons = PORT_BUTTONS;
      for (uint16_t b=0;b <16; b++) {
          serial_fill_rect(90+b*6,20,5,5,(buttons & (1<<b))?2:1);
      }


      if (buttons & 1) {
        shipX-=1;
      }
      if (buttons & 4) {
        shipX+=1;
      }
      blit_image(shipX,160,8,16,spaceship_data,spaceship_palette,BLITCON_BLIT_3,0);


      //read the mouse location
      uint16_t x=PORT_MOUSE_X;
      uint16_t y=PORT_MOUSE_Y;


      blit_image(x,y,3,16,arrow,arrowPal,BLITCON_BLIT_4,0);

      //put frame onscreen in lowres
      PORT_DISPLAY_SHIFT_X=0;
      PORT_DISPLAY_SHIFT_Y=0;
      PORT_DISPLAY_CONTROL=DC_SHOW_DISPLAY;
    }
    return (0);
}
