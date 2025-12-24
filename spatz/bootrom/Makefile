# Copyright (C) 2023-2024 ETH Zurich and University of Bologna
#
# Licensed under the Solderpad Hardware License, Version 0.51 
# (the "License"); you may not use this file except in compliance 
# with the License. You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: SHL-0.51
#
# Authors: Luca Balboni <luca.balboni10@studio.unibo.it>
# Spatz Initialization ROM Makefile for MAGIA Tile

# Using Spatz LLVM toolchain
LLVM_PATH := /sw/scratch/luca.balboni10/SPATZ/install/llvm

# Configuration from top-level Makefile
SPATZ_RVD      ?= 0   # 0: ELEN=32, 1: ELEN=64
SPATZ_VLEN     ?= 256 # Vector length in bits
SPATZ_N_IPU    ?= 1   # Number of Integer Processing Units (1-8)
SPATZ_N_FPU    ?= 4   # Number of Floating Point Units (1-8)
SPATZ_XDIVSQRT ?= 0   # 0: FP div/sqrt disabled, 1: enabled
SPATZ_XDMA     ?= 0   # 0: DMA disabled, 1: enabled
SPATZ_RVF      ?= 1   # 0: single-precision FP disabled, 1: enabled
SPATZ_RVV      ?= 1   # 0: vector extension disabled, 1: enabled

ISA      ?= riscv
ARCH     ?= rv
XLEN     ?= 32

# Build ISA string dynamically based on configuration flags
XTEN := ima
ifeq ($(SPATZ_RVD),1)
    XTEN := $(XTEN)fd
    XABI ?= 32d
else ifeq ($(SPATZ_RVF),1)
    XTEN := $(XTEN)f
    XABI ?= 32f
else
    XABI ?= 32
endif
ifeq ($(SPATZ_RVV),1)
    XTEN := $(XTEN)v
endif
XTEN := $(XTEN)_zfh
ABI  ?= ilp

CC      = $(LLVM_PATH)/bin/clang
OBJCOPY = $(LLVM_PATH)/bin/llvm-objcopy
OBJDUMP = $(LLVM_PATH)/bin/llvm-objdump

# Compiler flags (RVD=$(SPATZ_RVD), VLEN=$(SPATZ_VLEN), N_IPU=$(SPATZ_N_IPU), N_FPU=$(SPATZ_N_FPU), XDivSqrt=$(SPATZ_XDIVSQRT), Xdma=$(SPATZ_XDMA), RVF=$(SPATZ_RVF), RVV=$(SPATZ_RVV))
CFLAGS  = --target=$(ISA)$(XLEN)-unknown-elf -march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XABI)
CFLAGS += -DSPATZ_RVD=$(SPATZ_RVD) -DSPATZ_VLEN=$(SPATZ_VLEN) -DSPATZ_N_IPU=$(SPATZ_N_IPU) -DSPATZ_N_FPU=$(SPATZ_N_FPU) -DSPATZ_XDIVSQRT=$(SPATZ_XDIVSQRT) -DSPATZ_XDMA=$(SPATZ_XDMA) -DSPATZ_RVF=$(SPATZ_RVF) -DSPATZ_RVV=$(SPATZ_RVV)
CFLAGS += -static -nostartfiles -nostdlib -O2 -g -Wall -Wextra

# Linker flags
LDFLAGS = -T spatz_init.ld -fuse-ld=lld

# Files
SRC     = spatz_init.S
ELF     = spatz_init.elf
BIN     = spatz_init.bin
DUMP    = spatz_init.dump

.PHONY: all clean bin sv

# Build binary and dump files
bin: $(BIN) $(DUMP)

# Generate hardware bootrom SystemVerilog module from binary
sv: $(BIN)
	@echo "Generating hardware bootrom: ../../hw/tile/spatz_bootrom.sv"
	python3 ../../scripts/generate_spatz_bootrom.py $(BIN) -o ../../hw/tile/spatz_bootrom.sv

# Complete build: clean, compile binary, generate hardware module
all: clean bin sv

$(ELF): $(SRC) spatz_init.ld
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(SRC)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(DUMP): $(ELF)
	$(OBJDUMP) -D $< > $@

clean:
	rm -f $(ELF) $(BIN) $(DUMP)

.PRECIOUS: $(ELF) $(BIN)
