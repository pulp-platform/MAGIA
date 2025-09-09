# MAGIA
[![License](https://img.shields.io/badge/license-Apache--2.0-green)](LICENSE.APACHE)
[![SHL-0.51 license](https://img.shields.io/badge/license-SHL--0.51-green)](LICENSE.SHL)

This repo contains MAGIA (**M**esh **A**rchitecture for **G**enerative **I**ntelligence **A**cceleration), an open-source large-scale accelerator designed for Generative Artificial Intelligence (GenAI). MAGIA is a network of tiles that have at their heart [RedMulE](https://github.com/pulp-platform/redmule) for General Matrix Multiply (GeMM) acceleration, [iDMA](https://github.com/pulp-platform/iDMA) for fast and efficient data movement and an L1 scratchpad memory (SPM). Tiles are connected to a mesh Network-on-Chip (NoC) - [FlooNoC](https://github.com/pulp-platform/FlooNoC) - used for communication, and a dedicated network for synchronization - [FractalSync](https://github.com/VictorIsachi/fractal_sync). MAGIA is designed to support matrices of sizes that vary by orders of magnitude, and also sparse matrix multiplication. 

MAGIA is developed as part of the [PULP (Parallel Ultra-Low Power)](https://pulp-platform.org/) project, a joint effort between ETH Zurich and the University of Bologna.

## ⭐ Getting Started

### Pre-requisites

MAGIA uses [bender](https://github.com/pulp-platform/bender) to manage its dependencies and to automatically generate compilation scripts.

We use a virtual python environment which requires python>=3.6.8. To *create the envrionment* use (`MAGIA` folder):

```bash
make python_venv
```

By default, the `python` in your `$PATH` is used. You can specify the version by optionally exporting the `BASE_PYTHON` environment variable.

### Simulation

The following *optional* parameters can be specified:

`mesh_dv`: **0**|**1** (**Default**: 1). 0 simulation of a single tile; 1 simulation of the entire mesh.

`fast_sim`: **0**|**1** (**Default**: 0). 0 faster simulation that does not track signals; 1 simulation that tracks signals (for debugging).

`gui`: **0**|**1** (**Default**: 0). 0 simulation without GUI; 1 simulation with GUI.

`test`: **tile_test**|**mesh_test** (**Default**: mesh_test). Specifies which tests should be run. More fine-grain tests are available, see `sw/tests`.

**Instructions to build HW/SW and run simulations**:

**1)** Setup the *environment* (`MAGIA` folder):
```bash
source setup_env.sh
```
**2)** Install *python dependencies* (`MAGIA` folder):
```bash
make python_deps
```
**3)** Download *Bender* (`MAGIA` folder):
```bash
make bender
```
**4)** Clone the *dependencies* and generate the *compilation script* (`MAGIA` folder):
```bash
make update-ips > update-ips.log <mesh_dv>
```
**4\*)** Apply FlooNoC *patch* - **currently FlooNoC requires this step but should not need it in the future** (`MAGIA` folder):
```bash
make floonoc-patch
```
**5)** *Build* the hardware (`MAGIA` folder):
```bash
make build-hw > build-hw.log <mesh_dv> <fast_sim>
```
**6)** *Compile* the test code (`MAGIA` folder):
```bash
make all <test>
```
**7)** *Run* test (`MAGIA` folder):
```bash
make run <test> <gui> <mesh_dv>
```

**Full example**:
```bash
make python_venv
source setup_env.sh
make python_deps
make bender
make update-ips > update-ips.log
make build-hw > build-hw.log fast_sim=1
make all test=fsync_test
make run test=fsync_test
```

## ⚙️ Architecture

![](doc/MAGIA.png)

### Tile
The central piece of the architecture is the MAGIA tile containing a GeMM accelerator, a DMA engine, a multi-banked L1 SPM and a lightweight control core. The L1 features interleaved memory banks that compose the Tightly-Coupled Data Memory (TCDM). Each tile has access to the global L2 and to a subset of other tiles’ L1, accessing the latter via on-chip remote direct memory access (RDMA). Inter-tile and global communication is carried out through a 2-channel 32-bit [AXI4](https://github.com/pulp-platform/axi) crossbar (XBAR). External tiles and the core access the L1 through an OpenBus Interface ([OBI](https://github.com/pulp-platform/obi)) XBAR and an atomic memory operation (AMO) hardware module.

Each tile is controlled by a [cv32e40x](https://github.com/pulp-platform/cv32e40x). The system has been extended with custom instructions to program and control the iDMA, RedMulE, and FractalSync. These instructions are implemented using eXtension Interface (Xif). A dedicated dispatcher routs instructions not meant for the core to the appropriate module.

### Mesh
Replicating the MAGIA tile, we scale up to a homogeneous two-dimensional (2D) mesh of compute tiles. The NoC allows access to the global west-side L2 via a number of interfaces equal to the number of rows. The mesh features a 2D XY topology with 32-bit physical links. The conversion between the AXI4 protocol, used by the compute tiles, and the network-level protocol is performed by Network Interfaces (NIs) between each tile and the near router.

Rendez-vous among tiles are managed through the FractalSync (FS) mechanism and the dedicated network.

### Memory map
L1 size: 1 MB per tile (896kB Usable - 64kB Stack, 64kB Reserved (e.g. synchronization)).

L2 size: 1 GB.

| Region           | Range                                         | Notes                                                                      |
|------------------|-----------------------------------------------|----------------------------------------------------------------------------|
| *Reserved*       | \[0x0000_0000:0x0000_FFFF\]+*ID*\*0x0010_0000 | *ID* is the **mhartid** of the Tile                                        |
| *Stack*          | \[0x0001_0000:0x0001_FFFF\]                   | \[0x0001_0000:0x0001_FFFF\]+*ID*\*0x0010_0000, *ID* > 0, are **forbidden** |
| *L1*             | \[0x0002_0000:0x000F_FFFF\]+*ID*\*0x0010_0000 | Up to 3072 tiles                                                           |
| *L2*             | \[0xC000_0000:0xFFFF_FFFF\]                   |                                                                            |
| *Instructions*   | \[0xCC00_0000:0xCC00_8000\]                   |                                                                            |
| *Data*           | \[0xCC01_0000:0xCC04_0000\]                   |                                                                            |
| *L2 Base*        | 0xCC00_0000                                   |                                                                            |
| *Test End*       | 0xCC03_0000                                   |                                                                            |
| *String (utoa)*  | 0x0000_0000+*ID*\*0x0010_0000                 |                                                                            |
| *Print (stderr)* | 0xFFFF_0000                                   |                                                                            |
| *Print (stdio)*  | 0xFFFF_0004                                   |                                                                            |
| *Synch.*         | 0x0000_F000+*ID*\*0x0010_0000                 |                                                                            |

## 🖥️ Programming model
The systems supports the RV32IMA ISA and provies a set of **C functions** to program RedMulE, the iDMA and FractalSync. The Single Program Multiple Data (SPMD) model is used to program the system with control flow determined by the `mhartid [uint32_t]` returned by the `get_hartid();` function.

### RedMulE instructions

Performing *Y = (X x W) + Y*, where Y, X and W are *M x K*, *M x N* and *N x K* matrices respectively, can be done with the following functions:

```c
/* Configure sizes of matrices.
 * k_size [uint16_t]: Number of columns of Y and W.
 * m_size [uint16_t]: Number of rows of Y and X.
 * n_size [uint16_t]: Number of columns of X and rows of W. 
 */  
redmule_mcnfig(k_size, m_size, n_size);

/* Provide locations of matrices and start matrix multiplication.
 * y_base [uint32_t]: Source address of W.
 * w_base [uint32_t]: Source address of W.
 * x_base [uint32_t]: Source address of X.
 */
redmule_marith(y_base, w_base, x_base);
```

### iDMA instructions

Data transfers can occur concurently with GeMM operations. Furthermore, trasfters from and to the L1 can overlap. To start a transfer you must first configurre the iDMA transfer channel, setup transfer parameters (e.g. source address, destination address, length, stride 2, etc.) and then indicate transfer request.

```c
/* Configure the iDMA for input (i.e. external to L1) data transfers.
 */  
idma_conf_in();

/* Configure the iDMA for output (i.e. L1 to external) data transfers.
 */
idma_conf_out();

/* Setup for input data transfers.
 * dst_addr [uint32_t]: Destination address of the input data transfer.
 * src_addr [uint32_t]: Source address of the input data trasfer.
 * len      [uint32_t]: Length of the input data transfer.
 */
idma_set_addr_len_in(dst_addr, src_addr, len);

/* Setup for output data transfers.
 * dst_addr [uint32_t]: Destination address of the output data transfer.
 * src_addr [uint32_t]: Source address of the output data trasfer.
 * len      [uint32_t]: Length of the output data transfer.
 */
idma_set_addr_len_out(dst_addr, src_addr, len);

/* Setup for input data transfers.
 * dst_std_2 [uint32_t]: Destination stride 2 of the input data transfer.
 * src_std_2 [uint32_t]: Source stride 2 of the input data trasfer.
 * reps_2    [uint32_t]: Repetitions 2 of the input data transfer.
 */
idma_set_std2_rep2_in(dst_std_2, src_std_2, reps_2);

/* Setup for output data transfers.
 * dst_std_2 [uint32_t]: Destination stride 2 of the output data transfer.
 * src_std_2 [uint32_t]: Source stride 2 of the output data trasfer.
 * reps_2    [uint32_t]: Repetitions 2 of the output data transfer.
 */
idma_set_std2_rep2_out(dst_std_2, src_std_2, reps_2);

/* Setup for input data transfers.
 * dst_std_3 [uint32_t]: Destination stride 3 of the input data transfer.
 * src_std_3 [uint32_t]: Source stride 3 of the input data trasfer.
 * reps_3    [uint32_t]: Repetitions 3 of the input data transfer.
 */
idma_set_std3_rep3_in(dst_std_3, src_std_3, reps_3);

/* Setup for output data transfers.
 * dst_std_3 [uint32_t]: Destination stride 3 of the output data transfer.
 * src_std_3 [uint32_t]: Source stride 3 of the output data trasfer.
 * reps_3    [uint32_t]: Repetitions 3 of the output data transfer.
 */
idma_set_std3_rep3_out(dst_std_3, src_std_3, reps_3);

/* Start input data transfer.
 */  
idma_start_in();

/* Start output data transfer.
 */
idma_start_out();
```

### FractalSync instructions

Synchronizing tiles via barriers can be achieved by the instruction below. Arbitrary sets of tiles can be synchronized, with each tile participating in one barrier at a time.

```c
/* Request barrier synchronization.
 * id        [uint32_t]: ID of the synchronization barrier - specific to each node of the synchronization tree.
 * aggregate [uint32_t]: Aggregate pattern of synchronization.
 */  
fsync(id, aggregate);
```

A set of instructions for common synchronization patterns - implmented with the above `fsync()` - is also available.

```c
/*
 * Synchonize each tile with its immediate neighbor to the right, starting from leftmost tile.
 * As an example, the first row in a KxK mesh will have the following synchonization pattern:
 * 0<->1 2<->3 4 ... (K-3) (K-2)<->(K-1)
 */
fsync_h_nbr();

/*
 * Synchonize each tile with its immediate neighbor to the right, starting from second leftmost tile.
 * The edges of the mesh synchronize among themselves in a ring fashion.
 * As an example, the first row in a KxK mesh will have the following synchonization pattern:
 * 0 1<->2 3<->4 ... (K-3)<->(K-2) (K-1)
 * ^---------------------------------^
 */
fsync_h_tor_nbr();

/*
 * Synchonize each tile with its immediate neighbor to the bottom, starting from upmost tile.
 * As an example, the first column in a KxK mesh will have the following synchonization pattern:
 * 0
 * |
 * K
 * 
 * 2K
 * |
 * 3K
 * 
 * 4K
 * ...
 * (K-3)K
 *
 * (K-2)K
 * |
 * (K-1)K
 */
fsync_v_nbr();

/*
 * Synchonize each tile with its immediate neighbor to the bottom, starting from second upmost tile.
 * The edges of the mesh synchronize among themselves in a ring fashion.
 * As an example, the first column in a KxK mesh will have the following synchonization pattern:
 * 0 <
 * 
 * K <------
 * |        |
 * 2K       |
 *          |
 * 3K       |
 * |        |
 * 4K       |
 * ...      |
 * (K-3)K   |
 * |        |
 * (K-2)K   |
 *          |
 * (K-1)K <-
 */
fsync_v_tor_nbr();

/*
 * Synchonize all tiles within the same row.
 */
fsync_rows();

/*
 * Synchonize all tiles within the same column.
 */
fsync_cols();

/*
 * Synchonize all tiles in the mesh.
 */
fsync_global();
```

## 🧰 Changing number of tiles
**Supported Mesh Configurations**: `2x2`, `4x4`, `8x8`, `16x16`, `32x32`

**Scripts**: The `num_cores` parameter in the `Makefile` specifies for how many core stack traces should be generated.

**Tests**  : The `MESH_X_TILES` and `MESH_Y_TILES` parameters in `sw/utils/magia_utils.h` adapt the software stack to the specific mesh configuration.

**RTL/TB** : The `N_TILES_X` and `N_TILES_Y` parameters in `hw/mesh/magia_pkg.sv` specifie the number of tiles and allows the derivation of the appropriate data and syncrhonization networks.

## 🔏 License
MAGIA is an open-source project with a permissive license. All `software` sources are licensed under the Apache License 2.0 ([`LICENSE.APACHE`](LICENSE.APACHE)). All `hardware` sources are licensed under the Solderpad Hardware License 0.51 ([`LICENSE.SHL`](LICENSE.SHL)).

