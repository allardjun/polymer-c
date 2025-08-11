#!/bin/bash

cd /pub/kbogue1/GitHub/polymer-c/Gillespie/ForminProject/ForminProject/drivers

folder=/dfs6/pub/kbogue1/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.18.02.15.15

for d in $folder/*
do
    cd $d
    rm error_*.txt
    rm out_*.txt
    sbatch runGrid.sub
done
