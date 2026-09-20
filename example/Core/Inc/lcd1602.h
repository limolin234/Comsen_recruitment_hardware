#ifndef LCD1602_H
#define LCD1602_H

#include <stdint.h>

#define LCD1602_CHAR_ANGLE 1U

void lcd1602_init(void);
void lcd1602_write_lines(const char line1[16], const char line2[16]);
void lcd1602_write_frame(const char line1[16], const char line2[16],
                         uint8_t cursor_enabled, uint8_t cursor_row,
                         uint8_t cursor_column);

#endif
