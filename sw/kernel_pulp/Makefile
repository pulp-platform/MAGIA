# Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
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
# PULP cluster task Makefile for MAGIA.
#
# Mirrors spatz/sw/Makefile: builds a position-independent flat binary
# from <TEST_NAME>'s pulp_task sources and packs it into
#   sw/kernel_pulp/headers_bin/<TEST_NAME>_pulp_task_bin.h
# so the main CV32 ELF can KEEP it inside the .pulp_binary section.
#
# Invocation (from top-level Makefile):
#   make -C sw/kernel_pulp TEST_NAME=<test> task="<task1> <task2>"
#                          PULP_TASK_DIR=<absolute path>

ISA      ?= riscv
ARCH     ?= rv
XLEN     ?= 32
core     ?= CV32E40P

ifeq ($(core), CV32E40X)
  XTEN := imafc
  CC      = $(ISA)$(XLEN)-unknown-elf-gcc
  OBJCOPY = $(ISA)$(XLEN)-unknown-elf-objcopy
  OBJDUMP = $(ISA)$(XLEN)-unknown-elf-objdump
  XABI :=f
  ABI  := ilp
else ifeq ($(core), RI5CY)
  XTEN := imcxgap9
  CC      = riscv$(XLEN)-unknown-elf-gcc
  OBJCOPY = riscv$(XLEN)-unknown-elf-objcopy
  OBJDUMP = riscv$(XLEN)-unknown-elf-objdump
  XABI :=
  ABI  := ilp
else
  # CV32E40P with ZFINX=1 (FP ops on GPRs) — see top Makefile.
  XTEN := imc_xcvalu_xcvbi_xcvbitmanip_xcvhwlp_xcvmac_xcvmem_xcvsimd_xcvelw_zfinx_zhinxmin
  CC      = riscv64-unknown-elf-gcc
  OBJCOPY = riscv64-unknown-elf-objcopy
  OBJDUMP = riscv64-unknown-elf-objdump
  XABI :=
  ABI  := ilp
endif

TEST_NAME      ?= base_pulp_test
task           ?=
PULP_TASK_DIR  ?=

ARCH_FLAGS = -march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI)
# -msmall-data-limit=0: never use gp/zero-relative addressing for globals.
#     Required because the PIC binary is linked with ORIGIN=0, so .sdata
#     symbols would otherwise be accessed via `lw rd, imm(zero)`, which
#     hits MMIO addresses (iDMA CTRL at 0x200-0x5FF) instead of the
#     embedded binary's relocated data section.
# -mno-relax: prevent the linker from collapsing auipc+addi back into li
#     for small absolute values (would also break PIC at runtime).
# -fno-jump-tables: switch statements otherwise compile to a jump table
#     whose base address is referenced ABSOLUTELY (e.g. `li a4, 0x618`).
#     Since this binary is linked at ORIGIN=0 but copied/relocated to
#     0xCC00_xxxx at runtime without a dynamic loader, that absolute base
#     is never fixed up: the indirect jump lands in unmapped space and the
#     cluster icache stalls forever on a fill that loops in the NoC.
#     Forcing compare-chains keeps every branch PC-relative (PIC-safe).
#     Affects all cores (CV32E40P/RI5CY) and both mesh_dv settings.
CFLAGS     = $(ARCH_FLAGS) -O2 -g -Wall -Wextra -Wno-unused-parameter \
             -Wno-unused-variable -Wno-unused-function -Wundef \
             -ffunction-sections -fdata-sections \
             -fPIC -mcmodel=medany \
             -fno-jump-tables \
             -msmall-data-limit=0 \
             -nostartfiles -nostdlib \
             -DPULP_CORE_COUNT=$(PULP_CORE_COUNT) \
             -D$(core) -U__riscv__
CFLAGS    += -I../utils -I../../hw/include -I.
# RI5CY toolchain (riscv32-unknown-elf-gcc / gap9 binutils) uses an older
# assembler that does not recognise the 3-operand FLW pseudo-instruction
# `flw rd, symbol, rt` emitted by newer gcc when rv32*f* is in the march.
# -mexplicit-relocs forces gcc to emit lui+flw(%hi/%lo) instead.
ifeq ($(core), RI5CY)
CFLAGS    += -mexplicit-relocs
endif

LDFLAGS   = $(ARCH_FLAGS) -nostartfiles -nostdlib \
            -Wl,--gc-sections -Wl,--allow-multiple-definition \
            -Wl,-T,$(KERNEL_DIR)/pulp_program.ld
comma := ,
TASK_UNDEF_FLAGS = $(foreach t,$(task),-Wl$(comma)--undefined=$(t))

PULP_CORE_COUNT ?= 8

BINARY_NAME = $(TEST_NAME)_pulp_task_bin
HEADER_NAME = $(TEST_NAME)_pulp_task_bin

BIN_DIR    = bin
HEADER_DIR = headers_bin
KERNEL_DIR = .

# Task source files (resolved against PULP_TASK_DIR if provided, otherwise
# expected to be space-separated absolute/relative paths).
ifeq ($(PULP_TASK_DIR),)
TASK_SRCS = $(task)
else
TASK_SRCS = $(addprefix $(PULP_TASK_DIR)/,$(addsuffix .c,$(task)))
endif

CRT0      = $(KERNEL_DIR)/pulp_crt0.S
CRT0_OBJ  = $(BIN_DIR)/$(TEST_NAME)_pulp_crt0.o
ELF       = $(BIN_DIR)/$(BINARY_NAME).elf
BIN       = $(BIN_DIR)/$(BINARY_NAME).bin
DUMP      = $(BIN_DIR)/$(BINARY_NAME).dump
HEADER    = $(HEADER_DIR)/$(HEADER_NAME).h

BIN2HEADER = ../../scripts/bin2header.py

.PHONY: all clean dirs bin header

all: bin
	@rm -f $(HEADER)
	@$(MAKE) header

bin: dirs $(BIN) $(DUMP)
header: dirs $(HEADER)

dirs:
	@mkdir -p $(BIN_DIR) $(HEADER_DIR)

$(CRT0_OBJ): $(CRT0)
	@echo "[PULP] Compiling crt0..."
	$(CC) $(ARCH_FLAGS) -DPULP_CORE_COUNT=$(PULP_CORE_COUNT) -c -o $@ $(CRT0)

$(ELF): $(CRT0_OBJ) $(TASK_SRCS) $(KERNEL_DIR)/pulp_program.ld
	@if [ -z "$(TASK_SRCS)" ]; then \
		echo "[PULP] ERROR: No task sources for task=$(task)"; \
		exit 1; \
	fi
	@echo "[PULP] Building ELF (tasks: $(task))"
	$(CC) $(CFLAGS) $(LDFLAGS) $(TASK_UNDEF_FLAGS) -o $@ $(CRT0_OBJ) $(TASK_SRCS)

$(BIN): $(ELF)
	@echo "[PULP] Generating flat binary..."
	$(OBJCOPY) -O binary $< $@

$(DUMP): $(ELF)
	@echo "[PULP] Generating disassembly..."
	$(OBJDUMP) -D -S $< > $@

$(HEADER): $(BIN) $(ELF)
	@echo "[PULP] Generating header..."
	@python3 $(BIN2HEADER) $(BIN) $(HEADER) \
		--name $(HEADER_NAME) \
		--section .pulp_binary \
		--address "dynamic (_pulp_binary_start)"
	@GUARD=$$(echo "$(HEADER_NAME)" | tr 'a-z' 'A-Z'); \
	sed -i "/#endif \/\* __$${GUARD}_H__ \*\//d" $(HEADER)
	@echo "" >> $(HEADER)
	@echo "/* Binary start address - defined by CV32 linker */" >> $(HEADER)
	@echo "extern uint32_t _pulp_binary_start;" >> $(HEADER)
	@echo "#define PULP_BINARY_START ((uint32_t)&_pulp_binary_start)" >> $(HEADER)
	@echo "" >> $(HEADER)
	@echo "/* PULP task entry points (offset from PULP_BINARY_START).            */" >> $(HEADER)
	@echo "/* Extracted from $(BINARY_NAME).elf: any global function whose name */" >> $(HEADER)
	@echo "/* contains \"task\" becomes a dispatchable entry point.              */" >> $(HEADER)
	@$(OBJDUMP) -t $(ELF) | \
		awk '$$2 == "g" && $$4 ~ /^\.text/ && $$NF ~ /task/ { \
			name = $$NF; upper = toupper(name); \
			printf "#define %s (PULP_BINARY_START + 0x%s)\n", upper, $$1 \
		}' >> $(HEADER)
	@echo "" >> $(HEADER)
	@GUARD=$$(echo "$(HEADER_NAME)" | tr 'a-z' 'A-Z'); \
	echo "#endif /* __$${GUARD}_H__ */" >> $(HEADER)

clean:
	rm -rf $(BIN_DIR) $(HEADER_DIR)

.PRECIOUS: $(ELF) $(BIN)
