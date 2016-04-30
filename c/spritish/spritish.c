
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

#define PORT_MODE1_DISPLAY_START  _SFR_IO16(0x28)
#define PORT_MODE1_BYTES_WIDE  _SFR_IO8(0x2A)
#define PORT_MODE1_HEIGHT  _SFR_IO8(0x2B)
#define PORT_MODE1_LINE_INCREMENT  _SFR_IO8(0x2C)
#define PORT_MODE1_PALETTE_START  _SFR_IO16(0x2D)
#define PORT_MODE1_FLAGS  _SFR_IO8(0x2F)

#define PORT_MOUSEX  _SFR_IO8(0x2A)
#define PORT_MOUSEY  _SFR_IO8(0x2B)
#define PORT_TICK  _SFR_IO8(0x2C)
#define PORT_TIME  _SFR_IO8(0x2D)

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


const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };


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

void mode1Image(uint8_t x, uint8_t y, uint8_t* data, uint8_t bytesWide, uint8_t height) {

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

void testRenderMode1(uint16_t x, uint8_t y,uint8_t mode, uint8_t flags) {

    PORT_MODE1_DISPLAY_START  = (uint16_t)(&testSprite);
    PORT_MODE1_BYTES_WIDE  = 4;
    PORT_MODE1_HEIGHT = 12;
    PORT_MODE1_LINE_INCREMENT = 4;
    PORT_MODE1_PALETTE_START = (uint16_t)(&palette);

    PORT_MODE1_FLAGS  = flags;

    setPixelCursor(x,y);

    PORT_DISPLAY_CONTROL = mode;

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
  uint8_t mode = 0x84;
    for (;;)  {
      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      if (nextStep) {
        mode+=1;
        if (mode > 0x84) mode=0x81;
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
      PORT_SERIAL_PIXEL_SET = 2;

      writeRect(40,20,32,32,43);

      const uint8_t flipx = 0x80;
      const uint8_t flipy = 0x40;
      const uint8_t doublex = 0x20;
      const uint8_t doubley = 0x10;

      testRenderMode1(50,30,mode,0);
      testRenderMode1(80,30,mode,0);

      testRenderMode1(50,60,mode,0);
      testRenderMode1(80,60,mode,flipx);
      testRenderMode1(110,60,mode,flipy);
      testRenderMode1(140,60,mode,flipx|flipy);

      testRenderMode1(50,90,mode,doubley);
      testRenderMode1(80,90,mode,doubley|flipx);
      testRenderMode1(110,90,mode,doubley|flipy);
      testRenderMode1(140,90,mode,doubley|flipx|flipy);

      testRenderMode1(50,120,mode,doublex);
      testRenderMode1(80,120,mode,doublex|flipx);
      testRenderMode1(110,120,mode,doublex|flipy);
      testRenderMode1(140,120,mode,doublex|flipx|flipy);

      testRenderMode1(50,140,mode,doublex|doubley);
      testRenderMode1(80,140,mode,doublex|doubley|flipx);
      testRenderMode1(110,140,mode,doublex|doubley|flipy);
      testRenderMode1(140,140,mode,doublex|doubley|flipx|flipy);

      //write a grid of rectangles showing the serial pixel output palette
      for (uint16_t ty=0;ty <4; ty++) {
        for (uint16_t tx=0;tx <4; tx++) {
          writeRect(200+tx*6,10+ty*6,5,5,(ty<<2)+tx);
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
