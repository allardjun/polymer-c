#ifndef GLOBALS_H
#define GLOBALS_H

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define SPEEDRUN 1

// Constants - single source of truth
#define TWISTER genrand_real3()
#define NFILMAX         3
#define NMAX            1201
#define NTADAPT         20000
#define NTCHECK         200000
#define DCHIMIN         1e-4
#define NBINS           100
#define NBINSPOLYMER    3000
#define PI              3.14159265359
#define INF             1e14
#define DCHIINIT        0.1
#define KSCRITICAL      0.002
#define MEMBRANE        0
#define MULTIPLE        1
#define STIFFEN         0
#define ELECTRO         0
#define HARDWALL        0
#define BASEBOUND       0
#define CPMAX           1e8
#define TALKATIVE       1
#define VISUALIZE       1
#define CD3ZETA         0
#define BINDTRANSITION  0

extern char listName[100];
extern FILE *fList;

extern char liveListName[100];

//
extern char paramsFilename[100], filamentFilename[100], iSiteFilename[100], bSiteFilename[100], basicSiteFilename[100];
extern FILE *paramsFile, *filList, *iSiteList, *bSiteList, *basicSiteList;



// Global variable declarations (extern)
extern long NFil, N[NFILMAX];
extern long Ntemp, iSiteTemp;
extern long NTMAX;
extern long iSite[NFILMAX][NMAX], iSiteTotal[NFILMAX], iSiteCurrent, iy, ty, stericOcclusion[NFILMAX][NMAX];
extern long NumberiSites;
extern long Ncurrent;
extern double c0, c1, irLigand;

extern double occupied[NMAX];
extern double ree[NFILMAX], rM[NFILMAX], rM2[NFILMAX], rMiSite[NFILMAX][NMAX], rM2iSite[NFILMAX][NMAX], rH[NFILMAX];
extern double reeFil[NFILMAX][NFILMAX];
extern long iseed;

// Base arrays
extern double rBase[NFILMAX][3], tBase[NFILMAX][3], e1Base[NFILMAX][3], e2Base[NFILMAX][3];
extern double norm;
extern double iLigandCenter[NFILMAX][NMAX][3];

extern double RGlobal[3][3], RLocal[3][3];
extern double e1_dot_t, e2_dot_t, e2_dot_e1;

extern long st;
extern long nf, nf2, nfPropose;
extern long proposals[2], accepts[2], nt, iChi, i, iPropose, ix, iParam, ntNextStationarityCheck, i2, iStart;
extern double E, ENew, rate[2], dChi[2], dChiHere, Force;
extern long constraintProposalsTotal;

extern int filamentInputMethod, iSiteInputMethod;
extern long commandiSites;
extern char *iSiteLocations;
extern char input[4*NMAX];
extern long j, m;
extern int verboseTF;

// Convergence variables
extern double ksStatistic[NFILMAX];
extern long ntNextStationarityCheck, iBin;
extern int convergedTF, constraintSatisfiedTF;
extern long convergenceVariableCounts[NFILMAX][NBINS], convergenceVariableCountsPrevious[NFILMAX][NBINS];
extern long polymerLocationCounts[NFILMAX][NMAX][NBINSPOLYMER];

// STIFFEN variables
extern double StiffenRange, StiffSites[NFILMAX][NMAX];
extern int stiffCase, totalStiff[NFILMAX];

// MULTIPLE variables
extern int bSiteInputMethod;
extern double brLigand;
extern double bLigandCenter[NFILMAX][NMAX][3];
extern long bSite[NFILMAX][NMAX], bSiteTotal[NFILMAX], bSiteCurrent, ib, ib2;
extern long NumberbSites;
extern double bLigandCenterPropose[NFILMAX][NMAX][3];
extern double deliveryDistance;
extern long stericOcclusionBase[NFILMAX];
extern long membraneOcclusion[NFILMAX][NMAX], membraneAndSegmentOcclusion[NFILMAX][NMAX];
extern double localConcCutoff;
extern int deliveryMethod;
extern long boundToBaseDeliver[NFILMAX][NMAX];
extern int radtype;

// ELECTRO variables
extern double Eelectro, EelectroNew;
extern double Erepulsion, Zrepulsion;
extern double parabolaDepth, parabolaWidth, wallParabolaK;
extern double PhosphorylatedSites[NFILMAX][NMAX];
extern int PhosElectroRange;
extern long basicSite[NFILMAX][NMAX], BasicSitesYN[NFILMAX][NMAX], basicSiteTotal[NFILMAX], basicSiteCurrent, iBasic;

// BASEBOUND variables
extern double baserLigand;
extern double baseLigandCenter[NFILMAX][3];
extern double baseCenter[3];

// Multiple filament variables
extern double baseSepDistance;

// Filament tail dimerization force
extern double dimerDistCurrent, dimerDist0;
extern double kdimer;

// Multiple ligands energy variables
extern double kBound;
extern double boundCentertoJointDistance, boundCentertoBaseDistance, boundCentertoBaseLigandDistance, boundCentertoBoundDistance;

// Function declarations
extern double genrand_real3(void);
void initializeSummary(void);
void finalizeSummary(int final);
void dataRecording(void);

#endif // GLOBALS_H