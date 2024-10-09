%% Function to read in appropriate variables from data
function [] = readData_TransitionMatrix(filefolder,filesubfolder,filename)

    % Structure of output file
% 
%         nt,         // 1
%         NFil,       // 2
%         irLigand,   // 3
%         brLigand,   // 4
%         Force,      // 5
%         kdimer,     // 6
%         dimerDist0, // 7
%         baseSepDistance);     // 8
%         
%         for(nf=0;nf<NFil;nf++)
%         {
%                     N[nf],              // 9 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     ksStatistic[nf],    // 10 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     reeBar[nf],         // 11 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     ree2Bar[nf],        // 12 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     rMBar[nf],          // 13 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     rM2Bar[nf]);        // 14 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%             
%             for (iy=0;iy<iSiteTotal[nf];iy++)
%             {
% 
%                     iSite[nf][iy],              // 15 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     POcclude[nf][iy],           // 16 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     1-POcclude[nf][iy],         // 17 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     PMembraneOcclude[nf][iy],   // 18 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     Prvec0[nf][iy],             // 19 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     rMiSiteBar[nf][iy],         // 20 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                     rM2iSiteBar[nf][iy]);       // 21 + 7*iBind + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%             }
% 
%                     POccludeBase[nf],           // 22 + 7*(iSiteTotal-1) + (6 + 7*iSiteTotal + 2)*nf
%                     1-POccludeBase[nf]);        // 23 + 7*(iSiteTotal-1) + (6 + 7*iSiteTotal + 2)*nf
%             
%             for(nf2=0;nf2<NFil;nf2++)
%             {
%                 fprintf(fList, " %f",
%                     reeFilBar[nf][nf2]);        // 24 + 7*(iSiteTotal-1) + nf2 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%             }
%             
%             for(nf2=0;nf2<NFil;nf2++)
%             {
%                 fprintf(fList, " %f",
%                         ree2FilBar[nf][nf2]);   // 25 + 7*(iSiteTotal-1) + (NFil-1) + nf2 + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%             }
%             
%             
%             if (CD3ZETA)
%             {
%                 for (iy=0; iy<iSiteTotal[nf];iy++)
%                 {
%                     fprintf(fList, "%lf ", occupied[nf][iy]); // 26 + 7*(iSiteTotal-1) + (NFil-1) + (NFil-1) + iy + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%                 }
%                 
%                 // eventually want this to depend on filament
%                 fprintf(fList, "%s ", occupiedSitesNoSpace);    // 27 + 7*(iSiteTotal-1) + (NFil-1) + nf2 + (iSiteTotal-1) + (6 + 7*iSiteTotal + 2 + NFil + NFil)*nf
%             }



    M = dlmread(fullfile(filefolder,filesubfolder, filename));

    OccupiedLocations = M(:,end);

    OccupiedLocationsMatrix(:,1:6) = M(:,(end-6):(end-1));

    % up to total number of iSites - 6 for mouse CD3Zeta
    POcc(:,1:6) = M(:,16+7*(0:1:5));
    PBind(:,1:6) = 1-POcc(:,1:6);
    

end
    