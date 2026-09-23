# Copyright 2026 ETH Zurich and University of Bologna
# SPDX-License-Identifier: Apache-2.0
#
# svguard lint (https://github.com/FrancescoConti/SVGuard) on the synthesis
# view of the mesh (same Bender targets/defines as synth-ips).
#
#   make svguard-flist  generate svguard/build/svguard.f with Bender (paths
#                       relative to the repository root, so the flist can be
#                       passed between CI jobs; svguard runs from there too)
#   make svguard        lint it; errors fail everywhere, warnings are only
#                       reported for MAGIA RTL (dependencies are waived, see
#                       svguard/waivers.toml). SVGUARD_RULES selects the rules
#                       (--rules SPEC, default: all but style checks)
#   make svguard-autofix  fix findings in place with --autofix, in MAGIA RTL
#                       only: dependencies are fully waived (see
#                       svguard/waivers-autofix.toml). SVGUARD_AUTOFIX selects
#                       the rules (--autofix SPEC, default: every fixable rule)

SVGUARD           ?= svguard
SVGUARD_DIR       := $(MAGIA_DIR)/svguard
SVGUARD_BUILD_DIR ?= $(SVGUARD_DIR)/build
SVGUARD_FLIST     := $(SVGUARD_BUILD_DIR)/svguard.f
SVGUARD_TOP       ?= magia
SVGUARD_FORMAT    ?= text
SVGUARD_REPORT    ?= $(SVGUARD_BUILD_DIR)/svguard.log
SVGUARD_DEFS      := -DSYNTHESIS -DTARGET_SYNTHESIS
SVGUARD_RULES     ?= -style.*
SVGUARD_AUTOFIX   ?=
SVGUARD_AUTOFIX_WAIVERS ?= $(SVGUARD_DIR)/waivers-autofix.toml
SVGUARD_AUTOFIX_REPORT  ?= $(SVGUARD_BUILD_DIR)/svguard-autofix.log

.PHONY: svguard-flist svguard svguard-autofix clean-svguard

svguard-flist:
	mkdir -p $(SVGUARD_BUILD_DIR)
	$(BENDER) script flist-plus --relative-path \
	$(common_targs) $(common_defs) \
	$(synth_targs)  $(synth_defs)  \
	> $(SVGUARD_FLIST)

svguard: $(SVGUARD_FLIST)
	rm -f $(SVGUARD_REPORT)
	cd $(MAGIA_DIR) && $(SVGUARD) --config $(SVGUARD_DIR)/svguard.toml \
	--rules '$(SVGUARD_RULES)'                      \
	--format $(SVGUARD_FORMAT) -o $(SVGUARD_REPORT) \
	--top $(SVGUARD_TOP) $(SVGUARD_DEFS)            \
	-f $(SVGUARD_FLIST)                             \
	|| { [ ! -f $(SVGUARD_REPORT) ] || cat $(SVGUARD_REPORT); exit 1; }
	cat $(SVGUARD_REPORT)

svguard-autofix: $(SVGUARD_FLIST)
	rm -f $(SVGUARD_AUTOFIX_REPORT)
	cd $(MAGIA_DIR) && $(SVGUARD) --config $(SVGUARD_DIR)/svguard.toml \
	--waivers $(SVGUARD_AUTOFIX_WAIVERS)                         \
	--autofix$(if $(SVGUARD_AUTOFIX),=$(SVGUARD_AUTOFIX))        \
	--format $(SVGUARD_FORMAT) -o $(SVGUARD_AUTOFIX_REPORT)      \
	--top $(SVGUARD_TOP) $(SVGUARD_DEFS)                         \
	-f $(SVGUARD_FLIST)                                          \
	|| { [ ! -f $(SVGUARD_AUTOFIX_REPORT) ] || cat $(SVGUARD_AUTOFIX_REPORT); exit 1; }
	cat $(SVGUARD_AUTOFIX_REPORT)

$(SVGUARD_FLIST):
	$(MAKE) svguard-flist

clean-svguard:
	rm -rf $(SVGUARD_BUILD_DIR)
