function [fig,C,h]=probdencontour(n1,saveTF,savefigfolder)
arguments
    n1 double
    saveTF=0
    savefigfolder="" 
end

    fig=figure;

    f=@(n,k,x,y) ( ( 3/(2*pi*n*(k^2)) )^(3/2)) * exp( -3*(x^2+y^2)/(2*n*(k^2)) ) ;
    %val=@(x,y) f(n1,0.3,x*0.3,y*0.3)*1.66*10^6;
    val=@(x,y) f(n1,1,x,y)*6.1503*10^7; % simply doing it in kuhn lengths

    set(groot,'defaultfigureposition',[400 250 900 750]) % helps prevent cut offs in figs

    if n1<55
        nmax=n1-3;
    else
        nmax=50;
    end
    minprob=ceil(log10(val(nmax,0)));
    if mod(minprob,2)
        minprob=minprob-1;
    end

    hold on
    levels=arrayfun(@(k) val(k,0),linspace(50,0,200));
    levels=[levels,0.88];
    levels=sort(levels);
    fc=fcontour(val,[-37 37],"LevelList",levels,"Fill","on","MeshDensity",300);
    colorbar

    levels=[10.^[minprob:2:-1],10^1,10^2,10^3,10^4,10^5,10^6];
    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",1,"ShowText",true,"LabelFormat","%.0e uM",'labelspacing', 500);
    %clabel(C,h, 'labelspacing', 700);

    levels=[10^27,0.88];
    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",2.5,"ShowText",true,"LabelFormat","%.2f uM");

    plot(0, 0, '.', 'MarkerSize', 30,'Color','black')
    plot(35.5, 0, '.', 'MarkerSize', 30,'Color','black')

    grid on
    title({'Probability Density of PRM'},{strcat("double; PRM loc: ",num2str(n1))})
    xlabel('x')
    ylabel('y')

    if(saveTF)
        fname=strcat('Probdensity_contour_double_',num2str(n1));
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
    end
end