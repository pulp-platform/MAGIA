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
make update-ips > update-ips.log mesh_dv=0
```
**3\*)** Apply flooNoC patch (`floo_noc` folder, e.g. `.bender/git/checkouts/floo_noc-d566867a3b179444/`)
```bash
git apply ../../../../floonoc.patch
```
**4)** **Build** the hardware (`redmule-mesh` folder):
```bash
make build-hw > build-hw.log mesh_dv=0
```
**5)** **Comile** the test code (`redmule-mesh` folder):
```bash
make all test=boot_test
```
**6)** **Run** test (`redmule-mesh` folder):
```bash
make run test=boot_test gui=1 mesh_dv=0
```
