#include "hwio.h"
#include "simplegfx.h"

#define max(a,b)((a>b)?a:b)

const uint8_t font[96][6] PROGMEM = {
  {00,00,00,00,00,00}				,//  Space
  {144,0,146,0,130,0}				,//  !
  {144,144,0,0,0,0}						,//  quote
  {128,128,151,151,23,23}			,//  #
  {116,24,6,145,39,1}		,//  $
  {88,74,148,128,1,3}			,//  %
  {78,8,86,168,49,10}		,//  &
  {0,72,0,0,0,0}						,//  singlequote
  {160,1,146,0,4,8}				,// (
  {4,136,0,146,32,1}					,// )
  {136,80,60,24,10,17}			,// *
  {0,64,48,121,0,1}				,// +
  {0,0,128,0,1,0}						,// ,
  {0,0,56,24,0,0}						,// -
  {0,0,128,0,2,0}							,// .
  {0,74,164,0,10,0}					,// /
  {148,145,146,146,4,1}			,// 0
  {32,73,0,73,4,3}			,// 1
  {14,145,84,1,7,3}			,// 2
  {6,145,4,145,6,1}			,// 3
  {160,73,57,89,0,1}			,// 4
  {150,3,6,145,6,1}			,//	5
  {148,1,150,145,4,1}			,// 6
  {6,147,160,1,2,0}				,// 7
  {148,145,148,145,4,1}			,// 8
  {148,145,132,147,4,1}		,// 9
  {0,64,0,64,0,0}							,// :
  {0,64,0,64,4,0}						,// ;
  {80,4,136,0,0,0}					,// <
  {0,0,6,3,6,3}				,// =
  {136,0,84,0,0,0}					,// >
  {14,145,32,1,4,0}					,// ?
  {84,209,109,82,34,8} 	,// @
  {78,145,79,147,1,2} 		,// A
  {79,145,79,145,7,1}		,// B
  {78,17,73,128,6,1}			,// C
  {79,136,73,82,7,0}     ,// D
  {79,3,79,0,7,3}      ,// E
  {79,3,79,0,1,0}					,// F
  {78,3,77,147,6,3}   ,// G
  {73,146,79,147,1,2}		,// H
  {151,0,146,0,7,0}      ,// I
  {6,75,64,73,6,0}				,// J
  {73,82,79,136,1,2}			,// K
  {73,0,73,0,7,3}				,// L
  {217,218,109,146,1,2}		,// M
  {217,146,109,210,1,3}		,// N
  {78,145,73,146,6,1}		,// O
  {79,145,79,1,1,0}				,// P
  {78,145,105,210,16,17}		,// Q
  {79,145,79,137,1,2}		,// R
  {78,17,70,145,6,1}		,// S
  {6,79,0,73,0,1}			,// T
  {73,146,73,146,6,1}		,// U
  {73,146,145,74,4,0}			,// V
  {73,146,173,82,2,1}		,// W
  {137,82,84,136,1,2}			,// X
  {73,146,162,1,1,0}     ,// Y
  {7,83,84,0,7,3}     ,// Z
  {79,0,73,0,57,0}				,// [
  {137,0,36,64,0,18}					,// backslash
  {6,73,0,73,48,9}				,// ]
  {84,136,0,0,0,0}					,// ^
  {0,0,0,0,56,56}					,// _
  {32,64,0,0,0,0}					,// `
  {48,136,78,147,6,5}			,// a
  {73,0,79,145,7,1}				,// b
  {112,136,73,128,6,1}		,// c
  {0,146,78,147,6,3}			,// d
  {112,136,79,131,6,1}		,// e
  {148,1,151,0,2,0}				,// f
  {112,152,49,154,32,10}	,// g
  {73,0,79,145,1,2}				,// h
  {0,65,0,73,0,1}					,// i
  {0,65,0,73,49,1}				,// j
  {73,64,111,64,1,2}			,// k
  {0,73,0,73,0,17}				,// l
  {208,200,109,146,1,2}		,// m
  {120,136,73,146,1,2}		,// n
  {112,136,73,146,6,1}		,// o
  {120,136,121,10,9,0}			,// p
  {112,72,49,73,0,137}		,// q
  {232,8,73,0,1,0}				,// r
  {112,8,70,145,6,1}		,// s
  {186,8,146,0,2,0}			,// t
  {72,144,73,146,6,3}			,// u
  {72,144,137,82,4,0}			,// v
  {72,144,169,82,2,1}			,// w
  {136,80,164,64,1,2}			,// x
  {72,144,34,154,48,1}		,// y
  {56,152,160,1,7,3}			,// z
  {148,1,145,0,4,1}				,// {
  {0,73,0,73,0,73}				,// |
  {6,72,0,74,6,0}					,// }
  {112,224,0,0,0,0}				 // ~
};
void move_cells_raw(uint16_t* src, uint16_t* dst, uint8_t w, uint8_t h, uint8_t cells_per_line){
  int16_t next_line = cells_per_line - w;
  int8_t direction = 1;
  if (src < dst) {
     next_line = -next_line;
     direction = -direction;
     src += (h-1)*cells_per_line+(w-1);
     dst += (h-1)*cells_per_line+(w-1);
  }

  for (uint8_t ty=0; ty<h; ty++) {
    for (uint8_t tx=0; tx<w; tx++) {
      *dst=*src;
      dst+=direction;
      src+=direction;
    }
    src+=next_line;
    dst+=next_line;
  }
}

void move_cells(Mode0Page_t* page, uint8_t src_x, uint8_t src_y, uint8_t dst_x, uint8_t dst_y, uint8_t w, uint8_t h) {
  int8_t overflow_x = (max(src_x,dst_x)+w)- page->width;
  if (overflow_x > 0) w-=overflow_x;

  int8_t overflow_y = (max(src_y,dst_y)+h)- page->height;
  if (overflow_y > 0) h-=overflow_y;

  uint16_t src_offset = src_y*page->width + src_x;
  uint16_t dst_offset = dst_y*page->width + dst_x;

  move_cells_raw(page->start + src_offset, page->start + dst_offset,w,h,page->width);

}

void initTextPage(TextPage_t* result, uint16_t base, uint8_t w, uint8_t h, uint8_t margin_x, uint8_t margin_y) {
  uint8_t cells_wide = w*2+margin_x;
  if ( (cells_wide & 3) != 0)  cells_wide= (cells_wide & ~3)+4;

  result->cells.start=(uint16_t*) base;
  result->cells.width=cells_wide ;
  result->cells.height= h*3+margin_y;
  result->text_origin= (uint16_t*) ( base+ (result->cells.width * margin_y + margin_x) * 2);
  result->width=w;
  result->height=h;
  result->cursor_x=0;
  result->cursor_y=0;
  result->attribute=0x02;

}

TextPage_t makeTextPage(uint16_t base, uint8_t w, uint8_t h, uint8_t margin_x, uint8_t margin_y) {
    TextPage_t result;
    initTextPage(&result,base,w,h,margin_x,margin_y);
    return result;
}

void scroll_text_page(TextPage_t* page) {
    move_cells_raw(page->text_origin+page->cells.width*3,page->text_origin,page->width*2,(page->height-1)*3,page->cells.width);
    uint16_t* line1=page->text_origin+page->cells.width*3*(page->height-1);
    uint16_t* line2=line1+page->cells.width;
    uint16_t* line3=line2+page->cells.width;

    for (uint8_t i = 0; i<page->width*2;i++) {
      *line1++=0;
      *line2++=0;
      *line3++=0;
    }
}

void write_char_mode0(uint16_t* top_left_cell, uint8_t ch, uint8_t attribute, uint8_t next_line) {
  uint8_t* cell = (uint8_t*) top_left_cell;
  if (ch < 32) return;
  
  uint8_t character = ch-32;
  *(cell + 0)=pgm_read_byte(&font[character][0]);
  *(cell + 1)=attribute;
  *(cell + 2)=pgm_read_byte(&font[character][1]);
  *(cell + 3)=attribute;
  cell+= next_line*2;
  *(cell + 0)=pgm_read_byte(&font[character][2]);
  *(cell + 1)=attribute;
  *(cell + 2)=pgm_read_byte(&font[character][3]);
  *(cell + 3)=attribute;
  cell+= next_line*2;
  *(cell + 0)=pgm_read_byte(&font[character][4]);
  *(cell + 1)=attribute;
  *(cell + 2)=pgm_read_byte(&font[character][5]);
  *(cell + 3)=attribute;


}

void write_char_xy(uint8_t x, uint8_t y, uint8_t ch, uint8_t attribute, TextPage_t* page) {
   if ( (x >= page->width) || (y >= page->height) ) return;
   uint16_t* cell = page->text_origin;
   cell+= (y * page->cells.width*3  + x*2);
   write_char_mode0(cell,ch,attribute,page->cells.width);
}



void write_romstring_xy(uint8_t x, uint8_t y,const char* s, uint8_t attribute,  TextPage_t* page){
  uint8_t ch;
  while (ch = pgm_read_byte(s)) {
    write_char_xy(x++,y,ch,attribute,page);
    s+=1;
  }
}

void write_ramstring_xy(uint8_t x, uint8_t y,const char* s, uint8_t attribute,  TextPage_t* page ){
  uint8_t ch;
  while (ch = *s) {
  write_char_xy(x++,y,ch,attribute,page);
    s+=1;
  }
}

void write_char(uint8_t ch, TextPage_t* page) {
  write_char_xy(page->cursor_x,page->cursor_y,ch,page->attribute,page);
  page->cursor_x+=1;
  if ( (ch==10) || (page->cursor_x >= page->width) ) {
    page->cursor_x=0;
    page->cursor_y+=1;
    if (page->cursor_y >= page->height) {
      scroll_text_page(page);
      page->cursor_y=page->height-1;
    }
  }
}

void write_romstring(const char* s, TextPage_t* page) {
  uint8_t ch;
  while (ch = pgm_read_byte(s)) {
    write_char(ch,page);
    s+=1;
  }
}

void write_ramstring(const char* s, TextPage_t* page) {
  uint8_t ch;
  while (ch = *s){
    write_char(ch,page);
    s+=1;
  }
}


