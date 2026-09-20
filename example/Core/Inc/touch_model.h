#ifndef TOUCH_MODEL_H
#define TOUCH_MODEL_H

#include <stdint.h>

#define TOUCH_KEY_COUNT 30U
#define TOUCH_TRAINING_SAMPLES 30U

typedef struct
{
  uint8_t activation_count[TOUCH_KEY_COUNT][TOUCH_KEY_COUNT];
  uint8_t ready;
} touch_model_t;

void touch_model_reset(touch_model_t *model);
void touch_model_load_default(touch_model_t *model);
void touch_model_add_sample(touch_model_t *model, uint8_t intended_key,
                            uint32_t observed_bitmap);
uint32_t touch_model_classify(const touch_model_t *model,
                              uint32_t observed_bitmap);

#endif
