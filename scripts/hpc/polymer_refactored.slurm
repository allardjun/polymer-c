#!/bin/bash

#SBATCH --job-name=polymer_refactored      ## Name of the job.
#SBATCH -p free          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=1    ## number of cores the job needs
#SBATCH --error=error_%A_%a.txt ## error log file; %A is job id, %a is array task id. 
#SBATCH --output=out_%A_%a.txt  ## output filename. 
#SBATCH --time=01:00:00          ## time limit for each array task
#SBATCH --array=274          ## number of array tasks. 

# Echo job info on log
echo "Job $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID started on: " `hostname -s`
echo "Job $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID started on: " `date`
pwd

# Configuration (similar to quick_test.sh but adapted for SLURM)
CONFIG_DIR="config"
EXECUTABLE="metropolis.out"
PARAMS_FILE="$CONFIG_DIR/parameters/testing.txt"
OUTPUT_FILE="polymer_output_${SLURM_ARRAY_TASK_ID}.txt"
LOG_FILE="polymer_log_${SLURM_ARRAY_TASK_ID}.txt"

# Test parameters (using testing config)
VERBOSE=0
N_FILAMENTS=2
FILAMENT_LENGTH=${SLURM_ARRAY_TASK_ID}
ISITE_LOCATION=3
BASE_SEPARATION=-1
FORCE=-1
KDIMER=-1
RADIUS_TYPE=-1

echo "Running simulation with parameters:"
echo "  Parameters file: $PARAMS_FILE"
echo "  Output file: $OUTPUT_FILE"
echo "  N_filaments: $N_FILAMENTS"
echo "  Filament length: $FILAMENT_LENGTH"
echo "  ISite location: $ISITE_LOCATION"
echo "  Array task ID: $SLURM_ARRAY_TASK_ID"

# Verify required files exist
if [ ! -f "$EXECUTABLE" ]; then
    echo "Error: Executable not found: $EXECUTABLE"
    exit 1
fi

if [ ! -f "$PARAMS_FILE" ]; then
    echo "Error: Parameters file not found: $PARAMS_FILE"
    exit 1
fi

# Start timer
START_TIME=$(date +%s)

# Run the simulation
echo "Executing: ./$EXECUTABLE $PARAMS_FILE $OUTPUT_FILE $VERBOSE $N_FILAMENTS $FILAMENT_LENGTH $ISITE_LOCATION $BASE_SEPARATION $FORCE $KDIMER"
./"$EXECUTABLE" "$PARAMS_FILE" "$OUTPUT_FILE" $VERBOSE $N_FILAMENTS $FILAMENT_LENGTH $ISITE_LOCATION $BASE_SEPARATION $FORCE $KDIMER > "$LOG_FILE" 2>&1

# Check if output was generated
if [ -f "$OUTPUT_FILE" ]; then
    echo "Simulation completed successfully!"
    echo "Output file generated: $OUTPUT_FILE"
    echo "Log file generated: $LOG_FILE"
    echo "Output file size: $(wc -l < "$OUTPUT_FILE") lines"
    
    # End timer and display elapsed time
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "Simulation completed in ${ELAPSED_TIME} seconds"
else
    echo "Simulation failed: No output file generated"
    exit 1
fi

# Clean up copied files (similar to original SLURM script)
rm "$EXECUTABLE" "$PARAMS_FILE" ISEED

echo "Job $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID ended on: " `hostname -s`
echo "Job $SLURM_JOB_ID $SLURM_ARRAY_TASK_ID ended on: " `date`
echo " "
