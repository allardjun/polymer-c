#ifndef POLYMER_DATA_STRUCTURES_H
#define POLYMER_DATA_STRUCTURES_H

#include <string.h>
#include <stdlib.h>

// Original constants maintained for compatibility
#define NFILMAX         3
#define NMAX            1201
#define NBINSPOLYMER    3000

// New optimized data structures
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
    
    // Filament-specific data
    long *iSite;                // Interaction sites for this filament
    long iSiteTotal;            // Number of interaction sites
    
    long *bSite;                // Bound sites for this filament  
    long bSiteTotal;            // Number of bound sites
    
    long *basicSite;            // Basic sites for this filament
    long basicSiteTotal;        // Number of basic sites
    
    // Per-segment properties
    long *stericOcclusion;      // Steric occlusion for each segment
    long *membraneOcclusion;    // Membrane occlusion for each segment
    long *membraneAndSegmentOcclusion; // Combined occlusion
    double *PhosphorylatedSites; // Phosphorylation state
    long *BasicSitesYN;         // Basic site indicators
    double *StiffSites;         // Stiffening indicators
    
    // Ligand centers (3D positions)
    double (*iLigandCenter)[3]; // Interaction ligand centers
    double (*bLigandCenter)[3]; // Bound ligand centers  
    double (*bLigandCenterPropose)[3]; // Proposed bound ligand centers
    
    // Spatial distribution data
    long (*polymerLocationCounts)[NBINSPOLYMER]; // Location histograms
} filament_t;

// Global simulation state
typedef struct {
    filament_t *filaments;      // Array of filaments
    int NFil;                   // Number of filaments
    int allocated;              // Whether memory is allocated
    
    // Global arrays that don't fit segment pattern
    double occupied[NMAX];
    long NumberiSites;
    long NumberbSites;
    
    // Base-related data
    double baseCenter[3];
    double baseLigandCenter[NFILMAX][3];
    long stericOcclusionBase[NFILMAX];
    long boundToBaseDeliver[NFILMAX][NMAX];
    
    // Global parameters
    double c0, c1, irLigand, brLigand, baserLigand;
    double deliveryDistance, localConcCutoff;
    double StiffenRange;
    double baseSepDistance;
    double dimerDistCurrent, dimerDist0, kdimer;
    double kBound;
    
    // Global state variables
    double E, ENew, Eelectro, EelectroNew;
    long nt, ntNextStationarityCheck;
    long proposals[2], accepts[2];
    double dChi[2];
    long constraintProposalsTotal;
    int convergedTF, constraintSatisfiedTF;
    
    // Random number generator state
    long iseed;
    
} simulation_state_t;

// Function declarations
void allocate_simulation_state(simulation_state_t *state, int NFil, const int *N);
void free_simulation_state(simulation_state_t *state);
void convert_old_to_new_format(simulation_state_t *state);
void convert_new_to_old_format(simulation_state_t *state);

// Helper functions for efficient operations
void copy_segment(const segment_t *src, segment_t *dest);
void copy_segment_range(const segment_t *src, segment_t *dest, int count);
double segment_distance_squared(const segment_t *seg1, const segment_t *seg2);
double segment_distance(const segment_t *seg1, const segment_t *seg2);
void calculate_ligand_center(const segment_t *seg, double ligand_radius, 
                           const double *direction, double *center);

// Optimized configuration copying functions for metropolisJoint.c
void optimized_copy_to_proposal(int nfPropose, int iPropose);
void optimized_copy_from_proposal(int nfPropose, int iPropose);

// Backward compatibility macros for gradual migration to struct-of-arrays
#ifdef USE_COMPATIBILITY_LAYER
extern simulation_state_t g_sim_state;

// Compatibility macros - convert r[nf][i][coord] to r(nf,i,coord) 
#define r(nf,i,coord) (g_sim_state.filaments[nf].segments[i].r[coord])
#define t(nf,i,coord) (g_sim_state.filaments[nf].segments[i].t[coord])
#define e1(nf,i,coord) (g_sim_state.filaments[nf].segments[i].e1[coord])
#define e2(nf,i,coord) (g_sim_state.filaments[nf].segments[i].e2[coord])

#define rPropose(nf,i,coord) (g_sim_state.filaments[nf].segments_propose[i].r[coord])
#define tPropose(nf,i,coord) (g_sim_state.filaments[nf].segments_propose[i].t[coord])
#define e1Propose(nf,i,coord) (g_sim_state.filaments[nf].segments_propose[i].e1[coord])
#define e2Propose(nf,i,coord) (g_sim_state.filaments[nf].segments_propose[i].e2[coord])

#define phi(nf,i) (g_sim_state.filaments[nf].segments[i].phi)
#define theta(nf,i) (g_sim_state.filaments[nf].segments[i].theta)
#define psi(nf,i) (g_sim_state.filaments[nf].segments[i].psi)

#define phiPropose(nf,i) (g_sim_state.filaments[nf].segments_propose[i].phi)
#define thetaPropose(nf,i) (g_sim_state.filaments[nf].segments_propose[i].theta)
#define psiPropose(nf,i) (g_sim_state.filaments[nf].segments_propose[i].psi)

#define iSite(nf,i) (g_sim_state.filaments[nf].iSite[i])
#define iSiteTotal(nf) (g_sim_state.filaments[nf].iSiteTotal)
#define bSite(nf,i) (g_sim_state.filaments[nf].bSite[i])
#define bSiteTotal(nf) (g_sim_state.filaments[nf].bSiteTotal)

#define iLigandCenter(nf,i,coord) (g_sim_state.filaments[nf].iLigandCenter[i][coord])
#define bLigandCenter(nf,i,coord) (g_sim_state.filaments[nf].bLigandCenter[i][coord])
#define bLigandCenterPropose(nf,i,coord) (g_sim_state.filaments[nf].bLigandCenterPropose[i][coord])

#define stericOcclusion(nf,i) (g_sim_state.filaments[nf].stericOcclusion[i])
#define membraneOcclusion(nf,i) (g_sim_state.filaments[nf].membraneOcclusion[i])
#define membraneAndSegmentOcclusion(nf,i) (g_sim_state.filaments[nf].membraneAndSegmentOcclusion[i])

// External arrays that aren't part of the optimized structure
extern double rMiSite[NFILMAX][NMAX], rM2iSite[NFILMAX][NMAX];
extern long iSiteTotal[NFILMAX], bSiteTotal[NFILMAX];

#endif // USE_COMPATIBILITY_LAYER

#endif // POLYMER_DATA_STRUCTURES_H