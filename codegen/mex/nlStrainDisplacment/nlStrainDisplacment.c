/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * nlStrainDisplacment.c
 *
 * Code generation for function 'nlStrainDisplacment'
 *
 */

/* Include files */
#include "nlStrainDisplacment.h"
#include "nlStrainDisplacment_types.h"
#include "rt_nonfinite.h"
#include <string.h>

/* Function Definitions */
void nlStrainDisplacment(nlStrainDisplacmentStackData *SD, const real_T temp
  [5760000], const real_T FT_int[720000], real_T BN[11520000])
{
  real_T buffer;
  real_T d;
  int32_T BN_tmp_tmp;
  int32_T b_k;
  int32_T c_k;
  int32_T j;
  int32_T k;
  int32_T offset;
  int32_T pageroot;
  int32_T t;
  for (k = 0; k < 8; k++) {
    for (b_k = 0; b_k < 10000; b_k++) {
      for (t = 0; t < 8; t++) {
        offset = t * 3;
        for (c_k = 0; c_k < 3; c_k++) {
          BN_tmp_tmp = (3 * c_k + 9 * b_k) + 90000 * k;
          pageroot = (3 * (offset + c_k) + 72 * b_k) + 720000 * k;
          SD->f0.BN_tmp[pageroot] = FT_int[BN_tmp_tmp];
          SD->f0.BN_tmp[pageroot + 1] = FT_int[BN_tmp_tmp + 1];
          SD->f0.BN_tmp[pageroot + 2] = FT_int[BN_tmp_tmp + 2];
        }
      }
    }
  }

  memcpy(&SD->f0.b_a[0], &FT_int[0], 720000U * sizeof(real_T));
  for (BN_tmp_tmp = 0; BN_tmp_tmp < 240000; BN_tmp_tmp++) {
    pageroot = BN_tmp_tmp * 3;
    for (j = 0; j < 1; j++) {
      buffer = SD->f0.b_a[pageroot];
      for (k = 0; k < 2; k++) {
        b_k = pageroot + k;
        SD->f0.b_a[b_k] = SD->f0.b_a[b_k + 1];
      }

      SD->f0.b_a[pageroot + 2] = buffer;
    }
  }

  for (k = 0; k < 8; k++) {
    for (b_k = 0; b_k < 10000; b_k++) {
      for (t = 0; t < 8; t++) {
        offset = t * 3;
        for (c_k = 0; c_k < 3; c_k++) {
          pageroot = (3 * c_k + 9 * b_k) + 90000 * k;
          j = (3 * (offset + c_k) + 72 * b_k) + 720000 * k;
          SD->f0.b[j] = SD->f0.b_a[pageroot];
          SD->f0.b[j + 1] = SD->f0.b_a[pageroot + 1];
          SD->f0.b[j + 2] = SD->f0.b_a[pageroot + 2];
        }
      }
    }
  }

  memcpy(&SD->f0.a[0], &temp[0], 5760000U * sizeof(real_T));
  for (BN_tmp_tmp = 0; BN_tmp_tmp < 1920000; BN_tmp_tmp++) {
    pageroot = BN_tmp_tmp * 3;
    for (j = 0; j < 1; j++) {
      buffer = SD->f0.a[pageroot];
      for (k = 0; k < 2; k++) {
        b_k = pageroot + k;
        SD->f0.a[b_k] = SD->f0.a[b_k + 1];
      }

      SD->f0.a[pageroot + 2] = buffer;
    }
  }

  for (BN_tmp_tmp = 0; BN_tmp_tmp < 8; BN_tmp_tmp++) {
    for (pageroot = 0; pageroot < 10000; pageroot++) {
      for (j = 0; j < 24; j++) {
        b_k = (3 * j + 72 * pageroot) + 720000 * BN_tmp_tmp;
        buffer = temp[b_k];
        d = SD->f0.BN_tmp[b_k];
        t = (6 * j + 144 * pageroot) + 1440000 * BN_tmp_tmp;
        BN[t] = buffer * d;
        BN[t + 3] = buffer * SD->f0.b[b_k] + SD->f0.a[b_k] * d;
        buffer = temp[b_k + 1];
        d = SD->f0.BN_tmp[b_k + 1];
        BN[t + 1] = buffer * d;
        BN[t + 4] = buffer * SD->f0.b[b_k + 1] + SD->f0.a[b_k + 1] * d;
        buffer = temp[b_k + 2];
        d = SD->f0.BN_tmp[b_k + 2];
        BN[t + 2] = buffer * d;
        BN[t + 5] = buffer * SD->f0.b[b_k + 2] + SD->f0.a[b_k + 2] * d;
      }
    }
  }
}

/* End of code generation (nlStrainDisplacment.c) */
