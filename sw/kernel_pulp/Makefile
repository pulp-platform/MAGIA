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

zfinx ?= 1
XTEN_BASE := xcvalu_xcvbi_xcvbitmanip_xcvhwlp_xcvmac_xcvmem_xcvsimd_xcvelw
ifeq ($(zfinx),1)
  # zhinxmin deliberatamente assente: PLAY non usa half-precision e il .text
# risulta byte-identico con o senza, ma cosi' la stringa -march coincide
# esattamente con quella del build standalone di PLAY (verificato via
# DW_AT_producer sui due ELF), togliendo una variabile dal confronto.
XTEN := imc_$(XTEN_BASE)_zfinx
  XABI :=
else
  XTEN := imfc_$(XTEN_BASE)
  XABI := f
endif
CC      = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump
READELF = riscv64-unknown-elf-readelf
ABI  := ilp

TEST_NAME      ?= base_pulp_test
task           ?=
PULP_TASK_DIR  ?=

CV32E40P_TUNE := $(shell $(CC) -mtune=cv32e40p -E -x c /dev/null >/dev/null 2>&1 && echo -mtune=cv32e40p)

ARCH_FLAGS = -march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) $(CV32E40P_TUNE)

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
#     Affects both mesh_dv settings.
# -fno-semantic-interposition: restores inlining parity with the standalone
#     pulp_cluster build of PLAY. The task wrappers neutralise `static` around
#     their PLAY #includes (see sw/utils/play_l1_linkage.h -- required so the
#     PI_L1 variables get external linkage, hence a GOT entry the crt0 fixup
#     can keep absolute). That also strips `static` from PLAY's helper
#     FUNCTIONS, and with -fPIC GCC then assumes they may be interposed and
#     refuses to inline them -- while the standalone, where they are still
#     `static inline`, inlines them. Measured out-of-line calls left in the
#     kernel body, before -> after:
#         linalg_lu_decomp   (swap_elems, swap_rows, set_permutation_identity)  3 -> 1
#         linalg_svd_jacobi  (barrier, on the hot path across 200 Jacobi sweeps) 8 -> 0
#     The other four kernels with `static inline` helpers (cholesky, gemv,
#     gemv_trans, lu_solve) were already being inlined and are unaffected.
#     Verified NOT to disturb the .l1data mechanism: every PI_L1 symbol keeps
#     its R_RISCV_GOT_HI20 relocation with the flag on (checked on
#     lu_decomp, svd_jacobi, cholesky and svd) -- the flag changes function
#     inlining only, not how variables are addressed.
CFLAGS     = $(ARCH_FLAGS) -O3 -g -Wall -Wextra -Wno-unused-parameter \
             -Wno-unused-variable -Wno-unused-function -Wundef \
             -ffunction-sections -fdata-sections \
             -fPIC -mcmodel=medany \
             -fno-semantic-interposition \
             -fno-jump-tables \
             -msmall-data-limit=0 \
             -mno-relax \
             -nostartfiles -nostdlib \
             -DPULP_CORE_COUNT=$(PULP_CORE_COUNT) \
             -D$(core) -U__riscv__
CFLAGS    += -I../utils -I../../hw/include -I.

# PLAY (submodule) include path and cluster/core count for pulp_program.ld
CFLAGS    += -I../../PLAY/include -DCLUSTER=1 -DNUM_CORES=$(PULP_CORE_COUNT)

# Parita' con il build standalone di PLAY (verificato via DW_AT_producer):
# impedisce a GCC di trasformare i loop di copia/azzeramento in chiamate a
# memcpy/memset. Lo standalone ce l'ha; senza, MAGIA potrebbe generare quelle
# chiamate (che con -nostdlib non esistono) e comunque codegen diverso sui
# kernel di copia (matrix_memcpy, vector_memcpy, *_set_all).
# Verificato: su linalg_cholesky_decomp il .text e' byte-identico con e senza,
# quindi e' pura parita' di flag a costo zero.
CFLAGS    += -fno-tree-loop-distribute-patterns

# PLAY parity: 4 of PLAY's own pulp-open Makefiles opt these specific kernels
# into -ffast-math (test/vector_min, linalg_cholesky_decomp, linalg_svd_jacobi,
# linalg_svd -- see each one's pulp-open/Makefile APP_CFLAGS, all at line 22).
# Without it here, MAGIA's build picks a branch-heavy `flt.s`+branch sequence
# for `a<b?a:b` where -ffast-math unlocks the branchless `fmin.s` on the
# standalone side (verified: same corev-gcc v0.3, same PLAY source, only
# -ffast-math flips fmin.s count 0->7). The 3 sqrtf() kernels also add
# -fno-math-errno there; no -lm here (-nostdlib, and sqrtf already lowers to
# a bare fsqrt.s in this build without it -- see PIC_CALL_OVERHEAD.md-style
# verification before adding -lm if that ever stops being true).
FAST_MATH_TESTS := vector_min linalg_cholesky_decomp linalg_svd_jacobi linalg_svd
ifneq ($(filter $(TEST_NAME),$(FAST_MATH_TESTS)),)
CFLAGS    += -ffast-math
endif
SQRTF_TESTS := linalg_cholesky_decomp linalg_svd_jacobi linalg_svd linalg_svd_lsv
ifneq ($(filter $(TEST_NAME),$(SQRTF_TESTS)),)
CFLAGS    += -fno-math-errno
endif

# matrix_set_all: at -O3 with -fPIC, GCC's basic-block reordering pass places
# the CORE-V hardware-loop setup (cv.starti/cv.endi) *after* the loop body, so
# the setup refers backwards to the body -- but the hwloop immediate is uimm12,
# unsigned and forward-only, so the link fails with
# "R_RISCV_CVPCREL_UI12 relocation truncated to fit".
# -fno-reorder-blocks keeps the setup before the body and fixes it while
# preserving -O3 *and* the hardware loops themselves (verified: 3 hwloops in
# the linked binary), so the codegen stays as close as possible to PLAY's own
# pulp-open build. Earlier workarounds were worse: #pragma GCC optimize("Os")
# dropped the whole TU to -Os, and stripping _xcvhwlp from -march removed the
# hardware loops that the standalone keeps.
REORDER_BROKEN_TESTS := matrix_set_all
ifneq ($(filter $(TEST_NAME),$(REORDER_BROKEN_TESTS)),)
CFLAGS    += -fno-reorder-blocks
endif

# stats=1: enable PLAY-style HOTTING/REPEAT cycle-count reporting (sw/utils/stats.h)
stats ?= 0
ifeq ($(stats),1)
CFLAGS    += -DSTATS
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
	@# .l1data holds variables whose VMA is an ABSOLUTE TCDM address and which
	@# are deliberately not relocated with the PIC blob. GCC reaches a symbol
	@# with internal linkage (`static`) via a direct PC-relative auipc+lw
	@# rather than the GOT, so such a symbol resolves to blob_base + its VMA --
	@# past the 32 KB instruction RAM, into uninitialised L2 -- and silently
	@# reads 0. pulp_crt0.S's fixup only keeps GOT entries absolute, so it
	@# cannot catch that. Only external-linkage symbols are safe here.
	@# See sw/utils/play_l1_linkage.h.
	@idx=$$($(READELF) -S $@ | sed 's/\[ *\([0-9]*\)\]/\1/' | \
	        awk '$$2==".l1data" {print $$1; exit}'); \
	if [ -n "$$idx" ]; then \
		bad=$$($(READELF) -s $@ | \
		       awk -v i="$$idx" '$$7==i && $$5=="LOCAL" && $$4=="OBJECT" {printf "%s ", $$8}'); \
		if [ -n "$$bad" ]; then \
			echo "[PULP] ERROR: internal-linkage symbol(s) in .l1data: $$bad"; \
			echo "[PULP]        These would be addressed PC-relative and read 0 at runtime."; \
			echo "[PULP]        Give them external linkage (see sw/utils/play_l1_linkage.h)."; \
			rm -f $@; \
			exit 1; \
		fi; \
	fi

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
