%% Analysis_TransitionMatrix

%% lclemens@uci.edu
clear all;
close all;

%% Initialize

% initialization switch for which model we're inspecting
writeTransitionMatrix = 0; % 0 = do not create transitionMatrix files, 1 = create transitionMatrix files
spacing = 0; %  0 = EvenSites, 1 = CD3Zeta, 2 = CD3Epsilon
membrane = 1; % 0 for membrane off, 1 for membrane on
model = 3; % 1 = stiffening, 2 = multiple binding, 3 = electrostatics
saveTF = 0;

%%

switch (spacing)
    case 0
        iSiteSpacing = 'EvenSites';
    case 1
        iSiteSpacing = 'CD3Zeta';
    case 2
        iSiteSpacing = 'CD3Epsilon';
end

switch (model)
    
        
    case 2
        filefolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = 'CD3Zeta/MembraneOn/1.OcclusionProbabilities/CatFiles';
        
        filetitle = 'CD3ZetaElectrostaticsPhosphorylation';
        locationTotal = 6;
        phosSites = 6;
        transitionMatrixfolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        transitionMatrixsubfolder = 'CD3Zeta/MembraneOn/2.TransitionMatrices/';
        transitionMatFilename = 'CD3Zeta_MembraneAssociation_EP0Sweep';
        sweep = 0:2:20;
        
        savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/CD3Zeta/MembraneOn/';

        
        % figure parameters
        legendlabels = {'EP0 = 0','EP0 = 1','EP0 = 2','EP0 = 3','EP0 = 4','EP0 = 5','EP0 = 6'};
        colors = parula(11);
        lw = 2;
        ms = 6;
        modificationLabel = '(Phosphorylated)';
        
    
    case 3
        filefolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = 'CD3Epsilon/MembraneOn/TwoSites/1.OcclusionProbabilities/CatFiles';
        
        savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/CD3Epsilon/MembraneOn/';
        
        filetitle = 'CD3EpsilonElectrostaticsPhosphorylation';
        locationTotal = 2;
        phosSites = 2;
        transitionMatrixfolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        transitionMatrixsubfolder = 'CD3Epsilon/MembraneOn/TwoSites/2.TransitionMatrices/';
        transitionMatFilename = 'CD3Epsilon_MembraneAssociation_EP0Sweep';
        sweep = 0:1:40;

        
        % figure parameters
        legendlabels = {'EP0 = 0','EP0 = 1','EP0 = 2','EP0 = 3','EP0 = 4','EP0 = 5','EP0 = 6'};
        colors = parula(11);
        lw = 2;
        ms = 6;
        modificationLabel = '(Phosphorylated)';
    
    case 4
        filefolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = 'CD3Epsilon/MembraneOn/FiveSites/1.OcclusionProbabilities/CatFiles';
        
        
        savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/CD3Epsilon/MembraneOn/FiveSites';

        filetitle = 'CD3EpsilonElectrostaticsPhosphorylation';
        locationTotal = 5;
        phosSites = 2;
        transitionMatrixfolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        transitionMatrixsubfolder = 'CD3Epsilon/MembraneOn/2.TransitionMatrices/';
        transitionMatFilename = 'CD3Epsilon_MembraneAssociation_EP0Sweep';
        sweep = 0:2:20;

        
        % figure parameters
        legendlabels = {'EP0 = 0','EP0 = 1','EP0 = 2','EP0 = 3','EP0 = 4','EP0 = 5','EP0 = 6'};
        colors = parula(11);
        lw = 2;
        ms = 6;
        modificationLabel = '(Phosphorylated)';
        
end

%% create matrix to show correspondance between model number and parameters

WallK = 0.05;
ParabD = 0.5;
ParabW = ParabD/9;
Erepul = 0.5+0.5*(sweep-1);
Zrepul = 3;
params = zeros(20,5);
% WK, PD, PW, ER, ZR
params(:,1) = WallK;
it = 1;
for i=1:length(ParabW)
    for j=1:length(Erepul)
        for k=1:length(Zrepul)
            params(it,2)  = ParabD(i);
            params(it,3) = ParabW(i);
            params(it,4) = Erepul(j);
            params(it,5) = Zrepul(k);
            it=it+1;
        end
    end
end
%%

%% Initialize variables

sumRates = zeros(length(sweep),phosSites,2);
avgRates = zeros(length(sweep),phosSites,2);
%%
CompleteData = [];
for s = 1:length(sweep)
    
    if (s==0)
        filename = strcat(filetitle,'.',num2str(sweep(s)),'.cat.txt'); % Control
    else
        filename = strcat(filetitle,'.',num2str(sweep(s)),'.cat.txt');
    end
    
    
    %% Create transition matrices, calculate average binding rates
    
    disp(filename);
    
    % initialize
    OccupiedLocations = zeros(2^phosSites,1);
    OccupiedLocationsMatrix = zeros(2^phosSites,locationTotal);
    OccupiedLocationsDecimal = zeros(2^phosSites,1);
    POcc = zeros(2^phosSites,locationTotal);
    PBind = zeros(2^phosSites,locationTotal);
    PBindKinase = zeros(2^phosSites,locationTotal);
    
    %% Read from File
    
    M = dlmread(fullfile(filefolder,filesubfolder, filename));
    if (size(M,1)~=2^phosSites)
        disp(strcat('Incomplete Data!',filename));
    else
        
        CompleteData = [CompleteData, s];
        
        OccupiedLocations = M(:,end);
        
        switch model
            case {2}
                OccupiedLocationsMatrix(:,1:6) = M(:,1:6);
                % up to total number of iSites - 6 for mouse CD3Zeta
                POcc(:,1:6) = M(:,18+(0:1:5)*5);

            case {3}
                OccupiedLocationsMatrix(:,1:locationTotal) = M(:,end-locationTotal:end-1);
                % up to total number of iSites - locationTotal for mouse CD3Epsilon
                POcc(:,1:locationTotal) = M(:,8+2*(locationTotal+1)+6+2+(0:1:(locationTotal-1))*7);
                
            case {4}
                OccupiedLocationsMatrix(:,1:locationTotal) = M(:,(end-locationTotal):(end-1));
                
                % up to total number of iSites - 6 for mouse CD3Zeta
                POcc(:,1:locationTotal) = M(:,16+2*locationTotal+(0:1:(locationTotal-1))*7);   
        end
        
        PBind(:,1:locationTotal) = 1-POcc(:,1:locationTotal);
        
        %% Convert binary to decimal
        
        for j=1:2^phosSites
            binaryString = num2str(OccupiedLocations(j));
            disp(binaryString);
            OccupiedLocationsDecimal(j) = bin2dec(binaryString);
        end

        disp(OccupiedLocationsDecimal);
        
        %% Create kinase transitionMatrix (forward binding) and Phosphatase transitionMatrix (reverse binding)
        
        PBindKinase = PBind.*(~OccupiedLocationsMatrix);
        PBindPhosphatase = PBind.*(OccupiedLocationsMatrix);
        for j=1:2^phosSites
            PBindKCorrectOrder(OccupiedLocationsDecimal(j)+1,:) = PBindKinase(j,:);
            PBindPCorrectOrder(OccupiedLocationsDecimal(j)+1,:) = PBindPhosphatase(j,:);
        end
        KinaseTransition = fliplr(PBindKCorrectOrder);
        PhosphataseTransition = fliplr(PBindPCorrectOrder);
        AllTransition = KinaseTransition+PhosphataseTransition;
        AllTransition2 = PBindKinase + PBindPhosphatase;
        
        PhosphataseTransitionInverted = flipud(PhosphataseTransition);
        
        %% Calculate total possible ways to transition from State i to State i+1
        for i=1:phosSites
            totalRates(i) = nchoosek(phosSites,i-1).*(phosSites-(i-1));
        end
        
        
        %% Create 2^phosSites x 2^phosSites matrix of rates
        
        binaryArray = de2bi(0:1:2^phosSites-1,'left-msb');
        
        rateMatrix = zeros(2^phosSites,2^phosSites);
        kinaseRateMatrix = zeros(2^phosSites,2^phosSites);
        phosphataseRateMatrix = zeros(2^phosSites,2^phosSites);
        
        for i=1:2^phosSites
            for j=1:2^phosSites
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
            if (sweep(s)==-1)
                savefilenameK = strcat(transitionMatFilename,'.Kinase','.','Control');
                savefilenameP = strcat(transitionMatFilename,'.Phosphatase','.','Control');
                savefilenamePInv = strcat(transitionMatFilename,'.PhosphataseInv','.','Control');
            else
                savefilenameK = strcat(transitionMatFilename,'.Kinase','.',num2str(sweep(s)));
                savefilenameP = strcat(transitionMatFilename,'.Phosphatase','.',num2str(sweep(s)));
                savefilenamePInv = strcat(transitionMatFilename,'.PhosphataseInv','.',num2str(sweep(s)));
            end
            
            dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'FullMatrix',savefilenameK),kinaseRateMatrix,'\n');
            dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'FullMatrix',savefilenameP),phosphataseRateMatrix,'\n');
            
            dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'Phos',savefilenameK),KinaseTransition,'\n');
            dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'Dephos',savefilenameP),PhosphataseTransition,'\n');
            dlmwrite(fullfile(transitionMatrixfolder,transitionMatrixsubfolder,'Dephos',savefilenamePInv),PhosphataseTransitionInverted,'\n');
        end
        
        %% Calculate average rates of transition from one state to next
        
        for j=1:2^phosSites % for each state (i.e. 010010)
            totalOccupied(1) = size(find(KinaseTransition(j,:)==0),2); % find number of 0 entries (aka phosphorylated sites)
            totalOccupied(2) = size(find(PhosphataseTransition(j,:)==0),2); % find number of 0 entries (aka unphosphorylated sites)
            if(totalOccupied(1)<phosSites) % if not completely occupied
                sumRates(s,totalOccupied(1)+1,1) = sumRates(s,totalOccupied(1)+1,1)+sum(KinaseTransition(j,:));
            end
            if(totalOccupied(2)<phosSites)
                sumRates(s,totalOccupied(2)+1,2) = sumRates(s,totalOccupied(2)+1,2)+sum(PhosphataseTransition(j,:));
            end
        end
        
        % find average rates of transition from one state to another
        avgRates(s,:,1) = sumRates(s,:,1)./totalRates;
        avgRates(s,:,2) = sumRates(s,:,2)./totalRates;
        
    end
end

%% Plot Cooperativity - Phosphorylation no Labels

figure(1); clf; hold on; box on;
for s = 1:length(sweep)
    plotData = reshape(avgRates(s,:,1),[1 phosSites]);
    plot(1:1:phosSites,plotData,'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
end
% set first position - 2.5in by 2.5in with no labels
switch model
    case 0
    case {2,4}
        ylim([0.005 0.02]);
        yticks([0.005 0.01 0.015 0.02]);
    case 3
        ylim([0.008 0.016]);
        yticks([0.008 0.01 0.012 0.014 0.016]);
end
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(saveTF)
    figure(1);
    savesubfolder = 'Phos';
    savefilename = 'AvgBindVSTotalModified';
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'epsc');
end

%% Plot Cooperativity - Phosphorylation with Labels
figure(10); clf; hold on; box on;
for s = 1:length(sweep)
    plotData = reshape(avgRates(s,:,1),[1 phosSites]);
    plot(1:1:phosSites,plotData,'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
end
% set axis labels and scales
switch model
    case 0
    case {2,4}
        ylim([0.005 0.02]);
        yticks([0.005 0.01 0.015 0.02]);
        set(gca,'YTickLabel',{'0.005','0.01','0.015','0.02'});
    case 3
        ylim([0.008 0.016]);
        yticks([0.008 0.01 0.012 0.014 0.016]);
        set(gca,'YTickLabel',{'0.008','0.010','0.012','0.014','0.016'});
end
set(gca,'YTickLabel',{'0.005','0.01','0.015','0.02'});
set(gca,'XTick',1:1:phosSites);
set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6'});
xlabel1 = {['Number of Modified Sites'],modificationLabel};
ylabel1 = {['Average Binding Rate'],['(per free space binding)']};
title1 = 'Average Binding Rate vs Total Modified Sites';

% set second position and show labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[[1,1],30,25]);
set(gca,'FontName','Arial','FontSize',18);
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);

% set colorbar parameters based on model
set(gcf,'Colormap',parula)
colormap parula;
h = colorbar;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
set(h,'ylim',[0 1]);

% save figure with labels attached
if(saveTF)
    figure(10);
    savesubfolder = 'Phos';
    savefilename = 'AvgBindVSTotalModifiedLabels';
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'epsc');
end

%% Plot Cooperativity - Dephosphorylation no Labels
figure(2); clf; hold on; box on;
for s = 1:length(sweep)
    plotData = reshape(avgRates(s,:,2),[1 phosSites]);
    plot(1:1:phosSites,plotData,'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
end
% set first position - 2.5in by 2.5in with no labels
ylim([0 0.04]);
yticks([0 0.005 0.01 0.015 0.02 0.025 0.03 0.04]);
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(saveTF)
    figure(2);
    savesubfolder = 'Dephos';
    savefilename = 'AvgBindVSTotalModified';
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'epsc');
end

%% Plot Cooperativity - Dephosphorylation with Labels
figure(20); clf; hold on; box on;
for s = 1:length(sweep)
    plotData = reshape(avgRates(s,:,2),[1 phosSites]);
    plot(1:1:phosSites,plotData,'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
end
% set axis labels and scale
set(gca,'XTick',1:1:phosSites);
set(gca,'XTickLabel',{'6 -> 5','5 -> 4','4 -> 3','3 -> 2','2 -> 1','1 -> 0'});
ylim([0 0.04]);
yticks([0 0.005 0.01 0.015 0.02 0.025 0.03 0.035 0.04]);
yticklabels({'0','','0.01','','0.02','','0.03','','0.04'});
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

% set colorbar parameters
set(gcf,'Colormap',parula)
colormap parula;
h = colorbar;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
set(h,'ylim',[0 1]);


if(saveTF)
    figure(20);
    savesubfolder = 'Dephos';
    savefilename = 'AvgBindVSTotalModifiedLabels';
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,savefilename),'epsc');
end


