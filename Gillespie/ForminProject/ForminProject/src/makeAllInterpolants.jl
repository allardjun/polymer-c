using DataFrames

function makeAllInterpolants(df::DataFrame, method::String)

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

    # Create an empty dictionary to store interpolants
    interpolants = Dict{Symbol, Any}()

    # Iterate through each column in df3 (excluding k_cap, k_del, and r_cap)
    k_cap_range, k_del_range, r_cap_range = nothing, nothing, nothing
    for col in names(df_kpoly)
        if col ∉ [:k_cap, :k_del, :r_cap]
            # Create a new DataFrame with k_cap, k_del, r_cap, and the selected variable
            df_temp = select(df_kpoly, :k_cap, :k_del, :r_cap, col => :kpoly)

            # Get the interpolant function
            interpolant, k_cap_range, k_del_range, r_cap_range = makeinterpolant(df_temp, method)

            # Store the interpolant in the dictionary with the original column name as the key
            interpolants[Symbol(col)] = interpolant
        end
    end

    return interpolants, k_cap_range, k_del_range, r_cap_range
    
end