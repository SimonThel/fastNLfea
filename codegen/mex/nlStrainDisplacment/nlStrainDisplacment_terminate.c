/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nlStrainDisplacment_terminate.c
 *
 * Code generation for function 'nlStrainDisplacment_terminate'
 *
 */

/* Include files */
#include "nlStrainDisplacment_terminate.h"
#include "_coder_nlStrainDisplacment_mex.h"
#include "nlStrainDisplacment_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void nlStrainDisplacment_atexit(void)
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void nlStrainDisplacment_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (nlStrainDisplacment_terminate.c) */
