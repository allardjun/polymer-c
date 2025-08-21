#!/bin/bash

#SBATCH --job-name=dimer_35.5_2025.01.07_17.16.50      ## Name of the job.
#SBATCH -A jallard_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=1    ## number of cores the job needs
#SBATCH --error=run.dimer.N%a_2025.01.07_17.16.50/error_%A_%a.txt ## error log file; %A is job id, %a is array task id. 
#SBATCH --output=run.dimer.N%a_2025.01.07_17.16.50/out_%A_%a.txt  ## output filename. 
#SBATCH --time=14-00:00:00          ## time limit for each array task
#SBATCH --mail-type=all,time_limit,TIME_LIMIT_50,TIME_LIMIT_90,ARRAY_TASKS
#SBATCH --mail-user=kbogue1@uci.edu
#SBATCH --array=1-600           ## number of array tasks. 

# echo job info on log:
echo "Job $A $a started on:   " `hostname -s`
echo "Job $A $a started on:   " `date `
pwd
cd run.dimer.N${SLURM_ARRAY_TASK_ID}_2025.01.07_17.16.50 
pwd
## ./metropolis.out parameters.txt outputfilename verbose(should be 0) NFil N iSite(should be -1) baseSepDist(0 for single, 16.667000 for dimer or double) Force(always 0 for these models) dimerForce(10 for dimer)

 ./metropolis.out parameters.txt output_dimer.N${SLURM_ARRAY_TASK_ID}.iSite-1.BSD35.5.force0.kdimer10.txt 0 2 $SLURM_ARRAY_TASK_ID -1 35.5 0 10

 echo "metropolis finished running"

 rm metropolis.out parameters.txt ISEED

 echo "deleted metropolis.out parameters.txt ISEED"


# echo job info on joblog:
echo "Job $A $a ended on:   " `hostname -s`
echo "Job $A $a ended on:   " `date `
echo " "
