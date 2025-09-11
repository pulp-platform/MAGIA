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
SW             ?= sw
BUILD_DIR      ?= sim/work
ifneq (,$(wildcard /etc/iis.version))
    QUESTA ?= questa-2025.1
    BENDER ?= bender
else
    QUESTA ?=
    BENDER ?= ./bender
endif
BENDER_DIR     ?= .
ISA            ?= riscv
ARCH           ?= rv
XLEN           ?= 32
XTEN           ?= imafc
ABI            ?= ilp
XABI           ?= f

#ifeq ($(REDMULE_COMPLEX),1)
#	TEST_SRCS := sw/redmule_complex.c
#else
#	TEST_SRCS := sw/redmule.c
#endif

TEST_DIR  := sw/tests
TEST_SRCS  = $(TEST_DIR)/$(test).c

compile_script       ?= scripts/compile.tcl
compile_script_synth ?= scripts/synth_compile.tcl
compile_flag         ?= -suppress 2583 -suppress 13314 -suppress 3009

questa_compile_flag  += -t 1ns -suppress 3009
questa_opt_flag      += -suppress 3009 -debugdb +acc=npr
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

# Include directories
INC += -Isw
INC += -Isw/inc
INC += -Isw/utils

BOOTSCRIPT := sw/kernel/crt0.S
LINKSCRIPT := sw/kernel/link.ld

CC=$(ISA)$(XLEN)-unknown-elf-gcc
LD=$(CC)
OBJDUMP=$(ISA)$(XLEN)-unknown-elf-objdump
CC_OPTS=-march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) -D__$(ISA)__ -O2 -g -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -MMD -MP
LD_OPTS=-march=$(ARCH)$(XLEN)$(XTEN) -mabi=$(ABI)$(XLEN)$(XABI) -D__$(ISA)__ -MMD -MP -nostartfiles -nostdlib -Wl,--gc-sections

# Setup build object dirs
CRT=$(TEST_DIR)/$(test)/build/crt0.o
OBJ=$(TEST_DIR)/$(test)/build/verif.o
BIN=$(TEST_DIR)/$(test)/build/verif
DUMP=$(TEST_DIR)/$(test)/build/verif.dump
ODUMP=$(TEST_DIR)/$(test)/build/verif.objdump
ITB=$(TEST_DIR)/$(test)/build/verif.itb
STIM_INSTR=$(TEST_DIR)/$(test)/build/stim_instr.txt
STIM_DATA=$(TEST_DIR)/$(test)/build/stim_data.txt
VSIM_INI=modelsim.ini
VSIM_LIBS=work

# Build implicit rules
$(STIM_INSTR) $(STIM_DATA): $(BIN)
	objcopy --srec-len 1 --output-target=srec $(BIN) $(BIN).s19 &&	\
	scripts/parse_s19.pl $(BIN).s19 > $(BIN).txt &&					\
	python scripts/s19tomem.py $(BIN).txt $(STIM_INSTR) $(STIM_DATA)
	cd $(TEST_DIR)/$(test) &&										\
	ln -sfn ../../../$(INI_PATH) $(VSIM_INI) &&						\
	ln -sfn ../../../$(WORK_PATH) $(VSIM_LIBS)

$(BIN): $(CRT) $(OBJ)
	$(LD) $(LD_OPTS) -o $(BIN) $(CRT) $(OBJ) -T$(LINKSCRIPT)

$(CRT):
	cd $(TEST_DIR) &&							\
	mkdir -p $(test) &&							\
	cd $(test) &&								\
	mkdir -p build								
	$(CC) $(CC_OPTS) -c $(BOOTSCRIPT) -o $(CRT)

$(OBJ):
	cd $(TEST_DIR) &&											\
	mkdir -p $(test) &&											\
	cd $(test) &&												\
	mkdir -p build												
	$(CC) $(CC_OPTS) -c $(TEST_SRCS) $(FLAGS) $(INC) -o $(OBJ)

SHELL := /bin/bash

# Parameters used by the iDMA hardware build
IDMA_ROOT    ?= $(shell $(BENDER) path idma)
IDMA_ADD_IDS ?= rw_axi_rw_obi

# Parameters used for FlooNoC
FLOONOC_ROOT ?= $(shell $(BENDER) path floo_noc)

# Setup python3 venv and install dependencies
BASE_PYTHON ?= python

.PHONY: python_venv python_deps

python_venv:
	$(BASE_PYTHON) -m venv magia_venv

python_deps:
	$(BASE_PYTHON) -m pip install --upgrade pip setuptools && \
    $(BASE_PYTHON) -m pip install -r requirements.txt

# Generate instructions and data stimuli
all: $(STIM_INSTR) $(STIM_DATA) dis objdump itb

# Run the simulation
run: $(CRT)
ifeq ($(gui), 0)
	cd $(TEST_DIR)/$(test);                                                                		 \
	$(QUESTA) vsim -c vopt_tb $(questa_run_fast_flag) -l transcript -do "run -a"                 \
	+INST_HEX=$(inst_hex_name)                                                                   \
	+DATA_HEX=$(data_hex_name)                                                                   \
	+INST_ENTRY=$(inst_entry)                                                                    \
	+DATA_ENTRY=$(data_entry)                                                                    \
	+BOOT_ADDR=$(boot_addr)                                                                      \
	$(foreach i, $(shell seq 0 $(shell echo $$(($(num_cores)-1)))),                              \
		+log_file_$(i)=$(log_path_$(i))                                                            \
	)                                                                                            \
	+itb_file=$(itb_file)
else
	cd $(TEST_DIR)/$(test);                                                                		 \
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

# Download bender
bender:
	curl --proto '=https'  \
	--tlsv1.2 https://pulp-platform.github.io/bender/init -sSf | sh -s -- 0.28.1 \
	export PATH=$(pwd):$(PATH)

include bender_common.mk
include bender_sim.mk
include bender_synth.mk
include bender_profile.mk

bender_defs += -D COREV_ASSERT_OFF

bender_targs += -t rtl
bender_targs += -t test
bender_targs += -t cv32e40p_exclude_tracer
# Targets needed to avoid error even though the module is not used
bender_targs += -t snitch_cluster
bender_targs += -t idma_test

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
WAVES        := ./wave.do
bender_targs += -t redmule_complex
bender_targs += -t cv32e40x_bhv

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
	rm -rf $(TEST_DIR)/$(test)

dis:
	$(OBJDUMP) -d -S $(BIN) > $(DUMP)

objdump:
	$(OBJDUMP) -d -l -s $(BIN) > $(ODUMP)

itb:
	python scripts/objdump2itb.py $(ODUMP) > $(ITB)

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
MAGIA_NONFREE_COMMIT ?= main

.PHONY: magia-nonfree-init
magia-nonfree-init:
	git clone $(MAGIA_NONFREE_REMOTE) $(MAGIA_NONFREE_DIR)
	cd $(MAGIA_NONFREE_DIR) && git checkout $(MAGIA_NONFREE_COMMIT)