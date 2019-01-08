/*** Allard Group jun.allard@uci.edu                    ***/

void outputGillespie();

/*******************************************************************************/
//  GLOBAL VARIABLES for output control
/*******************************************************************************/

double topPaths[NTOPPATHS][5],pathArrayShort[STATEMAX][5],maxPath[5],leastPath[5];
int factorial,frequency,topLocation,topPathsLocation[NTOPPATHS],topFrequency, maxFreq, maxLocation,leastLocation;
double transitionTime_Avg[ISITEMAX];
double MFTP,leastFreq;
int pass, pathTotal;

/********************************************************************************************************/
void outputGillespie()
{
    
    //find factorial
    factorial=1;
    for (i=1;i<=iSiteTotal;i++)
    {
        factorial *= i;
    }
    
    
    /************* MFTP ******************/
    MFTP = timeSum/iterations; //find mean first passage time - avg time it takes to move from 000000 to 111111
    
    /************* Mean Time Between States ************/
    for(iy=0;iy<iSiteTotal;iy++)
    {
        transitionTime_Avg[iy] = transitionTime[iy]/iterations;
    }
    
    if(1)//debugging
    {
        for(iy=0;iy<iSiteTotal;iy++)
        {
            printf("Transition: %d, Mean Time: %f\n",iy,transitionTime_Avg[iy]);
            printf("Transition: %d, Mean Rate: %e\n",iy,1/transitionTime_Avg[iy]);
        }
    }
    /******************** PATHS ************************/
    
    //find the top twenty fastest paths
    //are fastest and most probable the same??
    //presumably no chance of having a tie?
    
    //this seems like a bad method
    
    //creates smaller matrix of all paths
    
    pathTotal=0;
    for (j=0;j<factorial;j++)
    {
        if (pathArray[j][0] != 0)
        {
            pathArrayShort[pathTotal][0] = j; //path index
            pathArrayShort[pathTotal][1] = pathArray[j][0]; //total times path was taken
            pathArrayShort[pathTotal][2] = pathArray[j][1]; //sum of all times when path was taken
            pathArrayShort[pathTotal][3] = pathArray[j][0]/iterations; //probability of path being taken
            pathArrayShort[pathTotal][4] = pathArray[j][1]/pathArray[j][0]; //average time
            pathTotal++;
        }
        
    }
    
    if (TALKATIVE)
    {
        printf("This is how many paths it thinks it took: %d\n", pathTotal);
    }
    
    
    //find most frequent path
    maxFreq = 0;
    for (j=0;j<pathTotal;j++)
    {
        if (pathArrayShort[j][1] > maxFreq)
        {
            maxFreq = pathArrayShort[j][1];
            maxLocation = j;
        }
    }
    
    for (k=0;k<5;k++)
    {
        maxPath[k] = pathArrayShort[maxLocation][k];
    }
    
    
    //find least frequent path
    leastFreq = INF;
    for (j=0;j<pathTotal;j++)
    {
        if (pathArrayShort[j][1] < leastFreq)
        {
            leastFreq = pathArrayShort[j][1];
            leastLocation = j;
        }
    }
    
    for (k=0;k<5;k++)
    {
        leastPath[k] = pathArrayShort[leastLocation][k];
    }
  
    
    //find top twenty most frequent paths
    topFrequency=0;
    for (k=0;k<NTOPPATHS;k++)
    {
        frequency=0;
        
        for (i=0;i<pathTotal;i++)
        {
            if (pathArrayShort[i][1]>frequency)
            {
                j=0;
                pass = 1;
                while (j<NTOPPATHS && pass)
                {
                    if (i != topPathsLocation[j])
                    {
                        j++;
                    }
                    else
                    {
                        pass = 0;
                    }
                }
                if (pass)
                {
                    frequency = pathArrayShort[i][1];
                    topPathsLocation[k] = i;
                }
            }
        }
    }

    
    //create list of top twenty paths with path, frequency, total time, probability, average time
    for (k=0;k<NTOPPATHS;k++)
    {
        topLocation = topPathsLocation[k];
        for (i=0;i<5;i++)
        {
            topPaths[k][i] = pathArrayShort[topLocation][i];
        }
    }
    
    /***************** OUTPUT ********************/
    
    /*********************** Print Summary Data ***********************/
    if (summaryOn)
    {

        summaryOutputFile = fopen(summaryOutputName, "a");
        
        //print MFPT
        fprintf(summaryOutputFile, "%f\n", MFTP);
        
        //print max path
        for (i=0;i<5;i++)
        {
            fprintf(summaryOutputFile, "%f ", maxPath[i]);
        }
        
        fprintf(summaryOutputFile, "\n");
        
        //print least path
        for (i=0;i<5;i++)
        {
            fprintf(summaryOutputFile, "%f ", leastPath[i]);
        }
        
        fprintf(summaryOutputFile, "\n");
        
        //print top paths
        for (i=0;i<NTOPPATHS;i++)
        {
            for (j=0;j<5;j++)
            {
                fprintf(summaryOutputFile, "%f ", topPaths[i][j]);
            }
            
            fprintf(summaryOutputFile, "\n");
        }
        
        //print time to transition between states (e.g. 0->1, 1->2...)
        for (iy=0;iy<iSiteTotal;iy++)
        {
            fprintf(summaryOutputFile, "%d %f %e\n", iy,transitionTime_Avg[iy],1/(double)transitionTime_Avg[iy]);
        }
        
        fclose(summaryOutputFile);

    }
    /*********************** Print All Data ***********************/

    outputFile = fopen(outputName, "a");
    
    fprintf(outputFile, "%f\n", MFTP);
    
    //print all path data
    for (i=0;i<pathTotal;i++)
    {
        for (j=0;j<5;j++)
        {
            fprintf(outputFile, "%f ", pathArrayShort[i][j]);
        }
        
        fprintf(outputFile, "\n");
    }
    
    //print time to transition between states (e.g. 0->1, 1->2...)
    for (iy=0;iy<iSiteTotal;iy++)
    {
        fprintf(outputFile, "%d %f %e\n", iy,transitionTime_Avg[iy],1/(double)transitionTime_Avg[iy]);
    }
    
    fclose(outputFile);
    
    /*********************** Print Time Data ***********************/
    
    if (TIME)
    {
        timeOutputFile = fopen(timeOutputName, "a");
        
        for (i=0;i<iterations;i++)
        {
            fprintf(timeOutputFile, "%f\n", timeArray[i]);
        }
    }
        
        

    
}


