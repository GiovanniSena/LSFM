/* 
 * File: _coder_absval_api.h 
 *  
 * MATLAB Coder version            : 2.6 
 * C/C++ source code generated on  : 12-Feb-2015 10:56:02 
 */

#ifndef ___CODER_ABSVAL_API_H__
#define ___CODER_ABSVAL_API_H__
/* Include files */
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Function Declarations */
extern void absval_initialize(emlrtContext *aContext);
extern void absval_terminate(void);
extern void absval_atexit(void);
extern void absval_api(const mxArray * const prhs[1], const mxArray *plhs[1]);
extern double absval(double u);
extern void absval_xil_terminate(void);

#endif
/* 
 * File trailer for _coder_absval_api.h 
 *  
 * [EOF] 
 */
