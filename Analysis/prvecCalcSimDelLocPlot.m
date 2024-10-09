function fig=prvecCalcSimDelLocPlot(lt,FH2size,FH1size,type)
%PRVECCALCSIMDELLOCPLOT creates plots of calculated and simulated
% probability density values vs delivery location to investigate impact of
% PRM location and FH1 length.
%
% fig =PRVECCALCSIMDELLOCPLOT(lt,FH2size,FH1size,type)
% 
% Inputs:
%       lt           : (Lookuptable) lookuptable object to pull prvec values
%                       from, must have the prvec terms listed below
%       FH2size      : (double) FH2 size to use in calculation (should be FH2
%                       size used in simulations recorded in lt)
%       FH1size      : size of FH1 domain (only relevent if type is dimer
%                       or ratio)
%       type         : filament model type to use (double, dimer, ratio)
% 
%   Output is a 3x1 figure with the following figures:
%       1 - calculated (curve) and simulated (points, see below)
%           probability density values vs. delivery location, colored by
%           FH1 length, on a 2x3 grid with different PRM locations
%       2 - calculated (curve) and simulated (points, see below) log10
%           probability density values vs. delivery location, colored by
%           FH1 length, on a 2x3 grid with different PRM locations
%       3 - calculated (curve) and simulated (points, see below) log10
%           probability density values vs. delivery location, colored by
%           FH1 length, on a 2x3 grid with different PRM locations;
%           multiple curves for different FH1 lengths
%
%   Simulated locations plotted:
%       "Prvec0"
%       "Prvec0_halfup"
%       "Prvec0_halfup_op"
%       "Prvec0_op"
%       "Prvec0_up"
%       "Prvec0_up_op"
%       "Prvec_cen"
%       "Prvec_cen_halfup"
%       "Prvec_cen_up"  
%       "Prvec_offcen"
%       "Prvec_offcen_halfup"
%       "Prvec_offcen_halfup_op"    
%       "Prvec_offcen_op"   
%       "Prvec_offcen_up"
%       "Prvec_offcen_up_op"
% 
%   Uses the function Pr.m (located in ForminKineticModel) to calculate
%   values.
% 
% See also MAKELOOKUPMAT, LOOKUPTABLE, PR, LOOKUPTABLE/STATTABLE.

    PRMlocs.double=[1,10,20,50,100,200];

    PRMlocs.dimer=[20,50,60,75,80,100];

    PRMlocs_sweep=[20,30,40,50,100];

    fh1sizes=[50,75,100,125,150,175,200,250,300,350];

    prvec_types=["Prvec0","Prvec0_halfup","Prvec0_halfup_op","Prvec0_op","Prvec0_up","Prvec0_up_op","Prvec_cen","Prvec_cen_halfup","Prvec_cen_up","Prvec_offcen","Prvec_offcen_halfup","Prvec_offcen_halfup_op","Prvec_offcen_op","Prvec_offcen_up","Prvec_offcen_up_op"];
    prvec_types_names=["attachment","halfup","halfup,op","op","up","up,op","cen","cen,halfup","cen,up","offcen","offcen,halfup","offcen,halfup,op","offcen,op","offcen,up","offcen,up,op"];
    x_coords=[0,0,FH2size,FH2size,0,FH2size,FH2size/2,FH2size/2,FH2size/2,(FH2size/2)-8.333,(FH2size/2)-8.333,(FH2size/2)+8.333,(FH2size/2)+8.333,(FH2size/2)-8.333,(FH2size/2)+8.333];
    y_coords=[0,8.333,8.333,0,16.666,16.666,0,8.333,16.666,0,8.333,8.333,0,16.666,16.666];
    r=(x_coords.^2+y_coords.^2).^(1/2);
    
    vals_a=arrayfun(@(x) lt.stattable(x,type).a,prvec_types,"UniformOutput",false);
    vals_b=arrayfun(@(x) lt.stattable(x,type).b,prvec_types,"UniformOutput",false);
    
    set(groot,'defaultfigureposition',[400 250 1500 800]) % helps prevent cut offs in figs
    fig(1)=figure;
    % tl= tiledlayout(2,3,'TileSpacing','tight','Padding','none');
    % 
    % for j=PRMlocs.(type)
    %     nexttile
    %     if type=="double"
    %         makeplot(j,0)
    %     else
    %         if j==PRMlocs.(type)(3)
    %             makeplot_fh1lensweep(j,1,0,0)
    %         else
    %             makeplot_fh1lensweep(j,0,0,0)
    %         end
    %     end
    % end
    % 
    % fig(2)=figure;
    tl= tiledlayout(2,3,'TileSpacing','tight','Padding','none');

    for j=PRMlocs.(type)
        nexttile
        if type=="double"
            makeplot(j,1)
        else
            if j==PRMlocs.(type)(1)
                makeplot_fh1lensweep(j,1,1,0)
            else
                makeplot_fh1lensweep(j,0,1,0)
            end
        end
    end

    fig(3)=figure;
    if type=="double"
        makeplot_fullsweep(0)
    else
        tl= tiledlayout(1,3,'TileSpacing','tight','Padding','none');
        nexttile
        makeplot_fullsweep(0)
        nexttile
        makeplot_fullsweep(8.333)
        nexttile
        makeplot_fullsweep(16.666)
    end
    

    function makeplot(PRMloc,logTF)
        if logTF
            f_pr=@(x) log10(pr(PRMloc,FH1size,FH2size,1,x,0,type)./(6.1503.*10^7)); %keep in units of kuhn length
        else
            f_pr=@(x) pr(PRMloc,FH1size,FH2size,1,x,0,type)./(6.1503.*10^7); %keep in units of kuhn length
        end
        
        fplot(f_pr,[0 40],"DisplayName","calculated");
        hold on
        xlabel("Delivery location, distance from attachment point (kuhn lengths)")
        if logTF
            ylabel("log10 Probability Density (kuhn lengths)")
        else
            ylabel("Probability Density (kuhn lengths)")
        end
        
        if type=="double"
            title(strcat("PRM loc: ",num2str(PRMloc),", ",type))

            f_a=cellfun(@(x) x(x(:,2)==PRMloc,3),vals_a,"UniformOutput",false);
            f_b=cellfun(@(x) x(x(:,2)==PRMloc,3),vals_b,"UniformOutput",false);
            f_fh1=cellfun(@(x) x(x(:,2)==PRMloc,1),vals_b,"UniformOutput",false);
        else
            title(strcat("PRM loc: ",num2str(PRMloc),", FH1 Size: ",num2str(FH1size),", FH2 Size: ",num2str(FH2size),", ",type))
            f_a=cellfun(@(x) x((x(:,2)==PRMloc)&(x(:,1)==FH1size),3),vals_a,"UniformOutput",false);
            f_b=cellfun(@(x) x((x(:,2)==PRMloc)&(x(:,1)==FH1size),3),vals_b,"UniformOutput",false);
            f_fh1=cellfun(@(x) x((x(:,2)==PRMloc)&(x(:,1)==FH1size),1),vals_b,"UniformOutput",false);
        end
        
        for i=1:15
            tab=table('Size',[length(f_a{1,i}) 3],'VariableTypes',["double","double","double"], 'VariableNames',["Pr", "r","fh1"]);
            if logTF
                tab.Pr=log10(f_a{1,i});
            else
                tab.Pr=f_a{1,i};
            end
            tab.fh1=f_fh1{1,i};
            tab.r(:)=r(i);
            scatter(tab,"r","Pr",'filled','ColorVariable',"fh1")
        end
        c=colorbar;
        c.Label.String="FH1 length";
        colormap cool
    end

    function makeplot_fullsweep(ycoord)
        hold on
        coloroptions=cool(length(PRMlocs_sweep));
        for k=1:length(PRMlocs_sweep)
            f_pr=@(x) log10(pr(PRMlocs_sweep(k),FH1size,FH2size,1,x,ycoord,type)./(6.1503.*10^7)); %keep in units of kuhn length
            fplot(f_pr,[0 40],"DisplayName",num2str(PRMlocs_sweep(k)),"Color",coloroptions(k,:));
        end
        leg=legend;
        leg.Location="southwest";
        title(leg,"PRM Location")
        xlabel("Delivery location, distance from attachment point (kuhn lengths)")
        ylabel("log10 Probability Density (kuhn lengths)")
        if type=="double"
            title(strcat(type))
        else
            title(strcat("FH1 Size: ",num2str(FH1size),", FH2 Size: ",num2str(FH2size),", y-coord: ",num2str(ycoord),", ",type))
        end
        
        for k=1:length(PRMlocs_sweep)
            if type=="double"
                f_a=cellfun(@(x) x((x(:,2)==PRMlocs_sweep(k)),3),vals_a,"UniformOutput",false);
                f_b=cellfun(@(x) x(x(:,2)==PRMlocs_sweep(k),3),vals_b,"UniformOutput",false);
                f_prm=cellfun(@(x) x(x(:,2)==PRMlocs_sweep(k),2),vals_b,"UniformOutput",false);
            else
                f_a=cellfun(@(x) x((x(:,2)==PRMlocs_sweep(k))&(x(:,1)==FH1size),3),vals_a,"UniformOutput",false);
                f_b=cellfun(@(x) x((x(:,2)==PRMlocs_sweep(k))&(x(:,1)==FH1size),3),vals_b,"UniformOutput",false);
                f_prm=cellfun(@(x) x((x(:,2)==PRMlocs_sweep(k))&(x(:,1)==FH1size),2),vals_b,"UniformOutput",false);
            end
            
            l=length(f_a{1,1});
            tab=table('Size',[l*15 5],'VariableTypes',["double","double","double","double","double"], 'VariableNames',["Pr", "r","prmloc","Pra","Prb"]);

            for i=1:15
                if type=="dimer" && y_coords(i)~=ycoord
                    continue
                end
                tab.Pra((i-1)*l+1:i*l)=log10(f_a{1,i});
                tab.Prb((i-1)*l+1:i*l)=log10(f_b{1,i});
                tab.Pr((i-1)*l+1:i*l)=log10(mean([f_a{1,i},f_b{1,i}]));
                tab.prmloc((i-1)*l+1:i*l)=f_prm{1,i};
                tab.r(((i-1)*l+1:i*l))=r(i);
            end
            tab=tab(tab.prmloc~=0,:);
            tab = sortrows(tab,"r","ascend");
            plot(tab.r,tab.Pr,"--",'Color',coloroptions(k,:),'MarkerEdgeColor',coloroptions(k,:),'Marker','o','MarkerFaceColor',coloroptions(k,:),'HandleVisibility','off','MarkerSize',4)
            plot(tab.r,tab.Pra,"*",'MarkerEdgeColor',coloroptions(k,:),'MarkerFaceColor',coloroptions(k,:),'HandleVisibility','off','MarkerSize',3)
            plot(tab.r,tab.Prb,"x",'MarkerEdgeColor',coloroptions(k,:),'MarkerFaceColor',coloroptions(k,:),'HandleVisibility','off','MarkerSize',3)
        end
    end

    function makeplot_fh1lensweep(PRMloc,legTF,logTF,ycoord)
        hold on
        coloroptions=cool(length(fh1sizes));
        for k=1:length(fh1sizes)
            if logTF
                f_pr=@(x) log10(pr(PRMloc,fh1sizes(k),FH2size,1,x,ycoord,type)./(6.1503.*10^7)); %keep in units of kuhn length
            else
                f_pr=@(x) (pr(PRMloc,fh1sizes(k),FH2size,1,x,ycoord,type)./(6.1503.*10^7)); %keep in units of kuhn length
            end
            fplot(f_pr,[0 40],"DisplayName",num2str(fh1sizes(k)),"Color",coloroptions(k,:),'Visible',(fh1sizes(k)>=PRMloc));
        end
        if legTF
            leg=legend;
            leg.Location="southwest";
            title(leg,"FH1 Size")
        end
        xlabel("Delivery location, distance from attachment point (kuhn lengths)")
        if logTF
            ylabel("log10 Probability Density (kuhn lengths)")
        else
            ylabel("Probability Density (kuhn lengths)")
        end
        
        if type=="double"
            title(strcat("PRM loc: ",num2str(PRMloc),", ",type))
        else
            title(strcat("PRM loc: ",num2str(PRMloc),", FH2 Size: ",num2str(FH2size),", y-coord: ",num2str(ycoord),", ",type))
        end
        
        for k=1:length(fh1sizes)
            if fh1sizes(k)<PRMloc
                continue
            end
            f_a=cellfun(@(x) x((x(:,2)==PRMloc)&(x(:,1)==fh1sizes(k)),3),vals_a,"UniformOutput",false);
            f_b=cellfun(@(x) x((x(:,2)==PRMloc)&(x(:,1)==fh1sizes(k)),3),vals_b,"UniformOutput",false);
            f_fh1=cellfun(@(x) x((x(:,2)==PRMloc)&(x(:,1)==fh1sizes(k)),1),vals_b,"UniformOutput",false);
            
            l=length(f_a{1,1});
            tab=table('Size',[l*15 5],'VariableTypes',["double","double","double","double","double"], 'VariableNames',["Pr", "r","fh1size","Pra","Prb"]);
            for i=1:15
                if y_coords(i)~=ycoord
                        continue
                end
                if logTF
                    tab.Pra((i-1)*l+1:i*l)=log10(f_a{1,i}); 
                    tab.Prb((i-1)*l+1:i*l)=log10(f_b{1,i});
                    tab.Pr((i-1)*l+1:i*l)=log10(mean([f_a{1,i},f_b{1,i}]));
                else
                    tab.Pra((i-1)*l+1:i*l)=(f_a{1,i});
                    tab.Prb((i-1)*l+1:i*l)=(f_b{1,i});
                    tab.Pr((i-1)*l+1:i*l)=mean([f_a{1,i},f_b{1,i}]);
                end
                
                tab.fh1size((i-1)*l+1:i*l)=f_fh1{1,i};
                tab.r((i-1)*l+1:i*l)=x_coords(i);
            end
            tab=tab(tab.fh1size~=0,:);
            tab = sortrows(tab,"r","ascend");
            plot(tab.r,tab.Pr,"--",'Color',coloroptions(k,:),'MarkerEdgeColor',coloroptions(k,:),'Marker','o','MarkerFaceColor',coloroptions(k,:),'HandleVisibility','off','MarkerSize',4)
            plot(tab.r,tab.Pra,"*",'MarkerEdgeColor',coloroptions(k,:),'MarkerFaceColor',coloroptions(k,:),'HandleVisibility','off','MarkerSize',3)
            plot(tab.r,tab.Prb,"x",'MarkerEdgeColor',coloroptions(k,:),'MarkerFaceColor',coloroptions(k,:),'HandleVisibility','off','MarkerSize',3)
        end
    end
end