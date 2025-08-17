
# Wishlist written by Jun

- Move configs to their own directory
- Minimal bash scripts for short local testing runs
- Create markdown guide to all modeling options, and their config input files
- Translate analysis routines to Julia (and test)
- Comment
- Write modern slurm submission scripts
- Delete unused files

---

# CURRENT

## End-to-end test including analysis

Read outputControl.c and local_experiments/*/quick_test_output.txt to understand how output looks. 
Create Analysis/analyze_single.jl julia file, create a Julia project.toml (using Julia tools?)
The julia script should read in the data from the single run, and plot occlusion probability versus location on the chain.

Find out everything in the output that can be reasonably plotted, and plot it. 
For a free chain, both Pocc and prvec0 have analytical forms to compare to. 

### All Plottable Output Variables (from outputControl.c analysis):

#### Simulation Parameters
- `nt` - Number of iterations
- `NFil` - Number of filaments  
- `irLigand`, `brLigand` - Ligand interaction parameters
- `Force`, `kdimer` - Force and dimerization parameters
- `dimerDist0`, `baseSepDistance` - Geometric parameters

#### Global Occlusion Statistics
- **`POcclude_NumSites[i]`** - Occlusion probability vs number of occupied sites *(already implemented)*
- **`PAvailable_NumSites[i]`** - Availability probability vs number of sites

#### Per-Filament Statistics
- **`N[nf]`** - Length of each filament
- **`ksStatistic[nf]`** - Kolmogorov-Smirnov convergence statistic
- **`reeBar[nf]`**, **`ree2Bar[nf]`** - Mean and second moment of end-to-end distance
- **`rMBar[nf]`**, **`rM2Bar[nf]`** - Mean and second moment of midpoint distance

#### Per-Site Data (indexed by nf, iy)
##### Core Binding/Occlusion Probabilities:
- **`POcclude[nf][iy]`** - Site occlusion probability *(key analytical comparison)*
- **`1-POcclude[nf][iy]`** - Site availability (1-occlusion)
- **`PMembraneOcclude[nf][iy]`** - Membrane occlusion probability

##### Distance Distribution Probabilities (Prvec):
- **`Prvec0[nf][iy]`** - Basic polymer vector probability *(analytical comparison available)*
- **`Prvec0_up[nf][iy]`**, **`Prvec0_halfup[nf][iy]`** - Directional variants
- **`Prvec0_rad[nf][iy]`** - Radial probability distributions

##### Radius-Specific Measurements:
- **`Prvec0_X.XXXXXX[nf][iy]`** - Probability at specific radii (0.1, 0.5, 0.75, etc.)
- **`Prvec0_up_X.XXXXXX[nf][iy]`** - Directional variants at specific radii

##### Bound State Analysis:
- **`Prvec0_bound_center[nf][iy]`**, **`Prvec0_bound_edge[nf][iy]`** - Center vs edge binding
- Multiple variants with `_up` and `_halfup` prefixes

##### Distance From Sites:
- **`rMiSiteBar[nf][iy]`**, **`rM2iSiteBar[nf][iy]`** - Distance statistics from interaction sites
- **`reeiSiteBar[nf][iy]`**, **`ree2iSiteBar[nf][iy]`** - End-to-end distances from sites

##### Base Occlusion:
- **`1-POccludeBase[nf]`** - Base availability probability

##### Inter-Filament Statistics:
- **`reeFilBar[nf][nf2]`**, **`ree2FilBar[nf][nf2]`** - Cross-filament end-to-end distances

#### Spatial Distribution Data:
- **`polymerLocationCounts[nf][iSiteCurrent][j]`** - Spatial location histograms
- **`occupied[i]`** - Site occupation patterns

#### Most Important for Analysis:
1. **`POcclude[nf][iy]`** vs position - *(has analytical form for free chain)*
2. **`Prvec0[nf][iy]`** vs position - *(has analytical form for free chain)*
3. **`reeBar[nf]`**, **`rMBar[nf]`** - Chain statistics
4. **`POcclude_NumSites[i]`** - Overall binding distribution *(already implemented)*

### Critical: NTCHECK = 200,000 iterations required for meaningful output

**Most output variables are only meaningful after NTCHECK iterations** because:

#### Variables that depend on (nt - NTCHECK):
All statistical averages are calculated using the denominator `(nt - NTCHECK)` rather than `nt`:

1. **`POcclude[nf][iy]`** - Site occlusion probability
2. **`POcclude_NumSites[i]`** - Global occlusion distribution 
3. **`PMembraneOcclude[nf][iy]`** - Membrane occlusion
4. **`reeBar[nf]`**, **`ree2Bar[nf]`** - End-to-end distance statistics
5. **`reeFilBar[nf][nf2]`**, **`ree2FilBar[nf][nf2]`** - Inter-filament distances
6. **`POccludeBase[nf]`** - Base occlusion probability
7. **All `Prvec0` variants** - Polymer vector probabilities
8. **All `Prvec_*` variants** - Distance distribution probabilities

#### Why NTCHECK matters:
- **Equilibration period**: The first 200,000 steps are considered "burn-in" to reach equilibrium
- **Binding transitions**: Ligand binding/unbinding only allowed after `nt > NTCHECK`
- **Convergence testing**: Stationarity checks begin at `2*NTCHECK = 400,000` steps

#### Impact on current testing:
Our `testing.txt` config has **NTMAX = 1,000,000**, which means:
- **Equilibration**: Steps 1-200,000 (discarded)
- **Data collection**: Steps 200,001-1,000,000 (800,000 meaningful steps)
- **Statistical validity**: ✅ Sufficient for meaningful output

#### Variables that work immediately:
- **Simulation parameters** (`nt`, `NFil`, `irLigand`, etc.)
- **Raw counts** (like `*_sum` variables in output)
- **Instantaneous measurements** before statistical averaging

**Conclusion**: For meaningful statistical output, simulations need **nt > 200,000**. Our current testing setup with 1M iterations provides 800k valid data points, which is adequate for analysis.


---


# Comprehensive Refactoring Plan (written by Claude Code)

Based on repository analysis and existing TODO items, here are comprehensive refactoring recommendations organized by priority:

## 🔥 High Priority (Foundation Fixes)

### 1. **Clean Up Version Control** (extends "delete unused files")
```bash
# Add to .gitignore immediately:
*.out
*.DS_Store
*.swp
*~
ISEED
metropolis.*
```

**Files to remove:**
- `/.DS_Store`, `/docs/.DS_Store`, `/docs/toyscripts/.DS_Store`
- `/src/PolymerCode/metropolis.out`, `/src/PolymerCode/metropolistest.out`
- `/src/PolymerCode/metropolis.ouot` (typo)
- Word document lock file: `~$merized formin code input and output.docx`

### 2. **Reorganize Configuration Files** (addresses "Move configs to their own directory")

**Proposed structure:**
```
config/
├── parameters/
│   ├── default.txt          # Rename from parameters.txt
│   ├── detailed.txt         # Rename from parameters_detailed.txt
│   └── examples/            # Parameter sets for common use cases
├── sites/
│   ├── filaments.txt
│   ├── iSites.txt
│   ├── bSites.txt
│   └── basicSites.txt
└── templates/               # Template configs for different experiments
```

### 3. **Break Down Large Files**

**`outputControl.c` (1,445 lines) → Split into:**
```
src/
├── core/
├── output/
│   ├── data_recording.c     # dataRecording() function
│   ├── statistics.c         # Statistical calculations
│   ├── file_writers.c       # Output file management
│   └── output_control.h     # Header with shared declarations
└── analysis/
    └── convergence.c        # Stationarity checking
```

## 🎯 Medium Priority (Usability & Organization)

### 4. **Create Testing Infrastructure** (addresses "Minimal bash scripts for short local testing runs")

**New directory structure:**
```
scripts/
├── test/
│   ├── quick_test.sh        # 30-second validation run
│   ├── medium_test.sh       # 5-minute parameter sweep
│   └── validation_suite.sh  # Full regression tests
├── local/
│   ├── single_run.sh        # Interactive single simulation
│   └── parameter_sweep.sh   # Local batch processing
└── examples/
    ├── basic_polymer.sh     # Simple polymer simulation
    ├── ligand_binding.sh    # Binding site example
    └── multi_filament.sh    # Multiple filament demo
```

### 5. **Standardize Source Code Organization**

**Proposed src/ structure:**
```
src/
├── core/              # Core algorithm implementation
│   ├── metropolis.c   # Main MC algorithm
│   ├── polymer.c      # Polymer geometry and moves  
│   ├── energy.c       # Energy calculations
│   └── constraints.c  # Constraint checking
├── io/                # Input/output handling
│   ├── parameters.c
│   ├── sites.c
│   └── filaments.c
├── physics/           # Physics modules
│   ├── stiffening.c
│   ├── electrostatics.c
│   └── membrane.c
├── utils/
│   ├── random.c       # twister.c
│   ├── math_utils.c
│   └── debug.c
└── main.c             # driveMetropolis.c
```

### 6. **Modernize Build System**

**Enhanced Makefile:**
```makefile
# Compiler settings
CC = gcc
CFLAGS = -O3 -Wall -Wextra -std=c99
DEBUG_FLAGS = -g -DDEBUG -fsanitize=address
LIBS = -lm

# Build targets
.PHONY: all clean debug test install

all: metropolis

debug: CFLAGS += $(DEBUG_FLAGS)
debug: metropolis

test: metropolis
	./scripts/test/quick_test.sh

install: metropolis
	mkdir -p bin/
	cp metropolis bin/
```

## 📈 Medium-Low Priority (Code Quality)

### 7. **Analysis Scripts Refactoring** (addresses "move analysis routines to Julia")

**Proposed migration strategy:**
```
analysis/
├── julia/                  # New Julia implementations
│   ├── PolymerAnalysis.jl  # Main analysis module
│   ├── plotting.jl         # Visualization functions
│   ├── statistics.jl       # Statistical analysis
│   └── examples/           # Example analysis scripts
├── matlab/                 # Keep existing MATLAB (deprecated)
│   └── [current files]
└── shared/                 # Common data/utilities
    ├── test_data/
    └── validation/
```

### 8. **Driver Scripts Consolidation** (addresses "slurm submission scripts")

**Template-based system:**
```
drivers/
├── templates/
│   ├── slurm_template.sub   # Base SLURM template
│   └── local_template.sh    # Local execution template
├── generators/
│   ├── make_slurm_job.py    # Generate SLURM scripts
│   └── make_batch.py        # Generate batch runs
├── examples/                # Pre-configured examples
└── legacy/                  # Old scripts (to be removed)
```

### 9. **Add Comprehensive Documentation** (addresses "Guide to all options")

**Documentation structure:**
```
docs/
├── user_guide/
│   ├── getting_started.md
│   ├── configuration.md     # All modeling options explained
│   ├── physics_models.md    # Physics options guide  
│   └── troubleshooting.md
├── developer/
│   ├── architecture.md
│   ├── adding_features.md
│   └── testing.md
└── examples/
    ├── tutorials/           # Step-by-step examples
    └── case_studies/        # Real-world applications
```

## 🔧 Low Priority (Polish)

### 10. **Standardize Naming Conventions**

**Consistent patterns:**
- **C files**: `snake_case.c`
- **Scripts**: `kebab-case.sh`
- **Julia files**: `PascalCase.jl` for modules, `snake_case.jl` for scripts
- **Config files**: `lowercase.txt` or `kebab-case.txt`

### 11. **Add Modern Development Tools**

**Development infrastructure:**
```
.github/
├── workflows/
│   ├── ci.yml              # Continuous integration
│   └── docs.yml            # Documentation building
└── ISSUE_TEMPLATE.md

tools/
├── format.sh               # Code formatting
├── lint.sh                 # Static analysis
└── benchmark.sh            # Performance testing
```

## 🚀 Implementation Roadmap

**Phase 1: Foundation (Week 1)**
1. Add .gitignore and clean repository
2. Move configs to new directory structure
3. Create basic test scripts

**Phase 2: Code Organization (Week 2-3)**  
4. Break down large files
5. Reorganize source code
6. Modernize build system

**Phase 3: Usability (Week 4)**
7. Create Julia analysis framework
8. Standardize driver scripts
9. Write comprehensive documentation

**Phase 4: Polish (Ongoing)**
10. Standardize naming
11. Add development tools

This refactoring plan addresses all existing TODO items while adding structure for long-term maintainability.

# Performance improvements in metropolisJoint.c

1. **Memory Access Patterns (metropolisJoint.c:279-324)**
   - Lines 287-302 and 308-323 copy entire arrays element by element. Pre-compute these arrays only once and use memcpy() for bulk copying instead of loops.

2. **Redundant Distance Calculations**
   - Lines 404-406, 479-481, 451-453: Distance calculations use expensive sqrt() unnecessarily. Compare squared distances instead and only use sqrt() when the actual distance value is needed.

3. **Loop Structure Optimizations**
   - Lines 703-718: Nested loops with early exit shortcuts could benefit from loop reordering - put most selective conditions first.
   - Lines 475-491: Multiple nested loops checking same conditions repeatedly.

4. **Expensive Math Operations (metropolisJoint.c:949-1082)**
   - The rotate() function recalculates trigonometric values. Cache sin/cos values when angles don't change.
   - Lines 952-960: RLocal matrix computation repeated - could be cached.

5. **Branch Prediction Issues**
   - Lines 244-268: Multiple switch statements and conditionals in hot loops. Consider loop unrolling or lookup tables.

6. **Memory Layout**
   - Global arrays like `r[NFILMAX][NMAX][3]` have poor cache locality. Consider structure-of-arrays vs array-of-structures reorganization.

7. **Redundant Calculations**
   - Lines 625-627, 356-358: Same ligand center calculations repeated multiple times. Cache results.

8. **Integer Division in Hot Path**
   - Line 206: `floor(N[nfPropose]*TWISTER)` could use bit operations if N values are powers of 2.
