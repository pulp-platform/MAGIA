#ifndef FSYNC_ISA_UTILS_H
#define FSYNC_ISA_UTILS_H

/* synch instruction */
  // asm volatile(
  //      ".word (0x0       << 20) | \     /* Reserved - 0x0 */
  //             (0b00101   << 15) | \     /* R1 - t0 */
  //             (0b010     << 12) | \     /* FUNC3 */
  //             (0x0       <<  7) | \     /* Reserved - 0x0 */
  //             (0b1011011 <<  0)   \n"); /* OPCODE */
inline void fsync(volatile uint32_t level){
  asm volatile("addi t0, %0, 0" ::"r"(level));
  asm volatile(
       ".word (0x0       << 20) | \
              (0b00101   << 15) | \
              (0b010     << 12) | \
              (0x0       <<  7) | \
              (0b1011011 <<  0)   \n");
}

#endif /*FSYNC_ISA_UTILS_H*/
