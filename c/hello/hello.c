
//#include "ravr.c"
#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

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

void setImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);

    const uint8_t* walk = progmem_data;
    progmem_data+=bytesPerRow;
    for (uint8_t tx=0;tx<w;tx++) {
       uint8_t pixel = pgm_read_byte(walk);
       walk+=1;
       if (pixel == 0) PORT_SERIAL_PIXEL_ADD=0; else PORT_SERIAL_PIXEL_SET = pixel;
    }
  }
}

void writeRect(uint16_t x,uint16_t y, uint8_t w, uint8_t h,uint8_t color) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);
    for (uint8_t tx=0;tx<w;tx++) {
        PORT_SERIAL_PIXEL_SET = color;
    }
  }
}

const uint8_t arrow[] PROGMEM = {
  2,0,0,0,0,0,0,0,
  2,2,0,0,0,0,0,0,
  2,2,2,0,0,0,0,0,
  2,2,2,2,0,0,0,0,
  2,2,2,2,2,0,0,0,
  2,2,2,2,2,2,0,0,
  2,2,2,2,2,0,0,0,
  2,0,2,2,2,0,0,0,
  0,0,0,2,2,2,0,0,
  0,0,0,2,2,2,0,0,
  0,0,0,0,2,2,2,0,
  0,0,0,0,2,2,2,0 };

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
    {146,0,146,0,2,0}				,// l
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


void renderMode0(uint16_t dataStart, uint8_t width_in_cells, uint8_t pageHeight ) {
    PORT_MODE0_PIXEL_DISPLAY_START = dataStart;
    PORT_MODE0_COLOR_DISPLAY_START = (dataStart+1);
    PORT_MODE0_PIXEL_INCREMENT=2;
    PORT_MODE0_COLOR_INCREMENT=2;
    PORT_MODE0_PIXEL_LINE_INCREMENT=width_in_cells >> 2; //   width_in_cells*2 >> 3
    PORT_MODE0_COLOR_LINE_INCREMENT=width_in_cells >> 2;
    PORT_DISPLAY_CONTROL=0x80;
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

int main (void)
{
  SP=0xffff;

  const int pageBase=0x4000;
  const int charsWide=40;
  const int charsHigh=20;

  const int pageEnd=pageBase+charsWide*charsHigh*6*2; //char cell is 6 bytes for pixels and  6 bytes for colour

  uint16_t data = 0;

    for (;;)  {
      //fill some memory with some changing data
      uint16_t* walk = (uint16_t*)(pageBase);
      walk=(uint16_t*)(pageBase);
  	  while (walk < (uint16_t*)(pageEnd)) {
    	   *walk++=data++;
      }

      // write some text into the page
      renderString(0,0,PSTR("Hello"),0x0f,pageBase,charsWide ,charsHigh);
      renderString(3,3,PSTR("World"),0x01,pageBase,charsWide ,charsHigh);

      //transfer the page of 3x3 cells to the frameBuffer
      //this operation sets all pixels in the output frameBuffer
      renderMode0(pageBase,charsWide*2,charsHigh*3);

      //set pixel 120,90 in the framebuffer to 2 (White)
      setPixelCursor(120,90);
      PORT_SERIAL_PIXEL_SET = 2;

      //write a grid of rectangles showing the serial pixel output palette
      for (uint16_t ty=0;ty <16; ty++) {
        for (uint16_t tx=0;tx <16; tx++) {
          writeRect(tx*6,84+ty*6,5,5,(ty<<4)+tx);
        }
      }

      //read the mouse location
      uint16_t x=PORT_MOUSEX;
      uint16_t y=PORT_MOUSEY;

      //draw a mouse pointer using serial pixel output
      writeRect(x,y,3,3,2);

      //put frame onscreen in lowres
      PORT_DISPLAY_CONTROL=0x00;
    }
    return (0);
}
