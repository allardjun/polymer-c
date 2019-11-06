%% Plot TCR base configurations


saveTF = 0;

baseSepDistance = [5,17]; % Kuhn lengths
NFIL = 6; % number of filaments in TCR
ms = 15; % marker size
xm=6; % x limit in nm
ym=6; % y limit in nm
colors_fil = [0.7 0 0; 0 0.5 0.8; 0 0.5 0; 0 0.8 0; 0.7 0 0.7; 1 0 0]
lw = 4; % line width
fs = 18; % font size
savefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures/3.SimultaneousBinding/TCR/MembraneOn';

for bSD = 1:length(baseSepDistance)
    for nf=1:1:NFIL
        rBase.x(bSD,nf)= sqrt(baseSepDistance(bSD).^2 + 2.5.^2) * cos( floor((nf-1)/2)*(2*pi/3) + (-1)^(nf)*atan( 2.5/baseSepDistance(bSD)) );
        rBase.y(bSD,nf)= sqrt(baseSepDistance(bSD).^2 + 2.5.^2) * sin( floor((nf-1)/2)*(2*pi/3) + (-1)^(nf)*atan( 2.5/baseSepDistance(bSD)) );
        rBase.z(bSD,nf)= 0;
    end
end

%% Define locations for TCR PDB Config
bSD = length(baseSepDistance)+1

% TCR configuration estimated from PDB: 6JXR
rBase.x(bSD,1) = 0;
rBase.y(bSD,1) = 0;
rBase.z(bSD,1) = 0;

rBase.x(bSD,2) = -cos( 0.753 )*4.1;
rBase.y(bSD,2) = sin( 0.753 )*4.1;
rBase.z(bSD,2) = 0;

rBase.x(bSD,3) = -9.7333;
rBase.y(bSD,3) = 0;
rBase.z(bSD,3) = 0;

rBase.x(bSD,4) = -cos( 0.5095 )*8.0667;
rBase.y(bSD,4) = sin( 0.5095 )*8.0667;
rBase.z(bSD,4) = 0;

rBase.x(bSD,5) = -cos( 0.97545 )*10.1667;
rBase.y(bSD,5) = sin( 0.97545 )*10.1667;
rBase.z(bSD,5) = 0;

rBase.x(bSD,6) = -cos( 1.069 )*11.3;
rBase.y(bSD,6) = sin( 1.069 )*11.3;
rBase.z(bSD,6) = 0;



%% Plot base configurations - SepDist5 - No Labels

figure(1); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(1,nf).*0.3,rBase.y(1,nf).*0.3,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gca,'xtick',[-6 -3 0 3 6],'XTickLabel',[]);
set(gca,'ytick',[-6 -3 0 3 6],'YTickLabel',[]);
set(gca,'units','inches','position',[[0.5,0.5],2,2]);

if(saveTF)
    figure(1);
    savesubfolder = 'SepDist5/Plots/Visuals';
    savename = 'TCRBaseConfig_BaseSepDist5';
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'epsc');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end

%% Plot base configurations - SepDist5 - Labels
figure(10); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(1,nf).*0.3,rBase.y(1,nf).*0.3,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gcf,'Position',[1 1 400 400]);
xlabel('x (nm)','FontName','Arial','FontSize',fs);
ylabel('y (nm)','FontName','Arial','FontSize',fs);
legend('CD3E','CD3D','CD3Z','CD3Z','CD3G','CD3E');

if(saveTF)
    figure(10);
    savesubfolder = 'SepDist5/Plots/Visuals';
    savename = 'TCRBaseConfig_BaseSepDist5Labels';
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'epsc');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end

%% Plot base configurations - SepDist17 - No Labels

figure(2); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(2,nf).*0.3,rBase.y(2,nf).*0.3,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gca,'xtick',[-6 -3 0 3 6],'XTickLabel',[]);
set(gca,'ytick',[-6 -3 0 3 6],'YTickLabel',[]);
set(gca,'units','inches','position',[[0.5,0.5],2,2]);

if(saveTF)
    figure(2);
    savesubfolder = 'SepDist17/Plots/Visuals';
    savename = 'TCRBaseConfig_BaseSepDist17';
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'epsc');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end

%% Plot base configurations - SepDist17 - Labels
figure(20); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(2,nf).*0.3,rBase.y(2,nf).*0.3,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gcf,'Position',[1 1 400 400]);
xlabel('x (nm)','FontName','Arial','FontSize',fs);
ylabel('y (nm)','FontName','Arial','FontSize',fs);
legend('CD3E','CD3D','CD3Z','CD3Z','CD3G','CD3E');

if(saveTF)
    figure(20);
    savesubfolder = 'SepDist17/Plots/Visuals';
    savename = 'TCRBaseConfig_BaseSepDist17Labels';
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'epsc');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end



%% Plot base configurations - TCR PDB Config - No Labels
xshift = +1.5; % shift this config to be similarly centered to above - does not affect results
yshift = -1.5;

figure(3); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(3,nf).*0.3 + xshift,rBase.y(3,nf).*0.3 + yshift,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gca,'xtick',[-6 -3 0 3 6],'XTickLabel',[]);
set(gca,'ytick',[-6 -3 0 3 6],'YTickLabel',[]);
set(gca,'units','inches','position',[[0.5,0.5],2,2]);

if(saveTF)
    figure(3);
    savesubfolder = 'TCRPDBConfig/Plots/Visuals';
    savename = 'TCRBaseConfig_BaseTCRPDBConfig';
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'epsc');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end


%% Plot base configurations - TCR PDB Config - Labels

figure(30); clf; hold on; box on;
for nf=1:1:NFIL
    plot(rBase.x(3,nf).*0.3 + xshift,rBase.y(3,nf).*0.3 + yshift,'x','MarkerSize',ms,'Color',colors_fil(nf,:),'LineWidth',lw);
end
xlim([-xm,xm]);
ylim([-ym,ym]);
set(gcf,'Position',[1 1 400 400]);
xlabel('x (nm)','FontName','Arial','FontSize',fs);
ylabel('y (nm)','FontName','Arial','FontSize',fs);
legend('CD3E','CD3D','CD3Z','CD3Z','CD3G','CD3E');

if(saveTF)
    figure(30);
    savesubfolder = 'TCRPDBConfig/Plots/Visuals';
    savename = 'TCRBaseConfig_BaseTCRPDBConfigLabels';
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'epsc');
    saveas(gcf,fullfile(savefolder,savesubfolder,savename),'fig');
end

%%
% %% Checking distances between dimers
% i1=3
% i2=6
% 
% sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)
% 
% i1 = 2
% i2 = 5
% sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)
% 
% 
% i1 = 1
% i2 = 4
% sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)
% 
% 
% i1 = 1
% i2 = 6
% sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)
% 
% i1 = 2
% i2 = 3
% sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)
% 
% i1 = 4
% i2 = 5
% sqrt((rBase.x(1,i1)-rBase.x(1,i2)).^2+(rBase.y(1,i1)-rBase.y(1,i2)).^2)