%% Analysis of Irreversible Gillespie Data
% Lara Clemens - lclemens@uci.edu

clear all;
close all;
overwriteTF = 0;
%% Initialize Model Choice

spacing = 3; % 0 = CD3Zeta, 1 = EvenSites, 2 = CD3Epsilon, 3 = TCR
membrane = 1; % 0 for membrane off, 1 for membrane on
phos = 1; % 1 = phosphorylation, 0 = dephosphorylation
        
% initialization switch for which model we're inspecting
model = 34; % 1x = stiffening, 2x = electrostatics, 3x = multiple binding - ibEqual

saveRatesPlot = 0;
saveSeqPlot = 0;


%% Model Parameters

savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures';

switch spacing
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'CD3Epsilon';
    case 3
        iSiteSpacing = 'TCR';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

if (phos)
    phosDirection = 'Phos';
else
    phosDirection = 'Dephos';
end

switch model
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     case 30
        
        % find files
        filefolder    = '~/Documents/polymer-c_runs/20181206GillespieMeanRateSimBind';
        filesubfolder = 'GillespieSimultaneousBindingCD3ZetaMembrane0Phos';
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        
        %
        locationTotal = 3;
        sweep = 1:1:14; % includes control
        sweepParameter = 'ibRadius';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        savefilesubsubfolder = [''];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = flipud(cool(length(sweep)+2));
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        modificationLabel = '(Phosphorylated)';
        
      case 31
        
        % find files
        filefolder    = '~/Documents/polymer-c_runs/20181206GillespieMeanRateSimBindibEqMemOn';
        filesubfolder = 'GillespieSimultaneousBindingCD3ZetaMembrane1Phos';
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        
        %
        locationTotal = 6;
        sweep = 1:1:7; % includes control
        sweepParameter = 'ibRadius';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        savefilesubsubfolder = [''];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = flipud(cool(length(sweep)+2));
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        modificationLabel = '(Phosphorylated)';
        

     case 32
        
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SepDist5/3.Gillespie/Irreversible/','CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        sweepParameter = 'ibRadius';
        %legendlabelsAbbrev = 1:14; % 14 finished total
        legendlabelsAbbrev = 1:13; % only plot 13 to match SepDist17
        
        locationTotal = 10;
        %sweep = 1:1:14; % 14 finished total
        sweep = 1:1:13; % only plot 13 to match SepDist17
        
        xlabelModel = 'Radius of Ligand';
        units = '(Kuhn lengths)';
        %
        % create location to save figures
        savefilesubfolder = ['3.SimultaneousBinding/','TCR','/Membrane',membraneState,'/SepDist5/Plots/',phosDirection,'/Sequence'];
        savefilesubsubfolder = [''];
        
        %colors = flipud(cool(length(sweep)));
        colors = spring(14);
        colormapName = spring;
        clims = [0 13/14];
        lw = 1.5;
        ms = 10;
        
        modificationLabel = '(Phosphorylated)';
        
        GillespieRuns = 1000000000;
        
     case 33
        
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SepDist17/3.Gillespie/Irreversible/','CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        sweepParameter = 'ibRadius';
        legendlabelsAbbrev = 1:10;
        
        locationTotal = 10;
        sweep = 1:1:13;
        
        xlabelModel = 'Radius of Ligand';
        units = '(Kuhn lengths)';
        %
        % create location to save figures
        savefilesubfolder = ['3.SimultaneousBinding/','TCR','/Membrane',membraneState,'/SepDist17/Plots/',phosDirection,'/Sequence'];
        savefilesubsubfolder = [''];
        
        %colors = flipud(cool(13));
        colors = spring(14);
        colormapName = spring;
        clims = [0 13/14];
        lw = 1.5;
        ms = 10;
        
        modificationLabel = '(Phosphorylated)';
        
        GillespieRuns = 1000000000;
        
      case 34
        
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/TCRPDBConfig/3.Gillespie/Irreversible/','CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        sweepParameter = 'ibRadius';
        legendlabelsAbbrev = 1:10;
        
        locationTotal = 10;
        sweep = 1:1:10;
        
        xlabelModel = 'Radius of Ligand';
        units = '(Kuhn lengths)';
        %
        % create location to save figures
        savefilesubfolder = ['3.SimultaneousBinding/','TCR','/Membrane',membraneState,'/TCRPDBConfig/Plots/',phosDirection,'/Sequence'];
        savefilesubsubfolder = [''];
        
        colors = spring(14);
        lw = 1.5;
        ms = 10;
        colormapName = spring;
        clims = [0 13/14];
        
        modificationLabel = '(Phosphorylated)';
        
        GillespieRuns = 1000000000;
        
        
end

%if(~exist(fullfile(savefilefolder,savefilesubfolder,'Data.mat'),'file') || overwriteTF)
    %% CREATE PERMUTATION LIST
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%% CREATE PERMUTATION LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % create list of permutations of numbers 1-10
    permutations = sortrows(perms(1:1:locationTotal));
    
   %% Find permutations that indicate one ligand per polymer in first six
   
   permutations_firstsix = permutations(:,1:6);
   
   % check for 1,2,9,10 in first six
   singleSites = [1,2,9,10];
   for i = 1:size(permutations_firstsix,1)
       allSinglesInFirstSix(i) = all(ismember(singleSites,permutations_firstsix(i,:)));
   end
   
   % for those that passed first check, check for exactly one of 3,4,5
   multipleSites = [3,4,5];
   for i = 1:size(permutations_firstsix,1)
       % count how many are on single zeta chain for that configuration
       occupiedFilamentTotal = sum(ismember(multipleSites,permutations_firstsix(i,:)));
       
       % if only one on that zeta AND all single ITAM chains are occupied,
       % set onePerFilament to true
       if( occupiedFilamentTotal == 1 && allSinglesInFirstSix(i) )
           onePerFilament(i) = 1;
       else
           onePerFilament(i) = 0;
       end
   end
   
   %% Track how many filaments have a ligand
   
   % initialize filamentsOccupied matrix
   filamentsOccupied = zeros(size(permutations,1),size(permutations,2));
    % set which sites on which filaments
    filamentSiteLocations = [1 2 3 3 3 4 4 4 5 6];
    
   % initialize newFilamentOccupied vector 
   newFilamentOccupied = zeros(10,1);
   
    for i = 1:size(permutations,1)
        % turn permutations of sites into permuations of filaments
        filamentPermutations = filamentSiteLocations(permutations(i,:));
        % find when a new filament is occupied
        [C uniqueFilInd ic] = unique(filamentPermutations,'first');
        % note if a new filament is occupied
        newFilamentOccupied(uniqueFilInd) = 1;
        
        % store how many filaments are occupied over path
        filamentsOccupied(i,:) = cumsum(newFilamentOccupied);
        
        
        % reset newFilamentOccupied
        newFilamentOccupied = zeros(10,1);
        
    end
            
        

    %% READ FILES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % initialize
    pathTakenOnePerFilament = zeros(length(sweep),1);
    probabilityOnePerFilament = zeros(length(sweep),1);
    probabilityTotal = zeros(length(sweep),1);
    pathTakenTotal = zeros(length(sweep),1);
    
    for s=1:length(sweep)

        clear M;

        % set up filename
        filename = strcat(filetitle,sweepParameter,'.',num2str(sweep(s)),'.AllData')

        % read in file
        M = dlmread(fullfile(filefolder,filesubfolder,filename));
        disp(s);
        disp(size(M));

        % check size of M for possible error
        if (size(M,1) < (1+factorial(locationTotal)+locationTotal))
            disp('File:');
            disp(s);
            disp('Warning! File might not contain all paths!');
            disp(size(M));
        end

        % find probability from matrix
        pathIndex = M(2:(end-locationTotal),1)+1; % in C, pathIndex started at 0 - convert to Matlab
        pathTaken = M(2:(end-locationTotal),2); % number of times that path was taken
        probability = M(2:(end-locationTotal),4); % probability (as recorded in C) that path was taken (pathTaken./GillespieRuns) <- note rounding errors when printed here
        probability_pathTaken = pathTaken./GillespieRuns;
        stdErrGillespie = sqrt(probability.*(1-probability))./sqrt(GillespieRuns);

        % Calculate probability of one ligand per filament
        for i = 1:length(pathIndex)
            if( onePerFilament(pathIndex(i)) )
                pathTakenOnePerFilament(s) = pathTakenOnePerFilament(s) + pathTaken(i);
                probabilityOnePerFilament(s) = probabilityOnePerFilament(s) + probability(i);
            end
            probabilityTotal(s) = probabilityTotal(s) + probability(i);
            pathTakenTotal(s) = pathTakenTotal(s) + pathTaken(i);
        end
        
        %% Find weighted average of number filaments occupied
        for i = 1:size(permutations,2)
            avgFilOccupied(i,s) = sum(filamentsOccupied(pathIndex,i).*probability_pathTaken);
        end
    %end
    
    %% save workspace
    %save_vars = {'path','probability','stdErrGillespie','permutations'};
    %save(fullfile(savefilefolder,savefilesubfolder,'Data.mat'),save_vars{:});
end

%% load workspace
%load(fullfile(savefilefolder,savefilesubfolder,'Data.mat'));

    %% Plot average filaments occupied
    %colors = parula(length(sweep));
    figure(1); clf; hold on;
    for s = 1:length(sweep)
        plot(avgFilOccupied(:,s),'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms,'DisplayName',['Ligand Radius: ', num2str(s),' Kuhn lengths']);
    end
    ylim([1 6]);
    xlabel1 = 'Number of Ligands on TCR';
    ylabel1 = 'Average number of filaments with at least one ligand';
    xlabel(xlabel1,'FontName','Arial','FontSize',18);
    ylabel(ylabel1,'FontName','Arial','FontSize',18);
    legend('Location','northwest');






