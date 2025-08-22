#!/bin/bash

# Submission script for refactored polymer-c SLURM jobs
# This script copies executables to local_experiments and submits SLURM jobs

set -e  # Exit on any error

# Configuration
SRC_DIR="../../src/PolymerCode"
CONFIG_DIR="../../config"
EXPERIMENTS_DIR="../../local_experiments"
EXECUTABLE="metropolis.out"
SLURM_SCRIPT="polymer_refactored.slurm"

# Generate date-based directory (YYMMDD format)
DATE_DIR=$(date +%y%m%d)
BASE_OUTPUT_DIR="$EXPERIMENTS_DIR/$DATE_DIR"

# Find next available number for today's runs to avoid overwriting
COUNTER=1
while [ -d "$BASE_OUTPUT_DIR" ]; do
    COUNTER=$((COUNTER + 1))
    BASE_OUTPUT_DIR="$EXPERIMENTS_DIR/${DATE_DIR}_${COUNTER}"
done

# Create the base output directory
mkdir -p "$BASE_OUTPUT_DIR"

echo "=== Polymer-C SLURM Submission ==="
echo "Setting up SLURM jobs in: $BASE_OUTPUT_DIR"

# Check if source files exist
if [ ! -f "$SRC_DIR/$EXECUTABLE" ]; then
    echo "Error: Executable not found at $SRC_DIR/$EXECUTABLE"
    echo "Please build the executable first by running 'make all' in $SRC_DIR"
    exit 1
fi

if [ ! -f "$CONFIG_DIR/parameters/testing.txt" ]; then
    echo "Error: Parameters file not found at $CONFIG_DIR/parameters/testing.txt"
    exit 1
fi

# Get array size from SLURM script
ARRAY_SIZE=$(grep "#SBATCH --array=" "$SLURM_SCRIPT" | sed 's/.*--array=1-\([0-9]*\).*/\1/')
echo "Setting up $ARRAY_SIZE job directories..."

# Create individual job directories and copy files
for i in $(seq 1 $ARRAY_SIZE); do
    JOB_DIR="$BASE_OUTPUT_DIR/job_${i}"
    mkdir -p "$JOB_DIR"
    
    # Copy executable and required files to job directory
    cp "$SRC_DIR/$EXECUTABLE" "$JOB_DIR/"
    cp "$SRC_DIR/ISEED" "$JOB_DIR/"
    
    # Create a local copy of the parameters file
    mkdir -p "$JOB_DIR/config/parameters"
    cp "$CONFIG_DIR/parameters/testing.txt" "$JOB_DIR/config/parameters/"
    
    # Copy the SLURM script to the job directory
    cp "$SLURM_SCRIPT" "$JOB_DIR/"
done

echo "Files copied to $ARRAY_SIZE job directories"

# Change to the base output directory to submit jobs
cd "$BASE_OUTPUT_DIR"

# Submit the SLURM job array
echo "Submitting SLURM job array..."
JOB_ID=$(sbatch --chdir="job_\$SLURM_ARRAY_TASK_ID" "$SLURM_SCRIPT" | grep -o '[0-9]*')

if [ -n "$JOB_ID" ]; then
    echo "SLURM job array submitted successfully!"
    echo "Job ID: $JOB_ID"
    echo "Job directories: $BASE_OUTPUT_DIR/job_1 to $BASE_OUTPUT_DIR/job_$ARRAY_SIZE"
    echo "Monitor with: squeue -j $JOB_ID"
    echo "Cancel with: scancel $JOB_ID"
else
    echo "Error: Failed to submit SLURM job"
    exit 1
fi

echo "=== Submission Complete ==="