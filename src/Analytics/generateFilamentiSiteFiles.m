%% Script to write text files for each combination of inter-ITAM spacing, number of filaments
clear all;
close all;

% initialize sweeps
numFilSweep = [1 2 3 5 9 10]; % only use numbers that can be uniquely arranged into mostly-evenly distributed filaments
ITAMTotal = 10;
interITAMSweep = 1:20;
ITAMlocationSweep = 1:2; % cases

% initialize filenames, locations
savefolder = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/TCR/MembraneOn/FilVSTime/FilamentParamFiles';

%% Set up ITAMs per filaments, filament lengths, ITAM locations

for iIS = 1:length(interITAMSweep)
    for nFS = 1:length(numFilSweep)
        clearvars ITAMperFil
        
        % set up savenames
        savename_fil_end = ['filaments_end.',num2str(interITAMSweep(iIS)),'.',num2str(numFilSweep(nFS)),'.txt'];
        savename_fil_mid = ['filaments_mid.',num2str(interITAMSweep(iIS)),'.',num2str(numFilSweep(nFS)),'.txt'];
        savename_ITAM = ['iSites.',num2str(interITAMSweep(iIS)),'.',num2str(numFilSweep(nFS)),'.txt'];
        
        % set up number of ITAMs per filament
        nFils = numFilSweep(nFS);
        base = floor(ITAMTotal./nFils);
        extra = mod(ITAMTotal,nFils);
        ITAMperFil = base.*ones(1,nFils);
        for iExtra = 1:extra
            ITAMperFil(iExtra) = ITAMperFil(iExtra)+1;
        end
        
        % set up length of each filament
        filamentLength_end = ITAMperFil.*interITAMSweep(iIS)
        filamentLength_mid = ITAMperFil.*interITAMSweep(iIS) + interITAMSweep(iIS)
        
        % set up ITAM locations for C indexing
        ITAMlocations = zeros(1,ITAMTotal);
        iL = 1;
        for ipF = 1:length(ITAMperFil)
            ITAMlocations(iL:(iL+ITAMperFil(ipF)-1)) = ITAMlocations(iL:(iL+ITAMperFil(ipF)-1)) + (1:ITAMperFil(ipF)).*interITAMSweep(iIS);
            iL = iL+ITAMperFil(ipF);
        end
        ITAMlocations = ITAMlocations - 1; % convert to C indexing
        
        % Print filaments to text file - end
        fileID = fopen(fullfile(savefolder,savename_fil_end),'w');
        fprintf(fileID,'%f\n',filamentLength_end);
        fclose(fileID);
        
        % Print filaments to text file - mid
        fileID = fopen(fullfile(savefolder,savename_fil_mid),'w');
        fprintf(fileID,'%f\n',filamentLength_mid);
        fclose(fileID);
        
        % Print iSites to text file
        fileID = fopen(fullfile(savefolder,savename_ITAM),'w');
        iL = 1
        for ipF = 1:length(ITAMperFil)
            fprintf(fileID,'%f ',ITAMlocations(iL:(iL+ITAMperFil(ipF)-2))); % print most iSites
            fprintf(fileID,'%f',ITAMlocations((iL+ITAMperFil(ipF)-1))); % need to remove space at last iSite for proper code functioning
            fprintf(fileID,'\n');
            iL = iL+ITAMperFil(ipF);
        end
        fclose(fileID);
        

    end
end
 