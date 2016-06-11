#include "hwio.h"

void setPixelCursor(uint16_t x,uint16_t y) {
  uint32_t addr = ((uint32_t)(y)) * 512 + x ;

  PORT_SERIAL_PIXEL_ADDRESS_H = (addr >> 16);
  PORT_SERIAL_PIXEL_ADDRESS_M =  (addr >> 8);
  PORT_SERIAL_PIXEL_ADDRESS_L =  (addr >> 0);
}


void serial_fillRect(uint16_t x,uint16_t y, uint8_t w, uint8_t h,uint8_t color) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);
    for (uint8_t tx=0;tx<w;tx++) {
        PORT_SERIAL_PIXEL_SET = color;
    }
  }
}

void writeProgMemImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow) {
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

void writeRamImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);

    const uint8_t* walk = progmem_data;
    progmem_data+=bytesPerRow;
    for (uint8_t tx=0;tx<w;tx++) {
       uint8_t pixel = *walk;
       walk+=1;
       if (pixel == 0) PORT_SERIAL_PIXEL_ADD=0; else PORT_SERIAL_PIXEL_SET = pixel;
    }
  }
}

void renderMode0(uint16_t dataStart, uint8_t width_in_cells, uint8_t pageHeight ) {
    PORT_MODE0_PIXEL_DISPLAY_START = dataStart;
    PORT_MODE0_COLOR_DISPLAY_START = (dataStart+1);
    PORT_MODE0_PIXEL_INCREMENT=2;
    PORT_MODE0_COLOR_INCREMENT=2;
    PORT_MODE0_PIXEL_LINE_INCREMENT=width_in_cells >> 2; //   width_in_cells*2 >> 3
    PORT_MODE0_COLOR_LINE_INCREMENT=width_in_cells >> 2;
    PORT_DISPLAY_CONTROL=0x80;
}
