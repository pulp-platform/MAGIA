#include <stdio.h>
#include "redmule_tile_utils.h"

#define X_BASE (0x1C010100)
#define W_BASE (0x1C010200)
#define Y_BASE (0x1C010300)
#define Z_BASE (0x1C010400)
#define E_BASE (0x2C010100)

#define M_SIZE (2)
#define N_SIZE (4)
#define K_SIZE (3)

int main(void) {
  for (int i = 0; i < M_SIZE*N_SIZE; ++i)
    mmio32(X_BASE + 2*i) = 1 + i;

  for (int i = 0; i < N_SIZE*K_SIZE; ++i)
    mmio32(W_BASE + 2*i) = 1 + i;

  for (int i = 0; i < M_SIZE*K_SIZE; ++i)
    mmio32(Y_BASE + 2*i) = 1;

  for (int i = 0; i < M_SIZE*K_SIZE; ++i)
    mmio32(Z_BASE + 2*i) = 0;

  for (int i = 0; i < M_SIZE*K_SIZE; ++i)
    mmio32(E_BASE + 2*i) = (i < 3) ? 70 + i*10 : 2*(70 + (i-3)*10) + 18 + (i-3)*6;

  uint32_t cfg_reg0 = ((((uint16_t)K_SIZE) << 16) | (((uint16_t)M_SIZE) << 0));
  uint32_t cfg_reg1 = (((uint16_t)N_SIZE) << 0);

  asm volatile("addi t0, %0, 0" ::"r"((uint32_t)X_BASE));
  asm volatile("addi t1, %0, 0" ::"r"((uint32_t)W_BASE));
  asm volatile("addi t2, %0, 0" ::"r"((uint32_t)Y_BASE));
  asm volatile("addi t3, %0, 0" ::"r"(cfg_reg0));
  asm volatile("addi t4, %0, 0" ::"r"(cfg_reg1));

  /* mcnfig instruction */
  // asm volatile(
  //      ".word (0x0       << 25) | \     /* Empty */
  //             (0b11101   << 20) | \     /* Rs2 */
  //             (0b11100   << 15) | \     /* Rs1 */
  //             (0x00      <<  7) | \     /* Empty */
  //             (0b0001011 <<  0)   \n"); /* OpCode */

  asm volatile(".word (0x0       << 25) | \
              (0b11101   << 20) | \
              (0b11100   << 15) | \
              (0x00      <<  7) | \
              (0b0001011 <<  0)   \n");

  /* marith instruction */
  // sm volatile(
  //     ".word (0b00111   << 27) | \     /* Rs3 */
  //            (0b00      << 25) | \     /* Empty*/
  //            (0b00110   << 20) | \     /* Rs2 */
  //            (0b00101   << 15) | \     /* Rs1 */
  //            (0b0       << 14) | \     /* Custom format enable/disable */
  //            (0b0       << 13) | \     /* Widening enable/disable */
  //            (0b001     << 10) | \     /* Operation selection */
  //            (0b001     <<  7) | \     /* Data format */
  //            (0b0101011 <<  0)   \n"); /* OpCode */

  asm volatile(".word (0b00111   << 27) | \
              (0b00      << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b0       << 14) | \
              (0b0       << 13) | \
              (0b001     << 10) | \
              (0b001     <<  7) | \
              (0b0101011 <<  0)   \n");
  
//   uint8_t exit_code;
  
//   mmio32(L2_BASE + 0x4) = 0x1;
//   mmio32(L2_BASE + 0x8) = 0x2;

//   mmio32(L1_BASE + 0x4) = mmio32(L2_BASE + 0x4);
//   mmio32(L1_BASE + 0x8) = mmio32(L2_BASE + 0x8);
//   mmio32(L1_BASE + 0xC) = mmio32(L1_BASE + 0x4) + mmio32(L1_BASE + 0x8);

//   mmio32(L2_BASE + 0xC) = mmio32(L1_BASE + 0xC);
//   if (mmio32(L2_BASE + 0xC) == 0x3)
//     exit_code = PASS_EXIT_CODE;
//   else
//     exit_code = FAIL_EXIT_CODE;

//   mmio32(TEST_END_ADDR) = exit_code;

  return 0;
}