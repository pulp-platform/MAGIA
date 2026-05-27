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
# Authors: Yvan Tortorella <yvan.tortorella@unibo.it>
#          Victor Isachi <victor.isachi@unibo.it>
# 
# MAGIA Makefile
 

# Paths to folders
ROOT_DIR       := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
core           ?= CV32E40P

MAGIA_DIR  ?= $(shell pwd)

SW             ?= sw
BUILD_DIR      ?= sim/work
ifneq (,$(wildcard /etc/iis.version))
    QUESTA ?= questa-2025.1
    BENDER ?= bender
    BASE_PYTHON ?= python
else
    QUESTA ?=
    BENDER ?= ./bender
    BASE_PYTHON ?= python3
endif
BENDER_DIR     ?= .
ARCH           ?= rv
XLEN           ?= 32
ifeq ($(core), CV32E40X)
  XTEN = imafc
  ISA = riscv
  ABI            ?= ilp
  XABI           ?= f
else
  # CV32E40P configured with ZFINX=1 in RTL: FP ops use the GPRs (no F register
  # file). Toolchain must therefore use Zfinx (and Zhinxmin for FP16) and the
  # plain ilp32 ABI; using `f` in march or ilp32f ABI would emit instructions
  # that target the (non-existent) F regs.
  XTEN = imc_xcvalu_xcvbi_xcvbitmanip_xcvhwlp_xcvmac_xcvmem_xcvsimd_xcvelw_zfinx_zhinxmin
  ISA = cv32e40p
  ABI            ?= ilp
  XABI           ?=
endif

#ifeq ($(REDMULE_COMPLEX),1)
#	TEST_SRCS := sw/redmule_complex.c
#else
#	TEST_SRCS := sw/redmule.c
#endif

# Auto-detect test location under sw/tests/ recursively — no cluster= flag needed.
# A directory named $(test) is searched first (handles both sw/tests/<test>/ and
# sw/tests/cluster_tests/<test>/); single-file tests fall back to sw/tests/$(test).c.
# cluster= is still accepted for backward compatibility but its value is ignored.
cluster       ?= 0   # accepted for backward compat — value is ignored
num_clusters  ?= 16  # number of PULP cluster tiles (N_TILES for 4x4 mesh)

_FOUND_TEST_DIR  := $(shell find sw/tests -maxdepth 5 -type d -name "$(test)" 2>/dev/null | head -1)
TEST_DIR          = $(if $(_FOUND_TEST_DIR),$(patsubst %/,%,$(dir $(_FOUND_TEST_DIR))),sw/tests)
TEST_SUBDIR       = $(filter-out .,$(shell find $(TEST_DIR) -name "$(test).c" -printf "%P\n" 2>/dev/null | head -1 | xargs dirname 2>/dev/null))
# CV32-side test source. For cluster tests with a pulp_task/ subdirectory the
# entrypoint is main.c (handled in the $(OBJ) rule); for plain single-binary
# tests this matches the legacy $(test).c naming convention.
TEST_SRCS  = $(TEST_DIR)/$(if $(TEST_SUBDIR),$(TEST_SUBDIR)/)$(test).c

compile_script       ?= scripts/compile.tcl
compile_script_synth ?= scripts/synth_compile.tcl
compile_flag         ?= -suppress 2583 -suppress 13314 -suppress 3009

questa_compile_flag  += -t 1ns -suppress 3009
questa_opt_flag      += -suppress 3009 -debugdb +acc
questa_opt_fast_flag += -suppress 3009
questa_run_flag      += -t 1ns -debugDB -suppress 3009
questa_run_fast_flag += -t 1ns -suppress 3009

INI_PATH  = sim/modelsim.ini
WORK_PATH = $(BUILD_DIR)

# Useful Parameters
gui           ?= 0
ipstools      ?= 0
inst_hex_name ?= build/stim_instr.txt 
data_hex_name ?= build/stim_data.txt 
inst_entry    ?= 0xCC000000
data_entry    ?= 0xCC010000
boot_addr     ?= 0xCC000080
test          ?= hello_world
mesh_dv       ?= 1
fast_sim      ?= 0
# Add here a path to the core traces of each tile you want to monitor
num_cores     ?= 16
$(foreach i, $(shell seq 0 $(shell echo $$(($(num_cores)-1)))), \
	$(eval log_path_$(i) := ./core_$(i)_traces.log)               \
)
itb_file      ?= build/verif.itb

ifeq ($(verbose),1)
	FLAGS += -DVERBOSE
endif

ifeq ($(debug),1)
	FLAGS += -DDEBUG
endif

ifeq ($(core), CV32E40X)
  FLAGS += -DCV32E40X
endif

# Include directories
INC += -Isw
INC += -Isw/inc
INC += -Isw/utils
INC += -Ispatz/sw/headers_bin
INC += -Isw/kernel_pulp/headers_bin

# ----------------------------------------------------------------------------
# Kernel runtime selection — magia-sdk single-binary flow.
#
# A single CV32 ELF is always produced via sw/kernel/{crt0.S,link.ld}.
# If the test directory contains a `pulp_task/` subdirectory with at least
# one .c source, the PULP cluster sources are compiled into a separate
# position-independent ELF (sw/kernel_pulp/{pulp_crt0.S,pulp_program.ld}),
# converted to a flat binary, and packed into
#   sw/kernel_pulp/headers_bin/<test>_pulp_task_bin.h
# which the CV32 main.c `#include`s. The linker (sw/kernel/link.ld) KEEPs
# that array inside the `.pulp_binary` section, right after the optional
# Spatz binary in instrram (0xCC000000...).  This mirrors what is done for
# Spatz tasks via spatz/sw/Makefile and the `.spatz_binary` section.
# ----------------------------------------------------------------------------
TEST_DIR_PATH       := $(if $(_FOUND_TEST_DIR),$(_FOUND_TEST_DIR),sw/tests/$(test))
PULP_TASK_DIR_PATH  := $(TEST_DIR_PATH)/pulp_task
PULP_TASKS          := $(if $(wildcard $(PULP_TASK_DIR_PATH)/*.c),$(notdir $(basename $(wildcard $(PULP_TASK_DIR_PATH)/*.c))),)

BOOTSCRIPT := sw/kernel/crt0.S
LINKSCRIPT := sw/kernel/link.ld

PULP_SW_DIR := sw/kernel_pulp

ifeq ($(core), CV32E40X)
	CC=$(ISA)$(XLEN)-unknown-elf-gcc
  OBJDUMP=$(ISA)$(XLEN)-unknown-elf-objdump
  NM=$(ISA)$(XLEN)-unknown-elf-nm
else
	CC=riscv64-unknown-elf-gcc
  OBJDUMP=riscv64-unknown-elf-objdump
  NM=riscv64-unknown-elf-nm
endif
LD=$(CC)
ifeq ($(core), CV32E40X)
  CC_OPTS=-march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) -D__$(ISA)__ -O2 -g -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -MMD -MP
	LD_OPTS=-march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) -D__$(ISA)__ -MMD -MP -nostartfiles -nostdlib -Wl,--gc-sections
else
	CC_OPTS=-march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) -D__$(ISA)__ -U__riscv__ -g -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -MMD -MP
  LD_OPTS=-march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) -D__$(ISA)__ -U__riscv__ -MMD -MP -nostartfiles -nostdlib -Wl,--gc-sections
endif

# Spatz embedded binary support (via header)
SPATZ_SW_DIR   := spatz/sw

# Auto-detect which Spatz tasks are used by looking for *_TASK symbols in CV32 code.
# Example: HELLO_WORLD_TASK -> hello_world_task.  PULP task macros use the same
# naming scheme, so remove tasks backed by pulp_task/*.c from the Spatz list.
# When PULP tasks are embedded, the actual CV32 source is main.c.
_SPATZ_SRC_TO_GREP := $(if $(PULP_TASKS),$(TEST_DIR_PATH)/main.c,$(TEST_SRCS))
_AUTO_TASKS := $(shell grep -oP '\b(?!SPATZ_)[A-Z][A-Z0-9_]*_TASK\b' $(_SPATZ_SRC_TO_GREP) 2>/dev/null | tr '[:upper:]' '[:lower:]' | awk '!seen[$$0]++')
SPATZ_TASKS := $(filter-out $(PULP_TASKS),$(_AUTO_TASKS))

# Setup build object dirs
TEST_BUILD_DIR = $(TEST_DIR)/$(if $(TEST_SUBDIR),$(TEST_SUBDIR)/)$(test)
CRT=$(TEST_BUILD_DIR)/build/crt0.o
OBJ=$(TEST_BUILD_DIR)/build/verif.o
BIN=$(TEST_BUILD_DIR)/build/verif
DUMP=$(TEST_BUILD_DIR)/build/verif.dump
ODUMP=$(TEST_BUILD_DIR)/build/verif.objdump
# PULP cluster disassembly with global (runtime) addresses (only when PULP_TASKS set)
PULP_ELF=$(PULP_SW_DIR)/bin/$(test)_pulp_task_bin.elf
PULP_DUMP_GLOBAL=$(TEST_BUILD_DIR)/build/$(test)_pulp_task_global.dump
ITB=$(TEST_BUILD_DIR)/build/verif.itb
STIM_INSTR=$(TEST_BUILD_DIR)/build/stim_instr.txt
STIM_DATA=$(TEST_BUILD_DIR)/build/stim_data.txt
VSIM_INI=modelsim.ini
VSIM_LIBS=work

# Build implicit rules
$(STIM_INSTR) $(STIM_DATA): $(BIN)
	objcopy --srec-len 1 --output-target=srec $(BIN) $(BIN).s19 &&	\
	scripts/parse_s19.pl $(BIN).s19 > $(BIN).txt &&					\
	$(BASE_PYTHON) scripts/s19tomem.py $(BIN).txt $(STIM_INSTR) $(STIM_DATA)
	cd $(TEST_BUILD_DIR) &&										\
	ln -sfn $(ROOT_DIR)/$(INI_PATH) $(VSIM_INI) &&						\
	ln -sfn $(ROOT_DIR)/$(WORK_PATH) $(VSIM_LIBS)

# Build Spatz binary with auto-detected tasks (only if tasks are used)
# Generate test-specific header: test_name_task_bin.h
.PHONY: spatz-header
spatz-header:
	@if [ -n "$(SPATZ_TASKS)" ]; then \
		echo "[SPATZ] Auto-detected tasks: $(SPATZ_TASKS)"; \
		$(MAKE) -C $(SPATZ_SW_DIR) task="$(SPATZ_TASKS)" TEST_NAME=$(test) SPATZ_RVD=$(SPATZ_RVD) SPATZ_VLEN=$(SPATZ_VLEN) SPATZ_N_IPU=$(SPATZ_N_IPU) SPATZ_N_FPU=$(SPATZ_N_FPU) SPATZ_XDIVSQRT=$(SPATZ_XDIVSQRT) SPATZ_XDMA=$(SPATZ_XDMA) SPATZ_RVF=$(SPATZ_RVF) SPATZ_RVV=$(SPATZ_RVV) all; \
	else \
		echo "[SPATZ] No Spatz tasks detected - skipping Spatz compilation"; \
	fi

# Build PULP cluster binary (magia-sdk style): produces
#   sw/kernel_pulp/headers_bin/<test>_pulp_task_bin.h
# embedding the position-independent flat binary in section .pulp_binary.
.PHONY: pulp-header
pulp-header:
	@if [ -n "$(PULP_TASKS)" ]; then \
		echo "[PULP] Auto-detected tasks: $(PULP_TASKS)"; \
		$(MAKE) -C $(PULP_SW_DIR) TEST_NAME=$(test) task="$(PULP_TASKS)" PULP_TASK_DIR=$(ROOT_DIR)/$(PULP_TASK_DIR_PATH) core=$(core) all; \
	else \
		echo "[PULP] No pulp_task/ directory — skipping PULP cluster compilation"; \
	fi

$(BIN): $(CRT) $(OBJ)
	@if [ -n "$(SPATZ_TASKS)" ]; then \
		echo "[CV32-LINK] Linking with embedded Spatz binary (tasks: $(SPATZ_TASKS))"; \
	else \
		echo "[CV32-LINK] Linking without Spatz binary"; \
	fi
	@if [ -n "$(PULP_TASKS)" ]; then \
		echo "[CV32-LINK] Linking with embedded PULP binary (tasks: $(PULP_TASKS))"; \
	fi
	$(LD) $(LD_OPTS) -o $(BIN) $(CRT) $(OBJ) -T$(LINKSCRIPT)

$(CRT):
	mkdir -p $(TEST_BUILD_DIR)/build
	$(CC) $(CC_OPTS) -c $(BOOTSCRIPT) -o $(CRT)

# Compile CV32 test (depends on spatz/pulp headers only when tasks are used)
ifneq ($(SPATZ_TASKS),)
$(OBJ): spatz-header
endif
ifneq ($(PULP_TASKS),)
$(OBJ): pulp-header
endif

$(OBJ):
	mkdir -p $(TEST_BUILD_DIR)/build
ifneq ($(PULP_TASKS),)
	@echo "[CV32] Compiling main core source: $(TEST_DIR_PATH)/main.c"
	$(CC) $(CC_OPTS) -c $(TEST_DIR_PATH)/main.c $(FLAGS) $(INC) -o $(OBJ)
else
	$(CC) $(CC_OPTS) -c $(TEST_SRCS) $(FLAGS) $(INC) -o $(OBJ)
endif

SHELL := /bin/bash

# Parameters used by the iDMA hardware build
IDMA_ROOT    ?= $(shell $(BENDER) path idma)
IDMA_ADD_IDS ?= rw_axi_rw_obi

# Parameters used for FlooNoC
FLOONOC_ROOT ?= $(shell $(BENDER) path floo_noc)

.PHONY: python_venv python_deps

python_venv:
	$(BASE_PYTHON) -m venv magia_venv

python_deps:
	$(BASE_PYTHON) -m pip install --upgrade pip setuptools && \
    $(BASE_PYTHON) -m pip install -r requirements.txt

# Generate instructions and data stimuli (single-binary flow).
ifneq ($(PULP_TASKS),)
all: $(STIM_INSTR) $(STIM_DATA) dis objdump itb pulp-dis
else
all: $(STIM_INSTR) $(STIM_DATA) dis objdump itb
endif

# Run the simulation
run: $(CRT)
ifneq ($(PULP_TASKS),)
	@rm -rf $(TEST_BUILD_DIR)/traces $(TEST_BUILD_DIR)/trace_core_*.log
	@bash $(ROOT_DIR)/scripts/setup_traces.sh $(TEST_BUILD_DIR) $(num_clusters)
endif
ifeq ($(gui), 0)
	cd $(TEST_BUILD_DIR);                                                                		 \
	$(QUESTA) vsim -c vopt_tb $(questa_run_fast_flag) -l transcript                              \
	+INST_HEX=$(inst_hex_name)                                                                   \
	+DATA_HEX=$(data_hex_name)                                                                   \
	+INST_ENTRY=$(inst_entry)                                                                    \
	+DATA_ENTRY=$(data_entry)                                                                    \
	+BOOT_ADDR=$(boot_addr)                                                                      \
	$(foreach i, $(shell seq 0 $(shell echo $$(($(num_cores)-1)))),                              \
		+log_file_$(i)=$(log_path_$(i))                                                            \
	)                                                                                            \
	+itb_file=$(itb_file)                                                                        \
	-do "run -a"
else
	cd $(TEST_BUILD_DIR);                                                                		 \
	$(QUESTA) vsim vopt_tb $(questa_run_flag) -l transcript                                      \
	-do "add log -r sim:/$(tb)/*"                                                                \
	-do "source $(WAVES)"                                                                        \
	+INST_HEX=$(inst_hex_name)                                                                   \
	+DATA_HEX=$(data_hex_name)                                                                   \
	+INST_ENTRY=$(inst_entry)                                                                    \
	+DATA_ENTRY=$(data_entry)                                                                    \
	+BOOT_ADDR=$(boot_addr)                                                                      \
	$(foreach i, $(shell seq 0 $(shell echo $$(($(num_cores)-1)))),                              \
		+log_file_$(i)=$(log_path_$(i))                                                            \
	)                                                                                            \
	+itb_file=$(itb_file)
endif
ifneq ($(PULP_TASKS),)
	@bash $(ROOT_DIR)/scripts/sort_traces.sh $(TEST_BUILD_DIR) $(num_clusters)
else
	@for f in $(TEST_BUILD_DIR)/trace_core_*.log; do \
		[ -f "$$f" ] || continue; \
		hartid=$$(printf '%d' "0x$$(basename $$f .log | sed 's/trace_core_//')"); \
		[ $$hartid -ge $$(( 2 * $(num_clusters) )) ] && rm -f "$$f" || true; \
	done
endif

# Download bender
bender:
	curl --proto '=https' \
	--tlsv1.2 https://pulp-platform.github.io/bender/init -sSf | sh -s -- --local
	export PATH=$(pwd):$(PATH)

include bender_common.mk
include bender_sim.mk
include bender_synth.mk
include bender_profile.mk

ifeq ($(core), CV32E40X)
  bender_defs += -D COREV_ASSERT_OFF
endif

ifeq ($(core), CV32E40X)
  bender_defs += -D CV32E40X
else ifeq ($(core), CV32E40P)
  bender_defs += -D CV32E40P
else
  $(error Detected unsupported core, must choose among CV32E40X and CV32E40P)
endif

bender_targs += -t rtl
bender_targs += -t test
bender_targs += -t cv32e40p_include_tracer


# Targets needed to avoid error even though the module is not used
bender_targs += -t snitch_cluster
bender_targs += -t idma_test
bender_targs += -t spatz

#ifeq ($(REDMULE_COMPLEX),1)
#	tb := redmule_complex_tb
#	WAVES := $(mkfile_path)/wave_complex_xif.do
#	bender_targs += -t redmule_complex
#else
#	tb := redmule_tb
#	WAVES := $(mkfile_path)/wave.do
#	bender_targs += -t redmule_hwpe
#endif

ifeq ($(mesh_dv),1)
	tb         := magia_tb
else
	tb         := magia_tile_tb
endif
WAVES        := $(mkfile_path)/wave.do
ifeq ($(core), CV32E40X)
  bender_targs += -t redmule_complex
  bender_targs += -t cv32e40x_bhv
else
  bender_targs += -t redmule_hwpe
endif

# Define for Spatz target
bender_defs  += -D TARGET_SPATZ
SPATZ_RVD      ?= 0   # 0: 32-bit TCDM (ELEN=32), 1: 64-bit TCDM (ELEN=64)
SPATZ_VLEN     ?= 256 # Vector length in bits (128, 256, 512, ...)
SPATZ_NRVREG   ?= 32  # Number of vector registers (RISC-V standard=32)
SPATZ_NR_VRF_BANKS ?= 4  # Number of VRF banks (banking parallelism: 2, 4, 8)
SPATZ_N_IPU    ?= 1   # Number of Integer Processing Units (1-8)
SPATZ_N_FPU    ?= 4   # Number of Floating Point Units (1-8)
SPATZ_NR_PARALLEL_INSTR ?= 4  # Number of parallel vector instructions (scoreboard depth)
SPATZ_XDIVSQRT ?= 0   # 0: FP div/sqrt disabled, 1: enabled (increases area)
SPATZ_XDMA     ?= 0   # 0: DMA disabled, 1: enabled
SPATZ_RVF      ?= 1   # 0: single-precision FP disabled, 1: enabled
SPATZ_RVV      ?= 1   # 0: vector extension disabled, 1: enabled
bender_defs    += -D SPATZ_RVD=$(SPATZ_RVD)
bender_defs    += -D SPATZ_VLEN=$(SPATZ_VLEN)
bender_defs    += -D SPATZ_NRVREG=$(SPATZ_NRVREG)
bender_defs    += -D SPATZ_NR_VRF_BANKS=$(SPATZ_NR_VRF_BANKS)
bender_defs    += -D SPATZ_N_IPU=$(SPATZ_N_IPU)
bender_defs    += -D SPATZ_N_FPU=$(SPATZ_N_FPU)
bender_defs    += -D SPATZ_NR_PARALLEL_INSTR=$(SPATZ_NR_PARALLEL_INSTR)
bender_defs    += -D SPATZ_XDIVSQRT=$(SPATZ_XDIVSQRT)
bender_defs    += -D SPATZ_XDMA=$(SPATZ_XDMA)
bender_defs    += -D SPATZ_RVF=$(SPATZ_RVF)
bender_defs    += -D SPATZ_RVV=$(SPATZ_RVV)

update-ips:
	$(BENDER) update
	$(BENDER) script vsim          \
	--vlog-arg="$(compile_flag)"   \
	--vcom-arg="-pedanticerrors"   \
	$(bender_targs) $(bender_defs) \
	$(sim_targs)    $(sim_deps)    \
	> ${compile_script}

vsim-scripts:
	$(BENDER) script vsim          \
	--vlog-arg="$(compile_flag)"   \
	--vcom-arg="-pedanticerrors"   \
	$(bender_targs) $(bender_defs) \
	$(sim_targs)    $(sim_deps)    \
	> ${compile_script}

synth-ips:
	$(BENDER) update
	$(MAKE) -C $(IDMA_ROOT) idma_hw_all IDMA_ADD_IDS=$(IDMA_ADD_IDS)
	$(BENDER) script synopsys      \
	$(common_targs) $(common_defs) \
	$(synth_targs)  $(synth_defs)  \
	> ${compile_script_synth}

profile-ips:
	$(BENDER) update
	$(BENDER) script vsim          			\
	--vlog-arg="$(compile_flag)"   			\
	--vcom-arg="-pedanticerrors"   			\
	$(bender_targs) $(bender_defs) 			\
	$(profile_targs)    $(profile_defs)    	\
	> ${compile_script}

floonoc-patch:
	cd $(FLOONOC_ROOT) &&                  \
	git apply ../../../../floonoc.patch && \
	cd ../../../../

build-hw: hw-all

sdk:
	cd $(SW); \
	git clone \
	git@github.com:pulp-platform/pulp-sdk.git

clean-sdk:
	rm -rf $(SW)/pulp-sdk

clean:
	rm -rf $(TEST_BUILD_DIR)/build
	@if [ -d "$(SPATZ_SW_DIR)" ]; then \
		echo "[CLEAN] Cleaning Spatz..."; \
		$(MAKE) -C $(SPATZ_SW_DIR) clean; \
	fi
	@if [ -d "$(PULP_SW_DIR)" ]; then \
		echo "[CLEAN] Cleaning PULP cluster..."; \
		$(MAKE) -C $(PULP_SW_DIR) clean; \
	fi

dis:
	$(OBJDUMP) -d -S $(BIN) > $(DUMP)

objdump:
	$(OBJDUMP) -d -l -s $(BIN) > $(ODUMP)

itb:
	$(BASE_PYTHON) scripts/objdump2itb.py $(ODUMP) > $(ITB)

# PULP cluster disassembly with actual runtime (global) addresses.
# Extracts _pulp_binary_start from the CV32 ELF via nm, then uses
# --adjust-vma to shift the PIC PULP ELF addresses to match the traces.
.PHONY: pulp-dis
pulp-dis: $(BIN)
	@LOAD_ADDR=$$($(NM) $(BIN) | grep ' _pulp_binary_start$$' | awk '{print "0x"$$1}'); \
	if [ -z "$$LOAD_ADDR" ]; then \
		echo "[PULP-DIS] WARNING: _pulp_binary_start not found in $(BIN) - skipping"; \
	else \
		echo "[PULP-DIS] _pulp_binary_start = $$LOAD_ADDR"; \
		$(OBJDUMP) -d -S --adjust-vma=$$LOAD_ADDR $(PULP_ELF) > $(PULP_DUMP_GLOBAL); \
		echo "[PULP-DIS] Written: $(PULP_DUMP_GLOBAL)"; \
	fi

# Trace directory helpers.
#   setup-traces: pre-creates the traces/tile_N/{main,cluster}/ tree so it is
#                 visible as soon as the simulation starts (called by 'run').
#   sort-traces : after sim, moves trace_core_<hartid>.log into the matching
#                 tile subdir (called by 'run'; also usable manually).
.PHONY: setup-traces sort-traces
setup-traces:
	@bash $(ROOT_DIR)/scripts/setup_traces.sh $(TEST_BUILD_DIR) $(num_clusters)

sort-traces:
	@bash $(ROOT_DIR)/scripts/sort_traces.sh $(TEST_BUILD_DIR) $(num_clusters)

OP     ?= gemm
fp_fmt ?= FP16
M      ?= 12
N      ?= 16
K      ?= 16

golden: golden-clean
	$(MAKE) -C golden-model $(OP) SW=$(SW)/inc M=$(M) N=$(N) K=$(K) fp_fmt=$(fp_fmt)

golden-clean:
	$(MAKE) -C golden-model golden-clean

# Hardware rules
hw-clean-all:
	rm -rf $(BUILD_DIR)
	rm -rf .bender
	rm -rf $(compile_script)
	rm -rf sim/modelsim.ini
	rm -rf .cached_ipdb.json

hw-opt:
ifeq ($(fast_sim), 0)
	$(QUESTA) vopt $(questa_opt_flag) -o vopt_tb $(tb) -floatparameters+$(tb) -work $(BUILD_DIR)
else
	$(QUESTA) vopt $(questa_opt_fast_flag) -o vopt_tb $(tb) -floatparameters+$(tb) -work $(BUILD_DIR)
endif

hw-compile:
	$(MAKE) -C $(IDMA_ROOT) idma_hw_all IDMA_ADD_IDS=$(IDMA_ADD_IDS)
	$(QUESTA) vsim $(questa_compile_flag) -c -l sim/compile.log +incdir+$(UVM_HOME) -do 'quit -code [source $(compile_script)]'

hw-lib:
	cd sim &&							\
	touch modelsim.ini	&&				\
	mkdir -p work
	$(QUESTA) vlib $(BUILD_DIR)
	$(QUESTA) vmap work $(BUILD_DIR)
	chmod +w $(INI_PATH)

hw-clean:
	rm -rf $(INI_PATH) $(BUILD_DIR)

hw-all: hw-clean hw-lib hw-compile hw-opt

# Nonfree components
MAGIA_NONFREE_REMOTE ?= git@iis-git.ee.ethz.ch:pulp-restricted/magia-nonfree
MAGIA_NONFREE_DIR ?= nonfree
MAGIA_NONFREE_COMMIT ?= v0.2

.PHONY: magia-nonfree-init
MAGIA_NONFREE_DEPS ?= 1
magia-nonfree-init:
	git clone $(MAGIA_NONFREE_REMOTE) $(MAGIA_NONFREE_DIR)
	cd $(MAGIA_NONFREE_DIR) && git checkout $(MAGIA_NONFREE_COMMIT)
	if [ "$(MAGIA_NONFREE_DEPS)" -eq "1" ]; then $(MAKE) nonfree-init-dep ; fi 

-include $(MAGIA_NONFREE_DIR)/nonfree.mk
