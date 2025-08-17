#### submit_job.sh START ####
#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o testlog.$JOB_ID
#$ -e testlog.${JOB_ID}.error
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=24:00:00,h_data=1G
## Modify the parallel environment
## and the number of cores as needed:
#$ -pe shared 1
# Email address to notify
#$ -M katharinebogue@gmail.com
# Notify when
#$ -m bea

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
pwd

# load the job environment:
. /u/local/Modules/default/init/modules.sh
## Edit the line below as needed:
module load gcc/4.9.3

## substitute the command to run your code
## in the two lines below:


## ./metropolis.out parameters.txt outputfilename verbose(should be 0) NFil N iSite(should be -1) baseSepDist(0 for single, 16.667000 for dimer or double) Force(always 0 for these models) dimerForce(10 for dimer)

  ./metropolis.out parameters.txt test_output_$i.txt 0 1 $i -1 0 0 0 &>/dev/null


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
#### submit_job.sh STOP ####
