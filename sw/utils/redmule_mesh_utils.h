#ifndef REDMULE_MESH_UTILS_H
#define REDMULE_MESH_UTILS_H

inline uint32_t get_hartid(){
    uint32_t hartid;
    asm volatile("csrr %0, mhartid"
                 :"=r"(hartid):);
    return hartid;
}

#endif /*REDMULE_MESH_UTILS_H*/