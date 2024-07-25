#include "redmule_tile_utils.h"
#include "redmule_isa_utils.h"
#include "idma_isa_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00001048)
#define V_BASE (L2_BASE + 0x00005048)
#define T_BASE (L2_BASE + 0x00009048)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (100)

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

#define CONCURRENT

#define IRQ_EN

void idma_mv_in(unsigned int x_dim, unsigned int y_dim, uint16_t src_data[], uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  uint32_t dst_std_2;
  uint32_t src_std_2;
  uint32_t reps_2;

  uint32_t dst_std_3;
  uint32_t src_std_3;
  uint32_t reps_3;

#ifdef IRQ_EN
  irq_en(1<<IRQ_A2O_DONE);
#endif

  for (int i = 0; i < x_dim*y_dim; i++)
    mmio16(T_BASE + 2*i) = src_data[i];

  idma_conf_in();

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)T_BASE;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x\n", dst_addr);
  printf("src_addr: 0x%8x\n", src_addr);
  printf("len: %0d\n", len);
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_addr));
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(len));
  idma_set_addr_len_in();

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_2));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_2));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  idma_set_std2_rep2_in();

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_3));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_3));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_3));
  idma_set_std3_rep3_in();

  idma_start_in();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++)
    printf("DST[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i));
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_address + 2*i) != src_data[i]) {
      num_errors++;
      printf("DST[%8x]: 0x%4x != SRC[%0d]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i), i, src_data[i]);
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

void idma_mv_out(unsigned int x_dim, unsigned int y_dim, uint32_t src_address, uint32_t dst_address){
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;

  uint32_t dst_std_2;
  uint32_t src_std_2;
  uint32_t reps_2;

  uint32_t dst_std_3;
  uint32_t src_std_3;
  uint32_t reps_3;

#ifdef IRQ_EN
  irq_en(1<<IRQ_O2A_DONE);
#endif

  idma_conf_out();

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)src_address;
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("dst_addr: 0x%8x\n", dst_addr);
  printf("src_addr: 0x%8x\n", src_addr);
  printf("len: %0d\n", len);
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_addr));
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(len));
  idma_set_addr_len_out();

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  printf("dst_std_2: 0x%8x\n", dst_std_2);
  printf("src_std_2: 0x%8x\n", src_std_2);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_2));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_2));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  idma_set_std2_rep2_out();

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  printf("dst_std_3: 0x%8x\n", dst_std_3);
  printf("src_std_3: 0x%8x\n", src_std_3);
  printf("reps_3: 0x%8x\n", reps_3);
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_3));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_3));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_3));
  idma_set_std3_rep3_out();

  idma_start_out();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++)
    printf("DST[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i));
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_address + 2*i) != mmio16(src_address + 2*i)) {
      num_errors++;
      printf("DST[%8x]: 0x%4x != SRC[%8x]: 0x%4x\n", dst_address + 2*i, mmio16(dst_address + 2*i), src_address + 2*i, mmio16(src_address + 2*i));
    }
  }
  printf("Detected %0d error(s) in the transfer...\n", num_errors);
#endif
}

int main(void) {
  // X
  printf("Initializing X through iDMA...\n");
  idma_mv_in(M_SIZE, N_SIZE, x_inp, X_BASE);

  // W
  printf("Initializing W through iDMA...\n");
  idma_mv_in(N_SIZE, K_SIZE, w_inp, W_BASE);

  // Y
  printf("Initializing Y through iDMA...\n");
  idma_mv_in(M_SIZE, K_SIZE, y_inp, Y_BASE);

  // Z - golden (reference)
  printf("Initializing Z - golden...\n");
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Z_BASE + 2*i) = z_oup[i];
#if VERBOSE > 100
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    printf("Z[%8x]: 0x%4x\n", Z_BASE + 2*i, mmio16(Z_BASE + 2*i));
#endif

  uint32_t cfg_reg0 = ((((uint16_t)K_SIZE) << 16) | (((uint16_t)M_SIZE) << 0));
  uint32_t cfg_reg1 = (((uint16_t)N_SIZE) << 0);

#if VERBOSE > 10
  printf("K_SIZE: %4x\n", K_SIZE);
  printf("M_SIZE: %4x\n", M_SIZE);
  printf("N_SIZE: %4x\n", N_SIZE);  
  printf("cfg_reg0: %8x\n", cfg_reg0);
  printf("cfg_reg1: %8x\n", cfg_reg1);
#endif

  asm volatile("addi t0, %0, 0" ::"r"((uint32_t)X_BASE));
  asm volatile("addi t1, %0, 0" ::"r"((uint32_t)W_BASE));
  asm volatile("addi t2, %0, 0" ::"r"((uint32_t)Y_BASE));
  asm volatile("addi t3, %0, 0" ::"r"(cfg_reg0));
  asm volatile("addi t4, %0, 0" ::"r"(cfg_reg1));

#ifdef IRQ_EN
  irq_en(1<<IRQ_REDMULE_EVT_0);
#endif

  redmule_mcnfig();

  redmule_marith();

  printf("Testing matrix multiplication with RedMulE...\n");

#ifdef IRQ_EN
  // Wait for end of computation
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

  printf("Moving results through iDMA...\n");
  idma_mv_out(M_SIZE, K_SIZE, Y_BASE, V_BASE);

  printf("Verifying results...\n");
  
  unsigned int num_errors = 0;

  uint16_t computed, expected, diff;
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed = mmio16(V_BASE + 2*i);
    expected = mmio16(Z_BASE + 2*i);
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
      num_errors++;
      printf("**ERROR**: V[%8x](=0x%4x) != Z[%8x](=0x%4x)\n", V_BASE + 2*i, computed, Z_BASE + 2*i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);

  uint32_t exit_code;
  if(num_errors)
    exit_code = FAIL_EXIT_CODE;
  else
    exit_code = PASS_EXIT_CODE;

  mmio32(TEST_END_ADDR) = exit_code;

  return 0;
}