#include "redmule_tile_utils.h"
#include "redmule_isa_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00012000)

#define M_SIZE (96)
#define N_SIZE (64)
#define K_SIZE (64)

#define VERBOSE (0)

#define IRQ_EN

#define WAIT_CYCLES (10)

#define DIFF_TH (0x0011)

int main(void) {
  // X
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    mmio16(X_BASE + 2*i) = x_inp[i];
#if VERBOSE > 10
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    printf("X[%8x]: 0x%4x\n", X_BASE + 2*i, mmio16(X_BASE + 2*i));
#endif

  // W
  for (int i = 0; i < N_SIZE*K_SIZE; i++)
    mmio16(W_BASE + 2*i) = w_inp[i];
#if VERBOSE > 10
  for (int i = 0; i < N_SIZE*K_SIZE; i++)
    printf("W[%8x]: 0x%4x\n", W_BASE + 2*i, mmio16(W_BASE + 2*i));
#endif

  // Y
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Y_BASE + 2*i) = y_inp[i];
#if VERBOSE > 10
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    printf("Y[%8x]: 0x%4x\n", Y_BASE + 2*i, mmio16(Y_BASE + 2*i));
#endif

  // Z - golden (reference)
  for (int i = 0; i < M_SIZE*K_SIZE; i++)
    mmio16(Z_BASE + 2*i) = z_oup[i];
#if VERBOSE > 10
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

  redmule_mcnfig();

  redmule_marith();

#ifdef IRQ_EN
  // Enable IRQs
  uint32_t index = (1<<IRQ_REDMULE_EVT_0) | (1<<IRQ_REDMULE_EVT_1);
  irq_en(index);
#endif

  // Wait for end of computation
  printf("Testing matrix multiplication with RedMulE...\n");
#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  printf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif
  printf("Verifying results...\n");
  
  unsigned int num_errors = 0;

  uint16_t computed, expected, diff;
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed = mmio16(Y_BASE + 2*i);
    expected = mmio16(Z_BASE + 2*i);
    diff = (computed > expected) ? (computed - expected) : (expected - computed);
    if(diff > DIFF_TH){
      num_errors++;
      printf("**ERROR**: Y[%8x](=0x%4x) != Z[%8x](=0x%4x)\n", Y_BASE + 2*i, computed, Z_BASE + 2*i, expected);
    }
  }
  printf("Finished test with %0d errors\n", num_errors);

  uint32_t exit_code;
  if(num_errors)
    exit_code = FAIL_EXIT_CODE;
  else
    exit_code = PASS_EXIT_CODE;

  mmio8(TEST_END_ADDR) = exit_code;

  return 0;
}