#ifndef CALCULATOR_ENGINE_H
#define CALCULATOR_ENGINE_H

#include <stdint.h>

typedef enum
{
  CALC_ANGLE_DEG = 0,
  CALC_ANGLE_RAD
} calc_angle_unit_t;

typedef struct
{
  float real;
  float imag;
} calc_complex_t;

typedef enum
{
  CALC_OK = 0,
  CALC_SYNTAX,
  CALC_DOMAIN,
  CALC_DIV_ZERO
} calc_status_t;

calc_status_t calculator_evaluate(const char *expression,
                                  calc_angle_unit_t angle_unit,
                                  uint8_t allow_complex,
                                  calc_complex_t answer,
                                  calc_complex_t *result);

calc_status_t calculator_solve_linear(float a, float b, float *x);

#endif
