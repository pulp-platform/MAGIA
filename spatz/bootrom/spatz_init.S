/*
 * Copyright (C) 2018-2019 ETH Zurich and University of Bologna
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
 * 
 * Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
 *  
 * All initialization (stack, regs, vector, BSS) done in spatz_crt0.S  
 * Minimal Boot ROM - only read FUNC_PTR and jump
 */

#define TASKBIN_ADDR 0x00001708  // OBI slave ctrl exchange register

  .section .text.bootrom
  .global _start
  .option norvc

_start:
  // Read dispatcher loop address from TASKBIN_REG (set by CV32)
  li      t0, TASKBIN_ADDR
  lw      t1, 0(t0)
  
  // Jump to _start in spatz binary (does all init)
  jr      t1
