/*
 * callabsval_terminate.c
 *
 * Code generation for function 'callabsval_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "callabsval.h"
#include "callabsval_terminate.h"

/* Custom Source Code */
#include "absval.h"

/* Function Definitions */
void callabsval_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void callabsval_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (callabsval_terminate.c) */
