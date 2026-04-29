/*
 * hello_redmule_pulp - PULP cluster-core binary.
 *
 * Linked at 0xC0000000, run by the 8 PULP cluster cores of each tile
 * (mhartid 32..159). All 8 cores ENTER main() concurrently after the
 * CV32 main has set PULP_FETCH_EN.
 *
 * Concurrency model (mirrors pulp_cluster + pulp-runtime):
 *
 *   - All 8 cluster cores try to ACQUIRE the RedMulE HWPE in parallel.
 *     RedMulE's REDMULE_ACQUIRE register returns >=0 to exactly ONE
 *     core at a time (HWPE-internal arbitration). The losers see -1
 *     and spin.
 *
 *   - The winner programs RedMulE (mcfg + base addresses), arms its
 *     OWN EU_CORE_MASK with EU_REDMULE_DONE_MASK, triggers the job,
 *     then sleeps via p.elw (eu_redmule_wait_completion(WFE)). Thanks
 *     to the RTL fix in magia_tile.sv (acc_events broadcast to all
 *     cores), the redmule_evt[*] line raises the DONE bit in EVERY
 *     core's EU buffer, but only the core that ARMED the mask wakes.
 *
 *   - When the winner returns from WFE, it releases (HWPE auto-clears
 *     on completion) and the next acquire winner runs. Repeat 8 times.
 *
 *   - Each cluster core writes a small marker in L2 with its hartid so
 *     we can confirm in the trace that all 8 actually ran the kernel.
 *
 * crt0 takes care of writing 1 to PULP_DONE (offset 0x04 in tile
 * cluster CSR) when all 8 cores have exited main(); only then the
 * CV32 main wakes from its busy-wait.
 *
 * NOTE: each cluster core re-runs the SAME matmul on the SAME L1
 * buffers prepared by the CV32 main. The result Y is overwritten 8
 * times with the same value (deterministic since X, W, bias are
 * unchanged across iterations). The CV32 main verifies Y == Z after
 * PULP_DONE.
 */

#include "magia_tile_utils.h"
#include "redmule_mm_utils.h"
#include "event_unit_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"

/* Same reduced size as main.c — must stay in sync. */
#define M_SIZE   (4)
#define N_SIZE   (64)
#define K_SIZE   (64)

#define X_BASE   (L1_BASE + 0x00012048)
#define W_BASE   (L1_BASE + 0x00016048)
#define Y_BASE   (L1_BASE + 0x0001A048)

/* Per-core marker area in L2: 4B per cluster core, 8 cluster cores per
   tile, 16 tiles -> 8*16 = 128 entries. Used only to prove every core
   reached the kernel. */
#define MARKER_BASE  (L2_BASE + 0x00050000)

static inline uint32_t get_mhartid(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

/* Enable the FPU on this hart: set mstatus.FS to INITIAL (01). Without
   this any FPU instruction faults. RedMulE's hwpe-mac-engine itself
   does not need this (it's a separate HWPE), but the cluster core
   may execute float register copies in libgcc helpers / printf, and
   future tests may issue FP instructions directly. */
static inline void enable_fpu(void) {
    asm volatile (
        "li t0, 0x2000\n"
        "csrs mstatus, t0\n"
        ::: "t0"
    );
}

/* Reload the bias slot the previous winner overwrote, so each
   subsequent winner sees a fresh y_inp. Without this every core after
   the first would compute Z + (k-1)*Z accumulated bias.
   The reload is itself protected by the HWPE acquire window: when a
   core holds the HWPE (between acquire and DONE), nobody else can
   trigger a job, so it's safe to write the bias buffer here.

   Use 32-bit stores (sw) instead of 16-bit (sh): observed that 16-bit
   stores from cluster cores to L1 race against the previous RedMulE
   writeback on the SAME 32-bit word, leaving Y[0,0]/Y[0,1] stale.
   32-bit stores avoid byte-enable handling on the cluster-core OBI
   path entirely. y_inp is uint16_t but contiguous, so we can read it
   as uint32_t pairs (little-endian: pair = y_inp[2k+1]<<16 | y_inp[2k]).
*/
static void reload_bias(void) {
    const uint32_t *src = (const uint32_t*)y_inp;
    volatile uint32_t *dst = (volatile uint32_t*)Y_BASE;
    for (int i = 0; i < (M_SIZE * K_SIZE) / 2; i++) dst[i] = src[i];
    /* Drain the write queue: read the FIRST element back and add a
       memory fence so RedMulE sees the freshly-written bias when it
       issues its first Y-load. */
    volatile uint32_t sink = dst[0];
    (void)sink;
    asm volatile("fence" ::: "memory");
}
int main(void) {
    enable_fpu();

    uint32_t hartid   = get_mhartid();
    uint32_t pulp_gid = hartid - PULP_HARTID_BASE;     /* 0..127 */
    uint32_t local_id = pulp_gid % PULP_CORE_COUNT;    /* 0..7 within tile */
    uint32_t tile_id  = pulp_gid / PULP_CORE_COUNT;    /* 0..15 across mesh */

    /* Drop a marker so the test trace can confirm we got here. */
    mmio32(MARKER_BASE + 4 * pulp_gid) = 0xC1057ED0u + local_id;

    /* Only core 0 of each tile prints, to avoid interleaving on the
       per-tile UART peripheral at 0xFFFF0004. */
    if (local_id == 0) {
        printf("[Tile %u PULP-%u mhartid %u] entering RedMulE contention\n",
            tile_id, local_id, hartid);
    }
    /* HWPE acquire: ONE core at a time wins. Losers spin here.
       NOTE: do NOT call hwpe_soft_clear inside this critical section,
       it would release the HWPE and let another core grab it mid-job.
       The CV32 main has already done cg_enable + soft_clear before
       releasing the cluster, so the HWPE is in a clean state. */
    int job_id;
    while ((job_id = hwpe_acquire_job()) < 0)
        ;

    /* Root cause of Y[0,0]/Y[0,1] corruption:
       HWPE releases the ACQUIRE lock (RUNNING_JOB→0) as soon as the
       last MAC fires, but its HCI TCDM master may still have a few
       write-back beats in flight to L1 (STATUS is still nonzero).
       The next winner acquires immediately and starts reload_bias(),
       writing y_inp back to Y_BASE. Those tail HCI beats from the
       PREVIOUS job then land on Y[0..1], overwriting the fresh bias
       with the previous GEMM result.  Polling STATUS=0 HERE (after
       acquire, before reload_bias) guarantees the previous job's HCI
       is fully committed to L1 before we touch Y. */
    while (hwpe_get_status() != 0);
    asm volatile("fence" ::: "memory");

    reload_bias();

    redmule_cfg((unsigned)X_BASE, (unsigned)W_BASE, (unsigned)Y_BASE,
                M_SIZE, N_SIZE, K_SIZE,
                (uint8_t)gemm_ops, (uint8_t)Float16, (uint8_t)Float16);

    /* Arm THIS core's own EU mask. Per-core slice => no interference
       with other cluster cores or the CV32. */
    eu_redmule_init();

    hwpe_trigger_job();

    /* Reference pattern from pulp_cluster hal_redmule.h::redmule_evt_wait():
         do { eu_evt_maskWaitAndClr(HWPE_EVT); } while (STATUS != 0);
       One WFE is not enough: RedMulE asserts DONE when the last MAC fires,
       but STATUS stays nonzero while the HCI writeback of Y is still in
       flight. The loop re-sleeps until STATUS == 0, which only happens
       after the TCDM master has completed all write-back beats. */
    do {
        eu_redmule_wait_completion(EU_WAIT_MODE_WFE);
    } while (hwpe_get_status() != 0);
    asm volatile("fence" ::: "memory");

    hwpe_cg_disable();


    printf("[Tile %u PULP-%u mhartid %u] RedMulE done, exiting\n",
            tile_id, local_id, hartid);

    /* crt0 will set PULP_DONE bit when all 8 cluster cores return. */
    return 0;
}
