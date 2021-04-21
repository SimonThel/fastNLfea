/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_nlStrainDisplacment_api.c
 *
 * Code generation for function '_coder_nlStrainDisplacment_api'
 *
 */

/* Include files */
#include "_coder_nlStrainDisplacment_api.h"
#include "nlStrainDisplacment.h"
#include "nlStrainDisplacment_data.h"
#include "nlStrainDisplacment_types.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[5760000];
static real_T (*c_emlrt_marshallIn(const mxArray *FT_int, const char_T
  *identifier))[720000];
static real_T (*d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[720000];
static real_T (*e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[5760000];
static real_T (*emlrt_marshallIn(const mxArray *temp, const char_T *identifier))
  [5760000];
static const mxArray *emlrt_marshallOut(const real_T u[11520000]);
static real_T (*f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[720000];

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[5760000]
{
  real_T (*y)[5760000];
  y = e_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static real_T (*c_emlrt_marshallIn(const mxArray *FT_int, const char_T
  *identifier))[720000]
{
  emlrtMsgIdentifier thisId;
  real_T (*y)[720000];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(emlrtAlias(FT_int), &thisId);
  emlrtDestroyArray(&FT_int);
  return y;
}

static real_T (*d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[720000]
{
  real_T (*y)[720000];
  y = f_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static real_T (*e_emlrt_marshallIn(const mxArray *src, const
  emlrtMsgIdentifier *msgId))[5760000]
{
  static const int32_T dims[4] = { 3, 24, 10000, 8 };

  real_T (*ret)[5760000];
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 4U,
    dims);
  ret = (real_T (*)[5760000])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*emlrt_marshallIn(const mxArray *temp, const char_T *identifier))
  [5760000]
{
  emlrtMsgIdentifier thisId;
  real_T (*y)[5760000];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(emlrtAlias(temp), &thisId);
  emlrtDestroyArray(&temp);
  return y;
}
  static const mxArray *emlrt_marshallOut(const real_T u[11520000])
{
  static const int32_T iv[4] = { 0, 0, 0, 0 };

  static const int32_T iv1[4] = { 6, 24, 10000, 8 };

  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(4, &iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, iv1, 4);
  emlrtAssign(&y, m);
  return y;
}

static real_T (*f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
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
  void nlStrainDisplacment_api(nlStrainDisplacmentStackData *SD, const mxArray *
  const prhs[2], const mxArray *plhs[1])
{
  real_T (*BN)[11520000];
  real_T (*temp)[5760000];
  real_T (*FT_int)[720000];
  BN = (real_T (*)[11520000])mxMalloc(sizeof(real_T [11520000]));

  /* Marshall function inputs */
  temp = emlrt_marshallIn(emlrtAlias(prhs[0]), "temp");
  FT_int = c_emlrt_marshallIn(emlrtAlias(prhs[1]), "FT_int");

  /* Invoke the target function */
  nlStrainDisplacment(SD, *temp, *FT_int, *BN);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*BN);
}

/* End of code generation (_coder_nlStrainDisplacment_api.c) */
