
//#include "ravr.c"
#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

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


#define  DC_SHOW_DISPLAY  0
#define  DC_SHOW_DISPLAY_HIRES 1
  
#define  BLITCON_BLIT_8 1
#define  BLITCON_BLIT_4 2
#define  BLITCON_BLIT_3 3
#define  BLITCON_BLIT_2 4

#define  BLITCON_MODE_0 0x10
#define  BLITCON_MODE_1 0x11

#define PORT_BLIT_IMAGE_START  _SFR_IO16(0x28)
#define PORT_BLIT_BYTES_WIDE  _SFR_IO8(0x2A)
#define PORT_BLIT_PIXELS_HIGH  _SFR_IO8(0x2B)
#define PORT_BLIT_LINE_INCREMENT  _SFR_IO8(0x2C)
#define PORT_BLIT_PALETTE_START  _SFR_IO16(0x2D)
#define PORT_BLIT_FLAGS  _SFR_IO8(0x2F)

#define PORT_BUTTONS  _SFR_IO16(0x10)
#define PORT_BUTTONSA  _SFR_IO8(0x10)
#define PORT_BUTTONSB  _SFR_IO8(0x11)
#define PORT_MOUSE_X  _SFR_IO8(0x12)
#define PORT_MOUSE_Y  _SFR_IO8(0x13)
#define PORT_TICK  _SFR_IO8(0x14)
#define PORT_TIME  _SFR_IO8(0x15)
#define PORT_KEY_BUFFER  _SFR_IO8(0x16)

void setPixelCursor(uint16_t x,uint16_t y) {
  uint32_t addr = ((uint32_t)(y)) * 512 + x ;

  PORT_SERIAL_PIXEL_ADDRESS_H = (addr >> 16);
  PORT_SERIAL_PIXEL_ADDRESS_M =  (addr >> 8);
  PORT_SERIAL_PIXEL_ADDRESS_L =  (addr >> 0);
}

void setImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);

    const uint8_t* walk = progmem_data;
    progmem_data+=bytesPerRow;
    for (uint8_t tx=0;tx<w;tx++) {
       uint8_t pixel = pgm_read_byte(walk);
       walk+=1;
       if (pixel == 0) PORT_SERIAL_PIXEL_SUB=0; else PORT_SERIAL_PIXEL_ADD = pixel;
    }
  }
}

void writeRect(uint16_t x,uint16_t y, uint8_t w, uint8_t h,uint8_t color) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);
    for (uint8_t tx=0;tx<w;tx++) {
        PORT_SERIAL_PIXEL_ADD = color;
    }
  }
}


const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};

const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint8_t font[96][6] PROGMEM = {
  {00,00,00,00,00,00}				,//  Space
  {144,0,146,0,130,0}				,//  !
  {144,144,0,0,0,0}						,//  quote
  {128,128,151,151,23,23}			,//  #
  {116,24,6,145,39,1}		,//  $
  {88,74,148,128,1,3}			,//  %
  {78,8,86,168,49,10}		,//  &
  {0,72,0,0,0,0}						,//  singlequote
  {160,1,146,0,4,8}				,// (
  {4,136,0,146,32,1}					,// )
  {136,80,60,24,10,17}			,// *
  {0,64,48,121,0,1}				,// +
  {0,0,128,0,1,0}						,// ,
  {0,0,56,24,0,0}						,// -
  {0,0,128,0,2,0}							,// .
  {0,74,164,0,10,0}					,// /
  {148,145,146,146,4,1}			,// 0
  {32,73,0,73,4,3}			,// 1
  {14,145,84,1,7,3}			,// 2
  {6,145,4,145,6,1}			,// 3
  {160,73,57,89,0,1}			,// 4
  {150,3,6,145,6,1}			,//	5
  {148,1,150,145,4,1}			,// 6
  {6,147,160,1,2,0}				,// 7
  {148,145,148,145,4,1}			,// 8
  {148,145,132,147,4,1}		,// 9
  {0,64,0,64,0,0}							,// :
  {0,64,0,64,4,0}						,// ;
  {80,4,136,0,0,0}					,// <
  {0,0,6,3,6,3}				,// =
  {136,0,84,0,0,0}					,// >
  {14,145,32,1,4,0}					,// ?
  {84,209,109,82,34,8} 	,// @
  {78,145,79,147,1,2} 		,// A
  {79,145,79,145,7,1}		,// B
  {78,17,73,128,6,1}			,// C
  {79,136,73,82,7,0}     ,// D
  {79,3,79,0,7,3}      ,// E
  {79,3,79,0,1,0}					,// F
  {78,3,77,147,6,3}   ,// G
  {73,146,79,147,1,2}		,// H
  {151,0,146,0,7,0}      ,// I
  {6,75,64,73,6,0}				,// J
  {73,82,79,136,1,2}			,// K
  {73,0,73,0,7,3}				,// L
  {217,218,109,146,1,2}		,// M
  {217,146,109,210,1,3}		,// N
  {78,145,73,146,6,1}		,// O
  {79,145,79,1,1,0}				,// P
  {78,145,105,210,16,17}		,// Q
  {79,145,79,137,1,2}		,// R
  {78,17,70,145,6,1}		,// S
  {6,79,0,73,0,1}			,// T
  {73,146,73,146,6,1}		,// U
  {73,146,145,74,4,0}			,// V
  {73,146,173,82,2,1}		,// W
  {137,82,84,136,1,2}			,// X
  {73,146,162,1,1,0}     ,// Y
  {7,83,84,0,7,3}     ,// Z
  {79,0,73,0,57,0}				,// [
  {137,0,36,64,0,18}					,// backslash
  {6,73,0,73,48,9}				,// ]
  {84,136,0,0,0,0}					,// ^
  {0,0,0,0,56,56}					,// _
  {32,64,0,0,0,0}					,// `
  {48,136,78,147,6,5}			,// a
  {73,0,79,145,7,1}				,// b
  {112,136,73,128,6,1}		,// c
  {0,146,78,147,6,3}			,// d
  {112,136,79,131,6,1}		,// e
  {148,1,151,0,2,0}				,// f
  {112,152,49,154,32,10}	,// g
  {73,0,79,145,1,2}				,// h
  {0,65,0,73,0,1}					,// i
  {0,65,0,73,49,1}				,// j
  {73,64,111,64,1,2}			,// k
  {0,73,0,73,0,17}				,// l
  {208,200,109,146,1,2}		,// m
  {120,136,73,146,1,2}		,// n
  {112,136,73,146,6,1}		,// o
  {120,136,121,10,9,0}			,// p
  {112,72,49,73,0,137}		,// q
  {232,8,73,0,1,0}				,// r
  {112,8,70,145,6,1}		,// s
  {186,8,146,0,2,0}			,// t
  {72,144,73,146,6,3}			,// u
  {72,144,137,82,4,0}			,// v
  {72,144,169,82,2,1}			,// w
  {136,80,164,64,1,2}			,// x
  {72,144,34,154,48,1}		,// y
  {56,152,160,1,7,3}			,// z
  {148,1,145,0,4,1}				,// {
  {0,73,0,73,0,73}				,// |
  {6,72,0,74,6,0}					,// }
  {112,224,0,0,0,0}				 // ~
};

void renderMode0(uint16_t dataStart, uint8_t width_in_cells, uint8_t height_in_cells ) {
    PORT_MODE0_IMAGE_DATA = dataStart;
    PORT_MODE0_CELLS_WIDE=width_in_cells;
    PORT_MODE0_CELLS_HIGH=height_in_cells;
    PORT_MODE0_LINE_INCREMENT=width_in_cells;
    setPixelCursor(0,0);
    PORT_BLIT_CONTROL=BLITCON_MODE_0;
}

void renderChar(uint8_t x, uint8_t y, uint8_t ch, uint8_t attribute,  uint16_t textPage, uint8_t pageWidth, uint8_t pageHeight  ) {
   uint8_t* cell = (uint8_t*) textPage;

   cell+= (y * pageWidth*2 * 3 + x*2)*2;

   uint8_t character = ch-32;
   *(cell + 0)=pgm_read_byte(&font[character][0]);
   *(cell + 1)=attribute;
   *(cell + 2)=pgm_read_byte(&font[character][1]);
   *(cell + 3)=attribute;
   cell+= pageWidth*4;
   *(cell + 0)=pgm_read_byte(&font[character][2]);
   *(cell + 1)=attribute;
   *(cell + 2)=pgm_read_byte(&font[character][3]);
   *(cell + 3)=attribute;
   cell+= pageWidth*4;
   *(cell + 0)=pgm_read_byte(&font[character][4]);
   *(cell + 1)=attribute;
   *(cell + 2)=pgm_read_byte(&font[character][5]);
   *(cell + 3)=attribute;
}

void renderString(uint8_t x, uint8_t y,const char* s, uint8_t attribute,  uint16_t textPage, uint8_t pageWidth, uint8_t pageHeight  ) {
  uint8_t ch;
  while (ch = pgm_read_byte(s)) {
    renderChar(x++,y,ch,attribute,textPage,pageWidth,pageHeight);
    s+=1;
  }
}

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
    PORT_BLIT_PIXELS_HIGH = 12;
    PORT_BLIT_LINE_INCREMENT = 4;
    PORT_BLIT_PALETTE_START = (uint16_t)(&palette);

    PORT_BLIT_FLAGS  = flags;

    setPixelCursor(x,y);

    PORT_BLIT_CONTROL = mode;

}

void drawImageData(uint16_t x, uint8_t y, uint8_t width_in_bytes, uint8_t height, const  uint8_t* image,const uint8_t* palette_table, uint8_t mode, uint8_t flags) {
  PORT_BLIT_IMAGE_START  = (uint16_t)(image);
  PORT_BLIT_BYTES_WIDE  = width_in_bytes;
  PORT_BLIT_PIXELS_HIGH = height;
  PORT_BLIT_LINE_INCREMENT = width_in_bytes;
  PORT_BLIT_PALETTE_START = (uint16_t)(palette_table);

  PORT_BLIT_FLAGS  = flags;

  setPixelCursor(x,y);

  PORT_BLIT_CONTROL = mode;
}

int main (void)
{
  SP=0xffff;

  const int pageBase=0x4000;
  const int charsWide=40;
  const int charsHigh=20;

  const int pageEnd=pageBase+charsWide*charsHigh*6*2; //char cell is 6 bytes for pixels and  6 bytes for colour

  uint16_t data = 0;
  uint8_t lastTime = 5;
  uint8_t mode = BLITCON_BLIT_8;
    for (;;)  {
      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      if (nextStep) {
        mode+=1;
        if (mode > BLITCON_BLIT_2) mode=BLITCON_BLIT_8;
      }


      //fill some memory with some changing data
      uint16_t* walk = (uint16_t*)(pageBase);
      walk=(uint16_t*)(pageBase);
  	  while (walk < (uint16_t*)(pageEnd)) {
    	   *walk++=data++;

         data=0;
      }

      // write some text into the page
      renderString(0,0,PSTR("HELLO"),0x0f,pageBase,charsWide ,charsHigh);
      renderString(6,1,PSTR("THERE"),0x01,pageBase,charsWide ,charsHigh);
      renderString(17,4,PSTR("FLIPS"),0x02,pageBase,charsWide ,charsHigh);
      renderString(13,5,PSTR("X    Y    XY"),0x02,pageBase,charsWide ,charsHigh);

      renderString(2,10,PSTR(" 2H"),0x02,pageBase,charsWide ,charsHigh);
      renderString(2,13,PSTR(" 2W"),0x02,pageBase,charsWide ,charsHigh);
      renderString(0,16,PSTR(" 2W + 2H)"),0x02,pageBase,charsWide ,charsHigh);

      for (int dataY=0;dataY<12;dataY++) {
        for (int dataX=0;dataX<4;dataX++) {
          uint8_t value = testSprite[dataY*4+dataX];

          renderChar(dataX*3+28,dataY+6,pgm_read_byte(&hexDigits[value >> 4]),0xC1,pageBase,charsWide ,charsHigh);
          renderChar(dataX*3+28+1,dataY+6,pgm_read_byte(&hexDigits[value & 0x0f]),0xC1,pageBase,charsWide ,charsHigh);
        }
      }
      //transfer the page of 3x3 cells to the frameBuffer
      //this operation sets all pixels in the output frameBuffer
      renderMode0(pageBase,charsWide*2,charsHigh*3);

      //set pixel 120,90 in the framebuffer to 2 (White)
      setPixelCursor(120,90);
      PORT_SERIAL_PIXEL_ADD = 2;

      writeRect(40,20,32,32,43);

      const uint8_t flipx = 0x80;
      const uint8_t flipy = 0x40;
      const uint8_t doublex = 0x20;
      const uint8_t doubley = 0x10;

      testBlit(50,30,mode,0);
      testBlit(80,30,mode,0);

      testBlit(50,60,mode,0);
      testBlit(80,60,mode,flipx);
      testBlit(110,60,mode,flipy);
      testBlit(140,60,mode,flipx|flipy);

      testBlit(50,90,mode,doubley);
      testBlit(80,90,mode,doubley|flipx);
      testBlit(110,90,mode,doubley|flipy);
      testBlit(140,90,mode,doubley|flipx|flipy);

      testBlit(50,120,mode,doublex);
      testBlit(80,120,mode,doublex|flipx);
      testBlit(110,120,mode,doublex|flipy);
      testBlit(140,120,mode,doublex|flipx|flipy);

      testBlit(50,140,mode,doublex|doubley);
      testBlit(80,140,mode,doublex|doubley|flipx);
      testBlit(110,140,mode,doublex|doubley|flipy);
      testBlit(140,140,mode,doublex|doubley|flipx|flipy);

      //write a grid of rectangles showing the serial pixel output palette
      for (uint16_t ty=0;ty <4; ty++) {
        for (uint16_t tx=0;tx <4; tx++) {
          writeRect(200+tx*6,10+ty*6,5,5,(ty<<2)+tx);
        }
      }

      //read the mouse location
      uint16_t x=PORT_MOUSE_X;
      uint16_t y=PORT_MOUSE_Y;


      drawImageData(x,y,3,16,arrow,arrowPal,0x72,0);

      //put frame onscreen in lowres
      PORT_DISPLAY_CONTROL=DC_SHOW_DISPLAY;
    }
    return (0);
}
