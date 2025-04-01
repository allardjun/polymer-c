function polymerstatheatmap(ltvar,lookuptab,FH2_dist,type1,calcTF,saveTF,savefigfolder,limits,maxNT,maxCT,minNT,minCT,xcord,ycord)
arguments
    ltvar
    lookuptab
    FH2_dist
    type1
    calcTF =false
    saveTF =false
    savefigfolder=""
    limits=0
    maxNT=400
    maxCT=400
    minNT=0
    minCT=1
    xcord=0
    ycord=0
end
set(groot,'defaultfigureposition',[400 250 900 750])
fig=figure;

if calcTF
    if ltvar=="POcclude"
        error("No equation for POcclude")
    elseif ltvar=="Prvec0"
        nCT=maxCT-minCT+1;
        nNT=maxNT-minNT+1;
        msize=nCT*nNT;
        FH2_dists=zeros(1, msize);
        NT_dists=zeros(1,msize);
        vals=zeros(1,msize);
        index=0;
        for FH2dist=minCT:maxCT
            for NT_dist=minNT:maxNT
                index=index+1;
                FH2_dists(1,index)=FH2dist;
                NT_dists(1,index)=NT_dist;
                vals(1,index)=pr(FH2dist,FH2dist+NT_dist,str2double(FH2_dist),1,xcord,ycord,type1,false);
            end
        end
        tab= table(log10(vals)',FH2_dists', NT_dists');
    end

else
    dimer_tab=lookuptab.stattable(ltvar,"dimer");
    dimer_tab.a=dimer_tab.a((dimer_tab.a(:,2)<=maxCT),:);
    dimer_tab.a=dimer_tab.a( ((dimer_tab.a(:,1)-dimer_tab.a(:,2)) <=maxNT),:);
    dimer_tab.a=dimer_tab.a((dimer_tab.a(:,2)>=minCT),:);
    dimer_tab.a=dimer_tab.a( ((dimer_tab.a(:,1)-dimer_tab.a(:,2)) >=minNT),:);
    double_tab=lookuptab.stattable(ltvar,"double");
    double_tab.a=double_tab.a((double_tab.a(:,2)<=maxCT),:);
    double_tab.a=double_tab.a( ((double_tab.a(:,1)-double_tab.a(:,2)) <=maxNT),:);
    double_tab.a=double_tab.a((double_tab.a(:,2)>=minCT),:);
    double_tab.a=double_tab.a( ((double_tab.a(:,1)-double_tab.a(:,2)) >=minNT),:);
    if ltvar=="POcclude"
        dimer_1minus=1-dimer_tab.a(:,3);
        double_1minus=1-double_tab.a(:,3);
        if type1=="ratio"
            ratio_tab=dimer_1minus./double_1minus;
        elseif type1=="dimer"
            ratio_tab=dimer_1minus;
        elseif type1=="double"
            ratio_tab=double_1minus;
        end
        ltvar="1-Pocc";
    else
        if type1=="ratio"
            ratio_tab=dimer_tab.a(:,3)./double_tab.a(:,3);
        elseif type1=="dimer"
            ratio_tab=dimer_tab.a(:,3);
        elseif type1=="double"
            ratio_tab=double_tab.a(:,3);
        end
    end
    tab= table(log10(ratio_tab),dimer_tab.a(:,2), dimer_tab.a(:,1)-dimer_tab.a(:,2));
end
h=heatmap(tab,'Var2','Var3','ColorVariable','Var1');
h.XLabel="Distance from PRM to FH2";
h.YLabel="Distance from PRM to NTD";
h.ColorMethod = 'none';
h.GridVisible="off";
h.NodeChildren(3).YDir='normal';

if type1=="ratio"
    load('customcolorbar_red_blue.mat');
    h.Colormap=CustomColormap;
    h.Title= strcat(ltvar, " ratio (dimer/double), FH2 dist= ", FH2_dist, ", x=",num2str(xcord),", y=",num2str(ycord));
else
    h.Colormap=cool;
    h.Title= strcat(ltvar," ", type1, " , FH2 dist= ", FH2_dist, ", x=",num2str(xcord),", y=",num2str(ycord));
end

hs=struct(h);
if calcTF
    ylabel(hs.Colorbar, strcat("CALCULATED log10 ", ltvar," ",type1))
else
    ylabel(hs.Colorbar, strcat("log10 ", ltvar," ",type1))
end

y=sort(tab.Var1(tab.Var1~=-Inf));
y = y(~isnan(y));
toobig=true;
ind=0;
while toobig
    ind=ind+1;
    if ind>10
        toobig=false;
    end
    if (y(1)+2)<y(2)
        y=y(2:end);
    else
        toobig=false;
    end
end
if type1=="ratio"
    if y(1)<0
        h.ColorLimits=[y(1) -y(1)];
    else
        h.ColorLimits=[-y(end) y(end)];
    end
    if y(1)<-10
        h.ColorLimits=[-10 10];
    end
else
    h.ColorLimits=[y(1) y(end)];
    if y(1)<-10
        h.ColorLimits=[-10 y(end)];
    end
end

if limits==0
else
    h.ColorLimits=limits;
end



for i=1:length(h.XDisplayLabels)
    if mod(i+minCT-1,20)~=0
        h.XDisplayLabels{i} = '';
    end
end
for i=1:length(h.YDisplayLabels)
    if mod(i+minNT-1,20)~=0
        h.YDisplayLabels{i} = '';
    end
end
    s = struct(h); 
    s.XAxis.TickLabelRotation = 0;   % horizontal

if saveTF
    fname=strcat('Heatmap_',ltvar,"_FH2",FH2_dist,"_x",num2str(xcord),"_y",num2str(ycord),"_",type1);
    if calcTF
        fname=strcat(fname,"_calculated");
    end
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
end