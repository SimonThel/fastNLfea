/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_SIGMA_api.c
 *
 * Code generation for function '_coder_SIGMA_api'
 *
 */

/* Include files */
#include "_coder_SIGMA_api.h"
#include "SIGMA.h"
#include "SIGMA_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[720000];
static real_T c_emlrt_marshallIn(const mxArray *NE, const char_T *identifier);
static real_T d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static real_T (*e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[720000];
static real_T (*emlrt_marshallIn(const mxArray *stress, const char_T *identifier))
  [720000];
static const mxArray *emlrt_marshallOut(const real_T u[6480000]);
static real_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[720000]
{
  real_T (*y)[720000];
  y = e_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static real_T c_emlrt_marshallIn(const mxArray *NE, const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(emlrtAlias(NE), &thisId);
  emlrtDestroyArray(&NE);
  return y;
}

static real_T d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[720000]
{
  static const int32_T dims[4] = { 3, 3, 10000, 8 };

  real_T (*ret)[720000];
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 4U,
    dims);
  ret = (real_T (*)[720000])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static real_T (*emlrt_marshallIn(const mxArray *stress, const char_T
  *identifier))[720000]
{
  emlrtMsgIdentifier thisId;
  real_T (*y)[720000];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(emlrtAlias(stress), &thisId);
  emlrtDestroyArray(&stress);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u[6480000])
{
  static const int32_T iv[4] = { 0, 0, 0, 0 };

  static const int32_T iv1[4] = { 9, 9, 10000, 8 };

  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(4, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, iv1, 4);
  emlrtAssign(&y, m);
  return y;
}

static real_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 0U,
    &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void SIGMA_api(const mxArray * const prhs[2], const mxArray *plhs[1])
{
  real_T (*SHEAD)[6480000];
  real_T (*stress)[720000];
  real_T NE;
  SHEAD = (real_T (*)[6480000])mxMalloc(sizeof(real_T [6480000]));

  /* Marshall function inputs */
  stress = emlrt_marshallIn(emlrtAlias(prhs[0]), "stress");
  NE = c_emlrt_marshallIn(emlrtAliasP(prhs[1]), "NE");

  /* Invoke the target function */
  SIGMA(*stress, NE, *SHEAD);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*SHEAD);
}

/* End of code generation (_coder_SIGMA_api.c) */
