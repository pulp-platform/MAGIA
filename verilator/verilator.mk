# Copyright 2026 ETH Zurich and University of Bologna
# SPDX-License-Identifier: Apache-2.0
#
# Verilator flow for MAGIA, one model per testbench:
#   mesh_dv=1  magia_tb, hierarchical: the tile is Verilated once into a
#              library and instantiated 16 times. Built in verilator/build.
#   mesh_dv=0  magia_tile_tb, flat: one tile, optimized across its whole
#              hierarchy. Built in verilator/build-tile.
#
#   make verilate       build the model
#   make verilate-run   compile + run test=<name> against the built model
#   make clean-verilate remove the model's build directory

MAGIA_ROOT  ?= $(shell git rev-parse --show-toplevel)
VERILATOR   ?= verilator
BASE_PYTHON ?= python3

# Model sources live with the Verilator-only RTL; verilator/ holds the build
# system and its output, verilator/scripts/ the host-side checkers. Both dirs
# below also go on the include path, ahead of Bender's -- see the raw flist rule.
VERILATOR_SRC        := $(MAGIA_ROOT)/target/verilator/src
# Headers that only exist to make third-party RTL compile here; currently the
# uvm_macros.svh stand-in the cv32e40px tracer needs. Verilator-only on purpose:
# putting it on any other flow's include path would shadow the real UVM.
VERILATOR_INC        := $(MAGIA_ROOT)/target/verilator/include
VERILATOR_SCRIPTS    := $(MAGIA_ROOT)/verilator/scripts

# Separate build dirs per testbench, so building one model never invalidates the other
ifeq ($(mesh_dv),0)
VERILATOR_HIER              := 0
VERILATOR_TOP               := magia_tile_tb
VERILATOR_DEFAULT_BUILD_DIR := $(MAGIA_ROOT)/verilator/build-tile
else
VERILATOR_HIER              := 1
VERILATOR_TOP               := magia_tb
VERILATOR_DEFAULT_BUILD_DIR := $(MAGIA_ROOT)/verilator/build
endif
VERILATOR_BUILD_DIR  ?= $(VERILATOR_DEFAULT_BUILD_DIR)
VERILATOR_OBJ_DIR    := $(VERILATOR_BUILD_DIR)/obj_dir

# hier_block metacomment marking the tile as a separately Verilated block.
VERILATOR_CONTROL     := $(VERILATOR_SRC)/magia_hier.vlt
# Empty on purpose, but required: without it Verilator inlines the tile and
# silently produces a flat model. See the file.
VERILATOR_HIER_PARAMS := $(VERILATOR_SRC)/magia_hier_params.v
# Owns +FST dumping. A testbench $dumpvars cannot see into hier_blocks; see
# the file.
VERILATOR_MAIN        := $(VERILATOR_SRC)/magia_main.cpp

# Build parallelism (not simulation speed).
VERILATOR_JOBS          ?= 16
# Simulation threads: 4 for the mesh, 1 for the tile, where more threads only add sync cost
ifeq ($(VERILATOR_HIER),0)
VERILATOR_THREADS       ?= 1
else
VERILATOR_THREADS       ?= 4
endif
# Extra trace detail. Tracing itself is always on: a non-tracing model diverges
# on tests that do real memory traffic, for reasons not yet understood.
VERILATOR_TRACE_STRUCTS ?= 0
VERILATOR_TRACE_PARAMS  ?= 0
VERILATOR_CFLAGS        ?= -march=native
# Parent and child must agree on where simulated time lives, or they segfault
# at time 0. Nothing sets VL_TIME_CONTEXT implicitly here, so force it on both.
# MAGIA_THREADS must match --threads: magia_main.cpp sizes the pool with it.
# MAGIA_TOP names the model class magia_main.cpp instantiates
VERILATOR_ABI_CFLAGS    := -DVL_TIME_CONTEXT -DMAGIA_THREADS=$(VERILATOR_THREADS) \
	-DMAGIA_TOP=V$(VERILATOR_TOP)
# SVA, immediate assertions and unique/priority case checks, as in the Questa flow; 0 drops them for speed
VERILATOR_ASSERT        ?= 1
VERILATOR_ASSERT_ARGS   := $(if $(filter 1,$(VERILATOR_ASSERT)),--assert,--no-assert)
# Assertions sit under `ifndef SYNTHESIS, so SYNTHESIS is defined only when they are off
VERILATOR_SYNTH_DEF     := $(if $(filter 1,$(VERILATOR_ASSERT)),,-DSYNTHESIS)
# Waveform for verilate-run. Empty means no dump and no cost.
VERILATOR_FST           ?=
# One tile library is expected; more means a parameter leaked into the boundary.
VERILATOR_EXPECTED_TILE_SPECIALIZATIONS ?= 1

# Reject junk early: these size a thread pool and a rebuild.
_VERILATOR_JOBS_NUM := $(strip $(shell expr $(VERILATOR_JOBS) + 0 2>/dev/null))
ifeq ($(_VERILATOR_JOBS_NUM),)
$(error VERILATOR_JOBS must be a positive integer, got '$(VERILATOR_JOBS)')
endif
ifeq ($(_VERILATOR_JOBS_NUM),0)
$(error VERILATOR_JOBS must be a positive integer, got '$(VERILATOR_JOBS)')
endif

_VERILATOR_THREADS_NUM := $(strip $(shell expr $(VERILATOR_THREADS) + 0 2>/dev/null))
ifeq ($(_VERILATOR_THREADS_NUM),)
$(error VERILATOR_THREADS must be a positive integer, got '$(VERILATOR_THREADS)')
endif
ifeq ($(_VERILATOR_THREADS_NUM),0)
$(error VERILATOR_THREADS must be a positive integer, got '$(VERILATOR_THREADS)')
endif

_VERILATOR_EXPECTED_NUM := $(strip $(shell expr $(VERILATOR_EXPECTED_TILE_SPECIALIZATIONS) + 0 2>/dev/null))
ifeq ($(_VERILATOR_EXPECTED_NUM),)
$(error VERILATOR_EXPECTED_TILE_SPECIALIZATIONS must be a positive integer)
endif
ifeq ($(_VERILATOR_EXPECTED_NUM),0)
$(error VERILATOR_EXPECTED_TILE_SPECIALIZATIONS must be a positive integer)
endif

# Warnings waived to get this RTL through; --timing is needed by the testbench.
VERILATOR_ARGS = -Wno-fatal \
	-Wno-style -Wno-timescalemod -Wno-redefmacro -Wno-implicit \
	-Wno-ascrange -Wno-widthexpand -Wno-widthconcat -Wno-misindent \
	-Wno-pinmissing -Wno-widthtrunc -Wno-unsigned -Wno-cmpconst \
	-Wno-userfatal -Wno-caseincomplete -Wno-combdly -Wno-latch \
	-Wno-blkandnblk -Wno-ENUMVALUE \
	-O3 --x-assign fast --x-initial fast $(VERILATOR_ASSERT_ARGS) \
	--timing --autoflush --threads $(VERILATOR_THREADS)

# Extra Verilator options from the command line
VERILATOR_USER_ARGS ?=
VERILATOR_ARGS += $(VERILATOR_USER_ARGS)

VERILATOR_ARGS += --trace-fst
ifeq ($(VERILATOR_TRACE_STRUCTS),1)
VERILATOR_ARGS += --trace-structs
endif
ifeq ($(VERILATOR_TRACE_PARAMS),1)
VERILATOR_ARGS += --trace-params
endif

# JTAG DPI: plain C, appended to the file list rather than compiled here.
RISCV_DBG_ROOT    ?= $(shell $(BENDER) path riscv-dbg)
FRACTAL_SYNC_ROOT ?= $(shell $(BENDER) path fractal_sync)
VERILATOR_DPI := \
	$(RISCV_DBG_ROOT)/tb/remote_bitbang/sim_jtag.c \
	$(RISCV_DBG_ROOT)/tb/remote_bitbang/remote_bitbang.c

VERILATOR_BENDER_TARGS := $(bender_targs) \
	-t tech_cells_generic_include_deprecated -t verilator -t rtl_sim \
	-t verilator_dpi -t magia_dv -t simulation -t cv32e40px_include_tracer
ifeq ($(VERILATOR_HIER),0)
VERILATOR_BENDER_TARGS += -t standalone_tile
endif
# Ibex is only a redmule dependency (nothing in MAGIA instantiates it),
# and its prim_assert.sv redefines `ASSERT with 4 arguments; that definition
# overrides the 5-argument common_cells one that FlooNoC uses.
VERILATOR_BENDER_EXCL  := -e ibex

VERILATOR_RAW_FLIST     := $(VERILATOR_BUILD_DIR)/magia.raw.f
VERILATOR_FLIST         := $(VERILATOR_BUILD_DIR)/magia.f
VERILATOR_BENDER_STAMP  := $(VERILATOR_BUILD_DIR)/bender.stamp
VERILATOR_CONFIG_STAMP  := $(VERILATOR_BUILD_DIR)/config.stamp
VERILATOR_VERSION_LOG   := $(VERILATOR_BUILD_DIR)/verilator-version.log
VERILATOR_PARENT_MK     := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP).mk
VERILATOR_HIER_MK       := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)_hier.mk
VERILATOR_CLASSES_MK    := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)_classes.mk
VERILATOR_CODEGEN_STAMP := $(VERILATOR_BUILD_DIR)/codegen.stamp
VERILATOR_TRACE_MODE    := $(VERILATOR_BUILD_DIR)/trace.mode
VERILATOR_BIN           := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)
VERILATOR_CODEGEN_LOG   := $(VERILATOR_BUILD_DIR)/codegen.log
VERILATOR_BUILD_LOG     := $(VERILATOR_BUILD_DIR)/build.log
VERILATOR_TIME          := $(shell command -v /usr/bin/time 2>/dev/null)

$(VERILATOR_BUILD_DIR):
	mkdir -p $@

# Stamps below record configuration identity: rewritten only when the content
# changes, so an unchanged rerun does not invalidate anything downstream.
.PHONY: $(VERILATOR_BUILD_DIR)/.bender-check
$(VERILATOR_BUILD_DIR)/.bender-check: | $(VERILATOR_BUILD_DIR)
	@command -v $(BENDER) >/dev/null 2>&1 || { echo "error: bender not found: $(BENDER)" >&2; exit 1; }
	@{ \
	  echo "path=$$(command -v $(BENDER))"; \
	  echo "version=$$($(BENDER) --version)"; \
	  echo "targets=$(VERILATOR_BENDER_TARGS)"; \
	  echo "defines=$(bender_defs) $(VERILATOR_SYNTH_DEF)"; \
	} > $(VERILATOR_BENDER_STAMP).tmp
	@if ! cmp -s $(VERILATOR_BENDER_STAMP).tmp $(VERILATOR_BENDER_STAMP) 2>/dev/null; then \
	  mv $(VERILATOR_BENDER_STAMP).tmp $(VERILATOR_BENDER_STAMP); \
	else rm -f $(VERILATOR_BENDER_STAMP).tmp; fi

$(VERILATOR_BENDER_STAMP): $(VERILATOR_BUILD_DIR)/.bender-check
	@test -f $@

# Bender's raw file list, plus the JTAG DPI sources. Our two include dirs are
# written before Bender's output on purpose: `include resolution follows
# +incdir+ order and gives the including file's own directory no priority, so
# this is what makes the vendorized cv32e40px_instr_trace.svh in target/verilator/src
# win over the one in the cv32e40px checkout's bhv/.
$(VERILATOR_RAW_FLIST): Bender.yml Bender.lock Makefile bender_common.mk \
	bender_sim.mk bender_synth.mk bender_profile.mk $(MAGIA_ROOT)/verilator/verilator.mk \
	$(VERILATOR_BENDER_STAMP) | $(VERILATOR_BUILD_DIR)
	echo +incdir+$(VERILATOR_SRC) > $@.tmp
	echo +incdir+$(VERILATOR_INC) >> $@.tmp
	$(BENDER) script verilator $(VERILATOR_BENDER_TARGS) $(VERILATOR_BENDER_EXCL) $(bender_defs) $(VERILATOR_SYNTH_DEF) -DVERILATOR -DCORE_TRACES >> $@.tmp
	echo +incdir+$(FRACTAL_SYNC_ROOT)/hw >> $@.tmp
	for f in $(VERILATOR_DPI); do echo $$f >> $@.tmp; done
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv $@.tmp $@; else rm -f $@.tmp; fi

# filter: drop files Verilator cannot take. check: fail if the filter dropped
# something we need (the top, the DPI) rather than let codegen fail obscurely.
$(VERILATOR_FLIST): $(VERILATOR_RAW_FLIST) \
	$(VERILATOR_SCRIPTS)/filter_filelist.py \
	$(VERILATOR_SCRIPTS)/check_filelist.py | $(VERILATOR_BUILD_DIR)
	$(BASE_PYTHON) $(VERILATOR_SCRIPTS)/filter_filelist.py --output $@.tmp \
		--vendor-dir $(VERILATOR_SRC) < $(VERILATOR_RAW_FLIST)
	$(BASE_PYTHON) $(VERILATOR_SCRIPTS)/check_filelist.py $@.tmp \
		--top $(VERILATOR_TOP) \
		--dpi $(RISCV_DBG_ROOT)/tb/remote_bitbang/sim_jtag.c \
		--dpi $(RISCV_DBG_ROOT)/tb/remote_bitbang/remote_bitbang.c
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv $@.tmp $@; else rm -f $@.tmp; fi

.PHONY: verilator-bender
verilator-bender: $(VERILATOR_FLIST)

# Everything that changes the generated model: tools, targets, flags, sources.
# Changing any of it re-runs codegen. 5.046 is the first version with the
# hier_block fixes this flow needs.
.PHONY: $(VERILATOR_BUILD_DIR)/.config-check
$(VERILATOR_BUILD_DIR)/.config-check: | $(VERILATOR_BUILD_DIR)
	@command -v $(VERILATOR) >/dev/null 2>&1 || { echo "error: verilator not found: $(VERILATOR)" >&2; exit 1; }
	@test -f $(VERILATOR_CONTROL) || { echo "error: missing $(VERILATOR_CONTROL)" >&2; exit 1; }
	@version="$$($(VERILATOR) --version)"; \
	numeric="$$(printf '%s\n' "$$version" | grep -oE '[0-9]+\.[0-9]+' | head -1)"; \
	awk -v got="$$numeric" 'BEGIN { split(got,a,"."); exit !((a[1]*1000+a[2]) >= 5046) }' || \
	  { echo "error: the Verilator flow requires Verilator >= 5.046; got $$version" >&2; exit 1; }; \
	printf '%s\n' "$$version" > $(VERILATOR_VERSION_LOG).tmp
	@if ! cmp -s $(VERILATOR_VERSION_LOG).tmp $(VERILATOR_VERSION_LOG) 2>/dev/null; then \
	  mv $(VERILATOR_VERSION_LOG).tmp $(VERILATOR_VERSION_LOG); \
	else rm -f $(VERILATOR_VERSION_LOG).tmp; fi
	@{ \
	  echo "verilator_path=$$(command -v $(VERILATOR))"; \
	  echo "verilator_version=$$($(VERILATOR) --version)"; \
	  echo "bender_path=$$(command -v $(BENDER))"; \
	  echo "bender_version=$$($(BENDER) --version 2>/dev/null)"; \
	  echo "top=$(VERILATOR_TOP)"; \
	  echo "mesh_dv=$(mesh_dv)"; \
	  echo "core=$(core)"; \
	  echo "bender_targets=$(VERILATOR_BENDER_TARGS)"; \
	  echo "bender_defines=$(bender_defs)"; \
	  echo "trace_structs=$(VERILATOR_TRACE_STRUCTS)"; \
	  echo "trace_params=$(VERILATOR_TRACE_PARAMS)"; \
	  echo "cflags=$(VERILATOR_CFLAGS) $(VERILATOR_ABI_CFLAGS)"; \
	  echo "cppflags=$(CPPFLAGS)"; \
	  echo "cxxflags=$(CXXFLAGS)"; \
	  echo "ldflags=$(LDFLAGS)"; \
	  echo "cxx_path=$$(command -v $(CXX) 2>/dev/null || echo $(CXX))"; \
	  echo "cxx_version=$$($(CXX) --version 2>/dev/null | head -1)"; \
	  echo "objcache=$$(if [ -n "$$OBJCACHE" ]; then printf '%s' "$$OBJCACHE"; else command -v ccache 2>/dev/null || echo none; fi)"; \
	  echo "dpi=$(VERILATOR_DPI)"; \
	  echo "verilator_args=$(VERILATOR_ARGS)$(if $(filter 1,$(VERILATOR_HIER)), --hierarchical)"; \
	  echo "control_sha256=$$(sha256sum $(VERILATOR_CONTROL) | cut -d' ' -f1)"; \
	  echo "hier_params_sha256=$$(sha256sum $(VERILATOR_HIER_PARAMS) | cut -d' ' -f1)"; \
	  echo "main=$(VERILATOR_MAIN)"; \
	} > $(VERILATOR_CONFIG_STAMP).tmp
	@if ! cmp -s $(VERILATOR_CONFIG_STAMP).tmp $(VERILATOR_CONFIG_STAMP) 2>/dev/null; then \
	  mv $(VERILATOR_CONFIG_STAMP).tmp $(VERILATOR_CONFIG_STAMP); \
	else rm -f $(VERILATOR_CONFIG_STAMP).tmp; fi

$(VERILATOR_CONFIG_STAMP): $(VERILATOR_BUILD_DIR)/.config-check
	@test -f $@

# 5.046 does not forward +define/+incdir from -f to the child run; mirror them, deduplicated in order to stay under the 128 KiB argument limit
VERILATOR_HIER_FLIST_FLAGS = $(shell grep -E '^\+(define|incdir)' $(VERILATOR_FLIST) | awk '!seen[$$0]++')

# Hierarchical: V<top>.mk is a stage-2 product, never touch or depend on it in stage 1; flat: codegen writes it
ifeq ($(VERILATOR_HIER),1)
VERILATOR_GEN_MK    := $(VERILATOR_HIER_MK)
VERILATOR_GEN_DEP   := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)__hierVer.d
VERILATOR_GEN_INPUT := $(VERILATOR_CONTROL) $(VERILATOR_HIER_PARAMS)
VERILATOR_GEN_ARGS   = $(VERILATOR_CONTROL) --hierarchical \
	--hierarchical-params-file $(VERILATOR_HIER_PARAMS) \
	$(VERILATOR_ARGS) $(VERILATOR_HIER_FLIST_FLAGS)
else
VERILATOR_GEN_MK    := $(VERILATOR_PARENT_MK)
VERILATOR_GEN_DEP   := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)__ver.d
VERILATOR_GEN_INPUT :=
VERILATOR_GEN_ARGS   = $(VERILATOR_ARGS)
endif

# Verilator's dependency file, rewritten as a rule for the target we own
VERILATOR_GEN_DEP_MK := $(VERILATOR_BUILD_DIR)/genVer.mk

-include $(VERILATOR_GEN_DEP_MK)

# An empty rule per source, as gcc -MP, so a deleted file re-runs codegen instead of failing make
# Keep source prerequisites only; entries under obj_dir are products of the very
# rule they would trigger. mv unconditionally: make restarts after remaking an
# included makefile, so this must end up newer or the restart loops.
$(VERILATOR_GEN_DEP_MK): $(VERILATOR_GEN_DEP) | $(VERILATOR_BUILD_DIR)
	@deps="$$(sed -e 's|^[^:]*:||' -e 's|[^ ]*$(VERILATOR_OBJ_DIR)[^ ]*||g' $<)"; \
	{ printf '%s:%s\n' '$(VERILATOR_GEN_MK)' "$$deps"; \
	  for d in $$deps; do printf '%s:\n' "$$d"; done; } > $@.tmp \
	  && mv -f $@.tmp $@

# Stage 1: codegen
$(VERILATOR_GEN_MK): $(VERILATOR_FLIST) $(VERILATOR_CONFIG_STAMP) \
	$(VERILATOR_GEN_INPUT) $(VERILATOR_VERSION_LOG) \
	| $(VERILATOR_BUILD_DIR)
	cd $(VERILATOR_BUILD_DIR) && \
		{ $(if $(VERILATOR_TIME),$(VERILATOR_TIME) -v -o $(VERILATOR_BUILD_DIR)/codegen.time.log,) \
		$(VERILATOR) -j $(VERILATOR_JOBS) $(VERILATOR_GEN_ARGS) \
		--cc --exe $(VERILATOR_MAIN) -Mdir $(VERILATOR_OBJ_DIR) \
		-CFLAGS "$(VERILATOR_CFLAGS) $(VERILATOR_ABI_CFLAGS)" \
		--top-module $(VERILATOR_TOP) \
		-f $(VERILATOR_FLIST); \
		echo $$? > $(VERILATOR_BUILD_DIR)/.codegen.status; } 2>&1 \
		| tee $(VERILATOR_CODEGEN_LOG); \
		exit $$(cat $(VERILATOR_BUILD_DIR)/.codegen.status)
	@test -f $(VERILATOR_GEN_MK)
	# The planner leaves this file alone when the plan is unchanged, so a merely
	# newer prerequisite would re-run Verilator on every make. Touch to converge.
	@touch $(VERILATOR_GEN_MK)

$(VERILATOR_CODEGEN_STAMP): $(VERILATOR_GEN_MK)
	@touch $@

# Stage 2: native build, driven by Verilator's generated makefile.
# VM_TRACE* are compiler flags the generated makefiles do not track, and tracing
# changes the model's class layout, so objects left over from another trace
# setting would silently mix ABIs. Drop them when it changes; unchanged leaves
# the tree alone, keeping a no-change rebuild a no-op.
$(VERILATOR_BIN): $(VERILATOR_CODEGEN_STAMP) $(VERILATOR_MAIN)
	@mode="structs=$(VERILATOR_TRACE_STRUCTS) params=$(VERILATOR_TRACE_PARAMS)"; \
	if [ -f $(VERILATOR_TRACE_MODE) ] && [ "$$mode" != "$$(cat $(VERILATOR_TRACE_MODE))" ]; then \
	  echo "trace configuration changed to [$$mode]; dropping stale objects"; \
	  find $(VERILATOR_OBJ_DIR) \( -name '*.o' -o -name '*.a' -o -name '*.d' \) \
	    ! -name '*__ver.d' ! -name '*__hierVer.d' -delete; \
	fi; \
	printf '%s\n' "$$mode" > $(VERILATOR_TRACE_MODE)
	{ $(if $(VERILATOR_TIME),$(VERILATOR_TIME) -v -o $(VERILATOR_BUILD_DIR)/build.time.log,) \
		$(MAKE) -C $(VERILATOR_OBJ_DIR) -f $(notdir $(VERILATOR_GEN_MK)) -j $(VERILATOR_JOBS); \
		echo $$? > $(VERILATOR_BUILD_DIR)/.build.status; } 2>&1 \
		| tee $(VERILATOR_BUILD_LOG); \
		exit $$(cat $(VERILATOR_BUILD_DIR)/.build.status)
	@test -x $@

.PHONY: verilate-gen verilate-build verilate
verilate-gen: $(VERILATOR_CODEGEN_STAMP)
verilate-build: $(VERILATOR_BIN)
ifeq ($(VERILATOR_HIER),1)
verilate: $(VERILATOR_BIN) verilate-check-hierarchy

# Inspects the built parent, not just the plan: inlining the tile instead of
# linking the library still builds, and is a failed hierarchical build.
.PHONY: verilate-check-hierarchy
verilate-check-hierarchy: $(VERILATOR_BIN)
	$(BASE_PYTHON) $(VERILATOR_SCRIPTS)/check_hierarchy.py \
		$(VERILATOR_HIER_MK) --module magia_tile_hier \
		--expected-count $(VERILATOR_EXPECTED_TILE_SPECIALIZATIONS) \
		--classes-mk $(VERILATOR_CLASSES_MK) --obj-dir $(VERILATOR_OBJ_DIR)
else
verilate: $(VERILATOR_BIN)

.PHONY: verilate-check-hierarchy
verilate-check-hierarchy:
	$(error $@ checks the hierarchical mesh model: it requires mesh_dv=1)
endif

# Uses whatever model is already in obj_dir: it deliberately does not depend on
# $(VERILATOR_BIN), so an edit anywhere in the RTL cannot turn a run into a
# multi-minute rebuild. Build the model yourself with `make verilate`.
# Like the Questa run: runs in the test's build dir, logs to its transcript and sorts the core traces
# Nothing bounds a hung run
.PHONY: verilate-run
verilate-run: all
	@test -x $(VERILATOR_BIN) || { \
	  echo "error: no Verilator model at $(VERILATOR_BIN)" >&2; \
	  echo "       build it first: make verilate core=$(core) mesh_dv=$(mesh_dv)" >&2; \
	  exit 1; }
	$(sim-traces-setup)
	@cd $(TEST_BUILD_DIR) && set -o pipefail && \
	  $(VERILATOR_BIN) \
	    +INST_HEX=$(inst_hex_name) +DATA_HEX=$(data_hex_name) \
	    +INST_ENTRY=$(inst_entry) +DATA_ENTRY=$(data_entry) \
	    +BOOT_ADDR=$(boot_addr) +itb_file=$(itb_file) \
	    $(foreach i,$(shell seq 0 $$(($(num_cores)-1))),+log_file_$(i)=$(log_path_$(i))) \
	    $(if $(VERILATOR_FST),+FST=$(VERILATOR_FST),) \
	    2>&1 | tee -i transcript
	$(sim-traces-sort)

# Guarded: this is an rm -rf of a variable path.
.PHONY: clean-verilate
clean-verilate:
	@test -n "$(VERILATOR_BUILD_DIR)"
	@test "$(VERILATOR_BUILD_DIR)" = "$(VERILATOR_DEFAULT_BUILD_DIR)"
	rm -rf $(VERILATOR_BUILD_DIR)
