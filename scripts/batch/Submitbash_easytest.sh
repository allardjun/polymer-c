#!/bin/bash
#./metropolis.out parameters.txt outputfile verboseTF NFil N iSite baseSepDist Force dimerForce

cd /pub/kbogue1/GitHub/polymer-c/drivers

d=$(date +%Y.%d.%m.%M)
#d=$(date +%Y.%d).${baseval}
#d='2023.14.01'

# polymer number of segments to sweep over
NumSeg=35

# output directory
output_dir=/pub/kbogue1/GitHub/Data/polymer-c_data/testing_removal

# dimerization state
what='double' #'single' 'double'

mkdir $output_dir/${what}.${d}
# type of radius run

radtype=20

occupied_opts=("2_10_26" "-1")

NFil=2       #2
#NumSeg=${i} #single=300; double=200; dimer=122
if [ ${NFil} -eq 2 ]; then
    baseSepDist=35.5
    #baseSepDist=${baseval}
else
    baseSepDist=0
fi
#dimerForce=10 #0
dimerForce=0
iSite='-1'
force=0
#

cd $output_dir
#mkdir ${what}.${d}
mkdir ${what}.${d}
cd -

for i in $(seq 0 0); do
    firstocc=${occupied_opts[$i]}
    for j in $(seq 1 1); do
        secocc=${occupied_opts[$j]}
        occupiedtype=${firstocc}__${secocc}

        cd /pub/kbogue1/GitHub/polymer-c/drivers

            #echo submit.${what}.N${NumSeg}.${d}.sh

            cp testslurm.sub submit.${what}.N${NumSeg}.${d}.sub
            sed -i "23c\ ./metropolis.out parameters.txt output_${what}.N${NumSeg}.iSite${iSite}.BSD${baseSepDist}.force${force}.kdimer${dimerForce}.radtype${radtype}.occupied${occupiedtype}.txt 0 ${NFil} ${NumSeg} ${iSite} ${baseSepDist} ${force} ${dimerForce} ${radtype}
        " "submit.${what}.N${NumSeg}.${d}.sub"
            sed -i "3c\#SBATCH --job-name=${what}_${NumSeg}      ## Name of the job.
        " "submit.${what}.N${NumSeg}.${d}.sub"
            sed -i "11c\#SBATCH --time=1-00:00:00          ## time limit for each array task
        " "submit.${what}.N${NumSeg}.${d}.sub"

        cd /pub/kbogue1/GitHub/polymer-c/src/PolymerCode
        sed -i "1c\ ${firstocc//_/ }
        " "bSites.txt"
        sed -i "2c\ ${secocc//_/ }
        " "bSites.txt"

        cd /pub/kbogue1/GitHub/polymer-c/drivers


        mkdir $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}.occupied${occupiedtype}
        cp ../src/PolymerCode/metropolis.out ../src/PolymerCode/parameters.txt ../src/PolymerCode/ISEED ../src/PolymerCode/bSites.txt $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}.occupied${occupiedtype}
        cp submit.${what}.N${NumSeg}.${d}.sub $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}.occupied${occupiedtype}
        rm submit.${what}.N${NumSeg}.${d}.sub

        cd $output_dir/${what}.${d}/run.${what}.N${NumSeg}_${d}.occupied${occupiedtype}
        sbatch submit.${what}.N${NumSeg}.${d}.sub
    done
done
