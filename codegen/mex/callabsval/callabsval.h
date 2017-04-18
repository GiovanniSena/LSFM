/*
 * callabsval.h
 *
 * Code generation for function 'callabsval'
 *
 */

#ifndef __CALLABSVAL_H__
#define __CALLABSVAL_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "callabsval_types.h"

/* Function Declarations */
extern real_T callabsval(const emlrtStack *sp, real_T input);

#ifdef __WATCOMC__

#pragma aux callabsval value [8087];

#endif
#endif

/* End of code generation (callabsval.h) */
