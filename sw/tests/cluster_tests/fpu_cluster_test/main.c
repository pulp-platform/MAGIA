/*
 * fpu_cluster_test - main core (CV32) binary.
 *
 * Releases the 8 PULP cluster cores and waits for them to complete.
 * Each cluster core runs a small set of single-precision FPU operations
 * (fadd.s, fmul.s, fsub.s) and writes a pass/fail word to L2.
 * The CV32 main then reads back those words and reports the result.
 */

#include <stdint.h>
#include "magia_tile_utils.h"

/* Result slot: 4 bytes per cluster core.
 * Cluster cores write 0xFEEDxxxx where xx = error count. */
#define FPU_RESULT_BASE  (L2_BASE + 0x00060000)
#define FPU_RESULT_MAGIC (0xFEED0000u)
#define FPU_RESULT_MASK  (0xFFFF0000u)

int main(void) {
    /* Release the PULP cluster cores. */
    printf("fpu_cluster_test: releasing PULP cluster cores...\n");
    mmio32(PULP_FETCH_EN) = 1;

    /* Wait until all 8 cluster cores have exited (crt0 sets PULP_DONE). */
    while (!(mmio32(PULP_DONE) & 1))
        ;

    /* Read back per-core results from L2 and report. */
    unsigned int total_errors = 0;
    for (int i = 0; i < PULP_CORE_COUNT; i++) {
        uint32_t word = mmio32(FPU_RESULT_BASE + 4 * i);
        if ((word & FPU_RESULT_MASK) != FPU_RESULT_MAGIC) {
            /* Slot was not written — core did not reach the result store. */
            printf("  core %d: MISSING (slot=0x%08x)\n", i, word);
            total_errors++;
        } else {
            unsigned int errs = word & 0xFFFFu;
            if (errs == 0) {
                printf("  core %d: PASS\n", i);
            } else {
                printf("  core %d: FAIL (%u FPU mismatches)\n", i, errs);
                total_errors += errs;
            }
        }
    }

    if (total_errors == 0)
        printf("fpu_cluster_test: all cores PASS\n");
    else
        printf("fpu_cluster_test: FAILED with %u errors\n", total_errors);

    return (int)total_errors;
}
