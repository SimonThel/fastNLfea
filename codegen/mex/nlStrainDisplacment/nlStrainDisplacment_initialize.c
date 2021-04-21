/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nlStrainDisplacment_initialize.c
 *
 * Code generation for function 'nlStrainDisplacment_initialize'
 *
 */

/* Include files */
#include "nlStrainDisplacment_initialize.h"
#include "_coder_nlStrainDisplacment_mex.h"
#include "nlStrainDisplacment_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void nlStrainDisplacment_initialize(void)
{
  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (nlStrainDisplacment_initialize.c) */
