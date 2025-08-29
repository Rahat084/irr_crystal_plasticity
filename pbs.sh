#! /bin bash 

# PBS -N irr_crystal_plasticity
# PBS -M mdshasan@ucla.edu
# PBS -l walltime=168:00:00
# PBS -l select=4:ncpus=112:mpiprocs=112
# PBS -P ncrc
# PBS -q general
# PBS -j oe

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
module load use.moose moose-dev-openmpi/2025.08.19
mpiexec -n 112 moose-dev-exec /scratch/hasamds2/projects/irr_crystal_plasticity/irr_crystal_plasticity-opt -i irrFCC_single.i
