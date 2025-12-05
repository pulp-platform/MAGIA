# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Spatz Initialization ROM Makefile for MAGIA Tile

# Toolchain (use GCC for bootrom - no vectors needed)
# Using system module pulp-gcc11/2.6.0
# Match Spatz Cluster bootrom: rv32imaf + ilp32
# Load with: module load pulp-gcc11/2.6.0
GCC_INSTALL_DIR ?= /sw/tool/riscv/pulp-gcc11/v2.6.0

ISA      ?= riscv
ARCH     ?= rv
XLEN     ?= 32
XTEN     := imaf
ABI      ?= ilp
XABI     ?= 32

CC      = $(GCC_INSTALL_DIR)/bin/$(ISA)$(XLEN)-unknown-elf-gcc
OBJCOPY = $(GCC_INSTALL_DIR)/bin/$(ISA)$(XLEN)-unknown-elf-objcopy
OBJDUMP = $(GCC_INSTALL_DIR)/bin/$(ISA)$(XLEN)-unknown-elf-objdump

# Compiler flags for bootrom (base + mul/div + FP single, NO compressed)
# Matches Spatz Cluster: -mabi=ilp32 -march=rv32imaf
CFLAGS  = -march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XABI) -static -nostartfiles -nostdlib
CFLAGS += -O2 -g -Wall -Wextra

# Linker flags
LDFLAGS = -T spatz_init.ld

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
