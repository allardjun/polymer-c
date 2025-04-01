using PlotlyJS

function plot_interpolation_scaledslice(interp_func, kcap_range, kdel_range, r_cap_slices, plot_title, gif_path)
    # Create a folder inside the gif_path to save the frames and GIF
    mkpath(gif_path)
    for r_cap in r_cap_slices
        plot_title=String(plot_title)
        # Compute x/z and y/z
        x_vals = 10 .^ range(log10(kcap_range[1]), log10(kcap_range[2]), length=1000)
        x_z = [x / r_cap for x in x_vals]
        y_vals = 10 .^ range(log10(kdel_range[1]), log10(kdel_range[2]), length=1000)
        y_z = [y / r_cap for y in y_vals]
        x_z_log = log10.(x_z)
        y_z_log = log10.(y_z)

        
        # for x in x_vals, y in y_vals
        #     result = interp_func(x, y, r_cap)[1]
        #     # check type of result
        #     if typeof(result) != Float64
        #         println("$(typeof(result)) detected at x=$x, y=$y, r_cap=$r_cap: ", result)
        #     end
        #     # if isnan(result) || isinf(result)
        #     #     println("$plot_title NaN/Inf detected at x=$x, y=$y, r_cap=$r_cap: ", result)
        #     # end
        # end

        # Compute function values for the heatmap
        heatmap_vals = [interp_func(x, y, r_cap)[1] for y in y_vals, x in x_vals]

        heatmap_vals[heatmap_vals .< 0] .= 1e-10  # use 1e-10 if val is negative

        # Determine if log scaling for the heatmap is needed
        log_scale = occursin("ratio", plot_title)

        if log_scale
            heatmap_vals = log10.((heatmap_vals))
            colorbar_title = "log10 k_poly"
            colorway=["#636EFA", "#EF553B", "#00CC96"]

            # Center color scale at 0 with symmetric limits
            nonan=heatmap_vals[.!isnan.(heatmap_vals)]
            noinf=nonan[.!isinf.(nonan)]
            max_val = maximum(abs, noinf)
            color_limits = (-max_val, max_val)
            color_limits = (-0.5, 0.5)
            colorscale = "Picnic"
        else
            colorbar_title = "k_poly"
            colorway=["#636EFA", "#EF553B", "#00CC96"]
            colorscale = "Viridis"
            color_limits = (minimum(heatmap_vals), maximum(heatmap_vals))
        end

        # Create the heatmap plot
        plt = Plot(
            PlotlyJS.heatmap(x=x_z_log, y=y_z_log, z=heatmap_vals, colorscale=colorscale, colorbar_title=colorbar_title, zmin=color_limits[1], zmax=color_limits[2]),
            Layout(
                xaxis_title="log10(k_cap/r_cap)",
                yaxis_title="log10(k_del/r_cap)",
                title="$(plot_title) (r_cap = $r_cap)"
            )
        )

        display(plt)
        filename = "$gif_path/$(plot_title)_$r_cap.png"
        PlotlyJS.savefig(plt, filename)
    end
end

