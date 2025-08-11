%% Look at polymer location distributions for Electrostatics

clear all;
close all;

%% Initialize parameters

ZETA = 1;

if(ZETA)
    combinations=64;
    N=113;
    iSiteTotal = 6;
else
    combinations = 4;
    N = 57;
    iSiteTotal = 2;
end

NTCHECK = 200000;
NBINS = 3000; % how many bins are there currently
KBT = 4.14;
BinSize = 2*N/NBINS; % what is the current binsize
bSiteTotal = 0; % how many bound ligands are there - for reading files properly
saveTF = 0; % save figures
rebin = 1; % rebin distributions to smooth

server = 0;

if(server)
    folder = '/Volumes/laraclemens/Documents/pub/lclemens/polymer-c_runs';
    controlFolder = '/Volumes/laraclemens/Documents/polymer-c_runs';
else
    folder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/CD3Zeta/MembraneOn/0.Distributions/';
    controlFolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/CD3Zeta/MembraneOn/0.Distributions/';
end
controlSubfolder = '20180409MembraneAssociationCD3ZetaMembraneOnEB0Zero';

% EP0 sweep
subfolder = '20180530MembraneAssociationCD3ZetaMembraneOnEP0Sweep';
savefolder = '~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/CD3Zeta/MembraneOn/Distributions/';

filenamePrefix = 'CD3ZetaElectrostatics';

PD = 0.5;  % parabola depth
PW = 0.5/9;  % parabola width
WK = 0.05;  % wall parabola k
ER = logspace(-2,2,101);  % repulsive energy multiplier
ZR = 3;  % repulsive energy exponent multiplier
ER2ind = find(ER>2,1,'first');

sweepVariable = ER;
colors = parula(202);
colors_gray = flipud(gray(202));
        
%% Read Files

fileDoesNotExist=0;
distributionData = zeros(length(WK),length(PD),length(PW),length(ER),length(ZR),iSiteTotal+1,NBINS);

for k = 1:length(WK)
    for w = 1:length(PW)
        for d = 1:length(PD)
            for e = 1:length(ER)
                for z = 1:length(ZR)
                    
                    %% Open file and retrieve distribution data

                    filename = strcat(filenamePrefix,'.','PD','.',num2str(d),'PW','.',num2str(w),'WK','.',num2str(k),'ER','.',num2str(e),'ZR','.',num2str(z));
                    
                    if(exist(fullfile(folder,subfolder,filename))~=0)
                        
                        M = dlmread(fullfile(folder,subfolder,filename));

                        ntTotal = M(1,12);

                        % Collect variance data for polymer tip
                        ree2(k,w,d,e,z) = M(1,15);
                        rM(k,w,d,e,z) = M(1,16);
                        rM2(k,w,d,e,z) = M(1,7+9+5*iSiteTotal+3+bSiteTotal+2*iSiteTotal*bSiteTotal+iSiteTotal+(iSiteTotal+1)*NBINS+1);

                        for i=1:1:iSiteTotal+1
                            start = 7+9+5*iSiteTotal+3+bSiteTotal+2*iSiteTotal*bSiteTotal+iSiteTotal+(i-1)*NBINS+1;

                            frequencyData(k,w,d,e,z,i,:) = M(1,start:start+NBINS-1);
                            distributionData(k,w,d,e,z,i,:) = frequencyData(k,w,d,e,z,i,:)./(sum(frequencyData(k,w,d,e,z,i,:).*BinSize));
                            distributionDataNM(k,w,d,e,z,i,:) = frequencyData(k,w,d,e,z,i,:)./(sum(frequencyData(k,w,d,e,z,i,:).*BinSize*0.3));
                        end
                    else
                        fileDoesNotExist=fileDoesNotExist+1;
                        disp('File Does Not Exist!');
                        disp(filename);
                    end
                    
                end
            end
        end
    end
end

%% Read Files
distributionDataControl = zeros(iSiteTotal+1,NBINS);

%% Open file and retrieve distribution data
controlFilename = 'CD3ZetaElectrostaticsDistributionControl';

M = dlmread(fullfile(controlFolder,controlSubfolder,controlFilename));

ntTotal = M(1,12);
ree2Control = M(1,15);
rMControl = M(1,16);
rM2Control = M(1,7+9+5*iSiteTotal+3+bSiteTotal+2*iSiteTotal*bSiteTotal+iSiteTotal+(iSiteTotal+1)*NBINS+1);

for i=1:1:iSiteTotal+1
    
    start = 7+9+5*iSiteTotal+3+bSiteTotal+2*iSiteTotal*bSiteTotal+iSiteTotal+(i-1)*NBINS+1;

    frequencyDataControl(i,:) = M(1,start:start+NBINS-1);
    distributionDataControl(i,:) = frequencyDataControl(i,:)./(sum(frequencyDataControl(i,:).*BinSize));
    distributionDataControlNM(i,:) = frequencyDataControl(i,:)./(sum(frequencyDataControl(i,:).*BinSize*0.3));
end

%% Plot histograms
lw = 2;
bins = 0:1:NBINS-1;
xaxis = -N+bins.*BinSize;
figureNumber = 1;



hFig = figure(1); clf; hold on; box on;
for i=1:iSiteTotal+1
    for k=1
        for w=1
            for d=1:length(PD)
                for e=1:length(ER)
                    for z=1:length(ZR)
                        
                        plotData = reshape(distributionData(k,w,d,e,z,i,:),[NBINS,1]);
                        hSub = subplot(2,4,i); hold on; box on;
                        plot(xaxis,plotData,'-','Color',colors(2*e,:),'LineWidth',lw);
                        xlim([-3.3333,16.6666]);
                        xlabel1 = 'z-coordinate (Kuhn Length)';
                        ylabel1 = 'Probability Density';
                        
                        if(i==iSiteTotal+1)
                            title1 = strcat('Distribution of Polymer Tip');
                        else
                            title1 = strcat('Distribution of Tyrosine: ', num2str(i));
                        end
                        
                        xlabel(xlabel1,'FontName','Arial','FontSize',18);
                        ylabel(ylabel1,'FontName','Arial','FontSize',18);
                        title(title1,'FontName','Arial','FontSize',18);
                        
                    end
                end
            end
        end
    end
end

figure(1);
for i=1:iSiteTotal+1
    subplot(2,4,i);
    plot([0 0],[0 2],'--k','LineWidth',lw);
    lg1 = plot(xaxis,distributionDataControl(i,:),'--r','LineWidth',lw+0.5);
    plotData = reshape(distributionData(k,w,d,ER2ind,z,i,:),[NBINS,1]);
    lg2 = plot(xaxis,plotData,'--','LineWidth',lw+0.5,'Color',[0.6,0, 0]);
    if(i~=7)
        ylim([0 1]);
    else
        ylim([0 1]);
    end
    cbar = colorbar;
    caxis(log10([10^(-2),10^2]));
    cbar.Label.String = 'Log_{10}(E_{P0})';
    cbar.Label.FontSize = 18;
    xtext = -1;
    ytext = get(gca,'YLim');
    text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
    legend([lg1,lg2],'E_{B0} = 0','E_{P0} = 2');
end
set(gcf,'units','centimeters','position',[1,4,76,33]);

%% Plot histogram in nanometers

xaxisNM = (-N+bins.*BinSize)*0.3;

hFig = figure(100); clf; hold on; box on;
for i=1:iSiteTotal+1
    for k=1
        for w=1
            for d=1:length(PD)
                for e=1:length(ER)
                    for z=1:length(ZR)
                        
                        plotData = reshape(distributionDataNM(k,w,d,e,z,i,:),[NBINS,1]);
                        hSub = subplot(2,4,i); hold on; box on;
                        plot(xaxisNM,plotData,'-','Color',colors(2*e,:),'LineWidth',lw);
                        xlim([-1,5]);
                        xlabel1 = 'z-coordinate (nm)';
                        ylabel1 = 'Probability Density';
                        
                        if(i==iSiteTotal+1)
                            title1 = strcat('Distribution of Polymer Tip');
                        else
                            title1 = strcat('Distribution of Tyrosine: ', num2str(i));
                        end
                        
                        xlabel(xlabel1,'FontName','Arial','FontSize',18);
                        ylabel(ylabel1,'FontName','Arial','FontSize',18);
                        title(title1,'FontName','Arial','FontSize',18);
                        
                    end
                end
            end
        end
    end
end

figure(100);
for i=1:iSiteTotal+1
    subplot(2,4,i);
    plot([0 0],[0 7],'--k','LineWidth',lw);
    lg1 = plot(xaxisNM,distributionDataControlNM(i,:),'--r','LineWidth',lw+0.5);
    plotData = reshape(distributionDataNM(k,w,d,ER2ind,z,i,:),[NBINS,1]);
    lg2 = plot(xaxisNM,plotData,'--','LineWidth',lw+0.5,'Color',[0.6 0 0]);
    if(i~=7)
        ylim([0 2]);
    else
        ylim([0 2]);
    end
    cbar = colorbar;
    caxis(log10([10^(-2),10^2]));
    cbar.Label.String = 'Log_{10}(E_{P0})';
    cbar.Label.FontSize = 18;
    xtext = -0.3;
    ytext = get(gca,'YLim');
    text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
    legend([lg1,lg2],'E_{B0} = 0','E_{P0} = 2');
end
set(gcf,'units','centimeters','position',[1,4,76,33]);

%% Rebin data if necessary

if(rebin)
    rebinSize = 3;
    BinSize_rebin = 2*N/(NBINS/rebinSize);
    for d = 1:length(PD)
        for k=1:length(WK)
            for w = 1:length(PW)
                for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=1:1:iSiteTotal+1
                            frequencyDataRebinned(k,w,d,e,z,i,:) = sum(reshape(frequencyData(k,w,d,e,z,i,:),[rebinSize,NBINS/rebinSize]),1);
                            
                            distributionDataRebinned(k,w,d,e,z,i,:) = frequencyDataRebinned(k,w,d,e,z,i,:)./(sum(frequencyDataRebinned(k,w,d,e,z,i,:).*BinSize_rebin));
                            distributionDataRebinnedNM(k,w,d,e,z,i,:) = frequencyDataRebinned(k,w,d,e,z,i,:)./(sum(frequencyDataRebinned(k,w,d,e,z,i,:).*BinSize_rebin*0.3));
                        end
                    end
                end
            end
        end
    end
    
    
    for i=1:1:iSiteTotal+1
        frequencyDataControlRebinned(i,:) = sum(reshape(frequencyDataControl(i,:),[rebinSize,NBINS/rebinSize]),1);
        distributionDataControlRebinned(i,:) = frequencyDataControlRebinned(i,:)./(sum(frequencyDataControlRebinned(i,:).*BinSize_rebin));
        distributionDataControlRebinnedNM(i,:) = frequencyDataControlRebinned(i,:)./(sum(frequencyDataControlRebinned(i,:).*BinSize_rebin*0.3));
    end
    NBINS_rebin = NBINS/rebinSize;
    bins_rebin = 0:1:NBINS_rebin-1;
    xaxisRebinned = -N+bins_rebin.*BinSize_rebin;
    
    lw = 2;
    hFig = figure(3); clf; hold on; box on;
    for d = 1:length(PD)
        for k=1:length(WK)
            for w = 1:length(PW)
                for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=1:1:iSiteTotal+1
                            
                            plotData = reshape(distributionDataRebinned(k,w,d,e,z,i,:),[NBINS_rebin,1]);
                            hSub = subplot(2,4,i); hold on;
                            plot(xaxisRebinned,plotData,'-','Color',colors(2*e,:),'LineWidth',lw);
                            xlim([-3.3333,16.6666]);
                            xlabel1 = 'z-coordinate (Kuhn Length)';
                            ylabel1 = 'Probability Density';

                            if(i==iSiteTotal+1)
                                title1 = strcat('Distribution of Polymer Tip');
                            else
                                title1 = strcat('Distribution of Tyrosine: ', num2str(i));
                            end
                            
                            xlabel(xlabel1,'FontName','Arial','FontSize',18);
                            ylabel(ylabel1,'FontName','Arial','FontSize',18);
                            title(title1,'FontName','Arial','FontSize',18);
                            
                        end
                        
                    end
                end
            end
            
        end
    end
    
    figure(3);
    for i = 1:iSiteTotal+1
        subplot(2,4,i);
        plot([0 0],[0 2],'--k','LineWidth',lw);
        lg1 = plot(xaxisRebinned,distributionDataControlRebinned(i,:),'--r','LineWidth',lw+0.5);
        plotData = reshape(distributionDataRebinned(k,w,d,ER2ind,z,i,:),[NBINS_rebin,1]);
        lg2 = plot(xaxisRebinned,plotData,'--r','LineWidth',lw+0.5,'Color',[0.6,0, 0]);
        if(i~=7)
            ylim([0 1]);
        else
            ylim([0 1]);
        end
        cbar = colorbar;
        caxis(log10([10^(-2),10^2]));
        cbar.Label.String = 'Log_{10}(E_{P0})';
        cbar.Label.FontSize = 18;
        xtext = -1;
        ytext = get(gca,'YLim');
        text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
        legend([lg1,lg2],'E_{B0} = 0','E_{P0} = 2');
    end
    set(gcf,'units','centimeters','position',[1,4,76,33]);
    
    xaxisRebinnedNM = (-N+bins_rebin.*BinSize_rebin)*0.3;
    lw = 2;
    hFig = figure(300); clf; hold on; box on;
    for d = 1:length(PD)
        for k=1:length(WK)
            for w = 1:length(PW)
                for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=1:1:iSiteTotal+1
                            plotData = reshape(distributionDataRebinnedNM(k,w,d,e,z,i,:),[NBINS_rebin,1]);
                            hSub = subplot(2,4,i); hold on; box on;
                            plot(xaxisRebinnedNM,plotData,'-','Color',colors(2*e,:),'LineWidth',lw);
                            xlim([-1,5]);
                            xlabel1 = 'z-coordinate (nm)';
                            ylabel1 = 'Probability Density';

                            if(i==iSiteTotal+1)
                                title1 = strcat('Distribution of Polymer Tip');
                            else
                                title1 = strcat('Distribution of Tyrosine: ', num2str(i));
                            end
                            
                            xlabel(xlabel1,'FontName','Arial','FontSize',18);
                            ylabel(ylabel1,'FontName','Arial','FontSize',18);
                            title(title1,'FontName','Arial','FontSize',18);
                            
                        end
                        
                    end
                end
            end
            
        end
    end
    
    figure(300);
    for i = 1:iSiteTotal+1
        subplot(2,4,i);box on;
        plot([0 0],[0 2],'--k','LineWidth',lw);
        lg1 = plot(xaxisRebinnedNM,distributionDataControlRebinnedNM(i,:),'--r','LineWidth',lw+0.5);
        plotData = reshape(distributionDataRebinnedNM(k,w,d,ER2ind,z,i,:),[NBINS_rebin,1]);
        lg2 = plot(xaxisRebinnedNM,plotData,'--','LineWidth',lw+0.5,'Color',[0.6,0, 0]);
        if(i~=7)
            ylim([0 2]);
        else
            ylim([0 2]);
        end
        cbar = colorbar;
        caxis(log10([10^(-2),10^2]));
        cbar.Label.String = 'Log_{10}(E_{P0})';
        cbar.Label.FontSize = 18;
        xtext = -0.3;
        ytext = get(gca,'YLim');
        text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
        legend([lg1,lg2],'E_{B0} = 0','E_{P0} = 2');
    end
    set(gcf,'units','centimeters','position',[1,4,76,33]);
    
    %% Plot distribution for EP0 in nanometers, no labels - Tyr3
    %colors_fig = flipud(gray(124));
    colors_fig = flipud(bone(124));
    eind = 0;
    eColorInd = [];
    xaxisRebinnedNM = (-N+bins_rebin.*BinSize_rebin)*0.3;
    lw = 2.5;
    hFig = figure(301); clf; hold on; box on;
    for d = 1:length(PD)
        for k=1:length(WK)
            for w = 1:length(PW)
                for e = [38 39:2:length(ER)-14 length(ER)-13]
                        eind = e-36;
                        eColorInd = [eColorInd eind];
                %for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=3
                            plotData = reshape(distributionDataRebinnedNM(k,w,d,e,z,i,:),[NBINS_rebin,1]);
                            plot(xaxisRebinnedNM,plotData,'-','Color',colors_fig(2*eind,:),'LineWidth',lw);
                            xlim([-1,5]);
                        end
                    end
                end
            end
        end
    end
    
    figure(301);
    for i = 3
        plot([0 0],[0 2],'--k','LineWidth',lw);
        lg1 = plot(xaxisRebinnedNM,distributionDataControlRebinnedNM(i,:),'--b','LineWidth',lw+1);
        plotData = reshape(distributionDataRebinnedNM(k,w,d,ER2ind,z,i,:),[NBINS_rebin,1]);
        lg2 = plot(xaxisRebinnedNM,plotData,'--','LineWidth',lw+1,'Color',[1,0, 0]);
        ylim([0 2]);
    end
    xticklabels([]);
    yticklabels([]);
    set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
    set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);
    
    if(saveTF)
        savename = 'DistributionEP0Bone';
        print('-painters',fullfile(savefolder,savename),'-depsc');
        saveas(gcf,fullfile(savefolder,savename),'fig');
        %saveas(gcf,fullfile(savefolder,savename),'epsc');
    end
    
    
    %% Plot distribution for EP0 in nanometers, with labels - Tyr3
    eind=0;
    
    xaxisRebinnedNM = (-N+bins_rebin.*BinSize_rebin)*0.3;
    lw = 4;
    hFig = figure(302); clf; hold on; box on;
    for d = 1:length(PD)
        for k=1:length(WK)
            for w = 1:length(PW)
                %for e = [1:10:20 21:2:40 41:1:60 61:2:80 81:4:100 101];
                % aesthetically pleasing, but nonlinear
                    %for e = [38:2:50 51:1:70 71:2:length(ER)-12]
                    for e = [38 39:2:length(ER)-14 length(ER)-13]
                    %for e=37:2:length(ER)-12
                        eind = e-36;
                %for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=3
                            plotData = reshape(distributionDataRebinnedNM(k,w,d,e,z,i,:),[NBINS_rebin,1]);
                            plot(xaxisRebinnedNM,plotData,'-','Color',colors_fig(2*eind,:),'LineWidth',lw);
                            xlim([-1,5]);
                            
                            xlabel1 = 'z-coordinate (nm)';
                            ylabel1 = 'Probability Density';
                            title1 = strcat('Distribution of Tyrosine: ', num2str(i));
                            
                            xlabel(xlabel1,'FontName','Arial','FontSize',18);
                            ylabel(ylabel1,'FontName','Arial','FontSize',18);
                            title(title1,'FontName','Arial','FontSize',18);
                            
                        end
                        
                    end
                end
            end
            
        end
    end
    
    figure(302);
    for i = 3
        plot([0 0],[0 2],'--k','LineWidth',lw);
        lg1 = plot(xaxisRebinnedNM,distributionDataControlRebinnedNM(i,:),'--b','LineWidth',lw+1);
        plotData = reshape(distributionDataRebinnedNM(k,w,d,ER2ind,z,i,:),[NBINS_rebin,1]);
        lg2 = plot(xaxisRebinnedNM,plotData,'--','LineWidth',lw+1,'Color',[1,0, 0]);
        ylim([0 2]);
        colormap bone;
        %cbar = colorbar('YDir','reverse');
        colortickind = [2*eColorInd(end) 2*eColorInd(1)];
        clims = [colors_fig(colortickind(1)) colors_fig(colortickind(2))];
        cbar = colorbar('Ticks',[colors_fig(colortickind(1)) colors_fig(colortickind(2))],'TickLabels',{'10^{1.5}','10^{-0.5}'},'ylim',clims);
        
        
        %set(cbar,'ylim',clims);
        %caxis(log10([10^(-0.5),10^1.5]));
        cbar.Label.String = 'Log_{10}(E_{P0})';
        cbar.Label.FontSize = 18;
        xtext = -0.3;
        ytext = get(gca,'YLim');
        text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
        legend([lg1,lg2],'E_{B0} = 0','E_{P0} = 2');
    end
    set(gcf,'units','centimeters','position',[1,4,46,33]);
    
    if(saveTF)
        savename = 'DistributionEP0LabelsBone';
        saveas(gcf,fullfile(savefolder,savename),'fig');
        print('-painters',fullfile(savefolder,savename),'-depsc');
    end
    
end

        

  