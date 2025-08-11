
# Wishlist written by Jun

- Move configs to their own directory
- Minimal bash scripts for short local testing runs
- Create markdown guide to all modeling options, and their config input files
- Translate analysis routines to Julia (and test)
- Comment
- Write modern slurm submission scripts
- Delete unused files

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
