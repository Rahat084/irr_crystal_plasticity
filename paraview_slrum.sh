#!/bin/bash
# Submit this script with: sbatch thefilename
#SBATCH --time=6:00:00 # walltime
#SBATCH --ntasks-per-node=112 # number of processor cores (i.e. tasks)
#SBATCH --nodes=1 # number of nodes
#SBATCH --wckey=ncrc # Project Code
#SBATCH --partition=general
#SBATCH --job-name="paraview_postp"
#SBATCH --mail-user=mdshasan@ucla.edu # email address
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=job_%j.out
# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
module load paraview/5.13.0-MPI-Linux-Python3.10 openmpi/4.1.5_intel
mpiexec -n 112 pvserver --client-host=localhost --server-port=8000
