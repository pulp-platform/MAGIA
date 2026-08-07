  If the hierarchy is genuinely dead, the ordering is

  1. Drop optimization on the generated C++. You said sim speed doesn't matter. VERILATOR_CFLAGS ?= -O2 currently, and the native
  build was 1589 s of the ~2530 s total. -O0 (or -O1) on 2.6 GiB of generated code is typically a 2–4× win on that phase, and it's a
  one-variable change with no rebuild-graph consequences.

  2. Use a faster linker. The binary is ~146 MB and gets relinked on every parent-side change — including the testbench edit you're
  building now. mold or lld via LDFLAGS turns a single-threaded multi-minute link into seconds, if either is available on this host.

  3. Reconsider -j64 on this host. Codegen peaked at ~18 GiB RSS in a single Verilator process, so a high job count buys nothing
  there, and 64 concurrent g++ instances over 2.6 GiB of generated code on a shared machine can thrash or OOM into being slower than
  -j16. Worth one measurement rather than assuming more is better.

  4. Make the mesh size overridable. N_TILES_X/N_TILES_Y are hardcoded localparams in hw/mesh/magia_pkg.sv — Plan 1 already flagged
  this as a deviation. A 2×2 dev configuration cuts parent elaboration roughly 4×. This only affects the parent, so it composes with
  a working hierarchy rather than competing with it.

  5. Then, and only then, tune --output-split. 2149 files at the default threshold is a lot of per-file overhead; the split controls
  the file-count/parallelism trade-off. Pointless to tune while the parent is emitting four times more code than it should.

  6. Additional hier_blocks (RedMulE, Spatz, the NoC router) — DETAILED_PLAN_6.md Step 5 lists this as an optional refinement.
  Genuinely useful, but strictly after the tile block works; today it would just add more unused libraries.