
typedef struct {
  uint16_t* start;
  uint8_t width;
  uint8_t height;
} Mode0Page_t;

typedef struct {
    Mode0Page_t cells;
    uint16_t* text_origin;
    uint8_t width;
    uint8_t height;
    uint8_t cursor_x;
    uint8_t cursor_y;
    uint8_t attribute;
} TextPage_t;

void initTextPage(TextPage_t* result, uint16_t base, uint8_t w, uint8_t h, uint8_t margin_x, uint8_t margin_y);

TextPage_t makeTextPage(uint16_t base, uint8_t w, uint8_t h, uint8_t margin_x, uint8_t margin_y);

void write_char_mode0(uint16_t* top_left_cell, uint8_t ch, uint8_t attribute, uint8_t next_line);

void write_char_xy(uint8_t x, uint8_t y, uint8_t ch, uint8_t attribute, TextPage_t* page);

void write_ramstring_xy(uint8_t x, uint8_t y,const char* s, uint8_t attribute,  TextPage_t* page);

void write_romstring_xy(uint8_t x, uint8_t y,const char* s, uint8_t attribute,  TextPage_t* page );

void write_char(uint8_t ch, TextPage_t* page);

void write_romstring(const char* s, TextPage_t* page);

void write_ramstring(const char* s, TextPage_t* page);

void move_cells(Mode0Page_t* page, uint8_t src_x, uint8_t src_y, uint8_t dst_x, uint8_t dst_y, uint8_t w, uint8_t h);

void move_cells_raw(uint16_t* src, uint16_t* dst, uint8_t w, uint8_t h, uint8_t cells_per_line);

void scroll_text_page(TextPage_t* page);
