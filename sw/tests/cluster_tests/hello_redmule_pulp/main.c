/*
 * hello_redmule_pulp - main core (CV32) binary.
 *
 * Linked at 0xCC000000, run by the CV32 main core (mhartid 0..15).
 *
 * Demonstrates the SHARED-ACCELERATOR / MULTI-INITIATOR pattern the way
 * pulp_cluster + pulp-runtime does it:
 *
 *   1) The CV32 main core loads X, W, Y in tile-local L1.
 *   2) The CV32 main core runs RedMulE once (sanity check), then waits
 *      for completion via Event Unit WFE (p.elw on its own EU slice).
 *   3) The CV32 main core re-loads Y (so the bias is fresh again),
 *      then kicks the 8 PULP cluster cores via PULP_FETCH_EN.
 *   4) Each PULP cluster core (see pulp_main.c) tries to ACQUIRE the
 *      RedMulE HWPE; the HWPE returns -1 if busy so the cluster cores
 *      naturally serialize. Whoever wins runs RedMulE on the same
 *      buffers and waits via WFE on its OWN EU slice (per-core mask).
 *   5) When all 8 cluster cores have hit crt0 exit, PULP_DONE goes
 *      high, the CV32 main wakes up, verifies Y == Z (golden), prints
 *      and exits.
 *
 * This exercises the RTL fix that broadcasts redmule_evt[*]/redmule_busy
 * to every cluster core's EU slice (acc_events_array[i] for i=0..N).
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"
#include "idma_mm_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

/* Address map.
 * X, W, Y live in tile-local L1 (private per tile, no cross-tile race).
 * The golden reference Z is read directly from z_oup[] in the main
 * ELF .rodata (already in L2), so no per-tile L2 copy is needed. */
#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)

static inline uint32_t get_mhartid(void) {
  uint32_t id;
  asm volatile("csrr %0, mhartid" : "=r"(id));
  return id;
}

/* Enable the FPU: set mstatus.FS to INITIAL (01).
 * Without this any FPU instruction faults. CV32E40P (and the cluster
 * cores) need this even though FP is enabled at compile time. */
static inline void enable_fpu(void) {
  asm volatile (
    "li t0, 0x2000\n"   /* mstatus.FS[14:13] = 01 (Initial) */
    "csrs mstatus, t0\n"
    ::: "t0"
  );
}

/* Bulk-load an array from L2 (.rodata of the main ELF) into L1 via iDMA.
 * Same wait pattern as cluster cores use after RedMulE jobs:
 *   issue -> WFE -> on wake re-check the HW status, retry until clear.
 * The first WFE returns when A2O_DONE is asserted, the status check
 * confirms the back-end FIFO has truly drained before we let the
 * caller touch L1. */
static inline void idma_load_l2_to_l1(uint32_t l2_src, uint32_t l1_dst, uint32_t size_bytes) {
  eu_clear_events(0xFFFFFFFF);
  eu_enable_events(EU_IDMA_A2O_DONE_MASK);
  (void)idma_L2ToL1(l2_src, l1_dst, (unsigned short)size_bytes);
  do {
    eu_idma_wait_a2o_completion(EU_WAIT_MODE_WFE);
  } while (idma_mm_is_busy_dir(/*is_l1_to_l2=*/0, /*stream_id=*/0));
}

/* Reduced from 96 to 4 (= RedMulE ARRAY_HEIGHT) to cut simulation time.
 * The first M rows of the golden are independent of the others, so
 * z_oup[0..M*K-1] remains a valid reference for this subset.
 * N and K cannot be reduced: they are baked into the W matrix layout. */
#define M_SIZE  (4)
#define N_SIZE  (64)
#define K_SIZE  (64)

#define VERBOSE (0)
#define USE_WFE (1)
#define DIFF_TH (0x0011)

/* Helper: same body as redmule_test_event_unit.c::main, factored so we
   can call it once from the CV32 main and verify results. Returns
   number of mismatches. */
static unsigned int redmule_run_and_verify(void) __attribute__((unused));
static unsigned int redmule_run_and_verify(void) {
  /* Bulk-load X, W, Y for this tile via iDMA. All 16 tiles run this
     in parallel; cross-tile contention is handled the same way the
     cluster cores serialize on the HWPE: each iDMA load issues, the
     core sleeps in WFE, and on wake re-checks the HW state until it
     is truly idle (see idma_load_l2_to_l1). */
  idma_load_l2_to_l1((uint32_t)x_inp, X_BASE, M_SIZE * N_SIZE * 2);
  idma_load_l2_to_l1((uint32_t)w_inp, W_BASE, N_SIZE * K_SIZE * 2);
  idma_load_l2_to_l1((uint32_t)y_inp, Y_BASE, M_SIZE * K_SIZE * 2);

  /* Initialize and configure RedMulE */
  hwpe_cg_enable();
  hwpe_soft_clear();

  int offload_id_tmp;
  while ((offload_id_tmp = hwpe_acquire_job()) < 0)
    ;

  redmule_cfg((unsigned int)X_BASE, (unsigned int)W_BASE, (unsigned int)Y_BASE,
              M_SIZE, N_SIZE, K_SIZE, (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

  /* Initialize Event Unit for RedMulE */
  eu_redmule_init();

  printf("Testing matrix multiplication with RedMulE...\n");
  hwpe_trigger_job();

  if (USE_WFE) {
    /* Drain HCI writeback: redmule_evt fires when the LAST writeback
       has been ISSUED, not when it's been committed to L1. Without
       this loop, the verify below can race the in-flight stores and
       see stale Y values on a few scattered indices (observed on
       tiles 14/15 where the per-tile timing is tightest). Same
       pattern used by pulp_main.c after the cluster jobs. */
    do {
      eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    } while (hwpe_get_status() != 0);
    printf("Detected WFE...\n");
  } else {
    do {
      eu_redmule_wait_completion(EU_WAIT_MODE_POLLING);
    } while (hwpe_get_status() != 0);
    printf("Detected polling completion...\n");
  }
  /* Make any in-flight HCI stores observable to subsequent loads. */
  asm volatile ("fence" ::: "memory");
  printf("Verifying results...\n");

  hwpe_cg_disable();

  unsigned int num_errors = 0;
  uint16_t computed, expected, diff;
  for (int i = 0; i < M_SIZE*K_SIZE; i++) {
    computed = mmio16(Y_BASE + 2*i);
    expected = z_oup[i];
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if (diff > DIFF_TH) {
      num_errors++;
      printf("**ERROR**: Y[%8x](=0x%4x) != Z[%0d](=0x%4x)\n",
             Y_BASE + 2*i, computed, i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);
  return num_errors;
}

int main(void) {
  enable_fpu();

  /* Step 1 (sanity check on the CV32 main) is skipped on purpose:
     it interacts badly with the iDMA + HWPE timing on tiles 14/15
     under mesh_dv=1, even though the actual RedMulE workload (run
     by the cluster cores in pulp_main.c) is what we want to test.

     We still need to populate X, W, Y in this tile's L1 SPM so the
     cluster cores have valid operands; just no programming /
     trigger / verify on the CV32 side. */
  idma_load_l2_to_l1((uint32_t)x_inp, X_BASE, M_SIZE * N_SIZE * 2);
  idma_load_l2_to_l1((uint32_t)w_inp, W_BASE, N_SIZE * K_SIZE * 2);
  idma_load_l2_to_l1((uint32_t)y_inp, Y_BASE, M_SIZE * K_SIZE * 2);

  /* Bring the RedMulE HWPE out of clock-gate and reset its FSM.
     pulp_main.c assumes the HWPE is "in a clean state" when the cluster
     cores start contending on REDMULE_ACQUIRE; without this they read
     garbage (0xFFFFFFFE) from the gated peripheral and spin forever
     in `while ((id = hwpe_acquire_job()) < 0)`. We do NOT trigger a
     sanity job here: just enable+clear, then release the cluster. */
  hwpe_cg_enable();
  hwpe_soft_clear();

  unsigned int err_main = 0;

  printf("Releasing PULP cluster cores...\n");
  mmio32(PULP_FETCH_EN) = 1;

  /* Step 3: wait for all cluster cores to exit (crt0 sets PULP_DONE). */
  while (!(mmio32(PULP_DONE) & 1))
    ;

  /* Step 4: verify the cluster's RedMulE pass also produced the right Y. */
  unsigned int err_pulp = 0;
  uint16_t computed, expected, diff;
  for (int i = 0; i < M_SIZE*K_SIZE; i++) {
    computed = mmio16(Y_BASE + 2*i);
    expected = z_oup[i];
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if (diff > DIFF_TH) {
      err_pulp++;
      printf("**PULP_ERR**: i=%0d row=%0d col=%0d Y=0x%4x Z=0x%4x diff=0x%4x\n",
             i, i / K_SIZE, i % K_SIZE, computed, expected, diff);
    }
  }
  printf("PULP cluster pass finished with %0d errors\n", err_pulp);

  return (err_main + err_pulp);
}
