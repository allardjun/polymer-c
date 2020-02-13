%% Base Config for Fake TCR

NFil = [1 2 3 5 9 10];
baseSepDist = 5;
colors = parula(7);
lw = 2;
for nf = 1:length(NFil)
    figure(nf); clf; hold on; axis equal;
    plot(baseSepDist*cos((0:(NFil(nf)-1)).*2*pi./NFil(nf)),baseSepDist*sin((0:(NFil(nf)-1)).*2*pi./NFil(nf)),'*','LineWidth',lw,'Color',colors(nf,:));
end
