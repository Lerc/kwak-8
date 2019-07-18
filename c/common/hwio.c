#include "hwio.h"

void setPixelCursor(uint16_t x,uint16_t y) {
  uint32_t addr = ((uint32_t)(y)) * 512 + x ;

  PORT_SERIAL_PIXEL_ADDRESS_H = (addr >> 16);
  PORT_SERIAL_PIXEL_ADDRESS_M =  (addr >> 8);
  PORT_SERIAL_PIXEL_ADDRESS_L =  (addr >> 0);
}


void serial_fill_rect(uint16_t x,uint16_t y, uint8_t w, uint8_t h,uint8_t color) {
  uint16_t bottom = y+h;
  while (y < bottom) {
    setPixelCursor(x,y++);
    for (uint8_t tx=0;tx<w;tx++) {
        PORT_SERIAL_PIXEL_ADD = color;
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
       if (pixel == 0) PORT_SERIAL_PIXEL_SUB=pixel; else PORT_SERIAL_PIXEL_ADD = pixel;
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
       if (pixel == 0) PORT_SERIAL_PIXEL_SUB=pixel; else PORT_SERIAL_PIXEL_ADD = pixel;
    }
  }
}

void renderMode0(uint8_t x, uint8_t y, uint16_t dataStart, uint8_t width_in_cells, uint8_t height_in_cells ) {
  setPixelCursor(x,y);

  PORT_MODE0_IMAGE_DATA = dataStart;
  PORT_MODE0_CELLS_WIDE=width_in_cells;
  PORT_MODE0_CELLS_HIGH=height_in_cells;
  PORT_MODE0_LINE_INCREMENT=width_in_cells;
  PORT_BLIT_CONTROL=BLITCON_MODE_0;
}

void blit_image(uint16_t x, uint8_t y, uint8_t width_in_bytes, uint8_t height, const  uint8_t* image,const uint8_t* palette_table, uint8_t mode, uint8_t flags) {
  PORT_BLIT_IMAGE_START  = (uint16_t)(image);
  PORT_BLIT_BYTES_WIDE  = width_in_bytes;
  PORT_BLIT_PIXELS_HIGH = height;
  PORT_BLIT_LINE_INCREMENT = width_in_bytes;
  PORT_BLIT_PALETTE_START = (uint16_t)(palette_table);

  PORT_BLIT_FLAGS  = flags;

  setPixelCursor(x,y);

  PORT_BLIT_CONTROL = mode;
}

void wait_frame() {
  uint8_t ticksOnEntry = PORT_TICK;
  while(ticksOnEntry==PORT_TICK);
}
