# Spatz Core Complex in MAGIA Tile
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](LICENSE.APACHE)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](LICENSE.SHL)

## Overview

The Spatz Core Complex (spatz_cc) is integrated into the MAGIA tile architecture as a **vector co-processor accelerator** controlled by the CV32 host core. Spatz CC consists of two main components: **Snitch** (a compact 32-bit RISC-V scalar core with integer and floating-point support) and **Spatz** (a RISC-V Vector Extension 1.0 coprocessor with multiple lanes of vector FPUs for parallel execution). These components collaborate through an **offload mechanism**: Snitch executes scalar code and control flow, while vector operations are offloaded to the Spatz vector unit via the RISC-V Vector Extension interface.

The integration in the MAGIA tile follows an accelerator-style programming model where the CV32 host manages Spatz CC execution through memory-mapped control registers and interrupt-driven task dispatching.

---

## Hardware Integration

### OBI Slave Control Interface

Spatz CC is controlled through an **OBI slave interface** (`obi_slave_ctrl_spatz`) that exposes memory-mapped control registers. This interface allows the CV32 to:
- Enable/disable the Spatz clock
- Set task entry points
- Trigger task execution via interrupt
- Read task completion status and exit codes

### Control Registers

The OBI slave exposes the following registers (base address: `SPATZ_CTRL_BASE = 0x00001700`):

| Register Name       | Offset | Address    | Description                                                                                 |
|---------------------|--------|------------|---------------------------------------------------------------------------------------------|
| `SPATZ_CLK_EN`      | 0x00   | 0x00001700 | Clock enable (write 1 to enable, 0 to disable Spatz CC clock)                                            |
| `SPATZ_EXCHANGE_REG`| 0x04   | 0x00001704 | Exchange register: CV32 writes task address, Spatz CC (Snitch) writes exit code                          |
| `SPATZ_START`       | 0x08   | 0x00001708 | Trigger register: write 1 to send interrupt (multicycle assertion) to Spatz CC, Snitch clears it         |
| `SPATZ_DONE`        | 0x0C   | 0x0000170C | Done flag: Spatz CC sets to 1 when task completes, done signal is a pulse, auto-clears                   |

**Signal Flow:**
1. CV32 writes task address to `SPATZ_EXCHANGE_REG`
2. CV32 writes 1 to `SPATZ_START` → triggers external interrupt to Spatz CC (Snitch core)
3. Snitch core wakes from WFI, deasserts `SPATZ_START`, reads task address from `SPATZ_EXCHANGE_REG`, executes task
4. Snitch writes exit code to `SPATZ_EXCHANGE_REG` and sets `SPATZ_DONE = 1`
5. CV32 can check completion through event-unit (WFE or polling) and reads exit code

### Instantiation and Connection

**Location in MAGIA:** Spatz CC is instantiated inside `magia_tile.sv` as part of the tile's processing elements.

**Key Parameters in MAKEFILE**
- **`SPATZ_RVD`** (default: 0): Controls TCDM data width and ELEN
  - `0`: 32-bit TCDM, ELEN=32 (single-precision only)
  - `1`: 64-bit TCDM, ELEN=64 (double-precision support)
  - **HCI Interconnect Impact:** When `RVD=1`, the HCI interconnect must support 64-bit so the HCI's ports are 2x.
- **`SPATZ_VLEN`** (default: 256): Vector register length in bits (128, 256, 512, ...)
- **`SPATZ_N_IPU`** (default: 1): Number of Integer Processing Units (1-8)
- **`SPATZ_N_FPU`** (default: 4): Number of Floating Point Units (1-8)
- **`SPATZ_XDIVSQRT`** (default: 0): Enable FP div/sqrt
- **`SPATZ_RVF`** (default: 1): Enable single-precision floating-point
- **`SPATZ_RVV`** (default: 1): Enable RISC-V Vector extension

**Other Parameters in magia_tile_pkg:**

These parameters are defined in `hw/tile/magia_tile_pkg.sv` and control advanced Spatz CC configuration. For detailed parameter descriptions, refer to the [Spatz CC documentation](https://github.com/pulp-platform/spatz).

**Memory and Outstanding Transactions:**
- **`SPATZ_NUM_INT_OUTSTANDING_LOADS`** (default: 1)
- **`SPATZ_NUM_INT_OUTSTANDING_MEM`** (default: 4)
- **`SPATZ_NUM_SPATZ_OUTSTANDING_LOADS`** (default: 4)

**Pipeline Control:**
- **`SPATZ_REGISTER_OFFLOAD_RSP`** (default: 0)
- **`SPATZ_REGISTER_CORE_REQ`** (default: 1)
- **`SPATZ_REGISTER_CORE_RSP`** (default: 1)

**FPU Pipeline Stages (Spatz Vector Unit):**
- **`SPATZ_FPU_PIPE_FMA_FP32`** (default: 1)
- **`SPATZ_FPU_PIPE_FMA_FP64`** (default: 2)
- **`SPATZ_FPU_PIPE_DIVSQRT_FP32`** (default: 2)
- **`SPATZ_FPU_PIPE_DIVSQRT_FP64`** (default: 4)
- **`SPATZ_FPU_PIPE_NONCOMP`** (default: 1)
- **`SPATZ_FPU_PIPE_CONV`** (default: 2)
- **`SPATZ_FPU_PIPE_DOTP`** (default: 2)

**Boot ROM:**
- **`SPATZ_BOOT_ADDR`** (default: 0x10000000): Spatz CC bootrom base address in Snitch address space
- **`SPATZ_BOOTROM_SIZE`** (default: 0xFF): Size of bootrom region


**Interconnect:**

Spatz CC has multiple interconnect interfaces for different domains:

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
   - Contains 4 control registers: `SPATZ_CLK_EN`, `SPATZ_EXCHANGE_REG`, `SPATZ_START`, `SPATZ_DONE`
   - CV32 accesses these registers via OBI to command Spatz CC operation

---

## Execution Flow

### Accelerator-Style Operation Model

Spatz CC operates as a **clock-gated, interrupt-driven accelerator** commanded by CV32:

1. **CV32 enables Spatz CC clock** (`SPATZ_CLK_EN = 1`)
2. **CV32 writes task entry point** to `SPATZ_EXCHANGE_REG`
3. **CV32 triggers execution** by writing to `SPATZ_START` (sends interrupt to Snitch core)
4. **Snitch core wakes from WFI**, executes task (using Spatz vector unit if needed), writes exit code, sets `SPATZ_DONE`
5. **CV32 reads result**, optionally disables Spatz CC clock to save power

Between tasks, Spatz CC (Snitch core) remains in **WFI (Wait-For-Interrupt)** state, consuming minimal power. CV32 can disable the clock completely when Spatz CC is idle.

### Boot and Initialization Sequence

#### 1. BootROM (`spatz/bootrom/spatz_init.S`)
The bootROM is **extremely minimal** (only 3 instructions) to minimize hardware impact and ROM area. It performs only:
```assembly
// Read dispatcher entry point from EXCHANGE_REG (set by CV32)
li      t0, EXCHANGE_REG_ADDR
lw      t1, 0(t0)
jr      t1  // Jump to spatz_crt0.S _start
```

The CV32 must write the Spatz CC binary's `_start` address to `SPATZ_EXCHANGE_REG` **before enabling the Spatz CC clock** for the first time.

#### 2. Runtime Initialization (`spatz/sw/kernel/spatz_crt0.S`)

The **spatz_crt0.S** runtime performs complete initialization and enters the task dispatcher loop. It is designed to be **completely transparent** to the programmer.

**Initialization Steps:**
1. **Stack Setup:** `sp = 0x00020000` (16KB stack at top of Snitch memory)
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
  - Clears `START` register to deassert interrupt signal
  - Reads task address from `EXCHANGE_REG`
  - Calls task via `jalr`
  - Writes exit code 0 (success) to `EXCHANGE_REG`
  - Sets `DONE = 1`
  
- **Exceptions** (mcause[31]=0):
  - Writes exception code | 0x100 to `EXCHANGE_REG` (bit 8 distinguishes exceptions)
  - Sets `DONE = 1`
  - Halts in infinite WFI loop

**Exit Code Convention:**
- `0x000`: Task completed successfully
- `0x1XX`: Exception occurred (XX = mcause[7:0])

---

## Programming Interface

### C API (`sw/utils/magia_spatz_utils.h`)

The programming interface provides simple functions to control Spatz CC as an accelerator:

#### Initialization Functions
```c
void spatz_clk_en(void);        // Enable Spatz CC clock
void spatz_clk_dis(void);       // Disable Spatz CC clock (power saving)
void spatz_init(uint32_t addr); // Initialize Spatz CC with binary start address
```

#### Task Control Functions
```c
void spatz_set_func(uint32_t addr);     // Set task entry point in EXCHANGE_REG
void spatz_trigger_en_irq(void);        // Trigger Spatz CC interrupt (start task)
void spatz_run_task(uint32_t addr);     // Combined: set address + trigger
uint32_t spatz_get_exit_code(void);     // Read task exit code from EXCHANGE_REG
```

### Typical Usage Pattern

```c
#include "magia_spatz_utils.h"
#include "event_unit_utils.h"
#include "my_test_task_bin.h"  // Auto-generated header with TASK symbols

int main(void) {
    // Initialize Event Unit (for WFE synchronization)
    eu_init();
    eu_enable_events(EU_SPATZ_DONE_MASK);
    
    // Initialize Spatz CC (first time only)
    spatz_init(SPATZ_BINARY_START);
    
    // Launch task 1
    spatz_run_task(MY_FIRST_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);  // Wait for completion
    
    if (spatz_get_exit_code() != 0) {
        printf("Task 1 failed: 0x%03lx\n", spatz_get_exit_code());
    }
    
    // Launch task 2 (no re-init needed)
    spatz_run_task(MY_SECOND_TASK);
    eu_wait_spatz_wfe(EU_SPATZ_DONE_MASK);
    
    // Disable Spatz CC clock to save power
    spatz_clk_dis();
    
    return 0;
}
```

---

## Software Build System

### Task Development Workflow

The build system is designed to make task development **transparent and automatic**. The programmer only needs to:

1. **Write task function** in C inside `spatz/sw/tasks/`:
   ```c
   // spatz/sw/tasks/my_vector_task.c
   void my_vector_task(void) {
       // Task code using RISC-V Vector intrinsics
       // ...
   }
   ```
   
   **Naming Convention (REQUIRED):**
   - File name: `'*_task.c` (lowercase with underscores, must end with `_task`)
   - Function name: `void *_task(void)` (must match file name exactly and end with `_task`)
   - Symbol in header: `*_TASK` (must match file name but uppercase)
   - Example: `my_vector_task.c` → `void my_vector_task(void)` → `MY_VECTOR_TASK`

2. **Include auto-generated header** in CV32 test:
   ```c
   #include "cv32_test_name_task_bin.h"  // Contains SPATZ_BINARY_START, MY_VECTOR_TASK
   ```

3. **Call task** from CV32 code:
   ```c
   spatz_init(SPATZ_BINARY_START);
   spatz_run_task(MY_VECTOR_TASK);
   ```

### Build Flow (Automatic)

#### Top-Level Makefile (`MAGIA-SPATZ/Makefile`)

When building a CV32 test, the top-level Makefile:

1. **Auto-detects Spatz tasks** used in the test:
   ```makefile
   SPATZ_TASKS := $(shell grep -oP '\b[A-Z][A-Z0-9_]*_TASK\b' $(TEST_SRCS) | ...)
   ```

2. **Triggers Spatz CC binary build** (if tasks detected):
   ```makefile
   spatz-header:
       cd spatz/sw && $(MAKE) all task="$(SPATZ_TASKS)" TEST_NAME=$(test)
   ```

3. **CV32 object depends on header**:
   ```makefile
   $(OBJ): spatz-header  # Ensures header exists before compiling CV32 test
   ```

#### Spatz Makefile (`spatz/sw/Makefile`)

The Spatz CC build system:

1. **Compiles runtime + tasks** into single ELF:
   ```makefile
   $(ELF): $(CRT0_OBJ) $(TASK_SRCS)
       $(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(CRT0_OBJ) $(TASK_SRCS)
   ```
   - Links `spatz_crt0.S` (dispatcher + trap handler)
   - Links all task `.c` files
   - Uses `spatz_program.ld` linker script (position-independent code at 0x00000000)

2. **Generates binary**:
   ```makefile
   $(BIN): $(ELF)
       $(OBJCOPY) -O binary $< $@
   ```

3. **Converts binary to C header** with `bin2header.py`:
   ```c
   // Auto-generated: spatz/sw/headers_bin/my_test_task_bin.h
   
   const uint8_t my_test_task_bin[] __attribute__((section(".spatz_binary"))) = {
       0x37, 0x01, 0x02, 0x00, ...  // Binary data
   };
   
   extern uint32_t _spatz_binary_start;  // Linker symbol from CV32 link.ld
   #define SPATZ_BINARY_START ((uint32_t)&_spatz_binary_start)
   
   #define SPATZ_DISPATCHER_LOOP (SPATZ_BINARY_START + 0x000000a4)
   #define MY_VECTOR_TASK        (SPATZ_BINARY_START + 0x00000120)  // Offset
   ```

4. **CV32 linker embeds binary** after CV32 `.text` in instrram:
   ```ld
   // sw/kernel/link.ld
   .text : { ... } > instrram
   
   _spatz_binary_start = .;
   .spatz_binary : {
       KEEP(*(.spatz_binary))  // Embeds array from header
   } > instrram
   ```

**Result:** Spatz CC code is **inlined into CV32 binary**, loaded into instrram at simulation/synthesis, completely transparent to programmer.

---

## Complete Build and Run Script

The build and run process is **identical** whether your test uses Spatz tasks or not. The build system automatically detects and handles everything:

```bash
#!/bin/bash
# Setup and build MAGIA + Spatz system

# 1. Setup Python virtual environment
export BASE_PYTHON=python3
make python_venv
source setup_env.sh
make python_deps

# 2. Setup Bender (dependency manager)
make bender
make update-ips mesh_dv=0 > update-ips.log

# 3. Apply FlooNoC patch
make floonoc-patch

# 4. Build hardware (QuestaSim)
module load questasim/2024.3
make build-hw mesh_dv=0 fast_sim=1 > build-hw.log

# 5. Build software (CV32 + Spatz CC) - AUTOMATIC task detection!
module load pulp-gcc7/1.0.16
make clean all test='name_test' mesh_dv=0

# 6. Run simulation
make run test='name_test' mesh_dv=0 gui=0
```

### What Happens Automatically

**If your test includes Spatz CC tasks** (following the programming pattern described above):
1. Makefile **auto-detects** task symbols (e.g., `VECTOR_TASK`, `MY_FIRST_TASK`) in your test code
2. **Automatically builds** Spatz CC binary with `spatz_crt0.S` + all detected task `.c` files
3. **Automatically converts** binary to header file (`name_test_task_bin.h`)
4. CV32 test includes the header and calls `spatz_run_task(TASK_NAME)`
5. Entire Spatz CC binary is **embedded inline** into CV32 instrram

**If your test does NOT use Spatz CC:**
- Build proceeds normally without Spatz CC binary generation
- No overhead or extra steps required

**Key Point:** The programmer **never manipulates binaries, addresses, or loading manually**. Just follow the programming pattern (write tasks, include header, call `spatz_run_task()`) and the build system handles everything — **fully accelerator-style!**

---
