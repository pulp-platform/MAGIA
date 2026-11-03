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
 * OBPMark 3.1 AES encryption (ESA, github.com/OBPMark/OBPMark, src/3.1-aes_encryption/src/ports/cpu) on the
 * control core: AES in counter mode, the state operations of the OBPMark CPU port kept as they are (AddRoundKey,
 * SubBytes, ShiftRows, MixColumns, the expanded key layout included). The key, the S-box, rcon, the expanded
 * key and the counter live in the L1 SPM (small and hot: any bare-metal port would put them there); the
 * plaintext and the ciphertext live in L2, and the three variants move only them, as raiderstream_test:
 *   direct : plaintext and ciphertext in L2 with the cache off
 *   idma   : tiles of plaintext in and ciphertext out, double buffered, compute in the L1 SPM
 *   cache  : plaintext and ciphertext in L2 through the cache (budget in ways, prefetch off and on)
 * AES is compute bound: this is the benchmark where the transport should matter least.
 * Checks: one FIPS-197 known-answer block, and the ciphertext checksum equal across every variant.
 * Needs the cache (make dcache=1). AES_KEY_BITS (128/192/256), AES_BLOCKS and BUDGETS_KIB are defines.
 */

#include "magia_tile_utils.h"
#include "magia_dcache_utils.h"
#include "idma_mm_utils.h"
#include "bench_utils.h"

// GCC 14 crashes ("could not split insn", doloop_begin_i) on the cv32e40p hardware loop of the big loops
#pragma GCC optimize("no-branch-count-reg")
#pragma GCC optimize("align-loops=4")
#define KERNEL __attribute__((noinline, aligned(4)))

////////////////
// Parameters //
////////////////

#ifndef AES_KEY_BITS
#define AES_KEY_BITS (256)
#endif
#ifndef AES_BLOCKS
#define AES_BLOCKS   (2048)                   /* 16-byte blocks: 32 KiB of plaintext */
#endif
#ifndef BUDGETS_KIB
#define BUDGETS_KIB  16, 32
#endif
#ifndef RUN_DIRECT
#define RUN_DIRECT   (1)
#endif
#ifndef RUN_IDMA
#define RUN_IDMA     (1)
#endif
#ifndef CACHE_PF
#define CACHE_PF     (3)
#endif

#define NK           (AES_KEY_BITS / 32)
#define NR           (AES_KEY_BITS == 128 ? 10 : (AES_KEY_BITS == 192 ? 12 : 14))
#define NB           (4)
#define DATA_BYTES   (AES_BLOCKS * 16)
#define DMA_CHUNK    (32 * 1024)

/////////////////////
// Memory and data //
/////////////////////

/* Plaintext and ciphertext in the L2 arena (cacheable region) */
#define ARENA        (0xCC100000)
#define PT_ADDR      (ARENA)
#define CT_ADDR      (ARENA + DATA_BYTES + 128)
#define ARENA_END    (CT_ADDR + DATA_BYTES)

/* The hot small data in the L1 SPM; the iDMA tiles from the start of the SPM */
#define SPM          (L1_BASE)
#define HOT          (L1_BASE + L1_SPM_SIZE - 4096)

static uint8_t  *const sbox         = (uint8_t *)(HOT);           /* 256 B */
static uint8_t  *const rcon         = (uint8_t *)(HOT + 256);     /* 11 B */
static uint32_t *const expanded_key = (uint32_t *)(HOT + 512);    /* NB*(NR+1) words */
static uint8_t  *const iv           = (uint8_t *)(HOT + 1024);    /* 16 B counter */
static uint8_t  *const key_value    = (uint8_t *)(HOT + 1056);    /* NK*4 B */

extern char _bss_end;

static const uint32_t budgets_kib[] = {BUDGETS_KIB};
static uint32_t errors = 0;

static void check(const char *what, uint32_t got, uint32_t expected) {
  if (got != expected) {
    printf("[FAIL] %s: got 0x%x, expected 0x%x\n", what, (unsigned)got, (unsigned)expected);
    errors++;
  }
}

//////////
// iDMA //
//////////

static uint32_t dma_in(uint32_t l2, uint32_t l1, uint32_t bytes) {
  uint32_t id = 0;
  for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
    uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
    id = idma_L2ToL1(l2 + off, l1 + off, len);
  }
  return id;
}

static uint32_t dma_out(uint32_t l1, uint32_t l2, uint32_t bytes) {
  uint32_t id = 0;
  for (uint32_t off = 0; off < bytes; off += DMA_CHUNK) {
    uint32_t len = (bytes - off < DMA_CHUNK) ? bytes - off : DMA_CHUNK;
    id = idma_L1ToL2(l1 + off, l2 + off, len);
  }
  return id;
}

/////////////////////////////////////////////////////////////
// AES, the OBPMark CPU port (processing.c, Marc Sole Bonet,
// BSC; ESA Community License), adapted to plain C
/////////////////////////////////////////////////////////////

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

/* OBPMark counter_add(iv, block, id), the recursion unrolled */
static void counter_add_one(void) {
  for (int id = 15; id >= 0; id--) {
    uint32_t carry = iv[id] + 1;
    iv[id] = (uint8_t)carry;
    if (carry <= 255 || id == 0)
      return;
  }
}

/* OBPMark AES_encrypt: counter mode, one 16-byte block */
static inline void AES_encrypt_block(const uint8_t *plaintext, uint8_t *final_state) {
  AES_encrypt_state((uint8_t(*)[4])iv, (uint8_t(*)[4])final_state);
  counter_add_one();
  for (int y = 0; y < NB; y++)
    *((uint32_t *)&final_state[4 * y]) ^= *((const uint32_t *)&plaintext[4 * y]);
}

/* The timed kernel: blocks of plaintext at pt to ciphertext at ct */
KERNEL static void aes_encrypt(const uint8_t *pt, uint8_t *ct, uint32_t blocks) {
  for (uint32_t b = 0; b < blocks; b++)
    AES_encrypt_block(pt + b * 16, ct + b * 16);
}

/////////////////////
// Tables and data //
/////////////////////

/* The AES S-box (FIPS-197), copied to the SPM at init */
static const uint8_t sbox_rom[256] = {
  0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
  0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
  0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
  0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
  0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
  0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
  0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
  0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
  0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
  0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
  0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
  0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
  0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
  0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
  0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
  0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};

static const uint8_t rcon_rom[11] = {0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};

/* FIPS-197 key of the known-answer tests (C.1/C.2/C.3: 00 01 02 ...) */
static void init_hot(void) {
  for (int i = 0; i < 256; i++)
    sbox[i] = sbox_rom[i];
  for (int i = 0; i < 11; i++)
    rcon[i] = rcon_rom[i];
  for (int i = 0; i < NK * 4; i++)
    key_value[i] = (uint8_t)i;
  AES_KeyExpansion();
}

static void iv_reset(void) {
  for (int i = 0; i < 16; i++)
    iv[i] = (uint8_t)(0xA0 + i);              /* same start for every variant: same ciphertext */
}

/* FIPS-197 appendix C: plaintext 00 11 22 ... ff, key 00 01 02 ...; the expected ciphertext per key size */
static void known_answer_check(void) {
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
    if (out[i] != exp[i]) {
      printf("[FAIL] FIPS-197 known answer, byte %d: 0x%x, expected 0x%x\n", i, out[i], exp[i]);
      errors++;
      return;
    }
}

KERNEL static uint32_t sum_arr(volatile uint32_t *p, int n) {
  uint32_t s = 0;
  for (int j = 0; j < n; j++)
    s += p[j];
  return s;
}

static uint32_t golden_checksum;

static uint32_t ct_checksum(void) {
  dcache_flush();
  return sum_arr((volatile uint32_t *)CT_ADDR, DATA_BYTES / 4);
}

static void print_res(const char *variant, uint32_t budget, uint32_t cycles, const dcache_perf_t *perf) {
  printf("RES variant=%s budget=%d kernel=aes%d cycles=%d hit_r=%d miss_r=%d hit_w=%d miss_w=%d refill=%d "
         "wb=%d\n", variant, (int)(budget / 1024), AES_KEY_BITS, (int)cycles, (int)perf->hit_r,
         (int)perf->miss_r, (int)perf->hit_w, (int)perf->miss_w, (int)perf->refill, (int)perf->writeback);
}

//////////
// Runs //
//////////

static void run_direct(void) {
  dcache_perf_t none = {0};
  iv_reset();
  dcache_flush();
  dcache_enable(0);
  uint32_t start = read_mcycle();
  aes_encrypt((const uint8_t *)PT_ADDR, (uint8_t *)CT_ADDR, AES_BLOCKS);
  uint32_t t = read_mcycle() - start;
  dcache_enable(1);
  check("direct checksum", ct_checksum(), golden_checksum);
  print_res("direct", 0, t, &none);
}

/* Tiles of plaintext in and ciphertext out, double buffered: pt0 pt1 ct0 ct1 of budget / 4 each */
static void run_idma(uint32_t budget) {
  dcache_perf_t none = {0};
  uint32_t tile_bytes = budget / 4;
  if (tile_bytes > DATA_BYTES)
    tile_bytes = DATA_BYTES;
  uint32_t tile_blocks = tile_bytes / 16;
  int      tiles       = AES_BLOCKS / tile_blocks;
  uint32_t in_id[2] = {0, 0}, out_id[2] = {0, 0};

  iv_reset();
  dcache_flush();
  uint32_t start = read_mcycle();
  in_id[0] = dma_in(PT_ADDR, SPM, tile_bytes);
  for (int t = 0; t < tiles; t++) {
    int b = t & 1, nx = b ^ 1;
    if (t + 1 < tiles) {
      if (t >= 1)
        idma_wait_out(out_id[nx]);
      in_id[nx] = dma_in(PT_ADDR + (t + 1) * tile_bytes, SPM + nx * tile_bytes, tile_bytes);
    }
    idma_wait_in(in_id[b]);
    aes_encrypt((const uint8_t *)(SPM + b * tile_bytes), (uint8_t *)(SPM + (2 + b) * tile_bytes), tile_blocks);
    out_id[b] = dma_out(SPM + (2 + b) * tile_bytes, CT_ADDR + t * tile_bytes, tile_bytes);
  }
  idma_wait_out(out_id[(tiles - 1) & 1]);
  uint32_t t = read_mcycle() - start;
  check("idma checksum", ct_checksum(), golden_checksum);
  print_res("idma", budget, t, &none);
}

static void run_cache(uint32_t budget, uint32_t prefetch) {
  const char   *variant = prefetch ? "cache_pf1" : "cache_pf0";
  uint32_t      way_bytes = L1_DCACHE_SIZE / dcache_num_ways();
  uint32_t      ways = budget / way_bytes;
  uint32_t      spm_base, spm_size;
  dcache_perf_t perf;

  if (ways == 0 || ways > dcache_num_ways() || ways * way_bytes != budget) {
    printf("cache %d KiB: not a number of ways, skipped\n", (int)(budget / 1024));
    return;
  }
  dcache_set_ways(ways, &spm_base, &spm_size);
  dcache_set_prefetch(prefetch);
  iv_reset();
  dcache_flush();
  dcache_perf_start();
  uint32_t start = read_mcycle();
  aes_encrypt((const uint8_t *)PT_ADDR, (uint8_t *)CT_ADDR, AES_BLOCKS);
  uint32_t t1 = read_mcycle() - start;
  dcache_perf_stop();
  dcache_perf_read(&perf);
  start = read_mcycle();
  dcache_flush();
  uint32_t tf = read_mcycle() - start;
  check("cache checksum", ct_checksum(), golden_checksum);
  print_res(variant, budget, t1 + tf, &perf);
  dcache_set_prefetch(0);
  dcache_set_ways(dcache_num_ways(), &spm_base, &spm_size);
}

int main(void) {
  asm volatile("csrw mcountinhibit, zero");

  printf("obpmark aes-%d ctr: %d blocks (%d KiB), dcache %d ways x %d sets (%d KiB), geometry %s\n",
         AES_KEY_BITS, AES_BLOCKS, DATA_BYTES / 1024, (int)dcache_num_ways(), MAGIA_DCACHE_SETS,
         L1_DCACHE_SIZE / 1024, dcache_geometry_ok() ? "ok" : "MISMATCH");
  if (!dcache_geometry_ok() || (uint32_t)&_bss_end > ARENA || ARENA_END > 0xCCF00000) {
    printf("[FAIL] geometry or arena\n");
    return 1;
  }

  init_hot();
  known_answer_check();

  // Plaintext in L2 through the cache (not timed), then the reference ciphertext
  volatile uint32_t *pt = (volatile uint32_t *)PT_ADDR;
  uint32_t x = 0x2026u;
  for (uint32_t i = 0; i < DATA_BYTES / 4; i++) {
    x = x * 1664525u + 1013904223u;
    pt[i] = x;
  }
  iv_reset();
  aes_encrypt((const uint8_t *)PT_ADDR, (uint8_t *)CT_ADDR, AES_BLOCKS);
  golden_checksum = ct_checksum();

  if (RUN_DIRECT)
    run_direct();
  for (uint32_t i = 0; i < sizeof(budgets_kib) / sizeof(budgets_kib[0]); i++) {
    uint32_t budget = budgets_kib[i] * 1024;
    if (RUN_IDMA)
      run_idma(budget);
    if (CACHE_PF & 1)
      run_cache(budget, 0);
    if (CACHE_PF & 2)
      run_cache(budget, 1);
  }

  printf("obpmark_aes_test: %d errors\n", (int)errors);
  return errors;
}
