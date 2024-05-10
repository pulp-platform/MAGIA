#include "redmule_tile_utils.h"

#include "x_input.h"

#define X_BASE (L1_BASE + 0x00012048)
#define Z_BASE (L2_BASE + 0x00001000)

#define M_SIZE (96)
#define N_SIZE (64)

#define VERBOSE (100)

#define WAIT_CYCLES (50)

int main(void) {
  // Z - golden (reference)
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    mmio16(Z_BASE + 2*i) = x_inp[i];
#if VERBOSE > 100
  for (int i = 0; i < M_SIZE*N_SIZE; i++)
    printf("Z[%8x]: 0x%4x\n", Z_BASE + 2*i, mmio16(Z_BASE + 2*i));
#endif

  /* conf instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Decouple R/AW - see iDMA documentation */
  //             (0b0       << 24) | \     /* Decouple R/W - see iDMA documentation */
  //             (0b0       << 23) | \     /* Source reduce length - see iDMA documentation */
  //             (0b0       << 22) | \     /* Destination reduce length - see iDMA documentation */
  //             (0b000     << 19) | \     /* Source maximum logarithmic length - see iDMA documentation */
  //             (0b000     << 16) | \     /* Destination maximum logarithmic length - see iDMA documentation */
  //             (0b1       << 15) | \     /* Enable ND extension - see iDMA documentation */
  //             (0b000     << 12) | \     /* FUNC3 */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1011011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0b0       << 25) | \
              (0b0       << 24) | \
              (0b0       << 23) | \
              (0b0       << 22) | \
              (0b000     << 19) | \
              (0b000     << 16) | \
              (0b1       << 15) | \
              (0b000     << 12) | \
              (0x0       <<  7) | \
              (0b1011011 <<  0)   \n");

  uint32_t x_dst_addr = (uint32_t)X_BASE;
#if VERBOSE > 10
  printf("x_dst_addr: 0x%8x\n", x_dst_addr);
#endif
  asm volatile ("addi t0, %0, 0" :: "r"(x_dst_addr));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b000     << 12) | \     /* FUNC3 - DST_ADDR */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b000     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  uint32_t x_src_addr = (uint32_t)Z_BASE;
#if VERBOSE > 10
  printf("x_src_addr: 0x%8x\n", x_src_addr);
#endif
  asm volatile ("addi t0, %0, 0" :: "r"(x_src_addr));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b001     << 12) | \     /* FUNC3 - SRC_ADDR */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b001     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  uint32_t len = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
#if VERBOSE > 10
  printf("len: %0d\n", len);
#endif
  asm volatile ("addi t0, %0, 0" :: "r"(len));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b010     << 12) | \     /* FUNC3 - LEN */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b010     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  uint32_t reps_2 = 1;
#if VERBOSE > 10
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b101     << 12) | \     /* FUNC3 - REP_2 */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b101     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  /* start instruction */
  // asm volatile(
  //      ".word (0x0       << 15) | \     /* Reserved - 0x0 */
  //             (0b111     << 12) | \     /* FUNC3 - START */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 15) | \
              (0b111     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  wait_print(WAIT_CYCLES);
  
  unsigned int num_errors = 0;

  uint16_t x_l1, x_l2;
  for(int i = 0; i < M_SIZE*N_SIZE; i++){
    x_l1 = mmio16(X_BASE + 2*i);
    x_l2 = mmio16(Z_BASE + 2*i);
    if(x_l1 != x_l2){
      num_errors++;
      printf("**ERROR**: L1_X[%0d](=0x%4x) != L2_X[%0d](=0x%4x)\n", i, x_l1, i, x_l2);
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