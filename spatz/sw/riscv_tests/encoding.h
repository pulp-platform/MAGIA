/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
 * Author: Luca Balboni, Fondazione Chips-IT
 *
 * RISC-V CSR definitions used by the riscvTests
 */
#ifndef ENCODING_H
#define ENCODING_H

#define MSTATUS_VS 0x00000600
#define MSTATUS_FS 0x00006000

#define read_csr(reg) ({ unsigned long __tmp; asm volatile("csrr %0, " #reg : "=r"(__tmp)); __tmp; })

#endif
