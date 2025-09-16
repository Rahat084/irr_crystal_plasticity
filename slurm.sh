#!/bin/bash
# Submit this script with: sbatch thefilename
#SBATCH --time=6:00:00 # walltime
#SBATCH --ntasks-per-node=112 # number of processor cores (i.e. tasks)
#SBATCH --nodes=1 # number of nodes
#SBATCH --wckey=ncrc # Project Code
#SBATCH --partition=general
#SBATCH --job-name="irr_crystal_plasticity_debug"
#SBATCH --mail-user=mdshasan@ucla.edu # email address
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=job_%j.out
# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
module load use.moose moose-dev-openmpi/2025.08.19
mpiexec -n 112 moose-dev-exec /scratch/hasamds2/projects/irr_crystal_plasticity/irr_crystal_plasticity-opt -i irrFCC_poly_debug.i
