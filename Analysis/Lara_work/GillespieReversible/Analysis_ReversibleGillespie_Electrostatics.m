%% Analysis_GillespieReversibleConstant
clear all; close all;

saveTF = 1;

constant = 1;
membrane = 1;
spacing = 0;

switch (spacing)
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'CD3Epsilon';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

if (constant)
    typeReversible = 'Constant';
else
    typeReversible = 'Prefactor';
end

switch(spacing)
    case 2
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/TwoSites/3.Gillespie/Reversible/CatFiles/',typeReversible];
    otherwise
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Reversible/CatFiles/',typeReversible];
end



savefolder    = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/2.MembraneAssociation/';
savesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/Plots/Hill/',typeReversible];


lw = 2;
ms_hill = 2;
ms_coeff = 7;
ms_lw = 1.5;
paramset = 0:2:20;
EP0 = 0.5*(paramset);
colors = parula(length(paramset));

hillcoeffEst = zeros(length(paramset),1);
hillcoeffEstPhos = zeros(length(paramset),1);

for s = 1:length(paramset)

    filename = ['ReversibleGillespie',iSiteSpacing,'Membrane',membraneState,typeReversible,'EP0.',num2str(paramset(s)),'.cat'];


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

    % OLD METHOD: Arbitrary user defined restriction on domain - same
    % restriction on all datasets
%     diffy = diff(movmean(log10((1-avgSteadyState(40:end-20))./(avgSteadyState(40:end-20))),3));
%     diffx = diff(log10(reverseRate(40:end-20)));
%     slope = diffy./diffx;
%     HillCoeffMaxSlope(s) = max(slope);
% 
%     % Plot
%     figure(33); hold on;
%     plot(log10(reverseRate(41:end-20)),slope,'-*k','LineWidth',2,'Color',colors(s,:));
%     xlabel('Phosphatase Rate');
%     ylabel('Slope of Hill curve');

    % NEW METHOD: Restriction on domain determined based on standard range
    % for that dataset
    % NOTE: reverseRate range needs to be 1/kinaseIntrinsicRate
    
    switch(spacing)
        case 0
            if(constant)
                % for constant:
                % use domain on right of axis
                domainStart = find(reverseRate > 10^(-3),1,'first');
                domainEnd = find(reverseRate > 10^(-1),1,'first');
                if( isempty(domainStart) || isempty(domainEnd) )
                    disp('Warning: domain index extends past domain!');
                end
            else
                % for prefactor:
                domainStart = find(reverseRate > 10^(-1),1,'first');
                domainEnd = find(reverseRate > 10^(1),1,'first');
            end
        case 1
            domainStart = 1;
            domainEnd = length(reverseRate);
            disp("Warning: no bounds set for EvenSite spacing!");
        case 2
            if(constant)
                % for constant:
                % use domain on right of axis
                domainStart = find(reverseRate > 10^(-3),1,'first');
                domainEnd = find(reverseRate > 10^(-1),1,'first');
                if( isempty(domainStart) || isempty(domainEnd) )
                    disp('Warning: domain index extends past domain!');
                end
            else
                % for prefactor:
                domainStart = find(reverseRate > 10^(-1),1,'first');
                domainEnd = find(reverseRate > 10^(1),1,'first');
            end
    end

    
    diffy = diff(movmean(log10((1-avgSteadyState(domainStart:domainEnd))./(avgSteadyState(domainStart:domainEnd))),3));
    diffx = diff(log10(reverseRate(domainStart:domainEnd)));
    slope = diffy./diffx;
    HillCoeffMaxSlope(s) = max(slope);
        

    % Plot
    figure(33); hold on;
    plot(log10(reverseRate(domainStart+1:domainEnd)),slope,'-*k','LineWidth',2,'Color',colors(s,:));
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

%% Parameters for theoretical hill curve
n=1;
KA = KA_Est(1);

%% Plot Hill Curves - no labels
figure(1);
plot(1./reverseRate,1-((reverseRate).^n./((KA^n)+(reverseRate.^n))),'--k','LineWidth',2.5);
set(gca,'XScale','log');
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(constant)
    xlim([10^0,10^4]);
else
    xlim([10^(-2),10^2]);
end


if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRate'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRate'),'epsc');
end

%% Plot Hill Curves - with labels
figure(10);
plot(1./reverseRate,1-((reverseRate).^n./((KA^n)+(reverseRate.^n))),'--k','LineWidth',2.5);

set(gca,'XScale','log');
xlabel1 = 'Kinase intrinsic rate';
ylabel1 = 'Fraction of sites phosphorylated';

switch(spacing)
    case 0
        if(constant)
            xlim([10^0,10^4]);
        else
            xlim([10^(-2),10^2]);
        end
    case 1
        if(constant)
            xlim([10^(-1),10^4]);
        else
            xlim([10^(-2),10^2]);
        end
    case 2
        if(constant)
            xlim([10^0,10^4]);
        else
            xlim([10^(-2),10^2]);
        end

end
    

% display axix labels
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);

% colorbar
colormap parula;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
set(h,'ylim',[0 1]);

if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRateLabels'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'PhosFractionVSPhosRateLabels'),'epsc');
end

%% Plot Hill numbers vs sweep parameter
gray = [0.7 0.7 0.7];
figure(34); clf; hold on; box on;
plot(EP0,HillCoeffMaxSlope,'-k','LineWidth',lw);
for s=1:length(paramset)
    plot(EP0(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
plot(EP0,hillcoeffEst,'-','Color',gray,'LineWidth',lw);
for s=1:length(paramset)
    plot(EP0(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
end
ylim([0.9 1.5]);
xlim([0 10]);
set(gca,'XTick',0:1:10);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSEP0'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSEP0'),'epsc');
end


figure(340); clf; hold on; box on;
plot(EP0,HillCoeffMaxSlope,'-k','LineWidth',lw);
for s=1:length(paramset)
    plot(EP0(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
plot(EP0,hillcoeffEst,'-','Color',gray,'LineWidth',lw);
for s=1:length(paramset)
    plot(EP0(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
end
xlabel1 = {'EP0'};
ylabel1 = 'Hill coefficient';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
ylim([0.9 1.5]);
xlim([0 10]);
set(gca,'XTick',0:1:10);
colormap parula;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
set(h,'ylim',[0 1]);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSEP0labels'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSEP0labels'),'epsc');
end

