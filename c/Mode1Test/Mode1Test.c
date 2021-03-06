


#include "../common/hwio.h"

const uint8_t arrowPal[] = {0x00,0x21,0x23,0x45,0x67,0x89,0xab,0xcd};
const uint8_t arrow[] = {  20,0,0,105,64,0,106,148,0,106,169,64,106,170,144,106,170,64,106,169,0,106,169,0,105,170,64,20,106,144,0,106,164,0,26,169,0,26,169,0,6,164,0,6,144,0,1,64  };

const uint8_t spaceship_palette[] = {0x0D,0xEF,0x85,0x67,0x89,0xab,0x2D,0xEF};
const uint8_t spaceship_data[] = {0,0,0,1,32,0,0,0,0,0,0,5,56,0,0,0,0,0,0,5,56,0,0,0,0,0,0,5,56,0,0,0,0,24,0,5,56,0,6,0,1,32,0,21,58,0,1,32,5,32,0,21,30,0,1,24,5,32,0,21,30,0,1,24,5,24,0,21,30,0,5,24,217,24,0,21,214,0,5,220,219,22,1,212,202,32,21,236,219,21,17,219,241,33,21,236,6,245,21,219,241,21,214,60,1,21,21,219,241,21,21,32,0,91,21,239,252,21,91,0,0,108,0,26,43,0,108,0 };

uint8_t palette[] = {0x01,0x23,0x45,0x67,0x89,0xab,0xcd,0xef};


uint16_t tileset_palettes[] = {
  0xbad9,0x7d56,0x37df,0x7d35,0xd2ac,0x6705,
};

uint16_t tileset[] = {
0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000, 0x0200,0x0a00,0x2a00,0xaa00,0xaa02,0xaa0a,0xa92a,0xa9aa, 0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xaaa9,0x6a67,0xd9df, 0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xa9aa,0xa76a,0x9fda, 0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xa6a6,0x9d9d,0x7f7f, 0xaaaa,0xaaaa,0xaaaa,0xaaaa,0xaaa9,0x6aa7,0xda9f,0xf67f, 0x0000,0x0000,0x0028,0x002a,0x802a,0xa02a,0xa82a,0xaa2a, 0x0000,0x0000,0x0000,0x0000,0xa000,0xa002,0xa00a,0xa02a, 0x05fc,0x05fc,0x1afc,0xaafc,0x5afd,0x5afd,0xa5fd,0x15fd, 0x0700,0x1f00,0x7e00,0xba01,0xba01,0xde05,0x5705,0x7d1f, 0x5755,0x5755,0x5f55,0x5f55,0x5e55,0x7755,0x5555,0xff55, 0x0100,0x0500,0x0500,0x0500,0x1500,0x5501,0x5515,0x5555, 0x0550,0x1554,0x5555,0x5555,0x5555,0x5555,0x5555,0x5555, 0x0040,0x0050,0x4055,0x5055,0x5455,0x5555,0x5555,0x5555, 0x0200,0x0a00,0x2a00,0xaa00,0xaa02,0xaa0a,0xaa2a,0xaaaa, 0xa9aa,0xa9aa,0x55aa,0x7faa,0x7faa,0x7fa5,0xf5a7,0xf5a7, 0xf7ff,0xffff,0xffff,0xfdff,0xf57f,0xd55f,0x5557,0x5555, 0x7ff6,0xfffd,0xffff,0xfffd,0x7f75,0x5d55,0x5555,0x5555, 0xffff,0xffff,0xffff,0xfff7,0xffd5,0x7f55,0x5f55,0x5755, 0xfdff,0xffff,0xdfff,0x57ff,0x55fd,0x55f5,0x55d5,0x5555, 0xaa02,0xaa02,0xaa00,0x2a00,0x0a00,0x3600,0xfd00,0xff00, 0x00aa,0x00aa,0x00a8,0x00a4,0x009c,0x007f,0xc0ff,0xc0ff, 0x2a00,0x2a00,0x2a00,0x2b00,0x2f00,0x2f00,0xbf00,0xbf00, 0xbf7f,0xba7e,0xfa7e,0x7a7d,0x5e1d,0x5715,0xf575,0xfd7d, 0xee57,0x7657,0x7755,0x5555,0xff55,0xff57,0xee57,0x665f, 0x0000,0x0000,0x0c00,0x3c00,0x3c0c,0x3c0f,0x3c0f,0x3c0f, 0x0500,0x1700,0x1f00,0x5f05,0x5f5f,0xdf7f,0xff7f,0xff7f, 0x0001,0x0001,0x4005,0x4005,0x4005,0x4005,0x5015,0x5015, 0xaaaa,0x95aa,0x9faa,0x5fa9,0xffa9,0xffa9,0xf555,0xf5ff, 0xf5a7,0xf557,0xf5ff,0x55f5,0x55f5,0x55f5,0x5555,0x5555, 0x0000,0x0000,0x0000,0x0000,0x0000,0x0500,0x1500,0x1500, 0x0000,0x0500,0x5500,0x5505,0x5555,0x5555,0x5555,0x5555, 0x0000,0x0000,0x0040,0x0040,0x0050,0x0550,0x5550,0x5505, 0x0000,0x0500,0x5500,0x5505,0x5555,0x5555,0x5555,0x5555, 0x5505,0x5501,0x5541,0x5550,0x5054,0x0555,0x5550,0x5505, 0x00ff,0x0af0,0x82c2,0x004a,0x2a40,0x2a40,0x5555,0x55d5, 0xff00,0x0f80,0x83a2,0xa102,0x0100,0x0100,0x5555,0x5755, 0xfffe,0xbaae,0xbaaf,0x7aad,0x5eb5,0x57d5,0xf55f,0xfd7f, 0xf755,0x5555,0xff57,0xff5f,0xff7f,0xeeff,0xeefd,0xb655, 0x0000,0x5501,0xfd05,0xff07,0xff07,0xff05,0xff01,0x7f00, 0xff7f,0xff7f,0xff7f,0xffff,0xffff,0xffff,0xffff,0xffff, 0x5455,0x5455,0x5015,0x5015,0x5015,0x5455,0x5455,0x5555, 0xf5ff,0x55fd,0x55fd,0x5555,0x5555,0x5555,0x5555,0x5555, 0x5555,0xa55a,0xa96a,0x99da,0x77f6,0xff7d,0xfd5d,0x7555, 0x5500,0x5500,0x5501,0x5501,0x5005,0x0505,0x5510,0x5505, 0x5055,0x0555,0x5550,0x5505,0x5555,0x5555,0x5555,0x5555, 0x5555,0x5555,0x5555,0x5555,0x5055,0x0555,0x5550,0x5505, 0x5055,0x0555,0x5550,0x5500,0x1550,0x1554,0x0555,0x4555, 0x5505,0x5501,0x5541,0x5550,0x5054,0x0055,0x0050,0x0000, 0x0000,0x2800,0x2800,0x3a00,0x3e2a,0x3caa,0x3c0f,0x3c0f, 0xa3c8,0xa820,0x0140,0x5555,0x0ff0,0x0ff0,0x83c2,0xa3ca, 0xbf7f,0xba7e,0xfa7e,0x7a7d,0x5e1d,0x5715,0x5505,0x5501, 0x5555,0x5540,0x5540,0x5690,0x5690,0x5aa5,0x6aa9,0xaaaa, 0x5f15,0x5f1f,0xff5f,0xff7f,0xff7f,0xff7f,0xff5f,0xff07, 0x1554,0x5fd5,0x7ffd,0xffff,0xffff,0xffff,0xffff,0xffff, 0x0300,0x0e00,0x3e00,0xfa00,0xfa03,0xea0f,0xab3e,0xafea, 0xef0a,0xef2e,0xef2e,0xff56,0xaa56,0x5555,0x9a66,0xefbb, 0x80ee,0xe0ee,0xe0ee,0x545a,0x545a,0x5455,0x549a,0xb8ef, 0x5515,0x5515,0x5505,0x5505,0x5001,0x0501,0x5500,0x5505, 0x5055,0x0055,0x4050,0x4005,0x5055,0x5055,0x5455,0x5455, 0x5515,0x5515,0x5505,0x5505,0x5001,0x0501,0x5500,0x5505, 0x5055,0x0055,0x0050,0x0000,0x0000,0x0000,0x0000,0x0000, 0x0000,0x0000,0x4000,0x4005,0x5055,0x5055,0x5455,0x5455, 0x0000,0x0100,0x2900,0x950a,0x55a9,0x5595,0x5055,0x0255, 0x0000,0x0050,0x0055,0x5055,0x0255,0x2a40,0xa90a,0x95aa, 0xdf01,0xba07,0xfa1e,0x7a1d,0x5e1d,0x5715,0xf575,0xfd7d, 0x55aa,0x40aa,0x40aa,0x90aa,0x90aa,0xa5aa,0xa9aa,0xaaaa, 0xaa55,0xaa55,0xaa55,0xaa56,0xaa56,0xaa5a,0xaa6a,0xaaaa, 0x0300,0x0e00,0x3e00,0xfa00,0xfa03,0xea0f,0xaa3e,0xaaea, 0xbeaa,0xfbaa,0xedab,0xb7ae,0x5faa,0x7dad,0xf595,0xd557, 0xefbb,0xff56,0xaa56,0x5555,0x9a59,0xef1a,0xef1a,0x9a05, 0xb8ef,0x545a,0x545a,0x5455,0x9499,0x90ee,0x90ee,0x4099, 0x5515,0x5515,0x5505,0x5505,0x5001,0x0001,0x0000,0x0000, 0x5055,0x0555,0x1550,0x1500,0x0500,0x0500,0x0100,0x0100, 0x5555,0x5555,0x5555,0x5555,0x5055,0x0055,0x0050,0x0000, 0x5055,0x0055,0x0050,0x0000,0x0000,0x0000,0x0000,0x0000, 0x0000,0x0500,0x5500,0x5500,0x1550,0x1554,0x0555,0x4555, 0x0055,0xaa5a,0x80aa,0x05a0,0x5501,0x5501,0x0550,0x4055, 0x5501,0x5501,0x5515,0x5a55,0xa055,0x015a,0x15a0,0x5501, 0xfffe,0xfffe,0xeffa,0xeffa,0xebea,0xebea,0x6a6a,0x6a6a, 0xffef,0xffef,0xfeeb,0xfeeb,0xfaea,0xfaea,0x6a6a,0x6a6a, 0x5555,0x4040,0x4040,0x4040,0x4050,0x4050,0x5155,0x5555, 0xafea,0xbfaa,0xfeaa,0xeaab,0xaaaa,0xaaaa,0xeaff,0xafff, 0xff5f,0xff7f,0xebff,0xabfa,0xafaa,0xffaa,0xfdff,0x55ff, 0xaaa9,0xaa89,0xaaa9,0x50a9,0xa8a9,0xaaa9,0xaaa8,0x2aa8, 0xa8aa,0x88aa,0xa8aa,0x5400,0xa854,0xa814,0xa884,0xa8a0, 0xfe0a,0xfe2e,0xfe2e,0x5555,0x5555,0xfebb,0xfebb,0xfebb, 0x80fe,0xe0fe,0xe0fe,0x5455,0x5455,0xb8ff,0xb8ff,0xb8ff, 0xffff,0xfabf,0xaaab,0xaaaa,0xaaaa,0xaaaa,0xbffa,0xafea, 0xffff,0xfabf,0xaaab,0xaaaa,0xaaaa,0xaaaa,0xaaff,0xaffe, 0xffff,0xfabf,0xaaab,0xaaaa,0xaaaa,0xaaaa,0xffab,0xffea, 0x5055,0x0155,0x2940,0x950a,0x55a9,0x5595,0x5055,0x0255, 0x5555,0x5555,0x5555,0x5055,0x0255,0x2a40,0xa90a,0x95aa, 0x9a69,0x9665,0xa559,0xa559,0xa868,0xa868,0xa8a8,0xa8a8, 0x596a,0x595a,0x6999,0x6995,0xa8a4,0xa8a4,0xa8a8,0xa8a8, 0x1059,0x1059,0x1059,0x1059,0x1059,0x1059,0x1059,0x1059, 0xbfaa,0x55fd,0xfd57,0xfdff,0xfdff,0xf5ff,0x557f,0x5555, 0x5555,0x5555,0x5555,0x5555,0x5555,0x5555,0x5555,0x5555, 0x4aa8,0x52a8,0x54a8,0x0054,0xaaaa,0xaa8a,0xaaaa,0x0000, 0xa8a8,0xa8a9,0xa8a9,0xa815,0xa8a9,0x88a9,0xa8a9,0x0000, 0xfebb,0xfebb,0xfebb,0x5555,0x5555,0xfe2e,0xfe2e,0xa905, 0xb8ff,0xb8ff,0xb8ff,0x5455,0x5455,0xe0fe,0xe0fe,0x40a9, 0x6aa5,0x5fd5,0xf57f,0xffff,0xffff,0xf57f,0xd55f,0x5555, 0x55aa,0x55f5,0xff5f,0xffff,0xffff,0xff7f,0xff55,0x5555, 0xaa56,0x7f55,0xd5ff,0xffff,0xffff,0xf5ff,0x55fd,0x5555, 0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff, 0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff, 0x5555,0x4040,0x4040,0x4140,0x4141,0x5541,0x5555,0x5555, 0x5555,0x5555,0x5555,0x5655,0x5655,0x5a55,0x6a55,0xaa55, 0x5555,0x4040,0x4040,0x4090,0x5090,0x50a5,0x55a9,0x55aa, 0x5555,0x4040,0x4040,0x4040,0x4040,0x4040,0x5151,0x5555, 0x5555,0x5540,0x5540,0x5641,0x5641,0x5a55,0x6a55,0xaa55,
};

uint16_t tileMap[32*25];



void blitTile(uint16_t x,uint8_t y,uint8_t tile, uint8_t attribute) {
  uint16_t* tileAddr = tileset + tile*8;
  uint16_t* paletteAddr = tileset_palettes + (attribute&0x0f);

  blit_image(x,y, 2,8, (uint8_t*) (tileAddr), (uint8_t*) (paletteAddr), BLITCON_BLIT_4,attribute &0xc0);
}
void renderMode1(void* tileData, void* mapData, void* paletteData, uint16_t map_width_in_bytes,  uint8_t shiftX, uint8_t shiftY) {
  
    PORT_MODE1_TILE_DATA = (uint16_t) tileData;
    PORT_MODE1_MAP_DATA = (uint16_t) mapData;
    PORT_MODE1_PALETTE_DATA = (uint16_t) paletteData;
    PORT_MODE1_LINE_INCREMENT= map_width_in_bytes >> 1;
    PORT_MODE1_SIZE = 0xFC;
    setPixelCursor(shiftX,shiftY);
    PORT_BLIT_CONTROL=BLITCON_MODE_1;
}

void waitForNewFrame() {
  uint8_t ticksOnEntry = PORT_TICK;
  while(ticksOnEntry==PORT_TICK);
}

void setMap() {
  uint16_t* walk = tileMap;

  for (uint16_t ty=0; ty<25; ty++){
    for (uint16_t tx =0 ;tx < 32; tx++) {
      *walk++=(tx%14)+(ty%8)*14;
    }
  }
}

#define panel_top 140
#define panel_left 0

#define tile_palette_top  panel_top+1
#define tile_palette_left panel_left+3

#define tileset_width 14
#define tileset_height 8

uint8_t tileset_colours [tileset_width * tileset_height / 2]; // 4 bits per colour id.


int8_t palette_offset_x = 0;
int8_t palette_offset_y = 0;

uint8_t tile_a_x = 1;
uint8_t tile_a_y = 0;

uint8_t erase_tile = 0;

uint8_t get_palette_tile_color(uint8_t tileid) {
  if (tileid > (tileset_width*tileset_height) ) return 0;
  uint8_t result = tileset_colours[tileid >>1];
  if (tileid & 1) result>>=4;
  return result & 0x0f;
}

void set_palette_tile_color(uint8_t tileid, uint8_t color) {
  if (tileid > (tileset_width*tileset_height) ) return;
  uint8_t mask = 0x0f;
  color&=mask;
  if (tileid & 1) {
    mask<<=4;
    color<<=4;
  }
  tileset_colours[tileid>>1] = (tileset_colours[tileid>>1] & ~mask) | color;
}


int16_t screen_to_palette_tile(int16_t x, int16_t y) {
  x-=tile_palette_left-1;
  y-=tile_palette_top-1;
  int16_t tile_x = (x/9);
  int16_t tile_y = (y/9);

  if (tile_x<0 || tile_y <0 || tile_x>=26 || tile_y >=4) return -1;

  return tile_x <<8 | tile_y;
}

uint8_t palette_to_tileid(uint8_t x, uint8_t y) {
  uint16_t tilex= (palette_offset_x +x) % tileset_width;
  uint8_t halfskip= 0;//((palette_offset_x +x) /tileset_width) * (tileset_height/2);
  uint16_t tiley= ((palette_offset_y + y +halfskip)) % tileset_height  ;
  return tilex+tiley*tileset_width;
}


void blitTilePalette( ) {
  serial_fill_rect(panel_left,panel_top,240,35,1);

  serial_fill_rect(tile_palette_left+(tile_a_x*9)-1,tile_palette_top+(tile_a_y*9)-1,10,10,7);

  for (uint8_t ty=0; ty<4; ty++){
    for (uint8_t tx =0 ;tx < 26; tx++) {
      uint8_t tileid = palette_to_tileid(tx,ty);
      uint8_t colour = get_palette_tile_color(tileid);
      if (tileid==erase_tile) serial_fill_rect(tile_palette_left+tx*9-1,tile_palette_top+ty*9-1,10,10,3);
      blitTile(tile_palette_left+tx*9,tile_palette_top+ty*9,tileid,colour);
    }
  }
}



void translateTilePalette(uint8_t dx, uint8_t dy) {
  palette_offset_x += dx;
  palette_offset_y += dy;

  if (palette_offset_x >= tileset_width) {
	palette_offset_x-= tileset_width;
	palette_offset_y += tileset_height /2;
  }

  if (palette_offset_x < 0) {
	palette_offset_x+= tileset_width;
	palette_offset_y -= tileset_height /2;
  }

  if (palette_offset_y >= tileset_height) {
	palette_offset_y-=tileset_height;
  }

  if (palette_offset_y < 0) {
	palette_offset_y+=tileset_height;
  }
}

int main (void)
{
  SP=0xffff;


  uint16_t shipX =150;

  setMap();


  uint8_t lastTime = 5;
  uint8_t mode = 0x74;

    tileMap[100]=0x0001;


    for (;;)  {
      waitForNewFrame();
      //read the mouse location
      uint16_t mouse_x=PORT_MOUSE_X;
      uint16_t mouse_y=PORT_MOUSE_Y;

      uint16_t tile_x = mouse_x / 8;
      uint16_t tile_y = mouse_y / 8;

      uint16_t mtile = tile_y*32+tile_x;
      int16_t ptile = screen_to_palette_tile(mouse_x,mouse_y);
      uint8_t tileid=palette_to_tileid(ptile>>8,ptile&0xff);

      uint8_t ch = PORT_KEY_BUFFER;
      switch (ch) {
        case 'a':
            translateTilePalette(-1,0);
          break;
        case 'd':
            translateTilePalette(1,0);
          break;
        case 'w':
            translateTilePalette(0,-1);
          break;
        case 's':
           translateTilePalette(0,1);
          break;
        case 'z':
        if (ptile!=-1) {
          set_palette_tile_color(tileid,get_palette_tile_color(tileid)-1);
        } else {
            tileMap[mtile]= (tileMap[mtile] & 0xf0ff) | ((tileMap[mtile] - 0x0100)  & 0x0f00);
          }
          break;
        case 'x':
          if (ptile!=-1) {
            set_palette_tile_color(tileid,get_palette_tile_color(tileid)-1);
          } else {
            tileMap[mtile]= (tileMap[mtile] & 0xf0ff) | ((tileMap[mtile] + 0x0100)  & 0x0f00) ;
          }
      }
      uint16_t buttons = PORT_BUTTONS;

      if (mouse_y > panel_top) {
        if (buttons & 0x2000) {
  		      if (ptile != -1) {
  			       tile_a_x=ptile >>8;
  			       tile_a_y=ptile &0xff;
  		      }
  	    }
        if (buttons & 0x8000) {
    		  if (ptile != -1) {
            erase_tile=palette_to_tileid(ptile >>8,ptile &0xff);
    		  }
  	    }
      } else {
        if (buttons & 0x2000) {
          uint8_t a_id = palette_to_tileid(tile_a_x,tile_a_y);
          tileMap[mtile]=a_id | (get_palette_tile_color(a_id)<<8);
        }
        if (buttons & 0x8000) {
          uint8_t a_id = erase_tile;
          tileMap[mtile]=a_id | (get_palette_tile_color(a_id)<<8);
        }

      }

      uint8_t now = PORT_TIME;
      uint8_t nextStep = now>lastTime;
      lastTime=now;

      if (nextStep) {
        mode+=1;
        if (mode > 0x74) mode=0x71;
      }

      renderMode1(tileset,tileMap,tileset_palettes,32*2,0,0);
      blitTilePalette();
/*
      for (uint16_t b=0;b <16; b++) {
          serial_fill_rect(100+b*6,30,5,5,(buttons & (1<<b))?2:1);
      }
      //write a grid of rectangles showing the serial pixel output palette
      for (uint16_t ty=0;ty <4; ty++) {
        for (uint16_t tx=0;tx <4; tx++) {
          serial_fill_rect(200+tx*6,20+ty*6,5,5,(ty<<2)+tx);
        }
      }

 */

      blit_image(mouse_x-1,mouse_y-1,3,16,arrow,arrowPal,BLITCON_BLIT_4,0);
      serial_fill_rect(mouse_x,0,1,195,1);
      serial_fill_rect(0,mouse_y,255,1,1);

      //put frame onscreen in lowres
      PORT_DISPLAY_SHIFT_X=0;
      PORT_DISPLAY_SHIFT_Y=0;
      
      PORT_DISPLAY_CONTROL=DC_SHOW_DISPLAY;
    }
    return (0);
}
