/*
 * hello_pulp — main core (CV32) binary.
 *
 * This ELF is linked at 0xCC000000 and executed by the CV32 main core
 * of each tile (mhartid 0..NUM_CLUSTERS-1).
 *
 * Flow:
 *   1) Print a "hello" banner.
 *   2) Kick the PULP cluster cores by writing PULP_FETCH_EN=1.
 *   3) Wait on PULP_DONE until all cluster cores have reported.
 *   4) Print the "done" message.
 */

#include "magia_tile_utils.h"

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

int main(void) {
    uint32_t hartid = get_mhartid();

    printf("[Main core %u] Hello World!\n", hartid);

    /* Release the PULP cluster cores of this tile. */
    mmio32(PULP_FETCH_EN) = 1;

    /* Wait until every cluster core of this tile has signalled exit. */
    while (!(mmio32(PULP_DONE) & 1))
        ;

    printf("[Main core %u] All %d cluster cores done!\n",
           hartid, PULP_CORE_COUNT);

    return 0;
}
