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
#include "nlStrainDisplacment_data.h"
#include "nlStrainDisplacment_emxutil.h"
#include "nlStrainDisplacment_types.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
void nlStrainDisplacment(const emxArray_real_T *temp, const emxArray_real_T
  *FT_int, emxArray_real_T *BN)
{
  emxArray_real_T *a;
  emxArray_real_T *b;
  emxArray_real_T *b_a;
  emxArray_real_T *buffer;
  emxArray_real_T *r;
  real_T d;
  real_T d1;
  int32_T b_i;
  int32_T b_k;
  int32_T i;
  int32_T i1;
  int32_T i2;
  int32_T j;
  int32_T k;
  int32_T na;
  int32_T npages_idx_1;
  int32_T npages_idx_2;
  int32_T ns;
  int32_T offset;
  int32_T outsize_idx_1;
  int32_T outsize_idx_2;
  int32_T pageroot;
  int32_T pagesize;
  int32_T stride;
  boolean_T shiftright_idx_0;
  boolean_T shiftright_idx_1;
  boolean_T shiftright_idx_2;
  boolean_T shiftright_idx_3;
  emlrtHeapReferenceStackEnterFcnR2012b(emlrtRootTLSGlobal);
  emxInit_real_T(&r, 4, true);
  i = r->size[0] * r->size[1] * r->size[2] * r->size[3];
  r->size[0] = 3;
  r->size[1] = 24;
  r->size[2] = FT_int->size[2];
  r->size[3] = 8;
  emxEnsureCapacity_real_T(r, i);
  if (FT_int->size[2] != 0) {
    na = FT_int->size[2];
    for (k = 0; k < 8; k++) {
      for (b_k = 0; b_k < na; b_k++) {
        for (npages_idx_2 = 0; npages_idx_2 < 8; npages_idx_2++) {
          offset = npages_idx_2 * 3;
          for (npages_idx_1 = 0; npages_idx_1 < 3; npages_idx_1++) {
            i = offset + npages_idx_1;
            r->data[(3 * i + 72 * b_k) + 72 * r->size[2] * k] = FT_int->data[(3 *
              npages_idx_1 + 9 * b_k) + 9 * FT_int->size[2] * k];
            r->data[((3 * i + 72 * b_k) + 72 * r->size[2] * k) + 1] =
              FT_int->data[((3 * npages_idx_1 + 9 * b_k) + 9 * FT_int->size[2] *
                            k) + 1];
            r->data[((3 * i + 72 * b_k) + 72 * r->size[2] * k) + 2] =
              FT_int->data[((3 * npages_idx_1 + 9 * b_k) + 9 * FT_int->size[2] *
                            k) + 2];
          }
        }
      }
    }
  }

  emxInit_real_T(&a, 4, true);
  i = a->size[0] * a->size[1] * a->size[2] * a->size[3];
  a->size[0] = 3;
  a->size[1] = 3;
  a->size[2] = FT_int->size[2];
  a->size[3] = 8;
  emxEnsureCapacity_real_T(a, i);
  stride = FT_int->size[0] * FT_int->size[1] * FT_int->size[2] * FT_int->size[3];
  for (i = 0; i < stride; i++) {
    a->data[i] = FT_int->data[i];
  }

  emxInit_real_T(&buffer, 2, true);
  if (FT_int->size[2] != 0) {
    i = 1;
    shiftright_idx_3 = false;
    if (1 > (FT_int->size[0] >> 1)) {
      i = FT_int->size[0] - 1;
      shiftright_idx_3 = true;
    }

    offset = i;
    shiftright_idx_0 = shiftright_idx_3;
    i = 0;
    shiftright_idx_3 = true;
    if (0 > (FT_int->size[1] >> 1)) {
      i = FT_int->size[1] - 1;
      shiftright_idx_3 = false;
    }

    outsize_idx_1 = i;
    shiftright_idx_1 = shiftright_idx_3;
    i = 0;
    shiftright_idx_3 = true;
    if (0 > (FT_int->size[2] >> 1)) {
      i = FT_int->size[2] - 1;
      shiftright_idx_3 = false;
    }

    outsize_idx_2 = i;
    shiftright_idx_2 = shiftright_idx_3;
    i = 0;
    shiftright_idx_3 = true;
    if (0 > (FT_int->size[3] >> 1)) {
      i = FT_int->size[3] - 1;
      shiftright_idx_3 = false;
    }

    stride = 3;
    if (FT_int->size[2] > 3) {
      stride = FT_int->size[2];
    }

    if (8 > stride) {
      stride = 8;
    }

    i1 = buffer->size[0] * buffer->size[1];
    buffer->size[0] = 1;
    buffer->size[1] = (int32_T)muDoubleScalarFloor((real_T)stride / 2.0);
    emxEnsureCapacity_real_T(buffer, i1);
    npages_idx_2 = FT_int->size[3];
    npages_idx_1 = npages_idx_2 * FT_int->size[2];
    na = npages_idx_1 * FT_int->size[1];
    i1 = a->size[0];
    ns = offset - 1;
    pagesize = a->size[0];
    if ((a->size[0] > 1) && (offset > 0)) {
      for (b_i = 0; b_i < na; b_i++) {
        pageroot = b_i * pagesize;
        for (j = 0; j < 1; j++) {
          if (shiftright_idx_0) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[((pageroot + k) + i1) - offset];
            }

            i2 = offset + 1;
            for (k = i1; k >= i2; k--) {
              b_k = pageroot + k;
              a->data[b_k - 1] = a->data[(b_k - offset) - 1];
            }

            for (k = 0; k <= ns; k++) {
              a->data[pageroot + k] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[pageroot + k];
            }

            i2 = i1 - offset;
            for (k = 0; k < i2; k++) {
              b_k = pageroot + k;
              a->data[b_k] = a->data[b_k + offset];
            }

            for (k = 0; k <= ns; k++) {
              a->data[((pageroot + k) + i1) - offset] = buffer->data[k];
            }
          }
        }
      }
    }

    stride = pagesize;
    i1 = a->size[1];
    ns = outsize_idx_1 - 1;
    pagesize *= a->size[1];
    if ((a->size[1] > 1) && (outsize_idx_1 > 0)) {
      for (b_i = 0; b_i < npages_idx_1; b_i++) {
        pageroot = b_i * pagesize;
        for (j = 0; j < stride; j++) {
          na = pageroot + j;
          if (shiftright_idx_1) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[na + ((k + i1) - outsize_idx_1) * stride];
            }

            i2 = outsize_idx_1 + 1;
            for (k = i1; k >= i2; k--) {
              a->data[na + (k - 1) * stride] = a->data[na + ((k - outsize_idx_1)
                - 1) * stride];
            }

            for (k = 0; k <= ns; k++) {
              a->data[na + k * stride] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[na + k * stride];
            }

            i2 = i1 - outsize_idx_1;
            for (k = 0; k < i2; k++) {
              a->data[na + k * stride] = a->data[na + (k + outsize_idx_1) *
                stride];
            }

            for (k = 0; k <= ns; k++) {
              a->data[na + ((k + i1) - outsize_idx_1) * stride] = buffer->data[k];
            }
          }
        }
      }
    }

    stride = pagesize;
    i1 = a->size[2];
    ns = outsize_idx_2 - 1;
    pagesize *= a->size[2];
    if ((a->size[2] > 1) && (outsize_idx_2 > 0)) {
      for (b_i = 0; b_i < npages_idx_2; b_i++) {
        pageroot = b_i * pagesize;
        for (j = 0; j < stride; j++) {
          na = pageroot + j;
          if (shiftright_idx_2) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[na + ((k + i1) - outsize_idx_2) * stride];
            }

            i2 = outsize_idx_2 + 1;
            for (k = i1; k >= i2; k--) {
              a->data[na + (k - 1) * stride] = a->data[na + ((k - outsize_idx_2)
                - 1) * stride];
            }

            for (k = 0; k <= ns; k++) {
              a->data[na + k * stride] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[na + k * stride];
            }

            i2 = i1 - outsize_idx_2;
            for (k = 0; k < i2; k++) {
              a->data[na + k * stride] = a->data[na + (k + outsize_idx_2) *
                stride];
            }

            for (k = 0; k <= ns; k++) {
              a->data[na + ((k + i1) - outsize_idx_2) * stride] = buffer->data[k];
            }
          }
        }
      }
    }

    i1 = a->size[3];
    ns = i - 1;
    if ((a->size[3] > 1) && (i > 0)) {
      for (b_i = 0; b_i < 1; b_i++) {
        for (j = 0; j < pagesize; j++) {
          if (shiftright_idx_3) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[j + ((k + i1) - i) * pagesize];
            }

            i2 = i + 1;
            for (k = i1; k >= i2; k--) {
              a->data[j + (k - 1) * pagesize] = a->data[j + ((k - i) - 1) *
                pagesize];
            }

            for (k = 0; k <= ns; k++) {
              a->data[j + k * pagesize] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = a->data[j + k * pagesize];
            }

            i2 = i1 - i;
            for (k = 0; k < i2; k++) {
              a->data[j + k * pagesize] = a->data[j + (k + i) * pagesize];
            }

            for (k = 0; k <= ns; k++) {
              a->data[j + ((k + i1) - i) * pagesize] = buffer->data[k];
            }
          }
        }
      }
    }
  }

  emxInit_real_T(&b_a, 4, true);
  i = b_a->size[0] * b_a->size[1] * b_a->size[2] * b_a->size[3];
  b_a->size[0] = 3;
  b_a->size[1] = 24;
  b_a->size[2] = temp->size[2];
  b_a->size[3] = 8;
  emxEnsureCapacity_real_T(b_a, i);
  stride = temp->size[0] * temp->size[1] * temp->size[2] * temp->size[3];
  for (i = 0; i < stride; i++) {
    b_a->data[i] = temp->data[i];
  }

  if (temp->size[2] != 0) {
    i = 1;
    shiftright_idx_3 = false;
    if (1 > (temp->size[0] >> 1)) {
      i = temp->size[0] - 1;
      shiftright_idx_3 = true;
    }

    offset = i;
    shiftright_idx_0 = shiftright_idx_3;
    i = 0;
    shiftright_idx_3 = true;
    if (0 > (temp->size[1] >> 1)) {
      i = temp->size[1] - 1;
      shiftright_idx_3 = false;
    }

    outsize_idx_1 = i;
    shiftright_idx_1 = shiftright_idx_3;
    i = 0;
    shiftright_idx_3 = true;
    if (0 > (temp->size[2] >> 1)) {
      i = temp->size[2] - 1;
      shiftright_idx_3 = false;
    }

    outsize_idx_2 = i;
    shiftright_idx_2 = shiftright_idx_3;
    i = 0;
    shiftright_idx_3 = true;
    if (0 > (temp->size[3] >> 1)) {
      i = temp->size[3] - 1;
      shiftright_idx_3 = false;
    }

    stride = 24;
    if (temp->size[2] > 24) {
      stride = temp->size[2];
    }

    i1 = buffer->size[0] * buffer->size[1];
    buffer->size[0] = 1;
    buffer->size[1] = (int32_T)muDoubleScalarFloor((real_T)stride / 2.0);
    emxEnsureCapacity_real_T(buffer, i1);
    npages_idx_2 = temp->size[3];
    npages_idx_1 = npages_idx_2 * temp->size[2];
    na = npages_idx_1 * temp->size[1];
    i1 = b_a->size[0];
    ns = offset - 1;
    pagesize = b_a->size[0];
    if ((b_a->size[0] > 1) && (offset > 0)) {
      for (b_i = 0; b_i < na; b_i++) {
        pageroot = b_i * pagesize;
        for (j = 0; j < 1; j++) {
          if (shiftright_idx_0) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[((pageroot + k) + i1) - offset];
            }

            i2 = offset + 1;
            for (k = i1; k >= i2; k--) {
              b_k = pageroot + k;
              b_a->data[b_k - 1] = b_a->data[(b_k - offset) - 1];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[pageroot + k] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[pageroot + k];
            }

            i2 = i1 - offset;
            for (k = 0; k < i2; k++) {
              b_k = pageroot + k;
              b_a->data[b_k] = b_a->data[b_k + offset];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[((pageroot + k) + i1) - offset] = buffer->data[k];
            }
          }
        }
      }
    }

    stride = pagesize;
    i1 = b_a->size[1];
    ns = outsize_idx_1 - 1;
    pagesize *= b_a->size[1];
    if ((b_a->size[1] > 1) && (outsize_idx_1 > 0)) {
      for (b_i = 0; b_i < npages_idx_1; b_i++) {
        pageroot = b_i * pagesize;
        for (j = 0; j < stride; j++) {
          na = pageroot + j;
          if (shiftright_idx_1) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[na + ((k + i1) - outsize_idx_1) *
                stride];
            }

            i2 = outsize_idx_1 + 1;
            for (k = i1; k >= i2; k--) {
              b_a->data[na + (k - 1) * stride] = b_a->data[na + ((k -
                outsize_idx_1) - 1) * stride];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[na + k * stride] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[na + k * stride];
            }

            i2 = i1 - outsize_idx_1;
            for (k = 0; k < i2; k++) {
              b_a->data[na + k * stride] = b_a->data[na + (k + outsize_idx_1) *
                stride];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[na + ((k + i1) - outsize_idx_1) * stride] = buffer->
                data[k];
            }
          }
        }
      }
    }

    stride = pagesize;
    i1 = b_a->size[2];
    ns = outsize_idx_2 - 1;
    pagesize *= b_a->size[2];
    if ((b_a->size[2] > 1) && (outsize_idx_2 > 0)) {
      for (b_i = 0; b_i < npages_idx_2; b_i++) {
        pageroot = b_i * pagesize;
        for (j = 0; j < stride; j++) {
          na = pageroot + j;
          if (shiftright_idx_2) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[na + ((k + i1) - outsize_idx_2) *
                stride];
            }

            i2 = outsize_idx_2 + 1;
            for (k = i1; k >= i2; k--) {
              b_a->data[na + (k - 1) * stride] = b_a->data[na + ((k -
                outsize_idx_2) - 1) * stride];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[na + k * stride] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[na + k * stride];
            }

            i2 = i1 - outsize_idx_2;
            for (k = 0; k < i2; k++) {
              b_a->data[na + k * stride] = b_a->data[na + (k + outsize_idx_2) *
                stride];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[na + ((k + i1) - outsize_idx_2) * stride] = buffer->
                data[k];
            }
          }
        }
      }
    }

    i1 = b_a->size[3];
    ns = i - 1;
    if ((b_a->size[3] > 1) && (i > 0)) {
      for (b_i = 0; b_i < 1; b_i++) {
        for (j = 0; j < pagesize; j++) {
          if (shiftright_idx_3) {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[j + ((k + i1) - i) * pagesize];
            }

            i2 = i + 1;
            for (k = i1; k >= i2; k--) {
              b_a->data[j + (k - 1) * pagesize] = b_a->data[j + ((k - i) - 1) *
                pagesize];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[j + k * pagesize] = buffer->data[k];
            }
          } else {
            for (k = 0; k <= ns; k++) {
              buffer->data[k] = b_a->data[j + k * pagesize];
            }

            i2 = i1 - i;
            for (k = 0; k < i2; k++) {
              b_a->data[j + k * pagesize] = b_a->data[j + (k + i) * pagesize];
            }

            for (k = 0; k <= ns; k++) {
              b_a->data[j + ((k + i1) - i) * pagesize] = buffer->data[k];
            }
          }
        }
      }
    }
  }

  emxFree_real_T(&buffer);
  emxInit_real_T(&b, 4, true);
  i = b->size[0] * b->size[1] * b->size[2] * b->size[3];
  b->size[0] = 3;
  b->size[1] = 24;
  b->size[2] = a->size[2];
  b->size[3] = 8;
  emxEnsureCapacity_real_T(b, i);
  if (a->size[2] != 0) {
    na = a->size[2];
    for (k = 0; k < 8; k++) {
      for (b_k = 0; b_k < na; b_k++) {
        for (npages_idx_2 = 0; npages_idx_2 < 8; npages_idx_2++) {
          offset = npages_idx_2 * 3;
          for (npages_idx_1 = 0; npages_idx_1 < 3; npages_idx_1++) {
            stride = offset + npages_idx_1;
            b->data[(3 * stride + 72 * b_k) + 72 * b->size[2] * k] = a->data[(3 *
              npages_idx_1 + 9 * b_k) + 9 * a->size[2] * k];
            b->data[((3 * stride + 72 * b_k) + 72 * b->size[2] * k) + 1] =
              a->data[((3 * npages_idx_1 + 9 * b_k) + 9 * a->size[2] * k) + 1];
            b->data[((3 * stride + 72 * b_k) + 72 * b->size[2] * k) + 2] =
              a->data[((3 * npages_idx_1 + 9 * b_k) + 9 * a->size[2] * k) + 2];
          }
        }
      }
    }
  }

  emxFree_real_T(&a);
  i = BN->size[0] * BN->size[1] * BN->size[2] * BN->size[3];
  BN->size[0] = 6;
  BN->size[1] = 24;
  BN->size[2] = temp->size[2];
  BN->size[3] = 8;
  emxEnsureCapacity_real_T(BN, i);
  stride = temp->size[2];
  for (i = 0; i < 8; i++) {
    for (i1 = 0; i1 < stride; i1++) {
      for (i2 = 0; i2 < 24; i2++) {
        b_k = 3 * i2 + 72 * i1;
        d = temp->data[b_k + 72 * temp->size[2] * i];
        d1 = r->data[b_k + 72 * r->size[2] * i];
        BN->data[(6 * i2 + 144 * i1) + 144 * BN->size[2] * i] = d * d1;
        BN->data[((6 * i2 + 144 * i1) + 144 * BN->size[2] * i) + 3] = d *
          b->data[b_k + 72 * b->size[2] * i] + b_a->data[b_k + 72 * b_a->size[2]
          * i] * d1;
        d = temp->data[((3 * i2 + 72 * i1) + 72 * temp->size[2] * i) + 1];
        d1 = r->data[((3 * i2 + 72 * i1) + 72 * r->size[2] * i) + 1];
        BN->data[((6 * i2 + 144 * i1) + 144 * BN->size[2] * i) + 1] = d * d1;
        BN->data[((6 * i2 + 144 * i1) + 144 * BN->size[2] * i) + 4] = d *
          b->data[((3 * i2 + 72 * i1) + 72 * b->size[2] * i) + 1] + b_a->data
          [((3 * i2 + 72 * i1) + 72 * b_a->size[2] * i) + 1] * d1;
        d = temp->data[((3 * i2 + 72 * i1) + 72 * temp->size[2] * i) + 2];
        d1 = r->data[((3 * i2 + 72 * i1) + 72 * r->size[2] * i) + 2];
        BN->data[((6 * i2 + 144 * i1) + 144 * BN->size[2] * i) + 2] = d * d1;
        BN->data[((6 * i2 + 144 * i1) + 144 * BN->size[2] * i) + 5] = d *
          b->data[((3 * i2 + 72 * i1) + 72 * b->size[2] * i) + 2] + b_a->data
          [((3 * i2 + 72 * i1) + 72 * b_a->size[2] * i) + 2] * d1;
      }
    }
  }

  emxFree_real_T(&b);
  emxFree_real_T(&r);
  emxFree_real_T(&b_a);
  emlrtHeapReferenceStackLeaveFcnR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (nlStrainDisplacment.c) */
