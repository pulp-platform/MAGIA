#ifndef REDMULE_MESH_UTILS_H
#define REDMULE_MESH_UTILS_H

#include "redmule_tile_utils.h"

#define STR_OFFSET  (0x00000000)
#define STR_BASE    (RESERVED_START + STR_OFFSET)
#define SYNC_OFFSET (0x0000F000)
#define SYNC_BASE   (RESERVED_START + SYNC_OFFSET)

#define MESH_X_TILES (4)
#define MESH_Y_TILES (4)
#define NUM_HARTS    (MESH_X_TILES*MESH_Y_TILES)

#define h_pprintf(x) (h_psprint(get_hartid(), x))
#define n_pprintf(x) (n_psprint(get_hartid(), x))
#define   pprintf(x) (  psprint(get_hartid(), x))
#define   pprintln   (  pprintf("\n"))

inline uint32_t get_hartid(){
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    return hartid;
}

inline void amo_increment(uint32_t addr){
    asm volatile("addi t0, %0, 0" ::"r"(addr));
    asm volatile("li t1, 1" ::);
    asm volatile("amoadd.w t2, t1, (t0)" ::);
}

/**
 * C++ version 0.4 char* style "itoa":
 * Written by Lukás Chmela
 * Released under GPLv3.
 */
char* itoa(int value, char* result, int base) {
    // check that the base if valid
    if (base < 2 || base > 36) { *result = '\0'; return result; }

    char* ptr = result, *ptr1 = result, tmp_char;
    int tmp_value;

    do {
        tmp_value = value;
        value /= base;
        *ptr++ = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz" [35 + (tmp_value - value * base)];
    } while ( value );

    // Apply negative sign
    if (tmp_value < 0) *ptr++ = '-';
    *ptr-- = '\0';
  
    // Reverse the string
    while(ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr--= *ptr1;
        *ptr1++ = tmp_char;
    }
    return result;
}

char* bs(uint32_t x) {
    uint32_t hartid = get_hartid();
    char *address = STR_BASE + L1_TILE_OFFSET*hartid;

    return itoa(x, address, 2);
}

char* ds(uint32_t x) {
    uint32_t hartid = get_hartid();
    char *address = STR_BASE + L1_TILE_OFFSET*hartid;

    return itoa(x, address, 10);
}

char* hs(uint32_t x) {
    uint32_t hartid = get_hartid();
    char *address = STR_BASE + L1_TILE_OFFSET*hartid;

    return itoa(x, address, 16);
}

void h_psprint(uint32_t hartid, const char* string){
    mmio8(0xFFFF0004 + (hartid*4)) = '[';
    mmio8(0xFFFF0004 + (hartid*4)) = 'm';
    mmio8(0xFFFF0004 + (hartid*4)) = 'h';
    mmio8(0xFFFF0004 + (hartid*4)) = 'a';
    mmio8(0xFFFF0004 + (hartid*4)) = 'r';
    mmio8(0xFFFF0004 + (hartid*4)) = 't';
    mmio8(0xFFFF0004 + (hartid*4)) = 'i';
    mmio8(0xFFFF0004 + (hartid*4)) = 'd';
    mmio8(0xFFFF0004 + (hartid*4)) = ' ';
    char*   mhardid_str = ds(hartid);
    uint8_t mhartid_idx = 0;
    while (mhardid_str[mhartid_idx] != '\0')
        mmio8(0xFFFF0004 + (hartid*4)) = mhardid_str[mhartid_idx++];
    mmio8(0xFFFF0004 + (hartid*4)) = ']';
    mmio8(0xFFFF0004 + (hartid*4)) = ' ';

    uint8_t index = 0;
    while (string[index] != '\0')
        mmio8(0xFFFF0004 + (hartid*4)) = string[index++];
}

void n_psprint(uint32_t hartid, const char* string){
    uint8_t index = 0;
    while (string[index] != '\0')
        mmio8(0xFFFF0004 + (hartid*4)) = string[index++];
    mmio8(0xFFFF0004 + (hartid*4)) = '\n';
}

void psprint(uint32_t hartid, const char* string){
    uint8_t index = 0;
    while (string[index] != '\0')
        mmio8(0xFFFF0004 + (hartid*4)) = string[index++];
}

#endif /*REDMULE_MESH_UTILS_H*/