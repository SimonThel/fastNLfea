/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nlStrainDisplacment.h
 *
 * Code generation for function 'nlStrainDisplacment'
 *
 */

#pragma once

/* Include files */
#include "nlStrainDisplacment_types.h"
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void nlStrainDisplacment(nlStrainDisplacmentStackData *SD, const real_T temp
  [5760000], const real_T FT_int[720000], real_T BN[11520000]);

/* End of code generation (nlStrainDisplacment.h) */
