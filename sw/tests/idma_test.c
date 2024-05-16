#include "redmule_tile_utils.h"

#include "x_input.h"

#define X_BASE (L1_BASE + 0x00012048)
#define Y_BASE (L1_BASE + 0x00016048)
#define Z_BASE (L2_BASE + 0x00001000)
#define W_BASE (L2_BASE + 0x00005000)

#define M_SIZE (96)
#define N_SIZE (64)

#define VERBOSE (0)

#define WAIT_CYCLES (10)

#define CONCURRENT

int main(void) {
  uint32_t dst_addr;
  uint32_t src_addr;
  uint32_t len;
  uint32_t reps_2;

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

  src_addr = (uint32_t)Z_BASE;
  dst_addr = (uint32_t)X_BASE;
#if VERBOSE > 10
  printf("src_addr: 0x%8x (Z_BASE)\n", src_addr);
  printf("dst_addr: 0x%8x (X_BASE)\n", dst_addr);
#endif
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(dst_addr));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b000     << 12) | \     /* FUNC3 - ADDR */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0b0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b000     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");


  len = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
  reps_2 = 1;
#if VERBOSE > 10
  printf("len: %0d\n", len);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  asm volatile ("addi t1, %0, 0" :: "r"(len));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b001     << 12) | \     /* FUNC3 - LEN/REP_2 */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0b0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b001     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  /* start instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0x0       << 15) | \     /* Reserved - 0x0 */
  //             (0b111     << 12) | \     /* FUNC3 - START */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0x0       << 15) | \
              (0b111     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  printf("iDMA moving data from L2 to L1...\n");
  wait_print(WAIT_CYCLES);

  /* conf instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b1       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
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
              (0b1       << 26) | \
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

  src_addr = (uint32_t)X_BASE;
  dst_addr = (uint32_t)W_BASE;
#if VERBOSE > 10
  printf("src_addr: 0x%8x (X_BASE)\n", src_addr);
  printf("dst_addr: 0x%8x (W_BASE)\n", dst_addr);
#endif
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(dst_addr));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b1       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b000     << 12) | \     /* FUNC3 - ADDR */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b1       << 26) | \
              (0b0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b000     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  len = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
  reps_2 = 1;
#if VERBOSE > 10
  printf("len: %0d\n", len);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  asm volatile ("addi t1, %0, 0" :: "r"(len));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b1       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b001     << 12) | \     /* FUNC3 - LEN/REP_2 */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b1       << 26) | \
              (0b0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b001     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

#ifdef CONCURRENT
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

  src_addr = (uint32_t)Z_BASE;
  dst_addr = (uint32_t)Y_BASE;
#if VERBOSE > 10
  printf("src_addr: 0x%8x (Z_BASE)\n", src_addr);
  printf("dst_addr: 0x%8x (Y_BASE)\n", dst_addr);
#endif
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(dst_addr));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b000     << 12) | \     /* FUNC3 - ADDR */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0b0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b000     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");


  len = (uint32_t)(M_SIZE*N_SIZE*2); // 2 Bytes per element
  reps_2 = 1;
#if VERBOSE > 10
  printf("len: %0d\n", len);
  printf("reps_2: 0x%8x\n", reps_2);
#endif
  asm volatile ("addi t1, %0, 0" :: "r"(len));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  /* set instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0b0       << 25) | \     /* Reserved - 0x0 */
  //             (0b00110   << 20) | \     /* R2 - t1 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b001     << 12) | \     /* FUNC3 - LEN/REP_2 */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0b0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b001     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  /* start instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b1       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0x0       << 15) | \     /* Reserved - 0x0 */
  //             (0b111     << 12) | \     /* FUNC3 - START */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b1       << 26) | \
              (0x0       << 15) | \
              (0b111     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  /* start instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b0       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0x0       << 15) | \     /* Reserved - 0x0 */
  //             (0b111     << 12) | \     /* FUNC3 - START */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b0       << 26) | \
              (0x0       << 15) | \
              (0b111     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  printf("iDMA moving concurrently data from L1 to L2 and from L2 to L1...\n");
  wait_print(2*WAIT_CYCLES);
#else
  /* start instruction */
  // asm volatile(
  //      ".word (0x0       << 27) | \     /* Reserved - 0x0 */
  //             (0b1       << 26) | \     /* Direction - 0 for AXI2OBI (L2 to L1), 1 for OBI2AXI (L1 to L2) */
  //             (0x0       << 15) | \     /* Reserved - 0x0 */
  //             (0b111     << 12) | \     /* FUNC3 - START */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1111011 <<  0)   \n"); /* OPCODE */
  asm volatile(
       ".word (0x0       << 27) | \
              (0b1       << 26) | \
              (0x0       << 15) | \
              (0b111     << 12) | \
              (0x0       <<  7) | \
              (0b1111011 <<  0)   \n");

  printf("iDMA moving data from L1 to L2...\n");
  wait_print(WAIT_CYCLES);
#endif

  printf("Verifying results...\n");
  
  unsigned int num_errors = 0;

  uint16_t detected, expected;
  for(int i = 0; i < M_SIZE*N_SIZE; i++){
    detected = mmio16(W_BASE + 2*i);
#ifdef CONCURRENT
    expected = mmio16(Y_BASE + 2*i);
#else
    expected = mmio16(Z_BASE + 2*i);
#endif
    if(detected != expected){
      num_errors++;
      printf("**ERROR**: DETECTED[%0d](=0x%4x) != EXPECTED[%0d](=0x%4x)\n", i, detected, i, expected);
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