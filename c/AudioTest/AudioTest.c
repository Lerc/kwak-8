
#include <stdbool.h>

#include "../common/hwio.h"
#include "../common/simplegfx.h"


const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};
const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint16_t noteFreq[] = { 
  1097,1163,   1232,1305,   1383,0,   1465,1552,   1644,1742,   1846,1955,   2072,0,
  2195,2326,   2463,2611,   2765,0,   2930,3104,   3289,3485,   3691,3911,   4143,0,
  4389,4651,   4928,5220,   5530,0,   5859,6208,   6577,6968,   7383,7822,   8287,0,
  8780,9302,   9854,10441, 11720,0, 12416,13154, 13936,14765,   15643,16574, 17551,0};

uint16_t freq = 2000;
uint8_t vol = 128;
uint8_t waveBase = 8;
uint8_t waveShift = 8;
uint8_t bendDuration = 0;
uint8_t bendPhase = 0;
uint8_t bendAmplitude = 20;
uint8_t noise = 0;
uint8_t hold = 1;
uint8_t attack = 2;
uint8_t release = 8;

uint8_t aNum = 5;

uint8_t voiceNumber = 0;

TextPage_t page_data;
TextPage_t* page = &page_data; 

void updateVoice_basic() {
  
  PORT_VOICE_FREQ=freq;
  PORT_VOICE_VOLUME = vol;
  PORT_VOICE_WAVE_SHAPE = waveBase | (waveShift << 4);
  PORT_VOICE_BEND_WAVE = bendDuration | (bendPhase <<5);
  PORT_VOICE_BEND_AMPLITUDE = bendAmplitude;
  PORT_VOICE_NOISE_HOLD = noise | (hold <<4);  
   
}
void updateVoice() {
  updateVoice_basic();
  //writing to attack_release register triggers envelope cycle 
  PORT_VOICE_ATTACK_RELEASE = attack + (release << 4);
}

char hexDigit(uint8_t val) {
  if (val < 10) return val+48;
  if (val < 16) return val+55; 
  return '_';
}

void drawByteAsHex(uint16_t x, uint16_t y, uint8_t value, uint8_t color) {
  write_char_xy(x,y,hexDigit(value >> 4),color,page);
  write_char_xy(x+1,y,hexDigit(value & 0x0f),color,page);
}

void drawByteAsDec(uint16_t x, uint16_t y, uint8_t value, uint8_t color) {
  x+=3;
  do {
    write_char_xy(x,y,hexDigit(value % 10),color,page);
    x-=1;
    value/=10;
  } while (value>0);
}

bool pointInRect(uint16_t x, uint16_t y, uint16_t left, uint16_t top, uint16_t width, uint16_t height ) {
  if (x<left) return false;
  if (x>=left+width) return false;
  if (y<top) return false;
  if (y>=top+height) return false;
  return true;
}

uint16_t isqrt(uint16_t value)
{
    uint8_t i;
    uint16_t rem =0;
    uint16_t root=0;
    for ( i = 0; i < 8; i++ ) {
        root <<= 1;
        rem = ((rem << 2) + (value >> 14));
        value <<= 2;
        root++;
        if ( root <= rem ) {
            rem -= root;
            root++;
        } else {
            root--;
        }
    }
    return (root >> 1);
}

int main (void)
{
  SP=0xffff;
  page_data = makeTextPage(0xC000,40,20,0,0);


  
  uint16_t data = 0;
  uint8_t lastTime = 5;
  
  uint8_t currentLine = 0;
  uint16_t oldButtons =0; 

    for (;;)  {
      wait_frame();
      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      // write some text into the page
      write_romstring_xy(16,1,PSTR("Audio Test"),0x0f,page);

      write_romstring_xy(5,3,PSTR("Frequency "),0x0f,page);
      drawByteAsHex(36,3,freq>>8,0x0f);
      drawByteAsHex(38,3,freq,0x0f);

      write_romstring_xy(8,4,PSTR("Volume "),0x0E,page);
      drawByteAsHex(38,4,vol,0x0E);

      write_romstring_xy(5,5,PSTR("Wave Base "),0x08,page);
      drawByteAsHex(38,5,waveBase,0x08);

      write_romstring_xy(4,6,PSTR("Wave Shift "),0x08,page);
      drawByteAsHex(38,6,waveShift << 4,0x08);

      write_romstring_xy(1,7,PSTR("Bend Duration "),0x06,page);
      drawByteAsHex(38,7,bendDuration,0x06);
      
      write_romstring_xy(4,8,PSTR("Bend Phase "),0x07,page);
      drawByteAsHex(38,8,bendPhase<<5,0x07);

      write_romstring_xy(4,9,PSTR("Bend Depth "),0x07,page);
      drawByteAsHex(38,9,bendAmplitude,0x07);

      write_romstring_xy(9,10,PSTR("Noise "),0x0a,page);
      drawByteAsHex(38,10,noise,0x0a);

      write_romstring_xy(10,11,PSTR("Hold "),0x0a,page);
      drawByteAsHex(38,11,hold << 4,0x0a);

      write_romstring_xy(8,12,PSTR("Attack "),0x0b,page);
      drawByteAsHex(38,12,attack,0x0b);

      write_romstring_xy(7,13,PSTR("Release "),0x0b,page);
      drawByteAsHex(38,13,release << 4,0x0b);

      drawByteAsHex(34,0,PORT_TICK,12);
      drawByteAsHex(37,0,PORT_TIME,12);

      drawByteAsHex(0,0,PORT_MOUSE_X,0x0b);
      drawByteAsHex(0,1,PORT_MOUSE_Y,0x0b);
      //transfer the page of 3x3 cells to the frameBuffer
      //this operation sets all pixels in the output frameBuffer

      renderMode0(16,16,(uint16_t)page->cells.start,page->cells.width,page->cells.height);

      //read the mouse location and buttons
      uint16_t mx=PORT_MOUSE_X+16;
      uint16_t my=PORT_MOUSE_Y+16;

      uint16_t buttons =  PORT_BUTTONS;
      uint16_t changes= oldButtons ^ buttons;
      uint16_t downs = changes & buttons;
      oldButtons=buttons;

      if ( pointInRect (mx,my, 108,45,128,9*11) ) {
        uint8_t line=(my-45) /9;
        if ( (my +4)%9 >3 ) {
          currentLine=line;
        }
      }

      serial_fill_rect(102,45,1+(isqrt(freq) >> 1),4,currentLine==0?3:15);
      serial_fill_rect(102,54,1+(vol >> 1),4,currentLine==1?3:14);
      serial_fill_rect(102,63,1+(waveBase << 3),4,currentLine==2?3:8);
      serial_fill_rect(102,72,1+(waveShift << 3),4,currentLine==3?3:8);
      serial_fill_rect(102,81,1+(bendDuration<<2),4,currentLine==4?3:6);
      serial_fill_rect(102,90,1+(bendPhase<<4),4,currentLine==5?3:7);
      serial_fill_rect(102,99,1+(bendAmplitude >>1),4,currentLine==6?3:7);
      serial_fill_rect(102,108,1+(noise << 3),4,currentLine==7?3:10);
      serial_fill_rect(102,117,1+(hold << 3),4,currentLine==8?3:10);
      serial_fill_rect(102,126,1+(attack<<3),4,currentLine==9?3:11);
      serial_fill_rect(102,135,1+(release <<3),4,currentLine==10?3:11);

      

      if (buttons & 0x2000) {
        int16_t value=mx-102;
        if (value < 0) value = 0;
        if (value >127)  value = 127;
        switch (currentLine) {
          case 0: freq=(value<<1)* (value<<1); updateVoice_basic(); break;
          case 1: vol=value<<1; updateVoice_basic();break;
          case 2: waveBase=value>>3; updateVoice_basic();break;
          case 3: waveShift=value>>3; updateVoice_basic();break;
          case 4: bendDuration=value>>2; updateVoice_basic();break;
          case 5: bendPhase=value>>4; updateVoice_basic();break;
          case 6: bendAmplitude=value<<1; updateVoice_basic();break;
          case 7: noise=value>>3; updateVoice_basic();break;
          case 8: hold=value>>3; updateVoice_basic();break;
          case 9: attack=value>>3; updateVoice();break;
          case 10: release=value>>3; updateVoice();break;
        }        
      } else currentLine = 0xff;
      uint8_t keyIndex = 0xff;
      
      for (uint16_t tx=0;tx <28; tx++) {
          uint16_t left=24+tx*8;
          uint8_t color=2;
          if (pointInRect (mx,my, left,175,7,40)) {
            color=1;
            keyIndex = tx *2;
          }
          serial_fill_rect(left,150,7,40,color);
      }

      for (uint16_t tx=0;tx <28; tx++) {
          if ( ((tx%7) &3) !=2 ) {
            uint16_t left=24+tx*8+4;
            uint8_t color=0;
            if (pointInRect (mx,my, left,150,7,25)) {
              color=1;
              keyIndex = tx*2+1;
            }
            serial_fill_rect(left,150,7,25,color);
          }
      }

      if (downs & 0x2000) {
        if (keyIndex != 0xff) {
          aNum=keyIndex;
          freq=noteFreq[keyIndex];
          voiceNumber = (voiceNumber+1) & 7;
          PORT_VOICE_SELECT = voiceNumber;
          updateVoice();
        }
      }
      
      blit_image(mx,my,3,16,arrow,arrowPal,BLITCON_BLIT_4,0);

      //put frame onscreen in lowres
      PORT_DISPLAY_SHIFT_X=16;
      PORT_DISPLAY_SHIFT_Y=16;
      PORT_DISPLAY_CONTROL=DC_SHOW_DISPLAY;
    }
    return (0);
}
