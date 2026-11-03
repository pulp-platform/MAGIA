/*
 * Copyright (C) 2026 ETH Zurich, University of Bologna and Fondazione Chips-IT
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 *
 * Authors: Niccolò Giuliani <niccolo.giuliani@chips.it>
 *
 * Dove si incrociano iDMA e cache. Il kernel prende blocchi di BLOCK parole consecutive, in ordine casuale:
 *
 *     for (j = 0; j < n_blocks; j++)
 *         for (k = 0; k < BLOCK; k++)
 *             sum += src[idx[j] + k];
 *
 * BLOCK = 1 e' il gather puro (una parola per indice), BLOCK = N e' il sequenziale puro: un solo parametro
 * copre tutto lo spettro fra i due casi che sappiamo gia' andare a uno e all'altro. L'iDMA paga un
 * descrittore per blocco piu' il trasferimento, quindi il suo costo per parola scende con BLOCK; la cache
 * paga un miss per linea e poi va a hit, quindi il suo costo per parola e' quasi piatto da 32 parole in su
 * (la linea e' 128 B). Le due curve si incrociano: questo test cerca dove.
 *
 * REUSE ripete il giro: con riuso alto l'iDMA vince per latenza (SPM contro i 3 cicli di un hit), non per
 * banda, quindi l'incrocio si sposta. Il risultato utile e' la frontiera sul piano (BLOCK, REUSE).
 *
 * Il test e' scritto per girare anche su una mesh: **non ha stato mutabile in .data o .bss**, che in MAGIA
 * sono una copia sola condivisa da tutte le tile. Contatori e risultati stanno in L1, che e' locale alla
 * tile, e l'arena in L2 e' spostata per hart id.
 *
 *   make all test=dcache_blocks_test dcache=1 core=CV32E40P fsync=1 \
 *        EXTRA_CFLAGS="-DN_WORDS=8192 -DREUSE=1 -DBUDGET_KIB=16"
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

////////////////
// Parametri  //
////////////////

#ifndef N_WORDS
#define N_WORDS      (8 * 1024)               /* 32 KiB di dati in L2 */
#endif
#ifndef REUSE
#define REUSE        (1)                      /* quante volte si ripassa su tutti i blocchi */
#endif
#ifndef BUDGET_KIB
#define BUDGET_KIB   (16)                     /* budget di L1 dato alla cache (way accese) */
#endif
#ifndef BLOCK_LIST
#define BLOCK_LIST   1, 2, 4, 8, 16, 32, 64, 128, 256, 512
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT   (1)
#endif
#ifndef ARENA_STRIDE
#define ARENA_STRIDE (0x00040000)             /* 256 KiB per tile: src + idx ci stanno larghi */
#endif

#define MAX_BLOCK    (512)

static inline uint32_t tile_id(void) {
    uint32_t id;
    asm volatile("csrr %0, mhartid" : "=r"(id));
    return id;
}

/////////////////////////////////////////////////
// Memoria: niente stato mutabile in .data/.bss //
/////////////////////////////////////////////////

/* L2, una fetta per tile */
/* 0xCC20_0000 e non 0xCC10_0000: la tile 0 avrebbe l'arena piu' bassa e su una mesh i dati del
 * programma (che sono una copia sola per tutte le tile) arrivano a toccarla. */
#define ARENA        (0xCC200000u + tile_id() * ARENA_STRIDE)
#define SRC_ADDR     (ARENA)
#define IDX_ADDR     (ARENA + N_WORDS * 4 + 128)
#define ARENA_END    (IDX_ADDR + N_WORDS * 4)

/* L1: locale alla tile, quindi automaticamente privata anche su una mesh */
#define STATE        (L1_BASE)                              /* contatori e risultati */
#define DMA_BUF      (L1_BASE + 0x1000)                     /* due buffer da MAX_BLOCK parole */

#define errors       (*(volatile uint32_t *)(STATE + 0))
#define lcg_state    (*(volatile uint32_t *)(STATE + 4))

extern char _bss_end;

static const uint32_t block_list[] = {BLOCK_LIST};          /* const: condividerla fra le tile va bene */

static inline uint32_t read_mcycle(void) {
    uint32_t cycles;
    asm volatile("csrr %0, mcycle" : "=r"(cycles));
    return cycles;
}

static void check(const char *what, uint32_t block, uint32_t got, uint32_t expected) {
    if (got != expected) {
        printf("[FAIL] tile %d %s block=%d: got 0x%x, expected 0x%x\n", (int)tile_id(), what, (int)block,
               (unsigned)got, (unsigned)expected);
        errors = errors + 1;
    }
}

//////////
// iDMA //
//////////

static inline void wait_in(uint32_t id) {
    while ((int32_t)(idma_mm_get_done_id_dir(0, 0) - id) < 0);
}

/////////////
// Kernel  //
/////////////

/* Somma di n_blocks blocchi da block parole, presi dove dice idx. Questa e' la versione che tocca la L2:
 * la usano sia direct sia cache, identica, cosi' l'unica differenza e' la configurazione della cache. */
KERNEL static uint32_t sum_blocks_l2(volatile uint32_t *src, volatile uint32_t *idx, uint32_t n_blocks,
                                     uint32_t block) {
    uint32_t sum = 0;
    for (uint32_t j = 0; j < n_blocks; j++) {
        uint32_t s = idx[j];
        for (uint32_t k = 0; k < block; k++)
            sum += src[s + k];
    }
    return sum;
}

/* La somma di un blocco gia' portato in SPM */
KERNEL static uint32_t sum_buf(volatile uint32_t *buf, uint32_t block) {
    uint32_t sum = 0;
    for (uint32_t k = 0; k < block; k++)
        sum += buf[k];
    return sum;
}

/* Versione iDMA: un descrittore per blocco, doppio buffer. Gli indirizzi dei blocchi si sanno solo leggendo
 * la lista degli indici, quindi un descrittore per blocco e' il meglio che una DMA puo' fare. */
static uint32_t sum_blocks_idma(uint32_t src, volatile uint32_t *idx, uint32_t n_blocks, uint32_t block) {
    uint32_t bytes = block * 4;
    uint32_t buf[2] = {DMA_BUF, DMA_BUF + MAX_BLOCK * 4};
    uint32_t id[2] = {0, 0};
    uint32_t sum = 0;

    id[0] = idma_L2ToL1(src + idx[0] * 4, buf[0], bytes);
    for (uint32_t j = 0; j < n_blocks; j++) {
        uint32_t d = j & 1, n = d ^ 1;
        if (j + 1 < n_blocks)
            id[n] = idma_L2ToL1(src + idx[j + 1] * 4, buf[n], bytes);
        wait_in(id[d]);
        sum += sum_buf((volatile uint32_t *)buf[d], block);
    }
    return sum;
}

/////////////////////
// Preparazione    //
/////////////////////

static uint32_t lcg_next(void) {
    lcg_state = lcg_state * 1664525u + 1013904223u;
    return lcg_state;
}

/* Una permutazione casuale dei blocchi (non delle parole: altrimenti i blocchi si sovrapporrebbero e la
 * somma di controllo non sarebbe piu' quella di tutto src). La scrive il core direttamente in L2: la
 * preparazione non e' cronometrata, e cosi' non c'e' nessuno staging da L1 che possa sbagliare, che su una
 * mesh e' stata la fonte di errori. */
static void make_block_permutation(uint32_t n_blocks, uint32_t block) {
    volatile uint32_t *idx = (volatile uint32_t *)IDX_ADDR;
    for (uint32_t i = 0; i < n_blocks; i++)
        idx[i] = i * block;
    for (uint32_t i = n_blocks - 1; i > 0; i--) {
        uint32_t j = lcg_next() % (i + 1);
        uint32_t tmp = idx[i];
        idx[i] = idx[j];
        idx[j] = tmp;
    }
    dcache_flush();                 /* la lista deve essere in L2 anche per i giri a cache spenta */
}

/* Il costo di un descrittore iDMA, da solo: e' la costante che decide dove cade l'incrocio */
static void measure_descriptor_cost(void) {
    const uint32_t n = 256;
    uint32_t start = read_mcycle();
    uint32_t id = 0;
    for (uint32_t i = 0; i < n; i++)
        id = idma_L2ToL1(SRC_ADDR, DMA_BUF, 4);
    wait_in(id);
    uint32_t t = read_mcycle() - start;
    printf("RES tile=%d what=descriptor n=%d cycles=%d per_descriptor=%d\n", (int)tile_id(), (int)n, (int)t,
           (int)(t / n));
}

//////////
// Giri //
//////////

static uint32_t golden_sum(void) {
    /* src[i] = i, e una permutazione dei blocchi li copre tutti: la somma non dipende da block */
    uint32_t n = N_WORDS;
    uint32_t tri = (n % 2 == 0) ? (n / 2) * (n - 1) : n * ((n - 1) / 2);
    return tri * REUSE;
}

static void print_res(const char *variant, uint32_t block, uint32_t cycles, const dcache_perf_t *perf) {
    printf("RES tile=%d variant=%s block=%d reuse=%d cycles=%d hit_r=%d miss_r=%d refill=%d\n",
           (int)tile_id(), variant, (int)block, REUSE, (int)cycles, (int)perf->hit_r, (int)perf->miss_r,
           (int)perf->refill);
}

static void run_block(uint32_t block) {
    volatile uint32_t *src = (volatile uint32_t *)SRC_ADDR;
    volatile uint32_t *idx = (volatile uint32_t *)IDX_ADDR;
    uint32_t n_blocks = N_WORDS / block;
    dcache_perf_t none = {0};
    dcache_perf_t perf;
    uint32_t spm_base, spm_size, start, t, sum;

    make_block_permutation(n_blocks, block);

    if (RUN_DIRECT) {
        dcache_flush();
        dcache_enable(0);
        start = read_mcycle();
        sum = 0;
        for (uint32_t r = 0; r < REUSE; r++)
            sum += sum_blocks_l2(src, idx, n_blocks, block);
        t = read_mcycle() - start;
        dcache_enable(1);
        check("direct", block, sum, golden_sum());
        print_res("direct", block, t, &none);
    }

    dcache_flush();
    dcache_enable(0);                         /* l'iDMA porta tutto in SPM: la cache non c'entra */
    start = read_mcycle();
    sum = 0;
    for (uint32_t r = 0; r < REUSE; r++)
        sum += sum_blocks_idma(SRC_ADDR, idx, n_blocks, block);
    t = read_mcycle() - start;
    dcache_enable(1);
    check("idma", block, sum, golden_sum());
    print_res("idma", block, t, &none);

    for (uint32_t pf = 0; pf < 2; pf++) {
        uint32_t way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
        uint32_t ways = (BUDGET_KIB * 1024) / way_bytes;
        if (ways == 0 || ways > dcache_num_ways())
            continue;
        dcache_set_ways(ways, &spm_base, &spm_size);
        dcache_set_prefetch(pf);
        dcache_flush();
        dcache_perf_start();
        start = read_mcycle();
        sum = 0;
        for (uint32_t r = 0; r < REUSE; r++)
            sum += sum_blocks_l2(src, idx, n_blocks, block);
        t = read_mcycle() - start;
        dcache_perf_stop();
        dcache_perf_read(&perf);
        check(pf ? "cache_pf1" : "cache_pf0", block, sum, golden_sum());
        print_res(pf ? "cache_pf1" : "cache_pf0", block, t, &perf);
        dcache_set_prefetch(0);
        dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
    }
}

int main(void) {
    volatile uint32_t *src = (volatile uint32_t *)SRC_ADDR;

    asm volatile("csrw mcountinhibit, zero");
    errors = 0;
    lcg_state = 0x2026u + tile_id();

    if (tile_id() == 0)
        printf("dcache_blocks: %d parole, riuso %d, budget %d KiB, dcache %d way x %d set (%d KiB)\n",
               N_WORDS, REUSE, BUDGET_KIB, (int)dcache_num_ways(), MAGIA_DCACHE_SETS, L1_DCACHE_SIZE / 1024);
    if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000) {
        printf("[FAIL] tile %d: geometria o arena\n", (int)tile_id());
        return 1;
    }

    for (uint32_t i = 0; i < N_WORDS; i++)
        src[i] = i;
    dcache_flush();

    measure_descriptor_cost();
    for (uint32_t i = 0; i < sizeof(block_list) / sizeof(block_list[0]); i++)
        run_block(block_list[i]);

    printf("dcache_blocks_test: tile %d, %d errors\n", (int)tile_id(), (int)errors);
    return errors;
}
