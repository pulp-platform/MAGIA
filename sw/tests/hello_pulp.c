/*
 * MAGIA Hello PULP — All Cores Hello World
 *
 * Adapted from magia-sdk tests/pulp/hello_pulp.
 * Main core (mhartid 0) prints, starts cluster cores, waits for done.
 * Each cluster core prints and exits (crt0 writes CLUSTER_DONE).
 *
 * Single UART at 0xFFFF0004 — output staggered with wait_nop().
 */

#include "magia_tile_utils.h"

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

int main(void) {
    uint32_t hartid = get_mhartid();

    if (hartid < PULP_HARTID_BASE) {
        /* ---- Main core ---- */
        printf("[Main core %u] Hello World!\n", hartid);

        /* Start all 8 cluster cores */
        mmio32(PULP_FETCH_EN) = 1;

        /* Wait for all cluster cores to signal done */
        while (!(mmio32(PULP_DONE) & 1))
            ;

        printf("[Main core %u] All %d cluster cores done!\n",
               hartid, PULP_CORE_COUNT);

    } else {
        /* ---- Cluster core ---- */
        uint32_t local_id = (hartid - PULP_HARTID_BASE) % PULP_CORE_COUNT;
        uint32_t tile_id  = (hartid - PULP_HARTID_BASE) / PULP_CORE_COUNT;

        /* Stagger output so characters don't interleave */
        wait_nop(local_id * 10000);

        printf("[Tile %u PULP-%u mhartid %u] Hello World!\n",
               tile_id, local_id, hartid);
    }

    return 0;
}
