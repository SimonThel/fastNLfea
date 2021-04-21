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
#include "rt_nonfinite.h"

/* Function Definitions */
void SIGMA(const real_T stress[720000], real_T NE, real_T SHEAD[6480000])
{
  int32_T SHEAD_tmp;
  int32_T b_SHEAD_tmp;
  int32_T b_loop_ub;
  int32_T c_loop_ub;
  int32_T d_loop_ub;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T loop_ub;
  loop_ub = (int32_T)NE;
  b_loop_ub = (int32_T)NE;
  c_loop_ub = (int32_T)NE;
  d_loop_ub = (int32_T)NE;
  for (i = 0; i < 8; i++) {
    for (i1 = 0; i1 < 10000; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD_tmp = (3 * i2 + 9 * i1) + 90000 * i;
        b_SHEAD_tmp = (9 * i2 + 81 * i1) + 810000 * i;
        SHEAD[b_SHEAD_tmp] = stress[SHEAD_tmp];
        SHEAD[b_SHEAD_tmp + 1] = stress[SHEAD_tmp + 1];
        SHEAD[b_SHEAD_tmp + 2] = stress[SHEAD_tmp + 2];
      }
    }

    for (i1 = 0; i1 < loop_ub; i1++) {
      for (i2 = 0; i2 < 6; i2++) {
        SHEAD_tmp = (9 * (i2 + 3) + 81 * i1) + 810000 * i;
        SHEAD[SHEAD_tmp] = 0.0;
        SHEAD[SHEAD_tmp + 1] = 0.0;
        SHEAD[SHEAD_tmp + 2] = 0.0;
      }
    }

    for (i1 = 0; i1 < b_loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD_tmp = (9 * i2 + 81 * i1) + 810000 * i;
        SHEAD[SHEAD_tmp + 3] = 0.0;
        SHEAD[SHEAD_tmp + 4] = 0.0;
        SHEAD[SHEAD_tmp + 5] = 0.0;
      }
    }

    for (i1 = 0; i1 < 10000; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD_tmp = (3 * i2 + 9 * i1) + 90000 * i;
        b_SHEAD_tmp = (9 * (i2 + 3) + 81 * i1) + 810000 * i;
        SHEAD[b_SHEAD_tmp + 3] = stress[SHEAD_tmp];
        SHEAD[b_SHEAD_tmp + 4] = stress[SHEAD_tmp + 1];
        SHEAD[b_SHEAD_tmp + 5] = stress[SHEAD_tmp + 2];
      }
    }

    for (i1 = 0; i1 < c_loop_ub; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD_tmp = (9 * (i2 + 6) + 81 * i1) + 810000 * i;
        SHEAD[SHEAD_tmp + 3] = 0.0;
        SHEAD[SHEAD_tmp + 4] = 0.0;
        SHEAD[SHEAD_tmp + 5] = 0.0;
      }
    }

    for (i1 = 0; i1 < d_loop_ub; i1++) {
      for (i2 = 0; i2 < 6; i2++) {
        SHEAD_tmp = (9 * i2 + 81 * i1) + 810000 * i;
        SHEAD[SHEAD_tmp + 6] = 0.0;
        SHEAD[SHEAD_tmp + 7] = 0.0;
        SHEAD[SHEAD_tmp + 8] = 0.0;
      }
    }

    for (i1 = 0; i1 < 10000; i1++) {
      for (i2 = 0; i2 < 3; i2++) {
        SHEAD_tmp = (3 * i2 + 9 * i1) + 90000 * i;
        b_SHEAD_tmp = (9 * (i2 + 6) + 81 * i1) + 810000 * i;
        SHEAD[b_SHEAD_tmp + 6] = stress[SHEAD_tmp];
        SHEAD[b_SHEAD_tmp + 7] = stress[SHEAD_tmp + 1];
        SHEAD[b_SHEAD_tmp + 8] = stress[SHEAD_tmp + 2];
      }
    }
  }
}

/* End of code generation (SIGMA.c) */
