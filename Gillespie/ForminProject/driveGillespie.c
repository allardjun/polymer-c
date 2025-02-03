/*** Allard Lab lclemens@uci.edu                   ***/

#define TWISTER genrand_real3()
#define PI         3.14159265359
#define INF        1e14
#define ISITEMAX   9
#define STATEMAX   3000
#define ITMAX      1000000000 // use 1e8 on HPC for memory restrictions
#define ENDSTORAGEMAX 10000000 // True max: ITMAX. Unlikely to use though. Use less for memory constraints.
#define TALKATIVE  1

#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include "twister.c"


/*******************************************************************************/
//  GLOBAL VARIABLES
/*******************************************************************************/

char matrixName[1000];
FILE *ratesFile;
char stateName[1000];
FILE *statesFile;
long iseed;

char outputName[1000];
FILE *outputFile;


double timeTotal,randTime[STATEMAX],timeStep,timeEnd;
int currentState,iy,it,iterations;

double rateMatrix[STATEMAX][STATEMAX];
double stateMatrix[STATEMAX][STATEMAX];
int i,j,k,iter;
int iSiteTotal,newState,numValidStates;

int sizeOfRateMatrix;
int verbose, summaryOn;
int stateStorage[ENDSTORAGEMAX],numberStatesStored;
int kpolyStorage[ENDSTORAGEMAX];
double timeStorage[ENDSTORAGEMAX];

double timeAvgDuration;
int stateStorage_End[ENDSTORAGEMAX];
int kpolyStorage_End[ENDSTORAGEMAX];
double timeStorage_End[ENDSTORAGEMAX];

double reverseRate;

double finalTotalTime;
int finalState;
int pastState;

/*******************************************************************************/
//  INCLUDES
/*******************************************************************************/

#include "outputGillespie.c"
#include "runGillespie.c"


/*******************************************************************************/
//  MAIN
/*******************************************************************************/

// arguments: 
int main( int argc, char *argv[] )
{

    printf("This program is starting.\n");

    if(argv[1]) // matrixName
        strcpy(matrixName, argv[1]);
    if (TALKATIVE) printf("This is the matrix file name: %s\n", matrixName);

    if(argv[2]) // stateName
        strcpy(stateName, argv[2]);
    if (TALKATIVE) printf("This is the state matrix file name: %s\n", stateName);

    if(argv[3]) // numValidStates
        numValidStates = atoi(argv[3]);
    if (TALKATIVE) printf("This is the number of states: %d\n", numValidStates);

    if(argv[4]) //iSiteTotal
        iSiteTotal = atoi(argv[4]);
    if (TALKATIVE) printf("This is the number of PRMs: %d\n", iSiteTotal);

    if(argv[5]) //total number of iterations
        timeEnd = atof(argv[5]);
    if (TALKATIVE) printf("This is the total number of iterations: %f\n", timeEnd);

    if(argv[6]) //output file name
        strcpy(outputName, argv[6]);
    if (TALKATIVE) printf("This is the output file name: %s\n", outputName);

    if(argv[7]) //time to average over
        timeAvgDuration = atof(argv[7]);
    if (TALKATIVE) printf("This is the time to average over: %f\n", timeAvgDuration);


	iseed = RanInitReturnIseed(0);

	runGillespie();

	return 0;

} // finished main
