# Spatz Vector Accelerator in MAGIA
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](../LICENSE.APACHE)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](../LICENSE.SHL)

The Spatz Core Complex (spatz_cc) is a **RISC-V Vector Extension 1.0 accelerator** integrated into the MAGIA tile architecture. It consists of **Snitch** (a compact 32-bit RISC-V scalar core) and **Spatz** (a vector coprocessor with multiple FPU lanes). The CV32 host core controls Spatz CC through memory-mapped registers and interrupt-driven task dispatching, following an accelerator-style programming model.

**Key Features:**
- RISC-V Vector Extension 1.0 support (RVV)
- Single and double precision floating-point (RVF, RVD)
- Configurable vector length (VLEN: 128-512 bits)
- Up to 8 vector FPU lanes
- Clock-gated, interrupt-driven operation
- Transparent binary embedding in CV32 firmware

## ⚙️ Hardware Integration

### OBI Slave Control Interface

Spatz CC is controlled through an **OBI slave interface** (`obi_slave_ctrl_spatz`) that exposes memory-mapped control registers. This interface allows the CV32 to:
- Enable/disable the Spatz clock
- Set task entry points
- Trigger task execution via interrupt
- Read task completion status and exit codes

### Control Registers

The OBI slave exposes the following registers (base address: `SPATZ_CTRL_BASE = 0x00001700`):

| Register Name    | Offset | Address    | Description                                                                                              |
|------------------|--------|------------|----------------------------------------------------------------------------------------------------------|
| `SPATZ_CLK_EN`   | 0x00   | 0x00001700 | Clock enable (write 1 to enable, 0 to disable Spatz CC clock)                                           |
| `SPATZ_START`    | 0x04   | 0x00001704 | Trigger register: write 1 to send interrupt to Spatz CC, Snitch clears it to 0                          |
| `SPATZ_TASKBIN`  | 0x08   | 0x00001708 | Task binary address: CV32 writes task entry point address, Snitch reads it                              |
| `SPATZ_DATA`     | 0x0C   | 0x0000170C | Data/parameter pointer: CV32 writes pointer to task parameters, Snitch reads it                          |
| `SPATZ_RETURN`   | 0x10   | 0x00001710 | Return value: Snitch writes task exit code (0=success, non-zero=error/exception), CV32 reads it         |
| `SPATZ_DONE`     | 0x14   | 0x00001714 | Done flag: Snitch writes 1 when task completes, generates 1-cycle pulse to Event Unit, auto-clears      |

**Register Behavior:**
- **CLK_EN, START, TASKBIN, DATA, RETURN**: Preserved registers - values persist until overwritten
- **DONE**: Pulse register - auto-clears after one cycle, used to trigger Event Unit

**Signal Flow:**
1. CV32 writes task address to `SPATZ_TASKBIN`
2. CV32 writes 1 to `SPATZ_START` → triggers external interrupt to Spatz CC (Snitch core)
3. Snitch core wakes from WFI, reads task address from `SPATZ_TASKBIN`, clears `SPATZ_START` to 0
4. CV32 waits for `SPATZ_START` to become 0 (Snitch has saved task address)
5. CV32 writes parameter pointer to `SPATZ_DATA` (optional, only if task needs parameters)
6. Snitch executes task, which reads parameters from address in `SPATZ_DATA`
7. Task completes and writes exit code to `SPATZ_RETURN`, then writes 1 to `SPATZ_DONE`
8. `SPATZ_DONE` generates 1-cycle pulse to Event Unit, CV32 wakes from WFE/polling
9. CV32 reads exit code from `SPATZ_RETURN` (0 = success)

## 🚀 Quick Start

### Typical CV32 Test with Spatz Tasks
```c
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "my_test_task_bin.h"  // REQUIRED - Auto-generated header with SPATZ_BINARY_START and task symbols

int main(void) {
    // Initialize Event Unit and Spatz
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    spatz_init(SPATZ_BINARY_START);  // Uses address from auto-generated header
    
    //Simple task (no parameters via EXCHANGE_REG)
    spatz_run_task(MY_VECTOR_TASK);  // MY_VECTOR_TASK defined in auto-generated header
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    //Task with parameters via SPATZ_DATA register (optional)
    typedef struct { uint32_t addr; uint32_t size; } params_t;
    params_t params = {.addr = DATA_BASE, .size = 1024};
    
    spatz_run_task(ANOTHER_TASK); // ANOTHER_TASK defined in auto-generated header
    spatz_pass_params((uint32_t)&params);  // Optional: pass params pointer via SPATZ_DATA
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

// Define parameter structure (optional, if task needs parameters)
typedef struct {
    uint32_t data_addr;
    uint32_t size;
} my_params_t;

int my_vector_task(void) {
    // Read parameter pointer from SPATZ_DATA register (if task uses parameters)
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
- Function: `int *_task(void)` (matches filename)
- Symbol: `*_TASK` (uppercase in generated header)

**Reading Parameters:**
- Parameters are passed via pointer in `SPATZ_DATA` register
- Task reads `SPATZ_DATA` to get pointer to parameter structure in L1
- CV32 must ensure parameters are written to L1 before triggering task

---

## 🔧 Configuration Parameters
### Main Parameters (Makefile)

| Parameter | Default | Description |
|-----------|---------|-------------|
| `SPATZ_RVD` | 0 | 0: 32-bit TCDM (ELEN=32); 1: 64-bit TCDM (ELEN=64, double precision) |
| `SPATZ_VLEN` | 256 | Vector register length in bits (128, 256, 512) |
| `SPATZ_N_FPU` | 4 | Number of FPU lanes (1-8) |
| `SPATZ_N_IPU` | 1 | Number of integer processing units (1-8) |
| `SPATZ_RVF` | 1 | Enable single-precision floating-point |
| `SPATZ_RVV` | 1 | Enable RISC-V Vector extension |
| `SPATZ_XDIVSQRT` | 0 | Enable FP div/sqrt |

### Advanced Parameters

Defined in `hw/tile/magia_tile_pkg.sv`. See [Spatz documentation](https://github.com/pulp-platform/spatz) for details.

**Memory & Transactions:**
- `SPATZ_NUM_INT_OUTSTANDING_LOADS`, `SPATZ_NUM_INT_OUTSTANDING_MEM`
- `SPATZ_NUM_SPATZ_OUTSTANDING_LOADS`

**Pipeline:**
- `SPATZ_REGISTER_OFFLOAD_RSP`, `SPATZ_REGISTER_CORE_REQ/RSP`
- `SPATZ_FPU_PIPE_*` (FMA, DIVSQRT, CONV, DOTP stages)

---

## 📋 Control Interface

1. **HCI Ports (High-Performance L1/TCDM Access):**
   - Spatz CC connects to the **HCI interconnect** with multiple ports (5-10 ports depending on `N_FPU` and `RVD`)
   - Each port corresponds to a TCDM request channel: N_FU ports from Spatz vector unit + 1 port from Snitch scalar core
   - When `RVD=1`: HCI ports are doubled (2x32-bit ports per TCDM port) to support 64-bit data transfers
   - **Destination:** L1 SPM and TCDM banks (local tile memory)

2. **OBI Master Port (General Memory Access):**
   - Spatz CC (Snitch core) connects to the **OBI crossbar as a master** through a req/rsp port
   - Used for accesses **outside L1/TCDM**: peripherals, L2 memory, cross-tile communication
   - Handles scalar memory operations from Snitch and accesses to non-TCDM address ranges
   - Routed through OBI interconnect to reach all tile resources

3. **OBI Slave Interface (Control Registers):**
   - Spatz CC exposes an **OBI slave interface** (`obi_slave_ctrl_spatz`) for CV32 control
   - Base address: `0x00001700`
   - Contains 6 control registers: `SPATZ_CLK_EN`, `SPATZ_START`, `SPATZ_TASKBIN`, `SPATZ_DATA`, `SPATZ_RETURN`, `SPATZ_DONE`
   - CV32 accesses these registers via OBI to command Spatz CC operation

---

## Execution Flow


### Operation Sequence

1. **CV32 enables clock** (`SPATZ_CLK_EN = 1`)
2. **CV32 writes task address** to `SPATZ_TASKBIN`
3. **CV32 triggers execution** (`SPATZ_START = 1` → interrupt to Snitch)
4. **Snitch wakes**, reads task address from `SPATZ_TASKBIN`, clears `SPATZ_START` to 0
5. **CV32 waits** for `SPATZ_START` to become 0 (Snitch saved task address)
6. **CV32 writes parameter pointer** to `SPATZ_DATA` (optional, if task needs parameters)
7. **Snitch executes task**, task reads parameters from `SPATZ_DATA`, writes exit code to `SPATZ_RETURN`
8. **Snitch sets** `SPATZ_DONE = 1` (1-cycle pulse to Event Unit)
9. **CV32 reads result** from `SPATZ_RETURN` and optionally disables clock

**Exit Codes:**
- `0x000`: Success
- `0x1XX`: Exception (XX = mcause[7:0])

---

## 🖥️ Programming API

### C Functions (`sw/utils/magia_spatz_utils.h`)

```c
// Clock control
void spatz_clk_en(void);                                 // Enable Spatz clock
void spatz_clk_dis(void);                                // Disable Spatz clock

// Initialization and task control
void spatz_init(uint32_t addr);                          // Initialize: writes addr to TASKBIN, enables clock
void spatz_run_task(uint32_t addr);                      // Write task address to TASKBIN and trigger START=1
void spatz_pass_params(uint32_t params_ptr);             // Write parameter pointer to DATA (waits for START=0)
void spatz_run_task_with_params(uint32_t addr, uint32_t params_ptr);  // Combined: run task + pass params
uint32_t spatz_get_exit_code(void);                      // Read exit code from RETURN register
```
---

## 🏗️ Boot and Initialization
The bootROM is **extremely minimal** (only 3 instructions) to minimize hardware impact and ROM area. It performs only:
```assembly
// Read dispatcher entry point from TASKBIN register (set by CV32)
li      t0, TASKBIN_ADDR      // 0x00001708
lw      t1, 0(t0)
jr      t1  // Jump to spatz_crt0.S _start
```

The CV32 must write the Spatz CC binary's `_start` address to `SPATZ_TASKBIN` **before enabling the Spatz CC clock** for the first time.

#### 2. Runtime Initialization (`spatz/sw/kernel/spatz_crt0.S`)

The **spatz_crt0.S** runtime performs complete initialization and enters the task dispatcher loop. It is designed to be **completely transparent** to the programmer.

**Initialization Steps:**
1. **Stack Setup:** `sp = 0x0001FFF8` (128KB - 8 bytes, stack at top of Snitch local memory)
2. **Register Clearing:** All integer registers `x1-x31` cleared (except `sp`)
3. **Vector Extension Enable:** Set `mstatus.VS = 0x200` (Initial state to enable Spatz vector coprocessor)
4. **BSS Clearing:** Zero-initialize `.bss` section
5. **Trap Handler Setup:** Install `_trap_handler` at `mtvec`
6. **Interrupt Enable:** Enable external interrupts (`MIE.MEIE`) and global interrupts (`mstatus.MIE`)

**Dispatcher Loop:**
```assembly
dispatcher_loop:
    wfi                      // Wait for interrupt from CV32
    j       dispatcher_loop  // Loop back after task completion
```

**Trap Handler (`_trap_handler`):**
- **Interrupts** (mcause[31]=1): 
  - **Reads and saves task address** from `TASKBIN` register into a register
  - Clears `START` register to 0 to deassert interrupt signal (signals CV32 it's safe to write to `DATA`)
  - Jumps to saved task address via `jalr ra, 0(t1)`
  - After task returns, writes exit code 0 (success) to `RETURN` register
  - Sets `DONE = 1` (generates 1-cycle pulse to Event Unit)
  
- **Exceptions** (mcause[31]=0):
  - Writes exception code | 0x100 to `RETURN` register (bit 8 distinguishes exceptions from task errors)
  - Sets `DONE = 1` (generates 1-cycle pulse to Event Unit)
  - Halts in infinite WFI loop

**Exit Code Convention:**
- `0x000`: Task completed successfully
- `0x1XX`: Exception occurred (XX = mcause[7:0])

### Workflow

**Programmer writes task** → **Makefile auto-detects** → **Builds Spatz binary** → **Converts to header** → **Embeds in CV32 firmware**

**Task Naming Convention:**
- File: `*_task.c` (e.g., `my_vector_task.c`)
- Function: `int *_task(void)`
- Symbol: `*_TASK` (uppercase in header)

### Auto-Detection and Build

Top-level Makefile automatically:
1. Scans test code for `*_TASK` symbols
2. Triggers Spatz binary build
3. Generates header with task addresses

```makefile
# Automatic in MAGIA-SPATZ/Makefile
SPATZ_TASKS := $(shell grep -oP '\b[A-Z][A-Z0-9_]*_TASK\b' $(TEST_SRCS))
$(OBJ): spatz-header  # Header generated before CV32 compilation
```

### Generated Header Example

The build system automatically generates a header file with the Spatz binary and task entry points:

```c
// Auto-generated: test_name_task_bin.h
const uint8_t test_name_task_bin[] __attribute__((section(".spatz_binary"))) = {
    0x37, 0x01, 0x02, 0x00, ...  // Spatz binary data
};

#define SPATZ_BINARY_START ((uint32_t)&_spatz_binary_start)
#define MY_VECTOR_TASK     (SPATZ_BINARY_START + 0x00000120)  // Task offset
#define ANOTHER_TASK       (SPATZ_BINARY_START + 0x00000240)  // Another task offset

```

**You MUST include this header in your CV32 test:**
```c
#include "my_test_task_bin.h"  // Required for SPATZ_BINARY_START and task symbols
```


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
make update-ips > update-ips.log
make floonoc-patch

# 2. Build hardware (QuestaSim)
module load questasim/2024.3
make build-hw mesh_dv=0 fast_sim=1 > build-hw.log

# 3. Build software (auto-detects Spatz tasks)
module load pulp-gcc7/1.0.16
make clean all test='my_test' mesh_dv=0

# 4. Run simulation
make run test='my_test' mesh_dv=0 gui=0
```

**Note:** Build flow is **identical** whether your test uses Spatz or not — the system automatically detects and handles Spatz tasks!

---

## 🔏 License
All `software` sources are licensed under the Apache License 2.0 ([`LICENSE.APACHE`](../LICENSE.APACHE)). All `hardware` sources are licensed under the Solderpad Hardware License 0.51 ([`LICENSE.SHL`](../LICENSE.SHL)).
