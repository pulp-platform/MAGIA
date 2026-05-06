/*
 * hello_spatz_pulp — PULP cluster-core binary.
 *
 * Each of the 8 cluster cores reads its 1/8th slice of the Z vector
 * (filled by Spatz on the CV32 side: Z[i] = 1.0 + 2.0 = 3.0 FP16 = 0x4200),
 * sums the raw uint16 bit-patterns into a uint32 partial sum, and writes
 * the result to its per-core L2 slot.
 *
 * Memory layout (shared with main.c):
 *   Z_BASE      = L1_BASE + 0x00002000   (256 FP16 elements, Spatz output)
 *   RESULT_BASE = L2_BASE + 0x00060000   (8 × uint32, one per cluster core)
 *
 * crt0 signals PULP_DONE when all 8 cores have returned from main().
 * The CV32 main then wakes from WFE (EU bit 22) and verifies the totals.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"

#define VLEN        256
#define Z_BASE      (L1_BASE + 0x00002000)
#define RESULT_BASE (L2_BASE + 0x00060000)

int main(void) {
    uint32_t local_id = cluster_core_id();
    uint32_t chunk    = VLEN / PULP_CORE_COUNT;   /* 32 elements per core */
    uint32_t start    = local_id * chunk;

    /* Sum raw FP16 bit-patterns in this core's slice of Z. */
    uint32_t partial_sum = 0;
    for (uint32_t i = start; i < start + chunk; i++)
        partial_sum += mmio16(Z_BASE + 2 * i);

    /* Write result to per-core L2 slot. */
    mmio32(RESULT_BASE + 4 * local_id) = partial_sum;

    if (local_id == 0)
        printf("[PULP core 0] partial_sum=0x%08x\n", partial_sum);

    return 0;
}
