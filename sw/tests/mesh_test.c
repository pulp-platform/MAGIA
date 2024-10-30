#include "redmule_tile_utils.h"
#include "redmule_mesh_utils.h"
#include "redmule_isa_utils.h"
#include "idma_isa_utils.h"

#include "x_input.h"
#include "w_input.h"
#include "y_input.h"
#include "z_output.h"

#define X_BASE (L1_BASE + 0x00012048)
#define W_BASE (L1_BASE + 0x00016048)
#define Y_BASE (L1_BASE + 0x0001A048)
#define Z_BASE (L2_BASE + 0x00012000)
#define V_BASE (L2_BASE + 0x00016000)
#define T_BASE (L2_BASE + 0x0001A000)

#define MHARTID_OFFSET (0x00010000)

#define NUM_HARTS (4)

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
    mmio16(T_BASE + get_hartid()*MHARTID_OFFSET + 2*i) = src_data[i];

  idma_conf_in();

  dst_addr = (uint32_t)dst_address;
  src_addr = (uint32_t)(T_BASE + get_hartid()*MHARTID_OFFSET);
  len      = (uint32_t)(x_dim*y_dim*2); // 2 Bytes per element
#if VERBOSE > 10
  h_pprintf("dst_addr: 0x"); n_pprintf(hs(dst_addr));
  h_pprintf("src_addr: 0x"); n_pprintf(hs(src_addr));
  h_pprintf("len:        "); n_pprintf(ds(len));
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_addr));
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(len));
  idma_set_addr_len_in();

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  h_pprintf("dst_std_2: 0x"); n_pprintf(hs(dst_std_2));
  h_pprintf("src_std_2: 0x"); n_pprintf(hs(src_std_2));
  h_pprintf("reps_2:    0x"); n_pprintf(hs(reps_2));
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_2));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_2));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  idma_set_std2_rep2_in();

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  h_pprintf("dst_std_3: 0x"); n_pprintf(hs(dst_std_3));
  h_pprintf("src_std_3: 0x"); n_pprintf(hs(src_std_3));
  h_pprintf("reps_3:    0x"); n_pprintf(hs(reps_3));
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_3));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_3));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_3));
  idma_set_std3_rep3_in();

  idma_start_in();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  h_pprintf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); n_pprintf(hs(mmio16(dst_addr + 2*i)));
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_addr + 2*i) != src_data[i]) {
      num_errors++;
      h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); pprintf(hs(mmio16(dst_addr + 2*i))); 
      pprintf(" != SRC["); pprintf(ds(i)); pprintf("]: 0x"); n_pprintf(ds(src_data[i]));
    }
  }
  h_pprintf("Detected "); pprintf(ds(num_errors)); n_pprintf(" error(s) in the transfer...");
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
  h_pprintf("dst_addr: 0x"); n_pprintf(hs(dst_addr));
  h_pprintf("src_addr: 0x"); n_pprintf(hs(src_addr));
  h_pprintf("len:        "); n_pprintf(ds(len));
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_addr));
  asm volatile ("addi t1, %0, 0" :: "r"(src_addr));
  asm volatile ("addi t0, %0, 0" :: "r"(len));
  idma_set_addr_len_out();

  dst_std_2 = 0;
  src_std_2 = 0;
  reps_2    = 1;
#if VERBOSE > 100
  h_pprintf("dst_std_2: 0x"); n_pprintf(hs(dst_std_2));
  h_pprintf("src_std_2: 0x"); n_pprintf(hs(src_std_2));
  h_pprintf("reps_2:    0x"); n_pprintf(hs(reps_2));
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_2));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_2));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_2));
  idma_set_std2_rep2_out();

  dst_std_3 = 0;
  src_std_3 = 0;
  reps_3    = 1;
#if VERBOSE > 100
  h_pprintf("dst_std_3: 0x"); n_pprintf(hs(dst_std_3));
  h_pprintf("src_std_3: 0x"); n_pprintf(hs(src_std_3));
  h_pprintf("reps_3:    0x"); n_pprintf(hs(reps_3));
#endif
  asm volatile ("addi t2, %0, 0" :: "r"(dst_std_3));
  asm volatile ("addi t1, %0, 0" :: "r"(src_std_3));
  asm volatile ("addi t0, %0, 0" :: "r"(reps_3));
  idma_set_std3_rep3_out();

  idma_start_out();

#ifdef IRQ_EN
  asm volatile("wfi" ::: "memory");
  h_pprintf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

#if VERBOSE > 100
  for (int i = 0; i < x_dim*y_dim; i++){
    h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); n_pprintf(hs(mmio16(dst_addr + 2*i)));
  }
#endif

#if VERBOSE > 10
  unsigned int num_errors;
  num_errors = 0;
  for (int i = 0; i < x_dim*y_dim; i++) {
    if (mmio16(dst_addr + 2*i) != mmio16(src_addr + 2*i)) {
      num_errors++;
      h_pprintf("DST[0x"); pprintf(hs(dst_addr + 2*i)); pprintf("]: 0x"); pprintf(hs(mmio16(dst_addr + 2*i)));
      pprintf(" != SRC[0x"); pprintf(hs(src_addr + 2*i)); pprintf("]: 0x"); n_pprintf(hs(mmio16(src_addr + 2*i)));
    }
  }
  h_pprintf("Detected "); pprintf(ds(num_errors)); n_pprintf(" error(s) in the transfer...");
#endif
}

int main(void) {
  // X
  h_pprintf("Initializing X through iDMA...\n");
  idma_mv_in(M_SIZE, N_SIZE, x_inp, (X_BASE + get_hartid()*0x10000000));

  // W
  h_pprintf("Initializing W through iDMA...\n");
  idma_mv_in(N_SIZE, K_SIZE, w_inp, (W_BASE + get_hartid()*0x10000000));

  // Y
  h_pprintf("Initializing Y through iDMA...\n");
  idma_mv_in(M_SIZE, K_SIZE, y_inp, (Y_BASE + get_hartid()*0x10000000));

  uint32_t cfg_reg0[NUM_HARTS];
  uint32_t cfg_reg1[NUM_HARTS];
  
  cfg_reg0[get_hartid()] = ((((uint16_t)K_SIZE) << 16) | (((uint16_t)M_SIZE) << 0));
  cfg_reg1[get_hartid()] = (((uint16_t)N_SIZE) << 0);

#if VERBOSE > 10
  h_pprintf("K_SIZE: 0x");   n_pprintf(hs(K_SIZE));
  h_pprintf("M_SIZE: 0x");   n_pprintf(hs(M_SIZE));
  h_pprintf("N_SIZE: 0x");   n_pprintf(hs(N_SIZE));
  h_pprintf("cfg_reg0: 0x"); n_pprintf(hs(cfg_reg0[get_hartid()]));
  h_pprintf("cfg_reg1: 0x"); n_pprintf(hs(cfg_reg1[get_hartid()]));
#endif

  asm volatile("addi t0, %0, 0" ::"r"((uint32_t)(X_BASE + get_hartid()*0x10000000)));
  asm volatile("addi t1, %0, 0" ::"r"((uint32_t)(W_BASE + get_hartid()*0x10000000)));
  asm volatile("addi t2, %0, 0" ::"r"((uint32_t)(Y_BASE + get_hartid()*0x10000000)));
  asm volatile("addi t3, %0, 0" ::"r"(cfg_reg0[get_hartid()]));
  asm volatile("addi t4, %0, 0" ::"r"(cfg_reg1[get_hartid()]));

  redmule_mcnfig();

  redmule_marith();

#ifdef IRQ_EN
  irq_en(1<<IRQ_REDMULE_EVT_0);
#endif

  h_pprintf("Testing matrix multiplication with RedMulE...\n");

#ifdef IRQ_EN
  // Wait for end of computation
  asm volatile("wfi" ::: "memory");
  h_pprintf("Detected IRQ...\n");
#else
  wait_print(WAIT_CYCLES);
#endif

  h_pprintf("Moving results through iDMA...\n");
  idma_mv_out(M_SIZE, K_SIZE, Y_BASE + get_hartid() * 0x10000000, V_BASE + get_hartid() * MHARTID_OFFSET);

  h_pprintf("Verifying results...\n");
  
  unsigned int num_errors[NUM_HARTS];
  num_errors[get_hartid()] = 0;

  uint16_t computed[NUM_HARTS], expected[NUM_HARTS], diff[NUM_HARTS];
  for(int i = 0; i < M_SIZE*K_SIZE; i++){
    computed[get_hartid()] = mmio16(V_BASE + get_hartid()*MHARTID_OFFSET + 2*i);
    expected[get_hartid()] = z_oup[i];
    diff[get_hartid()] = (computed[get_hartid()] > expected[get_hartid()]) ? (computed[get_hartid()] - expected[get_hartid()]) : (expected[get_hartid()] - computed[get_hartid()]);
    if(diff[get_hartid()] > DIFF_TH){
      num_errors[get_hartid()]++;
      h_pprintf("**ERROR**: V[0x"); pprintf(hs(V_BASE + get_hartid()*MHARTID_OFFSET + 2*i)); pprintf("](=0x"); pprintf(hs(computed[get_hartid()]));
      pprintf(") != Z["); pprintf(ds(i)); pprintf("](=0x"); pprintf(hs(expected[get_hartid()])); n_pprintf(")");
    }
  }
  h_pprintf("Finished test with "); pprintf(ds(num_errors[get_hartid()])); n_pprintf(" error(s)");

  uint32_t exit_code[NUM_HARTS];
  if(num_errors[get_hartid()])
    exit_code[get_hartid()] = FAIL_EXIT_CODE;
  else
    exit_code[get_hartid()] = PASS_EXIT_CODE;

  mmio8(TEST_END_ADDR + get_hartid()) = exit_code[get_hartid()] - get_hartid();

  return 0;
}