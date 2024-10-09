%% Membrane Association potentials

saveTF = 1;

%% Create potential functions
syms z

% specify which values to use
WallK = 0.05;
EB0 = 0.5;
EP0 = EB0*4;

% create piecewise functions
Usoft  = piecewise(z >= 0, 0, z < 0, WallK.*z.^2);
Ubasic = piecewise(z >= 3, 0, z <= 3, (EB0/9).*z.^2-EB0);
Uphos  = EP0.*exp(-z./3);

% create numeric values for z
zpoints = linspace(-5,15,201);

%% Plot potentials
lw = 2;

% plot all potentials, no labels
figure(1); clf; hold on; box on;
plot(zpoints,subs(Ubasic,z,zpoints),'-b','LineWidth',lw);
plot(zpoints,subs(Uphos,z,zpoints),'-.r','LineWidth',lw);
plot(zpoints,subs(Usoft,z,zpoints),':','Color',[0.1 0.5 0.1],'LineWidth',lw);
plot([0 0],[-2,10],'--k','LineWidth',lw);
ylim([-0.5 3]);
yticks([-0.5 0 2]);
xlim([-3.3333/2,13.3333]);
xticks([-3.3333/2 0 3.3333 6.6666 10 13.333]);
xticklabels([]);
yticklabels([]);
set(gcf,'units','inches','position',[[1,1],3.5,2.75]);
set(gca,'units','inches','position',[[0.5,0.5],2.5,1.8]);
if(saveTF)
    saveas(gcf,'~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/6.Potentials-Densities-EB0-EP0/Potentials','fig');
    saveas(gcf,'~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/6.Potentials-Densities-EB0-EP0/Potentials','epsc');
end


% plot all potentials, with labels
figure(2); clf; hold on; box on;
plot(zpoints,subs(Ubasic,z,zpoints),'-b','LineWidth',lw);
plot(zpoints,subs(Uphos,z,zpoints),'-.r','LineWidth',lw);
plot(zpoints,subs(Usoft,z,zpoints),':','Color',[0.1 0.5 0.1],'LineWidth',lw);
plot([0 0],[-2,10],'--k','LineWidth',lw);
ylim([-0.5 3]);
yticks([-0.5 0 2]);
yticklabels({'E_{B0}','0','E_{P0}'});
xlim([-3.3333/2,13.3333]);
xticks([-3.3333/2 0 3.3333 6.6666 10 13.333]);
xticklabels([-0.5 0 1 2 3 4]);
xlabel1 = 'Distance from membrane (nm)';
ylabel1 = 'Energy (k_BT)';
xlabel(xlabel1,'FontName','Arial','FontSize',18);
ylabel(ylabel1,'FontName','Arial','FontSize',18);
legend('Basic Residues','Phosphorylated Tyrosines','Other Amino Acids');
if(saveTF)
    saveas(gcf,'~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/6.Potentials-Densities-EB0-EP0/PotentialsLabels','fig');
    saveas(gcf,'~/Documents/Papers/MultisiteDisorder/Figures/2.MembraneAssociation/6.Potentials-Densities-EB0-EP0/PotentialsLabels','epsc');
end



















