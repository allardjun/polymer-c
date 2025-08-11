using PlotlyJS
using LinearAlgebra

function visualizeStats(outDict::Dict{Vector{Vector{Int}},Dict{String, Any}}, stat::String)

    statMat, PRMlocs=makeStatMat(outDict, stat)
    #display(statMat)
    PRMlocs = vcat([string(label) * " a" for label in PRMlocs],[string(label) * " b" for label in PRMlocs])
    
    
    dict_keys = collect(keys(statMat))
    nPRMs = length(PRMlocs) # Assume all arrays have the same length

    data_matrix = zeros(Float64, nPRMs*length(dict_keys), 13)
    indx=0
    for j in 1:nPRMs
        loc = PRMlocs[j]
        PRMloc = loc[1:end-2]
        PRMloc = parse(Int, PRMloc)
        fil = loc[end]
        if fil == 'a'
            fil = 1
        else
            fil = -1
        end
        indstart = indx +1
        for i in 1:length(dict_keys)
            key = dict_keys[i]
            val = statMat[key][j]
            indx += 1
            data_matrix[indx,1] = val # value
            data_matrix[indx,2] = PRMloc # PRM location
            data_matrix[indx,3] = fil # filament number
            data_matrix[indx,4] = i # index of bound sites
            data_matrix[indx,5] = minimum_distance(loc, key) # minimum distance to bound sites
            data_matrix[indx,6] = get_number_bound_sites(key) # number of bound sites
            data_matrix[indx,7] = (minimum_distance(loc, key)+1) * sum(length.(key)) * sum(length.(key)) # product of distance and number of bound sites, for ordering purposes
            data_matrix[indx,8] = PRMloc * (fil) # unique identifier for each PRM)
            data_matrix[indx,9] = key[1][1] # location of bound PRM (only valid when 1 PRM is bound)
            data_matrix[indx,10] = key[2][1] # location of bound PRM (only valid when 1 PRM is bound)
            if get_number_bound_sites(key) ==2
                if minimum_distance(loc, key)==0
                    if fil==1
                        if key[2][1] == -1
                            if key[1][1]==PRMloc
                                data_matrix[indx,11] = key[1][2]
                            else
                                data_matrix[indx,11] = key[1][1]
                            end
                            data_matrix[indx,12] = -1
                        else
                            data_matrix[indx,11] = -1
                            data_matrix[indx,12] = key[2][1]
                        end
                    elseif fil==-1
                        if key[1][1] == -1
                            data_matrix[indx,11] = -1
                            if key[2][1]==PRMloc
                                data_matrix[indx,12] = key[2][2]
                            else
                                data_matrix[indx,12] = key[2][1]
                            end
                        else
                            data_matrix[indx,11] = key[1][1]
                            data_matrix[indx,12] = -1
                        end
                    else
                        error("Filament number must be either 1 or -1")
                    end
                else
                    data_matrix[indx,11] = -2
                    data_matrix[indx,12] = -2
                end
            elseif get_number_bound_sites(key)==1
                if minimum_distance(loc, key)==0
                    data_matrix[indx,11] = -1
                    data_matrix[indx,12] = -1
                else
                    data_matrix[indx,11] = -3
                    data_matrix[indx,12] = -3
                end

            else
                data_matrix[indx,11] = -3
                data_matrix[indx,12] = -3
            end
        end
        indend = indx
        mindists = data_matrix[indstart:indend,7]
        indexes= sortperm(mindists)
        for i in indexes
            data_matrix[indstart+i-1,13] = i
        end
    end
    
    x, y, z = data_matrix_transform(data_matrix,8,9,1)

    # Create the heatmap for each x-axis value, maintaining dynamic y-axis label ordering
    PlotlyJS.plot()
    p=PlotlyJS.heatmap(
        x=x, y=y, z=z,
        title="$stat Heatmap"
    )
    #display(p)
    return data_matrix, x, y, z
end

function minimum_distance(current_site::String, key::Vector{Vector{Int64}})
    # Extract strand and numerical position
    current_strand = current_site[end]
    current_site = parse(Float64, current_site[1:end-2])

    mindist = 100000  # Large initial value

    for veci in 1:2 
        vec = key[veci]
        if length(vec) == 1 && vec[1] == -1
            continue
        end
        for site in vec
            site_strand = 'a'  # Default to "a" strand
            if veci == 2
                site_strand = 'b'  # "b" strand when from vec[2]
            end

            # If strands are different, distance is larger
            if current_strand != site_strand
                dist = current_site + site
            else
                dist = abs(current_site - site)
            end

            # Update minimum distance
            if dist < mindist
                mindist = dist
            end
        end
    end
    if mindist==100000
        mindist=0
    end
    return mindist
end

function data_matrix_transform(data_matrix::Matrix{Float64},xind,yind,colorind)
    """
    Transform data matrix to be used in a heatmap plot.
    
    Parameters:
    - data_matrix: Matrix containing data to be plotted.
    - xind: Index of the column containing the x-axis values.
    - yind: Index of the column containing the y-axis values.
    - colorind: Index of the column containing the color values.
    
    Returns:
    - x: Array containing the x-axis values.
    - y: Array containing the y-axis values.
    - z: matrix containing the color values.
    """
    z = zeros(Float64, length(unique(data_matrix[:,xind])), length(unique(data_matrix[:,yind])))
    x = sort(unique(data_matrix[:,xind]))
    y = sort(unique(data_matrix[:,yind]))

    for i in 1:length(data_matrix[:,colorind])
        cval = data_matrix[i,colorind]
        xval = data_matrix[i,xind]
        yval = data_matrix[i,yind]
        xfound=true
        xin=0
        while xfound
            xin += 1
            if x[xin] == xval
                xfound=false
            end
        end
        yfound=true
        yin=0
        while yfound
            yin += 1
            if y[yin] == yval
                yfound=false
            end
        end
        z[xin,yin] = cval
    end

    return x,y,z
end

function get_number_bound_sites(key::Vector{Vector{Int64}})
    # Extract strand and numerical position
    numbound=0
    for veci in 1:2 
        vec = key[veci]
        if length(vec) == 1 && vec[1] == -1
            continue
        end
        for site in vec
            if site > 0
                numbound += 1
            end
        end
    end
    return numbound
end


