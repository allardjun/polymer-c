%% Analysis_GillespieReversibleConstant
clear all; close all;

%% Initialize model parameters

saveTF = 1; % save figures

spacing = 0; % 0 = CD3Zeta spacing, 1 = evenly spaced tyrosines
membrane = 1; % 0 = no membrane, 1 = membrane
constant = 1; % 0 = steric-independent dephosphorylation, 1 = steric-influenced dephosphorylation, 2 = constant phosphorylation

% parameters to file label conversion
if (spacing)
    iSiteSpacing = 'EvenSites';
else
    iSiteSpacing = 'CD3Zeta';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

switch (constant)
    case 0
        typeReversible = 'Constant';
    case 1
        typeReversible = 'Prefactor';
    case 2
        typeReversible = 'ConstantPhos';
end

% data location
filefolder = '~/Documents/Papers/MultisiteDisorder/Data/1.LocalStructuring/';
filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Reversible/CatFiles/',typeReversible];

% save location for figures
%savefolder = '~/Documents/Papers/MultisiteDisorder/Figures/1.LocalStructuring/';
savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/1.LocalStructuring/';
savesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/Plots/Hill/',typeReversible];

% range of parameter sweep
sweep = -1:1:5;
%sweep = -1
totalAAImmPerMod = [0, sweep(2:end)*2+1];
% figure parameters
colors = flipud(cool(max(sweep)+2));
lw = 2;
ms_hill = 2;
ms_coeff = 7;
ms_lw = 1.5;

hillcoeffEst = zeros(length(sweep),1);
hillcoeffEstPhos = zeros(length(sweep),1);
HillCoeffMaxSlope = zeros(length(sweep),1);
hillcoeffEst_Bootstrap_Mean = zeros(length(sweep),1);
hillcoeffEst_Bootstrap_Std = zeros(length(sweep),1);
HillCoeffMaxSlope_Bootstrap_Mean = zeros(length(sweep),1);
HillCoeffMaxSlope_Bootstrap_Std = zeros(length(sweep),1);

for s = 1:length(sweep)

    filename = ['ReversibleGillespie',iSiteSpacing,'Membrane',membraneState,typeReversible,'StiffenRange.',num2str(sweep(s)),'.cat'];


    %% Import data, parse into variables
    M = dlmread(fullfile(filefolder,filesubfolder,filename));

    iSiteTotal     = M(1,2);
    reverseRate    = M(:,1); % rate of phosphatase
    avgSteadyState = M(:,4); % fraction phosphorylated as function of increasing phosphatase
    avgBound       = M(:,5); % total number phosphorylated as function of increasing phosphatase
    iterations_End = M(:,6);
    
    kinaseIntrinsicRate = 1./reverseRate; % kinase:phosphatase

    %% Find hill coeff for original data
    [hillcoeffEstTemp, KA_EstTemp, HillCoeffMaxSlopeTemp, kinaseIntrinsicRatePlot,slopeLogLog] = computeHillCoeff(constant, kinaseIntrinsicRate, avgSteadyState);
    
    hillcoeffEst(s) = hillcoeffEstTemp;
    KA_Est(s) = KA_EstTemp;
    HillCoeffMaxSlope(s) = HillCoeffMaxSlopeTemp;
    
    %% Plot Log(y/(1-y)) VS Log(K/P)
    figure(3); box on; hold on;
    plot(log10(kinaseIntrinsicRate), log10((avgSteadyState)./(1-avgSteadyState)),'-o','Color',colors(s,:),'LineWidth',lw);
    xlabel1 = 'log(Kinase Intrinsic Rate)';
    ylabel1 = 'log(\theta/(1-\theta)';

    xlabel(xlabel1);
    ylabel(ylabel1);
    if(saveTF)
        saveas(gcf,fullfile(savefolder,savesubfolder,'LogLogDoseResponse'),'fig');
        saveas(gcf,fullfile(savefolder,savesubfolder,'LogLogDoseResponse'),'epsc');
    end

    %% Plot Slope vs Kinase Intrinsic Rate
    figure(33); hold on; box on;
    plot(kinaseIntrinsicRatePlot,slopeLogLog,'-*k','LineWidth',2,'Color',colors(s,:));
    xlabel('Kinase Intrinsic Rate');
    ylabel('Slope of Hill curve');
    if(saveTF)
        saveas(gcf,fullfile(savefolder,savesubfolder,'SlopeVSPhosRate'),'fig');
        saveas(gcf,fullfile(savefolder,savesubfolder,'SlopeVSPhosRate'),'epsc');
    end

    %% Plot Hill curves

    % plot - for no labels version
    figure(1); box on; hold on;
    plot(kinaseIntrinsicRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill,'MarkerFaceColor',colors(s,:));

    % plot - for labels version
    figure(10); box on; hold on;
    plot(kinaseIntrinsicRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill,'MarkerFaceColor',colors(s,:));
    

    %% Bootstrap Hill coefficients for error
    N_Bootstrap = 100000;
    
    % initialize arrays
    hillcoeffEst_Bootstrap = zeros(N_Bootstrap,1);
    HillCoeffMaxSlope_Bootstrap = zeros(N_Bootstrap,1);
    
    % compute bootstrap distribution
    for bootIter = 1:N_Bootstrap   
        %sample = sort(randsample(length(kinaseIntrinsicRate),length(kinaseIntrinsicRate)-ceil(0.2*length(kinaseIntrinsicRate)))); % create and sort a random sample with replacement from indices of kinaseIntrinsicRate
        sample = sort(unique(randi(length(kinaseIntrinsicRate),length(kinaseIntrinsicRate),1))); % create and sort a random sample with replacement from indices of kinaseIntrinsicRate
        kIR_sample = kinaseIntrinsicRate(sample);
        aSS_sample = avgSteadyState(sample);
        [hillcoeffEstTemp, ~, HillCoeffMaxSlopeTemp, ~,~] = computeHillCoeff(constant, kIR_sample, aSS_sample);
        hillcoeffEst_Bootstrap(bootIter) = hillcoeffEstTemp;
        HillCoeffMaxSlope_Bootstrap(bootIter) = HillCoeffMaxSlopeTemp;        
    end
        
    % for debugging
    figure(4);
    hist(hillcoeffEst_Bootstrap);

    figure(40);
    hist(HillCoeffMaxSlope_Bootstrap);
    
    hillcoeffEst_Bootstrap_Mean(s) = mean(hillcoeffEst_Bootstrap);
    hillcoeffEst_Bootstrap_Std(s) = std(hillcoeffEst_Bootstrap);
    
    HillCoeffMaxSlope_Bootstrap_Mean(s) = mean(HillCoeffMaxSlope_Bootstrap);
    HillCoeffMaxSlope_Bootstrap_Std(s) = std(HillCoeffMaxSlope_Bootstrap);


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters for theoretical hill curve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=1;
KA = KA_Est(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Hill Curves - no labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
plot(kinaseIntrinsicRate,((kinaseIntrinsicRate).^n./((KA^n)+(kinaseIntrinsicRate.^n))),'--k','LineWidth',2.5);
set(gca,'XScale','log');
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

switch (constant)
    case 0
        xlim([10^0,10^4]);
    case 1
        xlim([10^(-2),10^3]);
    case 2
        xlim([10^(-4),10^2]);

end


if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRate'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRate'),'epsc');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Hill Curves - with labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10);
plot(kinaseIntrinsicRate,((kinaseIntrinsicRate).^n./((KA^n)+(kinaseIntrinsicRate.^n))),'--k','LineWidth',2.5);

set(gca,'XScale','log');
xlabel1 = 'Kinase intrinsic rate';
ylabel1 = 'Fraction of sites phosphorylated';

if(~spacing) % if CD3Zeta
    switch (constant)
        case 0
            xlim([10^0,10^4]);
        case 1
            xlim([10^(-2),10^3]);
        case 2
            xlim([10^(-4),10^2]);
    end
else
    switch (constant)
        case 0
            xlim([10^(-1),10^4]);
        case 1
            xlim([10^(-2),10^3]);
    end
end
    

% display axix labels
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);

legend('StiffRange = None','StiffRange = 0','StiffRange = 1','StiffRange = 2','StiffRange = 3',...
        'StiffRange = 4','StiffRange = 5',...
        'k_F/(1.0031+k_F)','Location','northwest');

% colorbar
colormap cool;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
set(h,'ylim',[0 1]);

if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRateLabels'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRateLabels'),'epsc');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Hill numbers vs sweep parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gray = [0.7 0.7 0.7];
figure(34); hold on; box on;
plot(totalAAImmPerMod,HillCoeffMaxSlope,'-k','LineWidth',lw);
for s=1:length(sweep)
    %plot(totalAAImmPerMod(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
    errorbar(totalAAImmPerMod(s),HillCoeffMaxSlope(s),HillCoeffMaxSlope_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
plot(totalAAImmPerMod,hillcoeffEst,'-','Color',gray,'LineWidth',lw);
for s=1:length(sweep)
    %plot(totalAAImmPerMod(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
    errorbar(totalAAImmPerMod(s),hillcoeffEst(s),hillcoeffEst_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
end
switch constant
    case {0,1}
        ylim([0.8 2]);
    case 2
        ylim([0.6 1.5]);
end
xlim([0 11]);
set(gca,'XTick',0:1:11);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSTotalImm'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSTotalImm'),'epsc');
end


figure(340); hold on; box on;
plot(totalAAImmPerMod,HillCoeffMaxSlope,'-k','LineWidth',lw);
for s=1:length(sweep)
    %plot(totalAAImmPerMod(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
    errorbar(totalAAImmPerMod(s),HillCoeffMaxSlope(s),HillCoeffMaxSlope_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
plot(totalAAImmPerMod,hillcoeffEst,'-','Color',gray,'LineWidth',lw);
for s=1:length(sweep)
    %plot(totalAAImmPerMod(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
    errorbar(totalAAImmPerMod(s),hillcoeffEst(s),hillcoeffEst_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
end
xlabel1 = {'Total amino acids', 'immobiziled per modification'};
ylabel1 = 'Hill coefficient';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
switch constant
    case {0,1}
        ylim([0.8 2]);
    case 2
        ylim([0.6 1.5]);
end
xlim([0 11]);
set(gca,'XTick',0:1:11);
colormap cool;
%h = colorbar;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
set(h,'ylim',[0 7/9]);
%legend('Max Slope','Decile');
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSTotalImmLabels'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSTotalImmLabels'),'epsc');
end

