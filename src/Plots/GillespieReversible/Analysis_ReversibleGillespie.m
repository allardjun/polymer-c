%% Analysis_GillespieReversibleConstant
clear all; close all;

%% Initialize model parameters

saveTF = 0; % save figures
model = 10; % 10 = Stiffening, 20 = electrostatics
spacing = 0; % 0 = CD3Zeta spacing, 1 = evenly spaced tyrosines, 2 = CD3Epsilon
membrane = 1; % 0 = no membrane, 1 = membrane
constant = 1; % 0 = steric-independent dephosphorylation, 1 = steric-influenced dephosphorylation, 2 = constant phosphorylation

% parameters to file label conversion
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

switch (constant)
    case 0
        typeReversible = 'Constant';
    case 1
        typeReversible = 'Prefactor';
    case 2
        typeReversible = 'ConstantPhos';
end

switch model
    case 10
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
        sweepVariable = [0, sweep(2:end)*2+1]; % totalAAImmPerMod
        % figure parameters
        colors = flipud(cool(max(sweep)+2));
        lw = 2;
        ms_hill = 2;
        ms_coeff = 7;
        ms_lw = 1.5;
        colormapName = cool;
        
    case 20
        switch(spacing)
            case 2
                filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
                filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/TwoSites/3.Gillespie/Reversible/CatFiles/',typeReversible];
            otherwise
                filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
                filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Reversible/CatFiles/',typeReversible];
        end
        % save location for figures
        savefolder    = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/2.MembraneAssociation/';
        savesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/Plots/Hill/',typeReversible];

        lw = 2;
        ms_hill = 2;
        ms_coeff = 7;
        ms_lw = 1.5;
        sweep = 0:2:20;
        %sweep = 20
        sweepVariable = 0.5*(sweep); % EP0
        colors = parula(length(sweep));
        colormapName = parula;
end


%% Initialize arrays
hillEC90EC10Est = zeros(length(sweep),1);
hillcoeffEstPhos = zeros(length(sweep),1);
HillCoeffMaxSlope = zeros(length(sweep),1);
hillEC90EC10Est_Mean = zeros(length(sweep),1);
hillEC90EC10Est_Std = zeros(length(sweep),1);
HillCoeffMaxSlope_Mean = zeros(length(sweep),1);
HillCoeffMaxSlope_RMSE = zeros(length(sweep),1);

%% Loop through data
for s = 1:length(sweep)

    
    switch model
        case 10
            filename = ['ReversibleGillespie',iSiteSpacing,'Membrane',membraneState,typeReversible,'StiffenRange.',num2str(sweep(s)),'.cat'];
        case 20      
            filename = ['ReversibleGillespie',iSiteSpacing,'Membrane',membraneState,typeReversible,'EP0.',num2str(sweep(s)),'.cat'];
    end

    %% Import data, parse into variables
    M = dlmread(fullfile(filefolder,filesubfolder,filename));

    iSiteTotal     = M(1,2);
    reverseRate    = M(:,1); % rate of phosphatase
    avgSteadyState = M(:,4); % fraction phosphorylated as function of increasing phosphatase
    avgBound       = M(:,5); % total number phosphorylated as function of increasing phosphatase
    iterations_End = M(:,6);
    
    kinaseIntrinsicRate = 1./reverseRate; % kinase:phosphatase

    %% Find hill coeff for original data - log(81)/log(EC90/EC10)
    
    % Compute estimate from log(81)/log(EC90/EC10)
    [hillEC90EC10EstTemp, KA_EstTemp] = computeHillEC90EC10(kinaseIntrinsicRate, avgSteadyState);
    % store result
    hillEC90EC10Est(s) = hillEC90EC10EstTemp;
    KA_Est(s) = KA_EstTemp;
    
    %% Bootstrap Hill coefficients for error - log(81)/log(EC90/EC10)
    N_Bootstrap = 100000;

    % initialize arrays
    hillEC90EC10Est_Bootstrap = zeros(N_Bootstrap,1);

    % compute bootstrap distribution
    for bootIter = 1:N_Bootstrap   
        %sample = sort(randsample(length(kinaseIntrinsicRate),length(kinaseIntrinsicRate)-ceil(0.2*length(kinaseIntrinsicRate)))); % create and sort a random sample with replacement from indices of kinaseIntrinsicRate
        sample = sort(unique(randi(length(kinaseIntrinsicRate),length(kinaseIntrinsicRate),1))); % create and sort a random sample with replacement from indices of kinaseIntrinsicRate
        kIR_sample = kinaseIntrinsicRate(sample);
        aSS_sample = avgSteadyState(sample);
        [hillEC90EC10EstTemp, ~] = computeHillEC90EC10(kIR_sample, aSS_sample);
        hillEC90EC10Est_Bootstrap(bootIter) = hillEC90EC10EstTemp;
    end

    % for debugging
    figure(4);
    hist(hillEC90EC10Est_Bootstrap);

    figure(40);
    hist(HillCoeffMaxSlope_Bootstrap);

    hillEC90EC10Est_Mean(s) = mean(hillEC90EC10Est_Bootstrap);
    hillEC90EC10Est_Std(s) = std(hillEC90EC10Est_Bootstrap);

    %% Compute hill estimate and error from max log slope
    [HillCoeffMaxSlopeTemp,HillCoeffMaxSlopeRMSETemp, kinaseIntrinsicRatePlot,slopeLogLog,slope_fit] = computeHillMaxLogSlope(model,constant,spacing,kinaseIntrinsicRate, avgSteadyState);
    % store result
    HillCoeffMaxSlope(s) = HillCoeffMaxSlopeTemp;
    HillCoeffMaxSlope_RMSE(s) = HillCoeffMaxSlopeRMSETemp;
    
    %% Plot Log(y/(1-y)) VS Log(K/P)
    figure(3); box on; hold on;
    plot(log10(kinaseIntrinsicRate), log10((avgSteadyState)./(1-avgSteadyState)),'-o','Color',colors(s,:),'LineWidth',lw);
    xlabel1 = 'log(Kinase Intrinsic Rate)';
    ylabel1 = 'log(\theta/(1-\theta)';

    xlabel(xlabel1);
    ylabel(ylabel1);

    %% Plot Slope vs Kinase Intrinsic Rate
    figure(33); hold on; box on;
    plot(kinaseIntrinsicRatePlot,slopeLogLog,'*','LineWidth',2,'Color',colors(s,:));
    plot(kinaseIntrinsicRatePlot,slope_fit,'-','LineWidth',2,'Color',colors(s,:));
    xlabel('Kinase Intrinsic Rate');
    ylabel('Slope of Hill curve');


    %% Plot Hill curves

    % plot - for no labels version
    figure(1); box on; hold on;
    plot(kinaseIntrinsicRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill,'MarkerFaceColor',colors(s,:));

    % plot - for labels version
    figure(10); box on; hold on;
    plot(kinaseIntrinsicRate, avgSteadyState,'-o','Color',colors(s,:),'LineWidth',lw,'MarkerSize',ms_hill,'MarkerFaceColor',colors(s,:));

end

figure(3);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'LogLogDoseResponse'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'LogLogDoseResponse'),'epsc');
end

figure(33);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'SlopeVSPhosRate'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'SlopeVSPhosRate'),'epsc');
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

switch model
    case 10
        switch (constant)
            case 0
                xlim([10^0,10^4]);
            case 1
                xlim([10^(-2),10^3]);
            case 2
                xlim([10^(-4),10^2]);
        end
    case 20
        switch (constant)
            case 0
                xlim([10^0,10^4]);
            case 1
                xlim([10^(-2),10^2]);
        end
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


switch model
    case 10
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
    case 20
        switch (spacing)
            case {0,2}
                switch (constant)
                    case 0
                        xlim([10^0,10^4]);
                    case 1
                        xlim([10^(-2),10^2]);
                end
            case 1
                switch (constant)
                    case 0
                        xlim([10^(-1),10^4]);
                    case 1
                        xlim([10^(-2),10^2]);
                end
        end
end
    

% display axix labels
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);

legend('StiffRange = None','StiffRange = 0','StiffRange = 1','StiffRange = 2','StiffRange = 3',...
        'StiffRange = 4','StiffRange = 5',...
        'k_F/(1.0031+k_F)','Location','northwest');

% colorbar
set(gcf,'Colormap',colormapName);
switch model
    case 10
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    case 20
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
end
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
errorbar(sweepVariable,HillCoeffMaxSlope,HillCoeffMaxSlope_RMSE,'-k','LineWidth',lw);
for s=1:length(sweep)
    plot(sweepVariable(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
% errorbar(sweepVariable,hillcoeffEst,hillcoeffEst_Std,'-','Color',gray,'LineWidth',lw);
% for s=1:length(sweep)
%     plot(sweepVariable(s),hillcoeffEst(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
%     %errorbar(sweepVariable(s),hillcoeffEst(s),hillcoeffEst_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
% end
switch model
    case 10
        xlim([0 11]);
        set(gca,'XTick',0:1:11);
        switch constant
            case {0,1}
                ylim([0.8 2]);
            case 2
                ylim([0.6 1.5]);
        end
    case 20
        ylim([0.9 1.5]);
        xlim([0 10]);
        set(gca,'XTick',0:1:10);
end
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSSweepParameter'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSSweepParameter'),'epsc');
end

%% Hill Numbers with EC90/EC10 Estimate
figure(35); hold on; box on;
errorbar(sweepVariable,HillCoeffMaxSlope,HillCoeffMaxSlope_RMSE,'-k','LineWidth',lw);
for s=1:length(sweep)
    plot(sweepVariable(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
errorbar(sweepVariable,hillEC90EC10Est,hillEC90EC10Est_Std,'-','Color',gray,'LineWidth',lw);
for s=1:length(sweep)
    plot(sweepVariable(s),hillEC90EC10Est(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
    %errorbar(sweepVariable(s),hillcoeffEst(s),hillcoeffEst_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
end
switch model
    case 10
        xlim([0 11]);
        set(gca,'XTick',0:1:11);
        switch constant
            case {0,1}
                ylim([0.8 2]);
            case 2
                ylim([0.6 1.5]);
        end
    case 20
        ylim([0.9 1.5]);
        xlim([0 10]);
        set(gca,'XTick',0:1:10);
end
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);
if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSSweepParameter_EC90EC10'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSSweepParameter_EC90EC10'),'epsc');
end


%% Hill Numbers With Labels
figure(340); hold on; box on;
errorbar(sweepVariable,HillCoeffMaxSlope,HillCoeffMaxSlope_RMSE,'-k','LineWidth',lw);
for s=1:length(sweep)
    plot(sweepVariable(s),HillCoeffMaxSlope(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
    %errorbar(sweepVariable(s),HillCoeffMaxSlope(s),HillCoeffMaxSlope_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor','k');
end
errorbar(sweepVariable,hillEC90EC10Est,hillEC90EC10Est_Std,'-','Color',gray,'LineWidth',lw);
for s=1:length(sweep)
    plot(sweepVariable(s),hillEC90EC10Est(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
    %errorbar(sweepVariable(s),hillcoeffEst(s),hillcoeffEst_Bootstrap_Std(s),'o','LineWidth',ms_lw,'Color',colors(s,:),'MarkerSize',ms_coeff,'MarkerFaceColor',colors(s,:),'MarkerEdgeColor',gray);
end

switch model
    case 10
        xlim([0 11]);
        set(gca,'XTick',0:1:11);
        xlabel1 = {'Total amino acids', 'immobiziled per modification'};
        ylabel1 = 'Hill coefficient';
        switch constant
            case {0,1}
                ylim([0.8 2]);
            case 2
                ylim([0.6 1.5]);
        end
    case 20
        xlabel1 = {'EP0'};
        ylabel1 = 'Hill coefficient';
        ylim([0.9 1.5]);
        xlim([0 10]);
        set(gca,'XTick',0:1:10);
        
end

xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
set(gcf,'Colormap',colormapName);
switch model
    case 10
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    case 20
        h = colorbar('Ticks',[0 1],'TickLabels',{'',''});
end
set(h,'ylim',[0 1]);

if(saveTF)
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSSweepParameterLabels'),'fig');
    saveas(gcf,fullfile(savefolder,savesubfolder,'HillCoeffVSSweepParameterLabels'),'epsc');
end

