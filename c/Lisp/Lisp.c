
#include <stdlib.h>

#include "../common/hwio.h"

#include "../common/simplegfx.h"



void print_rom(const char* s);
void println_rom(const char* s);
void print(const char* s);
void println(const char* s);
void print_char(char c);
void print_uint16(uint16_t num);
void print_int16(int16_t num);
void line(uint16_t x0,uint16_t y0,uint16_t x1,uint16_t y1, uint8_t color);
void show();

#include "uLisp.c"


const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};
const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint8_t crosshairPal[] = {0x02};
const uint8_t crosshair[] = {2,128,2,128,2,128,2,128,2,128,126,252,0,0,126,252,2,128,2,128,2,128,2,128,2,128};

uint8_t palette[] = {0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef};

TextPage_t page;

void print_char(char c) {
    write_char(c,&page);
}

void print_uint16(uint16_t num) {
  char buf[10];
  char* p = buf+9;
  *p=0;
  do {  *--p ='0' + (num%10);
        num/=10;
     } while (num !=0);
  char c;
  while (c = *p++ ) print_char(c);
}

void print_int16(int16_t num) {
  if (num < 0){
    print_char('-');
    print_uint16(-num);
  } else print_uint16(num);
}

void print_rom(const char* s) {
  write_romstring(s,&page);
}

void println_rom(const char* s) {
  write_romstring(s,&page);
  write_char('\n',&page);
}

void print(const char* s) {
  write_ramstring(s,&page);
}
void println(const char* s) {
  write_ramstring(s,&page);
  write_char('\n',&page);
}

void show() {
  renderMode0(0,0,(uint16_t)page.cells.start,page.cells.width,page.cells.height);

  PORT_DISPLAY_SHIFT_X=14;
  PORT_DISPLAY_SHIFT_Y=14;
  
  PORT_DISPLAY_CONTROL=DC_SHOW_DISPLAY;

}

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
  //SP=0xffff;
  /*
  #define page_Base 0x4000
  #define padding 3
  #define page_CharsWide 44
  #define page_CharsHigh 20
  #define page_CellsWide  (page_CharsWide*2 + padding * 2)
  #define page_CellsHigh  (page_CharsHigh*3 * padding * 2)

  #define page_End (page_Base+page_CellsWide*page_CellsHigh*2)
                    //char cell is 6 bytes for pixels and  6 bytes for colour
  */
  page = makeTextPage(0x4000,40,20,5,5);

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
  show();
  for (uint8_t i=0; i<16; i++) {
    line (i*15,16,16,196-(i*12),5);
    line (i*15,196,256,196-(i*12),5);
  }

  show();
  setup();

  loop();


  return (0);
}
