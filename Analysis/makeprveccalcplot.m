function fig=makeprveccalcplot(lt,FH2size,saveTF,savefigfolder)
arguments
    lt Lookuptable
    FH2size double
    saveTF=0
    savefigfolder="" 
end

    set(groot,'defaultfigureposition',[400 250 1500 800]) % helps prevent cut offs in figs
    
    prvec_types=["Prvec0","Prvec0_halfup","Prvec0_halfup_op","Prvec0_op","Prvec0_up","Prvec0_up_op","Prvec_cen","Prvec_cen_halfup","Prvec_cen_up","Prvec_offcen","Prvec_offcen_halfup","Prvec_offcen_halfup_op","Prvec_offcen_op","Prvec_offcen_up","Prvec_offcen_up_op"];
    prvec_types_names=["attachment","halfup","halfup,op","op","up","up,op","cen","cen,halfup","cen,up","offcen","offcen,halfup","offcen,halfup,op","offcen,op","offcen,up","offcen,up,op"];
    x_coords=[0,0,FH2size,FH2size,0,FH2size,FH2size/2,FH2size/2,FH2size/2,(FH2size/2)-8.333,(FH2size/2)-8.333,(FH2size/2)+8.333,(FH2size/2)+8.333,(FH2size/2)-8.333,(FH2size/2)+8.333];
    y_coords=[0,8.333,8.333,0,16.666,16.666,0,8.333,16.666,0,8.333,8.333,0,16.666,16.666];
    
    fig(1)=gridplots("dimer");
    % 
    % fig(2)=gridplots("ratio");
    % fig(3)=gridplots_diff("dimer");
    % fig(4)=gridplots_diff("ratio");
    
    % fig(2)=gridplots("double");
    % fig(3)=gridplots("ratio");
    % fig(4)=gridplots_diff("dimer");
    % fig(5)=gridplots_diff("double");
    % fig(6)=gridplots_diff("ratio");
    
    function fig1=gridplots(type)
        fig1=figure;
        tiles = tiledlayout(5,3,'TileSpacing','tight','Padding','none');
        for i=1:15
            ax1=nexttile(i);
            lt.ltplot("CTdist",prvec_types(i),1,'type',type,'scale',"log10",'ax1',ax1)
            title(strcat(type," FH2size: ",num2str(FH2size),"; delivery site: ",prvec_types_names(i),"[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            hold on
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
            s=scatter(ax1,valtab.a(:,2),log10(valtab.a(:,4)),10, 'filled','DisplayName',"calc");
            s=scatter(ax1,valtab.a(:,2),log10(valtab.a(:,4))-log10(valtab.a(:,3)),10, 'filled','DisplayName',"diff(calc-a)");
        end
        if(saveTF)
            fname=strcat('Probdensity_check_',num2str(FH2size),"_",type);
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
        end
    end

    function fig1=gridplots_diff(type)
        fig1=figure;
        tiles = tiledlayout(5,3,'TileSpacing','tight','Padding','none');
        for i=1:15
            ax1=nexttile(i);
            hold on
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
            s=scatter(ax1,valtab.a(:,2),abs((valtab.a(:,4))-(valtab.a(:,3))),10, 'filled','DisplayName',"diff(calc-a)");
            title(strcat(type,"; FH2size: ",num2str(FH2size),"; delivery site: ",prvec_types_names(i),"[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            xlabel("Distance from PRM to FH2")
            ylabel(strcat("difference ", prvec_types(i)))
        end
        if(saveTF)
            fname=strcat('Probdensity_check_',num2str(FH2size),"_",type,"_diff");
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
        end
    end

end