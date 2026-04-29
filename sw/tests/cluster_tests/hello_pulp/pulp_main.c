/*
 * hello_pulp — PULP cluster-core binary.
 *
 * This ELF is linked at 0xC0000000 and executed by the PULP cluster
 * cores of each tile (mhartid 32..159).
 *
 * On return, crt0 writes 1 to CLUSTER_DONE (tile CSR 0x1744) and
 * parks the core.
 */

#include "magia_tile_utils.h"

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

int main(void) {
    uint32_t hartid   = get_mhartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;
    uint32_t tile_id  = pulp_gid / PULP_CORE_COUNT;

    /* Only core 0 of each tile prints, to avoid interleaving on the
       shared per-tile UART peripheral at 0xFFFF0004. */
    if (local_id == 0)
        printf("[Tile %u PULP-%u mhartid %u] Hello World!\n",
               tile_id, local_id, hartid);

    return 0;
}
