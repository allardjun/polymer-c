#define USE_COMPATIBILITY_LAYER
#include "polymer_data_structures.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Global simulation state instance for compatibility
#ifdef USE_COMPATIBILITY_LAYER
simulation_state_t g_sim_state = {0};
#endif

void allocate_simulation_state(simulation_state_t *state, int NFil, const int *N) {
    if (state->allocated) {
        printf("Warning: Simulation state already allocated. Freeing first.\n");
        free_simulation_state(state);
    }
    
    // Initialize basic state
    state->NFil = NFil;
    state->allocated = 1;
    
    // Allocate filament array
    state->filaments = (filament_t*)calloc(NFil, sizeof(filament_t));
    if (!state->filaments) {
        printf("Error: Failed to allocate filaments array\n");
        exit(1);
    }
    
    // Allocate each filament
    for (int nf = 0; nf < NFil; nf++) {
        filament_t *fil = &state->filaments[nf];
        fil->N = N[nf];
        fil->capacity = N[nf];
        
        // Allocate segment arrays
        fil->segments = (segment_t*)calloc(N[nf], sizeof(segment_t));
        fil->segments_propose = (segment_t*)calloc(N[nf], sizeof(segment_t));
        
        if (!fil->segments || !fil->segments_propose) {
            printf("Error: Failed to allocate segments for filament %d\n", nf);
            exit(1);
        }
        
        // Allocate per-segment property arrays
        fil->iSite = (long*)calloc(NMAX, sizeof(long));
        fil->bSite = (long*)calloc(NMAX, sizeof(long));
        fil->basicSite = (long*)calloc(NMAX, sizeof(long));
        fil->stericOcclusion = (long*)calloc(N[nf], sizeof(long));
        fil->membraneOcclusion = (long*)calloc(N[nf], sizeof(long));
        fil->membraneAndSegmentOcclusion = (long*)calloc(N[nf], sizeof(long));
        fil->PhosphorylatedSites = (double*)calloc(N[nf], sizeof(double));
        fil->BasicSitesYN = (long*)calloc(N[nf], sizeof(long));
        fil->StiffSites = (double*)calloc(N[nf], sizeof(double));
        
        // Allocate ligand center arrays
        fil->iLigandCenter = (double(*)[3])calloc(NMAX, sizeof(double[3]));
        fil->bLigandCenter = (double(*)[3])calloc(NMAX, sizeof(double[3]));
        fil->bLigandCenterPropose = (double(*)[3])calloc(NMAX, sizeof(double[3]));
        
        // Allocate spatial distribution arrays
        fil->polymerLocationCounts = (long(*)[NBINSPOLYMER])calloc(N[nf], sizeof(long[NBINSPOLYMER]));
        
        if (!fil->iSite || !fil->bSite || !fil->basicSite || 
            !fil->stericOcclusion || !fil->membraneOcclusion || 
            !fil->membraneAndSegmentOcclusion || !fil->PhosphorylatedSites ||
            !fil->BasicSitesYN || !fil->StiffSites ||
            !fil->iLigandCenter || !fil->bLigandCenter || !fil->bLigandCenterPropose ||
            !fil->polymerLocationCounts) {
            printf("Error: Failed to allocate property arrays for filament %d\n", nf);
            exit(1);
        }
        
        // Initialize counts
        fil->iSiteTotal = 0;
        fil->bSiteTotal = 0;
        fil->basicSiteTotal = 0;
    }
    
    printf("Successfully allocated simulation state for %d filaments\n", NFil);
}

void free_simulation_state(simulation_state_t *state) {
    if (!state->allocated) {
        return;
    }
    
    if (state->filaments) {
        for (int nf = 0; nf < state->NFil; nf++) {
            filament_t *fil = &state->filaments[nf];
            
            // Free segment arrays
            free(fil->segments);
            free(fil->segments_propose);
            
            // Free property arrays
            free(fil->iSite);
            free(fil->bSite);
            free(fil->basicSite);
            free(fil->stericOcclusion);
            free(fil->membraneOcclusion);
            free(fil->membraneAndSegmentOcclusion);
            free(fil->PhosphorylatedSites);
            free(fil->BasicSitesYN);
            free(fil->StiffSites);
            
            // Free ligand center arrays
            free(fil->iLigandCenter);
            free(fil->bLigandCenter);
            free(fil->bLigandCenterPropose);
            
            // Free spatial arrays
            free(fil->polymerLocationCounts);
        }
        free(state->filaments);
    }
    
    state->filaments = NULL;
    state->NFil = 0;
    state->allocated = 0;
    
    printf("Freed simulation state\n");
}

// Conversion functions for backward compatibility with existing global arrays
void convert_old_to_new_format(simulation_state_t *state) {
    // This function would copy data from old global arrays to new structure
    // Implementation depends on which global arrays still exist during transition
    printf("Converting from old data format to new optimized format\n");
    
    // Example implementation (would need to be completed based on actual globals):
    // extern double r[NFILMAX][NMAX][3];
    // extern double t[NFILMAX][NMAX][3];
    // extern double phi[NFILMAX][NMAX];
    // etc.
    
    // for (int nf = 0; nf < state->NFil; nf++) {
    //     for (int i = 0; i < state->filaments[nf].N; i++) {
    //         for (int coord = 0; coord < 3; coord++) {
    //             state->filaments[nf].segments[i].r[coord] = r[nf][i][coord];
    //             state->filaments[nf].segments[i].t[coord] = t[nf][i][coord];
    //             state->filaments[nf].segments[i].e1[coord] = e1[nf][i][coord];
    //             state->filaments[nf].segments[i].e2[coord] = e2[nf][i][coord];
    //         }
    //         state->filaments[nf].segments[i].phi = phi[nf][i];
    //         state->filaments[nf].segments[i].theta = theta[nf][i];
    //         state->filaments[nf].segments[i].psi = psi[nf][i];
    //     }
    // }
}

void convert_new_to_old_format(simulation_state_t *state) {
    // This function would copy data from new structure back to old global arrays
    // Useful for interfacing with code that hasn't been migrated yet
    printf("Converting from new optimized format to old data format\n");
    
    // Example implementation:
    // for (int nf = 0; nf < state->NFil; nf++) {
    //     for (int i = 0; i < state->filaments[nf].N; i++) {
    //         for (int coord = 0; coord < 3; coord++) {
    //             r[nf][i][coord] = state->filaments[nf].segments[i].r[coord];
    //             t[nf][i][coord] = state->filaments[nf].segments[i].t[coord];
    //             e1[nf][i][coord] = state->filaments[nf].segments[i].e1[coord];
    //             e2[nf][i][coord] = state->filaments[nf].segments[i].e2[coord];
    //         }
    //         phi[nf][i] = state->filaments[nf].segments[i].phi;
    //         theta[nf][i] = state->filaments[nf].segments[i].theta;
    //         psi[nf][i] = state->filaments[nf].segments[i].psi;
    //     }
    // }
}

// Helper functions for efficient operations
void copy_segment(const segment_t *src, segment_t *dest) {
    memcpy(dest, src, sizeof(segment_t));
}

void copy_segment_range(const segment_t *src, segment_t *dest, int count) {
    memcpy(dest, src, count * sizeof(segment_t));
}

// Efficient distance calculation using segment pointers
double segment_distance_squared(const segment_t *seg1, const segment_t *seg2) {
    double dx = seg1->r[0] - seg2->r[0];
    double dy = seg1->r[1] - seg2->r[1];
    double dz = seg1->r[2] - seg2->r[2];
    return dx*dx + dy*dy + dz*dz;
}

double segment_distance(const segment_t *seg1, const segment_t *seg2) {
    return sqrt(segment_distance_squared(seg1, seg2));
}

// Efficient ligand center calculation
void calculate_ligand_center(const segment_t *seg, double ligand_radius, 
                           const double *direction, double *center) {
    center[0] = seg->r[0] + ligand_radius * direction[0];
    center[1] = seg->r[1] + ligand_radius * direction[1];
    center[2] = seg->r[2] + ligand_radius * direction[2];
}

// Optimized configuration copying functions for metropolisJoint.c
void optimized_copy_to_proposal(int nfPropose, int iPropose) {
    // Copy configuration using the new data layout with compatibility macros
    for (int nf = 0; nf < g_sim_state.NFil; nf++) {
        if (nf == nfPropose) {
            // For proposed filament, only copy segments before iPropose
            if (iPropose > 1) {
                // Use bulk memory copy on segment structures - much faster!
                copy_segment_range(&g_sim_state.filaments[nf].segments[1], 
                                 &g_sim_state.filaments[nf].segments_propose[1], 
                                 iPropose - 1);
            }
        } else {
            // For non-proposed filaments, copy all segments
            copy_segment_range(&g_sim_state.filaments[nf].segments[0], 
                             &g_sim_state.filaments[nf].segments_propose[0], 
                             g_sim_state.filaments[nf].N);
        }
    }
}

void optimized_copy_from_proposal(int nfPropose, int iPropose) {
    // Accept configuration using bulk segment copying
    copy_segment_range(&g_sim_state.filaments[nfPropose].segments_propose[iPropose], 
                     &g_sim_state.filaments[nfPropose].segments[iPropose], 
                     g_sim_state.filaments[nfPropose].N - iPropose);
}