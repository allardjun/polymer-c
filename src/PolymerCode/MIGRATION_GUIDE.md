# Data Structure Migration Guide

This guide explains how to migrate from the old array-based data structures to the new optimized structures for Performance Improvement #6.

## Phase 1: Setup (Completed)

### New Files Added:
- `polymer_data_structures.h` - New data structure definitions
- `polymer_data_structures.c` - Implementation of memory management
- `test_data_structures.c` - Test/demo program
- `MIGRATION_GUIDE.md` - This file

### Key Changes:
1. **segment_t structure**: Consolidates r[3], t[3], e1[3], e2[3], phi, theta, psi
2. **filament_t structure**: Contains arrays of segments plus filament-specific data
3. **simulation_state_t**: Global state container
4. **Compatibility layer**: Macros for gradual migration

## How to Test the New System

### Compile and run the test:
```bash
cd src/PolymerCode
gcc -o test_data_structures test_data_structures.c polymer_data_structures.c -lm
./test_data_structures
```

### Expected Output:
- Memory allocation test
- Data access demonstration  
- Bulk copy operations (Performance Improvement #1)
- Distance calculations (Performance Improvement #2)
- Ligand center calculations (Performance Improvement #7)
- Memory usage comparison

## Migration Strategy

### Phase 2: Gradual Migration (Next Steps)

1. **Add include to existing files:**
```c
#define USE_COMPATIBILITY_LAYER
#include "polymer_data_structures.h"
```

2. **Replace global array declarations with macros:**
```c
// Old:
extern double r[NFILMAX][NMAX][3];

// New (with compatibility):
// Use r(nf,i,coord) macro instead of r[nf][i][coord]
```

3. **Update core algorithm functions:**
- Replace element-by-element copying with `copy_segment_range()`
- Use `segment_distance_squared()` instead of manual distance calculation
- Use `calculate_ligand_center()` for ligand positioning

### Phase 3: Full Migration

1. **Remove old global arrays**
2. **Remove compatibility macros**  
3. **Use direct structure access**
4. **Optimize remaining performance bottlenecks**

## Performance Benefits Expected

Based on the data structure analysis:

1. **Memory Access (Improvement #1)**: 4x faster bulk copying
2. **Cache Efficiency**: 10-30% reduction in cache misses
3. **Memory Usage**: Reduced by eliminating unused NMAX allocations
4. **Code Clarity**: Type-safe operations on segment data

## Validation Plan

### Before Migration:
```bash
# Run baseline performance test
time ./metropolis config/parameters/testing.txt baseline_output.txt
```

### After Migration:
```bash
# Run optimized performance test  
time ./metropolis config/parameters/testing.txt optimized_output.txt

# Verify identical results
diff baseline_output.txt optimized_output.txt
```

## Rollback Plan

If issues arise:
1. Remove `#define USE_COMPATIBILITY_LAYER`
2. Revert to original global array declarations
3. The old code will work unchanged

## Next Steps for Implementation

1. **Test the new data structures** (complete steps 1-3 first)
2. **Add compatibility layer to driveMetropolis.c**
3. **Migrate metropolisJoint.c core loops**
4. **Update energy calculation functions**
5. **Performance validation**

The new data structures are designed to be drop-in replacements that provide immediate performance benefits while maintaining code compatibility.

## Automated Array Conversion Strategy

### Why sed Commands Are Necessary

The codebase contains hundreds of array accesses like `r[nf][i][coord]` that need to be converted to `r(nf,i,coord)` to use the compatibility macros. Manual conversion would be error-prone and time-consuming.

### Lessons Learned from Implementation

**Critical Discovery:**
The generic regex patterns like `s/\br\[\([^]]*\)\]\[\([^]]*\)\]\[\([^]]*\)\]/r(\1,\2,\3)/g` **DO NOT WORK** because they don't match the actual code patterns.

**What Actually Works:**
1. **Specific literal patterns**: Need to match exact variable names like `r[nf][i][0]`, not generic `r[anything][anything][anything]`
2. **Test-driven conversion**: Compile after each change and fix the exact error patterns reported
3. **Progressive approach**: Address compiler errors in order, converting exactly what's needed

**Working Strategy:**
- Use **specific literal patterns** for each error type
- Test compilation after each sed command  
- Follow compiler error progression systematically
- Handle function call arguments specially (need `&` for address-of operators)

### Arrays to Convert (Have Compatibility Macros)

**ACTUAL Working Commands (Specific Patterns):**
```bash
# outputControl.c - Convert specific coordinate patterns  
sed -i '' 's/r\[nf\]\[Ncurrent-1\]\[0\]/r(nf,Ncurrent-1,0)/g; s/r\[nf\]\[Ncurrent-1\]\[1\]/r(nf,Ncurrent-1,1)/g; s/r\[nf\]\[Ncurrent-1\]\[2\]/r(nf,Ncurrent-1,2)/g'
sed -i '' 's/r\[nf2\]\[Ncurrent-1\]\[0\]/r(nf2,Ncurrent-1,0)/g; s/r\[nf2\]\[Ncurrent-1\]\[1\]/r(nf2,Ncurrent-1,1)/g; s/r\[nf2\]\[Ncurrent-1\]\[2\]/r(nf2,Ncurrent-1,2)/g'
sed -i '' 's/r\[nf\]\[iSiteCurrent\]\[0\]/r(nf,iSiteCurrent,0)/g; s/r\[nf\]\[iSiteCurrent\]\[1\]/r(nf,iSiteCurrent,1)/g; s/r\[nf\]\[iSiteCurrent\]\[2\]/r(nf,iSiteCurrent,2)/g'
sed -i '' 's/r\[nf\]\[i\]\[0\]/r(nf,i,0)/g; s/r\[nf\]\[i\]\[1\]/r(nf,i,1)/g; s/r\[nf\]\[i\]\[2\]/r(nf,i,2)/g'

# metropolisJoint.c - Convert basic patterns first
sed -i '' 's/phi\[nf\]\[i\]/phi(nf,i)/g; s/theta\[nf\]\[i\]/theta(nf,i)/g; s/psi\[nf\]\[i\]/psi(nf,i)/g'
sed -i '' 's/r\[nf\]\[bSiteCurrent\]\[0\]/r(nf,bSiteCurrent,0)/g; s/r\[nf\]\[bSiteCurrent\]\[1\]/r(nf,bSiteCurrent,1)/g; s/r\[nf\]\[bSiteCurrent\]\[2\]/r(nf,bSiteCurrent,2)/g'
sed -i '' 's/e1\[nf\]\[bSiteCurrent\]\[0\]/e1(nf,bSiteCurrent,0)/g; s/e1\[nf\]\[bSiteCurrent\]\[1\]/e1(nf,bSiteCurrent,1)/g; s/e1\[nf\]\[bSiteCurrent\]\[2\]/e1(nf,bSiteCurrent,2)/g'

# Continue with compiler-error-driven pattern-by-pattern conversion...
```

**Key Insight:** Generic regex doesn't work because variables have specific names (`nf`, `i`, `nf2`, `iSiteCurrent`, etc.) rather than arbitrary expressions.

**2D Arrays:**
```bash
# Angle arrays
sed -i '' 's/\bphi\[\([^]]*\)\]\[\([^]]*\)\]/phi(\1,\2)/g'
sed -i '' 's/\btheta\[\([^]]*\)\]\[\([^]]*\)\]/theta(\1,\2)/g'
sed -i '' 's/\bpsi\[\([^]]*\)\]\[\([^]]*\)\]/psi(\1,\2)/g'
sed -i '' 's/\bphiPropose\[\([^]]*\)\]\[\([^]]*\)\]/phiPropose(\1,\2)/g'
sed -i '' 's/\bthetaPropose\[\([^]]*\)\]\[\([^]]*\)\]/thetaPropose(\1,\2)/g'
sed -i '' 's/\bpsiPropose\[\([^]]*\)\]\[\([^]]*\)\]/psiPropose(\1,\2)/g'

# Site arrays
sed -i '' 's/\biSite\[\([^]]*\)\]\[\([^]]*\)\]/iSite(\1,\2)/g'
sed -i '' 's/\bbSite\[\([^]]*\)\]\[\([^]]*\)\]/bSite(\1,\2)/g'

# Occlusion arrays  
sed -i '' 's/\bstericOcclusion\[\([^]]*\)\]\[\([^]]*\)\]/stericOcclusion(\1,\2)/g'
sed -i '' 's/\bmembraneOcclusion\[\([^]]*\)\]\[\([^]]*\)\]/membraneOcclusion(\1,\2)/g'
sed -i '' 's/\bmembraneAndSegmentOcclusion\[\([^]]*\)\]\[\([^]]*\)\]/membraneAndSegmentOcclusion(\1,\2)/g'
```

### Arrays to NOT Convert (Stay as Regular Arrays)

These arrays are NOT part of the optimized data structure and should remain unchanged:
- `reeiSite[NFILMAX][NMAX]` - stays as regular array
- `ree2iSite[NFILMAX][NMAX]` - stays as regular array  
- `rMiSite[NFILMAX][NMAX]` - stays as regular array
- `rM2iSite[NFILMAX][NMAX]` - stays as regular array
- `POcclude[NFILMAX][NMAX]` - stays as regular array
- `PDeliver[NFILMAX][NMAX]` - stays as regular array
- All variable declarations like `double arrayName[SIZE][SIZE]`

### REVISED Execution Plan (Based on Implementation Experience)

**Successful Test-Driven Strategy:**
1. **Start with outputControl.c** - Apply specific patterns and test compilation
2. **Follow compiler errors** - Each error tells you exactly what pattern to convert next
3. **Convert pattern-by-pattern** - Don't try to convert everything at once
4. **Move to metropolisJoint.c** - Apply same iterative approach
5. **Handle special cases** - Function arguments need `&` operator handling

**Example Error-Driven Workflow:**
```bash
# Test compilation
gcc -O3 driveMetropolis.c -o metropolis.out -lm

# Error: "use of undeclared identifier 'r' at line 812"
# Look at line 812: r[nf][Ncurrent-1][0]
# Convert that specific pattern:
sed -i '' 's/r\[nf\]\[Ncurrent-1\]\[0\]/r(nf,Ncurrent-1,0)/g'

# Test again, get next error, convert next pattern, repeat...
```

This approach is much more reliable than trying to anticipate all patterns.

### Validation

After each sed command:
```bash
gcc -O3 driveMetropolis.c -o metropolis.out -lm
```

The goal is to systematically eliminate "use of undeclared identifier" errors while maintaining correct syntax for all arrays.