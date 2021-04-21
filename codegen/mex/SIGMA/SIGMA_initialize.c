/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SIGMA_initialize.c
 *
 * Code generation for function 'SIGMA_initialize'
 *
 */

/* Include files */
#include "SIGMA_initialize.h"
#include "SIGMA_data.h"
#include "_coder_SIGMA_mex.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void SIGMA_initialize(void)
{
  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (SIGMA_initialize.c) */
