# Spatz Vector Accelerator in MAGIA
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](../LICENSE.APACHE)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](../LICENSE.SHL)

Spatz is a **RISC-V Vector Extension 1.0 (zve32f) vector co-processor** paired with a **CV32E40PX** scalar core (`cv32e40px_spatz`, referred to below as *Spatz-CV32*) into the MAGIA tile architecture. The vector coprocessor is composed by multiple FPU lanes attached through the CORE-V-X interface. The tile control core (*CV32*, a CV32E40X) drives the Spatz-CV32 through memory-mapped registers and interrupt-driven task dispatching, following an a-CV32elerator-style programming model.

The Spatz -CV32 (legacy) used to be built around a **Snitch** scalar core that booted from a small hardware bootROM. Snitch has been replaced by CV32E40PX, and the bootROM has been removed: the boot address now comes from a control register (see [Boot and Initialization](#️-boot-and-initialization)).

**Key Features:**
- RISC-V Vector Extension 1.0 (RVV) support
- Single-precision floating-point (RVF); double precision (RVD) is not supported yet by the CV32E40PX integration (see [Configuration](#-configuration))
- Configurable vector length (VLEN: 128-512 bits)
- Up to 8 vector FPU lanes
- Clock-gated, interrupt-driven operation
- No bootROM: boot address programmed by the CV32 through the `SPATZ_BINARY` register
- Single source of configuration (`hw/mesh/magia_pkg.sv`) for the hardware and the Spatz software build
- Transparent binary embedding in the CV32 firmware

---

## ⚙️ Hardware Integration

### Main Files

| File | Content |
|------|---------|
| `hw/tile/spatz_cv32_wrapper.sv` | Wraps `cv32e40px_spatz` (CV32E40PX + Spatz): scalar data path to OBI, vector ports to HCI, FPU configuration |
| `hw/tile/obi_slave_ctrl_spatz.sv` | Control registers (clock enable, boot address, task dispatch) |
| `hw/tile/magia_isle.sv` (`gen_spatz_cv32`) | Instantiation: control registers, clock gate, interrupt logic, dedicated I$ |
| `hw/mesh/magia_pkg.sv` | `spatz_cfg_t` and the Spatz configurations (`MagiaSpatzDefaultCfg`) |
| `hw/tile/magia_tile_pkg.sv` | Derived parameters (HCI ports, TCDM widths, FPU implementation, outstanding transactions) |
| `scripts/gen_spatz_vpu_pkg.py` | Generates `spatz_pkg.sv` and the SPATZ_* make variables from the selected configuration |
| `hw/generated/` | Generated files: `spatz_vpu_pkg.sv`, `spatz_cfg.mk` (do not edit) |

### OBI Slave Control Interface

The Spatz -CV32 is controlled through an **OBI slave interface** (`obi_slave_ctrl_spatz`) that exposes memory-mapped control registers. Through it the CV32 can:
- Set the Spatz-CV32 boot address
- Enable/disable the Spatz-CV32 clock
- Set task entry points and task parameters
- Trigger task execution via interrupt
- Read task completion status and exit codes

### Control Registers

Base address: `SPATZ_CTRL_BASE = 0x00001700` (`SPATZ_CTRL_ADDR_START` in `magia_tile_pkg.sv`, window of 0x40 bytes).

| Register Name    | Offset | Address    | Description |
|------------------|--------|------------|-------------|
| `SPATZ_CLK_EN`   | 0x00   | 0x00001700 | Clock enable (write 1 to enable, 0 to disable the Spatz-CV32 clock) |
| `SPATZ_READY`    | 0x04   | 0x00001704 | Ready flag: Spatz-CV32 writes 1 when ready for interrupts, 0 after the first task; CV32 polls it before triggering |
| `SPATZ_START`    | 0x08   | 0x00001708 | Trigger register: write 1 to send an interrupt to the Spatz -CV32, Spatz-CV32 clears it to 0 |
| `SPATZ_TASKBIN`  | 0x0C   | 0x0000170C | Task address: CV32 writes the task entry point, Spatz-CV32 reads it |
| `SPATZ_DATA`     | 0x10   | 0x00001710 | Parameter pointer: CV32 writes a pointer to the task parameters, Spatz-CV32 reads it |
| `SPATZ_RETURN`   | 0x14   | 0x00001714 | Return value: Spatz-CV32 writes the task exit code (0 = success, non-zero = error/exception), CV32 reads it |
| `SPATZ_DONE`     | 0x18   | 0x00001718 | Done flag: Spatz-CV32 writes 1 when the task completes, generates a 1-cycle pulse to the Event Unit, auto-clears |
| `SPATZ_BINARY`   | 0x1C   | 0x0000171C | Boot address of Spatz-CV32 (`boot_addr_i` and `mtvec_addr_i`). CV32 writes `SPATZ_BINARY_START` here **before** `SPATZ_CLK_EN = 1`. Reset value: `0x0` |

Reads outside the 8 registers return `0xDEADBEEF`.

**Register Behavior:**
- **CLK_EN, START, READY, TASKBIN, DATA, RETURN, BINARY**: preserved registers, values persist until overwritten
- **DONE**: pulse register, auto-clears after one cycle; it drives the `EU_ACC_SPATZ_DONE` Event Unit line

**Signal Flow:**
1. CV32 writes the Spatz binary start address to `SPATZ_BINARY`
2. CV32 enables the clock via `SPATZ_CLK_EN = 1`; Spatz-CV32 boots from `SPATZ_BINARY`
3. CV32 waits for `SPATZ_READY` to become 1 (Spatz-CV32 initialized and waiting in WFI)
4. CV32 writes the parameter pointer to `SPATZ_DATA` (optional, only if the task needs parameters)
5. CV32 writes the task address to `SPATZ_TASKBIN` and 1 to `SPATZ_START` → interrupt to Spatz-CV32
6. Spatz-CV32 wakes from WFI, reads the task address from `SPATZ_TASKBIN`, clears `SPATZ_START` to 0
7. CV32 waits for `SPATZ_START` to become 0 (Spatz-CV32 has saved the task address)
8. Spatz-CV32 executes the task, which reads its parameters from the address in `SPATZ_DATA`
9. The task completes: exit code to `SPATZ_RETURN`, then 1 to `SPATZ_DONE`
10. `SPATZ_DONE` generates a 1-cycle pulse to the Event Unit, CV32 wakes from WFE/polling
11. CV32 reads the exit code from `SPATZ_RETURN` (0 = success)

### Interrupt

`SPATZ_START` is the only interrupt source of Spatz-CV32. In `magia_isle.sv` a rising edge of `SPATZ_START` sets a pending latch, which drives the Machine External Interrupt (`irq_i[11]`). The latch is cleared when Spatz-CV32 acknowledges interrupt 11 (`irq_ack_o` with `irq_id_o == 11`), so holding `SPATZ_START` high does not re-trigger the interrupt. The `SPATZ_START` level is also sent to the Event Unit (`EU_OTHER_SPATZ_START`).

### Clock Gating

The Spatz -CV32 (core, vector unit, I$ and interrupt logic) runs on `spatz_clk`, produced by a `tc_clk_gating` cell enabled by `SPATZ_CLK_EN`. `fetch_enable_i` of Spatz-CV32 is tied to 1: the core starts fetching on the first clock edge after `SPATZ_CLK_EN = 1`.

---

## 🚀 Quick Start

### Typical CV32 Test with Spatz Tasks
```c
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "my_test_task_bin.h"  // REQUIRED - auto-generated header with SPATZ_BINARY_START and task symbols

int main(void) {
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);

    // Task with parameters via SPATZ_DATA register (optional)
    typedef struct { uint32_t addr; uint32_t size; } params_t;
    params_t params = {.addr = DATA_BASE, .size = 1024};

    spatz_init(SPATZ_BINARY_START);  // SPATZ_BINARY = start, CLK_EN = 1, wait for READY

    spatz_pass_params((uint32_t)&params);  // Optional: pass params pointer via SPATZ_DATA

    spatz_run_task(MY_VECTOR_TASK);  // MY_VECTOR_TASK defined in the auto-generated header
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

    if (spatz_get_exit_code() != 0) {
        printf("Task failed: 0x%03lx\n", spatz_get_exit_code());
        return 1;
    }

    spatz_clk_dis();  // Power saving
    return 0;
}
```

**Header Naming Convention:**
- Test file: `sw/tests/my_test.c`
- Generated header: `spatz/sw/headers_bin/my_test_task_bin.h`
- Include in your test: `#include "my_test_task_bin.h"`

### Writing a Spatz Task

Create `spatz/sw/tasks/my_vector_task.c`:

```c
#include "magia_tile_utils.h"
#include "magia_spatz_utils.h"

// Define parameter structure (optional, if the task needs parameters)
typedef struct {
    uint32_t data_addr;
    uint32_t size;
} my_params_t;

int my_vector_task(void) {
    // Read parameter pointer from SPATZ_DATA register (if the task uses parameters)
    uint32_t params_ptr = mmio32(SPATZ_DATA);
    volatile my_params_t *params = (volatile my_params_t *)params_ptr;

    uint32_t data_addr = params->data_addr;
    uint32_t size = params->size;

    // Your vector code here using RVV intrinsics or assembly
    asm volatile("vsetvli zero, %0, e32, m4, ta, ma" ::"r"(32));
    // ... vector operations ...

    return 0;  // Exit code: 0 = success, non-zero = error
}
```

**Naming Convention (Required):**
- File: `*_task.c` (lowercase, ends with `_task`)
- Function: `int *_task(void)` (matches the file name)
- Symbol: `*_TASK` (uppercase in the generated header)

**Reading Parameters:**
- Parameters are passed via a pointer in the `SPATZ_DATA` register
- The task reads `SPATZ_DATA` to get the pointer to the parameter structure in L1
- CV32 must write the parameters to L1 before triggering the task

---

## 🔧 Configuration

### Single Source of Configuration

The Spatz parameters live **only** in `hw/mesh/magia_pkg.sv`, as `spatz_cfg_t` localparams. The tile configuration (`magia_tile_cfg_t.Spatz`) points to one of them, and the same values drive the `spatz_vpu` package and the Spatz software build.

```systemverilog
localparam spatz_cfg_t MagiaSpatzDefaultCfg = '{
  RVD:      1'b0,   // Double precision (64-bit TCDM)
  RVF:      1'b1,   // Single-precision FP
  RVV:      1'b1,   // Vector extension
  NumIPU:   1,      // Integer processing units
  NumFPU:   4,      // FP processing units (vector lanes)
  NumPorts: 4,      // VLSU ports, a multiple of NumFPU
  XDivSqrt: 1'b0,   // FP div/sqrt
  XDMA:     1'b0,   // DMA inside the Spatz -CV32
  VLEN:     256,    // Vector length in bits
  ICacheL0LineCount: 8,    // Spatz I$: private L0 lines
  ICacheLineWidth:   256,  // Spatz I$: line width in bits
  ICacheLineCount:   32,   // Spatz I$: set count
  ICacheWays:        2     // Spatz I$: associativity
};
```

Keep the field values plain literals: `scripts/gen_spatz_vpu_pkg.py` parses them from the source.

| Field | Default | Description |
|-------|---------|-------------|
| `RVD` | 0 | 0: 32-bit TCDM (ELEN=32); 1: 64-bit TCDM (ELEN=64, double precision). **Must be 0** with CV32E40PX: `spatz_cv32_wrapper` supports 32-bit Spatz TCDM ports only and stops elaboration otherwise |
| `RVF` | 1 | Single-precision floating-point (`RVD=1` requires `RVF=1`) |
| `RVV` | 1 | RISC-V Vector extension |
| `NumIPU` | 1 | Integer processing units (≥ 1) |
| `NumFPU` | 4 | FP processing units (≥ 1) |
| `NumPorts` | 4 | VLSU ports; must be a multiple of `NumFPU` |
| `XDivSqrt` | 0 | FP div/sqrt |
| `XDMA` | 0 | DMA inside the Spatz -CV32 |
| `VLEN` | 256 | Vector register length in bits (128, 256, 512) |
| `ICache*` | see above | Geometry of the dedicated Spatz I$ |

### Selecting a Configuration

The Makefile variable `spatz_cfg` selects which configuration to use:

| `spatz_cfg` | Configuration |
|-------------|---------------|
| `default` | `MagiaSpatzDefaultCfg` (the default when `mesh_dv=1`) |

`spatz_cfg` is required only by the targets that write the compile script (`vsim-scripts`, `update-ips`, `synth-ips`, `profile-ips`, `spatz-vpu-pkg`). They generate `hw/generated/spatz_cfg.mk`, which the other targets (SW build, `run`) include. With `mesh_dv=0` you must pass `spatz_cfg=default` explicitly.

To add a configuration: add a new `spatz_cfg_t` localparam in `magia_pkg.sv`, add `SPATZ_CFG_NAME_<name> := <LocalparamName>` to the Makefile, point the tile configuration to it and run `make vsim-scripts spatz_cfg=<name>`.

### `spatz_pkg` Generation

The `spatz_vpu` dependency ships a pre-generated `spatz_pkg.sv` for its own configuration (RVD=1, VLEN=512). MAGIA does not modify `spatz_vpu`; instead:

1. `make spatz-vpu-pkg` (called automatically by `vsim-scripts` and the other compile-script targets) runs `scripts/gen_spatz_vpu_pkg.py`.
2. The script reads the selected `spatz_cfg_t` from `magia_pkg.sv`, checks it (`RVD` ⇒ `RVF`, `NumFPU`/`NumIPU` ≥ 1, `NumPorts` multiple of `NumFPU`) and renders `spatz_vpu`'s own Mako template (`hw/src/spatz_pkg.sv.tpl`), the same way `spatz_vpu`'s `util/apply_cfg.py` does. It also adds `SCALAR_FPU_SUPPORT`, which `spatz.sv` needs but the template lacks.
3. The output goes to `hw/generated/spatz_vpu_pkg.sv`, and the SPATZ_* make variables go to `hw/generated/spatz_cfg.mk`. Files are rewritten only when their content changes.
4. The Makefile swaps the `spatz_vpu` `spatz_pkg.sv` with `hw/generated/spatz_vpu_pkg.sv` in the compile script, and fails if the original is still referenced.

Generated `spatz_cfg.mk` (default configuration):
```makefile
SPATZ_RVD := 0
SPATZ_RVF := 1
SPATZ_RVV := 1
SPATZ_VLEN := 256
SPATZ_N_IPU := 1
SPATZ_N_FPU := 4
SPATZ_XDIVSQRT := 0
SPATZ_XDMA := 0
```

The Spatz SW build (`spatz/sw/Makefile`) receives these variables, so `-march` and the `-DSPATZ_*` defines always match the hardware. `spatz_cv32_wrapper` also checks at elaboration that `spatz_pkg::ELEN` matches the TCDM port width; if it does not, regenerate the compile script (`make vsim-scripts`).

### FPU Configuration

`cv32e40px_spatz` takes the FPU configuration of the Spatz lanes as a parameter (`SpatzFPUImplementation`). In `spatz_cv32_wrapper.sv` it is set by `SPATZ_FPU_IMPL`, which defaults to `fpnew_pkg::DEFAULT_SNITCH`.

The scalar FPU of Spatz-CV32 is enabled (`CV32_FPU = 1`, `ZFINX = 0`). `spatz_crt0.S` sets `mstatus.FS` and `mstatus.VS` to Initial: with `FS = Off` the core would offload scalar FP instructions to Spatz.

### Advanced Parameters

Defined in `hw/tile/magia_tile_pkg.sv`. See the [Spatz documentation](https://github.com/pulp-platform/spatz) for details.

**Memory & Transactions:**
- `SPATZ_NUM_INT_OUTSTANDING_LOADS`, `SPATZ_NUM_INT_OUTSTANDING_MEM`
- `SPATZ_NUM_SPATZ_OUTSTANDING_LOADS`

**Pipeline:**
- `SPATZ_REGISTER_OFFLOAD_RSP`, `SPATZ_REGISTER_CORE_REQ/RSP`

---

## 🕸️ Interconnects

1. **HCI Ports (vector L1/TCDM access):**
   - The Spatz vector LSU connects to the **HCI interconnect** with one 32-bit port per memory port: `max(NumFPU, NumIPU)` ports (`gen_tile_spatz_hci_ports`), 4 with the default configuration
   - Spatz produces L1-local addresses; the wrapper adds the L1 base and converts TCDM to HCI (`tcdm2hci`)
   - **Destination:** L1 SPM / TCDM banks (local tile memory)

2. **OBI Master Port (scalar data access):**
   - Every scalar data access of Spatz-CV32 goes through the **tile OBI crossbar** (native data interface → OBI)
   - Reaches L1, the control registers, L2 and other tiles through the NoC

3. **Dedicated Instruction Cache:**
   - Spatz-CV32 fetches through its own I$ (`magia_tile_icache_wrap`, geometry from the `ICache*` fields), clocked by `spatz_clk`
   - Refills go out on a dedicated AXI xbar slave port (`AXI_SLV_SPATZ_INSTR_IDX`) and reach the code in L2 through the NoC

4. **OBI Slave Interface (control registers):**
   - `obi_slave_ctrl_spatz` at base address `0x00001700`
   - 8 registers: `SPATZ_CLK_EN`, `SPATZ_READY`, `SPATZ_START`, `SPATZ_TASKBIN`, `SPATZ_DATA`, `SPATZ_RETURN`, `SPATZ_DONE`, `SPATZ_BINARY`
   - Accessed by the CV32 to command the Spatz -CV32, and by Spatz-CV32 itself (READY, START, RETURN, DONE)

---

## 🖥️ Programming API

### C Functions (`sw/utils/magia_spatz_utils.h`)

```c
// Clock control
void spatz_clk_en(void);                                 // Enable Spatz clock
void spatz_clk_dis(void);                                // Disable Spatz clock

// Initialization and task control
void spatz_init(uint32_t addr);                          // Boot: writes addr to BINARY, enables the clock, waits for READY
void spatz_run_task(uint32_t addr);                      // Writes the task address to TASKBIN, START=1, waits for START=0
void spatz_pass_params(uint32_t params_ptr);             // Writes the parameter pointer to DATA
void spatz_run_task_with_params(uint32_t addr, uint32_t params_ptr);  // Combined: pass params + run task
uint32_t spatz_get_exit_code(void);                      // Reads the exit code from RETURN
```

---

## 🏗️ Boot and Initialization

### 1. Boot Address (no bootROM)

With Snitch, the Spatz -CV32 booted from a hardware bootROM (`spatz_bootrom.sv`, 3 instructions at `0x1000_0000`, behind an AXI-to-regbus bridge on its own AXI xbar master port) that read `SPATZ_TASKBIN` and jumped to it. The bootROM, its generator (`scripts/generate_spatz_bootrom.py`), its sources (`spatz/bootrom/`), the AXI master port and the address rule have been removed.

Spatz-CV32 now boots like the PULP cluster cores: its `boot_addr_i` and `mtvec_addr_i` come from the `SPATZ_BINARY` register (`boot_addr_o` of `obi_slave_ctrl_spatz`). CV32E40P samples them only when it leaves reset and enters the boot state, which happens on the first `spatz_clk` edge after `SPATZ_CLK_EN = 1`. So:

> **`SPATZ_BINARY` must be written before `SPATZ_CLK_EN = 1`.** `spatz_init()` does this for you.

The address is `SPATZ_BINARY_START`, i.e. the `_start` of `spatz_crt0.S` inside the embedded Spatz binary.

If the clock is enabled with `SPATZ_BINARY` still at its reset value (`0x0`), Spatz-CV32 fetches from `0x0`. The address does not belong to the tile, the fetch leaves through the NoC and ends in an AXI decode error (in the tile testbench: `magia_isle: read from unmapped address from AXI port 2`). The usual cause is a test binary built before this change: rebuild it with `make clean all test=<test>`.

### 2. Binary Placement (`SPATZ_BINARY_START`)

- The Spatz binary is linked at address 0 (`spatz/sw/kernel/spatz_program.ld`) and compiled position-independent (`-fPIC`, `-mcmodel=medany`), so it runs wherever it is placed.
- It is embedded in the CV32 firmware as a byte array in section `.spatz_binary` (generated header).
- The CV32 linker script (`sw/kernel/link.ld`) places `.spatz_binary` in `instrram`, right after the CV32 `.text`, and defines `_spatz_binary_start`, `_spatz_binary_end` and `_spatz_binary_size`.
- The generated header defines `SPATZ_BINARY_START` as `(uint32_t)&_spatz_binary_start`, and each task symbol as `SPATZ_BINARY_START + <offset>`.
- CV32E40P keeps only `mtvec[31:8]`. `_trap_handler` is placed at a 256-byte boundary *inside* the binary (`.balign 256`), and `link.ld` aligns `.spatz_binary` to 256 bytes, so the absolute trap handler address is 256-byte aligned too.

### 3. Runtime Initialization (`spatz/sw/kernel/spatz_crt0.S`)

The **spatz_crt0.S** runtime performs the complete initialization and enters the task dispatcher loop. It is **transparent** to the programmer.

**Initialization Steps:**
1. **Stack Setup:** `sp = 0x0001FFF8` (top of the Spatz-CV32 stack)
2. **Register Clearing:** all integer registers `x1-x31` cleared (except `sp`)
3. **FP/Vector Enable:** `mstatus.FS` and `mstatus.VS` set to Initial (`0x2200`)
4. **BSS Clearing:** zero-initialize `.bss`
5. **Trap Handler Setup:** install `_trap_handler` in `mtvec` (direct mode; must be 256-byte aligned, see [Binary Placement](#2-binary-placement-spatz_binary_start))
6. **Interrupt Enable:** external interrupts (`mie.MEIE`) and global interrupts (`mstatus.MIE`)
7. **Signal READY:** write 1 to `SPATZ_READY` to tell the CV32 that initialization is complete

**Dispatcher Loop:**
```assembly
    wfi                      // First WFI - wait for the first interrupt

    // Deassert READY after the first wakeup (only once)
    li      t0, READY_ADDR
    sw      zero, 0(t0)

dispatcher_loop:
    wfi                      // Wait for the next interrupts from CV32
    j       dispatcher_loop  // Loop back after task completion
```

**READY Synchronization:**
- After initialization, Spatz-CV32 writes `READY = 1`
- `spatz_init()` polls `READY` until it becomes 1
- After the first WFI wakeup, Spatz-CV32 clears `READY = 0` (only once)
- This prevents the CV32 from triggering an interrupt before Spatz-CV32 is in WFI

**Trap Handler (`_trap_handler`):**
- **Interrupts** (mcause[31]=1, only ID 11 is handled):
  - Waits until `TASKBIN` is non-zero, then **saves the task address** in a register
  - Clears `START` to 0 (tells the CV32 it is safe to write `DATA` again)
  - Jumps to the saved task address via `jalr ra, 0(t1)`
  - After the task returns, writes exit code 0 (success) to `RETURN`
  - Sets `DONE = 1` (1-cycle pulse to the Event Unit)

- **Exceptions** (mcause[31]=0):
  - Writes exception code | 0x100 to `RETURN` (bit 8 distinguishes exceptions from task errors)
  - Sets `DONE = 1` (1-cycle pulse to the Event Unit)
  - Halts in an infinite WFI loop

**Exit Code Convention:**
- `0x000`: task completed successfully
- `0x1XX`: exception occurred (XX = mcause[7:0])

### Workflow

**Programmer writes task** → **Makefile auto-detects** → **Builds Spatz binary** → **Converts to header** → **Embeds in CV32 firmware**

### Auto-Detection and Build

The top-level Makefile automatically:
1. Scans the test code for `*_TASK` symbols
2. Builds the Spatz binary (Spatz LLVM, flags from `hw/generated/spatz_cfg.mk`)
3. Generates the header with the binary and the task addresses

```makefile
SPATZ_TASKS := $(shell grep -oP '\b[A-Z][A-Z0-9_]*_TASK\b' $(TEST_SRCS))
$(OBJ): spatz-header  # Header generated before the CV32 compilation
```

`spatz-header` fails if `hw/generated/spatz_cfg.mk` is missing: run `make vsim-scripts spatz_cfg=<cfg>` first.

### Generated Header Example

```c
// Auto-generated: test_name_task_bin.h
const uint8_t test_name_task_bin[] __attribute__((section(".spatz_binary"))) = {
    0x37, 0x01, 0x02, 0x00, ...  // Spatz binary data
};

extern uint32_t _spatz_binary_start; /* Linker symbol from CV32 link.ld */
#define SPATZ_BINARY_START ((uint32_t)&_spatz_binary_start)
#define MY_VECTOR_TASK     (SPATZ_BINARY_START + 0x00000120)  // Task offset
#define ANOTHER_TASK       (SPATZ_BINARY_START + 0x00000240)  // Another task offset
```

**You MUST include this header in your CV32 test:**
```c
#include "my_test_task_bin.h"  // Required for SPATZ_BINARY_START and task symbols
```

---

## ⚡ Complete Build and Run

### Example Test with Spatz

**File: `sw/tests/my_test.c`**
```c
#include "magia_tile_utils.h"
#include "magia_utils.h"
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "my_test_task_bin.h"

int main(void) {
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);

    spatz_run_task(MY_VECTOR_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);

    return spatz_get_exit_code();
}
```

### Build Commands

```bash
# 1. Setup environment
make python_venv
source setup_env.sh
make python_deps
make bender
# Generates the compile script, hw/generated/spatz_vpu_pkg.sv and hw/generated/spatz_cfg.mk
make vsim-scripts mesh_dv=0 spatz_cfg=default > vsim-scripts.log

# 2. Build hardware (QuestaSim on PATH)
make build-hw mesh_dv=0 fast_sim=1 > build-hw.log

# 3. Build software (auto-detects Spatz tasks; RISC-V GCC on PATH, SPATZ_LLVM_PATH set to the Spatz LLVM)
make clean all test='my_test' mesh_dv=0

# 4. Run simulation
make run test='my_test' mesh_dv=0 gui=0
```

**Notes:**
- The build flow is the same whether your test uses Spatz or not: Spatz tasks are detected and built automatically.
- After changing the Spatz configuration in `magia_pkg.sv`, rerun step 1 (`vsim-scripts`), rebuild the hardware and rebuild the tests.
- After changing `sw/utils/magia_spatz_utils.h`, always use `make clean all`: the test object is not rebuilt when only the header changes.

---

## 🔏 License
All `software` sources are licensed under the Apache License 2.0 ([`LICENSE.APACHE`](../LICENSE.APACHE)). All `hardware` sources are licensed under the Solderpad Hardware License 0.51 ([`LICENSE.SHL`](../LICENSE.SHL)).
