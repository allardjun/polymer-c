%% Analysis_TransitionMatrix

%% lclemens@uci.edu
clear all;
close all;

%% Initialize model

% Pick model
spacing = 2; % 0 = CD3Zeta, 1 = EvenSites, 2 = TCR, 3 = CD3Epsilon
membrane = 1; % 0 for membrane off, 1 for membrane on
itam = 0; % 0 - End, 1 - Mid (only for Filament Sweep - model 40,41)
model = 40; % 1x = LocalStructuring, 2x = Membrane Association, 3x = Simultaneous Binding

% 10 = Local Structuring
% 20 = Membrane Association
% 30 = Simultaneous Binding SH2
% 40 = Filament Sweep

% Save Figures
saveTF = 0;

%%

%savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures';
savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures';
%savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/';

% from driveM file
NTCHECK = 200000;

switch (spacing)
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'TCR';
    case 3
        iSiteSpacing = 'CD3Epsilon';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

switch (itam)
    case 0
        itamLoc = 'End';
    case 1
        itamLoc = 'Mid';
end

%% Set parameters for model

switch (model)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 40 % Filament Sweep - separation distance 5
        
        % model name
        modelName = 'SimultaneousBinding';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist5/','ITAM_',itamLoc,'/1.OcclusionProbabilities/CatFiles_5to6'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist5/','ITAM_',itamLoc,'/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist5/','ITAM_',itamLoc,'/Plots'];
        
        %
        locationTotal = 10;
        NFilSweep = [1 2 3 5 9 10];
        %iSiteTotal(1:NFil) = [1 1 3 3 1 1]; % specify in loop for models
        %40, 41
        %sweep = 4:4:20;
        sweep = 8:4:20;
        sweepParameter = 'FilSweepNITAM';
        
        % figure parameters
        legendlabels = {[sweepParameter,' = ', num2str(sweep(1))],[sweepParameter,' = ', num2str(sweep(2))],[sweepParameter,' = ', num2str(sweep(3))],[sweepParameter,' = ', num2str(sweep(4))]};
        colorIndices = sweep;
        %colors = flipud(cool(max(sweep)));
        colors = flipud(cool(length(sweep))); % use colors from TCR above with bigger range
        ms = 10;
        lw = 2;
        modificationLabel = '(Bound)';
    
    case 41 % Filament Sweep - separation distance 17
        
        % model name
        modelName = 'SimultaneousBinding';
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist17/','ITAM_',itamLoc,'/1.OcclusionProbabilities/CatFiles_5to6'];
        filetitle     = strcat(iSiteSpacing,'Membrane',num2str(membrane));
        
        % save transition matrices location
        transitionMatrixfolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        transitionMatrixsubfolder = [iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist17/','ITAM_',itamLoc,'/2.TransitionMatrices'];
        
        % save figures location
        savesubfolder = ['3.SimultaneousBinding/',iSiteSpacing,'/Membrane',membraneState,'/FilVSTime/SepDist17/','ITAM_',itamLoc,'/Plots'];
        
        %
        locationTotal = 10;
        NFilSweep = [1 2 3 5 9 10];
        %iSiteTotal(1:NFil) = [1 1 3 3 1 1]; % specify in loop for models
        %40, 41
        %sweep = 4:4:20;
        sweep = 8:4:20;
        sweepParameter = 'FilSweepNITAM';
        
        % figure parameters
        legendlabels = {[sweepParameter,' = ', num2str(sweep(1))],[sweepParameter,' = ', num2str(sweep(2))],[sweepParameter,' = ', num2str(sweep(3))],[sweepParameter,' = ', num2str(sweep(4))]};
        colorIndices = sweep;
        %colors = flipud(cool(max(sweep)));
        colors = flipud(cool(length(sweep))); % use colors from TCR above with bigger range
        ms = 10;
        lw = 2;
        modificationLabel = '(Bound)';
        
        
end


%% Initialize variables
totalPerm = nchoosek(locationTotal,5);
rates_sum = zeros(length(NFilSweep),length(sweep));
avgRates = zeros(length(NFilSweep),length(sweep));


%% Create transition matrices, calculate average binding rates
for nfSweep = 1:length(NFilSweep)
    
    % set NFil, ITAM locations for this iteration
    NFil = NFilSweep(nfSweep);
    disp('NFil:');
    disp(NFil);
    
    % set up number of ITAMs per filament
    base = floor(locationTotal./NFil);
    extra = mod(locationTotal,NFil);
    iSiteTotal = base.*ones(1,NFil);
    for iExtra = 1:extra
        iSiteTotal(iExtra) = iSiteTotal(iExtra)+1;
    end

    %% Find indices of end ITAMs
    iSiteEnd = cumsum(iSiteTotal);

    
    disp('iSiteTotal:');
    disp(iSiteTotal);
    disp('iSites at end of filaments:');
    disp(iSiteEnd);
    
    % start parameter sweep
    for s = 1:length(sweep)
        
        % choose file

        filename = strcat(filetitle,sweepParameter,'.',num2str(sweep(s)),'.NFIL.',num2str(NFil),'.5to6.cat');

        disp(filename);
        
        % initialize
        OccupiedLocations = zeros(nchoosek(locationTotal,5),1);
        OccupiedLocationsMatrix = zeros(nchoosek(locationTotal,5),locationTotal);
        OccupiedLocationsDecimal = zeros(nchoosek(locationTotal,5),1);
        POcc = zeros(nchoosek(locationTotal,5),locationTotal);
        PBind = zeros(nchoosek(locationTotal,5),locationTotal);
        PAvail = zeros(nchoosek(locationTotal,5),locationTotal);
        PBindKinase = zeros(nchoosek(locationTotal,5),locationTotal);
        POcc_NumSites = zeros(nchoosek(locationTotal,5),locationTotal+1);
        PAvail_NumSites = zeros(nchoosek(locationTotal,5),locationTotal+1);
        
        %% Read from File
        
        %readData_TransitionMatrix(filefolder,filesubfolder,filename);
        
        M = dlmread(fullfile(filefolder,filesubfolder, filename));
        
        ntMetropolis = M(:,1);
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
                PAvail(:,siteCounter) = M(:,ind + 7*(iy-1) + 1);
                siteCounter = siteCounter + 1;
            end
        end
        %PBind(:,1:locationTotal) = 1-POcc(:,1:locationTotal);
        PBind(:,1:locationTotal) = PAvail(:,1:locationTotal).*(1-OccupiedLocationsMatrix);
        
        
        POcc_NumSites(:,1:locationTotal+1) = M(:,8+(1:(locationTotal+1)));
        PAvail_NumSites(:,1:locationTotal+1) = M(:,8+(locationTotal+1)+(1:(locationTotal+1)));
        
        %% Convert binary to decimal
        
        for j=1:locationTotal
            binaryString = num2str(OccupiedLocations(j));
            OccupiedLocationsDecimal(j) = bin2dec(binaryString);
        end
        
        %% Find indices of iSites on filaments with NONE BOUND
        
        % initialize
        iSites_NoneBoundOnFilament = zeros(size(OccupiedLocationsMatrix));
        iSiteEnd_NoneBound = [0 iSiteEnd];
        for k=1:size(OccupiedLocationsMatrix,1)
            for j = 1:length(iSiteEnd)
                if( sum(OccupiedLocationsMatrix(k,(iSiteEnd_NoneBound(j)+1):iSiteEnd_NoneBound(j+1))) == 0 )
                    iSites_NoneBoundOnFilament(k,(iSiteEnd_NoneBound(j)+1):iSiteEnd_NoneBound(j+1)) = 1;
                end
            end
        end
        
        
        
        %% 
        rates_sum(nfSweep,s) = sum(sum(PBind));

        
        %% Find average rates of transition from one state to another
        avgRates(nfSweep,s) = rates_sum(nfSweep,s)./size(find(1-OccupiedLocationsMatrix),1);
        
        %% Plot histogram of rates
        
        figure(2); hold on;
        subplot(length(sweep),length(NFilSweep),length(NFilSweep)*(s-1)+nfSweep);
        histogram(log10(PBind(find(PBind))),12);
        title1 = ['NFil = ',num2str(NFilSweep(nfSweep)),',  NITAM = ',num2str(sweep(s))];
        xlabel1 = 'Binding Rate (log10)';
        xlabel(xlabel1,'FontName','Arial','FontSize',18);
        title(title1,'FontName','Arial','FontSize',18);
        xlim([-10 0]);
        
        set(gcf,'units','centimeters','Position',[3.5 2.5 75 45]);
        
        %% Plot histogram of rates - end vs not end
        
        figure(3); hold on;
        subplot(length(sweep),length(NFilSweep),length(NFilSweep)*(s-1)+nfSweep); hold on;
        histogram(log10(PBind(find(PBind(:,iSiteEnd)))),12);
        histogram(log10(PBind(find(PBind(:,setdiff(1:locationTotal,iSiteEnd))))),12);
        title1 = ['NFil = ',num2str(NFilSweep(nfSweep)),',  NITAM = ',num2str(sweep(s))];
        xlabel1 = 'Binding Rate (log10)';
        xlabel(xlabel1,'FontName','Arial','FontSize',18);
        title(title1,'FontName','Arial','FontSize',18);
        xlim([-10 0]);
        if(s == length(sweep) && nfSweep == length(NFilSweep))
            leg = legend('end ITAMs','mid ITAMs','Location','northwest');
        end
        set(gcf,'units','centimeters','Position',[3.5 2.5 75 45]);
        
        
        %% Plot histogram of rates - none bound on same filament vs not
        
        figure(4); hold on;
        subplot(length(sweep),length(NFilSweep),length(NFilSweep)*(s-1)+nfSweep); hold on;
        histogram(log10(PBind(find(iSites_NoneBoundOnFilament))),12);
        histogram(log10(PBind(find(~iSites_NoneBoundOnFilament.*PBind))),12);
        title1 = ['NFil = ',num2str(NFilSweep(nfSweep)),',  NITAM = ',num2str(sweep(s))];
        xlabel1 = 'Binding Rate (log10)';
        xlabel(xlabel1,'FontName','Arial','FontSize',18);
        title(title1,'FontName','Arial','FontSize',18);
        xlim([-10 0]);
        if(s == length(sweep) && nfSweep == length(NFilSweep))
            leg = legend('unbound filaments','bound filaments','Location','northwest');
        end
        
        set(gcf,'units','centimeters','Position',[3.5 2.5 75 45]);
        
        
        
    end
    
    disp(iSites_NoneBoundOnFilament);
end

%% Save histogram plot

if(saveTF)
    figure(2);
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'BindingRates_5to6_Histogram.fig'),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'BindingRates_5to6_Histogram.eps'),'epsc');

    figure(3);
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'BindingRates_5to6_Histogram_EndVSMidITAMs.fig'),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'BindingRates_5to6_Histogram_EndVSMidITAMs.eps'),'epsc');

    figure(4);
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'BindingRates_5to6_Histogram_UnboundFilsVSBoundFils.fig'),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'BindingRates_5to6_Histogram_UnboundFilsVSBoundFils.eps'),'epsc');
end

%%
colors = ((length(sweep):-1:1)'/length(sweep)).*[0.1 0 0] + ((1:1:length(sweep))'/length(sweep)).*[0 0.7 1];
fontName = 'Arial';
fs = 18;

%% Plot Cooperativity - Phosphorylation no Labels
figure(1000); clf; hold on; box on;
for s = 1:length(sweep)
    pL = plot(NFilSweep,avgRates(:,s),'-s','LineWidth',lw,'Color',colors(s,:),'MarkerFaceColor',colors(s,:));
    pL.DisplayName = ['N ITAM = ',num2str(sweep(s))];
end
xlim([min(NFilSweep) max(NFilSweep)]);
set(gca,'YScale','log');


set(gcf,'units','centimeters','Position',[5 5 10 10]);
xlabel1 = 'Number of Filaments';
ylabel1 = 'Probability of Binding';
xlabel(xlabel1,'FontName',fontName,'FontSize',fs);
ylabel(ylabel1,'FontName',fontName,'FontSize',fs);

leg = legend;

if(saveTF)
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'AvgBindingRates_5to6_Labels.fig'),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'AvgBindingRates_5to6_Labels.eps'),'epsc');
end

% save with no labels
set(gcf,'units','centimeters','Position',[5 5 5 5]);
xlabel1 = '';
ylabel1 = '';
xlabel(xlabel1,'FontName',fontName,'FontSize',fs);
ylabel(ylabel1,'FontName',fontName,'FontSize',fs);
set(gca,'xticklabels',[]);
set(gca,'yticklabels',[]);
leg.Visible = 'off';

if(saveTF)
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'AvgBindingRates_5to6.fig'),'fig');
    saveas(gcf,fullfile(savefilefolder,savesubfolder,'AvgBindingRates_5to6.eps'),'epsc');
end























