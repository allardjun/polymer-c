%% Script to create plot of 64 possible transitions versus site
clear all; close all;
folder = '~/Documents/PolymerGit/src/PolymerCode';
filename = 'OccupiediSitesMouse.txt';

savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/1.LocalStructuring/RatesStatesExample';
saveTF=0;

% state matrix - 0 or 1;
phosphoStates = dlmread(fullfile(folder,filename),'_');

states = 1:1:64;
sites = 1:1:6;

% Horizontal
% figure(1); clf;
% heatmap(states,sites,phosphoStates');

% Vertical - phosphostates on yaxis
figure(2); clf;
hm = heatmap(sites,states,phosphoStates);
hm.Colormap = flipud(gray);
hm.ColorbarVisible = 'off';
for l=1:64
    ydispLabels{l} = {''};
end
for l=1:6
    xdispLabels{l} = {''};
end
hm.CellLabelColor = 'None';
hm.YDisplayLabels = ydispLabels;
hm.XDisplayLabels = xdispLabels;
set(gcf,'units','inches','Position',[0.5 0.5 0.85 8.75]);

if(saveTF)
    savefilename = 'PhosphoStates';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

%% Use rates matrix - sorted by combination

% READ FILE
folder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/1.LocalStructuring/CD3Zeta/MembraneOn/1.OcclusionProbabilities/CatFiles';
filename = 'CD3ZetaMembrane1StiffenRange.5.cat';
locationTotal = 6;
iSiteTotal = 6;
NFil = 1;
% state matrix - 0 or 1;
    
% initialize 
OccupiedLocations = zeros(2^locationTotal,1);
OccupiedLocationsMatrix = zeros(2^locationTotal,locationTotal);
POcc = zeros(2^locationTotal,locationTotal);
PBind = zeros(2^locationTotal,locationTotal);

M = dlmread(fullfile(folder,filename));

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
    
% PLOT VARIABLES
PBindPlot = (1-POcc).*(1-phosphoStates);
PBindPlot(PBindPlot==0) = NaN;

PlotData = [phosphoStates, PBindPlot];

%%
figure(400);clf; 
hm = heatmap(sites,states,PBind);
% Horizontal
%figure(3); clf;
%hm = heatmap(states,sites,PBindPlot');
%hm.ColorLimits = [0 max(PBindPlot(PBindPlot > 0))];

%% No labels
% Vertical - phosphostates on yaxis
figure(4); clf;
hm = heatmap(sites,states,PBindPlot);
hm.Colormap = pink;
hm.ColorbarVisible = 'off';
%hm.MissingDataLabel = 'Phosphorylated';
hm.MissingDataLabel = '';
hm.ColorLimits = [0 ceil(max(PBindPlot(PBindPlot > 0))*20)/20];
for l=1:64
    ydispLabels{l} = {''};
end

hm.YDisplayLabels = ydispLabels;
hm.CellLabelFormat = '%0.4f';

for l=1:6
    xdispLabels{l} = {''};
end
hm.XDisplayLabels = xdispLabels;
set(gcf,'units','inches','Position',[0.5 0.5 2.5 8.75]);

if(saveTF)
    savefilename = 'RatesExample';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

%%
figure(40); clf;
hm = heatmap(sites,states,PBindPlot);
hm.Colormap = pink;
hm.MissingDataLabel = 'Phosphorylated';

hm.ColorLimits = [0 ceil(max(PBindPlot(PBindPlot > 0))*20)/20];
for l=1:64
    ydispLabels{l} = {''};
end

hm.YDisplayLabels = ydispLabels;
hm.CellLabelFormat = '%0.4f';
hm.FontSize = 12;
hm.ColorbarVisible = 'off';

for l=1:6
    xdispLabels{l} = {''};
end
hm.XDisplayLabels = xdispLabels;
set(gcf,'units','inches','Position',[1 1 2.5 8.75]);

if(saveTF)
    savefilename = 'RatesExampleLabels';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

%%
% Vertical - phosphostates on yaxis
figure(5); clf;
hm = heatmap(PlotData);
hm.ColorLimits = [0 max(PBindPlot(PBindPlot > 0))];

for l=1:64
    ydispLabels{l} = {''};
end

hm.YDisplayLabels = ydispLabels;

ind=1;
for i=1:2
    for l=1:6
        xdispLabels{ind} = {num2str(l)};
        ind = ind+1;
    end
end

hm.XDisplayLabels = xdispLabels;


