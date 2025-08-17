# polymer-c

A Monte Carlo simulation toolkit for modeling polymer filament dynamics with ligand binding interactions using the Metropolis algorithm.

## Overview

This repository implements a comprehensive simulation framework for studying flexible polymer chains (such as actin filaments or other cytoskeletal structures) with protein binding partners. The simulation models:

- **Flexible polymer chains** in 3D space with configurable mechanical properties
- **Ligand binding/unbinding** at specific sites along the polymers  
- **External forces and constraints** (membrane association, electrostatics, stiffening)
- **Multi-filament systems** with potential dimerization interactions
- **Statistical analysis** of polymer conformations and binding probabilities

## Architecture

### Main Components

- **`driveMetropolis.c`** - Main entry point and simulation driver
- **`metropolisJoint.c`** - Core Metropolis Monte Carlo algorithm implementation
- **`getParameters.c`** - Parameter file parsing and configuration
- **`getFilaments.c`** - Polymer filament initialization
- **`getSites.c`** - Binding site setup (interaction sites, bound sites, basic sites)
- **`outputControl.c`** - Data recording and statistical analysis
- **`twister.c`** - Mersenne Twister random number generator

### Supporting Files

- **Configuration files**: Located in `config/parameters/` and `config/sites/`
- **Analysis tools**: MATLAB scripts in `Analysis/` directory
- **Scripts**: Located in `scripts/` with subdirectories for batch, HPC, local utilities, and testing

## Quick Start

### Prerequisites

- GCC compiler
- Make utility
- Standard C libraries (math.h, stdio.h, stdlib.h, etc.)

### Basic Execution

1. **Navigate to the source directory:**
   ```bash
   cd src/PolymerCode/
   ```

2. **Compile and run quick test:**
   ```bash
   make test
   ```
   This builds the executable and runs a fast validation test with output in `local_experiments/YYMMDD/`

3. **Manual compilation:**
   ```bash
   make all
   ```
   This creates the `metropolis.out` executable.

4. **Run a basic simulation:**
   ```bash
   ./metropolis.out ../../config/parameters/default.txt outputTest.txt 0 2 30 3 -1 -1 -1
   ```

### Command Line Arguments

The simulation accepts the following arguments:
```bash
./metropolis.out [params_file] [output_file] [verbose] [n_filaments] [filament_length] [isite_location] [base_separation] [force] [kdimer] [radius_type]
```

- `params_file`: Parameter configuration file (e.g., `../../config/parameters/default.txt`)
- `output_file`: Output filename for results
- `verbose`: Verbosity level (0=quiet, 1=verbose)
- `n_filaments`: Number of polymer filaments
- `filament_length`: Length of each filament (number of segments)
- `isite_location`: Location of interaction site
- `base_separation`: Distance between filament bases
- `force`: External force magnitude
- `kdimer`: Dimerization spring constant  
- `radius_type`: Radius calculation method (10=N/NBINS, 20=iy/NBINS, etc.)

### Configuration Files

Configuration files are organized in the `config/` directory:

#### Parameter Files (`config/parameters/`)
- **`default.txt`**: Production config with NTMAX=10,000,000,000 (original behavior)
- **`testing.txt`**: Testing config with NTMAX=100,000 (fast execution for validation)
- **`detailed.txt`**: Additional parameter configurations

Example parameter file format:
```
listName		outputTest
NFil			1
N			60
NTMAX			10000000000
filamentInputMethod	0
baseSepDistance		1
irLigand		2.25
brLigand		40
kBound			1000
Force			0
kdimer			0
...
```

#### Site Definition Files (`config/sites/`)
- **`filaments.txt`**: Specifies filament lengths (e.g., `60`)
- **`iSites.txt`**: Comma-separated interaction site positions (e.g., `5,17,29,41,53`)
- **`bSites.txt`**: Bound site specifications (use -1 for no bound sites)
- **`basicSites.txt`**: Basic site definitions

### Make Targets

- `make` or `make all`: Compile the simulation
- `make test` or `make quick-test`: Run comprehensive validation test
- `make run`: Compile and run with default parameters
- `make batch`: Compile and run batch processing
- `make hpc`: Prepare for HPC cluster submission
- `make parallel`: Run parallel simulations

### Testing

The repository includes a comprehensive testing framework:

- **Quick Test**: `scripts/test/quick_test.sh` provides automated validation
- **Fast execution**: Uses `testing.txt` config with NTMAX=100,000
- **Organized output**: Results saved to `local_experiments/YYMMDD[_N]/`
- **Build verification**: Automatically compiles if needed
- **Config validation**: Checks for required parameter files

## Output

The simulation generates output files containing:

- **End-to-end distances** and polymer conformations
- **Binding probabilities** at interaction sites
- **Statistical metrics** (mean, variance, distributions)
- **Convergence diagnostics** via Kolmogorov-Smirnov tests

### Analysis

MATLAB analysis scripts in `Analysis/` directory can process simulation output to generate:
- Polymer distribution plots
- Binding probability curves  
- Force-extension relationships
- Electrostatic interaction analysis

## Key Features

### NTMAX Parameterization
A major enhancement allows runtime control of iteration limits:
- **No recompilation needed**: NTMAX is now a configurable parameter read from config files
- **Flexible simulation control**: Different configs for testing vs. production
- **Backward compatibility**: Maintains all existing functionality

### Advanced Features
The simulation supports several advanced modeling options controlled by preprocessor flags in `driveMetropolis.c`:

- **`MEMBRANE`**: Membrane association interactions
- **`STIFFEN`**: Polymer stiffening mechanics
- **`ELECTRO`**: Electrostatic interactions and phosphorylation
- **`BASEBOUND`**: Immobile ligands at filament bases
- **`MULTIPLE`**: Multiple ligand binding

## HPC Usage

For high-performance computing environments:

1. **Prepare job scripts** in `scripts/hpc/` directory
2. **Modify account settings** in HPC submission scripts
3. **Submit jobs** using provided batch scripts:
   ```bash
   make hpc
   ```

## Repository Structure

```
polymer-c/
├── config/
│   ├── parameters/         # Parameter files (default.txt, testing.txt, etc.)
│   └── sites/             # Site definition files (filaments.txt, iSites.txt, etc.)
├── scripts/
│   ├── batch/             # Batch processing scripts
│   ├── hpc/               # SLURM and HPC scripts
│   ├── local/             # Utility scripts
│   ├── test/              # Testing scripts (quick_test.sh)
│   └── examples/          # Example files
├── local_experiments/      # Date-organized simulation output
├── src/PolymerCode/       # Core simulation code
├── Analysis/              # MATLAB analysis scripts
├── docs/                  # Documentation and flowcharts
└── README.md             # This file
```

## Citation

If you use this code, please cite:
- Allard Lab, UC Irvine (jun.allard@uci.edu)

## License

[License information not specified in source files]