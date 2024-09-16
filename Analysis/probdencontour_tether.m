function [fig,C,h]=probdencontour_tether(n1,fh1length,FH2size,saveTF,savefigfolder)
arguments
    n1 double
    fh1length double
    FH2size double
    saveTF=0
    savefigfolder="" 
end

    fig=figure;


    f=@(n1,fh1length,FH2size,k,x,y) pr(n1,fh1length,FH2size,k,x,y);

    %val=@(x,y) f(n1,fh1length,FH2size*0.3,0.3,x*0.3,y*0.3)*1.66*10^6;
    val=@(x,y) f(n1,fh1length,FH2size,1,x,y)*6.1503*10^7; % simply doing it in kuhn lengths

    f_double=@(n,k,x,y) (3/(2*pi*n*(k^2))^(3/2)*exp(-3*(x^2+y^2)/(2*n*(k^2))));
    %val=@(x,y) f(n1,0.3,x*0.3,y*0.3)*1.66*10^6;
    val_double=@(x,y) f_double(n1,1,x,y)*6.1503*10^7; % simply doing it in kuhn lengths

    val_ratio=@(x,y) log2(val(x,y)/val_double(x,y));

    set(groot,'defaultfigureposition',[400 250 1500 500]) % helps prevent cut offs in figs

    tiledlayout(1,3)
    if n1<FH2size+27
        nmax=n1-3;
    else
        nmax=FH2size+25;
    end
    minprob=ceil(log10(val(nmax,0)));
    if mod(minprob,2)
        minprob=minprob-1;
    end

    nexttile(1)
    hold on
    levels=arrayfun(@(k) val_double(k,0),linspace(50,0,200));
    levels=[levels,0.88];
    levels=sort(levels);
    
    fc=fcontour(val_double,[-5 FH2size+5 -ceil((FH2size+10)/2) ceil((FH2size+10)/2)],"LevelList",levels,"Fill","on","MeshDensity",300);
    colorbar

    levels=[10.^[minprob:2:-2],10^-1,10^1,10^2,10^3,10^4,10^5,10^6];
    %[C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",1);

    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",1,"ShowText",true,"LabelFormat","%.0e uM",'labelspacing', 500);
    %clabel(C,h, 'labelspacing', 700);

    levels=[10^-27,0.88];
    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",2.5,"ShowText",true,"LabelFormat","%.2f uM");

    plot(0, 0, '.', 'MarkerSize', 30,'Color','black')
    plot(FH2size, 0, '.', 'MarkerSize', 30,'Color','black')

    grid on
    title({'Probability Density of PRM'},{strcat("double; PRM loc: ",num2str(n1)," FH1 length: ",num2str(fh1length)," FH2 size: ",num2str(FH2size))})
    xlabel('x')
    ylabel('y')


    nexttile(2)
    hold on
    levels=arrayfun(@(k) val(k,0),linspace(FH2size+20,0));
    levels=[levels,0.88];
    levels=sort(levels);
    
    fc=fcontour(val,[-5 FH2size+5 -ceil((FH2size+10)/2) ceil((FH2size+10)/2)],"LevelList",levels,"Fill","on","MeshDensity",300);
    colorbar

    levels=[10.^[minprob:2:-2],10^-1,10^1,10^2,10^3,10^4,10^5,10^6];
    %[C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",1);

    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",1,"ShowText",true,"LabelFormat","%.0e uM",'labelspacing', 500);
    %clabel(C,h, 'labelspacing', 700);

    levels=[10^-27,0.88];
    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",2.5,"ShowText",true,"LabelFormat","%.2f uM");

    plot(0, 0, '.', 'MarkerSize', 30,'Color','black')
    plot(FH2size, 0, '.', 'MarkerSize', 30,'Color','black')

    grid on
    title({'Probability Density of PRM'},{strcat("dimer; PRM loc: ",num2str(n1)," FH1 length: ",num2str(fh1length)," FH2 size: ",num2str(FH2size))})
    xlabel('x')
    ylabel('y')


    ax1=nexttile(3);
    hold on
    
    
    fc=fcontour(val_ratio,[-5 FH2size+5 -ceil((FH2size+10)/2) ceil((FH2size+10)/2)],"Fill","on","MeshDensity",300);
    c=colorbar;
    c.Label.String = 'log_2(dimer/double)';
    
    colormap(ax1,flipud(sky))
    %clim([-10 10]);

    levels=[-100,0];
    [C,h]=contour(fc.XData,fc.YData,fc.ZData,levels,'black',"LineWidth",2.5,"ShowText",true);

    plot(0, 0, '.', 'MarkerSize', 30,'Color','black')
    plot(FH2size, 0, '.', 'MarkerSize', 30,'Color','black')

    grid on
    title({'Probability Density of PRM'},{strcat("ratio; PRM loc: ",num2str(n1)," FH1 length: ",num2str(fh1length)," FH2 size: ",num2str(FH2size))})
    xlabel('x')
    ylabel('y')

    if(saveTF)
        fname=strcat('Probdensity_contour_dimer_',num2str(n1),"_",num2str(fh1length),"_",num2str(FH2size));
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
    end

    function pval=pr(n1,fh1length,FH2size,k,x,y)
        nN=n1+2*(fh1length-n1);
        nprime=((1/n1)+(1/nN))^-1;
        b=FH2size;
        x2=b;
        y2=0;
        dotprod=(x*x2)+(y*y2);
        pval= (...
            (3/(2*pi*nprime*(k^2)))^(3/2) * ...
            exp( (3*(b^2)) / (2*(k^2)*(n1+nN)) )*...
            exp( (-3/(2*(k^2))) * ( ((x^2+y^2)/n1) + ((x^2+y^2+b^2-2*dotprod)/nN) ) )...
        );
    end
end