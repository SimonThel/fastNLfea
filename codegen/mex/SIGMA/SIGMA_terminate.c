/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SIGMA_terminate.c
 *
 * Code generation for function 'SIGMA_terminate'
 *
 */

/* Include files */
#include "SIGMA_terminate.h"
#include "SIGMA_data.h"
#include "_coder_SIGMA_mex.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void SIGMA_atexit(void)
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void SIGMA_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (SIGMA_terminate.c) */
