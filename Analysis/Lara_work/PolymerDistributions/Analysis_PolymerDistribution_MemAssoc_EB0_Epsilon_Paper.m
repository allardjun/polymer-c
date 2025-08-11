%% Look at polymer location distributions for Electrostatics

clear all;
close all;

%% Initialize parameters

model = 1; % 1 - EB0 sweep, 2 - EP0 Sweep, 3 - CD3E EB0 Sweep

NTCHECK = 200000;
NBINS = 3000; % how many bins are there currently
KBT = 4.14;
bSiteTotal = 0; % how many bound ligands are there - for reading files properly
saveTF = 0; % save figures
rebin = 1; % rebin distributions to smooth

server = 0;

if(server)
    folder = '/Volumes/laraclemens/Documents/pub/lclemens/polymer-c_runs';
    controlFolder = '/Volumes/laraclemens/Documents/polymer-c_runs';
else
    switch(model)
        case 1
            folder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/CD3Zeta/MembraneOn/0.Distributions/';
            controlFolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/CD3Zeta/MembraneOn/0.Distributions/';
        case 3
            folder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/CD3Epsilon/MembraneOn/TwoSites/0.Distributions/';
            controlFolder = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/CD3Epsilon/MembraneOn/TwoSites/0.Distributions/';
    end
end

switch (model)
    
    case 1
        %subfolder = '20180306CD3ZetaElectrostaticsEB0Sweep';
        subfolder = 'CatFiles/EB0';
        savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/2.MembraneAssociation/CD3Zeta/MembraneOn/Plots/Distributions/';
        
        filenamePrefix = 'CD3ZetaMembraneAssociation';
        
        PD = logspace(-6,2,201);  % parabola depth
        PW = 1;  % parabola width
        WK = 0.05;  % wall parabola k
        ER = 0;  % repulsive energy multiplier
        ZR = 3;  % repulsive energy exponent multiplier
        
        sweepVariable = PD;
        colors = parula(404);
        colors_gray = flipud(gray(404));
        
        iSiteLocations = [20, 31, 59, 71, 90, 101]+1;
        iSiteEndIndices = zeros(6,2);
        combinations=64;
        NFil = 1;
        N=113;
        
        iSiteTotal = 6;
        BinSize = 2*N/NBINS; % what is the current binsize
        
%         controlSubfolder = '20180409MembraneAssociationCD3ZetaMembraneOnEB0Zero';
%         controlFilename = 'CD3ZetaElectrostaticsDistributionControl';

        plotiSite = 3;
        
        
    case 3
        %subfolder = '20180306CD3ZetaElectrostaticsEB0Sweep';
        %subfolder = '20190411MembraneAssociationCD3EpsilonMembraneOnEB0Sweep';
        subfolder = 'CatFiles/EB0';
        savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/2.MembraneAssociation/CD3Epsilon/MembraneOn/Plots/Distributions/';
        
        filenamePrefix = 'CD3EpsilonMembraneAssociation';
        
        PD = logspace(-6,2,201);  % parabola depth
        PW = 1;  % parabola width
        WK = 0.05;  % wall parabola k
        ER = 0;  % repulsive energy multiplier
        ZR = 3;  % repulsive energy exponent multiplier
        
        sweepVariable = PD;
        colors = parula(404);
        colors_gray = flipud(gray(404));
        
        iSiteLocations = [35,46]+1;
        iSiteEndIndices = zeros(2,2);
        combinations=4;
        NFil = 1;
        N=55;
        iSiteTotal = 2;
        BinSize = 2*N/NBINS; % what is the current binsize
        
        %controlSubfolder = '20181126MembraneAssociationCD3EpsilonMembraneOnEB0Zero';
        %controlFilename = 'CD3EpsilonElectrostaticsDistributionControl';
        plotiSite = 1;
end




%%

%% Read Files

fileDoesNotExist=0;
distributionData = zeros(length(WK),length(PD),length(PW),length(ER),length(ZR),iSiteTotal+1,NBINS);

for k = 1:length(WK)
    for w = 1:length(PW)
        for d = 1:length(PD)
            for e = 1:length(ER)
                for z = 1:length(ZR)
                    
                    %% Open file and retrieve distribution data

                    %filename = strcat(filenamePrefix,'.','PD','.',num2str(d),'PW','.',num2str(w),'WK','.',num2str(k),'ER','.',num2str(e),'ZR','.',num2str(z));
                    filename = strcat(filenamePrefix,'.EB0.',num2str(d));

                    if(exist(fullfile(folder,subfolder,filename))~=0)
                        
                        M = dlmread(fullfile(folder,subfolder,filename));
                        
                        ntTotal = M(1,1);
                        
                        % Collect variance data for polymer tip
                        ree2(k,w,d,e,z) = M(1,12+2*(iSiteTotal+1));
                        rM(k,w,d,e,z) = M(1,13+2*(iSiteTotal+1));
                        rM2(k,w,d,e,z) = M(1,14+2*(iSiteTotal+1));
                        rMNM(k,w,d,e,z) = rM(k,w,d,e,z).*0.3;
                        rM2NM(k,w,d,e,z) = rM2(k,w,d,e,z).*0.09;
                        
%                         for i = 1:iSiteTotal
%                             rMiSite(k,w,d,e,z,i) = M(1,20+7*(i-1));
%                             rMiSiteNM(k,w,d,e,z,i) = rMiSite(k,w,d,e,z,i).*0.3;
%                             
%                             %
%                             rM2iSite(k,w,d,e,z,i) = M(1,21+7*(i-1));
%                             rM2iSiteNM(k,w,d,e,z,i) = rM2iSite(k,w,d,e,z,i).*0.09;
%                         end
                        
                        % rewrite above in vector notation
                        rMiSite(k,w,d,e,z,(1:1:iSiteTotal)) = M(1,20+2*(iSiteTotal+1)+7*((1:1:iSiteTotal)-1));
                        rMiSiteNM(k,w,d,e,z,:) = rMiSite(k,w,d,e,z,:).*0.3;

                        %
                        rM2iSite(k,w,d,e,z,(1:1:iSiteTotal)) = M(1,21+2*(iSiteTotal+1)+7*((1:1:iSiteTotal)-1));
                        rM2iSiteNM(k,w,d,e,z,:) = rM2iSite(k,w,d,e,z,:).*0.09;
                        
                        
                        for i=1:1:iSiteTotal+1
                            start = 8+2*(iSiteTotal+1)+6+7*(iSiteTotal)+2+(NFil) + (NFil) + NBINS*(i-1) + 1;
                            
                            %distributionData(k,w,d,e,z,i,:) = M(1,start:start+NBINS-1)./(ntTotal-NTCHECK);
                            frequencyData(k,w,d,e,z,i,:) = M(1,start:start+NBINS-1);
                            distributionData(k,w,d,e,z,i,:) = frequencyData(k,w,d,e,z,i,:)./(sum(frequencyData(k,w,d,e,z,i,:).*BinSize));
                            distributionDataNM(k,w,d,e,z,i,:) = frequencyData(k,w,d,e,z,i,:)./(sum(frequencyData(k,w,d,e,z,i,:).*(BinSize*0.3)));
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

%% Open file and retrieve distribution data for control
filename = strcat(filenamePrefix,'.EB0.',num2str(0));
M = dlmread(fullfile(folder,subfolder,filename));

ntTotal = M(1,1);
ree2Control = M(1,12+2*(iSiteTotal+1));

rMControl = M(1,13+2*(iSiteTotal+1));
rMControlNM = rMControl.*0.3;

rM2Control = M(1,14+2*(iSiteTotal+1));
rM2ControlNM = rM2Control.*0.09;

rMiSiteControl(:) = M(1,20+2*(iSiteTotal+1)+7*((1:1:iSiteTotal)-1));
rMiSiteControlNM(:) = rMiSiteControl(:)*0.3;

rM2iSiteControl(:) = M(1,21+2*(iSiteTotal+1)+7*((1:1:iSiteTotal)-1));
rM2iSiteControlNM(:) = rM2iSiteControl(:)*0.09;

for i=1:1:iSiteTotal+1
    start = 8+2*(iSiteTotal+1)+6+7*(iSiteTotal)+2+(NFil) + (NFil) + NBINS*(i-1) + 1;
    %distributionDataControl(i,:) = M(1,start:start+NBINS-1)./(ntTotal-NTCHECK);
    frequencyDataControl(i,:) = M(1,start:start+NBINS-1);
    distributionDataControl(i,:) = frequencyDataControl(i,:)./(sum(frequencyDataControl(i,:).*BinSize));
    distributionDataControlNM(i,:) = frequencyDataControl(i,:)./(sum(frequencyDataControl(i,:).*(BinSize*0.3)));
end

%% Plot histograms
lw = 2;
bins = 0:1:NBINS-1;
xaxis = -N+bins.*BinSize;
xaxisNM = (-N+bins.*BinSize)*0.3;
for i=1:length(iSiteLocations)
    iSiteEndIndices(i,1) = find( xaxis < -iSiteLocations(i),1,'last');
    iSiteEndIndices(i,2) = find( xaxis < iSiteLocations(i),1,'last');
end
figureNumber = 1;


if(0)
    hFig = figure(1); clf; hold on; box on;
    for i=1:iSiteTotal+1
        for k=1
            for w=1
                for d=1:length(PD)
                    for e=1:length(ER)
                        for z=1:length(ZR)
                            plotData = reshape(distributionData(k,w,d,e,z,i,:),[NBINS,1]);
                            hSub = subplot(2,4,i); hold on; box on;
                            plot(xaxis,plotData,'-','Color',colors(2*d,:),'LineWidth',lw);
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
        lg = plot(xaxis,distributionDataControl(i,:),'--r','LineWidth',lw+0.5);
        if(i~=7)
            ylim([0 1]);
        else
            ylim([0 2]);
        end
        cbar = colorbar;
        caxis(log10([10^(-6),10^2]));
        cbar.Label.String = 'Log_{10}(E_{B0})';
        cbar.Label.FontSize = 18;
        xtext = -1;
        ytext = get(gca,'YLim');
        text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
        legend(lg,'E_{B0} = 0');
    end
    set(gcf,'units','centimeters','position',[1,4,76,33]);
end

%% Plot distributions in nanometers
if(0)
    hFig = figure(100); clf; hold on; box on;
    for i=1:iSiteTotal+1
        for k=1
            for w=1
                for d=1:length(PD)
                    for e=1:length(ER)
                        for z=1:length(ZR)
                            plotData = reshape(distributionDataNM(k,w,d,e,z,i,:),[NBINS,1]);
                            hSub = subplot(2,4,i); hold on; box on;
                            plot(xaxisNM,plotData,'-','Color',colors(2*d,:),'LineWidth',lw);
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
        lg = plot(xaxisNM,distributionDataControlNM(i,:),'--r','LineWidth',lw+0.5);
        if(i~=7)
            ylim([0 2]);
        else
            ylim([0 7]);
        end
        cbar = colorbar;
        caxis(log10([10^(-6),10^2]));
        cbar.Label.String = 'Log_{10}(E_{B0})';
        cbar.Label.FontSize = 18;
        xtext = -0.3;
        ytext = get(gca,'YLim');
        text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
        legend(lg,'E_{B0} = 0');
    end
    set(gcf,'units','centimeters','position',[1,4,76,33]);
end

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
                            distributionDataRebinnedNM(k,w,d,e,z,i,:) = frequencyDataRebinned(k,w,d,e,z,i,:)./(sum(frequencyDataRebinned(k,w,d,e,z,i,:).*(BinSize_rebin*0.3)));
                        end
                    end
                end
            end
        end
    end
    
    
    for i=1:1:iSiteTotal+1
        frequencyDataControlRebinned(i,:) = sum(reshape(frequencyDataControl(i,:),[rebinSize,NBINS/rebinSize]),1);
        distributionDataControlRebinned(i,:) = frequencyDataControlRebinned(i,:)./(sum(frequencyDataControlRebinned(i,:).*BinSize_rebin));
        distributionDataControlRebinnedNM(i,:) = frequencyDataControlRebinned(i,:)./(sum(frequencyDataControlRebinned(i,:).*(BinSize_rebin*0.3)));
    end
    NBINS_rebin = NBINS/rebinSize;
    bins_rebin = 0:1:NBINS_rebin-1;
    xaxisRebinned = -N+bins_rebin.*BinSize_rebin;
    xaxisRebinnedNM = (-N+bins_rebin.*BinSize_rebin)*0.3;
    for i=1:length(iSiteLocations)
        iSiteEndIndices_rebinned(i,1) = find( xaxisRebinned < -iSiteLocations(i),1,'last');
        iSiteEndIndices_rebinned(i,2) = find( xaxisRebinned < iSiteLocations(i),1,'last');
    end
    
    %% Plot distributions
    if(0)
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
                                plot(xaxisRebinned,plotData,'-','Color',colors(2*d,:),'LineWidth',lw);
                                xlim([-3.3333,16.6666]);
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
        
        figure(3);
        for i = 1:iSiteTotal+1
            subplot(2,4,i);
            plot([0 0],[0 2],'--k','LineWidth',lw);
            lg = plot(xaxisRebinned,distributionDataControlRebinned(i,:),'--r','LineWidth',lw+0.5);
            if(i~=7)
                ylim([0 1]);
            else
                ylim([0 2]);
            end
            cbar = colorbar;
            caxis(log10([10^(-6),10^2]));
            cbar.Label.String = 'Log_{10}(E_{B0})';
            cbar.Label.FontSize = 18;
            xtext = -1;
            ytext = get(gca,'YLim');
            text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
            legend(lg,'E_{B0} = 0');
        end
        set(gcf,'units','centimeters','position',[1,4,76,33]);
    end
    
    %% Plot rebinned histograms in nanometers
    if(0)
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
                                plot(xaxisRebinnedNM,plotData,'-','Color',colors(2*d,:),'LineWidth',lw);
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
            subplot(2,4,i); box on;
            plot([0 0],[0 7],'--k','LineWidth',lw);
            lg = plot(xaxisRebinnedNM,distributionDataControlRebinnedNM(i,:),'--r','LineWidth',lw+0.5);
            if(i~=7)
                ylim([0 2]);
            else
                ylim([0 7]);
            end
            cbar = colorbar;
            caxis(log10([10^(-6),10^2]));
            cbar.Label.String = 'Log_{10}(E_{B0})';
            cbar.Label.FontSize = 18;
            xtext = -0.3;
            ytext = get(gca,'YLim');
            text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
            legend(lg,'E_{B0} = 0');
        end
        set(gcf,'units','centimeters','position',[1,4,76,33]);
    end
    
    %% Plot rebinned histograms in nanometers, no labels
    colors_fig = flipud(gray(230));
    lw = 2;
    dColorInd = [];
    hFig = figure(301); clf; hold on; box on;
    %for d = 1:5:length(PD)
    for d = 101:4:length(PD)
        dind = d-100;
        dColorInd = [dColorInd dind];
        for k=1:length(WK)
            for w = 1:length(PW)
                for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=plotiSite
                            plotData = reshape(distributionDataRebinnedNM(k,w,d,e,z,i,:),[NBINS_rebin,1]);
                            plot(xaxisRebinnedNM,plotData,'-','Color',colors_fig(2*dind,:),'LineWidth',lw);
                            xlim([-1,5]);
                        end
                    end
                end
            end
        end
    end
    
    figure(301);
    for i = plotiSite
        plot([0 0],[0 7],'--k','LineWidth',lw);
        lg = plot(xaxisRebinnedNM,distributionDataControlRebinnedNM(i,:),'--b','LineWidth',lw+1);
        ylim([0 2]);
        yticks([0 0.25 0.5 0.75 1 1.25 1.5 1.75 2]);
    end
    xticklabels([]);
    yticklabels([]);
    set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
    set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);
    if(saveTF)
        savefilename = 'DistributionEB0';
        saveas(gcf,fullfile(savefolder,savefilename),'fig');
        print('-painters',fullfile(savefolder,savefilename),'-depsc');
    end
    
    
    %% Plot rebinned histograms in nanometers, with labels
    lw = 3;
    hFig = figure(302); clf; hold on; box on;
    %for d = 1:length(PD)
        for d = 101:4:length(PD)
        dind = d-100;
        for k=1:length(WK)
            for w = 1:length(PW)
                for e = 1:length(ER)
                    for z = 1:length(ZR)
                        for i=plotiSite
                            plotData = reshape(distributionDataRebinnedNM(k,w,d,e,z,i,:),[NBINS_rebin,1]);
                            disp('d:');
                            disp(d);
                            disp('Std:');
                            disp(std(plotData(iSiteEndIndices_rebinned(i,1):iSiteEndIndices_rebinned(i,2))));
                            disp('Var:');
                            disp(var(plotData(iSiteEndIndices_rebinned(i,1):iSiteEndIndices_rebinned(i,2))));
                            plot(xaxisRebinnedNM,plotData,'-','Color',colors_fig(2*dind,:),'LineWidth',lw);
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
    for i = plotiSite
        plot([0 0],[0 7],'--k','LineWidth',lw);
        lg = plot(xaxisRebinnedNM,distributionDataControlRebinnedNM(i,:),'--b','LineWidth',lw+1);
        ylim([0 2]);
        yticks([0 0.25 0.5 0.75 1 1.25 1.5 1.75 2]);
        colormap gray;
        colortickind = [2*dColorInd(end) 2*dColorInd(1)];
        clims = [colors_fig(colortickind(1)) colors_fig(colortickind(2))];
        cbar = colorbar('Ticks',[colors_fig(colortickind(1)) colors_fig(colortickind(2))],'TickLabels',{'10^{2}','10^{-2}'},'ylim',clims);
        %caxis(log10([10^(-6),10^2]));
        cbar.Label.String = 'Log_{10}(E_{B0})';
        cbar.Label.FontSize = 18;
        xtext = -0.1;
        ytext = get(gca,'YLim');
        text(xtext,0.75*ytext(2),'membrane','FontSize',14,'Rotation',90);
        legend(lg,'E_{B0} = 0');
    end
    set(gcf,'units','centimeters','position',[1,4,46,33]);
    
    if(saveTF)
        savefilename = 'DistributionEB0Labels';
        saveas(gcf,fullfile(savefolder,savefilename),'fig');
        print('-painters',fullfile(savefolder,savefilename),'-depsc');
    end
    
end

%% Plot variance of distance-to-membrane - polymer tip
lw = 2;
figure(17); clf; hold on; box on;
plotData = reshape(rM2(k,w,:,e,z)-rM(k,w,:,e,z).^2,[length(PD),1]);
plot(PD,plotData,'-k','LineWidth',lw);
set(gca,'xscale','log');
title1 = 'Variance of Distance-to-Membrane';
set(gcf,'units','centimeters','position',[1,4,50,46]);
xlabel1 = 'E_{B0} (k_{B}T)';
ylabel1 = 'Distribution Variance';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);

%% Plot normalized variance of distance-to-membrane, no labels - polymer tip
figure(18); clf; hold on; box on;
plotData = reshape(rM2(k,w,:,e,z)-rM(k,w,:,e,z).^2,[length(PD),1]);
rMVar = plotData./(rM2Control-rMControl.^2);
plot(PD,rMVar,'-k','LineWidth',lw);
plot(PD,exp(-1).*ones(length(PD),1),'--r','LineWidth',lw);
%ylim([0 1.2]);
xlim([10^(-6),10^2]);
xticklabels([]);
yticklabels([]);
set(gca,'xscale','log');
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(saveTF)
    savefilename = 'NormalizedVarDistMemVSEB0';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

%% Plot normalized variance of distance-to-membrane, with labels - polymer tip
figure(19); clf; hold on; box on;
plotData = reshape(rM2(k,w,:,e,z)-rM(k,w,:,e,z).^2,[length(PD),1]);
rMVar = plotData./(rM2Control-rMControl.^2);
plot(PD,rMVar,'-k','LineWidth',lw);
plot(PD,exp(-1).*ones(length(PD),1),'--b','LineWidth',lw);
set(gca,'xscale','log');
title1 = 'Normalized Variance of Distance-to-Membrane';
set(gcf,'units','centimeters','position',[1,4,18,15]);
xlabel1 = 'E_{B0} (k_{B}T)';
ylabel1 = 'Normalized Distribution Variance';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);
legend('Variance','1/e');

if(saveTF)
    savefilename = 'NormalizedVarDistMemVSEB0Labels';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

% %% Plot normalized variance of distance-to-membrane, no labels - polymer tip, as inset to Fig 301
% figure(301); hold on; box on;
% axes('Position',[0.45 0.45 0.4 0.4]); hold on; box on;
% plotData = reshape(rM2(k,w,:,e,z)-rM(k,w,:,e,z).^2,[length(PD),1]);
% rMVar = plotData./(rM2Control-rMControl.^2);
% plot(PD,rMVar,'-k','LineWidth',lw);
% plot(PD,exp(-1).*ones(length(PD),1),'--b','LineWidth',lw);
% ylim([0 1.2]);
% xlim([10^(-6),10^2]);
% xticklabels([]);
% yticklabels([]);
% set(gca,'xscale','log');
% 
% if(saveTF)
%     savefilename = 'NormalizedVarDistMemVSEB0';
%     saveas(gcf,fullfile(savefolder,savefilename),'fig');
%     saveas(gcf,fullfile(savefolder,savefilename),'epsc');
% end

%% Calculate EB0 when Normalized <rM^2>-<rM>^2 is below 1/e (0.37)

EB0starind = find(rMVar < 0.37,1,'first');
EB0star = PD(EB0starind);
disp(EB0star);

%% Plot variance of distance-to-membrane - Tyr 3
lw = 2;
figure(27); clf; hold on; box on;
plotData = reshape(rM2iSiteNM(k,w,:,e,z,plotiSite)-rMiSiteNM(k,w,:,e,z,plotiSite).^2,[length(PD),1]);
disp('Var Calc:');
disp(plotData);
rMVarTyr3 = plotData;
plot(PD,plotData,'-k','LineWidth',lw);
plot(PD,(exp(-1).*(rMVarTyr3(1)-rMVarTyr3(end))+rMVarTyr3(end)).*ones(length(PD),1),'--b','LineWidth',lw);
set(gca,'xscale','log');
title1 = 'Variance of Distance-to-Membrane';
set(gcf,'units','centimeters','position',[1,4,18,15]);
xlabel1 = 'E_{B0} (k_{B}T)';
ylabel1 = 'Distribution Variance';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);

if(saveTF)
    savefilename = 'VarDistMemTyr3VSEB0Labels';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

%% Plot standard deviation of distance-to-membrane - Tyr 3
lw = 2;
figure(270); clf; hold on; box on;
plotData = reshape(rM2iSiteNM(k,w,:,e,z,plotiSite)-rMiSiteNM(k,w,:,e,z,plotiSite).^2,[length(PD),1]);
disp('Std Calc:');
disp(sqrt(plotData));
rMVarTyr3 = sqrt(plotData);
plot(PD,sqrt(plotData),'-k','LineWidth',lw);
plot(PD,(exp(-1).*(rMVarTyr3(1)-rMVarTyr3(end))+rMVarTyr3(end)).*ones(length(PD),1),'--b','LineWidth',lw);
set(gca,'xscale','log');
title1 = 'Standard Deviation of Distance-to-Membrane';
set(gcf,'units','centimeters','position',[1,4,18,15]);
xlabel1 = 'E_{B0} (k_{B}T)';
ylabel1 = 'Distribution Variance';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);


%% Plot normalized variance of distance-to-membrane, no labels - Tyr 3
figure(28); clf; hold on; box on;
plotData = reshape(rM2iSiteNM(k,w,:,e,z,plotiSite)-rMiSiteNM(k,w,:,e,z,plotiSite).^2,[length(PD),1]);
rMVarTyr3 = plotData./(rM2iSiteControlNM(plotiSite)-rMiSiteControlNM(plotiSite).^2);
plot(PD,rMVarTyr3,'-k','LineWidth',lw);
plot(PD,(exp(-1).*(1-rMVarTyr3(end))+rMVarTyr3(end)).*ones(length(PD),1),'--r','LineWidth',lw);
ylim([0 1.2]);
xlim([10^(-6),10^2]);
%xticks([10^(-6) 10^(-4) 10^(-2) 10^0 10^2]);
xticklabels([]);
yticklabels([]);
set(gca,'xscale','log');
set(gcf,'units','inches','position',[[1,1],3.5,3.5]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,2.5]);

if(saveTF)
    savefilename = 'NormalizedVarDistMemTyr3VSEB0';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

%% Plot normalized variance of distance-to-membrane, with labels - Tyr 3
figure(29); clf; hold on; box on;
plotData = reshape(rM2iSite(k,w,:,e,z,plotiSite)-rMiSite(k,w,:,e,z,plotiSite).^2,[length(PD),1]);
rMVarTyr3 = plotData./(rM2iSiteControl(plotiSite)-rMiSiteControl(plotiSite).^2);
plot(PD,rMVarTyr3,'-k','LineWidth',lw);
plot(PD,(exp(-1).*(1-rMVarTyr3(end))+rMVarTyr3(end)).*ones(length(PD),1),'--b','LineWidth',lw);
set(gca,'xscale','log');
ylim([0 1.2]);
xlim([10^(-6),10^2]);
%xticks([10^(-6) 10^(-4) 10^(-2) 10^0 10^2]);
title1 = 'Normalized Variance of Distance-to-Membrane';
set(gcf,'units','centimeters','position',[1,4,18,15]);
xlabel1 = 'E_{B0} (k_{B}T)';
ylabel1 = 'Normalized Distribution Variance';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
title(title1,'FontName','Arial','FontSize',18);
legend('Variance','1/e');

if(saveTF)
    savefilename = 'NormalizedVarDistMemTyr3VSEB0Labels';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    saveas(gcf,fullfile(savefolder,savefilename),'epsc');
end

% %% Plot normalized variance of distance-to-membrane, no labels - Tyr 3 as inset in Fig 301 (Tyr 3 distributions)
% figure(301); hold on; box on;
% axes('Position',[0.45 0.45 0.4 0.4]); hold on;
% plotData = reshape(rM2iSite(k,w,:,e,z,3)-rMiSite(k,w,:,e,z,3).^2,[length(PD),1]);
% rMVarTyr3 = plotData./(rM2iSiteControl(3)-rMiSiteControl(3).^2);
% plot(PD,rMVarTyr3,'-k','LineWidth',lw);
% plot(PD,(exp(-1).*(1-rMVarTyr3(end))+rMVarTyr3(end)).*ones(length(PD),1),'--b','LineWidth',lw);
% ylim([0 1.2]);
% xlim([10^(-6),10^2]);
% xticks([10^(-6) 10^(-4) 10^(-2) 10^0 10^2]);
% xticklabels([]);
% yticklabels([]);
% set(gca,'xscale','log');
% 
% if(saveTF)
%     savefilename = 'DistributionEB0Inset';
%     saveas(gcf,fullfile(savefolder,savefilename),'fig');
%     print('-painters',fullfile(savefolder,savefilename),'-depsc');
% end

%% Plot variance of distance-to-membrane, no labels - Tyr 3 as inset in Fig 301 (Tyr 3 distributions)
figure(301); hold on; box on;
axes('Position',[0.45 0.45 0.4 0.4]); hold on;
plotData = reshape(rM2iSiteNM(k,w,:,e,z,plotiSite)-rMiSiteNM(k,w,:,e,z,plotiSite).^2,[length(PD),1]);
rMVarTyr3 = plotData;
plot(PD,rMVarTyr3,'-k','LineWidth',lw);
plot(PD,(exp(-1).*(rMVarTyr3(1)-rMVarTyr3(end))+rMVarTyr3(end)).*ones(length(PD),1),'--b','LineWidth',lw);
switch(model)
    case 1
        ylim([0 0.9]);
        xlim([10^(-6),10^2]);
    case 3
        ylim([0 0.6]);
        xlim([10^(-6),10^2]);
end
xticks([10^(-6) 10^(-4) 10^(-2) 10^0 10^2]);
xticklabels([]);
yticklabels([]);
set(gca,'xscale','log');

if(saveTF)
    savefilename = 'DistributionEB0Inset';
    saveas(gcf,fullfile(savefolder,savefilename),'fig');
    print('-painters',fullfile(savefolder,savefilename),'-depsc');
end

%% Calculate EB0 when (not normalized) <rM^2>-<rM>^2 is below 1/e (0.37) of range

EB0starindTyr3 = find(rMVarTyr3 < (exp(-1).*(rMVarTyr3(1)-rMVarTyr3(end))+rMVarTyr3(end)),1,'first');
EB0starTyr3 = PD(EB0starindTyr3);
disp(EB0starTyr3);

%% Calculate EB0 when Normalized is 

rMVariSite = zeros(6,201);
rMVariSiteNorm = zeros(6,201);

for i = 1:iSiteTotal
    rMVariSite(i,:) = rM2iSite(k,w,:,e,z,i)-rMiSite(k,w,:,e,z,i).^2;
    rMVariSiteNorm(i,:) = rMVariSite(i,:)./(rM2iSiteControl(i)-rMiSiteControl(i).^2);
    EB0starindiSite(i) = find(rMVariSiteNorm(i,:) < (exp(-1).*(1-rMVariSiteNorm(i,end))+rMVariSiteNorm(i,end)),1,'first');
    EB0stariSite(i) = PD(EB0starindiSite(i));
end

disp(EB0stariSite);

