%% Base Config for Fake TCR

saveTF = 1;

NFil = [1 2 3 5 9 10];
baseSepDistance = [5,17]; % Kuhn lengths*nm

savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/3.SimultaneousBinding/TCR/MembraneOn/FilVSTime';

%% Figure parameters
ms = 7; % marker size
xm = 6; % x limit in nm
ym = 6; % y limit in nm
lw = 2; % line width
fs = 18; % font size

%% Plot bases configurations
for bSD = 1:length(baseSepDistance)
    
    baseSepDist = baseSepDistance(bSD);
    savesubfolder = ['SepDist',num2str(baseSepDist),'/ITAM_End/Plots/Visuals'];

    for nf = 1:length(NFil)
       
        % figure
        figure(nf); clf; hold on; box on; axis equal;
        plot(0.3*baseSepDist*cos((0:(NFil(nf)-1)).*2*pi./NFil(nf)),0.3*baseSepDist*sin((0:(NFil(nf)-1)).*2*pi./NFil(nf)),'xk','LineWidth',lw,'MarkerSize',ms);
        
        % axis limits, axes ticks
        xlim([-xm xm]);
        ylim([-ym ym]);
        xticks([-xm -xm/2 0 xm/2 xm]);
        yticks([-ym -ym/2 0 ym/2 ym]);
        
        % set size
        set(gcf,'units','centimeters','Position',[5 5 3 3]);
        
        % save figure
        if(saveTF)
            saveas(gcf,fullfile(savefolder,savesubfolder,['TCRBaseConfig_Fake_SepDist',num2str(baseSepDist),'_NFil',num2str(nf),'.fig']),'fig');
            saveas(gcf,fullfile(savefolder,savesubfolder,['TCRBaseConfig_Fake_SepDist',num2str(baseSepDist),'_NFil',num2str(nf),'.eps']),'epsc');
        end

    end

end


