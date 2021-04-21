/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nlStrainDisplacment_types.h
 *
 * Code generation for function 'nlStrainDisplacment'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"

/* Type Definitions */
#ifndef typedef_nlStrainDisplacmentStackData
#define typedef_nlStrainDisplacmentStackData

typedef struct {
  struct {
    real_T a[5760000];
    real_T BN_tmp[5760000];
    real_T b[5760000];
    real_T b_a[720000];
  } f0;
} nlStrainDisplacmentStackData;

#endif                                 /*typedef_nlStrainDisplacmentStackData*/

/* End of code generation (nlStrainDisplacment_types.h) */
