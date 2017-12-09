
#include <stdbool.h>

#include "hwio.h"


const char hexDigits[] PROGMEM = { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' };

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


void drawByteAsHex(uint16_t x, uint16_t y, uint8_t value, uint8_t color) {
  renderChar(x,y,pgm_read_byte(&hexDigits[value >> 4]),color,0x4000,44 , 20);
  renderChar(x+1,y,pgm_read_byte(&hexDigits[value & 0x0f]),color,0x4000, 44 ,20);
}

void drawByteAsDec(uint16_t x, uint16_t y, uint8_t value, uint8_t color) {
  x+=3;
  do {
    renderChar(x,y,pgm_read_byte(&hexDigits[value %10]),color,0x4000,44 , 20);
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

  const int pageBase=0x4000;
  const int charsWide=44;
  const int charsHigh=20;

  const int pageEnd=pageBase+charsWide*charsHigh*6*2; //char cell is 6 bytes for pixels and  6 bytes for colour

  
  uint16_t data = 0;
  uint8_t lastTime = 5;
  uint8_t mode = 0x74;
  
  uint8_t currentLine = 0;
  uint16_t oldButtons =0; 

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
      renderProgMemString(18,2,PSTR("Audio Test"),0x0f,pageBase,charsWide ,charsHigh);

      //renderProgMemString(10,15,PSTR("PORT $4C  Frame Ticker"),0x02,pageBase,charsWide ,charsHigh);
      //renderProgMemString(10,16,PSTR("PORT $4D  Second Ticker "),0x02,pageBase,charsWide ,charsHigh);


      renderProgMemString(7,5,PSTR("Frequency "),0x0f,pageBase,charsWide ,charsHigh);
      drawByteAsHex(38,5,freq>>8,0x0f);
      drawByteAsHex(40,5,freq,0x0f);

      renderProgMemString(10,6,PSTR("Volume "),0x0E,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,6,vol,0x0E);

      renderProgMemString(7,7,PSTR("Wave Base "),0x08,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,7,waveBase,0x08);

      renderProgMemString(6,8,PSTR("Wave Shift "),0x08,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,8,waveShift << 4,0x08);

      renderProgMemString(3,9,PSTR("Bend Duration "),0x06,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,9,bendDuration,0x06);
      
      renderProgMemString(6,10,PSTR("Bend Phase "),0x07,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,10,bendPhase<<5,0x07);

      renderProgMemString(6,11,PSTR("Bend Depth "),0x07,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,11,bendAmplitude,0x07);

      renderProgMemString(11,12,PSTR("Noise "),0x0a,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,12,noise,0x0a);

      renderProgMemString(12,13,PSTR("Hold "),0x0a,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,13,hold << 4,0x0a);

      renderProgMemString(10,14,PSTR("Attack "),0x0b,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,14,attack,0x0b);

      renderProgMemString(9,15,PSTR("Release "),0x0b,pageBase,charsWide ,charsHigh);
      drawByteAsHex(40,15,release << 4,0x0b);

      //drawByteAsDec(13,2,PORT_MOUSEX);
      //drawByteAsDec(15,2,PORT_MOUSEY);

      aNum=hold;
      //drawByteAsHex(14,4,aNum & 0xff);

      drawByteAsHex(36,2,PORT_TICK,12);
      drawByteAsHex(39,2,PORT_TIME,12);

      //transfer the page of 3x3 cells to the frameBuffer
      //this operation sets all pixels in the output frameBuffer
      renderMode0(pageBase,charsWide*2,charsHigh*3);


      fillRect(108,47,1+(isqrt(freq) >> 1),4,15);
      fillRect(108,56,1+(vol >> 1),4,14);
      fillRect(108,65,1+(waveBase << 3),4,8);
      fillRect(108,74,1+(waveShift << 3),4,8);
      fillRect(108,83,1+(bendDuration<<2),4,6);
      fillRect(108,92,1+(bendPhase<<4),4,7);
      fillRect(108,101,1+(bendAmplitude >>1),4,7);
      fillRect(108,110,1+(noise << 3),4,10);
      fillRect(108,119,1+(hold << 3),4,10);
      fillRect(108,128,1+(attack<<3),4,11);
      fillRect(108,137,1+(release <<3),4,11);

      //read the mouse location and buttons
      uint16_t mx=PORT_MOUSEX+15;
      uint16_t my=PORT_MOUSEY+15;
      uint16_t buttons =  PORT_BUTTONS;
      uint16_t changes= oldButtons ^ buttons;
      uint16_t downs = changes & buttons;
      oldButtons=buttons;

      
      if ((downs & 0x2000) && pointInRect (mx,my, 108,47,128,9*11) ) {
        uint8_t line=(my-47) /9;
        if ( (my +1)%9 >2 ) {
          currentLine=line;
        }
      }

      if (buttons & 0x2000) {
        int16_t value=mx-108;
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
          fillRect(left,150,7,40,color);
      }
      for (uint16_t tx=0;tx <28; tx++) {
          if ( ((tx%7) &3) !=2 ) {
            uint16_t left=24+tx*8+4;
            uint8_t color=0;
            if (pointInRect (mx,my, left,150,7,25)) {
              color=1;
              keyIndex = tx*2+1;
            }
            fillRect(left,150,7,25,color);
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
      


      drawImageData(mx,my,3,16,arrow,arrowPal,0x72,0);

      //put frame onscreen in lowres
      PORT_DISPLAY_SHIFT=0xff;
      PORT_DISPLAY_CONTROL=0x00;
    }
    return (0);
}
