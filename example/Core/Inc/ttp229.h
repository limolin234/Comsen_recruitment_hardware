#ifndef TTP229_H
#define TTP229_H

#include <stdint.h>

/* Bits 0..29 correspond to the physical keys T0..T29. */
uint32_t ttp229_read_physical(void);

#endif
