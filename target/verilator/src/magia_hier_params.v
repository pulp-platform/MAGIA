// Copyright 2026 ETH Zurich and University of Bologna
// SPDX-License-Identifier: Apache-2.0
//
// Deliberately empty because: Verilator 5.046 only substitutes a prebuilt hier_block
// library for its instances when ParameterizedHierBlocks::m_hierSubRun is set
// (V3Param.cpp:101-103), and that requires --hierarchical-params-file to be
// present in addition to --hierarchical-block. Verilator emits a parameter
// file of its own only for blocks that have `parameter type` parameters
// (V3HierBlock.cpp:282); magia_tile_hier has none, so without this file the
// top-level Verilation silently de-parameterizes magia_tile_hier into an
// inlined magia_tile_hier__<params> clone per tile and produces a flat model.
// The Verilator engine writes its own parameter files as <prefix>__hierParameters.v
// (V3HierBlock.cpp:110-112), so this one matches what it would have generated.
//
// The option only needs to name a parseable file; no type parameters have to
// be declared here. Add declarations only if magia_tile_hier ever gains type
// parameters, and keep them in sync with what Verilator would generate.
