#### submit_job.sh START ####
#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
## Edit the line below as needed:
#$ -l highp,h_rt=300:00:00,h_data=3G
## Modify the parallel environment
## and the number of cores as needed:
## -pe shared 24
## Email address to notify
#$ -M $USER@mail
# Notify when
#$ -m bea

echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
#. /u/local/Modules/default/init/modules.sh
#source /u/home/m/mdshasan/.bashrc
source /u/home/m/mdshasan/miniforge3/etc/profile.d/conda.sh
conda activate moose
## Edit the line below as needed:
#module load gcc/4.9.3

## substitute the command to run your code
## in the two lines below:
mpiexec /u/home/m/mdshasan/projects/irr_crystal_plasticity/irr_crystal_plasticity-opt -i fccSCSlipTwin.i

## echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
#### submit_job.sh STOP ####
