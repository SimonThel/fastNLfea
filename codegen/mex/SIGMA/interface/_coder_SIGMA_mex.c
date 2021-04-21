/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_SIGMA_mex.c
 *
 * Code generation for function '_coder_SIGMA_mex'
 *
 */

/* Include files */
#include "_coder_SIGMA_mex.h"
#include "SIGMA_data.h"
#include "SIGMA_initialize.h"
#include "SIGMA_terminate.h"
#include "_coder_SIGMA_api.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void SIGMA_mexFunction(int32_T nlhs, mxArray *plhs[1], int32_T nrhs, const
  mxArray *prhs[2])
{
  const mxArray *outputs[1];

  /* Check for proper number of arguments. */
  if (nrhs != 2) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 2, 4, 5, "SIGMA");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 5, "SIGMA");
  }

  /* Call the function. */
  SIGMA_api(prhs, outputs);

  /* Copy over outputs to the caller. */
  emlrtReturnArrays(1, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(&SIGMA_atexit);

  /* Module initialization. */
  SIGMA_initialize();

  /* Dispatch the entry-point. */
  SIGMA_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  SIGMA_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_SIGMA_mex.c) */
