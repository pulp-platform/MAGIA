# Copyright 2026 ETH Zurich and University of Bologna
# SPDX-License-Identifier: Apache-2.0
#
# Verilator flow for the MAGIA mesh. Hierarchical only: the tile is Verilated
# once into a library and instantiated 16 times, so mesh_dv=1 is required.
#
#   make verilate       build the model
#   make verilate-run   compile + run test=<name> against the built model
#   make clean-verilate remove verilator/build

MAGIA_ROOT  ?= $(shell git rev-parse --show-toplevel)
VERILATOR   ?= verilator
BASE_PYTHON ?= python3

# Model sources live with the Verilator-only RTL; verilator/ holds the build
# system and its output, verilator/scripts/ the host-side checkers.
VERILATOR_SRC        := $(MAGIA_ROOT)/target/verilator/src
VERILATOR_SCRIPTS    := $(MAGIA_ROOT)/verilator/scripts
VERILATOR_BUILD_DIR  ?= $(MAGIA_ROOT)/verilator/build
VERILATOR_OBJ_DIR    := $(VERILATOR_BUILD_DIR)/obj_dir
VERILATOR_TOP        := magia_tb

# hier_block metacomment marking the tile as a separately Verilated block.
VERILATOR_CONTROL     := $(VERILATOR_SRC)/magia_hier.vlt
# Empty on purpose, but required: without it Verilator inlines the tile and
# silently produces a flat model. See the file.
VERILATOR_HIER_PARAMS := $(VERILATOR_SRC)/magia_hier_params.v
# Owns +FST dumping. A testbench $dumpvars cannot see into hier_blocks; see
# the file.
VERILATOR_MAIN        := $(VERILATOR_SRC)/magia_main.cpp

# Build parallelism (not simulation speed).
VERILATOR_JOBS          ?= 4
# Simulation threads. Experimental: 8 halved a test, 4 segfaults at time zero.
# Leave at 1.
VERILATOR_THREADS       ?= 1
# Extra trace detail. Tracing itself is always on: a non-tracing model diverges
# on tests that do real memory traffic, for reasons not yet understood.
VERILATOR_TRACE_STRUCTS ?= 0
VERILATOR_TRACE_PARAMS  ?= 0
VERILATOR_CFLAGS        ?= -O2
# Parent and child must agree on where simulated time lives, or they segfault
# at time 0. Nothing sets VL_TIME_CONTEXT implicitly here, so force it on both.
# MAGIA_THREADS must match --threads: magia_main.cpp sizes the pool with it.
VERILATOR_ABI_CFLAGS    := -DVL_TIME_CONTEXT -DMAGIA_THREADS=$(VERILATOR_THREADS)
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
VERILATOR_ARGS = -j $(VERILATOR_JOBS) -Wno-fatal \
	-Wno-style -Wno-timescalemod -Wno-redefmacro -Wno-implicit \
	-Wno-ascrange -Wno-widthexpand -Wno-widthconcat -Wno-misindent \
	-Wno-pinmissing -Wno-widthtrunc -Wno-unsigned -Wno-cmpconst \
	-Wno-userfatal -Wno-caseincomplete -Wno-combdly -Wno-latch \
	-Wno-unoptflat -Wno-blkandnblk -Wno-ENUMVALUE \
	--timing --autoflush --threads $(VERILATOR_THREADS)

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
	-t verilator_dpi -t magia_dv -t simulation -t cv32e40p_exclude_tracer

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
	  echo "defines=$(bender_defs)"; \
	} > $(VERILATOR_BENDER_STAMP).tmp
	@if ! cmp -s $(VERILATOR_BENDER_STAMP).tmp $(VERILATOR_BENDER_STAMP) 2>/dev/null; then \
	  mv $(VERILATOR_BENDER_STAMP).tmp $(VERILATOR_BENDER_STAMP); \
	else rm -f $(VERILATOR_BENDER_STAMP).tmp; fi

$(VERILATOR_BENDER_STAMP): $(VERILATOR_BUILD_DIR)/.bender-check
	@test -f $@

# Bender's raw file list, plus the JTAG DPI sources.
$(VERILATOR_RAW_FLIST): Bender.yml Bender.lock Makefile bender_common.mk \
	bender_sim.mk bender_synth.mk bender_profile.mk $(VERILATOR_BENDER_STAMP) | $(VERILATOR_BUILD_DIR)
	$(BENDER) script verilator $(VERILATOR_BENDER_TARGS) $(bender_defs) -DSYNTHESIS -DVERILATOR > $@.tmp
	echo +incdir+$(FRACTAL_SYNC_ROOT)/hw >> $@.tmp
	for f in $(VERILATOR_DPI); do echo $$f >> $@.tmp; done
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv $@.tmp $@; else rm -f $@.tmp; fi

# filter: drop files Verilator cannot take. check: fail if the filter dropped
# something we need (the top, the DPI) rather than let codegen fail obscurely.
$(VERILATOR_FLIST): $(VERILATOR_RAW_FLIST) \
	$(VERILATOR_SCRIPTS)/filter_filelist.py \
	$(VERILATOR_SCRIPTS)/check_filelist.py | $(VERILATOR_BUILD_DIR)
	$(BASE_PYTHON) $(VERILATOR_SCRIPTS)/filter_filelist.py --output $@.tmp < $(VERILATOR_RAW_FLIST)
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
	  { echo "error: hierarchical Verilation requires Verilator >= 5.046; got $$version" >&2; exit 1; }; \
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
	  echo "verilator_args=$(VERILATOR_ARGS) --hierarchical"; \
	  echo "control_sha256=$$(sha256sum $(VERILATOR_CONTROL) | cut -d' ' -f1)"; \
	  echo "hier_params_sha256=$$(sha256sum $(VERILATOR_HIER_PARAMS) | cut -d' ' -f1)"; \
	  echo "main=$(VERILATOR_MAIN)"; \
	} > $(VERILATOR_CONFIG_STAMP).tmp
	@if ! cmp -s $(VERILATOR_CONFIG_STAMP).tmp $(VERILATOR_CONFIG_STAMP) 2>/dev/null; then \
	  mv $(VERILATOR_CONFIG_STAMP).tmp $(VERILATOR_CONFIG_STAMP); \
	else rm -f $(VERILATOR_CONFIG_STAMP).tmp; fi

$(VERILATOR_CONFIG_STAMP): $(VERILATOR_BUILD_DIR)/.config-check
	@test -f $@

# 5.046 does not forward +define/+incdir from -f to the child run; mirror them.
VERILATOR_HIER_FLIST_FLAGS = $(shell grep -E '^\+(define|incdir)' $(VERILATOR_FLIST))

# Verilator's own dependency file, rewritten as a rule for the target we own.
VERILATOR_HIER_DEP    := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)__hierVer.d
VERILATOR_HIER_DEP_MK := $(VERILATOR_BUILD_DIR)/hierVer.mk

-include $(VERILATOR_HIER_DEP_MK)

# Keep source prerequisites only; entries under obj_dir are products of the very
# rule they would trigger. mv unconditionally: make restarts after remaking an
# included makefile, so this must end up newer or the restart loops.
$(VERILATOR_HIER_DEP_MK): $(VERILATOR_HIER_DEP) | $(VERILATOR_BUILD_DIR)
	@{ printf '%s:' '$(VERILATOR_HIER_MK)'; \
	   sed -e 's|^[^:]*:||' -e 's|[^ ]*$(VERILATOR_OBJ_DIR)[^ ]*||g' $<; } > $@.tmp \
	  && mv -f $@.tmp $@

# Stage 1: plan the hierarchy. Writes V<top>_hier.mk and the per-block argument
# files. V<top>.mk is a stage-2 product -- never create, touch or depend on it
# here, or stage 2 is skipped and a flat parent is built instead.
$(VERILATOR_HIER_MK): $(VERILATOR_FLIST) $(VERILATOR_CONFIG_STAMP) \
	$(VERILATOR_CONTROL) $(VERILATOR_HIER_PARAMS) $(VERILATOR_VERSION_LOG) \
	| $(VERILATOR_BUILD_DIR)
	cd $(VERILATOR_BUILD_DIR) && \
		{ $(if $(VERILATOR_TIME),$(VERILATOR_TIME) -v -o $(VERILATOR_BUILD_DIR)/codegen.time.log,) \
		$(VERILATOR) $(VERILATOR_CONTROL) --hierarchical \
		--hierarchical-params-file $(VERILATOR_HIER_PARAMS) \
		$(VERILATOR_ARGS) $(VERILATOR_HIER_FLIST_FLAGS) \
		--cc --exe $(VERILATOR_MAIN) -Mdir $(VERILATOR_OBJ_DIR) \
		-CFLAGS "$(VERILATOR_CFLAGS) $(VERILATOR_ABI_CFLAGS)" \
		--top-module $(VERILATOR_TOP) \
		-f $(VERILATOR_FLIST); \
		echo $$? > $(VERILATOR_BUILD_DIR)/.codegen.status; } 2>&1 \
		| tee $(VERILATOR_CODEGEN_LOG); \
		exit $$(cat $(VERILATOR_BUILD_DIR)/.codegen.status)
	@test -f $(VERILATOR_HIER_MK)
	# The planner leaves this file alone when the plan is unchanged, so a merely
	# newer prerequisite would re-run Verilator on every make. Touch to converge.
	@touch $(VERILATOR_HIER_MK)

$(VERILATOR_CODEGEN_STAMP): $(VERILATOR_HIER_MK)
	@touch $@

# Stage 2: native build, driven by Verilator's generated makefile.
# VM_TRACE* are compiler flags the generated makefiles do not track, and tracing
# changes the model's class layout, so objects left over from another trace
# setting would silently mix ABIs. Drop them when it changes; unchanged leaves
# the tree alone, keeping a no-change rebuild a no-op.
$(VERILATOR_BIN): $(VERILATOR_CODEGEN_STAMP) $(VERILATOR_MAIN)
	@mode="structs=$(VERILATOR_TRACE_STRUCTS) params=$(VERILATOR_TRACE_PARAMS)"; \
	if [ -d $(VERILATOR_OBJ_DIR) ] && [ "$$mode" != "$$(cat $(VERILATOR_TRACE_MODE) 2>/dev/null)" ]; then \
	  echo "trace configuration changed to [$$mode]; dropping stale objects"; \
	  find $(VERILATOR_OBJ_DIR) \( -name '*.o' -o -name '*.a' -o -name '*.d' \) -delete; \
	fi; \
	printf '%s\n' "$$mode" > $(VERILATOR_TRACE_MODE)
	{ $(if $(VERILATOR_TIME),$(VERILATOR_TIME) -v -o $(VERILATOR_BUILD_DIR)/build.time.log,) \
		$(MAKE) -C $(VERILATOR_OBJ_DIR) -f V$(VERILATOR_TOP)_hier.mk -j $(VERILATOR_JOBS); \
		echo $$? > $(VERILATOR_BUILD_DIR)/.build.status; } 2>&1 \
		| tee $(VERILATOR_BUILD_LOG); \
		exit $$(cat $(VERILATOR_BUILD_DIR)/.build.status)
	@test -x $@

# The flow only exists for the mesh, and CV32E40X would need per-tile trace
# filenames resolved at run time.
ifeq ($(mesh_dv),0)
.PHONY: verilate-gen verilate-build verilate verilate-check-hierarchy verilate-run
verilate-gen verilate-build verilate verilate-check-hierarchy verilate-run:
	$(error $@ requires mesh_dv=1)
else ifeq ($(core),CV32E40X)
.PHONY: verilate-gen verilate-build verilate verilate-check-hierarchy verilate-run
verilate-gen verilate-build verilate verilate-check-hierarchy verilate-run:
	$(error CV32E40X hierarchical CORE_TRACES needs runtime per-tile filenames)
else
.PHONY: verilate-gen verilate-build verilate
verilate-gen: $(VERILATOR_CODEGEN_STAMP)
verilate-build: $(VERILATOR_BIN)
verilate: $(VERILATOR_BIN) verilate-check-hierarchy

# Inspects the built parent, not just the plan: inlining the tile instead of
# linking the library still builds, and is a failed hierarchical build.
.PHONY: verilate-check-hierarchy
verilate-check-hierarchy: $(VERILATOR_BIN)
	$(BASE_PYTHON) $(VERILATOR_SCRIPTS)/check_hierarchy.py \
		$(VERILATOR_HIER_MK) --module magia_tile_hier \
		--expected-count $(VERILATOR_EXPECTED_TILE_SPECIALIZATIONS) \
		--classes-mk $(VERILATOR_CLASSES_MK) --obj-dir $(VERILATOR_OBJ_DIR)

# Uses whatever model is already in obj_dir: it deliberately does not depend on
# $(VERILATOR_BIN), so an edit anywhere in the RTL cannot turn a run into a
# multi-minute rebuild. Build the model yourself with `make verilate`.
# Runs in the test's build dir, so a relative VERILATOR_FST lands there.
# Output goes straight to the terminal; nothing bounds a hung run.
.PHONY: verilate-run
verilate-run: all
	@test -x $(VERILATOR_BIN) || { \
	  echo "error: no Verilator model at $(VERILATOR_BIN)" >&2; \
	  echo "       build it first: make verilate core=$(core) mesh_dv=$(mesh_dv)" >&2; \
	  exit 1; }
	@cd $(TEST_BUILD_DIR) && \
	  $(VERILATOR_BIN) \
	    +INST_HEX=$(inst_hex_name) +DATA_HEX=$(data_hex_name) \
	    +INST_ENTRY=$(inst_entry) +DATA_ENTRY=$(data_entry) \
	    +BOOT_ADDR=$(boot_addr) +itb_file=$(itb_file) \
	    $(if $(VERILATOR_FST),+FST=$(VERILATOR_FST),)
endif

# Guarded: this is an rm -rf of a variable path.
.PHONY: clean-verilate
clean-verilate:
	@test -n "$(VERILATOR_BUILD_DIR)"
	@test "$(VERILATOR_BUILD_DIR)" = "$(MAGIA_ROOT)/verilator/build"
	rm -rf $(VERILATOR_BUILD_DIR)
