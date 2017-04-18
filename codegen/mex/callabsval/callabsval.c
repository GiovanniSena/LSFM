/*
 * callabsval.c
 *
 * Code generation for function 'callabsval'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "callabsval.h"

/* Custom Source Code */
#include "absval.h"

/* Function Definitions */
real_T callabsval(const emlrtStack *sp, real_T input)
{
  real_T y;
  (void)sp;

  /*  Check the target. Do not use coder.ceval if callabsval is */
  /*  executing in MATLAB */
  /*  Executing in the generated code.  */
  /*  Call the initialize function before calling the  */
  /*  C function for the first time */
  absval_initialize();

  /*  Call the generated C library function absval */
  y = absval(input);

  /*  Call the terminate function after */
  /*  calling the C function for the last time */
  absval_terminate();
  return y;
}

/* End of code generation (callabsval.c) */
