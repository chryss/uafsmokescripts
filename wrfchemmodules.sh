#!/bin/bash -l

module purge
module load toolchain/pic-intel/2016b
module load data/netCDF-Fortran/4.4.4-pic-intel-2016b
module load data/netCDF-C++4/4.3.0-pic-intel-2016b
module load vis/JasPer/1.900.1-pic-intel-2016b
module load lib/libpng/1.6.24-pic-intel-2016b
module load slurm
module list
