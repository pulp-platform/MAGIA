# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Spatz Programs Makefile for MAGIA Tile

# Toolchain - LLVM for vector extension support
LLVM_PATH ?= /sw/tool/riscv/snitch-llvm/0.12.0

ISA      ?= riscv
ARCH     ?= rv
XLEN     ?= 32
XTEN     := imafv0p10  # MAGIA Spatz: I+M+A+F(SP)+V0.10
ABI      ?= ilp
XABI     ?= 32f

# Toolchain paths
CC      = $(LLVM_PATH)/bin/clang
OBJCOPY = $(LLVM_PATH)/bin/llvm-objcopy
OBJDUMP = $(LLVM_PATH)/bin/llvm-objdump

# Architecture flags
ARCH_FLAGS   = --target=riscv32 -march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XABI)
ARCH_FLAGS  += -menable-experimental-extensions

# Compiler flags
CFLAGS       = $(ARCH_FLAGS) -static -nostartfiles -nostdlib
CFLAGS      += -O2 -g -Wall -Wextra
CFLAGS      += -fno-common -ffunction-sections -fdata-sections
CFLAGS      += -mcmodel=medany
CFLAGS      += -I../../sw/utils -I../../hw/include
CFLAGS      += -DTINYPRINTF_DEFINE_TFP_SPRINTF=0

# Linker flags
LDFLAGS      = -T spatz_program.ld -fuse-ld=lld
LDFLAGS     += -Wl,--gc-sections -Wl,-z,norelro
LDFLAGS     += $(ARCH_FLAGS)

# Test name (pass with test=name)
test        ?= hello_spatz

# Directories
BIN_DIR      = bin
HEADER_DIR   = headers
TESTS_DIR    = tests

# Source and output files
SRC          = $(TESTS_DIR)/$(test).c
ELF          = $(BIN_DIR)/$(test).elf
BIN          = $(BIN_DIR)/$(test).bin
DUMP         = $(BIN_DIR)/$(test).dump
HEADER       = $(HEADER_DIR)/$(test).h

# Python script for bin2header conversion
BIN2HEADER   = ../../scripts/bin2header.py

.PHONY: all clean bin header dirs

# Complete build: clean, compile binary, generate header
all: clean bin header

# Build binary (ELF + BIN + DUMP)
bin: dirs $(BIN) $(DUMP)

# Generate header from binary
header: dirs $(HEADER)

# Create directories
dirs:
	@mkdir -p $(BIN_DIR) $(HEADER_DIR)

# Build ELF executable
$(ELF): $(SRC) spatz_program.ld
	@mkdir -p $(BIN_DIR)
	@echo "[SPATZ] Compiling $(test).c ..."
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(SRC)

# Generate binary from ELF
$(BIN): $(ELF)
	@echo "[SPATZ] Generating binary..."
	$(OBJCOPY) -O binary $< $@

# Generate disassembly
$(DUMP): $(ELF)
	@echo "[SPATZ] Generating disassembly..."
	$(OBJDUMP) -D -S $< > $@

# Generate header file with inline binary array
$(HEADER): $(BIN)
	@mkdir -p $(HEADER_DIR)
	@echo "[SPATZ] Generating header..."
	python3 $(BIN2HEADER) $(BIN) $(HEADER) \
		--name $(subst -,_,$(test))_binary \
		--section .spatz_binary \
		--address 0x00000000

clean:
	rm -rf $(BIN_DIR)/*.elf $(BIN_DIR)/*.bin $(BIN_DIR)/*.dump
	rm -rf $(HEADER_DIR)/*.h

.PRECIOUS: $(ELF) $(BIN)
