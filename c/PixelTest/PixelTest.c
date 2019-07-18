
#include <stdlib.h>
#include "../common/hwio.h"
#include "../common/simplegfx.h"

const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};
const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint8_t crosshairPal[] = {0x02};
const uint8_t crosshair[] = {2,128,2,128,2,128,2,128,2,128,126,252,0,0,126,252,2,128,2,128,2,128,2,128,2,128};

uint8_t palette[] = {0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef};

TextPage_t page;

void drawByteAsHex(uint16_t x, uint16_t y, uint8_t value) {
  write_char_xy(x,y,pgm_read_byte(&hexDigits[value >> 4]),0x0B,&page);
  write_char_xy(x+1,y,pgm_read_byte(&hexDigits[value & 0x0f]),0x0B,&page);
}

uint8_t countBits(uint8_t byte) {
  uint8_t result =0;
  for (result=0;byte!=0; result++) {
    byte&= byte-1;
  }
}

void setCell(uint16_t* cellAddress, uint8_t cellPixel, uint8_t color) {
  uint16_t cell = *cellAddress;
  uint8_t a = (cell >> 8) & 0xf;
  uint8_t b = (cell >> 12) & 0xf;
  uint8_t bits = cell & 0xff;

  if ( (a!=color) && (b!=color) ){
      if (countBits(bits) <= 5) a=color; else b=color;
  }

  if (cellPixel ==8) {
    if (color !=b) {
      a=b;
      b=color;
      bits=~bits;
    }
  } else {
    if (color == a) {
      bits |= 1 << cellPixel;
    } else {
      bits &=  ~(1 << cellPixel);
    }
  }
  *cellAddress=(a<<8) | (b<<12) | bits;

}

void setPixel(uint16_t x, uint16_t y, uint8_t color) {
  uint8_t cellX = x / 3;
  uint8_t cellY = y / 3;
  if (cellX >= page.cells.width) return;
  if (cellY >= page.cells.height) return;

  uint16_t* cellAddress =  page.cells.start + (page.cells.width*cellY + cellX);

  uint8_t cellPixel = (x % 3) + (y%3)*3;

  setCell(cellAddress,cellPixel,color);
}

void line(uint16_t x0,uint16_t y0,uint16_t x1,uint16_t y1, uint8_t color) {
  int16_t dx = abs(x1-x0);
  int16_t dy = abs(y1-y0);
  int8_t sx=x0<x1? 1:-1;
  int8_t sy=y0<y1? 1:-1;
  int16_t err = (dx>dy?dx:-dy)/2;

  for(;;) {
    setPixel(x0,y0,color);
    if (x0==x1 && y0==y1) break;
    int16_t e2 =err;
    if (e2 > -dx){err-=dy; x0+=sx;}
    if (e2 < dy){err+=dx; y0+=sy;}
  }
}

int main (void)
{
  SP=0xffff;
  page = makeTextPage(0x4000,40,20,0,0);

  uint16_t shipX =150;

  uint16_t data = 0;
  uint8_t lastTime = 5;
  uint8_t lastX=PORT_MOUSE_X;
  uint8_t lastY=PORT_MOUSE_Y;

  //clear the space we will use as screen memory
  uint16_t* walk = page.cells.start;
  uint16_t* page_end = page.cells.start + page.cells.width* page.cells.height;

  while (walk < (uint16_t*)(page_end)) {
     *walk++=0;
  }

  for (uint8_t i=0; i<16; i++) {
    line (i*15,0,0,180-(i*12),i);
    line (i*15,180,240,180-(i*12),i);
  }

  move_cells(&(page.cells),10,5,15,25,20,10);
  page.cursor_y=19;
    for (;;)  {
      wait_frame();
      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      uint8_t c = PORT_KEY_BUFFER;
      if (c) {
        write_char( c, &page);
        drawByteAsHex(10,10,c);
      }

      // write some text into the page
      write_romstring_xy(3,4,PSTR("PIXEL TEST"),0x0f,&page);

      //transfer the page of 3x3 cells to the frameBuffer
      renderMode0(0,0,(uint16_t)page.cells.start,page.cells.width,page.cells.height);


      //read the mouse location
      uint16_t x=PORT_MOUSE_X;
      uint16_t y=PORT_MOUSE_Y;
      line(x,y,lastX,lastY,now&0xf);
      lastX=x;
      lastY=y;

      blit_image(x-7,y-6,2,13,crosshair,crosshairPal,0x71,0);

      //put frame onscreen in lowres
      PORT_DISPLAY_SHIFT_X=0;
      PORT_DISPLAY_SHIFT_Y=0;

      PORT_DISPLAY_CONTROL=DC_SHOW_DISPLAY;
    }
    return (0);
}
