#
# Copyright (C) 2018-2019 ETH Zurich and University of Bologna
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
#

import numpy as np
import sys

# Default memory layout: main-core ELF at 0xCC000000.
# Override with optional argv[4] (instr base) and argv[5] (data base)
# for the PULP cluster-core ELF which lives at 0xC0000000 / 0xC0100000.
DEFAULT_MEM_START  = 0xcc000000
DEFAULT_DATA_OFFSET = 0x10000  # data = instr_base + 0x10000 (main) or explicit

if len(sys.argv) >= 5:
    MEM_START = int(sys.argv[4], 16)
else:
    MEM_START = DEFAULT_MEM_START

if len(sys.argv) >= 6:
    DATA_BASE = int(sys.argv[5], 16)
else:
    DATA_BASE = MEM_START + DEFAULT_DATA_OFFSET

INSTR_SIZE = 0x8000
INSTR_END  = MEM_START + INSTR_SIZE
DATA_SIZE  = 0x30000
DATA_END   = DATA_BASE + DATA_SIZE
STACK_BASE = 0x10000
STACK_SIZE = 0x10000
STACK_END  = STACK_BASE + STACK_SIZE

INSTR_MEM_SIZE = INSTR_SIZE
DATA_MEM_SIZE  = DATA_SIZE + STACK_SIZE

with open(sys.argv[1], "r") as f:
    s = f.read()

if len(sys.argv) >= 4:
    instr_txt = sys.argv[2]
    data_txt  = sys.argv[3]
else:
    instr_txt = "stim_instr.txt"
    data_txt  = "stim_data.txt"

instr_mem = np.zeros(INSTR_MEM_SIZE, dtype='int')
data_mem  = np.zeros(DATA_MEM_SIZE,  dtype='int')

for l in s.split():
    addr = int(l[0:8]  , 16)
    whhh = int(l[9:11] , 16)
    whhl = int(l[11:13], 16)
    whlh = int(l[13:15], 16)
    whll = int(l[15:17], 16)
    wlhh = int(l[17:19], 16)
    wlhl = int(l[19:21], 16)
    wllh = int(l[21:23], 16)
    wlll = int(l[23:25], 16)
    rel_data_addr = addr - DATA_BASE
    rel_imem_addr = addr - MEM_START
    if addr >= DATA_BASE and addr < DATA_END:
        data_mem [int(rel_data_addr)    ] = wlll
        data_mem [int(rel_data_addr) + 1] = wllh
        data_mem [int(rel_data_addr) + 2] = wlhl
        data_mem [int(rel_data_addr) + 3] = wlhh
        data_mem [int(rel_data_addr) + 4] = whll
        data_mem [int(rel_data_addr) + 5] = whlh
        data_mem [int(rel_data_addr) + 6] = whhl
        data_mem [int(rel_data_addr) + 7] = whhh
    elif addr >= MEM_START and  addr < INSTR_END:
        instr_mem[int(rel_imem_addr)    ] = wlll
        instr_mem[int(rel_imem_addr) + 1] = wllh
        instr_mem[int(rel_imem_addr) + 2] = wlhl
        instr_mem[int(rel_imem_addr) + 3] = wlhh
        instr_mem[int(rel_imem_addr) + 4] = whll
        instr_mem[int(rel_imem_addr) + 5] = whlh
        instr_mem[int(rel_imem_addr) + 6] = whhl
        instr_mem[int(rel_imem_addr) + 7] = whhh

s = ""
s += "@%08x\n" % MEM_START
for m in instr_mem:
    s += "%02x\n" % m
with open(instr_txt, "w") as f:
    f.write(s)

s = ""
s += "@%08x\n" % DATA_BASE
for m in data_mem:
    s += "%02x\n" % m
with open(data_txt, "w") as f:
    f.write(s.rstrip('\n'))