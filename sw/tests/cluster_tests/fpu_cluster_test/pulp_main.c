/*
 * fpu_cluster_test - PULP cluster-core binary.
 *
 * Mirrors sw/tests/fpu_test.c but runs on all 8 cluster cores concurrently.
 * Each core performs:
 *   fadd.s:  12.34 + 56.78  ≈ 69.12  (tolerance 0.1)
 *   fsub.s:  56.78 - 12.34  ≈ 44.44  (tolerance 0.1)
 *   fmul.s:  12.34 * 2.0    ≈ 24.68  (tolerance 0.1)
 *
 * 12.34 and 56.78 are NOT exact in float32, so comparisons use the same
 * 0.1 tolerance as fpu_test.c rather than bit-exact equality.
 *
 * Each core writes a 32-bit word to L2:
 *   0xFEED0000 | <error_count_16bit>
 * The CV32 main reads these back to determine pass/fail.
 */

#include <stdint.h>
#include "magia_tile_utils.h"

/* L2 result area: 4 bytes per cluster core (local_id 0..7). */
#define FPU_RESULT_BASE  (L2_BASE + 0x00060000)
#define FPU_RESULT_MAGIC (0xFEED0000u)

#define A_VAL  (12.34f)
#define B_VAL  (56.78f)
#define ADD_EXP (69.12f)
#define SUB_EXP (44.44f)
#define MUL_EXP (24.68f)
#define FP_TH  (0.1f)

#define abs_diff(x, y) (((x) > (y)) ? ((x) - (y)) : ((y) - (x)))

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

/* Enable the FPU: set mstatus.FS to INITIAL (01). */
static inline void enable_fpu(void) {
    asm volatile (
        "li t0, 0x2000\n"
        "csrs mstatus, t0\n"
        ::: "t0"
    );
}

int main(void) {
    enable_fpu();

    uint32_t hartid   = get_mhartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;  /* 0..127 */
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;  /* 0..7 */

    unsigned int errors = 0;

    volatile float a = A_VAL;
    volatile float b = B_VAL;

    /* fadd.s: a + b ≈ 69.12 */
    float c_add = a + b;
    if (abs_diff(c_add, ADD_EXP) > FP_TH) errors++;

    /* fsub.s: b - a ≈ 44.44 */
    float c_sub = b - a;
    if (abs_diff(c_sub, SUB_EXP) > FP_TH) errors++;

    /* fmul.s: a * 2.0 ≈ 24.68 */
    volatile float two = 2.0f;
    float c_mul = a * two;
    if (abs_diff(c_mul, MUL_EXP) > FP_TH) errors++;

    /* Only core 0 prints to avoid UART interleaving. */
    if (local_id == 0) {
        if (errors == 0) {
            printf("[PULP FPU] core %u: all 3 ops PASS\n", local_id);
        } else {
            printf("[PULP FPU] core %u: %u errors (add=%s sub=%s mul=%s)\n",
                   local_id, errors,
                   (abs_diff(c_add, ADD_EXP) <= FP_TH) ? "OK" : "FAIL",
                   (abs_diff(c_sub, SUB_EXP) <= FP_TH) ? "OK" : "FAIL",
                   (abs_diff(c_mul, MUL_EXP) <= FP_TH) ? "OK" : "FAIL");
        }
    }

    /* Write result to L2 slot for this core. */
    mmio32(FPU_RESULT_BASE + 4 * local_id) = FPU_RESULT_MAGIC | (errors & 0xFFFFu);

    return 0;
}
