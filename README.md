# RedMulE Mesh

This repo contains RedMulE Mesh (WIP), a network of [RedMulE](https://github.com/pulp-platform/redmule) tiles designed to extend the latter to support matrices of sizes that vary by orders of magnitude, and also sparse matrix multiplications.

RedMulE Mesh is developed as part of the [PULP](https://pulp-platform.org/) project, a joint effort between ETH Zurich and the University of Bologna.


## Getting Started
**1)** Setup the environment (`redmule-mesh` folder):
```bash
source setup_env.sh
```
**2)** Download Bender (`redmule-mesh` folder):
```bash
make bender
```
**3)** Clone the dependencies and **generate** the compilation script (`redmule-mesh` folder):
```bash
make update-ips > update-ips.log mesh_dv=1
```
**3\*)** Apply FlooNoC patch (`redmule-mesh` folder):
```bash
make floonoc-patch
```
**4)** **Build** the hardware (`redmule-mesh` folder):
```bash
make build-hw > build-hw.log mesh_dv=1 fast_sim=0
```
**5)** **Comile** the test code (`redmule-mesh` folder):
```bash
make all test=mesh_test
```
**6)** **Run** test (`redmule-mesh` folder):
```bash
make run test=mesh_test gui=1 mesh_dv=1
```

## Changing number of Tiles
**Scripts**: `num_cores` parameter in the `Makefile`

**Tests**  : `MESH_X_TILES` and `MESH_Y_TILES` parameters in `redmule_mesh_utils.h`

**RTL/TB** : `N_TILES_X` and `N_TILES_Y` parameters in `redmule_mesh_pkg.sv`
