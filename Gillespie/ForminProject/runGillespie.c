/*** Allard Group jun.allard@uci.edu                    ***/

void runGillespie();
void initializeStoreStates();
void storeStates();

void runGillespie()
{
    
    /****************************** Create State Matrix from File ***********************/

    sizeOfRateMatrix = numValidStates;
    
    // import first rate matrix
    char line1[20000];
    
    ratesFile = fopen(matrixName,"r");

    int i = 0;
    while (fgets(line1, sizeof(line1), ratesFile))
    {
        char *h = ",";
        char *token = strtok(line1, h);
        for (int j=0;j<sizeOfRateMatrix;j++) {
            if (token!=NULL){
                rateMatrix[i][j] = atof(token);
            }
            else{
                printf("null at j: %d\n",j);
            }
            token = strtok(NULL, h);
        }
        i++;
    }
    
    fclose(ratesFile);
    //printf("read in rate matrix\n");
    //debugging
    if(0)
    {
        
        
        // print rate matrix
        for (i=0;i<sizeOfRateMatrix;i++)
        {
            for (j=0;j<sizeOfRateMatrix;j++)
            {
                printf("%lf ", rateMatrix[i][j]);
            }
        
            printf("\n");
        }
    }


    // import state matrix
    char line2[20000];
    
    statesFile = fopen(stateName,"r");

    i = 0;
    while (fgets(line2, sizeof(line2), statesFile))
    {
        char *h = ",";
        char *token = strtok(line2, h);
        for (int j=0;j<iSiteTotal;j++) {
            if (token!=NULL){
                stateMatrix[i][j] = atof(token);
            }
            else{
                printf("null at j: %d\n",j);
            }
            token = strtok(NULL, h);
        }
        i++;
    }
    
    fclose(statesFile);
    //printf("read in state matrix\n");
    
    /*************** Binary Conversion and Initialize Stored States ************************/
    
    initializeStoreStates();
    //printf("ran initializeStoreStates\n");
    
    /******************************* Gillespie ******************************************/
    
    
    it=0;
    timeTotal=0;
    currentState=0; //start at free FH1
    
    initialize_dataRecording();
    //printf("ran initialize_dataRecording\n");
    
    // while less than number of desired steps or less than max steps
    while (timeTotal < timeEnd && it < ITMAX)
    {
        
        //initialize random time array and time step
        for (iy=0;iy<sizeOfRateMatrix;iy++)
        {
            randTime[iy]=0;
        }
        
        timeStep = INF;
        
        //Gillespie step
        
        for (iy=0;iy<sizeOfRateMatrix;iy++)
        {
            //printf("%f,", rateMatrix[currentState][iy]);
            if (rateMatrix[currentState][iy]!=0)
            {
                randTime[iy] = - log(TWISTER)/rateMatrix[currentState][iy]; //exponentially distributed random variable based on transition rate
                //printf("This is the state: %d\n", iy);
                //printf("This is the rate: %f\n", rateMatrix[currentState][iy]);
                //printf("This is the time: %f\n", randTime[iy]);
            }
            else
            {
                randTime[iy] = 0; //use 0 instead of infinity - then just remove these cases later
            }
            if (randTime[iy] < 0){
                printf("negative time \n");
                printf("This is the state: %d\n", iy);
                printf("This is the rate: %f\n", rateMatrix[currentState][iy]);
                printf("This is the time: %f\n", randTime[iy]);
            }
        }
        
        //pick smallest of random times
        for (iy=0;iy<sizeOfRateMatrix;iy++)
        {
            if (randTime[iy]!= 0)  // 0 time is not an option
            {
                if (randTime[iy]<timeStep)
                {
                    timeStep = randTime[iy];
                    newState = iy;
                }
            }
        }
        
        if (0)
        printf("\nThis is the path chosen: %d\n", newState);
    
        
        //update time
        timeTotal += timeStep;
        //printf("This is the total time: %f\n\n", timeTotal);
        
        // record current state and timestep before updating - matches state with time spent in that state
        /******************************* Store Last 100 States ******************************************/
        //update stored states
        storeStates();
        //printf("ran storestates \n");
        dataRecording();
        //printf("ran datarecording \n");
        /*************************************************************************************************/
        
        
        
        //update state
        currentState = newState;
    
        
        if (0)
        printf("Current State is: %d \n", currentState);
        


        

        it++;
    
    }
    printf("completed gillespie loop\n");
    finalState = currentState;
    finalTotalTime = timeTotal;
    printf("This is the total time: %f\n\n", timeTotal);
    
    outputGillespie();
    
    
}

/*************************************Initialize Store States********************************************/
/************************************************************************************************************************/
void initializeStoreStates()
{
    //initialize state storage
    numberStatesStored = 100;

    pastState = 0; 
    
    for (i=0;i<numberStatesStored;i++)
    {
        stateStorage[i] = 0;
        timeStorage[i]  = 0;
        kpolyStorage[i] = 0; 
    }
    
}
/******************************************Store States*************************************************************/
/************************************************************************************************************************/
void storeStates()
{
    int kpolynew = 0;
    int diffSite=0;
    int difftot=0;
    for (int j=0; j<iSiteTotal; j++){
        pastState = stateStorage[numberStatesStored-1];
        if (stateMatrix[pastState][j]!=stateMatrix[currentState][j]){
            difftot++;
            diffSite=j;
        }
    }
    if (stateMatrix[pastState][diffSite]==2 && stateMatrix[currentState][diffSite]==0){
            kpolynew=1;
        }

    for (i=0;i<numberStatesStored-1;i++)
    {
        stateStorage[i] = stateStorage[i+1];
        timeStorage[i]  = timeStorage[i+1];
        kpolyStorage[i]  = kpolyStorage[i+1];
    }
    
    stateStorage[numberStatesStored-1] = currentState;
    timeStorage[numberStatesStored-1]  = timeStep;
    kpolyStorage[numberStatesStored-1]  = kpolynew;
    

    if(0)
    {
        for (i=0;i<numberStatesStored;i++)
        {
            printf("State Storage %d: %d\n", i, stateStorage[i]);
        }
    
        for (i=0;i<numberStatesStored;i++)
        {
            printf("Time Storage %d: %f\n", i, timeStorage[i]);
        }
    
    }
}
    


