using PlotlyJS
using Interpolations
using Images  # For saving images
using FileIO  # For saving images
using Base.Threads  # For parallel processing

# Helper function for creating meshgrid
function meshgrid(x, y)
    X = repeat(x', length(y), 1)  # Transpose x so that it is row-wise
    Y = repeat(y, 1, length(x))   # Expand y column-wise
    return X, Y
end

# Plot function with rotating frames and folder creation
function plot_interpolation_slices(interp_func, kcap_range, kdel_range, rcap_range, slice_r_caps, plot_title, gif_path)
    # Create a folder inside the gif_path to save the frames and GIF
    mkpath(gif_path)

    # Create a fine grid for kcap and kdel
    kcaps = LinRange(kcap_range[1], kcap_range[2], 50)
    kdels = LinRange(kdel_range[1], kdel_range[2], 50)

    # Compute k_poly values over the entire range to determine global color scale
    kcap_grid, kdel_grid = meshgrid(kcaps, kdels)
    rcap_grid = fill(slice_r_caps[1], size(kcap_grid))  # Just using the first slice to start
    kpoly_vals = [interp_func(kcap_grid[i, j], kdel_grid[i, j], slice_r_caps[1]) 
                  for i in 1:size(kcap_grid,1), j in 1:size(kcap_grid,2)]
    
    # Set the global color scale based on the min and max k_poly values
    cmin = minimum(x -> (isnan(x) || x == 0) ? Inf : x, kpoly_vals)
    cmax = maximum(x->isnan(x) ? -Inf : x,kpoly_vals)
    for slice_r_cap in slice_r_caps
        rcap_grid = fill(slice_r_cap, size(kcap_grid))
        kpoly_vals1 = [interp_func(kcap_grid[i, j], kdel_grid[i, j], slice_r_cap) 
                  for i in 1:size(kcap_grid,1), j in 1:size(kcap_grid,2)]
        
        cmin1 = minimum(x -> (isnan(x) || x == 0) ? Inf : x, kpoly_vals1)
        cmax1 = maximum(x->isnan(x) ? -Inf : x,kpoly_vals1)
        
        cmin = min(cmin1, cmin)
        cmax = max(cmax1, cmax)
        break
    end

    if occursin("ratio", String(plot_title))
        cmax=log10(cmax)
        cmin=log10(cmin)
        cmax=max(abs(cmin),abs(cmax))
        cmin=-cmax

        if cmin<-1
            cmin=-1
            cmax=1
        end

        # Create subplots layout
        layout = Layout(
            title=String(plot_title),
            scene=attr(
                xaxis_title="log10(k_cap)",
                yaxis_title="log10(k_del)",
                zaxis_title="log10(r_cap)"
            ),
            colorway=["#636EFA", "#EF553B", "#00CC96"],
            coloraxis=attr(
                colorscale="Picnic",  # Set a global color scale
                cmin=cmin,  # Global minimum color scale
                cmax=cmax,  # Global maximum color scale
                colorbar=attr(
                    title=attr(text="log 10k_poly"),  # Explicitly set title text
                    nticks=5,  # Set the number of ticks
                    ticks="outside"  # Optional: Ticks outside for visibility
                )
            )
        )

    else
        # Create subplots layout
        layout = Layout(
            title=String(plot_title),
            scene=attr(
                xaxis_title="log10(k_cap)",
                yaxis_title="log10(k_del)",
                zaxis_title="log10(r_cap)"
            ),
            colorway=["#636EFA", "#EF553B", "#00CC96"],
            coloraxis=attr(
                colorscale="Viridis",  # Set a global color scale
                cmin=cmin,  # Global minimum color scale
                cmax=cmax,  # Global maximum color scale
                colorbar=attr(
                    title=attr(text="k_poly"),  # Explicitly set title text
                    nticks=5,  # Set the number of ticks
                    ticks="outside"  # Optional: Ticks outside for visibility
                )
            )
        )

    end

    
    # Create a subplot
    p = PlotlyJS.Plot()

    # Set layout explicitly
    relayout!(p, layout)

    # Loop through r_cap slices
    for slice_r_cap in slice_r_caps
        # Update rcap_grid for the current slice
        rcap_grid .= slice_r_cap

        # Compute interpolated k_poly values for the current slice
        kpoly_vals = [interp_func(kcap_grid[i, j], kdel_grid[i, j], slice_r_cap) 
                      for i in 1:size(kcap_grid,1), j in 1:size(kcap_grid,2)]

        if occursin("ratio", String(plot_title))
            kpoly_vals = log10.(kpoly_vals)
        end
        # Create surface trace with color scale
        trace = PlotlyJS.surface(
            x=log10.(kcap_grid),
            y=log10.(kdel_grid),
            z=log10.(rcap_grid),
            surfacecolor=kpoly_vals,  # Set color based on k_poly values
            coloraxis="coloraxis"  # Use the global coloraxis for consistent scaling
        )

        # Add the trace to the plot
        add_trace!(p, trace)
    end

    display(p)

    # Generate rotating frames
    for i in 1:360  # Rotate 360 degrees
        # Adjust the camera position for a full rotation around the plot's center
        camera = attr(
            eye=attr(
                x=2 * cos(i * π / 180),  # Rotate around the x-axis
                y=2 * sin(i * π / 180),  # Rotate around the y-axis
                z=2 * sin(i * π / 180)   # Varying z to allow viewing from above and below
            )
        )

        # Apply rotation by updating camera
        relayout!(p, scene=attr(camera=camera))

        # Save the current frame as an image in the gif_path directory
        filename = "$gif_path/frame_$i.png"
        PlotlyJS.savefig(p, filename)
    end

    # Create a GIF from the saved frames using ImageMagick (run the shell command from Julia)
    gif_output_path = "$gif_path/output.gif"

    return "GIF created at: $gif_output_path"
end
