#!/bin/bash
# Batch Script
# July 23, 2018
# Sweep through N values for various formin dimerization states
# Summer 2019
# team real formins: Joanna, Poorvi, Katie, Allard
# Set variables for each run
SWEEPNAME=single_10_12

# Loop through single variable
for N in $(seq 1 25 301)
do
    # Run executable
    ./metropolis.out parameters.txt $SWEEPNAME.txt 0 1 $N -1 baseSepDist Force dimerForce
    date
done

