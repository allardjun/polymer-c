using PlotlyJS

function barvisuals(fname, title, saveloc)
    outDict=ForminProject.makeOutputDict(fname)

    data_matrixpr, x1, y1, z1=ForminProject.visualizeStats(outDict, "Prvec0")
    data_matrixpo, x1, y1, z1=ForminProject.visualizeStats(outDict, "POcclude")

    data_matrixpr_onebound=data_matrixpr[findall(data_matrixpr[:, 6] .<= 1),:];
    data_matrixpo_onebound=data_matrixpo[findall(data_matrixpr[:, 6] .<= 1),:];
    
    #makebarvisualplots(data_matrixpr_onebound, "Prvec0", title, saveloc)
    #makebarvisualplots(data_matrixpo_onebound, "POcclude", title, saveloc)

    data_matrixpr_twobound=data_matrixpr[findall(data_matrixpr[:, 6] .== 2),:];
    data_matrixpr_twobound_self=data_matrixpr[findall(data_matrixpr[:, 5] .== 0),:];
    
    makebarvisualplots_twobound(data_matrixpr_twobound_self, "Prvec0", title, saveloc)
end


function makebarvisualplots_onebound(data_matrix, type, title, saveloc)
    PRMlocs = unique(data_matrix[:, 2])
    PRMlocs=sort(PRMlocs)
    PRMlocs_rev=sort(PRMlocs, rev=true)
    PRMlocs_strings_a = [string(label) * " a" for label in PRMlocs_rev]
    PRMlocs_strings_b=[string(label) * " b" for label in PRMlocs]
    PRMlocs_strings = vcat(PRMlocs_strings_a, PRMlocs_strings_b)
    traces = PlotlyJS.AbstractTrace[] 

    data_matrix_fil_a=data_matrix[findall(data_matrix[:, 9] .!= -1),:]
    data_matrix_fil_b=data_matrix[findall(data_matrix[:, 10] .!= -1),:]

    data_matrix_unbound=data_matrix[findall(data_matrix[:, 9] .== -1),:]
    data_matrix_unbound=data_matrix_unbound[findall(data_matrix_unbound[:, 10] .== -1),:]

    data_matrix_unbound_a = data_matrix_unbound[findall(data_matrix_unbound[:, 3] .== 1),:]
    data_matrix_unbound_b = data_matrix_unbound[findall(data_matrix_unbound[:, 3] .== -1),:]

    values_unbound = zeros(2*length(PRMlocs), 1)
    for i in 1:length(PRMlocs)
        PRMloc = PRMlocs_rev[i]
        val=data_matrix_unbound_a[findall(data_matrix_unbound_a[:, 2] .== PRMloc),:][:,1]
        if length(val) == 1
            values_unbound[i] = val[1]
        else
            error("More than one value found for PRM location $PRMloc for unbound filament a")
        end
        val=data_matrix_unbound_b[findall(data_matrix_unbound_b[:, 2] .== PRMloc),:][:,1]
        if length(val) == 1
            values_unbound[2*length(PRMlocs)-i+1] = val[1]
        else
            error("More than one value found for PRM location $PRMloc for unbound filament b")
        end
    end
    push!(traces, PlotlyJS.bar(
        x=PRMlocs_strings, # target PRM
        y=values_unbound[1:2*length(PRMlocs)], # values for filament a
        name="unbound", # PRM bound
    ))

    for PRM_loc in PRMlocs_rev
        data_matrix_prm_a = data_matrix_fil_a[findall(data_matrix_fil_a[:, 9] .== PRM_loc),:]

        data_matrix_prm_a_a = data_matrix_prm_a[findall(data_matrix_prm_a[:, 3] .== 1),:]
        data_matrix_prm_a_b = data_matrix_prm_a[findall(data_matrix_prm_a[:, 3] .== -1),:]

        values_a = zeros(2*length(PRMlocs), 1)
        
        for i in 1:length(PRMlocs)
            PRMloc = PRMlocs_rev[i]
            val=data_matrix_prm_a_a[findall(data_matrix_prm_a_a[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_a[i] = val[1]
            else
                error("More than one value found for PRM location $PRMloc in filament a")
            end
            val=data_matrix_prm_a_b[findall(data_matrix_prm_a_b[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_a[2*length(PRMlocs)-i+1] = val[1]
            else
                error("More than one value found for PRM location $PRMloc in filament b")
            end
        end
        push!(traces, PlotlyJS.bar(
            x=PRMlocs_strings, # target PRM
            y=values_a[1:2*length(PRMlocs)], # values for filament a
            name=string(PRM_loc)*" a", # PRM bound
        ))
    end

    for PRM_loc in PRMlocs
        data_matrix_prm_b = data_matrix_fil_b[findall(data_matrix_fil_b[:, 10] .== PRM_loc),:]

        data_matrix_prm_b_a = data_matrix_prm_b[findall(data_matrix_prm_b[:, 3] .== 1),:]
        data_matrix_prm_b_b = data_matrix_prm_b[findall(data_matrix_prm_b[:, 3] .== -1),:]

        values_b = zeros(2*length(PRMlocs), 1)
        
        for i in 1:length(PRMlocs)
            PRMloc = PRMlocs_rev[i]

            val=data_matrix_prm_b_a[findall(data_matrix_prm_b_a[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_b[i] = val[1]
            else
                error("More than one value found for PRM location $PRMloc in filament a")
            end
            val=data_matrix_prm_b_b[findall(data_matrix_prm_b_b[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_b[2*length(PRMlocs)-i+1] = val[1]
            else
                error("More than one value found for PRM location $PRMloc in filament b")
            end
        end
        push!(traces, PlotlyJS.bar(
            x=PRMlocs_strings, # target PRM
            y=values_b[1:2*length(PRMlocs)], # values for filament b
            name=string(PRM_loc)*" b", # PRM bound
        ))
    end

    # Create the layout for grouped bars
    if type=="POcclude"
        layout = Layout(
            barmode="group",  # Grouped bars
            title=type * " for single bound PRM; " * title,
            xaxis_title="Target PRM",
            yaxis_title="Value",
            yaxis=attr(range=[0.8, 1], showgrid=true)
        )
    else
        layout = Layout(
            barmode="group",  # Grouped bars
            title=type * " for single bound PRM; " * title,
            xaxis_title="Target PRM",
            yaxis_title="Value"
        )
    end

    # Plot
    p=PlotlyJS.plot(traces, layout)
    display(p)

    # Save the plot as a png 
    savetitle="PRMbars"*string(type)*"_"*title*".png"
    PlotlyJS.savefig(p, joinpath(saveloc,savetitle), width=1600, height=1200)
end


function makebarvisualplots_twobound(data_matrix, type, title, saveloc)
    PRMlocs = unique(data_matrix[:, 2])
    PRMlocs=sort(PRMlocs)
    PRMlocs_rev=sort(PRMlocs, rev=true)
    PRMlocs_strings_a = [string(label) * " a" for label in PRMlocs_rev]
    PRMlocs_strings_b=[string(label) * " b" for label in PRMlocs]
    PRMlocs_strings = vcat(PRMlocs_strings_a, PRMlocs_strings_b)
    traces = PlotlyJS.AbstractTrace[] 

    data_matrix_fil_a=data_matrix[findall(data_matrix[:, 11] .!= -1),:]
    data_matrix_fil_b=data_matrix[findall(data_matrix[:, 12] .!= -1),:]

    display(data_matrix)
    data_matrix_unbound=data_matrix[findall(data_matrix[:, 11] .== -1),:]
    data_matrix_unbound=data_matrix_unbound[findall(data_matrix_unbound[:, 12] .== -1),:]

    display(data_matrix_unbound)
    data_matrix_unbound_a = data_matrix_unbound[findall(data_matrix_unbound[:, 3] .== 1),:]
    data_matrix_unbound_b = data_matrix_unbound[findall(data_matrix_unbound[:, 3] .== -1),:]

    display(data_matrix_unbound_a)
    display(data_matrix_unbound_b)
    values_unbound = zeros(2*length(PRMlocs), 1)
    for i in 1:length(PRMlocs)
        PRMloc = PRMlocs_rev[i]
        val=data_matrix_unbound_a[findall(data_matrix_unbound_a[:, 2] .== PRMloc),:][:,1]
        if length(val) == 1
            values_unbound[i] = val[1]
        elseif length(val) == 0
            values_unbound[i] = 0
        else
            display(val)
            error("More than one value found for PRM location $PRMloc for unbound filament a")
        end
        val=data_matrix_unbound_b[findall(data_matrix_unbound_b[:, 2] .== PRMloc),:][:,1]
        if length(val) == 1
            values_unbound[2*length(PRMlocs)-i+1] = val[1]
        elseif length(val) == 0
            values_unbound[2*length(PRMlocs)-i+1] = 0
        else
            display(val)
            error("More than one value found for PRM location $PRMloc for unbound filament b")
        end
    end
    push!(traces, PlotlyJS.bar(
        x=PRMlocs_strings, # target PRM
        y=values_unbound[1:2*length(PRMlocs)], # values for filament a
        name="self bound", # PRM bound
    ))

    for PRM_loc in PRMlocs_rev
        data_matrix_prm_a = data_matrix_fil_a[findall(data_matrix_fil_a[:, 11] .== PRM_loc),:]

        data_matrix_prm_a_a = data_matrix_prm_a[findall(data_matrix_prm_a[:, 3] .== 1),:]
        data_matrix_prm_a_b = data_matrix_prm_a[findall(data_matrix_prm_a[:, 3] .== -1),:]

        values_a = zeros(2*length(PRMlocs), 1)
        
        for i in 1:length(PRMlocs)
            PRMloc = PRMlocs_rev[i]
            val=data_matrix_prm_a_a[findall(data_matrix_prm_a_a[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_a[i] = val[1]
            elseif length(val) == 0
                values_a[i] = 0
            else
                display(val)
                display(data_matrix_prm_a_a)
                error("More than one value found for PRM location $PRMloc in filament a")
            end
            val=data_matrix_prm_a_b[findall(data_matrix_prm_a_b[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_a[2*length(PRMlocs)-i+1] = val[1]
            elseif length(val) == 0
                values_a[2*length(PRMlocs)-i+1] = 0
            else
                display(val)
                display(data_matrix_prm_a_b)
                error("More than one value found for PRM location $PRMloc in filament b")
            end
        end
        push!(traces, PlotlyJS.bar(
            x=PRMlocs_strings, # target PRM
            y=values_a[1:2*length(PRMlocs)], # values for filament a
            name=string(PRM_loc)*" a", # PRM bound
        ))
    end

    for PRM_loc in PRMlocs
        data_matrix_prm_b = data_matrix_fil_b[findall(data_matrix_fil_b[:, 12] .== PRM_loc),:]

        data_matrix_prm_b_a = data_matrix_prm_b[findall(data_matrix_prm_b[:, 3] .== 1),:]
        data_matrix_prm_b_b = data_matrix_prm_b[findall(data_matrix_prm_b[:, 3] .== -1),:]

        values_b = zeros(2*length(PRMlocs), 1)
        
        for i in 1:length(PRMlocs)
            PRMloc = PRMlocs_rev[i]

            val=data_matrix_prm_b_a[findall(data_matrix_prm_b_a[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_b[i] = val[1]
            elseif length(val) == 0
                values_b[i] = 0
            else
                display(val)
                display(data_matrix_prm_b_a)
                error("More than one value found for PRM location $PRMloc in filament a")
            end
            val=data_matrix_prm_b_b[findall(data_matrix_prm_b_b[:, 2] .== PRMloc),:][:,1]
            if length(val) == 1
                values_b[2*length(PRMlocs)-i+1] = val[1]
            elseif length(val) == 0
                values_b[2*length(PRMlocs)-i+1] = 0
            else
                display(val)
                display(data_matrix_prm_b_b)
                error("More than one value found for PRM location $PRMloc in filament b")
            end
        end
        push!(traces, PlotlyJS.bar(
            x=PRMlocs_strings, # target PRM
            y=values_b[1:2*length(PRMlocs)], # values for filament b
            name=string(PRM_loc)*" b", # PRM bound
        ))
    end

    # Create the layout for grouped bars
    if type=="POcclude"
        layout = Layout(
            barmode="group",  # Grouped bars
            title=type * " for 2 bound PRMs; " * title,
            xaxis_title="Target PRM",
            yaxis_title="Value",
            yaxis=attr(range=[0.8, 1], showgrid=true)
        )
    else
        layout = Layout(
            barmode="group",  # Grouped bars
            title=type * " for 2 bound PRMs; " * title,
            xaxis_title="Target PRM",
            yaxis_title="Value"
        )
    end

    # Plot
    p=PlotlyJS.plot(traces, layout)
    display(p)

    # Save the plot as a png 
    savetitle="PRMbars_self"*string(type)*"_"*title*".png"
    PlotlyJS.savefig(p, joinpath(saveloc,savetitle), width=1600, height=1200)
end