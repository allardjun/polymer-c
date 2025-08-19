# Static RLocal Matrix Caching Optimization

## Overview
This optimization caches rotation matrices (RLocal) for each filament segment to avoid redundant computation during Monte Carlo simulation steps. Since most MC steps perturb only one segment out of hundreds, we can reuse cached RLocal matrices for unchanged segments.

## Memory Cost
- Storage: `RLocalCache[NFILMAX][NMAX][3][3]` double array
- For NFil=2, N=600: 2×600×3×3×8 = 86,400 bytes (~86 KB)
- Negligible memory footprint for significant performance gain

## Implementation Details

### Files Modified
1. **globals.h**: Added RLocal cache declarations
   ```c
   extern double RLocalCache[NFILMAX][NMAX][3][3];
   extern int RLocalCacheInitialized;
   ```

2. **driveMetropolis.c**: Added RLocal cache definitions
   ```c
   double RLocalCache[NFILMAX][NMAX][3][3];
   int RLocalCacheInitialized = 0;
   ```

3. **metropolisJoint.c**: 
   - Modified `rotate()` function signature to accept `(int fil, int seg)` parameters
   - Added cache initialization and management logic
   - Updated rotate() calls to pass filament and segment indices

### Algorithm
1. **Initialization**: On first call, initialize cache with identity matrices
2. **Cache Check**: For each rotate() call, check if segment is the perturbed one
3. **Selective Recomputation**: Only recompute RLocal matrix if segment was modified
4. **Cache Usage**: Use cached RLocal matrix for unchanged segments

### Performance Benefits
- **Expected Speedup**: ~99% reduction in RLocal computation overhead
- **MC Efficiency**: Most steps change 1 segment out of 1200 total
- **Compound Effect**: Works with existing Gram-Schmidt optimization

## Code Locations with RLOCAL_CACHE_OPTIMIZATION Comments
- `globals.h:66-68`: Cache variable declarations
- `driveMetropolis.c:57-59`: Cache variable definitions  
- `metropolisJoint.c:12`: Updated function declaration
- `metropolisJoint.c:296`: First rotate() call with segment tracking
- `metropolisJoint.c:323-325`: Loop rotate() calls with segment tracking
- `metropolisJoint.c:953-1013`: Cache initialization and management logic

## Status
✅ **COMPLETED**: All implementation steps finished
- Cache storage arrays added
- Function signatures updated
- Cache management logic implemented
- All rotate() calls updated with segment tracking
- Code compiles and runs successfully

## Testing
- Code compiles without errors
- Runtime test confirmed successful execution
- Ready for performance benchmarking

## Future Considerations
- Could extend caching to other expensive matrix operations
- Potential for further optimization of matrix multiplication in RGlobal computation
- Cache invalidation strategy if angles change outside of MC perturbations