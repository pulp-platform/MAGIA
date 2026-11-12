# Spatz Vector Unit in MAGIA
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](../LICENSE.APACHE)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](../LICENSE.SHL)

Each tile with `TileCfg.EnSpatzCC` has a vector core: a [CV32E40PX](https://github.com/FondazioneChipsIT/cv32e40px)
(`lb/magia_cv32e40px`) with the [Spatz](https://github.com/FondazioneChipsIT/spatz_vpu) vector unit
(`dpala/cv32e40px_integration`) on its CORE-V eXtension Interface (XIF). The CV32 control core boots it and
dispatches tasks to it exactly like to core 0 of the PULP cluster: same registers, same embedded-binary flow.

- RISC-V Vector Extension 1.0, configured by `spatz_pkg` inside `spatz_vpu` (VLEN=512, 4 FPUs, 1 IPU, ELEN=64)
- Scalar ISA RV32IMF (+Xf16) on the CV32E40PX, no A and no D
- Vector loads and stores go straight to the tile L1 through the HCI; they must target L1
- Tasks are compiled with LLVM into a position-independent binary embedded in the CV32 ELF

## Hardware

`hw/tile/cv32e40px_spatz_wrapper.sv`, instantiated in `magia_isle` next to its control registers and i$:

| Part | Connection |
|------|------------|
| CV32E40PX (`magia_cv32e40px_wrap`, `COREV_X_IF=1`, F registers) | fetch through its own i$ on `AXI_SLV_SPATZ_INSTR_IDX` |
| Scalar data port | `core_data_demux`: L1 ranges to one HCI port, everything else to the OBI crossbar |
| Spatz VLSU | `spatz_pkg::N_FU` TCDM ports, each split into `ELEN/32` HCI ports |
| XIF issue/result | mapped onto Spatz' accelerator issue/response channels |
| Control registers | `obi_slave_ctrl_cluster` with `NumCores = 1`, at `SPATZ_CTRL_BASE = 0xA0002200` |
| START | level on the core's machine external interrupt: wakes the dispatcher from WFI |
| DONE | Event Unit event `EU_SPATZ_DONE` (bit 8) of the control core |

What the wrapper adds on top of the XIF:

- **Memory order.** The XIF has no fence: scalar loads/stores wait while an offloaded vector load/store or
  a VLSU request is in flight. A task can read with scalar code what it just stored with `vse`.
- **Operands.** An instruction is offloaded only when ID could advance and no load or FP operation is in
  flight in the core, so the scalar operands it carries are up to date.
- **Results.** They wait while the core sleeps in WFI (its clock is gated).
- **`vfmv.f.s` is refused** (illegal instruction): the core writes XIF results only into the integer
  registers. Use `vmv.x.s` and move the bits (see `fdotp_v16b` in `spatz_workers.h`).

The vector FP flags are not merged into the core's `fflags`; the vector unit reads the core's `frm`.

`tcdm64_to_dual_tcdm32` sends a fully masked 64-bit VLSU store to a bank with no byte enabled: the VLSU
waits for every store ack.

Fixes in the dependencies, found with this integration:

- `spatz_vpu` `lb/px-spatz_vpu`: every unit response is buffered until it reaches the core (they were
  lost on collisions, and `vmv.x.s` deadlocked), `rd` is written only for scalar results, and the core is
  told to wait for any instruction that writes `rd`.
- `cv32e40px` (on top of `lb/magia_cv32e40px`): the scalar operand of the OPFVF instructions
  (`vfadd.vf`, `vfmacc.vf`, ...) is read from the F registers instead of the X registers, the stride of
  the strided vector stores (`vsse*`) is read from the X registers instead of the F registers, an
  instruction no longer writes a register that an offloaded instruction (e.g. `vmv.x.s`) is still due to write,
  and an instruction the coprocessor does not accept traps with its own `mepc` instead of the next one's.

### Control registers

| Register | Offset | Access | Description |
|----------|--------|--------|-------------|
| `SPATZ_FETCH_EN` | 0x00 | R/W | Boot enable, sticky in the core; every write resets READY |
| `SPATZ_BINARY`   | 0x04 | R/W | Boot address |
| `SPATZ_DONE`     | 0x08 | W   | Spatz signals the end of a task, raising `EU_SPATZ_DONE` |
| `SPATZ_TASKBIN`  | 0x0C | R/W | Task function address |
| `SPATZ_DATA`     | 0x10 | R/W | Task argument, passed in `a0` |
| `SPATZ_START`    | 0x14 | R/W | CV32 writes 1 to dispatch, Spatz writes 0 to ACK |
| `SPATZ_READY`    | 0x18 | R/W | 1 once Spatz has booted |
| `SPATZ_RETURN`   | 0x1C | R/W | Task exit code; bit 31 set with `mcause` if Spatz trapped |

## Software

`spatz/sw/kernel/spatz_crt0.S` sets the stack (private L1, `[0xA011C000, 0xA0120000)`), clears BSS, enables
FP and vector state, zeroes the VRF and posts READY. Its dispatcher loop then sleeps in WFI, reads
TASKBIN and DATA, ACKs START, calls the task and writes RETURN and DONE.

### CV32 side (`sw/utils/magia_spatz_utils.h`)

```c
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "my_test_task_bin.h"   // Generated: SPATZ_BINARY_START and the *_TASK entry points

int main(void) {
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);                       // Once after reset

    spatz_run_task_with_params(MY_VECTOR_TASK, params);   // Returns once Spatz has taken the task
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    return spatz_get_exit_code();
}
```

### Spatz side (`spatz/sw/tasks/<name>_task.c`)

```c
#include "magia_tile_utils.h"

int my_vector_task(void *params) {   // params is SPATZ_DATA; mmio32(SPATZ_DATA) works too
    asm volatile("vsetvli zero, %0, e32, m4, ta, ma" :: "r"(32));
    return 0;                         // Exit code in SPATZ_RETURN
}
```

The top-level Makefile finds every `*_TASK` used by the CV32 test, builds the matching `spatz/sw/tasks/*.c`
with the Spatz LLVM (`SPATZ_LLVM_PATH`, default `/opt/riscv/spatz-22-llvm`, `-march=rv32imf_zve64f_zfh`,
`-fPIE`) and generates `spatz/sw/headers_bin/<test>_task_bin.h`, linked in `.spatz_binary`.
The compiler never emits vector code on its own (`-mno-implicit-float`, no vectorizers, as spatz_vpu's
toolchain): the VLSU reaches only L1, and the binary's data live in L2.

## Tests

| Test | What |
|------|------|
| `spatz_tests/simple_spatz_test` | Boot and one task |
| `spatz_tests/instructions_sweep_spatz_test` | Scalar F and vector instructions, must not trap |
| `spatz_tests/rvv_riscv_test` | One riscvTest of spatz_vpu (`RVV_TEST=vadd` by default) |
| `scripts/spatz_rvv_sweep.sh` | Every riscvTest of spatz_vpu (`-k sdk`: every magia-sdk Spatz test), Verilator, in parallel |
| `spatz_tests/sdk_spatz_test` | One magia-sdk Spatz test, unchanged (`SDK_TEST=onnx_add`), over the HAL shims in `sdk_shim/` |
| `spatz_tests/{vecsum,dotp,gemv,gemm,matmul_compare}_spatz_test` | Kernels checked against a golden result |

```bash
make verilate mesh_dv=0                                # Tile model, once
make clean all test=rvv_riscv_test RVV_TEST=vfadd mesh_dv=0
make verilate-run test=rvv_riscv_test mesh_dv=0
scripts/spatz_rvv_sweep.sh -j 16                       # Results in sw/tests/spatz_tests/rvv_riscv_test/sweep/
git submodule update --init magia-sdk                   # Once, for the magia-sdk tests
scripts/spatz_rvv_sweep.sh -k sdk -j 16                # Results in sw/tests/spatz_tests/sdk_spatz_test/sweep/
```

The riscvTests run with `ELEN=32` (`RVV_TEST_ELEN`): their e64 cases pass FP64 scalars in F registers,
which needs the D extension the CV32E40PX does not have.

## License
All `software` sources are licensed under the Apache License 2.0 ([`LICENSE.APACHE`](../LICENSE.APACHE)). All `hardware` sources are licensed under the Solderpad Hardware License 0.51 ([`LICENSE.SHL`](../LICENSE.SHL)).
