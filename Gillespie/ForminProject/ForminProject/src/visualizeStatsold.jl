using Plots
using LinearAlgebra

function visualizeStats(outDict::Dict{Vector{Vector{Int}},Dict{String, Any}}, stat::String)

    statMat, PRMlocs=makeStatMat(outDict, stat)
    PRMlocs = [string(label) * " a" for label in PRMlocs]
    
    
    dict_keys = sort(collect(keys(statMat)), by = key -> sum(length.(key)))
    nPRMs = length(PRMlocs) # Assume all arrays have the same length

    # Compute custom y-axis ordering for each x-axis value
    all_y_labels = []
    all_data_matrices = []
    for x_idx in 1:nPRMs
        current_site = PRMlocs[x_idx]
        # Group keys by number of bound sites and sort by circular distance
        grouped_keys = Dict{Int, Vector{Vector{Vector{Float64}}}}()
        for key in dict_keys
            num_bound_sites = sum(length.(key))
            if !haskey(grouped_keys, num_bound_sites)
                grouped_keys[num_bound_sites] = []
            end
            push!(grouped_keys[num_bound_sites], key)
        end
        
        # Sort within each group by distance to the current x-axis site
        ordered_keys = []
        cluster_labels = []
        for (num_bound_sites, key_group) in sort(collect(grouped_keys), by = x -> x[1])
            a_keys = filter(k -> PRMlocs[x_idx][end] == 'a', key_group)
            b_keys = filter(k -> PRMlocs[x_idx][end] == 'b', key_group)
        
            # Sort each strand separately
            sorted_a = sort(a_keys, by = key -> minimum_distance(current_site, key))
            sorted_b = sort(b_keys, by = key -> minimum_distance(current_site, key))
        
            append!(ordered_keys, sorted_a)
            append!(ordered_keys, sorted_b)
            
            push!(cluster_labels, "Cluster $(num_bound_sites) sites")
        end

        # Store string representations of ordered keys for y-tick labels
        reordered_data_matrix = [statMat[key][x_idx] for key in ordered_keys]
        push!(all_data_matrices, reordered_data_matrix)
        push!(all_y_labels, cluster_labels)
    end

    data_matrix = hcat(all_data_matrices...)

    y_tick_positions = []
    y_tick_labels = []

    pos = 0
    for cluster in all_y_labels[1]
        len_cluster = length(cluster)
        pos += len_cluster
        push!(y_tick_positions, pos - len_cluster / 2)  # Place label in middle of cluster
        push!(y_tick_labels, cluster[1])  # Use only the first occurrence per cluster
    end

    separator_row = fill(NaN, size(data_matrix, 2))  # A row of NaNs

    new_data_matrix = []
    for cluster in all_data_matrices
        append!(new_data_matrix, cluster)
        push!(new_data_matrix, separator_row)  # Insert separator
    end

    # Create the heatmap for each x-axis value, maintaining dynamic y-axis label ordering
    Plots.plot()
    p=Plots.heatmap(
        1:nPRMs, 1:length(dict_keys), data_matrix,
        xlabel="PRM Location", ylabel="Number of Bound Sites",
        xticks=(1:nPRMs, PRMlocs),
        yticks=(y_tick_positions, y_tick_labels), 
        title="$stat Heatmap"
    )
    display(p)
end

function minimum_distance(current_site::String, key::Vector{Vector{Float64}})
    # Extract strand and numerical position
    current_strand = current_site[end]
    current_site = parse(Float64, current_site[1:end-2])

    mindist = 100000  # Large initial value

    for veci in 1:2 
        vec = key[veci]
        for site in vec
            site_strand = 'a'  # Default to "a" strand
            if veci == 2
                site = -site
                site_strand = 'b'  # "b" strand when from vec[2]
            end

            # Compute distance
            dist = abs(current_site - site)
            
            # If strands are different, distance is larger
            if current_strand != site_strand
                dist += 1000  # Add penalty for switching strands
            end

            # Update minimum distance
            if dist < mindist
                mindist = dist
            end
        end
    end
    return mindist
end