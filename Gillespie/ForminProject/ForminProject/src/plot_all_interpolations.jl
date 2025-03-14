using Plots
using Base.Threads  # For parallel processing

function plot_all_interpolations(interp_dict, kcap_range, kdel_range, rcap_range, slice_r_caps,saveloc,exclude)
    num_funcs = length(interp_dict)
    num_slices = length(slice_r_caps)

    # Create a list to hold individual plots
    #plot_list = []

    # Loop through each interpolation function in the dictionary
    keys_=collect(keys(interp_dict))

    for key in keys_
        # Get the interpolation function
        interp_func = interp_dict[key]
        # Call the plot_interpolation_slices function for each function
        if key==:k_cap || key==:k_del || key==:r_cap 
            continue
        end
        if key in exclude
            continue
        end
        gif_path=joinpath(saveloc, string(key))
        slices = plot_interpolation_slices(interp_func, kcap_range, kdel_range, rcap_range, slice_r_caps,key,gif_path)
        
        # Add each slice plot to the plot list
        #append!(plot_list, slices)
    end

    # Create a layout for the plots
    #plot_grid = Plots.plot(plot_list..., layout=(num_funcs, num_slices), size=(400 * num_slices, 400 * num_funcs))

    #display(plot_grid)
end

