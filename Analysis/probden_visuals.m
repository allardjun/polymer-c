
saveTF=1;
savefigfolder=savefigfolder;

n1=10;
fh1length=50;
FH2sizes=[0:36];

makeFH1sweeps=0; % these do not change with fh1length or n1
%% FH2 location, radius sweeps

set(groot,'defaultfigureposition',[400 250 1500 500]) % helps prevent cut offs in figs
fig=figure;

tl= tiledlayout(1,3);

ax_double=nexttile(1);
hold on
ax_dimer=nexttile(2);
hold on
ax_ratio=nexttile(3);
hold on


coloroptions=cool(length(FH2sizes));

for i=1:length(FH2sizes)
    FH2size=FH2sizes(i);

    f_dimer=@(x) (pr(n1,fh1length,FH2size,1,x,0,"dimer"));
    f_double=@(x) pr(n1,fh1length,FH2size,1,x,0,"double");
    
    f_ratio=@(x) log2(pr(n1,fh1length,FH2size,1,x,0,"ratio"));
    
    fplot(ax_dimer,f_dimer,[0 40],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    fplot(ax_double,f_double,[0 40],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    fplot(ax_ratio,f_ratio,[0 40],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
end

title(tl,strcat("PRM loc: ",num2str(n1),", FH1 length: ", num2str(fh1length)))
leg=legend("Location","northeastoutside");
title(leg,"FH2 size")
ylabel(ax_double,"Probability Density double (uM)")
ylabel(ax_dimer,"Probability Density dimer (uM)")
ylabel(ax_ratio,"log_2 Probability Density Ratio (dimer/double)")
xlabel(tl,"Distance from FH2 attachment point")
xlab="Distance from FH2 attachment point";
xlabel(ax_double,xlab)
xlabel(ax_dimer,xlab)
xlabel(ax_ratio,xlab)


if(saveTF)
    fname=strcat('Probdensity_visuals_rsweep_',num2str(n1),"_",num2str(fh1length));
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
end

%% FH2 location, at attachment point, PRM location sweeps

set(groot,'defaultfigureposition',[400 250 1500 800]) % helps prevent cut offs in figs
fig=figure;

tl= tiledlayout(2,3);

ax_double=nexttile(1);
hold on
ax_dimer=nexttile(2);
hold on
ax_ratio=nexttile(3);
hold on
ax_dimer_2=nexttile(4);
hold on
ax_dimer_3=nexttile(5);
hold on

FH2sizes=[0:36];

coloroptions=cool(length(FH2sizes));

for i=1:length(FH2sizes)
    FH2size=FH2sizes(i);

    f_dimer=@(x) (pr(x,fh1length,FH2size,1,0,0,"dimer"));
    f_dimer_log=@(x) log10(pr(x,fh1length,FH2size,1,0,0,"dimer"));
    f_double=@(x) pr(x,fh1length,FH2size,1,0,0,"double");
    
    f_ratio=@(x) log2(pr(x,fh1length,FH2size,1,0,0,"ratio"));
    
    fplot(ax_dimer,f_dimer,[1 fh1length],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    fplot(ax_dimer_3,f_dimer_log,[1 fh1length],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    fplot(ax_double,f_double,[1 fh1length],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    fplot(ax_ratio,f_ratio,[1 fh1length],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    if FH2size>15
        fplot(ax_dimer_2,f_dimer,[1 fh1length],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
    end
end

title(tl,{"Probability density of PRM at the FH2 attachment point" ,strcat("FH1 length: ", num2str(fh1length))})
leg=legend(ax_ratio,"Location","northeastoutside");
title(leg,"FH2 size")
ylabel(ax_double,"Probability Density double (uM)")
ylabel(ax_dimer,"Probability Density dimer (uM)")
ylabel(ax_dimer_2,"Probability Density dimer (uM)")
ylabel(ax_ratio,"log_2 Probability Density Ratio (dimer/double)")
ylabel(ax_dimer_3,"log_{10} Probability Density dimer (uM)")
xlab="PRM location";
xlabel(ax_double,xlab)
xlabel(ax_dimer,xlab)
xlabel(ax_dimer_2,xlab)
xlabel(ax_ratio,xlab)
xlabel(ax_dimer_3,xlab)

if(saveTF)
    fname=strcat('Probdensity_visuals_PRMlocsweep_',num2str(fh1length));
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
end


if makeFH1sweeps
    %% FH2 location, at attachment point, PRM at NT, FH1 length sweeps
    
    set(groot,'defaultfigureposition',[400 250 1500 800]) % helps prevent cut offs in figs
    fig=figure;
    
    tl= tiledlayout(2,3);
    
    ax_double=nexttile(1);
    hold on
    ax_dimer=nexttile(2);
    hold on
    ax_ratio=nexttile(3);
    hold on
    ax_dimer_2=nexttile(4);
    hold on
    ax_dimer_3=nexttile(5);
    hold on
    
    FH2sizes=[0:36];
    
    coloroptions=cool(length(FH2sizes));
    
    for i=1:length(FH2sizes)
        FH2size=FH2sizes(i);
    
        f_dimer=@(x) (pr(x,x,FH2size,1,0,0,"dimer"));
        f_dimer_log=@(x) log10(pr(x,x,FH2size,1,0,0,"dimer"));
        f_double=@(x) pr(x,x,FH2size,1,0,0,"double");
        
        f_ratio=@(x) log2(pr(x,x,FH2size,1,0,0,"ratio"));
        
        fplot(ax_dimer,f_dimer,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        fplot(ax_dimer_3,f_dimer_log,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        fplot(ax_double,f_double,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        fplot(ax_ratio,f_ratio,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        if FH2size>15
            fplot(ax_dimer_2,f_dimer,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        end
    end
    
    title(tl,{"Probability density of PRM at the FH2 attachment point" ,"PRM at NT"})
    leg=legend(ax_ratio,"Location","northeastoutside");
    title(leg,"FH2 size")
    ylabel(ax_double,"Probability Density double (uM)")
    ylabel(ax_dimer,"Probability Density dimer (uM)")
    ylabel(ax_dimer_2,"Probability Density dimer (uM)")
    ylabel(ax_ratio,"log_2 Probability Density Ratio (dimer/double)")
    ylabel(ax_dimer_3,"log_{10} Probability Density dimer (uM)")
    xlab="FH1 length";
    xlabel(ax_double,xlab)
    xlabel(ax_dimer,xlab)
    xlabel(ax_dimer_2,xlab)
    xlabel(ax_ratio,xlab)
    xlabel(ax_dimer_3,xlab)
    
    if(saveTF)
        fname=strcat('Probdensity_visuals_FH1sweep_NT');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
    end
    
    %% FH2 location, at attachment point, PRM at 1/FH1 length, FH1 length sweeps
    
    set(groot,'defaultfigureposition',[400 250 1500 800]) % helps prevent cut offs in figs
    fig=figure;
    
    tl= tiledlayout(2,3);
    
    ax_double=nexttile(1);
    hold on
    ax_dimer=nexttile(2);
    hold on
    ax_ratio=nexttile(3);
    hold on
    ax_dimer_2=nexttile(4);
    hold on
    ax_dimer_3=nexttile(5);
    hold on
    
    FH2sizes=[0:36];
    
    coloroptions=cool(length(FH2sizes));
    
    for i=1:length(FH2sizes)
        FH2size=FH2sizes(i);
    
        f_dimer=@(x) (pr(ceil(x/2),x,FH2size,1,0,0,"dimer"));
        f_dimer_log=@(x) log10(pr(ceil(x/2),x,FH2size,1,0,0,"dimer"));
        f_double=@(x) pr(ceil(x/2),x,FH2size,1,0,0,"double");
        
        f_ratio=@(x) log2(pr(ceil(x/2),x,FH2size,1,0,0,"ratio"));
        
        fplot(ax_dimer,f_dimer,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        fplot(ax_dimer_3,f_dimer_log,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        fplot(ax_double,f_double,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        fplot(ax_ratio,f_ratio,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        if FH2size>15
            fplot(ax_dimer_2,f_dimer,[1 400],"DisplayName",num2str(FH2size),"Color",coloroptions(i,:));
        end
    end


    title(tl,{"Probability density of PRM at the FH2 attachment point" ,"PRM at 0.5FH1 length"})
    leg=legend(ax_ratio,"Location","northeastoutside");
    title(leg,"FH2 size")
    ylabel(ax_double,"Probability Density double (uM)")
    ylabel(ax_dimer,"Probability Density dimer (uM)")
    ylabel(ax_dimer_2,"Probability Density dimer (uM)")
    ylabel(ax_ratio,"log_2 Probability Density Ratio (dimer/double)")
    ylabel(ax_dimer_3,"log_{10} Probability Density dimer (uM)")
    xlab="FH1 length";
    xlabel(ax_double,xlab)
    xlabel(ax_dimer,xlab)
    xlabel(ax_dimer_2,xlab)
    xlabel(ax_ratio,xlab)
    xlabel(ax_dimer_3,xlab)
    
    if(saveTF)
        fname=strcat('Probdensity_visuals_FH1sweep_halfway');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
    end
end

function pval=pr(n1,fh1length,FH2size,k,x,y,type)
    nN=n1+2*(fh1length-n1);
    nprime=((1/n1)+(1/nN))^-1;
    b=FH2size;
    x2=b;
    y2=0;
    dotprod=(x*x2)+(y*y2);
    pval_dimer= (...
        (3/(2*pi*nprime*(k^2)))^(3/2) * ...
        exp( (3*(b^2)) / (2*(k^2)*(n1+nN)) )*...
        exp( (-3/(2*(k^2))) * ( ((x^2+y^2)/n1) + ((x^2+y^2+b^2-2*dotprod)/nN) ) )...
    );
    pval_double=( ( 3/(2*pi*n1*(k^2)) )^(3/2)) * exp( -3*(x^2+y^2)/(2*n1*(k^2)) ) ;

    pval_dimer=pval_dimer*6.1503*10^7;
    pval_double=pval_double*6.1503*10^7;

    if type=="dimer"
        pval=pval_dimer;
    elseif type=="double"
        pval=pval_double;
    elseif type=="ratio"
        pval=pval_dimer/pval_double;
    end
end