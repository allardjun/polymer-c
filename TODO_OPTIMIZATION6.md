# Plan for Performance Improvement #6: Memory Layout Optimization

## Phase 1: Analysis and Design

### 1. Analyze Current Data Structure Usage Patterns
**Objective:** Understand how data is accessed throughout the codebase

**Tasks:**
- Inventory all global arrays: `r[][]`, `t[][]`, `e1[][]`, `e2[][]`, `phi[][]`, etc.
- Map access patterns in key functions (metropolisJoint, energy calculations, output)
- Identify hot paths and most frequently accessed data combinations
- Document current memory layout and estimate cache miss patterns

**Files to analyze:**
- `driveMetropolis.c` (global declarations)
- `metropolisJoint.c` (core algorithm)
- `outputControl.c` (data access for output)
- Energy calculation sections

### 2. Design New Data Structures
**Objective:** Create optimal memory layout for the identified access patterns

**Design decisions:**
```c
// Primary structure - Array of Structures (AoS)
typedef struct {
    double r[3];           // Position vector
    double t[3];           // Tangent vector  
    double e1[3];          // First normal vector
    double e2[3];          // Second normal vector
    double phi, theta, psi; // Euler angles
} segment_t;

typedef struct {
    segment_t *segments;        // Dynamic array of segments
    segment_t *segments_propose; // Proposed configuration
    segment_t base;             // Base segment
    int N;                      // Number of segments
    int capacity;               // Allocated capacity
} filament_t;

// Global state
typedef struct {
    filament_t *filaments;      // Array of filaments
    int NFil;                   // Number of filaments
    
    // Keep frequently accessed globals
    double occupied[NMAX];
    long iSite[NFILMAX][NMAX];
    // ... other globals that don't fit the segment pattern
} simulation_state_t;
```

## Phase 2: Implementation Strategy

### 3. Create Compatibility Layer
**Objective:** Enable gradual migration without breaking existing code

**Approach:**
```c
// Create accessor macros for backward compatibility
#define r(nf,i,coord) (sim_state.filaments[nf].segments[i].r[coord])
#define t(nf,i,coord) (sim_state.filaments[nf].segments[i].t[coord])
#define rPropose(nf,i,coord) (sim_state.filaments[nf].segments_propose[i].r[coord])

// Conversion functions
void convert_old_to_new_format(simulation_state_t *state);
void convert_new_to_old_format(simulation_state_t *state);

// Memory management
void allocate_simulation_state(simulation_state_t *state, int NFil, int *N);
void free_simulation_state(simulation_state_t *state);
```

### 4. Refactor Core Algorithm (metropolisJoint.c)
**Objective:** Update the Monte Carlo core for optimal memory access

**Key changes:**
- **Configuration copying (lines 279-324):** Replace element-by-element copying with structure copying
- **Rotation operations:** Work with segment pointers instead of coordinate arrays
- **Constraint checking:** Optimize distance calculations using structure access

**Example refactor:**
```c
// Before: 12 assignments per segment
for(i=1;i<iPropose;i++) {
    rPropose[nf][i][0] = r[nf][i][0];
    // ... 11 more assignments
}

// After: 1 assignment per segment  
for(i=1;i<iPropose;i++) {
    filaments[nf].segments_propose[i] = filaments[nf].segments[i];
}
// Or bulk copy:
memcpy(&filaments[nf].segments_propose[1], 
       &filaments[nf].segments[1], 
       (iPropose-1) * sizeof(segment_t));
```

### 5. Update Energy Calculation Functions
**Objective:** Optimize distance calculations and constraint checking

**Focus areas:**
- BASEBOUND constraint checking (lines 404-406)
- Bound ligand energy calculations (lines 479-481) 
- Dimer distance calculations (lines 451-453)
- Steric occlusion tests (lines 707-709)

## Phase 3: Full Migration

### 6. Refactor Initialization and I/O
**Objective:** Update file I/O and initialization for new structures

**Files to update:**
- `getFilaments.c` - Load filament configurations
- `getSites.c` - Initialize binding sites
- Parameter loading and validation

### 7. Update Output and Analysis Functions  
**Objective:** Maintain output compatibility while using new data structures

**Files to update:**
- `outputControl.c` - All output formatting
- Statistical calculation functions
- Data recording functions

## Phase 4: Validation and Optimization

### 8. Performance Testing and Validation
**Objective:** Verify correctness and measure performance gains

**Test plan:**
```bash
# Performance benchmarks
./scripts/test/performance_before.sh  # Baseline measurements
# Apply optimization
./scripts/test/performance_after.sh   # New measurements

# Correctness validation  
./scripts/test/regression_test.sh     # Ensure identical output
./scripts/test/convergence_test.sh    # Verify statistical behavior
```

**Expected improvements:**
- 2-4x speedup in configuration copying
- 10-30% reduction in cache misses
- Better compiler optimization opportunities

## Implementation Timeline

**Week 1: Analysis & Design**
- Complete data structure analysis
- Finalize new structure design
- Create compatibility layer

**Week 2: Core Refactoring**  
- Implement new data structures
- Refactor metropolisJoint.c core loops
- Update energy calculations

**Week 3: Full Migration**
- Refactor initialization and I/O
- Update all output functions
- Integration testing

**Week 4: Validation**
- Performance benchmarking
- Regression testing
- Documentation updates

## Risk Mitigation

**Backward Compatibility:**
- Keep old data access working via macros during transition
- Implement conversion functions for gradual migration

**Testing Strategy:**
- Unit tests for each refactored function
- Integration tests with known simulation results
- Performance regression detection

**Rollback Plan:**
- Maintain original code in separate branch
- Feature flags to switch between old/new implementations
- Automated performance monitoring

This structured approach ensures the memory layout optimization provides maximum performance benefit while minimizing risk of introducing bugs or breaking existing functionality.