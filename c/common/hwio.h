#include <inttypes.h>
#include <avr/io.h>
#include <avr/pgmspace.h>


#define PORT_DISPLAY_CONTROL _SFR_IO8(0x08)
#define PORT_DISPLAY_SHIFT_X  _SFR_IO8(0x09)
#define PORT_DISPLAY_SHIFT_Y  _SFR_IO8(0x0a)
#define PORT_BLIT_CONTROL _SFR_IO8(0x0b)
#define PORT_VOICE_SELECT  _SFR_IO8(0x0c)
#define PORT_MASTER_VOLUME  _SFR_IO8(0x0d)

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

#define PORT_MODE1_MAP_DATA  _SFR_IO16(0x28)
#define PORT_MODE1_SIZE        _SFR_IO8(0x2A)
#define PORT_MODE1_LINE_INCREMENT  _SFR_IO8(0x2B)
#define PORT_MODE1_PALETTE_DATA  _SFR_IO16(0x2C)
#define PORT_MODE1_TILE_DATA  _SFR_IO16(0x2E)


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

#define PORT_VOICE_FREQ  _SFR_IO16(0x30)
#define PORT_VOICE_FREQ_L  _SFR_IO8(0x30)
#define PORT_VOICE_FREQ_H  _SFR_IO8(0x31)
#define PORT_VOICE_VOLUME  _SFR_IO8(0x32)
#define PORT_VOICE_WAVE_SHAPE  _SFR_IO8(0x33)
#define PORT_VOICE_BEND_WAVE  _SFR_IO8(0x34)
#define PORT_VOICE_BEND_AMPLITUDE  _SFR_IO8(0x35)
#define PORT_VOICE_NOISE_HOLD  _SFR_IO8(0x36)
#define PORT_VOICE_ATTACK_RELEASE  _SFR_IO8(0x37)

;

void setPixelCursor(uint16_t x,uint16_t y);

void serial_fill_rect(uint16_t x,uint16_t y, uint8_t w, uint8_t h,uint8_t color);

void writeProgMemImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow);

void writeRamImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow);

void renderMode0(uint8_t x, uint8_t y, uint16_t dataStart, uint8_t width_in_cells, uint8_t height_in_cells );

void blit_image(uint16_t x, uint8_t y, uint8_t width_in_bytes, uint8_t height, const  uint8_t* image,const uint8_t* palette_table, uint8_t mode, uint8_t flags);

void wait_frame();

