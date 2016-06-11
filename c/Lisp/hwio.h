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

#define PORT_BLIT_IMAGE_START  _SFR_IO16(0x28)
#define PORT_BLIT_BYTES_WIDE  _SFR_IO8(0x2A)
#define PORT_BLIT_HEIGHT  _SFR_IO8(0x2B)
#define PORT_BLIT_LINE_INCREMENT  _SFR_IO8(0x2C)
#define PORT_BLIT_PALETTE_START  _SFR_IO16(0x2D)
#define PORT_BLIT_FLAGS  _SFR_IO8(0x2F)

#define PORT_BUTTONS  _SFR_IO16(0x28)
#define PORT_BUTTONSA  _SFR_IO8(0x28)
#define PORT_BUTTONSB  _SFR_IO8(0x29)
#define PORT_MOUSEX  _SFR_IO8(0x2A)
#define PORT_MOUSEY  _SFR_IO8(0x2B)
#define PORT_TICK  _SFR_IO8(0x2C)
#define PORT_TIME  _SFR_IO8(0x2D)
#define PORT_CONSOLE  _SFR_IO8(0x2E)

;

void setPixelCursor(uint16_t x,uint16_t y);
void serial_fillRect(uint16_t x,uint16_t y, uint8_t w, uint8_t h,uint8_t color);


void writeProgMemImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow);

void writeRamImage(uint16_t x,uint16_t y, uint8_t w, uint8_t h, const uint8_t* progmem_data, uint8_t bytesPerRow);

void renderMode0(uint16_t dataStart, uint8_t width_in_cells, uint8_t pageHeight );
