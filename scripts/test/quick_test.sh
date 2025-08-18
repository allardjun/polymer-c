#!/bin/bash

# Quick test script for polymer-c simulation
# This runs a minimal test to verify the simulation works

set -e  # Exit on any error

# Configuration
SRC_DIR="../../src/PolymerCode"
CONFIG_DIR="../../config"
EXPERIMENTS_DIR="../../local_experiments"
EXECUTABLE="metropolis.out"

# Generate date-based output directory (YYMMDD format)
DATE_DIR=$(date +%y%m%d)
OUTPUT_DIR="$EXPERIMENTS_DIR/$DATE_DIR"

# Find next available number for today's test to avoid overwriting
COUNTER=1
while [ -d "$OUTPUT_DIR" ] && [ -f "$OUTPUT_DIR/quick_test_output.txt" ]; do
    COUNTER=$((COUNTER + 1))
    OUTPUT_DIR="$EXPERIMENTS_DIR/${DATE_DIR}_${COUNTER}"
done

# Test parameters (using testing config with lower NTMAX for faster execution)
PARAMS_FILE="$CONFIG_DIR/parameters/testing.txt"
OUTPUT_FILE="quick_test_output.txt"
LOG_FILE="quick_test_log.txt"
VERBOSE=0
N_FILAMENTS=2
FILAMENT_LENGTH=30
ISITE_LOCATION=3
BASE_SEPARATION=-1
FORCE=-1
KDIMER=-1
RADIUS_TYPE=-1

echo "=== Polymer-C Quick Test ==="
echo "Starting quick validation test..."
echo "Output will be saved to: $OUTPUT_DIR"



# Change to source directory
cd "$SRC_DIR"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if executable exists, build if not
if [ ! -f "$EXECUTABLE" ]; then
    echo "Building simulation executable..."
    make all
fi

# Verify required config files exist
if [ ! -f "$PARAMS_FILE" ]; then
    echo "Error: Parameters file not found at $PARAMS_FILE"
    exit 1
fi

# Run the quick test
echo "Running simulation with parameters:"
echo "  Parameters file: $PARAMS_FILE"
echo "  Output file: $OUTPUT_FILE"
echo "  N_filaments: $N_FILAMENTS"
echo "  Filament length: $FILAMENT_LENGTH"
echo "  ISite location: $ISITE_LOCATION"

echo "Executing: ./$EXECUTABLE $PARAMS_FILE $OUTPUT_FILE $VERBOSE $N_FILAMENTS $FILAMENT_LENGTH $ISITE_LOCATION $BASE_SEPARATION $FORCE $KDIMER"

# Start timer
START_TIME=$(date +%s)

# Run the simulation and redirect stdout to log file
./"$EXECUTABLE" "$PARAMS_FILE" "$OUTPUT_FILE" $VERBOSE $N_FILAMENTS $FILAMENT_LENGTH $ISITE_LOCATION $BASE_SEPARATION $FORCE $KDIMER > "$LOG_FILE" 2>&1

# Check if output was generated and move to experiments directory
if [ -f "$OUTPUT_FILE" ]; then
    echo "✓ Test completed successfully!"
    echo "✓ Output file generated: $OUTPUT_FILE"
    
    # Move output and log files to experiments directory
    mv "$OUTPUT_FILE" "$OUTPUT_DIR/"
    mv "$LOG_FILE" "$OUTPUT_DIR/"
    FINAL_OUTPUT="$OUTPUT_DIR/$OUTPUT_FILE"
    FINAL_LOG="$OUTPUT_DIR/$LOG_FILE"
    
    echo "✓ Output moved to: $FINAL_OUTPUT"
    echo "✓ Log moved to: $FINAL_LOG"
    echo "Output file size: $(wc -l < "$FINAL_OUTPUT") lines"
    echo "First few lines of output:"
    head -5 "$FINAL_OUTPUT"
    
    # End timer and display elapsed time
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo "✓ Simulation completed in ${ELAPSED_TIME} seconds"
    
    # Run Julia analysis
    echo "Running Julia analysis..."
    ANALYSIS_DIR="../../Analysis"
    PLOT_OUTPUT="$OUTPUT_DIR/occlusion_probability_plot.pdf"
    
    # Convert to absolute paths for Julia
    FINAL_OUTPUT_ABS=$(readlink -f "$FINAL_OUTPUT")
    PLOT_OUTPUT_ABS="$(readlink -f "$OUTPUT_DIR")/occlusion_probability_plot.pdf"
    
    cd "$ANALYSIS_DIR"
    julia --project=. analyze_single.jl "$FINAL_OUTPUT_ABS" "$PLOT_OUTPUT_ABS"
    
    if [ -f "$PLOT_OUTPUT_ABS" ]; then
        echo "✓ Analysis plot generated: $PLOT_OUTPUT_ABS"
    else
        echo "⚠ Warning: Analysis plot not generated"
    fi
else
    echo "✗ Test failed: No output file generated"
    exit 1
fi

echo "=== Quick Test Complete ==="