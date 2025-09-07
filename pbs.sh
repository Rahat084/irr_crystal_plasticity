#!/bin bash 

# PBS -N irr_crystal_plasticity
# PBS -M mdshasan@ucla.edu
# PBS -l select=1
# PBS -l place=excl
# PBS -l walltime=2:00:00
# PBS -P ncrc
# PBS -q debug
# PBS -j oe

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
module load use.moose moose-dev-openmpi/2025.08.19
mpiexec -n 112 moose-dev-exec /scratch/hasamds2/projects/irr_crystal_plasticity/irr_crystal_plasticity-opt -i irrFCC_single.i
