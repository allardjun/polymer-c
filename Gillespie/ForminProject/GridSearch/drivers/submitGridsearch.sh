#!/bin/bash

cd /pub/kbogue1/GitHub/polymer-c/Gillespie/ForminProject/GridSearch/drivers

folder=/dfs6/pub/kbogue1/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.31.03.10.01

for d in $folder/*
do
    cd $d
    rm error_*.txt
    rm out_*.txt
    sbatch runGrid.sub
done
