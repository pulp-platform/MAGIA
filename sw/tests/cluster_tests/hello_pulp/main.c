/*
 * hello_pulp — main core (CV32) binary.
 *
 * This ELF is linked at 0xCC000000 and executed by the CV32 main core
 * of each tile (mhartid 0..NUM_CLUSTERS-1).
 *
 * Flow:
 *   1) Print a "hello" banner.
 *   2) Arm the Event Unit for cluster-done WFE (EU bit 22).
 *   3) Kick the PULP cluster cores via cluster_start().
 *   4) Sleep in WFE until all cluster cores have reported (cluster_wait_eu()).
 *   5) Print the "done" message.
 */

#include "magia_tile_utils.h"
#include "cluster_utils.h"

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

int main(void) {
    uint32_t hartid = get_mhartid();

    printf("[Main core %u] Hello World!\n", hartid);

    /* Arm EU before kicking the cluster to avoid missing the event. */
    cluster_init_eu();

    /* Release the PULP cluster cores of this tile. */
    cluster_start();

    /* Sleep (cv.elw) until every cluster core of this tile has signalled
     * exit; cluster_wait_eu() also clears PULP_DONE (read-to-clear). */
    cluster_wait_eu();

    printf("[Main core %u] All %d cluster cores done!\n",
           hartid, PULP_CORE_COUNT);

    return 0;
}
