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
 * Authors: Luca Balboni <luca.balboni10@studio.unibo,it>
 *
 * Instructions Sweep Task for Spatz_cc
 */

#include <stdint.h>
#include "magia_tile_utils.h"

#define VEC_SIZE 16

// Memory layout in L1
#define VEC_A_BASE   (L1_BASE + 0x00005000)
#define VEC_B_BASE   (L1_BASE + 0x00005200)
#define VEC_C_BASE   (L1_BASE + 0x00005400)
#define SCALAR_BASE  (L1_BASE + 0x00005600)

#define vec_a ((volatile float *)VEC_A_BASE)
#define vec_b ((volatile float *)VEC_B_BASE)
#define vec_c ((volatile float *)VEC_C_BASE)
#define scalar_mem ((volatile float *)SCALAR_BASE)

int instructions_sweep_simple_task(void) {
    
    printf("[SNITCH] 32-bit Instructions Test - Spatz Full Coverage\n");
    printf("[SNITCH] Testing: RVF, Vector Int/FP (e8/e16/e32)\n");
    printf("[SNITCH] Using L1 memory at 0x%08x\n", L1_BASE);
    printf("[SNITCH] ========================================\n");
    
    float a_f, b_f, c_f, result_f;
    int32_t iresult;
    
    // ==================== SCALAR RVF (Single Precision) ====================
    printf("[SNITCH] Testing Scalar RVF Instructions:\n");
    a_f = 3.5f; b_f = 2.0f; c_f = 1.5f;
    
    // Arithmetic
    asm volatile("fadd.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FADD.S\n");
    asm volatile("fsub.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FSUB.S\n");
    asm volatile("fmul.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FMUL.S\n");
    asm volatile("fmin.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FMIN.S\n");
    asm volatile("fmax.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FMAX.S\n");
    
    // Sign injection
    asm volatile("fsgnj.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FSGNJ.S\n");
    asm volatile("fsgnjn.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FSGNJN.S\n");
    asm volatile("fsgnjx.s %0, %1, %2" : "=f"(result_f) : "f"(a_f), "f"(b_f)); printf("  FSGNJX.S\n");
    
    // Comparisons
    asm volatile("feq.s %0, %1, %2" : "=r"(iresult) : "f"(a_f), "f"(b_f)); printf("  FEQ.S\n");
    asm volatile("flt.s %0, %1, %2" : "=r"(iresult) : "f"(a_f), "f"(b_f)); printf("  FLT.S\n");
    asm volatile("fle.s %0, %1, %2" : "=r"(iresult) : "f"(a_f), "f"(b_f)); printf("  FLE.S\n");
    asm volatile("fclass.s %0, %1" : "=r"(iresult) : "f"(a_f)); printf("  FCLASS.S\n");
    
    // FMA
    asm volatile("fmadd.s %0, %1, %2, %3" : "=f"(result_f) : "f"(a_f), "f"(b_f), "f"(c_f)); printf("  FMADD.S\n");
    asm volatile("fmsub.s %0, %1, %2, %3" : "=f"(result_f) : "f"(a_f), "f"(b_f), "f"(c_f)); printf("  FMSUB.S\n");
    asm volatile("fnmadd.s %0, %1, %2, %3" : "=f"(result_f) : "f"(a_f), "f"(b_f), "f"(c_f)); printf("  FNMADD.S\n");
    asm volatile("fnmsub.s %0, %1, %2, %3" : "=f"(result_f) : "f"(a_f), "f"(b_f), "f"(c_f)); printf("  FNMSUB.S\n");
    
    // Conversions
    asm volatile("fcvt.w.s %0, %1, rtz" : "=r"(iresult) : "f"(a_f)); printf("  FCVT.W.S\n");
    asm volatile("fcvt.wu.s %0, %1, rtz" : "=r"(iresult) : "f"(a_f)); printf("  FCVT.WU.S\n");
    asm volatile("fcvt.s.w %0, %1" : "=f"(result_f) : "r"(iresult)); printf("  FCVT.S.W\n");
    asm volatile("fcvt.s.wu %0, %1" : "=f"(result_f) : "r"(iresult)); printf("  FCVT.S.WU\n");
    
    // Load/Store
    scalar_mem[0] = 42.0f;
    asm volatile("flw %0, 0(%1)" : "=f"(result_f) : "r"(scalar_mem)); printf("  FLW\n");
    asm volatile("fsw %0, 0(%1)" :: "f"(result_f), "r"(scalar_mem)); printf("  FSW\n");
    
    
    // ==================== SCALAR M-EXTENSION (Integer Mul/Div) ====================
    printf("[SNITCH] Testing Scalar M-Extension Instructions:\n");
    int32_t a_i = 15, b_i = 4, result_i;
    
    asm volatile("mul %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  MUL\n");
    asm volatile("mulh %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  MULH\n");
    asm volatile("mulhu %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  MULHU\n");
    asm volatile("mulhsu %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  MULHSU\n");
    asm volatile("div %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  DIV\n");
    asm volatile("divu %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  DIVU\n");
    asm volatile("rem %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  REM\n");
    asm volatile("remu %0, %1, %2" : "=r"(result_i) : "r"(a_i), "r"(b_i)); printf("  REMU\n");
    
    // ==================== VECTOR INTEGER (e32) ====================
    printf("[SNITCH] Testing Vector Integer Instructions (e32):\n");
    
    volatile int32_t *vec_ia = (volatile int32_t *)VEC_A_BASE;
    volatile int32_t *vec_ib = (volatile int32_t *)VEC_B_BASE;
    volatile int32_t *vec_ic = (volatile int32_t *)VEC_C_BASE;
    
    for (int i = 0; i < VEC_SIZE; i++) {
        vec_ia[i] = i + 1;
        vec_ib[i] = i * 2;
    }
    
    asm volatile("vsetvli zero, %0, e32, m4, ta, ma" ::"r"(VEC_SIZE)); printf("  VSETVLI (e32)\n");
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_ia)); printf("  VLE32.V\n");
    asm volatile("vle32.v v4, (%0)" ::"r"(vec_ib)); printf("  VLE32.V\n");
    
    // Arithmetic
    asm volatile("vadd.vv v8, v0, v4"); printf("  VADD.VV\n");
    asm volatile("vsub.vv v8, v0, v4"); printf("  VSUB.VV\n");
    asm volatile("vmul.vv v8, v0, v4"); printf("  VMUL.VV\n");
    asm volatile("vdivu.vv v8, v0, v4"); printf("  VDIVU.VV\n");
    asm volatile("vdiv.vv v8, v0, v4"); printf("  VDIV.VV\n");
    asm volatile("vremu.vv v8, v0, v4"); printf("  VREMU.VV\n");
    asm volatile("vrem.vv v8, v0, v4"); printf("  VREM.VV\n");
    
    int32_t scalar_i = 5;
    asm volatile("vadd.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VADD.VX\n");
    asm volatile("vsub.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VSUB.VX\n");
    asm volatile("vrsub.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VRSUB.VX\n");
    asm volatile("vmul.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VMUL.VX\n");
    
    // Logical
    asm volatile("vand.vv v8, v0, v4"); printf("  VAND.VV\n");
    asm volatile("vor.vv v8, v0, v4"); printf("  VOR.VV\n");
    asm volatile("vxor.vv v8, v0, v4"); printf("  VXOR.VV\n");
    asm volatile("vand.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VAND.VX\n");
    asm volatile("vor.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VOR.VX\n");
    asm volatile("vxor.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VXOR.VX\n");
    
    // Shifts
    asm volatile("vsll.vv v8, v0, v4"); printf("  VSLL.VV\n");
    asm volatile("vsrl.vv v8, v0, v4"); printf("  VSRL.VV\n");
    asm volatile("vsra.vv v8, v0, v4"); printf("  VSRA.VV\n");
    asm volatile("vsll.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VSLL.VX\n");
    asm volatile("vsrl.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VSRL.VX\n");
    asm volatile("vsra.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VSRA.VX\n");
    
    // Min/Max
    asm volatile("vmin.vv v8, v0, v4"); printf("  VMIN.VV\n");
    asm volatile("vmax.vv v8, v0, v4"); printf("  VMAX.VV\n");
    asm volatile("vminu.vv v8, v0, v4"); printf("  VMINU.VV\n");
    asm volatile("vmaxu.vv v8, v0, v4"); printf("  VMAXU.VV\n");
    
    // High multiply
    asm volatile("vmulh.vv v8, v0, v4"); printf("  VMULH.VV\n");
    asm volatile("vmulhu.vv v8, v0, v4"); printf("  VMULHU.VV\n");
    asm volatile("vmulhsu.vv v8, v0, v4"); printf("  VMULHSU.VV\n");
    asm volatile("vmulh.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VMULH.VX\n");
    
    // MAC
    asm volatile("vmacc.vv v8, v0, v4"); printf("  VMACC.VV\n");
    asm volatile("vnmsac.vv v8, v0, v4"); printf("  VNMSAC.VV\n");
    asm volatile("vmadd.vv v8, v0, v4"); printf("  VMADD.VV\n");
    asm volatile("vnmsub.vv v8, v0, v4"); printf("  VNMSUB.VV\n");
    
    // Carry/Borrow
    asm volatile("vadc.vvm v8, v0, v4, v0"); printf("  VADC.VVM\n");
    asm volatile("vmadc.vv v0, v4, v8"); printf("  VMADC.VV\n");
    asm volatile("vsbc.vvm v8, v0, v4, v0"); printf("  VSBC.VVM\n");
    asm volatile("vmsbc.vv v0, v4, v8"); printf("  VMSBC.VV\n");
    
    // Comparisons (mask operations)
    asm volatile("vmseq.vv v0, v4, v8"); printf("  VMSEQ.VV\n");
    asm volatile("vmsne.vv v0, v4, v8"); printf("  VMSNE.VV\n");
    asm volatile("vmslt.vv v0, v4, v8"); printf("  VMSLT.VV\n");
    asm volatile("vmsltu.vv v0, v4, v8"); printf("  VMSLTU.VV\n");
    asm volatile("vmsle.vv v0, v4, v8"); printf("  VMSLE.VV\n");
    asm volatile("vmsleu.vv v0, v4, v8"); printf("  VMSLEU.VV\n");
    asm volatile("vmsltu.vx v0, v4, %0" ::"r"(scalar_i)); printf("  VMSLTU.VX\n");
    asm volatile("vmslt.vx v0, v4, %0" ::"r"(scalar_i)); printf("  VMSLT.VX\n");
    
    // Integer immediate operations
    asm volatile("vadd.vi v8, v0, 5"); printf("  VADD.VI\n");
    asm volatile("vrsub.vi v8, v0, 10"); printf("  VRSUB.VI\n");
    asm volatile("vand.vi v8, v0, 15"); printf("  VAND.VI\n");
    asm volatile("vor.vi v8, v0, 7"); printf("  VOR.VI\n");
    asm volatile("vxor.vi v8, v0, 3"); printf("  VXOR.VI\n");
    asm volatile("vsll.vi v8, v0, 2"); printf("  VSLL.VI\n");
    asm volatile("vsrl.vi v8, v0, 2"); printf("  VSRL.VI\n");
    asm volatile("vsra.vi v8, v0, 2"); printf("  VSRA.VI\n");
    asm volatile("vmseq.vi v0, v4, 5"); printf("  VMSEQ.VI\n");
    asm volatile("vmsne.vi v0, v4, 5"); printf("  VMSNE.VI\n");
    asm volatile("vmsleu.vi v0, v4, 10"); printf("  VMSLEU.VI\n");
    asm volatile("vmsle.vi v0, v4, 10"); printf("  VMSLE.VI\n");
    asm volatile("vmsgtu.vi v0, v4, 3"); printf("  VMSGTU.VI\n");
    asm volatile("vmsgt.vi v0, v4, 3"); printf("  VMSGT.VI\n");
    
    // Reductions
    asm volatile("vredsum.vs v8, v0, v4"); printf("  VREDSUM.VS\n");
    asm volatile("vredand.vs v8, v0, v4"); printf("  VREDAND.VS\n");
    asm volatile("vredor.vs v8, v0, v4"); printf("  VREDOR.VS\n");
    asm volatile("vredxor.vs v8, v0, v4"); printf("  VREDXOR.VS\n");
    asm volatile("vredmin.vs v8, v0, v4"); printf("  VREDMIN.VS\n");
    asm volatile("vredminu.vs v8, v0, v4"); printf("  VREDMINU.VS\n");
    asm volatile("vredmax.vs v8, v0, v4"); printf("  VREDMAX.VS\n");
    asm volatile("vredmaxu.vs v8, v0, v4"); printf("  VREDMAXU.VS\n");
    
    // Move
    asm volatile("vmv.v.v v8, v0"); printf("  VMV.V.V\n");
    asm volatile("vmv.v.x v8, %0" ::"r"(scalar_i)); printf("  VMV.V.X\n");
    asm volatile("vmv.s.x v8, %0" ::"r"(scalar_i)); printf("  VMV.S.X\n");
    asm volatile("vmv.x.s %0, v0" :"=r"(result_i)); printf("  VMV.X.S\n");
    
    // Slide
    asm volatile("vslideup.vx v8, v0, %0" ::"r"(2)); printf("  VSLIDEUP.VX\n");
    asm volatile("vslidedown.vx v8, v0, %0" ::"r"(2)); printf("  VSLIDEDOWN.VX\n");
    asm volatile("vslide1up.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VSLIDE1UP.VX\n");
    asm volatile("vslide1down.vx v8, v0, %0" ::"r"(scalar_i)); printf("  VSLIDE1DOWN.VX\n");
    
    // Widening (e16->e32)
    asm volatile("vsetvli zero, %0, e16, m2, ta, ma" ::"r"(VEC_SIZE*2));
    volatile int16_t *vec_i16a = (volatile int16_t *)VEC_A_BASE;
    volatile int16_t *vec_i16b = (volatile int16_t *)VEC_B_BASE;
    for (int i = 0; i < VEC_SIZE*2; i++) {
        vec_i16a[i] = i + 1;
        vec_i16b[i] = i * 2;
    }
    asm volatile("vle16.v v0, (%0)" ::"r"(vec_i16a));
    asm volatile("vle16.v v2, (%0)" ::"r"(vec_i16b));
    asm volatile("vwadd.vv v8, v0, v2"); printf("  VWADD.VV (e16->e32)\n");
    asm volatile("vwaddu.vv v8, v0, v2"); printf("  VWADDU.VV (e16->e32)\n");
    asm volatile("vwsub.vv v8, v0, v2"); printf("  VWSUB.VV (e16->e32)\n");
    asm volatile("vwsubu.vv v8, v0, v2"); printf("  VWSUBU.VV (e16->e32)\n");
    asm volatile("vwmul.vv v8, v0, v2"); printf("  VWMUL.VV (e16->e32)\n");
    asm volatile("vwmulu.vv v8, v0, v2"); printf("  VWMULU.VV (e16->e32)\n");
    asm volatile("vwmulsu.vv v8, v0, v2"); printf("  VWMULSU.VV (e16->e32)\n");
    
    // Widening with scalar (e16->e32)
    int16_t scalar_i16 = 3;
    asm volatile("vwadd.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWADD.VX (e16->e32)\n");
    asm volatile("vwaddu.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWADDU.VX (e16->e32)\n");
    asm volatile("vwsub.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWSUB.VX (e16->e32)\n");
    asm volatile("vwsubu.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWSUBU.VX (e16->e32)\n");
    asm volatile("vwmul.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWMUL.VX (e16->e32)\n");
    asm volatile("vwmulu.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWMULU.VX (e16->e32)\n");
    asm volatile("vwmulsu.vx v8, v0, %0" ::"r"(scalar_i16)); printf("  VWMULSU.VX (e16->e32)\n");
    
    // Widening MAC (e16->e32)
    asm volatile("vwmacc.vv v8, v0, v2"); printf("  VWMACC.VV (e16->e32)\n");
    asm volatile("vwmaccu.vv v8, v0, v2"); printf("  VWMACCU.VV (e16->e32)\n");
    asm volatile("vwmaccsu.vv v8, v0, v2"); printf("  VWMACCSU.VV (e16->e32)\n");
    
    // Widening MAC with scalar (e16->e32)
    asm volatile("vwmacc.vx v8, %0, v2" ::"r"(scalar_i16)); printf("  VWMACC.VX (e16->e32)\n");
    asm volatile("vwmaccu.vx v8, %0, v2" ::"r"(scalar_i16)); printf("  VWMACCU.VX (e16->e32)\n");
    asm volatile("vwmaccsu.vx v8, %0, v2" ::"r"(scalar_i16)); printf("  VWMACCSU.VX (e16->e32)\n");
    asm volatile("vwmaccus.vx v8, %0, v2" ::"r"(scalar_i16)); printf("  VWMACCUS.VX (e16->e32)\n");
    
    // Note: Integer narrowing (vnsrl/vnsra) requires ELEN=64 (RVD extension)
    // Skipped for 32-bit only configuration
    
    // Load/Store
    asm volatile("vsetvli zero, %0, e32, m4, ta, ma" ::"r"(VEC_SIZE));
    asm volatile("vse32.v v0, (%0)" ::"r"(vec_ic)); printf("  VSE32.V\n");
    asm volatile("vle32.v v4, (%0)" ::"r"(vec_ic)); printf("  VLE32.V\n");
    asm volatile("vlse32.v v4, (%0), %1" ::"r"(vec_ic), "r"(8)); printf("  VLSE32.V (strided)\n");
    asm volatile("vsse32.v v4, (%0), %1" ::"r"(vec_ic), "r"(8)); printf("  VSSE32.V (strided)\n");
    
    // Indexed load/store
    for (int i = 0; i < VEC_SIZE; i++) vec_ia[i] = i * 4;
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_ia));
    asm volatile("vluxei32.v v4, (%0), v0" ::"r"(vec_ib)); printf("  VLUXEI32.V (indexed)\n");
    asm volatile("vsuxei32.v v4, (%0), v0" ::"r"(vec_ic)); printf("  VSUXEI32.V (indexed)\n");
    
    // ==================== VECTOR INTEGER (e16) ====================
    printf("[SNITCH] Testing Vector Integer Instructions (e16):\n");
    asm volatile("vsetvli zero, %0, e16, m2, ta, ma" ::"r"(VEC_SIZE*2));
    for (int i = 0; i < VEC_SIZE*2; i++) {
        vec_i16a[i] = i + 1;
        vec_i16b[i] = i * 2;
    }
    asm volatile("vle16.v v0, (%0)" ::"r"(vec_i16a)); printf("  VLE16.V\n");
    asm volatile("vle16.v v2, (%0)" ::"r"(vec_i16b));
    asm volatile("vadd.vv v4, v0, v2"); printf("  VADD.VV (e16)\n");
    asm volatile("vmul.vv v4, v0, v2"); printf("  VMUL.VV (e16)\n");
    asm volatile("vse16.v v4, (%0)" ::"r"(vec_i16a)); printf("  VSE16.V\n");
    
    // ==================== VECTOR INTEGER (e8) ====================
    printf("[SNITCH] Testing Vector Integer Instructions (e8):\n");
    asm volatile("vsetvli zero, %0, e8, m2, ta, ma" ::"r"(VEC_SIZE*4));
    volatile int8_t *vec_i8a = (volatile int8_t *)VEC_A_BASE;
    volatile int8_t *vec_i8b = (volatile int8_t *)VEC_B_BASE;
    for (int i = 0; i < VEC_SIZE*4; i++) {
        vec_i8a[i] = i + 1;
        vec_i8b[i] = i * 2;
    }
    asm volatile("vle8.v v0, (%0)" ::"r"(vec_i8a)); printf("  VLE8.V\n");
    asm volatile("vle8.v v2, (%0)" ::"r"(vec_i8b));
    asm volatile("vadd.vv v4, v0, v2"); printf("  VADD.VV (e8)\n");
    asm volatile("vmul.vv v4, v0, v2"); printf("  VMUL.VV (e8)\n");
    asm volatile("vse8.v v4, (%0)" ::"r"(vec_i8a)); printf("  VSE8.V\n");
    
    // Reset to e32 for FP tests
    asm volatile("vsetvli zero, %0, e32, m4, ta, ma" ::"r"(VEC_SIZE));
    
    // ==================== VECTOR FP (e32 - single precision) ====================
    printf("[SNITCH] Testing Vector FP Instructions (e32):\n");
    
    // Riusa gli stessi buffer L1
    for (int i = 0; i < VEC_SIZE; i++) {
        vec_a[i] = (float)(i + 1);
        vec_b[i] = (float)(i * 2);
    }
    
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vle32.v v4, (%0)" ::"r"(vec_b));
    
    // Arithmetic VV
    asm volatile("vfadd.vv v8, v0, v4"); printf("  VFADD.VV (e32)\n");
    asm volatile("vfsub.vv v8, v0, v4"); printf("  VFSUB.VV (e32)\n");
    asm volatile("vfmul.vv v8, v0, v4"); printf("  VFMUL.VV (e32)\n");
    
    // Arithmetic VF
    float scalar_f = 2.5f;
    asm volatile("vfadd.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFADD.VF (e32)\n");
    asm volatile("vfsub.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFSUB.VF (e32)\n");
    asm volatile("vfrsub.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFRSUB.VF (e32)\n");
    asm volatile("vfmul.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFMUL.VF (e32)\n");
    
    // Min/Max
    asm volatile("vfmin.vv v8, v0, v4"); printf("  VFMIN.VV (e32)\n");
    asm volatile("vfmax.vv v8, v0, v4"); printf("  VFMAX.VV (e32)\n");
    asm volatile("vfmin.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFMIN.VF (e32)\n");
    asm volatile("vfmax.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFMAX.VF (e32)\n");
    
    // Sign injection
    asm volatile("vfsgnj.vv v8, v0, v4"); printf("  VFSGNJ.VV (e32)\n");
    asm volatile("vfsgnjn.vv v8, v0, v4"); printf("  VFSGNJN.VV (e32)\n");
    asm volatile("vfsgnjx.vv v8, v0, v4"); printf("  VFSGNJX.VV (e32)\n");
    asm volatile("vfsgnj.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFSGNJ.VF (e32)\n");
    asm volatile("vfsgnjn.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFSGNJN.VF (e32)\n");
    asm volatile("vfsgnjx.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFSGNJX.VF (e32)\n");
    
    // FMA
    asm volatile("vle32.v v8, (%0)" ::"r"(vec_b));
    asm volatile("vfmadd.vv v0, v4, v8"); printf("  VFMADD.VV (e32)\n");
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vfmsub.vv v0, v4, v8"); printf("  VFMSUB.VV (e32)\n");
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vfnmadd.vv v0, v4, v8"); printf("  VFNMADD.VV (e32)\n");
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vfnmsub.vv v0, v4, v8"); printf("  VFNMSUB.VV (e32)\n");
    
    // MACC
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vle32.v v8, (%0)" ::"r"(vec_b));
    asm volatile("vfmacc.vv v8, v0, v4"); printf("  VFMACC.VV (e32)\n");
    asm volatile("vle32.v v8, (%0)" ::"r"(vec_b));
    asm volatile("vfmsac.vv v8, v0, v4"); printf("  VFMSAC.VV (e32)\n");
    asm volatile("vle32.v v8, (%0)" ::"r"(vec_b));
    asm volatile("vfnmacc.vv v8, v0, v4"); printf("  VFNMACC.VV (e32)\n");
    asm volatile("vle32.v v8, (%0)" ::"r"(vec_b));
    asm volatile("vfnmsac.vv v8, v0, v4"); printf("  VFNMSAC.VV (e32)\n");
    
    // Reductions
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vfmv.s.f v12, %0" ::"f"(0.0f));
    asm volatile("vfredosum.vs v12, v0, v12"); printf("  VFREDOSUM.VS (e32)\n");
    asm volatile("vfredusum.vs v12, v0, v12"); printf("  VFREDUSUM.VS (e32)\n");
    asm volatile("vfredmin.vs v12, v0, v12"); printf("  VFREDMIN.VS (e32)\n");
    asm volatile("vfredmax.vs v12, v0, v12"); printf("  VFREDMAX.VS (e32)\n");
    
    // Conversions
    asm volatile("vfcvt.xu.f.v v8, v0"); printf("  VFCVT.XU.F.V (e32)\n");
    asm volatile("vfcvt.x.f.v v8, v0"); printf("  VFCVT.X.F.V (e32)\n");
    asm volatile("vfcvt.rtz.xu.f.v v8, v0"); printf("  VFCVT.RTZ.XU.F.V (e32)\n");
    asm volatile("vfcvt.rtz.x.f.v v8, v0"); printf("  VFCVT.RTZ.X.F.V (e32)\n");
    asm volatile("vfcvt.f.xu.v v0, v8"); printf("  VFCVT.F.XU.V (e32)\n");
    asm volatile("vfcvt.f.x.v v0, v8"); printf("  VFCVT.F.X.V (e32)\n");
    
    // Move/Slide
    asm volatile("vfmv.v.f v8, %0" ::"f"(scalar_f)); printf("  VFMV.V.F (e32)\n");
    asm volatile("vfmv.s.f v8, %0" ::"f"(scalar_f)); printf("  VFMV.S.F (e32)\n");
    asm volatile("vfmv.f.s %0, v0" :"=f"(result_f)); printf("  VFMV.F.S (e32)\n");
    
    // Reload fresh data for slide operations
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vfslide1up.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFSLIDE1UP.VF (e32)\n");
    asm volatile("vfslide1down.vf v8, v0, %0" ::"f"(scalar_f)); printf("  VFSLIDE1DOWN.VF (e32)\n");

    printf("  [SKIPPED] Vector FP comparisons and VFCLASS.V not supported\n");
    
    // ==================== VECTOR FP (e16 - half precision) ====================
    printf("[SNITCH] Testing Vector FP Instructions (e16):\n");
    asm volatile("vsetvli zero, %0, e16, m2, ta, ma" ::"r"(VEC_SIZE*2));
    volatile __fp16 *vec_h = (volatile __fp16 *)VEC_A_BASE;
    for (int i = 0; i < VEC_SIZE*2; i++) vec_h[i] = (__fp16)(i + 1);
    asm volatile("vle16.v v0, (%0)" ::"r"(vec_h));
    asm volatile("vle16.v v2, (%0)" ::"r"(vec_h));
    asm volatile("vfadd.vv v4, v0, v2"); printf("  VFADD.VV (e16)\n");
    asm volatile("vfmul.vv v4, v0, v2"); printf("  VFMUL.VV (e16)\n");
    asm volatile("vfmacc.vv v4, v0, v2"); printf("  VFMACC.VV (e16)\n");
    
    // Widening FP16->FP32
    asm volatile("vfwadd.vv v8, v0, v2"); printf("  VFWADD.VV (e16->e32)\n");
    asm volatile("vfwsub.vv v8, v0, v2"); printf("  VFWSUB.VV (e16->e32)\n");
    asm volatile("vfwmul.vv v8, v0, v2"); printf("  VFWMUL.VV (e16->e32)\n");
    asm volatile("vfwmacc.vv v8, v0, v2"); printf("  VFWMACC.VV (e16->e32)\n");
    asm volatile("vfwnmacc.vv v8, v0, v2"); printf("  VFWNMACC.VV (e16->e32)\n");
    asm volatile("vfwmsac.vv v8, v0, v2"); printf("  VFWMSAC.VV (e16->e32)\n");
    asm volatile("vfwnmsac.vv v8, v0, v2"); printf("  VFWNMSAC.VV (e16->e32)\n");
    
    // Narrowing FP32->FP16 
    asm volatile("vsetvli zero, %0, e16, m2, ta, ma" ::"r"(VEC_SIZE*2));
    asm volatile("vsetvli zero, %0, e32, m4, ta, ma" ::"r"(VEC_SIZE));  // Load e32 data
    asm volatile("vle32.v v0, (%0)" ::"r"(vec_a));
    asm volatile("vsetvli zero, %0, e16, m2, ta, ma" ::"r"(VEC_SIZE*2)); // Set for narrowing output
    asm volatile("vfncvt.f.f.w v8, v0"); printf("  VFNCVT.F.F.W (e32->e16)\n");
    asm volatile("vfncvt.xu.f.w v8, v0"); printf("  VFNCVT.XU.F.W (e32->e16)\n");
    asm volatile("vfncvt.x.f.w v8, v0"); printf("  VFNCVT.X.F.W (e32->e16)\n");
    asm volatile("vfncvt.rtz.xu.f.w v8, v0"); printf("  VFNCVT.RTZ.XU.F.W (e32->e16)\n");
    asm volatile("vfncvt.rtz.x.f.w v8, v0"); printf("  VFNCVT.RTZ.X.F.W (e32->e16)\n");
    
    printf("[SNITCH] ==== Test completed ====\n");
    return 0;
}
