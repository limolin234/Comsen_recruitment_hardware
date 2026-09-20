#ifndef TOUCH_FILTER_H
#define TOUCH_FILTER_H

#include <stdint.h>

typedef struct
{
  uint8_t counters[30];
  uint32_t stable_bitmap;
  uint32_t active_bitmap;
  uint8_t wait_all_released;
} touch_filter_t;

void touch_filter_init(touch_filter_t *filter);

/* Returns either zero or one physical key bit. Call every 10 ms. */
uint32_t touch_filter_update(touch_filter_t *filter, uint32_t raw_bitmap);

#endif
