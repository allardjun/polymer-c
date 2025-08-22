/*** Allard Group jun.allard@uci.edu                    ***/

void getFilaments();


/*******************************************************************************/
//  GLOBAL VARIABLES for output control
/*******************************************************************************/


/********************************************************************************************************/
void getFilaments()
{
    /********* INITIALIZE Filaments *******************/
    
    switch (filamentInputMethod)
    {
            
        case 0:  // use identical filaments, number and length set from parameters.txt file or command line argument

            for(nf=0;nf<NFil;nf++)
            {
                N[nf]=Ntemp;
                if (TALKATIVE) printf("This is number of rods in filament %ld: %ld\n",nf, N[nf]);
            }
            
            break;
            
        case 1: //filaments from file
            
            // Check if filename indicates no file should be loaded
            if (strcmp(filamentFilename, "NONE") == 0 || strcmp(filamentFilename, "") == 0) {
                printf("Filament filename set to NONE - skipping file load\n");
                break;
            }
            
            filList = fopen(filamentFilename, "r");
            if (filList == NULL) {
                printf("Warning: Could not open filament file %s - using default values\n", filamentFilename);
                break;
            }
            
            char line[200];
            nf=0;
            
            while (fgets(line, sizeof(line), filList))
            {
                N[nf]=atoi(line);
                nf++;
            }
            
            fclose(filList);
            
            // count number of filaments
            NFil=nf;

            break;
            
        case 2: // do nothing, use command line input, set filaments in driveMet
            
            break;

    }
    
    //for debugging - prints a list of the filament lengths
    if (TALKATIVE)
    {
        for(nf=0;nf<NFil;nf++)
        {
            printf("Filament: %ld\n", nf);
            fflush(stdout);
            
            printf("N: %ld\n", N[nf]);
            fflush(stdout);
        }
    }
    
}

/********************************************************************************************************/

