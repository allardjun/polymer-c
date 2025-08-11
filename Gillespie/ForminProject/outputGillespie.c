/*** Allard Group jun.allard@uci.edu                    ***/

void outputGillespie();
void dataRecording();

/*******************************************************************************/
//  GLOBAL VARIABLES for output control
/*******************************************************************************/

int endStorage_length;
int storedAddedActin;
double storedTotalTime;
double storedKpoly;
int storedAddedActin_End;
double storedTotalTime_End;
double storedKpoly_End;

/********************************************************************************************************/
void initialize_dataRecording()
{
    iter=0;
}

/********************************************************************************************************/
void outputGillespie()
{
    
    {
        
        /***************** OUTPUT ********************/

        outputFile = fopen(outputName, "a");
        fprintf(outputFile, "\n");  
                             
        storedTotalTime_End = 0;
        storedAddedActin_End = 0;                     
       for (i=0;i<endStorage_length;i++)
        {
            storedTotalTime_End = storedTotalTime_End + timeStorage_End[i];
            storedAddedActin_End = storedAddedActin_End + kpolyStorage_End[i];
            fprintf(outputFile, "state time kpoly %d %f %d", stateStorage_End[i], timeStorage_End[i], kpolyStorage_End[i]);     
            fprintf(outputFile, "\n");            
        }
        storedKpoly_End = storedAddedActin_End/storedTotalTime_End;

        fprintf(outputFile, "numValidStates %d\n", numValidStates);
        fprintf(outputFile, "iSiteTotal %d\n", iSiteTotal);                      
        fprintf(outputFile, "timeEnd %f\n", timeEnd);                          
        fprintf(outputFile, "finalState %d\n", finalState);                      
        fprintf(outputFile, "finalTotalTime %f\n", finalTotalTime);  
        fprintf(outputFile, "Over Avg time storedTotalTime %f\n", storedTotalTime_End);    
        fprintf(outputFile, "Over Avg time storedAddedActin %d\n", storedAddedActin_End); 
        fprintf(outputFile, "Over Avg time storedKpoly %f\n", storedKpoly_End);
        fprintf(outputFile, "it %d\n", it); 

        fclose(outputFile);
    
    }

    
}


/********************************************************************************************************/

void dataRecording()
{
    /*********************************************************************/
    // Record last x time states
    if (timeTotal >= (timeEnd-timeAvgDuration))
    {

        timeStorage_End[iter]  = timeStep;
        stateStorage_End[iter] = currentState;

        int kpolynew = 0;
        int diffSite=0;
        int difftot=0;
        for (int j=0; j<iSiteTotal; j++){
            if (stateMatrix[pastState][j]!=stateMatrix[currentState][j]){
                difftot++;
                diffSite=j;
            }
    }
        if (stateMatrix[pastState][diffSite]==2 && stateMatrix[currentState][diffSite]==0){
                kpolynew=1;
            }


        kpolyStorage_End[iter] = kpolynew;
        endStorage_length = iter+1;
        
        if(0)
        {
            fflush(stdout);
            printf("timeStorage_End iter %d : %f \n", iter, timeStorage_End[iter]);
            fflush(stdout);
            printf("stateStorage_End iter %d : %d \n", iter, stateStorage_End[iter]);
            
        }

        fprintf(outputFile, "state timestep %d %f", stateStorage_End[iter], timeStorage_End[iter]);     
        fprintf(outputFile, "\n");  

        if (stateStorage_End[iter] >timeTotal)
        {
            fprintf(outputFile,"ERROR: timeStorage_End is greater than timeTotal\n");
        }

        
        iter++;
    }
    pastState = currentState;

    /*********************************************************************/
}





