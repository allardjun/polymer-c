%% Analysis_GillespieReversibleConstant
clear all; close all;

%% Initialize model parameters

saveTF = 1; % save figures

spacing = 0; % 0 = CD3Zeta spacing, 1 = evenly spaced tyrosines
membrane = 1; % 0 = no membrane, 1 = membrane
constant = 0; % 0 = steric-influenced dephosphorylation, 1 = steric-influenced dephosphorylation, 2 = constant phosphorylation

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
totalAAImmPerMod = [0, sweep(2:end)*2+1];
% figure parameters
colors = flipud(cool(max(sweep)+2));
lw = 2;
ms_hill = 2;
ms_coeff = 7;
ms_lw = 1.5;

hillcoeffEst = zeros(length(sweep),1);
hillcoeffEstPhos = zeros(length(sweep),1);

for s = 1:length(sweep)

    filename = ['ReversibleGillespie',iSiteSpacing,'Membrane',membraneState,typeReversible,'StiffenRange.',num2str(sweep(s)),'.cat'];


    %% Import data, parse into variables
    M = dlmread(fullfile(filefolder,filesubfolder,filename));

    iSiteTotal     = M(1,2);
    reverseRate    = M(:,1);
    avgSteadyState = M(:,4);
    avgBound       = M(:,5);
    iterations_End = M(:,6);
    
    %% Find 0.1 and 0.9 x values for estimating Hill coefficient
    % This is super ugly - clean this up - better variable names etc
    
    i11 = find((1-avgSteadyState)-0.1<0,1,'last');
    i12 = find((1-avgSteadyState)-0.1>0,1,'first');
    x11 = reverseRate(i11);
    x12 = reverseRate(i12);
    slope1 = ((1-avgSteadyState(i11))-(1-avgSteadyState(i12)))/(reverseRate(i11)-reverseRate(i12));
    
    i91 = find((1-avgSteadyState)-0.9<0,1,'last');
    i92 = find((1-avgSteadyState)-0.9>0,1,'first');
    x91 = reverseRate(i91);
    x92 = reverseRate(i92);
    slope9 = ((1-avgSteadyState(i91))-(1-avgSteadyState(i92)))/(reverseRate(i91)-reverseRate(i92));
    
    x1 = (0.1-(1-avgSteadyState(i11)))/slope1 + x11;
    x9 = (0.9-(1-avgSteadyState(i91)))/slope9 + x91;
    
    hillcoeffEst(s) = log10(81)/(log10(x9/x1));
 
    %% Find KA
    
    i51 = find((1-avgSteadyState)-0.5<0,1,'last');
    i52 = find((1-avgSteadyState)-0.5>0,1,'first');
    x51 = reverseRate(i51);
    x52 = reverseRate(i52);
    slope5 = ((1-avgSteadyState(i51))-(1-avgSteadyState(i52)))/(reverseRate(i51)-reverseRate(i52));
    
    KA_Est(s) = (0.5-(1-avgSteadyState(i51)))/slope5 + x51;
   
    %% MAX LOG SLOPE Hill Coeff Estimate

    switch (constant)
        case 0
            diffy = diff(movmean(log10((1-avgSteadyState(45:end-20))./(avgSteadyState(45:end-20))),3));
            diffx = diff(log10(reverseRate(45:end-20)));
            slope = diffy./diffx;
            HillCoeffMaxSlope(s) = max(slope);
            
            reverseRatePlot = log10(reverseRate(46:end-20));
        case 1
            diffy = diff(movmean(log10((1-avgSteadyState(45:end-20))./(avgSteadyState(45:end-20))),3));
            diffx = diff(log10(reverseRate(45:end-20)));
            slope = diffy./diffx;
            HillCoeffMaxSlope(s) = max(slope);
            
            reverseRatePlot = log10(reverseRate(46:end-20));
        case 2
            diffy = diff(movmean(log10((1-avgSteadyState(45:end))./(avgSteadyState(45:end))),3));
            diffx = diff(log10(reverseRate(45:end)));
            slope = diffy./diffx;
            HillCoeffMaxSlope(s) = max(slope);
            
            reverseRatePlot = log10(reverseRate(46:end));
    end

    % Plot
    figure(33); hold on;
    plot(reverseRatePlot,slope,'-*k','LineWidth',2,'Color',colors(s,:));
    xlabel('Phosphatase Rate');
    ylabel('Slope of Hill curve');

    %% Plot Hill curves

    % plot 
    figure(1); box on; hold on;
    plot(1./reverseRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill,'MarkerFaceColor',colors(s,:));

    
    figure(10); box on; hold on;
    plot(1./reverseRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill,'MarkerFaceColor',colors(s,:));


    %
    figure(11); box on; hold on;
    plot(reverseRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill);
    %plot(reverseRate,reverseRate,'-','Color',[1.0000, 0.2857, 0],'LineWidth',10);
    %set(gca,'XScale','log');
    xlabel1 = 'Phosphatase Rate';
    ylabel1 = 'Fraction of sites phosphorylated';
    
    xlabel(xlabel1,'FontName','Arial','FontSize',18);
    ylabel(ylabel1,'FontName','Arial','FontSize',18);
    
    %
    figure(2); clf; box on; hold on;
    plot(reverseRate, avgBound, '-ob','Color',colors(s,:),'LineWidth',lw);
    plot(reverseRate, avgSteadyState*iSiteTotal,'-or','LineWidth',lw);
    set(gca,'XScale','log');
    legend('avgBound','fractionBound*iSiteTotal');
    xlabel1 = 'Phosphatase Rate';
    ylabel1 = 'Number of sites phosphorylated';

    xlabel(xlabel1);
    ylabel(ylabel1);
    
    %
    figure(3); box on; hold on;
    plot(log10(reverseRate), log10((1-avgSteadyState)./(avgSteadyState)),'-o','Color',colors(s,:),'LineWidth',lw);
    xlabel1 = 'log(Phosphatase Rate)';
    ylabel1 = 'log(\theta/(1-\theta)';

    xlabel(xlabel1);
    ylabel(ylabel1);


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
plot(1./reverseRate,1-((reverseRate).^n./((KA^n)+(reverseRate.^n))),'--k','LineWidth',2.5);
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
plot(1./reverseRate,1-((reverseRate).^n./((KA^n)+(reverseRate.^n))),'--k','LineWidth',2.5);

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
    plot(totalAAImmPerMod(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
plot(totalAAImmPerMod,hillcoeffEst,'-','Color',gray,'LineWidth',lw);
for s=1:length(sweep)
    plot(totalAAImmPerMod(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
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
    plot(totalAAImmPerMod(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
plot(totalAAImmPerMod,hillcoeffEst,'-','Color',gray,'LineWidth',lw);
for s=1:length(sweep)
    plot(totalAAImmPerMod(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
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

