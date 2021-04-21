/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SIGMA.c
 *
 * Code generation for function 'SIGMA'
 *
 */

/* Include files */
#include "SIGMA.h"
#include "SIGMA_emxutil.h"
#include "SIGMA_types.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void SIGMA(const emxArray_real_T *stress, real_T NE, emxArray_real_T *SHEAD)
{
  int32_T b_loop_ub;
  int32_T c_loop_ub;
  int32_T d_loop_ub;
  int32_T e_loop_ub;
  int32_T f_loop_ub;
  int32_T g_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T loop_ub;
  i = SHEAD->size[0] * SHEAD->size[1] * SHEAD->size[2] * SHEAD->size[3];
  SHEAD->size[0] = 9;
  SHEAD->size[1] = 9;
  SHEAD->size[2] = stress->size[2];
  SHEAD->size[3] = 8;
  emxEnsureCapacity_real_T(SHEAD, i);
  loop_ub = stress->size[2];
  b_loop_ub = (int32_T)NE;
  c_loop_ub = (int32_T)NE;
  d_loop_ub = stress->size[2];
  e_loop_ub = (int32_T)NE;
  f_loop_ub = (int32_T)NE;
  g_loop_ub = stress->size[2];
  for (i = 0; i < 8; i++) {
    for (i1 = 0; i1 < loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD->data[(9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i] = stress->
          data[(3 * i2 + 9 * i1) + 9 * stress->size[2] * i];
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 1] =
          stress->data[((3 * i2 + 9 * i1) + 9 * stress->size[2] * i) + 1];
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 2] =
          stress->data[((3 * i2 + 9 * i1) + 9 * stress->size[2] * i) + 2];
      }
    }

    for (i1 = 0; i1 < b_loop_ub; i1++) {
      for (i2 = 0; i2 < 6; i2++) {
        SHEAD->data[(9 * (i2 + 3) + 81 * i1) + 81 * SHEAD->size[2] * i] = 0.0;
        SHEAD->data[((9 * (i2 + 3) + 81 * i1) + 81 * SHEAD->size[2] * i) + 1] =
          0.0;
        SHEAD->data[((9 * (i2 + 3) + 81 * i1) + 81 * SHEAD->size[2] * i) + 2] =
          0.0;
      }
    }

    for (i1 = 0; i1 < c_loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 3] = 0.0;
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 4] = 0.0;
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 5] = 0.0;
      }
    }

    for (i1 = 0; i1 < d_loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD->data[((9 * (i2 + 3) + 81 * i1) + 81 * SHEAD->size[2] * i) + 3] =
          stress->data[(3 * i2 + 9 * i1) + 9 * stress->size[2] * i];
        SHEAD->data[((9 * (i2 + 3) + 81 * i1) + 81 * SHEAD->size[2] * i) + 4] =
          stress->data[((3 * i2 + 9 * i1) + 9 * stress->size[2] * i) + 1];
        SHEAD->data[((9 * (i2 + 3) + 81 * i1) + 81 * SHEAD->size[2] * i) + 5] =
          stress->data[((3 * i2 + 9 * i1) + 9 * stress->size[2] * i) + 2];
      }
    }

    for (i1 = 0; i1 < e_loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD->data[((9 * (i2 + 6) + 81 * i1) + 81 * SHEAD->size[2] * i) + 3] =
          0.0;
        SHEAD->data[((9 * (i2 + 6) + 81 * i1) + 81 * SHEAD->size[2] * i) + 4] =
          0.0;
        SHEAD->data[((9 * (i2 + 6) + 81 * i1) + 81 * SHEAD->size[2] * i) + 5] =
          0.0;
      }
    }

    for (i1 = 0; i1 < f_loop_ub; i1++) {
      for (i2 = 0; i2 < 6; i2++) {
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 6] = 0.0;
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 7] = 0.0;
        SHEAD->data[((9 * i2 + 81 * i1) + 81 * SHEAD->size[2] * i) + 8] = 0.0;
      }
    }

    for (i1 = 0; i1 < g_loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD->data[((9 * (i2 + 6) + 81 * i1) + 81 * SHEAD->size[2] * i) + 6] =
          stress->data[(3 * i2 + 9 * i1) + 9 * stress->size[2] * i];
        SHEAD->data[((9 * (i2 + 6) + 81 * i1) + 81 * SHEAD->size[2] * i) + 7] =
          stress->data[((3 * i2 + 9 * i1) + 9 * stress->size[2] * i) + 1];
        SHEAD->data[((9 * (i2 + 6) + 81 * i1) + 81 * SHEAD->size[2] * i) + 8] =
          stress->data[((3 * i2 + 9 * i1) + 9 * stress->size[2] * i) + 2];
      }
    }
  }
}

/* End of code generation (SIGMA.c) */
