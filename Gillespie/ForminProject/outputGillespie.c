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
        storedTotalTime = 0;
        storedAddedActin = 0; 
        for (i=0;i<numberStatesStored;i++){
            storedTotalTime = storedTotalTime + timeStorage[i];
            storedAddedActin = storedAddedActin + kpolyStorage[i];
        }
        storedKpoly = storedAddedActin/storedTotalTime;
        
        /***************** OUTPUT ********************/

        outputFile = fopen(outputName, "a");
                             
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
        fprintf(outputFile, "storedTotalTime %f\n", storedTotalTime);    
        fprintf(outputFile, "storedAddedActin %d\n", storedAddedActin); 
        fprintf(outputFile, "storedKpoly %f\n", storedKpoly); 
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
        kpolyStorage_End[iter] = kpolyStorage[numberStatesStored-1];
        endStorage_length = iter+1;
        
        if(0)
        {
            fflush(stdout);
            printf("timeStorage_End iter %d : %f \n", iter, timeStorage_End[iter]);
            fflush(stdout);
            printf("stateStorage_End iter %d : %d \n", iter, stateStorage_End[iter]);
            
        }
        
        iter++;
    }

    /*********************************************************************/
}





