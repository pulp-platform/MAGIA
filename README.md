# MAGIA

This repo contains MAGIA (**M**esh **A**rchitecture for **G**enerative **I**ntelligence **A**cceleration), a large-scale accelerator designed for GenAI. MAGIA is a network of Tiles that have at their heart [RedMulE](https://github.com/pulp-platform/redmule) for GeMM acceleration, [iDMA](https://github.com/pulp-platform/iDMA) for fast and efficient data movement and an L1 SPM. Tiles are connected to a mesh NoC. MAGIA is designed to support matrices of sizes that vary by orders of magnitude, and also sparse matrix multiplication. 

MAGIA is developed as part of the [PULP](https://pulp-platform.org/) project, a joint effort between ETH Zurich and the University of Bologna.


## Getting Started

You can specify the following optional parameters:
-`mesh_dv`: {**0**, **1**} (**Default**: 1). 0 simulation of a single Tile; 1 simulation of the entire Mesh.
-`fast_sim`: {**0**, **1**} (**Default**: 0). 0 faster simulation that does not track signals; 1 simulation that tracks signals (for debugging).
-`gui`: {**0**, **1**} (**Default**: 0). 0 simulation without GUI; 1 simulation with GUI.
**1)** Setup the environment (`magia` folder):
```bash
source setup_env.sh
```
**2)** Download Bender (`magia` folder):
```bash
make bender
```
**3)** Clone the dependencies and **generate** the compilation script (`magia` folder):
```bash
make update-ips > update-ips.log <mesh_dv>
```
**3\*)** Apply FlooNoC patch (`magia` folder):
```bash
make floonoc-patch
```
**4)** **Build** the hardware (`magia` folder):
```bash
make build-hw > build-hw.log <mesh_dv> <fast_sim>
```
**5)** **Comile** the test code (`magia` folder):
```bash
make all test=<test_name>
```
**6)** **Run** test (`magia` folder):
```bash
make run test=<test_name> <gui> <mesh_dv>
```

**Example**:
```bash
source setup_env.sh
make bender
make update-ips > update-ips.log
make build-hw > build-hw.log fast_sim=1
make all test=mesh_test
make run test=mesh_test
```

## Changing number of Tiles
**Scripts**: `num_cores` parameter in the `Makefile`

**Tests**  : `MESH_X_TILES` and `MESH_Y_TILES` parameters in `magia_utils.h`

**RTL/TB** : `N_TILES_X` and `N_TILES_Y` parameters in `magia_pkg.sv`

**Supported Mesh Configurations**: `2x2`, `4x4`, `8x8`, `16x16`, `32x32`
