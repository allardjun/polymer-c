#!/bin/bash

cd /pub/kbogue1/GitHub/polymer-c/Gillespie/ForminProject/ForminProject/drivers

d=$(date +%Y.%d.%m.%H.%M)

# output directory
output_dir=/dfs6/pub/kbogue1/GitHub/Data/Gillespie_data/HPC3outputs

polymercdir=/dfs6/pub/kbogue1/GitHub//Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20

step=100

mkdir $output_dir/GridSearch.${d}

ncombs=$(cut -d' ' -f1 <(wc -l combinations.txt))

i=1

cp combinations.txt $output_dir/GridSearch.${d}/combinations.txt

while [[ $i -lt $ncombs ]];
do 
    istart=$i
    iend=$((i + step)) 
    mkdir $output_dir/GridSearch.${d}/i_${istart}_${iend}
    cp runGrid.sub $output_dir/GridSearch.${d}/i_${istart}_${iend}/runGrid.sub
    sed -i "23c\ julia --project=/pub/kbogue1/GitHub/polymer-c/Gillespie/ForminProject/ForminProject /pub/kbogue1/GitHub/polymer-c/Gillespie/ForminProject/ForminProject/drivers/runGridSearch.jl $output_dir/GridSearch.${d}/combinations.txt $istart $iend $polymercdir $output_dir/GridSearch.${d}/i_${istart}_${iend}
        " "$output_dir/GridSearch.${d}/i_${istart}_${iend}/runGrid.sub"
    
    sed -i "3c\#SBATCH --job-name=GridSearch_${istart}_${iend}     ## Name of the job.
        " "$output_dir/GridSearch.${d}/i_${istart}_${iend}/runGrid.sub"
    
    cd $output_dir/GridSearch.${d}/i_${istart}_${iend}
    sbatch runGrid.sub

    i=$((i + step + 1)) 
done

