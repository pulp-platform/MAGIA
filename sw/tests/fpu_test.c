/*
 * Copyright (C) 2023-2024 ETH Zurich and University of Bologna
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Victor Isachi <victor.isachi@unibo.it>
 *          Luca Balboni  <luca.balboni@chips.it>
 *
 * MAGIA Tile FPU Test
 *
 */

#include "magia_tile_utils.h"

#if defined(__riscv_zfinx)
#define FPR      "r"
#define MODE_STR "Zfinx"
#else
#define FPR      "f"
#define MODE_STR "F"
#endif

/* Operands */
#define A_VAL (12.34f)
#define B_VAL (56.78f)
#define C_VAL (-3.5f)
#define I_VAL (-7)

/* IEEE-754 single-precision references */
#define EXP_ADD     0x428A3D70u   /* a + b                  */
#define EXP_SUB     0xC231C28Fu   /* a - b            (mod) */
#define EXP_MUL     0x442F2A93u   /* a * b                  */
#define EXP_DIV     0x3E5E8BC5u   /* a / b                  */
#define EXP_SQRT    0x4060D244u   /* sqrt(a)                */
#define EXP_FMADD   0x442E4A93u   /*  (a*b) + c             */
#define EXP_FNMSUB  0xC4300A93u   /* -(a*b) + c       (mod) */
#define EXP_SGNJ    0xC14570A4u   /* a with sign of c       */
#define EXP_SGNJN   0xC14570A4u   /* a with ~sign of a(mod) */
#define EXP_MIN     0xC0600000u   /* min(a, c)              */
#define EXP_MAX     0x414570A4u   /* max(a, c)        (mod) */
#define EXP_CVT_SW  0xC0E00000u   /* (float)-7              */
#define EXP_CVT_W   12u           /* (int)a,  rtz           */
#define EXP_CVT_WU  56u           /* (unsigned)b, rtz (mod) */
#define EXP_LT      1u            /* a < b                  */

#define FP_OP1(insn, x)          ({ float _d;    asm volatile(insn " %0, %1"         : "=" FPR(_d) : FPR(x));                 _d; })
#define FP_OP2(insn, x, y)       ({ float _d;    asm volatile(insn " %0, %1, %2"     : "=" FPR(_d) : FPR(x), FPR(y));         _d; })
#define FP_OP3(insn, x, y, z)    ({ float _d;    asm volatile(insn " %0, %1, %2, %3" : "=" FPR(_d) : FPR(x), FPR(y), FPR(z)); _d; })
#define FP_CMP(insn, x, y)       ({ uint32_t _d; asm volatile(insn " %0, %1, %2"     : "=r"(_d)    : FPR(x), FPR(y));         _d; })
/* rtz is spelled out so the conversions match the C cast semantics and do not
   depend on the current dynamic rounding mode in fcsr. */
#define FP_TO_INT(insn, x)       ({ uint32_t _d; asm volatile(insn " %0, %1, rtz"    : "=r"(_d)    : FPR(x));                 _d; })
#define INT_TO_FP(insn, x)       ({ float _d;    asm volatile(insn " %0, %1"         : "=" FPR(_d) : "r"(x));                 _d; })

static inline uint32_t f2u(float f) {
  uint32_t u;
#if defined(__riscv_zfinx)
  asm volatile("mv %0, %1" : "=r"(u) : "r"(f));
#else
  asm volatile("fmv.x.w %0, %1" : "=r"(u) : "f"(f));
#endif
  return u;
}

static inline float u2f(uint32_t u) {
  float f;
#if defined(__riscv_zfinx)
  asm volatile("mv %0, %1" : "=r"(f) : "r"(u));
#else
  asm volatile("fmv.w.x %0, %1" : "=f"(f) : "r"(u));
#endif
  return f;
}

/* Results are collected first and reported afterwards, so that no FP value is
   live across the printf calls. */
enum { N_CHECKS = 15 };

static const char *const names[N_CHECKS] = {
  "fadd.s", "fsub.s", "fmul.s", "fdiv.s", "fsqrt.s",
  "fmadd.s", "fnmsub.s", "fsgnj.s", "fsgnjn.s",
  "fmin.s", "fmax.s", "fcvt.s.w", "fcvt.w.s", "fcvt.wu.s", "flt.s"
};

static const uint32_t expected[N_CHECKS] = {
  EXP_ADD, EXP_SUB, EXP_MUL, EXP_DIV, EXP_SQRT,
  EXP_FMADD, EXP_FNMSUB, EXP_SGNJ, EXP_SGNJN,
  EXP_MIN, EXP_MAX, EXP_CVT_SW, EXP_CVT_W, EXP_CVT_WU, EXP_LT
};

int main(void) {
  uint32_t got[N_CHECKS];
  uint32_t errors = 0;
  uint32_t i;

  /* volatile so the operands are genuine loads and nothing is folded away */
  static volatile uint32_t raw_a = 0x414570A4u;   /* 12.34f */
  static volatile uint32_t raw_b = 0x42631EB8u;   /* 56.78f */
  static volatile uint32_t raw_c = 0xC0600000u;   /* -3.5f  */
  static volatile int32_t  raw_i = I_VAL;

  printf("FPU test (%s mode)\n", MODE_STR);

  {
    float a = u2f(raw_a);
    float b = u2f(raw_b);
    float c = u2f(raw_c);
    int32_t n = raw_i;

    got[0]  = f2u(FP_OP2("fadd.s",   a, b));
    got[1]  = f2u(FP_OP2("fsub.s",   a, b));
    got[2]  = f2u(FP_OP2("fmul.s",   a, b));
    got[3]  = f2u(FP_OP2("fdiv.s",   a, b));
    got[4]  = f2u(FP_OP1("fsqrt.s",  a));
    got[5]  = f2u(FP_OP3("fmadd.s",  a, b, c));
    got[6]  = f2u(FP_OP3("fnmsub.s", a, b, c));
    got[7]  = f2u(FP_OP2("fsgnj.s",  a, c));
    got[8]  = f2u(FP_OP2("fsgnjn.s", a, a));
    got[9]  = f2u(FP_OP2("fmin.s",   a, c));
    got[10] = f2u(FP_OP2("fmax.s",   a, c));
    got[11] = f2u(INT_TO_FP("fcvt.s.w",  n));
    got[12] = FP_TO_INT("fcvt.w.s",  a);
    got[13] = FP_TO_INT("fcvt.wu.s", b);
    got[14] = FP_CMP("flt.s", a, b);
  }

  for (i = 0; i < N_CHECKS; i++) {
    if (got[i] != expected[i]) {
      errors++;
      printf("  %s: got 0x%08x expected 0x%08x\n", names[i],
             (unsigned int)got[i], (unsigned int)expected[i]);
    }
  }

  printf("%d/%d checks passed\n", (unsigned int)(N_CHECKS - errors),
         (unsigned int)N_CHECKS);

  if (errors)
    printf("Test FAILED\n");
  else
    printf("Test PASSED\n");

  return errors;
}
