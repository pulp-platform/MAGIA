# CoreMark on MAGIA

CoreMark (EEMBC) on the control core of a tile, to compare where its data live: the L1 scratchpad, the L2
through the data cache, the L2 with the cache off.

| File | What |
|---|---|
| `core_list_join.c`, `core_main.c`, `core_matrix.c`, `core_state.c`, `core_util.c`, `eembc/coremark.h`, `LICENSE.md` | EEMBC CoreMark, github.com/eembc/coremark at `9d07b05`, unchanged: `md5sum -c` with its `coremark.md5` |
| `core_portme.h`, `core_portme.c` | the MAGIA port: `mcycle` for the time, the variant, `ee_printf` on tinyprintf |
| `coremark.h`, `eembc/core_portme.h` | include guard around `eembc/coremark.h` and the exit code; a redirect to the port |
| `coremark_test.c` | the test: one source file that includes all of the above (MAGIA builds one file per test) |

```
make all test=coremark_test dcache=1 EXTRA_CFLAGS="-DCOREMARK_MEM=1 -DITERATIONS=1"
```

| Define | Default | |
|---|---|---|
| `COREMARK_MEM` | 1 | 0: data on the stack (L1 SPM); 1: in `.bss`, L2 through the cache; 2: in `.bss`, cache off |
| `COREMARK_PF` | 0 | 1: next-line prefetch on |
| `ITERATIONS` | 1 | iterations of the timed run |

The exit code is 0 when the CRCs are the known ones (2K performance run, seeds 0, 0, 0x66). The last lines give
the result: `COREMARK mem=.. iterations=.. cycles=.. cycles_per_iter=.. coremark_per_mhz_x1000=..` and the cache
counters of the timed part. CoreMark always prints "Must execute for at least 10 secs": a simulation runs for
milliseconds, so these are cycle counts, not a reportable score.

Compiler: GCC 14 and the corev GCC stop with an internal error on `core_state.c` at `-O2` (`maybe_postinc`, with
the CV32 post-increment loads): `coremark_test.c` turns the loop optimizer off for that file only.
