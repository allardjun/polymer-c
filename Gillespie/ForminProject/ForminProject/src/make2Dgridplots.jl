using DataFrames, DelimitedFiles, Plots, Random, Interpolations, Statistics, Impute, NearestNeighbors


function make2Dgridplots(df::DataFrame, input_file::String,scaler::String, saveloc)
    savepath=joinpath(saveloc, "2Dgridplots")
    mkpath(savepath)
    # Convert k_cap, k_del, r_cap to Float64
    for col in [:k_cap, :k_del, :r_cap]
        if eltype(df[!, col]) <: AbstractFloat
        else
            df[!, col] .= parse.(Float64, df[!, col])
        end
    end

    # Function to extract one index from array columns
    function extract_index(df, idx)
        new_df = select(df, :k_cap, :k_del, :r_cap)  # Keep key columns
        for col in names(df)
            if eltype(df[!, col]) <: AbstractVector  # Check if column contains arrays
                new_df[!, col] = getindex.(df[!, col], idx)  # Extract specific index
            end
        end
        return new_df
    end

    # Create three DataFrames for each index (1, 2, 3)
    df_times = extract_index(df, 1)
    df_addedactin = extract_index(df, 2)
    df_kpoly = extract_index(df, 3)

    ratiodf=getratiodf(df_kpoly, input_file)
    
    scaleddf, scaledkeys=getscaleddf(ratiodf,scaler)

    keys=collect(names(scaleddf))

    for key in keys
        if contains(string(key), "ratio")
            keyscaleddf = select(scaleddf, scaledkeys[1], scaledkeys[2], key)
            keyscaleddf = dropmissing(keyscaleddf)  # Removes rows with missing values
        
            # Ensure values are non-NaN and positive before taking log10
            keyscaleddf = filter(row -> row[key] > 0 && !isnan(row[key]) && row[key] !== nothing, keyscaleddf)

            keyscaleddf = filter(row -> isfinite(log10(row[key])), keyscaleddf) # Filter out infinite values

            println(extrema(log10.(keyscaleddf[!, key])))  # Check min and max values

            jitter_amount = 0.08  # Adjust the jitter amount
            x_vals = log10.(keyscaleddf[:, scaledkeys[1]]) .+ jitter_amount * randn(size(keyscaleddf, 1))
            y_vals = log10.(keyscaleddf[:, scaledkeys[2]]) .+ jitter_amount * randn(size(keyscaleddf, 1))
            x_vals_raw = log10.(keyscaleddf[:, scaledkeys[1]])
            y_vals_raw = log10.(keyscaleddf[:, scaledkeys[2]]) 
            z_vals = log10.(keyscaleddf[!, key])

            max_val = maximum(abs, z_vals)
            color_limits = (-max_val, max_val)
            color_limits = (-.5, .5)
        
            # Ensure log10 is applied only to valid values
            p = Plots.plot(
                Plots.scatter(
                    x_vals,
                    y_vals,
                    zcolor=z_vals,
                    title=key,
                    marker=:circle,
                    clims=color_limits,
                    color=:bwr,  # Change the colormap
                    markersize=3,
                    xlabel="log10($(scaledkeys[1]))",
                    ylabel="log10($(scaledkeys[2]))",
                    colorbar_title="log10(kpoly/kpoly sum)",
                    legend=false
                )
            )
            display(p)
            filename = "$savepath/$(key)_dataplot.png"
            Plots.savefig(p, filename)

            interpolateplot(x_vals_raw,y_vals_raw,z_vals, color_limits, "log10($(scaledkeys[1]))", "log10($(scaledkeys[2]))", key, savepath)
            
        end
    end
    
end

function getscaleddf(df::DataFrame,scaler::String)
    out_df=df
    scalersym=Symbol(scaler)
    keys=[:k_cap,:k_del,:r_cap]
    scaledkeys=[]
    for key in keys
        if key===scalersym
            continue
        end
        newkey=Symbol(string(key,"_scaled"))
        out_df[!,newkey]=out_df[!,key]./out_df[!,scalersym]
        scaledkeys=push!(scaledkeys,newkey)
    end

    return out_df, scaledkeys
end


function getratiodf(df::DataFrame, input_file::String)
    out_df=df
    # Read the input .txt file with lines delimited by spaces
    lines = readlines(input_file)
    
    # Iterate over each line in the file
    for line in lines
        entries = split(line)  # Split the line into entries
        
        # Get key for the first entry 
        key1 = Symbol(string(entries[1]))  # Convert the first entry to a Symbol

        # initialize array to hold the rest of the keys
        keys = Vector{Symbol}()  # Initialize an empty array to hold the keys
        
        for entry in entries[2:end]  # Exclude the first entry
            newkey = Symbol(string(entry))  # Convert the entry to a Symbol
            push!(keys, newkey)  # Append the new key to the array
        end
        
        # Construct the new key for sum
        sum_key = Symbol(string(key1, "_sum"))

        out_df[!,sum_key]=sum(eachcol(df[:,keys]))

        # Construct the new key for ratio
        ratio_key = Symbol(string(key1, "_ratio"))

        out_df[!,ratio_key]=df[:,key1]./out_df[:,sum_key]

    end
    
    return out_df
end

function interpolateplot(x1, y1, z1, color_limits, xlab, ylab, key1, savepath)
    display(key1)
    # Create a DataFrame from the input data
    df_points = DataFrame(x=x1, y=y1, z=z1)

    # Aggregate by (x, y) pairs and take the mean for duplicate points
    df_agg = combine(groupby(df_points, [:x, :y]), :z => mean => :z)

    # Extract unique x and y values
    x_unique = sort(unique(df_agg.x))
    y_unique = sort(unique(df_agg.y))

    # Define a moderate resolution grid (instead of a very fine one)
    fine_nx, fine_ny = 500, 500  # Moderate grid size
    x_fine = LinRange(minimum(x_unique), maximum(x_unique), fine_nx)
    y_fine = LinRange(minimum(y_unique), maximum(y_unique), fine_ny)

    # Create a lookup dictionary for fast (x, y) → z access
    data_dict = Dict(zip(zip(df_agg.x, df_agg.y), df_agg.z))

    # Initialize matrix for interpolated z-values
    z_matrix = fill(NaN, length(x_unique), length(y_unique))

    for (i, x) in enumerate(x_unique), (j, y) in enumerate(y_unique)
        if haskey(data_dict, (x, y))
            z_matrix[i, j] = data_dict[(x, y)]
        end
    end

    # Impute missing values (ensuring full grid coverage)
    z_matrix = Impute.interpolate(z_matrix)

    z_matrix = Impute.fill(z_matrix, method=:nearest)

    # Create an interpolation object
    itp = Interpolations.interpolate((x_unique, y_unique), z_matrix,  Gridded(Constant()))

    # Compute interpolated values on the moderate grid
    z_fine = [itp[x, y] for y in y_fine, x in x_fine]

    # Generate the moderate-resolution heatmap
    p = Plots.heatmap(x_fine, y_fine, z_fine, color=:bwr,
        xlabel=xlab, ylabel=ylab, clims=color_limits, title=String(key1))

    # Overlay original data points
    Plots.scatter!(p, df_agg.x, df_agg.y, zcolor=df_agg.z, markersize=3, label="Original Data, mean", color=:bwr, clims=color_limits, colorbar_title="log10(kpoly/kpoly sum)", legend=true)

    display(p)

    filename = "$savepath/$(key1)_interpolateddataplot.png"
    Plots.savefig(p, filename)

end


