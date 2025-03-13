#ifndef REDMULE_ISA_UTILS_H
#define REDMULE_ISA_UTILS_H

/* mcnfig instruction */
  // asm volatile(
  //      ".word (0x0       << 25) | \     /* Empty */
  //             (0b00110   << 20) | \     /* Rs2 - t1 */
  //             (0b00101   << 15) | \     /* Rs1 - t0 */
  //             (0x00      <<  7) | \     /* Empty */
  //             (0b0001011 <<  0)   \n"); /* OpCode */
inline void redmule_mcnfig(volatile uint16_t k_size, volatile uint16_t m_size, volatile uint16_t n_size){
  uint32_t cfg_reg0 = (k_size << 16) | (m_size << 0);
  uint32_t cfg_reg1 = n_size << 0;
  asm volatile("addi t0, %0, 0" ::"r"(cfg_reg0));
  asm volatile("addi t1, %0, 0" ::"r"(cfg_reg1));
  asm volatile(
       ".word (0x0       << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0x00      <<  7) | \
              (0b0001011 <<  0)   \n");
}

/* marith instruction */
  // asm volatile(
  //     ".word (0b00111   << 27) | \     /* Rs3 - t2 */
  //            (0b00      << 25) | \     /* Empty */
  //            (0b00110   << 20) | \     /* Rs2 - t1 */
  //            (0b00101   << 15) | \     /* Rs1 - t0 */
  //            (0b0       << 14) | \     /* Custom format enable/disable */
  //            (0b0       << 13) | \     /* Widening enable/disable */
  //            (0b001     << 10) | \     /* Operation selection */
  //            (0b001     <<  7) | \     /* Data format */
  //            (0b0101011 <<  0)   \n"); /* OpCode */
inline void redmule_marith(volatile uint32_t y_base, volatile uint32_t w_base, volatile uint32_t x_base){
  asm volatile("addi t2, %0, 0" ::"r"(y_base));
  asm volatile("addi t1, %0, 0" ::"r"(w_base));
  asm volatile("addi t0, %0, 0" ::"r"(x_base));
  asm volatile(
       ".word (0b00111   << 27) | \
              (0b00      << 25) | \
              (0b00110   << 20) | \
              (0b00101   << 15) | \
              (0b0       << 14) | \
              (0b0       << 13) | \
              (0b001     << 10) | \
              (0b001     <<  7) | \
              (0b0101011 <<  0)   \n");
}

#endif /*REDMULE_ISA_UTILS_H*/