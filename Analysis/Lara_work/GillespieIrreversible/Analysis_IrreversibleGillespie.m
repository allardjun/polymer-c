%% Analysis of Irreversible Gillespie Data
% Lara Clemens - lclemens@uci.edu

clear all;
close all;

%% Initialize Model Choice

% temporary for loop

% spacing = 0; % 0 = CD3Zeta, 1 = EvenSites, 2 = CD3Epsilon, 3 = TCR
% membrane = 1; % 0 for membrane off, 1 for membrane on
% phos = 0; % 1 = phosphorylation, 0 = dephosphorylation
for spacing = 0
    for membrane = 1
        for phos = 1
            sf = 1
%             for sf = 0
%                 clearvars -except spacing membrane phos sf
% 
%                 switch sf
%                     case 0
%                         %sweep = -1:1:103;
%                         %sweep = [-1:2:45 47:4:103]; % acceptably many curves
%                         %sweep = [-1:2:45 48:5:103];% acceptably many curves
%                         sweep = [-1:3:4 5:2:31 33:3:45 48:5:103]; % probably correct
%                         savefilesubsubfolder = ['/FullStiffenRange'];
%                         saveRatesPlot = 1;
%                         saveSeqPlot = 0;
% 
%                     case 1
%                         savefilesubsubfolder = [''];
%                         sweep = -1:1:10;
%                         saveRatesPlot = 0;
%                         saveSeqPlot = 1;
% 
%                     case 2
%                         savefilesubsubfolder = [''];
%                         sweep = -1:1:5;
%                         saveRatesPlot = 1;
%                         saveSeqPlot = 0;
% 
%                 end

            
% initialization switch for which model we're inspecting
model = 20; % 1x = stiffening, 2x = electrostatics, 3x = multiple binding - ibEqual

saveRatesPlot = 1;
saveSeqPlot = 0;





%% Model Parameters

savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures';
%savefilesubsubfolder = ['/FullStiffenRange'];
%subsubfolder = ['']
%savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures';

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

switch (model)
    
    case 10 % Local Structuring
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/1.LocalStructuring/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Irreversible/','/CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        %
        locationTotal = 6;
        %sweep = -1:1:10; % includes control
        sweepParameter = 'StiffenRange';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/Plots/',phosDirection];
        
        % figure parameters
        if (sf==0)
            lw = 1;
        else
            lw = 2;
        end
        ms = 10;
        if (sf==0)
            colors = flipud(cool(max(sweep)+2));
        else
            colors = flipud(cool(length(sweep)));
        end
        colormapName = cool;
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        modificationLabel = '(Phosphorylated)';
        
        % set GillespieRuns from Gillespie algorithm
        % this would be better if printed in Gillespie output
        GillespieRuns = 200000000;
        
      
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 20 % Membrane Association - Zeta
      
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Irreversible/CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        %
        locationTotal = 6;
        sweep = 0:2:20; % includes control
        sweepParameter = 'EP0';
        
        % create location to save figures
        savefilesubfolder = ['2.MembraneAssociation/',iSiteSpacing,'/Membrane',membraneState,'/Plots/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = parula(11);
        legendlabelsAbbrev = {'0','1','2','3','4','5','6','7','8','9','10'};
        legendlabels = {['EP0', num2str(sweep)]};
        
        xlabelModel = 'EP0';
        units = 'kBT'; 
        
        modificationLabel = '(Phosphorylated)';
        colormapName = 'parula';
        
        GillespieRuns = 200000000;
        
     case 21 % Membrane Association - Epsilon
      
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/TwoSites/3.Gillespie/Irreversible/CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        %
        locationTotal = 2;
        sweep = 0:2:20; % includes control
        sweepParameter = 'EP0';
        
        % create location to save figures
        savefilesubfolder = ['2.MembraneAssociation/',iSiteSpacing,'/Membrane',membraneState,'/Plots/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = parula(11);
        legendlabelsAbbrev = {'0','1','2','3','4','5','6','7','8','9','10'};
        legendlabels = {['EP0', num2str(sweep)]};
        colormapName = 'parula';
        
        xlabelModel = 'EP0';
        units = 'kBT'; 
        modificationLabel = '(Phosphorylated)';
        
        GillespieRuns = 200000000;
        
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
        
        colors = flipud(cool(length(sweep)));
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
        
        colors = flipud(cool(13));
        lw = 1.5;
        ms = 10;
        
        modificationLabel = '(Phosphorylated)';
        
        GillespieRuns = 1000000000;
        
        
end


%% CREATE PERMUTATION LIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CREATE PERMUTATION LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize
path = zeros(factorial(locationTotal),1);
avgTime = zeros(factorial(locationTotal),size(sweep,2)+1);
probability = zeros(factorial(locationTotal),size(sweep,2)+1);
stdErrGillespie = zeros(factorial(locationTotal),size(sweep,2)+1);

% create list of permutations of numbers 1-6
permutations = sortrows(perms(1:1:locationTotal));

% create permutation strings then convert to number
for j=1:factorial(locationTotal)
    permString = '';
    for k=1:locationTotal
        permString = strcat(permString,num2str(permutations(j,k)));
    end
    path(j) = str2num(permString);
end

% attach path to each so becomes vector e.g. [path, avgTime]
avgTime(:,1) = path(:);
probability(:,1) = path(:);
stdErrGillespie(:,1) = path(:);

%% Find indices of paths where x is i-th event
% Only works for locationTotal <= 9 (NOT TCR)
switch model
    case {32,33}
    otherwise
        % initialize
        eventIndices = zeros(locationTotal,factorial(locationTotal)/locationTotal);
        secondToLastEventProbability = zeros(locationTotal,length(sweep));

        % find second to last event
        eventIndex = locationTotal-1; % options: 1 to locationTotal
        eventModifier = locationTotal-eventIndex;

        % find index of paths where designated event is x
        secondToLastEvent = mod(floor(path(:)/10^(eventModifier)),10);

        for eInd = 1:locationTotal
            eventIndices(eInd,:) = find(secondToLastEvent == eInd);
        end
end
%% READ FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for s=1:length(sweep)
   
    clear M;
    
    % set up filename
    filename = strcat(filetitle,sweepParameter,'.',num2str(sweep(s)),'.AllData');
    
    % read in file
    M = dlmread(fullfile(filefolder,filesubfolder,filename));
    disp(s);
    disp(size(M));
    % read in average times and rates
    transitionTime_Avg(s,1:locationTotal) = M(end-(locationTotal-1):end,2);
    transitionRate_Avg(s,1:locationTotal) = M(end-(locationTotal-1):end,3);

    
    % check size of M for possible error
    if (size(M,1) < (1+factorial(locationTotal)+locationTotal))
        disp('File:');
        disp(s);
        disp('Warning! File might not contain all paths!');
        disp(size(M));
    end
    
    % find probability and avgTime from matrix
    for k=1:(size(M,1)-1-locationTotal)
        probability(k,s+1) = M(k+1,4);
        avgTime(k,s+1) = M(k+1,5);
    end
    
    stdErrGillespie(:,s+1) = sqrt(probability(:,s+1).*(1-probability(:,s+1)))./sqrt(GillespieRuns);
    
    
    %% Find probability path has x as i-th event
    % Only works for locationTotal <= 9 (NOT TCR)
    switch model
        case {32,33}
        otherwise
        for eInd = 1:locationTotal
            secondToLastEventProbability(eInd,s) = sum(probability(eventIndices(eInd,:),s+1));
            %disp(secondToLastEventProbability(eInd,s));
        end
    end
    
end


%% save workspace
save(fullfile(savefilefolder,savefilesubfolder,'Data.mat'));

%% load workspace
load(fullfile(savefilefolder,savefilesubfolder,'Data.mat'));

%% AVERAGE TRANSITION RATE PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% AVERAGE TRANSITION RATE PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Average Transition Rates VS Number of Modified Sites - No Labels

figure(12); clf; hold on; box on;
for s=1:length(sweep)
    plot_line = plot(0:1:(locationTotal-1),transitionRate_Avg(s,:)./(locationTotal:-1:1),'-s','LineWidth',lw);
    if (sf==0)
        plot_line.Color = colors(sweep(s)+2,:);
        plot_line.MarkerFaceColor = colors(sweep(s)+2,:);
        plot_line.MarkerSize = 3;
    else
        plot_line.Color = colors(s,:);
        plot_line.MarkerFaceColor = colors(s,:);
        plot_line.MarkerSize = 2;
    end
end

set(gca,'xlim',[0 locationTotal-1]);
set(gca,'XTick',0:1:locationTotal-1);
set(gca,'xticklabel',[]);
switch model
    case 10

        if max(sweep) > 15
            ylim([0 1]);
        elseif max(sweep) <= 15
            if (spacing) % Even Sites
                if (membrane) % Membrane On
                    if (phos) % Phos
                        ylim([0 0.03]);
                    else
                        ylim([0 1]);
                    end
                else % Membrane Off
                    if (phos)
                        ylim([0.02 0.04]);
                        yticks([0.02 0.025 0.03 0.035 0.04]);
                    else
                        ylim([0 1]);
                    end
                end
            else % CD3Zeta
                if (membrane) % Membrane On
                    if (phos)
                        ylim([0.005 0.02]);
                    else
                        ylim([0 0.6]);
                    end
                else % Membrane Off
                    if (phos)
                        ylim([0.02 0.05]);
                    else
                        ylim([0 1]);
                    end
                end
            end   
        end
    case 20
        if(phos)
            ylim([0.004 0.012]);
        else
        end
                
    case {30}
        ylim([0 1]);
    case { 32,33,34}
        set(gca,'YScale','log');
        ylim([10^(-10) 10^(0)]);
end
set(gca,'yticklabel',[]);

% print position and labels
pos = get(gca, 'position');
set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);

if (saveRatesPlot)
    % % save figure
    savefiletitle = 'AvgTransRateVSNumberModified';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
end

%% Average Transition Rates VS Number of Modified Sites - Labels

figure(120); clf; hold on; box on;
for s=1:length(sweep)
    plot_line = plot(0:1:(locationTotal-1),transitionRate_Avg(s,:)./(locationTotal:-1:1),'-s','LineWidth',lw);
    if (sf==0)
        plot_line.Color = colors(sweep(s)+2,:);
        plot_line.MarkerFaceColor = colors(sweep(s)+2,:);
        plot_line.MarkerSize = 3;
    else
        plot_line.Color = colors(s,:);
        plot_line.MarkerFaceColor = colors(s,:);
    end
end
switch model
    case {30,31,32,33}
        set(gca,'yscale','log');
    otherwise
end
xlabel1 = {['Number of Modified Sites'],modificationLabel};
ylabel1 = {['Average Transition Rate / Unmodified Sites']};
title1 = 'Average Transition Rate';
set(gca,'XTick',0:1:locationTotal-1);
set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6', '6 -> 7', '7 -> 8', '8 -> 9', '9 -> 10'});
switch model
    case 10
        
        if max(sweep) > 15
            ylim([0 1]);
        elseif max(sweep) <= 15
            if (spacing) % Even Sites
                if (membrane) % Membrane On
                    if (phos)
                        ylim([0 0.03]);
                    else
                        ylim([0 1]);
                    end
                else % Membrane Off
                    if (phos)
                        ylim([0.02 0.04]);
                        yticks([0.02 0.025 0.03 0.035 0.04]);
                    else
                        ylim([0 1]);
                    end
                end
            else % CD3Zeta
                if (membrane)
                    if (phos)
                        ylim([0.005 0.02]);
                    else
                        ylim([0 0.6]);
                    end
                else
                    if (phos)
                        ylim([0.02 0.05]);
                    else
                        ylim([0 1]);
                    end
                end
            end   
        end
        
    case 20
        if(phos)
            ylim([0.004 0.012]);
        else
        end
        
    case {30}
        ylim([0 1]);
    case {32,33}
        xlim([0 locationTotal-1])
        set(gca,'YScale','log');
        ylim([10^(-10) 10^(0)]);
end
%set(gcf,'Colormap',colormapName);
colormap parula;
h = colorbar;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
set(h,'ylim',[0 1]);

pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',30);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);

if (saveRatesPlot)
    % % save figure
    savefiletitle = 'AvgTransRateVSNumberModifiedLabels';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
end

%% SEQUENCE PROBABILITY PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% SEQUENCE PROBABILITY PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Create matrices to be read by 'Bar' command

% want either just 654321 and 123456 or also Max and Min

sequentialAvgTime = zeros(2,size(sweep,2)+1);
sequentialProbability = zeros(2,size(sweep,2)+1);


sequentialAvgTime(1,:) = avgTime(1,:);
sequentialProbability(1,:) = probability(1,:);
sequentialStdErrGillespie(1,:) = stdErrGillespie(1,:);

sequentialAvgTime(2,:) = avgTime(factorial(locationTotal),:);
sequentialProbability(2,:) = probability(factorial(locationTotal),:);
sequentialStdErrGillespie(2,:) = stdErrGillespie(factorial(locationTotal),:);

%% Create bar graphs
switch (spacing)
    case 4
        sequence = {'12','21'};
    otherwise
        sequence = {'123456','654321'};
end

%% Plot Probability versus Sequence - No Labels

ax=figure(2); clf; box on; hold on;
b=bar(sequentialProbability(:,2:end));
individualBarWidth = b(1).BarWidth/length(sweep);
for iBar = 1:length(b)
    XBar = (b(iBar).XData - 0.5*b(iBar).BarWidth + 0.5*individualBarWidth)+(iBar-1)*individualBarWidth;
    errorbar(XBar,sequentialProbability(:,iBar+1),sequentialStdErrGillespie(:,iBar+1),'.k');
end

w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/factorial(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1,2]);
set(gca,'xticklabel',[]);
switch (model)
    case 10

        if(phos)
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.015]);
                yticks([0 0.005 0.01 0.015]);
            end
        else
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.006]);
                yticks([0 0.001 0.002 0.003 0.004 0.005 0.006]);
            end
        end
        
    case 20
        if(phos)
            ylim([0 0.016]);
            yticks([0 0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016]);
        else
            ylim([0 4*10^(-3)]);
            yticks(10.^(-3).*[0 0.5 1 1.5 2 2.5 3 3.5 4]);
        end
    case 30
        if(phos)
            ylim([0 0.002])
            yticks([0 0.0005 0.001 0.0015 0.002]);
        end
end
set(gca,'yticklabel',[]);

% print position and labels
pos = get(gca, 'position');
set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);
%set(gca,'units','inches','position',[0.5,0.5,1.7,1.2]);

if (saveSeqPlot)
    % % save figure
    savefiletitle = 'ProbVSSequence';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'-depsc');
%     saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end

%% Plot Probability versus Sequence - Labels

ax=figure(20); clf; box on; hold on;
b=bar(sequentialProbability(:,2:end));
individualBarWidth = b(1).BarWidth/length(sweep);
for iBar = 1:length(b)
    XBar = (b(iBar).XData - 0.5*b(iBar).BarWidth + 0.5*individualBarWidth)+(iBar-1)*individualBarWidth;
    errorbar(XBar,sequentialProbability(:,iBar+1),sequentialStdErrGillespie(:,iBar+1),'.k');
end

w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/factorial(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1 2]);
set(gca,'xticklabel',sequence);
xlabel1 = 'Sequence';
ylabel1 = 'Probability';
title1 = 'Probability vs Sequence';
switch (model)
    
    case 10
        if(phos)
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.015]);
                yticks([0 0.005 0.01 0.015]);
            end
        else
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.006]);
                yticks([0 0.001 0.002 0.003 0.004 0.005 0.006]);
            end
        end
    case 20
        if(phos)
            ylim([0 0.016]);
            yticks([0 0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016]);
        else
            ylim([0 4*10^(-3)]);
            yticks(10.^(-3).*[0 0.5 1 1.5 2 2.5 3 3.5 4]);
        end
    case 31
        if(phos)
            ylim([0 0.002])
            yticks([0 0.0005 0.001 0.0015 0.002]);
        end
end

% print position and labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',30);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);

% colorbar
set(gcf,'Colormap',colormapName)
colortickind = [length(sweep) 1];
%clims = [0 1]
clims = [colors(colortickind(1)) colors(colortickind(2))];
% cbar = colorbar('Ticks',[colors_fig(colortickind(1)) colors_fig(colortickind(2))],'TickLabels',{'10^{2}','10^{-2}'},'ylim',clims);
h = colorbar('Ticks',[colors(colortickind(1)) colors(length(sweep)-5) colors(colortickind(2))],'TickLabels',{'',''},'ylim',clims);
% set(h,'ylim',colorTicks);

%legend(horzcat(legendlabels,{'Random Probability = 1/720'}),'Location','northwest');
if (saveSeqPlot)
    % % save figure
    savefiletitle = 'ProbVSSequenceLabels';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'fig');
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'epsc');
end


%% SEQUENCE PROBABILITY PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% SECOND TO LAST EVENT PROBABILITY PLOTS %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch model
    case {32,33}
    otherwise
        
%% Plot Probability versus Sequence - No Labels

ax=figure(3); clf; box on; hold on;
b=bar(secondToLastEventProbability(:,1:end));
individualBarWidth = b(1).BarWidth/length(sweep);
%for iBar = 1:length(b)
    %XBar = (b(iBar).XData - 0.5*b(iBar).BarWidth + 0.5*individualBarWidth)+(iBar-1)*individualBarWidth;
    %errorbar(XBar,sequentialProbability(:,iBar+1),sequentialStdErrGillespie(:,iBar+1),'.k');
%end

w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1,2]);
set(gca,'xticklabel',[]);
switch (model)
    case 10

        if(phos)
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.3]);
                yticks([0 0.1 0.2 0.3]);
            end
        else
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.3]);
                yticks([0 0.1 0.2 0.3]);
            end
        end
end
set(gca,'yticklabel',[]);

% print position and labels
pos = get(gca, 'position');
set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);
%set(gca,'units','inches','position',[0.5,0.5,1.7,1.2]);

if (saveSeqPlot)
    % % save figure
    savefiletitle = 'ProbVSEvent';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'-depsc');
%     saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end

%% Plot Probability versus Sequence - Labels

ax=figure(30); clf; box on; hold on;
b=bar(secondToLastEventProbability(:,1:end));
individualBarWidth = b(1).BarWidth/length(sweep);
% for iBar = 1:length(b)
%     XBar = (b(iBar).XData - 0.5*b(iBar).BarWidth + 0.5*individualBarWidth)+(iBar-1)*individualBarWidth;
%     errorbar(XBar,sequentialProbability(:,iBar+1),sequentialStdErrGillespie(:,iBar+1),'.k');
% end

w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1 2 3 4 5 6]);
%set(gca,'xticklabel',sequence);
xlabel1 = 'Binding Site';
ylabel1 = 'Probability';
title1 = 'Probability of Second to Last Event Being Given Binding Site';
switch (model)
    
    case 10
        if(phos) 
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.3]);
                yticks([0 0.1 0.2 0.3]);
            end
        else
            if(max(sweep)>15)
                ylim([0 max(max(probability(:,2:end)))]);
            else
                ylim([0 0.3]);
                yticks([0 0.1 0.2 0.3]);
            end
        end
end

% print position and labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',30);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);

% colorbar
set(gcf,'Colormap',flipud(colormapName))
colortickind = [length(sweep) 1];
%clims = [0 1]
clims = [colors(colortickind(1)) colors(colortickind(2))];
% cbar = colorbar('Ticks',[colors_fig(colortickind(1)) colors_fig(colortickind(2))],'TickLabels',{'10^{2}','10^{-2}'},'ylim',clims);
h = colorbar('Ticks',[colors(colortickind(1)) colors(length(sweep)-5) colors(colortickind(2))],'TickLabels',{'',''},'ylim',clims);
% set(h,'ylim',colorTicks);

%legend(horzcat(legendlabels,{'Random Probability = 1/720'}),'Location','northwest');
if (saveSeqPlot)
    % % save figure
    savefiletitle = 'ProbVSEventLabels';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'fig');
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefilesubsubfolder,savefiletitle),'epsc');
end

end

            %end
        end
    end
end

%% EXTRA PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXTRA PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{

    %% Create transition rate plots

    figure(1); clf; hold on;
    for s=1:length(sweep)
        plot(0:1:(locationTotal-1),transitionRate_Avg(s,:),'Color',colors(s,:),'LineWidth',lw);
    end
    xlabel1 = {['Number of Modified Sites'],modificationLabel};
    ylabel1 = {['Average Transition Rate'],['(per free space binding)']};
    title1 = 'Average Transition Rate';
    set(gca,'XTick',0:1:locationTotal-1);
    set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6'});
    set(gcf,'Colormap',colormapName)
    h = colorbar;
    h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    set(h,'ylim',[0 1]);
    switch model
        case 1
            ylim([0 locationTotal]);
        case {2,3}
            ylim([0 1]);
    end

    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    set(gca,'FontName','Arial','FontSize',30);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    
    if (saveTF)
        % % save figure
        savefiletitle = 'AverageTransitionRate_TotalSitesVSNumberModified';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end

    %%
    figure(11); clf; hold on;
    for s=1:length(sweep)
        plot(0:1:(locationTotal-1),transitionTime_Avg(s,:),'Color',colors(s,:),'LineWidth',lw);
    end
    xlabel1 = {['Number of Modified Sites'],modificationLabel};
    ylabel1 = {['Average Transition Time']};
    title1 = 'Average Transition Time';
    set(gca,'XTick',0:1:locationTotal-1);
    set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6'});
    set(gcf,'Colormap',colormapName)
    h = colorbar;
    h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    set(h,'ylim',[0 1]);

    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    set(gca,'FontName','Arial','FontSize',30);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    
    if (saveTF)
        % % save figure
        savefiletitle = 'AverageTransitionTimeVSNumberModified';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end



    %% Create Sorted Graphs
    % removes association with path once sorted for plot purposes (i.e. x-axis
    % is rank, not sequence)
    % want to be able to know which one is 123456, 654321

    sortedAvgTimeSweep = zeros(factorial(locationTotal),size(sweep,2));
    sequenceRankAvgTimeMemToTail = zeros(2,size(sweep,2));
    sequenceRankAvgTimeTailToMem = zeros(2,size(sweep,2));

    sortedProbabilitySweep = zeros(factorial(locationTotal),size(sweep,2));
    sequenceRankProbabilityMemToTail = zeros(2,size(sweep,2));
    sequenceRankProbabilityTailToMem = zeros(2,size(sweep,2));
    sequenceRankProbability = zeros(2,size(sweep,2));


    for s = 1:length(sweep)
        % AVERAGE TIME
        %initialize
        preSortAvgTime = zeros(factorial(locationTotal),2);
        sortedAvgTime = zeros(factorial(locationTotal),2);

        % collect path and avgTime data one column at a time, sort, pull out
        % data for 123456, 654321
        preSortAvgTime(:,1) = path;
        preSortAvgTime(:,2) = avgTime(:,s+1);
        sortedAvgTime = sortrows(preSortAvgTime,2);

        % collect location in sequenceRankAvgTime of 123456, 654321
        sequenceRankAvgTimeMemToTail(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{1}));
        sequenceRankAvgTimeTailToMem(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{2}));

        % collect average time
        sequenceRankAvgTimeMemToTail(2,s) = sortedAvgTime(sequenceRankAvgTimeMemToTail(1,s),2);
        sequenceRankAvgTimeTailToMem(2,s) = sortedAvgTime(sequenceRankAvgTimeTailToMem(1,s),2);

        sortedAvgTimeSweep(:,s) = sortedAvgTime(:,2);


        %PROBABILITY
        %initialize
        preSortProbability = zeros(factorial(locationTotal),2);
        sortedProbability = zeros(factorial(locationTotal),2);

        % collect path and probability data one column at a time, sort, pull out
        % data for 123456, 654321
        preSortProbability(:,1) = path;
        preSortProbability(:,2) = probability(:,s+1);
        sortedProbability = sortrows(preSortProbability,2);
        sequenceRankProbability(1,s) = find(sortedProbability(:,1)==str2num(sequence{1}));
        sequenceRankProbability(2,s) = find(sortedProbability(:,1)==str2num(sequence{2}));

        sequenceRankProbabilityMemToTail(1,s) = find(sortedProbability(:,1)==str2num(sequence{1}));
        sequenceRankProbabilityTailToMem(1,s) = find(sortedProbability(:,1)==str2num(sequence{2}));

        sequenceRankProbabilityMemToTail(2,s) = sortedProbability(sequenceRankProbabilityMemToTail(1,s),2);
        sequenceRankProbabilityTailToMem(2,s) = sortedProbability(sequenceRankProbabilityTailToMem(1,s),2);


        sortedProbabilitySweep(:,s) = sortedProbability(:,2);

    end
    %% Plot AvgTime vs Rank
    figure(31); clf; 


    figure(31); hold on; box on;
    for s = 1:length(sweep)
        plot(1:1:factorial(locationTotal),sortedAvgTimeSweep(:,s),'-');
    end
    plot(sequenceRankAvgTimeMemToTail(1,:),sequenceRankAvgTimeMemToTail(2,:),'xk','LineWidth',lw,'MarkerSize',ms);
    plot(sequenceRankAvgTimeTailToMem(1,:),sequenceRankAvgTimeTailToMem(2,:),'ok','LineWidth',lw,'MarkerSize',ms);

    % Plot labels
    xlabel1 = 'Rank';
    ylabel1 = 'Average Time (s)';
    title1 = 'Average Time vs Rank';
    set(gca,'FontName','Arial','FontSize',24);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);

    % Plot legend
    markerlabels = {['Sequence = ',sequence{1}],['Sequence = ',sequence{2}]};
    legendlabelswithmarkers = horzcat(legendlabels,markerlabels)
    legend(legendlabelswithmarkers,'Location','northwest');

    % position
    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);

    if (saveTF)
        % % save figure
        savefiletitle = 'AvgTimeVSRank';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end

    %% Plot Probability vs Rank
    figure(41); clf;
    figure(41); hold on; box on;
    for s = 1:length(sweep)
        plot(1:1:factorial(locationTotal),sortedProbabilitySweep(:,s),'-k','LineWidth',lw);
    end
    plot(sequenceRankProbabilityMemToTail(1,:),sequenceRankProbabilityMemToTail(2,:),'xk','LineWidth',lw,'MarkerSize',ms);
    plot(sequenceRankProbabilityTailToMem(1,:),sequenceRankProbabilityTailToMem(2,:),'ok','LineWidth',lw,'MarkerSize',ms);
    plot([1 factorial(locationTotal)],[1/factorial(locationTotal) 1/factorial(locationTotal)],'--k','LineWidth',2);

    % Plot labels
    xlabel1 = 'Rank';
    ylabel1 = 'Probability';
    title1 = 'Probability vs Rank';
    set(gca,'FontName','Arial','FontSize',24);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    legend(horzcat(legendlabelswithmarkers,{['Random Probability = 1/',num2str(factorial(locationTotal))]}),'Location','northwest');

    % position
    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    if (saveTF)
        % % save figure
        savefiletitle = 'ProbVSRank';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end

 %}
