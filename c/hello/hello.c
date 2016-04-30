
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

const uint8_t font[64][6] PROGMEM = {
  {00,00,00,00,00,00}				,//  Space
  {144,0,146,0,130,0}				,//  !
  {72,72,0,0,0,0}						,//  quote
  {232,232,233,233,1,1}			,//  #
  {80,172,17,100,136,118}		,//  $
  {192,80,3,37,82,213}			,//  %
  {80,68,145,160,137,113}		,//  &
  {0,36,0,0,0,0}						,//  singlequote
  {128,4,73,0,17,32}				,// (
  {0,68,0,146,0,42}					,// )
  {136,80,24,60,10,17}			,// *
  {128,0,158,12,2,0}				,// +
  {0,0,0,0,82,0}						,// ,
  {0,0,24,12,0,0}						,// -
  {0,0,0,0,2,0}							,// .
  {0,72,0,37,146,0}					,// /
  {128,68,73,150,17,42}			,// 0
  {208,0,146,0,210,32}			,// 1
  {80,68,128,5,201,96}			,// 2
  {80,68,16,69,138,41}			,// 3
  {0,104,202,233,0,73}			,// 4
  {88,12,17,68,192,41}			,//	5
  {80,68,89,68,137,41}			,// 6
  {24,76,0,37,146,0}				,// 7
  {80,68,81,69,137,41}			,// 8
  {80,68,137,105,136,41}		,// 9
  {0,0,0,4,0,4}							,// :
  {0,0,0,4,128,4}						,// ;
  {128,4,69,0,2,4}					,// <
  {192,96,192,96,0,0}				,// =
  {68,0,130,4,5,0}					,// >
  {80,140,0,42,0,4}					,// ?
  {80,140,73,183,137,227} 	,// @
  {80,140,89,158,73,146} 		,// A
  {80,140,89,142,201,114}		,// B
  {80,140,73,0,137,112}			,// C
  {88,68,73,146,201,42}     ,// D
  {88,28,89,4,201,224}      ,// E
  {88,28,89,4,73,0}					,// F
  {80,140,73,192,137,114}   ,// G
  {72,144,89,158,73,146}		,// H
  {152,4,146,0,210,32}      ,// I
  {0,92,0,73,196,41}				,// J
  {72,144,89,37,73,145}			,// K
  {72,0,73,0,201,224}				,// L
  {200,208,75,183,73,146}		,// M
  {200,144,75,182,73,155}		,// N
  {80,140,73,146,137,114}		,// O
  {88,140,89,14,73,0}				,// P
  {80,140,73,146,137,170}		,// Q
  {88,140,201,114,73,146}		,// R
  {80,140,17,68,136,114}		,// S
  {156,12,146,0,146,0}			,// T
  {72,144,73,146,137,114}		,// U
  {72,144,137,82,2,37}			,// V
  {72,144,73,182,91,155}		,// W
  {72,144,2,37,74,145}			,// X
  {72,144,17,114,192,5}     ,// Y
  {24,156,0,37,202,224}     ,// Z
  {88,12,73,0,201,96}				,// [
  {137,0,2,36,0,9}					,// backslash
  {24,76,0,73,24,13}				,// ]
  {128,32,1,1,0,0}					,// ^
  {0,0,0,0,224,224}					// _
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
      renderString(0,0,PSTR("HELLO"),0x0f,pageBase,charsWide ,charsHigh);
      renderString(3,3,PSTR("THERE"),0x01,pageBase,charsWide ,charsHigh);

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
      setImage(x,y,8,12,arrow,8);

      //put frame onscreen in lowres
      PORT_DISPLAY_CONTROL=0x00;
    }
    return (0);
}
