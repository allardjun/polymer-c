function fig=prvecheatmap(lt,FH2size,gridtype,saveTF,savefigfolder)
%PRVECHEATMAP creates heatmaps of percent difference between simulated and
%calculated probability density values across multiple delivery locations
%and for both tethered (NTD) and untethered filaments.
%
% fig =PRVECHEATMAP(lt,FH2size,gridtype,saveTF,savefigfolder)
% 
% Inputs:
%       lt           : (Lookuptable) lookuptable object to pull prvec values
%                       from, must have the prvec terms listed below
%       FH2size      : (double) FH2 size to use in calculation (should be FH2
%                       size used in simulations recorded in lt)
%       gridtype     : layout for tiled layout 
%                       1- 1x15 grid (default)
%                       2- 3x5 grid
%       saveTF       : whether or not to save the output figures (default is
%                       false)
%       savefigfolder: location to save output figures (default is empty
%                       string)
% 
%   Output is a 2x1 figure array with a figure for double and a figure for
%   dimer, each figure containing a tiled layout with a heatmap for the
%   following 15 delivery sites:
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
%   Percent difference values are simulated-calculated/simulated.
% 
% See also MAKELOOKUPMAT, LOOKUPTABLE, PR.
arguments
    lt Lookuptable
    FH2size double
    gridtype =1 %1 = 1x15, 2= 3x5
    saveTF=0
    savefigfolder="" 
end

    set(groot,'defaultfigureposition',[400 250 1500 800])
    types=["double","dimer"];
    for k=1:2
        type=types(k);
        fig=figure;
        if gridtype==1
            tiles=tiledlayout(1,15,'TileSpacing','tight','Padding','none');
        elseif gridtype==2
            tiles=tiledlayout(3,5,'TileSpacing','tight','Padding','none');
        end
        title(tiles,{"Percent diff Simulated vs. Calculated",strcat(type,"; FH2size: ",num2str(FH2size))})
        
        prvec_types=["Prvec0","Prvec0_halfup","Prvec0_halfup_op","Prvec0_op","Prvec0_up","Prvec0_up_op","Prvec_cen","Prvec_cen_halfup","Prvec_cen_up","Prvec_offcen","Prvec_offcen_halfup","Prvec_offcen_halfup_op","Prvec_offcen_op","Prvec_offcen_up","Prvec_offcen_up_op"];
        prvec_types_names=["attachment","halfup","halfup,op","op","up","up,op","cen","cen,halfup","cen,up","offcen","offcen,halfup","offcen,halfup,op","offcen,op","offcen,up","offcen,up,op"];
        x_coords=[0,0,FH2size,FH2size,0,FH2size,FH2size/2,FH2size/2,FH2size/2,(FH2size/2)-8.333,(FH2size/2)-8.333,(FH2size/2)+8.333,(FH2size/2)+8.333,(FH2size/2)-8.333,(FH2size/2)+8.333];
        y_coords=[0,8.333,8.333,0,16.666,16.666,0,8.333,16.666,0,8.333,8.333,0,16.666,16.666];
        for i=1:15
            valtab=lt.stattable(prvec_types(i),type);
            valtab.a(1,4)=0;
            for j=1:length(valtab.a)
                if type=="ratio"
                    val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type);
                else
                    val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type)/(6.1503*10^7);
                end
                valtab.a(j,4)=val;
            end
            tab=valtab.a;
            tab(:,3)=mean([valtab.a(:,3),valtab.b(:,3)],2);
            tab(:,5)=abs(tab(:,4)-tab(:,3))./(tab(:,3));
            tab=array2table(tab,'VariableNames',{'FH1 Length','PRM loc','Avg prvec','Calc prvec','calc-sim'});
            ax1=nexttile(i);
            h=heatmap(tab,'FH1 Length','PRM loc','ColorVariable','calc-sim','ColorMethod','none');
            ylabs_num=1:str2double(h.YDisplayLabels{end});
            ylabs=string(ylabs_num);
            xlabs_num=1:str2double(h.XDisplayLabels{end});
            xlabs=string(ylabs_num);
            if i==1 || (gridtype==2 && (i==6 || i==11))
                ylabs(mod(ylabs_num,50) ~= 0)="";
            else
                ylabs(:)="";
                h.YLabel='';
            end
    
            if length(xlabs)==length(h.XDisplayLabels)
                xlabs(mod(xlabs_num,50) ~= 0)="";
                h.XDisplayLabels=xlabs;
            end
            h.YDisplayLabels=ylabs;
            h.NodeChildren(3).YDir='normal';
            if gridtype==1
                h.title({prvec_types_names(i),strcat("[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]")})
            elseif gridtype==2
                h.title(strcat(prvec_types_names(i)," [",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            end
    
            % allvals=sort(tab.("calc-sim"));
            % allvals=rmoutliers(allvals);
            % allvals = allvals(~isnan(allvals));
            % h.ColorLimits=[0 allvals(end)];
            h.GridVisible="off";
            h.ColorLimits=[0 1];
            if i~=15
                h.ColorbarVisible = 'off';
            end
    
            if gridtype==2
                if i==5 || i==10
                    h.ColorbarVisible = 'on';
                end
                if i<11
                    h.XLabel='';
                    h.XDisplayLabels=strings([1 length(h.XDisplayLabels)]);
                end
            end
        end
    
        if(saveTF)
            fname=strcat('Probdensity_heatmap_',num2str(FH2size),"_",type);
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
        end
    end
end