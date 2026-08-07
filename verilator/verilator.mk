# Copyright 2026 ETH Zurich and University of Bologna
# SPDX-License-Identifier: Apache-2.0

MAGIA_ROOT  ?= $(shell git rev-parse --show-toplevel)
VERILATOR   ?= verilator
BASE_PYTHON ?= python3

VERILATOR_BUILD_DIR ?= $(MAGIA_ROOT)/verilator/build
VERILATOR_HIER_DIR   := $(VERILATOR_BUILD_DIR)/hier
VERILATOR_OBJ_DIR    := $(VERILATOR_HIER_DIR)/obj_dir
VERILATOR_TOP        := magia_tb
VERILATOR_CONTROL    := $(MAGIA_ROOT)/verilator/magia_hier.vlt
# Required for hier_block substitution to happen at all; see the file itself.
VERILATOR_HIER_PARAMS := $(MAGIA_ROOT)/verilator/magia_hier_params.v

VERILATOR_JOBS          ?= 4
VERILATOR_TRACE         ?= 0
VERILATOR_TRACE_STRUCTS ?= 0
VERILATOR_TRACE_PARAMS  ?= 0
VERILATOR_CFLAGS        ?= -O2
VERILATOR_RUN_TIMEOUT   ?= 120
VERILATOR_EXPECTED_TILE_SPECIALIZATIONS ?= 1

_VERILATOR_JOBS_NUM := $(strip $(shell expr $(VERILATOR_JOBS) + 0 2>/dev/null))
ifeq ($(_VERILATOR_JOBS_NUM),)
$(error VERILATOR_JOBS must be a positive integer, got '$(VERILATOR_JOBS)')
endif
ifeq ($(_VERILATOR_JOBS_NUM),0)
$(error VERILATOR_JOBS must be a positive integer, got '$(VERILATOR_JOBS)')
endif

_VERILATOR_EXPECTED_NUM := $(strip $(shell expr $(VERILATOR_EXPECTED_TILE_SPECIALIZATIONS) + 0 2>/dev/null))
ifeq ($(_VERILATOR_EXPECTED_NUM),)
$(error VERILATOR_EXPECTED_TILE_SPECIALIZATIONS must be a positive integer)
endif
ifeq ($(_VERILATOR_EXPECTED_NUM),0)
$(error VERILATOR_EXPECTED_TILE_SPECIALIZATIONS must be a positive integer)
endif

ifeq ($(VERILATOR_TRACE),0)
ifneq ($(VERILATOR_TRACE_STRUCTS),0)
$(error VERILATOR_TRACE_STRUCTS=1 requires VERILATOR_TRACE=1)
endif
ifneq ($(VERILATOR_TRACE_PARAMS),0)
$(error VERILATOR_TRACE_PARAMS=1 requires VERILATOR_TRACE=1)
endif
endif

VERILATOR_ARGS = -j $(VERILATOR_JOBS) -Wno-fatal \
	-Wno-style -Wno-timescalemod -Wno-redefmacro -Wno-implicit \
	-Wno-ascrange -Wno-widthexpand -Wno-widthconcat -Wno-misindent \
	-Wno-pinmissing -Wno-widthtrunc -Wno-unsigned -Wno-cmpconst \
	-Wno-userfatal -Wno-caseincomplete -Wno-combdly -Wno-latch \
	-Wno-unoptflat -Wno-blkandnblk -Wno-ENUMVALUE \
	--timing --autoflush

ifeq ($(VERILATOR_TRACE),1)
VERILATOR_ARGS += --trace-fst
ifeq ($(VERILATOR_TRACE_STRUCTS),1)
VERILATOR_ARGS += --trace-structs
endif
ifeq ($(VERILATOR_TRACE_PARAMS),1)
VERILATOR_ARGS += --trace-params
endif
endif

RISCV_DBG_ROOT    ?= $(shell $(BENDER) path riscv-dbg)
FRACTAL_SYNC_ROOT ?= $(shell $(BENDER) path fractal_sync)
VERILATOR_DPI := \
	$(RISCV_DBG_ROOT)/tb/remote_bitbang/sim_jtag.c \
	$(RISCV_DBG_ROOT)/tb/remote_bitbang/remote_bitbang.c

VERILATOR_BENDER_TARGS := $(bender_targs) \
	-t tech_cells_generic_include_deprecated -t verilator -t rtl_sim \
	-t verilator_dpi -t magia_dv -t simulation -t cv32e40p_exclude_tracer

VERILATOR_RAW_FLIST := $(VERILATOR_HIER_DIR)/magia.raw.f
VERILATOR_FLIST := $(VERILATOR_HIER_DIR)/magia.f
VERILATOR_BENDER_STAMP := $(VERILATOR_HIER_DIR)/bender.stamp
VERILATOR_CONFIG_STAMP := $(VERILATOR_HIER_DIR)/config.stamp
VERILATOR_VERSION_LOG := $(VERILATOR_HIER_DIR)/verilator-version.log
VERILATOR_PARENT_MK := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP).mk
VERILATOR_HIER_MK := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)_hier.mk
VERILATOR_CODEGEN_STAMP := $(VERILATOR_HIER_DIR)/codegen.stamp
VERILATOR_BIN := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)
VERILATOR_RUN_LOG := $(VERILATOR_HIER_DIR)/run.log
VERILATOR_CODEGEN_LOG := $(VERILATOR_HIER_DIR)/codegen.log
VERILATOR_BUILD_LOG := $(VERILATOR_HIER_DIR)/build.log
VERILATOR_CLASSES_MK := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)_classes.mk
VERILATOR_TIME := $(shell command -v /usr/bin/time 2>/dev/null)

$(VERILATOR_BUILD_DIR) $(VERILATOR_HIER_DIR):
	mkdir -p $@

.PHONY: $(VERILATOR_HIER_DIR)/.bender-check
$(VERILATOR_HIER_DIR)/.bender-check: | $(VERILATOR_HIER_DIR)
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

$(VERILATOR_BENDER_STAMP): $(VERILATOR_HIER_DIR)/.bender-check
	@test -f $@

$(VERILATOR_RAW_FLIST): Bender.yml Bender.lock Makefile bender_common.mk \
	bender_sim.mk bender_synth.mk bender_profile.mk $(VERILATOR_BENDER_STAMP) | $(VERILATOR_HIER_DIR)
	$(BENDER) script verilator $(VERILATOR_BENDER_TARGS) $(bender_defs) -DSYNTHESIS -DVERILATOR > $@.tmp
	echo +incdir+$(FRACTAL_SYNC_ROOT)/hw >> $@.tmp
	for f in $(VERILATOR_DPI); do echo $$f >> $@.tmp; done
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv $@.tmp $@; else rm -f $@.tmp; fi

$(VERILATOR_FLIST): $(VERILATOR_RAW_FLIST) \
	$(MAGIA_ROOT)/verilator/filter_filelist.py \
	$(MAGIA_ROOT)/verilator/check_filelist.py | $(VERILATOR_HIER_DIR)
	$(BASE_PYTHON) $(MAGIA_ROOT)/verilator/filter_filelist.py --output $@.tmp < $(VERILATOR_RAW_FLIST)
	$(BASE_PYTHON) $(MAGIA_ROOT)/verilator/check_filelist.py $@.tmp \
		--top $(VERILATOR_TOP) \
		--dpi $(RISCV_DBG_ROOT)/tb/remote_bitbang/sim_jtag.c \
		--dpi $(RISCV_DBG_ROOT)/tb/remote_bitbang/remote_bitbang.c
	@if ! cmp -s $@.tmp $@ 2>/dev/null; then mv $@.tmp $@; else rm -f $@.tmp; fi

.PHONY: verilator-bender
verilator-bender: $(VERILATOR_FLIST)

.PHONY: $(VERILATOR_HIER_DIR)/.config-check
$(VERILATOR_HIER_DIR)/.config-check: | $(VERILATOR_HIER_DIR)
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
	  echo "trace=$(VERILATOR_TRACE)"; \
	  echo "trace_structs=$(VERILATOR_TRACE_STRUCTS)"; \
	  echo "trace_params=$(VERILATOR_TRACE_PARAMS)"; \
	  echo "cflags=$(VERILATOR_CFLAGS)"; \
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
	} > $(VERILATOR_CONFIG_STAMP).tmp
	@if ! cmp -s $(VERILATOR_CONFIG_STAMP).tmp $(VERILATOR_CONFIG_STAMP) 2>/dev/null; then \
	  mv $(VERILATOR_CONFIG_STAMP).tmp $(VERILATOR_CONFIG_STAMP); \
	else rm -f $(VERILATOR_CONFIG_STAMP).tmp; fi

$(VERILATOR_CONFIG_STAMP): $(VERILATOR_HIER_DIR)/.config-check
	@test -f $@

# Verilator 5.046 does not forward +define/+incdir entries expanded from -f
# to child runs, so mirror those flags from the authoritative Bender list.
VERILATOR_HIER_FLIST_FLAGS = $(shell grep -E '^\+(define|incdir)' $(VERILATOR_FLIST))

# Verilator's dependency file is one line listing every generated source as a
# target, V$(VERILATOR_TOP).mk included. That file belongs to the generated
# hierarchy makefile, so keep only the prerequisite list and attach it to the
# codegen product this Makefile does own.
VERILATOR_HIER_DEP    := $(VERILATOR_OBJ_DIR)/V$(VERILATOR_TOP)__hierVer.d
VERILATOR_HIER_DEP_MK := $(VERILATOR_HIER_DIR)/hierVer.mk

-include $(VERILATOR_HIER_DEP_MK)

# Keep only the source prerequisites: entries under the output directory are
# byproducts of this very rule (the child wrapper is written by stage 2, after
# stage 1 produced its target) and would re-trigger codegen on every run.
# Unconditional mv: make re-executes itself after remaking an included
# makefile, so this target must always end up newer than its prerequisite or
# the restart repeats forever.
$(VERILATOR_HIER_DEP_MK): $(VERILATOR_HIER_DEP) | $(VERILATOR_HIER_DIR)
	@{ printf '%s:' '$(VERILATOR_HIER_MK)'; \
	   sed -e 's|^[^:]*:||' -e 's|[^ ]*$(VERILATOR_OBJ_DIR)[^ ]*||g' $<; } > $@.tmp \
	  && mv -f $@.tmp $@

# Stage 1 writes the hierarchy plan: V$(VERILATOR_TOP)_hier.mk and the per-block
# argument files. V$(VERILATOR_TOP).mk is a stage-2 product, regenerated by that
# plan with --hierarchical-block so the tile instance is replaced by the
# prebuilt child library. Never create, touch, or depend on it here: doing so
# makes it look newer than the child wrapper, the stage-2 rule is skipped, and a
# flat parent is compiled and linked instead.
$(VERILATOR_HIER_MK): $(VERILATOR_FLIST) $(VERILATOR_CONFIG_STAMP) \
	$(VERILATOR_CONTROL) $(VERILATOR_HIER_PARAMS) $(VERILATOR_VERSION_LOG) \
	| $(VERILATOR_HIER_DIR)
	cd $(VERILATOR_HIER_DIR) && \
		{ $(if $(VERILATOR_TIME),$(VERILATOR_TIME) -v -o $(VERILATOR_HIER_DIR)/codegen.time.log,) \
		$(VERILATOR) $(VERILATOR_CONTROL) --hierarchical \
		--hierarchical-params-file $(VERILATOR_HIER_PARAMS) \
		$(VERILATOR_ARGS) $(VERILATOR_HIER_FLIST_FLAGS) \
		--cc --main --exe -Mdir $(VERILATOR_OBJ_DIR) \
		-CFLAGS "$(VERILATOR_CFLAGS)" --top-module $(VERILATOR_TOP) \
		-f $(VERILATOR_FLIST); \
		echo $$? > $(VERILATOR_HIER_DIR)/.codegen.status; } 2>&1 \
		| tee $(VERILATOR_CODEGEN_LOG); \
		exit $$(cat $(VERILATOR_HIER_DIR)/.codegen.status)
	@test -f $(VERILATOR_HIER_MK)

$(VERILATOR_CODEGEN_STAMP): $(VERILATOR_HIER_MK)
	@touch $@

$(VERILATOR_BIN): $(VERILATOR_CODEGEN_STAMP)
	{ $(if $(VERILATOR_TIME),$(VERILATOR_TIME) -v -o $(VERILATOR_HIER_DIR)/build.time.log,) \
		$(MAKE) -C $(VERILATOR_OBJ_DIR) -f V$(VERILATOR_TOP)_hier.mk -j $(VERILATOR_JOBS); \
		echo $$? > $(VERILATOR_HIER_DIR)/.build.status; } 2>&1 \
		| tee $(VERILATOR_BUILD_LOG); \
		exit $$(cat $(VERILATOR_HIER_DIR)/.build.status)
	@test -x $@

ifeq ($(mesh_dv),0)
.PHONY: verilate-hier-gen verilate-hier-build verilate-hier verilate verilate-check-hierarchy verilate-run
verilate-hier-gen verilate-hier-build verilate-hier verilate verilate-check-hierarchy verilate-run:
	$(error $@ requires mesh_dv=1)
else ifeq ($(core),CV32E40X)
.PHONY: verilate-hier-gen verilate-hier-build verilate-hier verilate verilate-check-hierarchy verilate-run
verilate-hier-gen verilate-hier-build verilate-hier verilate verilate-check-hierarchy verilate-run:
	$(error CV32E40X hierarchical CORE_TRACES needs runtime per-tile filenames)
else
.PHONY: verilate-hier-gen verilate-hier-build verilate-hier verilate
verilate-hier-gen: $(VERILATOR_CODEGEN_STAMP)
verilate-hier-build: $(VERILATOR_BIN)
verilate-hier verilate: $(VERILATOR_BIN) verilate-check-hierarchy

# Checks the built parent, not just the plan: a parent that inlined the tile
# instead of linking the child library is a failed hierarchical build.
.PHONY: verilate-check-hierarchy
verilate-check-hierarchy: $(VERILATOR_BIN)
	$(BASE_PYTHON) $(MAGIA_ROOT)/verilator/check_hierarchy.py \
		$(VERILATOR_HIER_MK) --module magia_tile_hier \
		--expected-count $(VERILATOR_EXPECTED_TILE_SPECIALIZATIONS) \
		--classes-mk $(VERILATOR_CLASSES_MK) --obj-dir $(VERILATOR_OBJ_DIR)

.PHONY: verilate-run
verilate-run: verilate-hier all
	@command -v timeout >/dev/null 2>&1 || { echo "error: timeout utility is required" >&2; exit 1; }
	@cd $(TEST_BUILD_DIR) && \
	  timeout --foreground $(VERILATOR_RUN_TIMEOUT)s $(VERILATOR_BIN) \
	    +INST_HEX=$(inst_hex_name) +DATA_HEX=$(data_hex_name) \
	    +INST_ENTRY=$(inst_entry) +DATA_ENTRY=$(data_entry) \
	    +BOOT_ADDR=$(boot_addr) +itb_file=$(itb_file) \
	    > $(VERILATOR_RUN_LOG) 2>&1; \
	  status=$$?; cat $(VERILATOR_RUN_LOG); \
	  if [ $$status -eq 124 ]; then \
	    echo "error: hierarchical simulation timed out after $(VERILATOR_RUN_TIMEOUT)s" >&2; \
	  fi; \
	  exit $$status
endif

.PHONY: clean-verilate-hier clean-verilate
clean-verilate-hier clean-verilate:
	@test -n "$(VERILATOR_HIER_DIR)"
	@test "$(VERILATOR_HIER_DIR)" = "$(VERILATOR_BUILD_DIR)/hier"
	rm -rf $(VERILATOR_HIER_DIR)

.PHONY: verilator
