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

# Parse array specification from SLURM script
ARRAY_SPEC=$(grep "#SBATCH --array=" "$SLURM_SCRIPT" | sed 's/.*--array=\([0-9,-]*\).*/\1/' | tr -d ' ')

# Debug: show what we parsed
echo "Parsed array spec: '$ARRAY_SPEC'"

# Determine array task IDs
if [[ "$ARRAY_SPEC" =~ ^[0-9]+-[0-9]+$ ]]; then
    # Range format like "1-100"
    START=$(echo "$ARRAY_SPEC" | cut -d'-' -f1)
    END=$(echo "$ARRAY_SPEC" | cut -d'-' -f2)
    TASK_IDS=$(seq $START $END)
elif [[ "$ARRAY_SPEC" =~ ^[0-9]+$ ]]; then
    # Single number like "274"
    TASK_IDS="$ARRAY_SPEC"
else
    # Comma-separated or other format like "1,5,274"
    TASK_IDS=$(echo "$ARRAY_SPEC" | tr ',' ' ')
fi

# Filter out empty task IDs
TASK_IDS=$(echo $TASK_IDS | tr ' ' '\n' | grep -v '^$' | tr '\n' ' ')

echo "Setting up job directories for task IDs: $TASK_IDS"

# Create individual job directories and copy files
for i in $TASK_IDS; do
    JOB_DIR="$BASE_OUTPUT_DIR/job_${i}"
    mkdir -p "$JOB_DIR"
    
    # Copy executable and required files to job directory
    cp "$SRC_DIR/$EXECUTABLE" "$JOB_DIR/"
    cp "$SRC_DIR/ISEED" "$JOB_DIR/"
    
    # Create a local copy of the parameters file
    mkdir -p "$JOB_DIR/config/parameters"
    cp "$CONFIG_DIR/parameters/testing.txt" "$JOB_DIR/config/parameters/"
    ls "$JOB_DIR/config/parameters/"

    # Copy the SLURM script to the job directory
    cp "$SLURM_SCRIPT" "$JOB_DIR/"
done

echo "Files copied to job directories"

# Submit the SLURM job array
echo "Submitting SLURM job array..."
# Use the first task ID to locate and submit the SLURM script
FIRST_TASK_ID=$(echo $TASK_IDS | awk '{print $1}')
cd "$BASE_OUTPUT_DIR/job_${FIRST_TASK_ID}"
JOB_ID=$(sbatch "$SLURM_SCRIPT" | grep -o '[0-9]*')

if [ -n "$JOB_ID" ]; then
    echo "SLURM job array submitted successfully!"
    echo "Job ID: $JOB_ID"
    echo "Job directories created for task IDs: $TASK_IDS"
    echo "Monitor with: squeue -j $JOB_ID"
    echo "Cancel with: scancel $JOB_ID"
else
    echo "Error: Failed to submit SLURM job"
    exit 1
fi

echo "=== Submission Complete ==="
