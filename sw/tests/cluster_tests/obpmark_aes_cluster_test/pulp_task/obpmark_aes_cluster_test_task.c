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
 * Cluster task of obpmark_aes_cluster_test: the 8 PULP cores encrypt in counter mode. The AES port is the one
 * of sw/tests/obpmark_aes_test.c (OBPMark 3.1, CPU port), with one change that parallelism forces: the block
 * counter is not incremented one block at a time but computed as base + block index, so that each core can
 * start on its own range and the ciphertext is the same as the serial one.
 * The tables and the expanded key are built once by core 0 in the L1 SPM and read by everybody.
 */

#include <stdint.h>
#include "magia_tile_utils.h"
#include "cluster_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"
#include "../obpmark_aes_cluster_test.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

#define NK  (AES_KEY_BITS / 32)
#define NR  (AES_KEY_BITS == 128 ? 10 : (AES_KEY_BITS == 192 ? 12 : 14))
#define NB  (4)

/* The hot area, bound at task entry: core view of the SPM */
static uint8_t  *sbox;
static uint8_t  *rcon;
static uint32_t *expanded_key;
static uint8_t  *iv_base;
static uint8_t  *key_value;


static inline uint32_t AES_RotWord(uint32_t n) {
  return (n >> 8) | (n << 24);
}

static uint32_t AES_SubWord(uint32_t word) {
  return sbox[word >> 24] << 24 | sbox[(uint8_t)(word >> 16)] << 16 |
         sbox[(uint8_t)(word >> 8)] << 8 | sbox[(uint8_t)word];
}

static void AES_KeyExpansion(void) {
  uint32_t temp;
  int i = 0;
  while (i < NK) {
    expanded_key[i] = *((uint32_t *)&key_value[4 * i]);
    i++;
  }
  for (; i < NB * (NR + 1); i++) {
    temp = expanded_key[i - 1];
    if (i % NK == 0)
      temp = AES_SubWord(AES_RotWord(temp)) ^ rcon[i / NK];
    else if (NK > 6 && i % NK == 4)
      temp = AES_SubWord(temp);
    expanded_key[i] = expanded_key[i - NK] ^ temp;
  }
}

static void AES_AddRoundKey(uint8_t in_state[4][4], uint8_t state[4][4], const uint8_t *roundkey,
                            unsigned int round_number) {
  for (int i = 0; i < NB; i++)
    for (int j = 0; j < 4; j++)
      state[i][j] = in_state[i][j] ^ roundkey[(round_number * NB * 4) + (i * NB) + j];
}

static void AES_SubBytes(uint8_t state[4][4]) {
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++)
      state[i][j] = sbox[state[i][j]];
}

static void AES_ShiftRows(uint8_t state[4][4]) {
  uint8_t temp;
  temp = state[0][1];
  state[0][1] = state[1][1];
  state[1][1] = state[2][1];
  state[2][1] = state[3][1];
  state[3][1] = temp;

  temp = state[0][2];
  state[0][2] = state[2][2];
  state[2][2] = temp;
  temp = state[1][2];
  state[1][2] = state[3][2];
  state[3][2] = temp;

  temp = state[3][3];
  state[3][3] = state[2][3];
  state[2][3] = state[1][3];
  state[1][3] = state[0][3];
  state[0][3] = temp;
}

static inline uint8_t xtime(uint8_t x) {
  return (x << 1) ^ (((x >> 7) & 1) * 0x1b);
}

static void AES_MixColumns(uint8_t state[4][4]) {
  uint8_t Tmp, Tm, t;
  for (int i = 0; i < 4; ++i) {
    t   = state[i][0];
    Tmp = state[i][0] ^ state[i][1] ^ state[i][2] ^ state[i][3];

    Tm = state[i][0] ^ state[i][1];
    Tm = xtime(Tm);
    state[i][0] ^= Tm ^ Tmp;

    Tm = state[i][1] ^ state[i][2];
    Tm = xtime(Tm);
    state[i][1] ^= Tm ^ Tmp;

    Tm = state[i][2] ^ state[i][3];
    Tm = xtime(Tm);
    state[i][2] ^= Tm ^ Tmp;

    Tm = state[i][3] ^ t;
    Tm = xtime(Tm);
    state[i][3] ^= Tm ^ Tmp;
  }
}

static void AES_encrypt_state(uint8_t in_state[4][4], uint8_t state[4][4]) {
  AES_AddRoundKey(in_state, state, (uint8_t *)expanded_key, 0);
  for (unsigned int roundi = 1; roundi < NR; roundi++) {
    AES_SubBytes(state);
    AES_ShiftRows(state);
    AES_MixColumns(state);
    AES_AddRoundKey(state, state, (uint8_t *)expanded_key, roundi);
  }
  AES_SubBytes(state);
  AES_ShiftRows(state);
  AES_AddRoundKey(state, state, (uint8_t *)expanded_key, NR);
}

/* OBPMark counter_add(iv, block, id): here the counter of block n is computed in one go, base + n, so
 * that a core can start anywhere in the stream. The serial port added one at a time, which is the same
 * sequence of counters and therefore the same ciphertext. */
static void counter_at(uint8_t *ctr, uint32_t n) {
    uint32_t       *dst = (uint32_t *)ctr;
    const uint32_t *src = (const uint32_t *)iv_base;
    uint32_t        carry = n;

    /* Unrolled: a byte loop here becomes a call to memcpy, which the bare metal build does not have */
    dst[0] = src[0];
    dst[1] = src[1];
    dst[2] = src[2];
    dst[3] = src[3];
    for (int i = 15; i >= 0 && carry; i--) {
        uint32_t v = ctr[i] + (carry & 0xFF);
        ctr[i] = (uint8_t)v;
        carry = (carry >> 8) + (v >> 8);
    }
}

/* The timed kernel: `blocks` blocks from pt to ct, the first one being block `first` of the stream */
KERNEL static void aes_encrypt(const uint8_t *pt, uint8_t *ct, uint32_t first, uint32_t blocks) {
    uint8_t ctr[16] __attribute__((aligned(4)));
    for (uint32_t b = 0; b < blocks; b++) {
        uint8_t *out = ct + b * 16;
        counter_at(ctr, first + b);
        AES_encrypt_state((uint8_t(*)[4])ctr, (uint8_t(*)[4])out);
        for (int y = 0; y < NB; y++)
            *((uint32_t *)&out[4 * y]) ^= *((const uint32_t *)(pt + b * 16 + 4 * y));
    }
}

/* FIPS-197 appendix C known answer, run once by core 0 on the expanded key */
static uint32_t known_answer_errors(void) {
    uint8_t in[16], out[16];
    static const uint8_t exp128[16] = {0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x04, 0x30,
                                       0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a};
    static const uint8_t exp192[16] = {0xdd, 0xa9, 0x7c, 0xa4, 0x86, 0x4c, 0xdf, 0xe0,
                                       0x6e, 0xaf, 0x70, 0xa0, 0xec, 0x0d, 0x71, 0x91};
    static const uint8_t exp256[16] = {0x8e, 0xa2, 0xb7, 0xca, 0x51, 0x67, 0x45, 0xbf,
                                       0xea, 0xfc, 0x49, 0x90, 0x4b, 0x49, 0x60, 0x89};
    const uint8_t *exp = (AES_KEY_BITS == 128) ? exp128 : (AES_KEY_BITS == 192) ? exp192 : exp256;

    for (int i = 0; i < 16; i++)
        in[i] = (uint8_t)(i * 0x11);
    AES_encrypt_state((uint8_t(*)[4])in, (uint8_t(*)[4])out);
    for (int i = 0; i < 16; i++)
        if (out[i] != exp[i])
            return 1;
    return 0;
}

//////////////
// Variants //
//////////////

/* L2 variants: every core encrypts its own range of blocks, straight from and to the L2 */
static void aes_l2(volatile aes_params_t *p, uint32_t id) {
    uint32_t first = cluster_chunk_offset(p->blocks, PULP_CORE_COUNT, id);
    uint32_t n     = cluster_chunk_size(p->blocks, PULP_CORE_COUNT, id);

    aes_encrypt((const uint8_t *)(p->pt + first * 16), (uint8_t *)(p->ct + first * 16), first, n);
}

/* iDMA variant: core 0 brings in a tile of plaintext and sends out the ciphertext, double buffered; the team
 * splits the tile. Four halves in the budget: pt0 pt1 ct0 ct1. */
static void aes_idma(volatile aes_params_t *p, uint32_t id) {
    uint32_t tile_bytes = p->tile_blocks * 16;
    uint32_t per        = p->tile_blocks / PULP_CORE_COUNT;
    int      tiles      = p->blocks / p->tile_blocks;
    uint32_t in_id[2] = {0, 0}, out_id[2] = {0, 0};

    if (id == 0)
        in_id[0] = idma_L2ToL1(p->pt, p->spm_loc, tile_bytes);
    for (int t = 0; t < tiles; t++) {
        int d = t & 1, n = d ^ 1;
        if (id == 0) {
            idma_wait_in(in_id[d]);
            if (t + 1 < tiles) {
                if (t >= 1)
                    idma_wait_out(out_id[n]);
                in_id[n] = idma_L2ToL1(p->pt + (t + 1) * tile_bytes, p->spm_loc + n * tile_bytes, tile_bytes);
            }
        }
        pi_cl_team_barrier();
        aes_encrypt((const uint8_t *)(p->spm + d * tile_bytes + id * per * 16),
                    (uint8_t *)(p->spm + (2 + d) * tile_bytes + id * per * 16),
                    t * p->tile_blocks + id * per, per);
        pi_cl_team_barrier();
        if (id == 0)
            out_id[d] = idma_L1ToL2(p->spm_loc + (2 + d) * tile_bytes, p->ct + t * tile_bytes, tile_bytes);
    }
    if (id == 0)
        idma_wait_out(out_id[(tiles - 1) & 1]);
}

static void aes_fork_entry(void *arg) {
    volatile aes_params_t *p = (volatile aes_params_t *)arg;
    uint32_t id = pi_core_id();

    asm volatile("csrw mcountinhibit, zero");
    sbox         = (uint8_t *)(p->hot + AES_HOT_SBOX);
    rcon         = (uint8_t *)(p->hot + AES_HOT_RCON);
    expanded_key = (uint32_t *)(p->hot + AES_HOT_EKEY);
    iv_base      = (uint8_t *)(p->hot + AES_HOT_IV);
    key_value    = (uint8_t *)(p->hot + AES_HOT_KEY);
    if (id == 0) {
        AES_KeyExpansion();
        p->kat_errors = known_answer_errors();
    }
    pi_cl_team_barrier();
    uint32_t start = read_mcycle();

    if (p->variant == AES_VAR_IDMA)
        aes_idma(p, id);
    else
        aes_l2(p, id);

    p->cycles[id] = read_mcycle() - start;
    pi_cl_team_barrier();
}

int obpmark_aes_cluster_test_task(void *data) {
    pi_cl_team_fork(PULP_CORE_COUNT, aes_fork_entry, data);
    return 0;
}
