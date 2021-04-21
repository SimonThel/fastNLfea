/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_nlStrainDisplacment_mex.c
 *
 * Code generation for function '_coder_nlStrainDisplacment_mex'
 *
 */

/* Include files */
#include "_coder_nlStrainDisplacment_mex.h"
#include "_coder_nlStrainDisplacment_api.h"
#include "nlStrainDisplacment_data.h"
#include "nlStrainDisplacment_initialize.h"
#include "nlStrainDisplacment_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&nlStrainDisplacment_atexit);

  /* Module initialization. */
  nlStrainDisplacment_initialize();

  /* Dispatch the entry-point. */
  nlStrainDisplacment_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  nlStrainDisplacment_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

void nlStrainDisplacment_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T
  nrhs, const mxArray *prhs[2])
{
  const mxArray *outputs[1];

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 2, 4, 19, "nlStrainDisplacment");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 19,
                        "nlStrainDisplacment");
  }

  /* Call the function. */
  nlStrainDisplacment_api(prhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

/* End of code generation (_coder_nlStrainDisplacment_mex.c) */
