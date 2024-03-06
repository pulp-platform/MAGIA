# RedMulE Mesh

This repo contains RedMulE Mesh (WIP), a network of [RedMulE](https://github.com/pulp-platform/redmule) tiles designed to extend the latter to support matrices of sizes that vary by orders of magnitude, and also sparse matrix multiplications.

RedMulE Mesh is developed as part of the [PULP](https://pulp-platform.org/) project, a joint effort between ETH Zurich and the University of Bologna.


## Getting Started
**1)** Setup the environment (`redmule-mesh` folder):
```
source setup_env.sh
```
**2)** Download Bender (`redmule-mesh` folder):
```
make bender
```
**3)** Clone the dependencies and generate the compilation script (`redmule-mesh` folder):
```
make update-ips > update-ips.log
```
**4)** Build the hardware (`redmule-mesh` folder):
```
make build-hw > build-hw.log
```
**5)** Comile the test code (`redmule-mesh` folder):
```
make all
```
**6)** Run test (`redmule-mesh` folder):
```
make run gui=1
```
