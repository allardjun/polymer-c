%% Visualize 3D - Zeta Chain
%% lclemens@uci.edu

clear all;
close all;

%% Movie parameters

% which model and movie parameters
membraneVisible = 1; % 0 = don't show membrane, 1 = show membrane
model = 2; % switch for file location and parameters
movie = 0; % 0 = don't save movie, 1 = save movie
kinaseVisible = 0; % 0 = don't show kinases on iSites, 1 = show kinases
scale = 1; %0 = kuhn length, 1 = nanometers, % auto scale is off - needs debugging.  currently using set(gca) method
saveFinalFrame = 1;

% how many iterations, from which part of the file
start = 1;
stop = 15;
stepsize = 5;
iterations = start:stepsize:stop;

filefolder = '~/Documents/Papers/MultisiteDisorder/Data/4.Visual/TCRInit/';
%filefolder = 'VisualizeData';

savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/3.SimultaneousBinding/TCR/MembraneOn';


%% model parameters
if (membraneVisible)
    membraneState = 'On';
else
    membraneState = 'Off';
end

if (kinaseVisible)
    kinaseState = 'On';
else
    kinaseState = 'Off';
end


%% Initialize TCR

NFil = 6; - epsilon
% Filament 1
Filaments(1).N = 55;
Filaments(1).iSites = [41]+1;
Filaments(1).bSites = [];
% Fil 2 - delta
Filaments(2).N = 47;
Filaments(2).iSites = [28]+1;
Filaments(2).bSites = [];
% Fil 3 - zeta
Filaments(3).N = 113;
Filaments(3).iSites = [26,65,96]+1;
Filaments(3).bSites = [];
% Fil 4 - zeta
Filaments(4).N = 113;
Filaments(4).iSites = [26,65,96]+1;
Filaments(4).bSites = [];
% Filament 5 - gamma
Filaments(5).N = 45;
Filaments(5).iSites = [28]+1;
Filaments(5).bSites = [];
% Filament 6 - epsilon
Filaments(6).N = 55;
Filaments(6).iSites = [41]+1;
Filaments(6).bSites = [];

bLigands = 1;

irLigand = 7;
brLigand = 7;
BASEBOUND = 0;
baserLigand = 0;

switch(model)
    case 0
        filename = 'TCRInitBaseSep17.txt';
        if (membraneVisible)
            axes = [-50, 50];
        else
            axes = [-60, 60];
        end

    case 1
        filename = 'TCRNoneBoundBaseSep17.txt';
        if (membraneVisible)
            axes = [-30, 30];
        else
            axes = [-sqrt(113)-5, sqrt(113)+5];
        end
    case 2
        filename = 'TCRInitBaseSep5.txt';
        if (membraneVisible)
            axes = [-50, 50];
        else
            axes = [-60, 60];
        end
        savesubfolder = 'SepDist5/Plots/Visuals/';

    case 3
        filename = 'TCRNoneBoundBaseSep5.txt';
        if (membraneVisible)
            axes = [-15, 15];
        else
            axes = [-sqrt(113)-5, sqrt(113)+5];
        end
        
     case 4
        %filename = 'TCRNoneBoundBaseSep5Long.txt';
        filename = 'TCRNoneBoundBaseSep5LongDChi0001.txt';
        if (membraneVisible)
            axes = [-15, 15];
        else
            axes = [-sqrt(113)-5, sqrt(113)+5];
        end
        
      case 5
        %filename = 'TCRBoundBaseSep5Long.txt';
        filename = 'TCRBoundBaseSep5LongDChi0001.txt';
        if (membraneVisible)
            axes = [-30, 30];
        else
            axes = [-sqrt(113)-5, sqrt(113)+5];
        end
        Filaments(1).bSites = [41]+1;
        Filaments(3).bSites = [96]+1;
end

moviename = [filename,'withKinase'];

lw = 2;
marker_lw = 2;
ms = 8;
%colors = [0.8 0 0; 0 0 0.7; 0.8 0 0.8; 0 0.7 0]
%colors_fil = [colors(1,:); colors(2,:); colors(3,:); colors(3,:); colors(4,:); colors(1,:)];
colors_fil = [0.7 0 0; 0 0.5 0.8; 0 0.5 0; 0 0.8 0; 0.7 0 0.7; 1 0 0]
membraneColor = [1 1 180/255];
% scale ligand to nanometers
% if (scale)
%     irLigand = 0.3*irLigand;
% end


%% Visualization

% create movie if desired
if (movie)
   Visual3D = VideoWriter(strcat(moviename,'.avi'));
   Visual3D.FrameRate = 5;
   open(Visual3D);
end

% how does this initialization work with only 3 columns?
for nf = 1:length(Filaments)
    Filaments(nf).r1 = zeros(length(iterations),Filaments(nf).N +1);
    Filaments(nf).r2 = zeros(length(iterations),Filaments(nf).N +1);
    Filaments(nf).r3 = zeros(length(iterations),Filaments(nf).N +1);
end


% read in data - formatted as follows
% 
% nt,                                     // 1
% E,                                      // 2
% dChi[0],                                // 3
% dChi[1],                                // 4
% rate[0],                                // 5
% rate[1],                                // 6
% constraintProposalsTotal,               // 7

% ree[nf],                                // 8       + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*(nf-1)
% rM[nf],                                 // 9
% rH[nf],                                 // 10
% ksStatistic[nf],                        // 11
% reeFil[nf][nf2]                         // 12 + (nf-1)
% stericOcclusion[nf][iy],                // 13 + (NFil-1) + 3*iy
% membraneOcclusion[nf][iy],              // 14 + (NFil-1) + 3*iy
% membraneAndSegmentOcclusion[nf][iy],    // 15 + (NFil-1) + 3*iy
% stericOcclusionBase[nf]);               // 16 + (NFil-1) + 3*(iSiteTotal[nf]-1)
% rBase[nf][0],                           // 17 + (NFil-1) + 3*(iSiteTotal[nf]-1)
% rBase[nf][1],                           // 18 + (NFil-1) + 3*(iSiteTotal[nf]-1)
% rBase[nf][2],                           // 19 + (NFil-1) + 3*(iSiteTotal[nf]-1)
% r[nf][i][0],                            // 20 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*i
% r[nf][i][1],                            // 21 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*i
% r[nf][i][2],                            // 22 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*i
% iLigandCenter[nf][iy][0],               // 23 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
% iLigandCenter[nf][iy][1],               // 24 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
% iLigandCenter[nf][iy][2]                // 25 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
% baseLigandCenter[nf][0]
% baseLigandCenter[nf][1]
% baseLigandCenter[nf][2]
% bLigandCenter[nf][iy][0],                 // 29 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
% bLigandCenter[nf][iy][1],                 // 30 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
% bLigandCenter[nf][iy][2]);            // 31 + (NFil-1) + 3*(iSiteTotal[nf]-1) + 3*(N[nf]-1) + 3*iy
% baseCenter[0],                      // 1 + 8 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*(NFil-1)
% baseCenter[1],                      // 2 + 8 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*(NFil-1)
% baseCenter[2]                       // 3 + 8 + (4 + NFil + 3*iSiteTotal[nf] + 1 + 3 + 3*N[nf] + 3*iSiteTotal[nf] + 3 + MULTIPLE*3*bSiteTotal[nf])*(NFil-1)

M = dlmread(fullfile(filefolder,filename));

% pull out location data including base
indexStart = 7 + 4 + length(Filaments) + 3*length(Filaments(1).iSites) + 1 + 1;
for nf = 1:length(Filaments)
    disp(indexStart);
    for i=1:(Filaments(nf).N+1)
        for j=1:length(iterations)
            Filaments(nf).r1(j,i) = M(iterations(j), indexStart + 0 + 3*(i-1));
            Filaments(nf).r2(j,i) = M(iterations(j), indexStart + 1 + 3*(i-1));
            Filaments(nf).r3(j,i) = M(iterations(j), indexStart + 2 + 3*(i-1));
        end
    end
    if(nf<(length(Filaments)))
        indexStart = indexStart + (4 + length(Filaments) + 3*length(Filaments(nf+1).iSites) + 1 + 3 + 3*Filaments(nf).N + 3*length(Filaments(nf).iSites) + 3 + 3*length(Filaments(nf).bSites));
    end
end

% convert to nanometers
% if(scale)
%    r1 = 0.3*r1;
%    r2 = 0.3*r2;
%    r3 = 0.3*r2;
% end

% pull out ligand center data
if (kinaseVisible)
   indexStart = 7 + 4 + length(Filaments) + 3*length(Filaments(1).iSites) + 1 + 3 + 3*Filaments(1).N + 1;
   for nf = 1:length(Filaments)
       for i=1:length(Filaments(nf).iSites)
           for j=1:length(iterations)
                Filaments(nf).iLigandCenter1(j,i) = M(iterations(j), indexStart + 0 + 3*(i-1));
                Filaments(nf).iLigandCenter2(j,i) = M(iterations(j), indexStart + 1 + 3*(i-1));
                Filaments(nf).iLigandCenter3(j,i) = M(iterations(j), indexStart + 2 + 3*(i-1));
           end
       end
    if(nf<length(Filaments))
        indexStart = indexStart + (4 + length(Filaments) + 3*length(Filaments(nf+1).iSites) + 1 + 3 + 3*Filaments(nf+1).N + 3*length(Filaments(nf).iSites) + 3 + 3*length(Filaments(nf).bSites));
    end
   end
end
   
% pull out base center data
if (BASEBOUND)
   for j=1:length(iterations)
        baseCenter1(j) = M(iterations(j), end-2);
        baseCenter2(j) = M(iterations(j), end-1);
        baseCenter3(j) = M(iterations(j), end-0);
   end
end
   
if(bLigands)
    indexStart = 7 + 4 + length(Filaments) + 3*length(Filaments(1).iSites) + 1 + 3 + 3*Filaments(1).N + 3*length(Filaments(1).iSites) + 3 + 1;
   for nf = 1:length(Filaments)
       for i=1:length(Filaments(nf).bSites)
           for j=1:length(iterations)
                Filaments(nf).bLigandCenter1(j,i) = M(iterations(j), indexStart + 0 + 3*(i-1));
                Filaments(nf).bLigandCenter2(j,i) = M(iterations(j), indexStart + 1 + 3*(i-1));
                Filaments(nf).bLigandCenter3(j,i) = M(iterations(j), indexStart + 2 + 3*(i-1));
           end
       end
       if(nf<length(Filaments))
            indexStart = indexStart + (4 + length(Filaments) + 3*length(Filaments(nf+1).iSites) + 1 + 3 + 3*Filaments(nf+1).N + 3*length(Filaments(nf+1).iSites) + 3 + 3*length(Filaments(nf).bSites));
       end
   end
end

% % convert to nanometers
% if(scale)
%     iLigandCenter1 = 0.3*iLigandCenter1;
%     iLigandCenter2 = 0.3*iLigandCenter2;
%     iLigandCenter3 = 0.3*iLigandCenter3;
% end

% pull out occupancy data
indexStart = 7 + 4 + length(Filaments) + 1;
for nf = 1:length(Filaments)
    for j=1:length(iterations)
        for i=1:length(Filaments(nf).iSites)
            Filaments(nf).occlusion(j,i) = M(iterations(j), indexStart);
        end
    end
    indexStart = indexStart + (4 + length(Filaments) + 3*length(Filaments(nf).iSites) + 1 + 3 + 3*Filaments(nf).N + 3*length(Filaments(nf).iSites) + 3 + 3*length(Filaments(nf).bSites));
end

[membraneX, membraneY, membraneZ] = meshgrid(-50:50,-50:50,0);

%% plot
for j=1:length(iterations)

    figure(1); clf; box on; hold on; view([51 12]);
    %set(gca, 'Color',[0.94, 0.94, 0.94]);
    switch(model)
        case 2
            set(gcf,'Position',[1 1 270 375]);
        case {4,5}
            view([-32.6 24.8]);
            set(gcf,'Position',[1065 148 1250 1197]);
        otherwise
            view([51,12]);
    end
    
    % plot filaments
    for nf = 1:length(Filaments)
        plot3(Filaments(nf).r1(j,1),Filaments(nf).r2(j,1),Filaments(nf).r3(j,1),'xk','MarkerSize',ms,'LineWidth',marker_lw);
        filamentPlot = plot3(Filaments(nf).r1(j,:),Filaments(nf).r2(j,:),Filaments(nf).r3(j,:));
        filamentPlot.LineStyle = '-';
        filamentPlot.LineWidth = lw;
        filamentPlot.Color = colors_fil(nf,:);
    end
    dim = [0.1 0.1 0.1 0.1];
    str = num2str(j);
    %annotation('textbox',dim,'String',str);
    set(gca, 'Color',[0.94, 0.94, 0.94]);
    set(gcf, 'Color','w');
    axis 'equal';
    
    % plot iSite Locations and kinase sphere
    for nf = 1:length(Filaments)
        
        % check if end of filaments is within figure bounds
        fig = plot3(Filaments(nf).r1(j,end),Filaments(nf).r2(j,end),Filaments(nf).r3(j,end),'.k','MarkerSize',ms);
        
        for i = 1:length(Filaments(nf).iSites)
            % label tyrosines with black square
            fig = plot3(Filaments(nf).r1(j,Filaments(nf).iSites(i)),Filaments(nf).r2(j,Filaments(nf).iSites(i)),Filaments(nf).r3(j,Filaments(nf).iSites(i)),'sk','MarkerSize',ms,'LineWidth',marker_lw);
                
            % plot ligand sphere in transparent yellow
            if (kinaseVisible)
                if(nf==2)
                if(i==1)
                    % plot ligand
                    [ligandX, ligandY, ligandZ] = ellipsoid(Filaments(nf).iLigandCenter1(j,i),Filaments(nf).iLigandCenter2(j,i),Filaments(nf).iLigandCenter3(j,i),irLigand,irLigand,irLigand);
                    ligand = surf(ligandX,ligandY,ligandZ);

                    % format ligand appearance
                    ellipsoidData = get(ligand,'zdata');
                    if (~Filaments(nf).occlusion(j,i))
                        ligand.FaceAlpha = 1;
                    else
                        ligand.FaceAlpha = 0.2;
                    end
                    ligand.EdgeAlpha = 0.3;
                    ligand.EdgeColor = [155/255 155/255 155/255];
                    ligand.FaceColor = [205/255 113/255 8/255];
                    ligand.FaceLighting = 'gouraud';
                    ligand.AmbientStrength = 0.3;
                    ligand.DiffuseStrength = 0.5;
                    ligand.SpecularStrength = 0.9;
                    ligand.SpecularExponent = 25;
                    ligand.BackFaceLighting = 'unlit';
                    lightangle(-45,30);
                end
                end
            end

        end
    end
    if(bLigands)
        for nf = 1:length(Filaments)
            for i = 1:length(Filaments(nf).bSites)
                % label tyrosines with red asterisk
                %fig = plot3(Filaments(nf).r1(j,Filaments(nf).bSites(i)),Filaments(nf).r2(j,Filaments(nf).bSites(i)),Filaments(nf).r3(j,Filaments(nf).bSites(i)),'*r');

                % plot ligand sphere in transparent green
                % need to move center of ligand to be ACTUAL center of ligand
                [ligandX, ligandY, ligandZ] = ellipsoid(Filaments(nf).bLigandCenter1(j,i),Filaments(nf).bLigandCenter2(j,i),Filaments(nf).bLigandCenter3(j,i),brLigand,brLigand,brLigand);
                ligand = surf(ligandX,ligandY,ligandZ);
                
                    ellipsoidData = get(ligand,'zdata');
                    set(ligand,'FaceAlpha',1);
                    set(ligand,'EdgeAlpha',0.3);
                    set(ligand,'EdgeColor',[155/255 155/255 155/255]);
                    set(ligand,'FaceColor',[205/255 113/255 8/255]);
                    %set(ligand, 'FaceLighting','Gouraud');
                    lightangle(-45,30)
                    ligand.FaceLighting = 'gouraud';
                    ligand.AmbientStrength = 0.3;
                    ligand.DiffuseStrength = 0.5;
                    ligand.SpecularStrength = 0.9;
                    ligand.SpecularExponent = 25;
                    ligand.BackFaceLighting = 'unlit';
            end
        end
    end
    if(BASEBOUND)
        % plot ligand sphere in transparent green
        if (kinaseVisible)
            % need to move center of ligand to be ACTUAL center of ligand
            [ligandX, ligandY, ligandZ] = ellipsoid(baseCenter1(j),baseCenter2(j),baseCenter3(j),baserLigand,baserLigand,baserLigand);
            ligand = surf(ligandX,ligandY,ligandZ);
            ellipsoidData = get(ligand,'zdata');
            set(ligand,'FaceAlpha',1);
            set(ligand,'EdgeAlpha',0.3);
            set(ligand,'EdgeColor',[155/255 155/255 155/255]);
            set(ligand,'FaceColor',[205/255 213/255 8/255]);
            %set(ligand, 'FaceLighting','Gouraud');
            lightangle(-45,30)
            ligand.FaceLighting = 'gouraud';
            ligand.AmbientStrength = 0.3;
            ligand.DiffuseStrength = 0.5;
            ligand.SpecularStrength = 0.9;
            ligand.SpecularExponent = 25;
            ligand.BackFaceLighting = 'unlit';
        end

    end
    if (membraneVisible)
        membranePlot = surf(membraneX, membraneY, membraneZ);
        membranePlot.EdgeColor = 'none';
        membranePlot.LineStyle = 'none';
        %membranePlot.LineWidth = 0.5;
        membranePlot.FaceAlpha = 0.7;
        %membranePlot.FaceColor = [0.6745 0.8588 0.9647];
        membranePlot.FaceColor = membraneColor;
        membranePlot.FaceLighting = 'none';
        
        switch(model)
            case {0,2}
                set(gca, 'xlim', axes, 'ylim', axes, 'zlim', [0 max([Filaments(:).N])-3]); 
            case 1
                set(gca, 'xlim', axes, 'ylim', axes, 'zlim', [-3 sqrt(max([Filaments(:).N]))+10]); 
            otherwise
                set(gca, 'xlim', axes, 'ylim', axes, 'zlim', [0 sqrt(max([Filaments(:).N]))+15]); 
        end
    else
        set(gca, 'xlim', axes, 'ylim', axes, 'zlim', axes);
    end
    
   if (scale)
       switch (model)
           case 2
               xticks([-110 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100 110]);
               xticklabels({'-33','-30','-27','-24','-21','-18','-15','-12','-9','-6','-3', '0','3','6','9','12','15','18','21','24','27','30','33'});
               xlabel('x (nm)','FontName','Arial','FontSize',18);

               yticks([-110 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100 110]);
               yticklabels({'-33','-30','-27','-24','-21','-18','-15','-12','-9','-6','-3', '0','3','6','9','12','15','18','21','24','27','30','33'});
               ylabel('y (nm)','FontName','Arial','FontSize',18);

               zticks([-110 -100 -90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90 100 110]);
               zticklabels({'-33','-30','-27','-24','-21','-18','-15','-12','-9','-6','-3', '0','3','6','9','12','15','18','21','24','27','30','33'});
               zlabel('z (nm)','FontName','Arial','FontSize',18);

           otherwise
               xticks([-50 -46.6666 -43.3333 -40 -36.6666 -33.3333 -30 -26.6666 -23.3333 -20 -16.6666 -13.3333 -10 -6.6666 -3.3333 0 3.3333 6.6666 10 13.3333 16.6666 20 23.3333 26.6666 30 33.3333 36.6666 40 43.3333 46.6666 50]);
               xticklabels({'-15','-14','-13','-12','-11','-10','-9','-8','-7','-6','-5','-4','-3', '-2', '-1', '0', '1', '2', '3','4','5','6','7','8','9','10','11','12','13','14','15'});
               xlabel('x (nm)','FontName','Arial','FontSize',18);

               yticks([-50 -46.6666 -43.3333 -40 -36.6666 -33.3333 -30 -26.6666 -23.3333 -20 -16.6666 -13.3333 -10 -6.6666 -3.3333 0 3.3333 6.6666 10 13.3333 16.6666 20 23.3333 26.6666 30 33.3333 36.6666 40 43.3333 46.6666 50]);
               yticklabels({'-15','-14','-13','-12','-11','-10','-9','-8','-7','-6','-5','-4','-3', '-2', '-1', '0', '1', '2', '3','4','5','6','7','8','9','10','11','12','13','14','15'});
               ylabel('y (nm)','FontName','Arial','FontSize',18);

               zticks([-50 -46.6666 -43.3333 -40 -36.6666 -33.3333 -30 -26.6666 -23.3333 -20 -16.6666 -13.3333 -10 -6.6666 -3.3333 0 3.3333 6.6666 10 13.3333 16.6666 20 23.3333 26.6666 30 33.3333 36.6666 40 43.3333 46.6666 50]);
               zticklabels({'-15','-14','-13','-12','-11','-10','-9','-8','-7','-6','-5','-4','-3', '-2', '-1', '0', '1', '2', '3','4','5','6','7','8','9','10','11','12','13','14','15'});
               zlabel('z (nm)','FontName','Arial','FontSize',18);
       end
   else
       xlabel('x (kuhn lengths)','FontName','Arial','FontSize',18);
       ylabel('y (kuhn lengths)','FontName','Arial','FontSize',18);
       zlabel('z (kuhn lengths)','FontName','Arial','FontSize',18);
   end
    
    if (movie)
        frame = getframe(gcf);
        writeVideo(Visual3D, frame);
    end
    
    hold off;
end

% close movie
if (movie)
    close(Visual3D);
end

%% Save Final Frame as Snapshot - with Labels

if(saveFinalFrame)
    savename = erase(filename,'.txt');
    savename = [savename,'Labels'];
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'pdf');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end

%% Save Final Frame as Snapshot - without Labels

finalFrame = gcf;
finalFrameAxes = gca;
set(finalFrameAxes,'XLabel',[]);
set(finalFrameAxes,'YLabel',[]);
set(finalFrameAxes,'ZLabel',[]);
set(finalFrameAxes,'XTickLabel',[]);
set(finalFrameAxes,'YTickLabel',[]);
set(finalFrameAxes,'ZTickLabel',[]);

if(saveFinalFrame)
    savename = erase(filename,'.txt');
    savename = [savename,'NoLabels'];
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'pdf');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end
    
    
