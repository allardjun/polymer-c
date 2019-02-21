%% Analysis_TransitionMatrix

%% lclemens@uci.edu
clear all;
close all;

%% Initialize model

% Pick model
spacing = 0; % 0 = CD3Zeta, 1 = EvenSites, 2 = TCR
membrane = 1; % 0 for membrane off, 1 for membrane on
model = 10; % 1x = LocalStructuring, 3x = Simultaneous Binding

% 10 = Local Structuring

% 30 = Simultaneous Binding SH2

% Save Transition Matrices and Figures
writeTransitionMatrix = 0; % 0 = do not create transitionMatrix files, 1 = create transitionMatrix files
saveTF = 0;

%% 

%savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures';
savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/';

switch (spacing)
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'TCR';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

%% Set parameters for model

switch (model)
    
    case 10
        % model name
        modelName = 'LocalStructuring';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/1.LocalStructuring';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/1.OcclusionProbabilities/CatFiles'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/1.LocalStructuring';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState];
        
        % 
        locationTotal = 6;
        NFil = 1;
        iSiteTotal(1:NFil) = [6];
        sweep = -1:1:103;
        %sweep = -1:1:103;
        %sweep = [-1 1:2:15 19:6:103];
        sweepParameter = 'StiffenRange';
        
        % figure parameters
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        colorIndices = sweep+2;
        colors = flipud(cool(max(sweep)+2));
        ms = 10;
        lw = 2;
        modificationLabel = '(Phosphorylated)';
        
    case 30
        % model name
        modelName = 'SimultaneousBindingSH2';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SH2/1.OcclusionProbabilities/CatFiles'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SH2/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/SH2'];
        
        % 
        locationTotal = 6;
        NFil = 1;
        iSiteTotal(1:NFil) = [6];
        sweep = 1:1:14;
        sweepParameter = 'irLigand';
        
        % figure parameters
        legendlabels = {'irLigand = 1','irLigand = 2','irLigand = 3','irLigand = 4','irLigand = 5','irLigand = 6','irLigand = 7','irLigand = 8','irLigand = 9','irLigand = 10','irLigand = 11','irLigand = 12','irLigand = 13','irLigand = 14'};
        colorIndices = sweep;
        colors = flipud(cool(max(sweep)));
        lw = 2;
        ms = 10;
        modificationLabel = '(Bound)';
        
    case 31
        
        % model name
        modelName = 'SimultaneousBindingibEqual';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/ibEqual/1.OcclusionProbabilities/CatFiles'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/ibEqual/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/ibEqual'];
        
        % 
        locationTotal = 6;
        NFil = 1;
        iSiteTotal(1:NFil) = [6];
        sweep = 1:1:7;
        sweepParameter = 'ibRadius';
        
        % figure parameters
        legendlabels = {'ibRadius = 1','ibRadius = 2','ibRadius = 3','ibRadius = 4','ibRadius = 5','ibRadius = 6','ibRadius = 7','ibRadius = 8','ibRadius = 9','ibRadius = 10','ibRadius = 11','ibRadius = 12','ibRadius = 13','ibRadius = 14'};
        colorIndices = sweep;
        colors = flipud(cool(max(sweep)));
        ms = 10;
        lw = 2;
        modificationLabel = '(Bound)';
        
     case 32
        
        % model name
        modelName = 'SimultaneousBindingCoarseGrainibEqual';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/CoarseGrainibEqual/1.OcclusionProbabilities/CatFiles'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/CoarseGrainibEqual/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/CoarseGrainibEqual'];
        
        % 
        locationTotal = 3;
        NFil = 1;
        iSiteTotal(1:NFil) = [3];
        sweep = 1:1:14;
        sweepParameter = 'ibRadius';
        
        % figure parameters
        legendlabels = {'ibRadius = 1','ibRadius = 2','ibRadius = 3','ibRadius = 4','ibRadius = 5','ibRadius = 6','ibRadius = 7','ibRadius = 8','ibRadius = 9','ibRadius = 10','ibRadius = 11','ibRadius = 12','ibRadius = 13','ibRadius = 14'};
        colorIndices = sweep;
        colors = flipud(cool(max(sweep)));
        ms = 10;
        lw = 2;
        modificationLabel = '(Bound)';
        
    case 33 % TCR - separation distance 5 Kuhn
        
        % model name
        modelName = 'SimultaneousBindingibEqual';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SepDist5/1.OcclusionProbabilities/CatFiles'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SepDist5/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/SepDist5'];
        
        % 
        locationTotal = 10;
        NFil = 6;
        iSiteTotal(1:NFil) = [1 1 3 3 1 1];
        sweep = 1:1:10;
        sweepParameter = 'ibRadius';
        
        % figure parameters
        legendlabels = {'ibRadius = 1','ibRadius = 2','ibRadius = 3','ibRadius = 4','ibRadius = 5','ibRadius = 6','ibRadius = 7','ibRadius = 8','ibRadius = 9','ibRadius = 10','ibRadius = 11','ibRadius = 12','ibRadius = 13','ibRadius = 14'};
        colorIndices = sweep;
        colors = flipud(cool(max(sweep)));
        ms = 10;
        lw = 2;
        modificationLabel = '(Bound)';
        
        
end


%% Initialize variables

sumRates = zeros(length(sweep),locationTotal,2);
avgRates = zeros(length(sweep),locationTotal,2);

%% Create transition matrices, calculate average binding rates

for s = 1:length(sweep)
    % choose file
    filename = strcat(filetitle,sweepParameter,'.',num2str(sweep(s)),'.cat');
    disp(filename);
    
    % initialize 
    OccupiedLocations = zeros(2^locationTotal,1);
    OccupiedLocationsMatrix = zeros(2^locationTotal,locationTotal);
    OccupiedLocationsDecimal = zeros(2^locationTotal,1);
    POcc = zeros(2^locationTotal,locationTotal);
    PBind = zeros(2^locationTotal,locationTotal);
    PBindKinase = zeros(2^locationTotal,locationTotal);
    POcc_NumSites = zeros(2^locationTotal,locationTotal+1);
    PAvail_NumSites = zeros(2^locationTotal,locationTotal+1);
    
    %% Read from File

    %readData_TransitionMatrix(filefolder,filesubfolder,filename);
    
    M = dlmread(fullfile(filefolder,filesubfolder, filename));

    OccupiedLocations = M(:,end);

    OccupiedLocationsMatrix(:,1:locationTotal) = M(:,(end-locationTotal):(end-1));

    % up to total number of iSites - 6 for mouse CD3Zeta
    siteCounter = 1;
    
    % starting index - 8+2*(locationTotal+1) is output only once, 6+2 takes
    % us to the correct index in the filament output
    ind = 8+2*(locationTotal+1)+6+2; 
    for nf = 1:NFil
        
        if(nf>1)
            ind = ind + (6 + 7*iSiteTotal(nf-1) + 2 + NFil + NFil);
        end
        
        for iy = 1:iSiteTotal(nf)
            POcc(:,siteCounter) = M(:,ind + 7*(iy-1));
            siteCounter = siteCounter + 1;
        end
    end
    PBind(:,1:locationTotal) = 1-POcc(:,1:locationTotal);
    
    POcc_NumSites(:,1:locationTotal+1) = M(:,8+(1:(locationTotal+1)));
    PAvail_NumSites(:,1:locationTotal+1) = M(:,8+(locationTotal+1)+(1:(locationTotal+1)));
    
    %% Convert binary to decimal
    
    for j=1:2^locationTotal
        binaryString = num2str(OccupiedLocations(j));
        OccupiedLocationsDecimal(j) = bin2dec(binaryString);
    end
    
    %% Create kinase transitionMatrix (forward binding) and Phosphatase transitionMatrix (reverse binding)
    
    PBindKinase = PBind.*(~OccupiedLocationsMatrix);
    PBindPhosphatase = PBind.*(OccupiedLocationsMatrix);
    for j=1:2^locationTotal
        PBindKCorrectOrder(OccupiedLocationsDecimal(j)+1,:) = PBindKinase(j,:);
        PBindPCorrectOrder(OccupiedLocationsDecimal(j)+1,:) = PBindPhosphatase(j,:);
    end
    KinaseTransition = fliplr(PBindKCorrectOrder);
    PhosphataseTransition = fliplr(PBindPCorrectOrder);
    AllTransition = KinaseTransition+PhosphataseTransition;
    AllTransition2 = PBindKinase + PBindPhosphatase;
    
    PhosphataseTransitionInverted = flipud(PhosphataseTransition);
    
    %% Calculate total possible ways to transition from State i to State i+1
    for i=1:locationTotal
        totalRates(i) = nchoosek(locationTotal,i-1).*(locationTotal-(i-1));
    end
    
    
    %% Create 2^locationTotal x 2^locationTotal matrix of rates
    
    binaryArray = de2bi(0:1:2^locationTotal-1,'left-msb');
    
    rateMatrix = zeros(2^locationTotal,2^locationTotal);
    kinaseRateMatrix = zeros(2^locationTotal,2^locationTotal);
    phosphataseRateMatrix = zeros(2^locationTotal,2^locationTotal);
    
    for i=1:2^locationTotal
        for j=1:2^locationTotal
            if(sum(xor(binaryArray(i,:),binaryArray(j,:)))==1)
                transitionIndex = find(xor(binaryArray(i,:),binaryArray(j,:)));
                rateMatrix(i,j) = AllTransition2(i,transitionIndex); % insert rate into appropriate location
                if(j>i)
                    kinaseRateMatrix(i,j)       = AllTransition2(i,transitionIndex);
                else
                    phosphataseRateMatrix(i,j)  = AllTransition2(i,transitionIndex);
                end
            end
        end
    end
    
    % debugging
    if(1)
        if(sum(sum(rateMatrix-(kinaseRateMatrix+phosphataseRateMatrix)))~=0)
            disp('Error!!');
        end
    end
    
    %% Write to File
    if(writeTransitionMatrix)
        
        % Create save name for transition matrix
        savefilenameK = strcat(modelName,iSiteSpacing,'Membrane',membraneState,'.Kinase','.',num2str(sweep(s)));
        savefilenameP = strcat(modelName,iSiteSpacing,'Membrane',membraneState,'.Phosphatase','.',num2str(sweep(s)));
        savefilenamePInv = strcat(modelName,iSiteSpacing,'Membrane',membraneState,'.PhosphataseInv','.',num2str(sweep(s)));
        
        % Save full matrix - for Reversible Gillespie
        dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'FullMatrix',savefilenameK),kinaseRateMatrix,'\n');
        dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'FullMatrix',savefilenameP),phosphataseRateMatrix,'\n');
        
        % Save just POcc/PBind for Irreversible Gillespie
        dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'Phos',savefilenameK),KinaseTransition,'\n');
        dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'Dephos',savefilenameP),PhosphataseTransition,'\n');
        dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'Dephos',savefilenamePInv),PhosphataseTransitionInverted,'\n');
    end
    
    %% Calculate average rates of transition from one state to next

    for j=1:2^locationTotal % for each state (i.e. 010010)
        totalOccupied(1) = size(find(KinaseTransition(j,:)==0),2); % find number of 0 entries (aka phosphorylated sites)
        totalOccupied(2) = size(find(PhosphataseTransition(j,:)==0),2); % find number of 0 entries (aka unphosphorylated sites)
        if(totalOccupied(1)<locationTotal) % if not completely occupied
            sumRates(s,totalOccupied(1)+1,1) = sumRates(s,totalOccupied(1)+1,1)+sum(KinaseTransition(j,:));
        end
        if(totalOccupied(2)<locationTotal)
            sumRates(s,totalOccupied(2)+1,2) = sumRates(s,totalOccupied(2)+1,2)+sum(PhosphataseTransition(j,:));
        end
    end
        
    % find average rates of transition from one state to another
    avgRates(s,:,1) = sumRates(s,:,1)./totalRates;
    avgRates(s,:,2) = sumRates(s,:,2)./totalRates;

end

%%






























%% Plot Cooperativity - Phosphorylation no Labels

figure(1); clf; hold on; box on;
for s = 1:length(sweep)
    plotColor = colorIndices(s);
    plotData = reshape(avgRates(s,:,1),[1 locationTotal]);
    plot(1:1:locationTotal,plotData,'-s','LineWidth',lw,'Color',colors(plotColor,:),'MarkerFaceColor',colors(plotColor,:));
end
% set first position - 2.5in by 2.5in with no labels
switch (model)
    case 1 % stiff
        %set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([0.02,0.045]); % CD3ZetaMembrane0
            else
                ylim([0.01,0.035]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([0.02, 0.035]); % EvenSitesMembrane0
                set(gca,'YTick',[0.02, 0.025,0.03, 0.035]);
            else
                ylim([0.01,0.03]); % EvenSitesMembrane1
                set(gca,'YTick',[0.01,0.015,0.02, 0.025,0.03]);
            end
        end
    case 2 % sim bind SH2
        if(~spacing)
            if(~membrane)
                ylim([0,1]); % CD3ZetaMembrane0
            else
                ylim([0,1]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([0,1]); % EvenSitesMembrane0
            else
                ylim([0,1]); % EvenSitesMembrane1
            end
        end 
    case 3 % sim bind SH2
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-4),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-4),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-4),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-4),10^0]); % EvenSitesMembrane1
            end
        end        
    case {4,6} % sim bind ibEqual
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-4),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-4),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-4),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-4),10^0]); % EvenSitesMembrane1
            end
        end 
     case 5 % sim bind ibEqual
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-5),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-5),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-5),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-5),10^0]); % EvenSitesMembrane1
            end
        end  
      case 7 % sim bind ibEqual TCR
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-5),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-5),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-5),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-5),10^0]); % EvenSitesMembrane1
            end
        end   
      case 8 % sim bind ibEqual TCR
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-3),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-3),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-3),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-3),10^0]); % EvenSitesMembrane1
            end
        end  
end
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(saveTF)
    switch model
        case 2
            figure(1);
            savesubsubfolder = 'Phos';
            savefilename = 'AvgBindVSTotalModifiedFullStiffenRange';
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');
        otherwise
            figure(1);
            savesubsubfolder = 'Phos';
            savefilename = 'AvgBindVSTotalModified';
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');
    end
end

%% Plot Cooperativity - Phosphorylation with Labels
figure(10); clf; hold on; box on;
for s = 1:length(sweep)
    plotColor = colorIndices(s);
    plotData = reshape(avgRates(s,:,1),[1 locationTotal]);
    plot(1:1:locationTotal,plotData,'-s','LineWidth',lw,'Color',colors(plotColor,:),'MarkerFaceColor',colors(plotColor,:),'MarkerSize',ms);
end
% set axis labels and scales
set(gca,'XTick',1:1:locationTotal);
set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6', '6 -> 7', '7 -> 8', '8 -> 9', '9 -> 10'});
xlabel1 = {['Number of Modified Sites'],modificationLabel};
ylabel1 = {['Average Binding Rate'],['(per free space binding)']};
title1 = 'Average Binding Rate vs Total Modified Sites';
switch (model)
    case 1 % stiff
        %set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([0.02,0.045]); % CD3ZetaMembrane0
            else
                ylim([0.01,0.035]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([0.02, 0.035]); % EvenSitesMembrane0
                set(gca,'YTick',[0.02, 0.025,0.03, 0.035]);
            else
                ylim([0.01,0.03]); % EvenSitesMembrane1
                set(gca,'YTick',[0.01,0.015,0.02, 0.025,0.03]);

            end
        end
    case 2 % sim bind SH2
        if(~spacing)
            if(~membrane)
                ylim([0,1]); % CD3ZetaMembrane0
            else
                ylim([0,1]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([0,1]); % EvenSitesMembrane0
            else
                ylim([0,1]); % EvenSitesMembrane1
            end
        end 
    case 3 % sim bind SH2
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-4),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-4),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-4),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-4),10^0]); % EvenSitesMembrane1
            end
        end        
    case {4,6} % sim bind ibEqual
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-4),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-4),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-4),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-4),10^0]); % EvenSitesMembrane1
            end
        end    
     case 5 % sim bind ibEqual
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-5),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-5),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-5),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-5),10^0]); % EvenSitesMembrane1
            end
        end  
        
      case 7 % sim bind ibEqual TCR
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-5),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-5),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-5),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-5),10^0]); % EvenSitesMembrane1
            end
        end   
      case 8 % sim bind ibEqual TCR
        set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([10^(-3),10^0]); % CD3ZetaMembrane0
            else
                ylim([10^(-3),10^0]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([10^(-3),10^0]); % EvenSitesMembrane0
            else
                ylim([10^(-3),10^0]); % EvenSitesMembrane1
            end
        end  
end

% set second position and show labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[[1,1],30,25]);
set(gca,'FontName','Arial','FontSize',18);
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);

% set colorbar parameters based on model
switch (model)
    case 1
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 7/9],'TickLabels',{'',''},'YDir','reverse');
        set(h,'ylim',[0 7/9]);
    case 2
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    case 3
    case 4
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 7/9],'TickLabels',{'',''},'YDir','reverse');
        set(h,'ylim',[0 7/9]);
    case 5
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
        set(h,'ylim',[0 1]);
end

% save figure with labels attached
if(saveTF)
    switch model
        case 2
            figure(10);
            savesubsubfolder = 'Phos';
            savefilename = 'AvgBindVSTotalModifiedLabelsFullStiffenRange';
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');

        otherwise
            figure(10);
            savesubsubfolder = 'Phos';
            savefilename = 'AvgBindVSTotalModifiedLabels';
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');
    end
end

%% Plot Cooperativity - Dephosphorylation no Labels
figure(2); clf; hold on; box on;
for s = 1:length(sweep)
    plotData = reshape(avgRates(s,:,2),[1 locationTotal]);
    plot(1:1:locationTotal,plotData,'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
end
% set first position - 2.5in by 2.5in with no labels
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(saveTF)
        switch model
            case 2
                figure(2);
                savesubsubfolder = 'Dephos';
                savefilename = 'AvgBindVSTotalModifiedFullStiffenRange';
                saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
                saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');

            otherwise
                figure(2);
                savesubsubfolder = 'Dephos';
                savefilename = 'AvgBindVSTotalModified';
                saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
                saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');
        end
end

%% Plot Cooperativity - Dephosphorylation with Labels
figure(20); clf; hold on; box on;
for s = 1:length(sweep)
    plotData = reshape(avgRates(s,:,2),[1 locationTotal]);
    plot(1:1:locationTotal,plotData,'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
end
% set axis labels and scale
set(gca,'XTick',1:1:locationTotal);
set(gca,'XTickLabel',{'6 -> 5','5 -> 4','4 -> 3','3 -> 2','2 -> 1','1 -> 0'});
title1 = 'Average Binding Rate vs Total Modified Sites';
xlabel1 = {['Number of Modified Sites'],modificationLabel};
ylabel1 = {['Average Binding Rate'],['(per free space binding)']};

% set second position and show labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[[1,1],30,25]);
set(gca,'FontName','Arial','FontSize',18);
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);
switch (model)
    case 1
        %set(gca,'YScale','log');
        if(~spacing)
            if(~membrane)
                ylim([0,0.7]); % CD3ZetaMembrane0
            else
                ylim([0,0.6]); % CD3ZetaMembrane1
            end
        else
            if(~membrane)
                ylim([0, 0.6]); % EvenSitesMembrane0
            else
                ylim([0,0.5]); % EvenSitesMembrane1
            end
        end

    case 3
        set(gca,'YScale','log');
    case 4
        set(gca,'YScale','log');
    case 5
        set(gca,'YScale','log');
end

% set colorbar parameters
switch (model)
    case 1
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 7/9],'TickLabels',{'',''},'YDir','reverse');
        set(h,'ylim',[0 7/9]);
    case 3
    case 4
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 7/9],'TickLabels',{'',''},'YDir','reverse');
        set(h,'ylim',[0 7/9]);
    case 5
        set(gcf,'Colormap',cool)
        colormap cool;
        h = colorbar;
        h = colorbar('Ticks',[0 7/9],'TickLabels',{'',''},'YDir','reverse');
        set(h,'ylim',[0 7/9]);
end

if(saveTF)
    switch model
        case 2
            figure(20);
            savesubsubfolder = 'Dephos';
            savefilename = 'AvgBindVSTotalModifiedLabelsFullStiffenRange';
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');

        otherwise
            figure(20);
            savesubsubfolder = 'Dephos';
            savefilename = 'AvgBindVSTotalModifiedLabels';
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'fig');
            saveas(gcf,fullfile(savefilefolder,savesubfolder,savesubsubfolder,savefilename),'epsc');
    end
end


