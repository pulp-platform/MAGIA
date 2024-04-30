#ifndef REDMULE_TILE_UTILS_H
#define REDMULE_TILE_UTILS_H

#include "tinyprintf.h"

#define L1_BASE       (0x1C010000)
#define L2_BASE       (0x2C010000)
#define TEST_END_ADDR (0x2C030000)

#define DEFAULT_EXIT_CODE (0xAF)
#define PASS_EXIT_CODE    (0xA)
#define FAIL_EXIT_CODE    (0xF)

#define mmio64(x) (*(volatile uint64_t *)(x))
#define mmio32(x) (*(volatile uint32_t *)(x))
#define mmio16(x) (*(volatile uint16_t *)(x))
#define mmio8(x)  (*(volatile uint8_t  *)(x))

#define addr64(x) (*(uint64_t *)(&x))
#define addr32(x) (*(uint32_t *)(&x))
#define addr16(x) (*(uint16_t *)(&x))
#define addr8(x)  (*(uint8_t  *)(&x))

void wait_print(unsigned int cycles){
    for(int i = 0; i <= cycles; i++){
        printf("Waiting: [");
        for(int j = 0; j < i; j++)
            printf("+");
        for(int j = 0; j < cycles - i; j++)
            printf("-");
        printf("]\n");
    }
}

#endif /*REDMULE_TILE_UTILS_H*/