#!/usr/bin/env julia

"""
analyze_single.jl

Analyzes single simulation output from polymer-c to plot occlusion probability
versus location on the polymer chain.

Usage:
    julia analyze_single.jl <path_to_output_file>
    
Example:
    julia analyze_single.jl ../local_experiments/250816/quick_test_output.txt
"""

using DelimitedFiles
using CairoMakie
using Statistics

# Data structures for organizing simulation output
struct SimulationData
    parameters::Dict{String, Any}
    global_data::Dict{String, Vector{Float64}}
    per_filament_data::Dict{String, Vector{Float64}}
    per_site_data::Dict{String, Dict{Int, Dict{Int, Float64}}}
    filament_lengths::Vector{Int}
    n_filaments::Int
end

function SimulationData()
    return SimulationData(
        Dict{String, Any}(),
        Dict{String, Vector{Float64}}(),
        Dict{String, Vector{Float64}}(),
        Dict{String, Dict{Int, Dict{Int, Float64}}}(),
        Int[],
        0
    )
end

function parse_simulation_output(filename::String)
    """Parse complete simulation output file into structured data."""
    
    if !isfile(filename)
        error("Output file not found: $filename")
    end
    
    lines = readlines(filename)
    data = SimulationData()
    
    # Parse all data types
    for line in lines
        parse_line!(data, line)
    end
    
    # Extract legacy format for backward compatibility
    positions = Int[]
    probabilities = Float64[]
    
    if haskey(data.global_data, "POcclude_NumSites")
        positions = collect(0:(length(data.global_data["POcclude_NumSites"])-1))
        probabilities = data.global_data["POcclude_NumSites"]
    end
    
    if isempty(positions)
        error("No POcclude_NumSites data found in file: $filename")
    end
    
    return positions, probabilities, data
end

function parse_line!(data::SimulationData, line::String)
    """Parse a single line and add to appropriate data structure."""
    
    parts = split(strip(line))
    if isempty(parts)
        return
    end
    
    # Parse simulation parameters
    if length(parts) == 2 && !(occursin("[", parts[1]))
        key = parts[1]
        try
            value = parse(Float64, parts[2])
            data.parameters[key] = value
            
            # Track number of filaments
            if key == "NFil"
                data.n_filaments = Int(value)
            end
        catch
            data.parameters[key] = parts[2]
        end
        return
    end
    
    # Parse indexed data
    if occursin("[", parts[1])
        parse_indexed_data!(data, parts)
    end
end

function parse_indexed_data!(data::SimulationData, parts::Vector{SubString{String}})
    """Parse indexed data (global arrays, per-filament, per-site)."""
    
    variable_part = parts[1]
    
    # Global data: Variable[i] index value
    if occursin("[i]", variable_part)
        var_name = split(variable_part, "[i]")[1]
        if length(parts) >= 3
            index = parse(Int, parts[2])
            value = parse(Float64, parts[3])
            
            if !haskey(data.global_data, var_name)
                data.global_data[var_name] = Float64[]
            end
            
            # Ensure array is large enough
            while length(data.global_data[var_name]) <= index
                push!(data.global_data[var_name], 0.0)
            end
            
            data.global_data[var_name][index + 1] = value
        end
    
    # Per-filament data: Variable[nf] filament_index value  
    elseif occursin("[nf]", variable_part) && !occursin("[iy]", variable_part)
        var_name = split(variable_part, "[nf]")[1]
        if length(parts) >= 3
            nf = parse(Int, parts[2])
            value = parse(Float64, parts[3])
            
            if !haskey(data.per_filament_data, var_name)
                data.per_filament_data[var_name] = Float64[]
            end
            
            # Ensure array is large enough
            while length(data.per_filament_data[var_name]) <= nf
                push!(data.per_filament_data[var_name], 0.0)
            end
            
            data.per_filament_data[var_name][nf + 1] = value
            
            # Track filament lengths
            if var_name == "N"
                while length(data.filament_lengths) <= nf
                    push!(data.filament_lengths, 0)
                end
                data.filament_lengths[nf + 1] = Int(value)
            end
        end
    
    # Per-site data: Variable[nf][iy] filament_index site_index value
    elseif occursin("[nf][iy]", variable_part)
        var_name = split(variable_part, "[nf][iy]")[1]
        if length(parts) >= 4
            nf = parse(Int, parts[2])
            iy = parse(Int, parts[3])
            value = parse(Float64, parts[4])
            
            if !haskey(data.per_site_data, var_name)
                data.per_site_data[var_name] = Dict{Int, Dict{Int, Float64}}()
            end
            
            if !haskey(data.per_site_data[var_name], nf)
                data.per_site_data[var_name][nf] = Dict{Int, Float64}()
            end
            
            data.per_site_data[var_name][nf][iy] = value
        end
    end
end

function extract_simulation_parameters(data::SimulationData)
    """Extract simulation parameters from parsed data (legacy compatibility)."""
    
    params = Dict{String, Any}()
    
    # Map new parameter names to legacy names
    param_mapping = Dict(
        "nt" => "NTMAX",
        "NFil" => "n_filaments",
        "irLigand" => "irLigand",
        "brLigand" => "brLigand", 
        "Force" => "Force",
        "kdimer" => "kdimer"
    )
    
    for (old_key, new_key) in param_mapping
        if haskey(data.parameters, old_key)
            params[new_key] = data.parameters[old_key]
        end
    end
    
    return params
end

function get_per_site_arrays(data::SimulationData, variable_name::String)
    """Extract per-site data as arrays for plotting."""
    
    if !haskey(data.per_site_data, variable_name)
        return Dict{Int, Tuple{Vector{Int}, Vector{Float64}}}()
    end
    
    result = Dict{Int, Tuple{Vector{Int}, Vector{Float64}}}()
    
    for (nf, site_data) in data.per_site_data[variable_name]
        if !isempty(site_data)
            positions = sort(collect(keys(site_data)))
            values = [site_data[pos] for pos in positions]
            result[nf] = (positions, values)
        end
    end
    
    return result
end

function get_site_dependent_variables(data::SimulationData)
    """Get list of all site-dependent variables in the data."""
    return collect(keys(data.per_site_data))
end

function plot_occlusion_probability(positions, probabilities, params, output_file)
    """Create a plot of occlusion probability vs chain position."""
    
    # Create figure
    fig = Figure(size = (800, 600))
    ax = Axis(fig[1, 1], 
        xlabel = "Position on Chain",
        ylabel = "Occlusion Probability",
        title = "Occlusion Probability vs Chain Position"
    )
    
    # Plot the data
    lines!(ax, positions, probabilities, 
           color = :blue, linewidth = 2, label = "P(Occlusion)")
    scatter!(ax, positions, probabilities, 
             color = :red, markersize = 4)
    
    # Add parameter information as text
    param_text = "Parameters:\n"
    for (key, value) in params
        param_text *= "$key: $value\n"
    end
    
    text!(ax, 0.02, 0.98, text = param_text, 
          space = :relative, align = (:left, :top), 
          fontsize = 10, color = :black)
    
    # Show legend
    axislegend(ax, position = :rt)
    
    # Save the plot
    save(output_file, fig)
    println("Plot saved to: $output_file")
    
    return fig
end

function plot_per_site_variable(data::SimulationData, variable_name::String, output_file::String; 
                                ylabel::String="", title::String="", 
                                show_scatter::Bool=true, colors=[:blue, :red, :green, :orange, :purple])
    """Create a plot of any per-site variable with multiple filaments."""
    
    site_arrays = get_per_site_arrays(data, variable_name)
    
    if isempty(site_arrays)
        println("Warning: No data found for variable $variable_name")
        return nothing
    end
    
    # Create figure
    fig = Figure(size = (800, 600))
    ax = Axis(fig[1, 1], 
        xlabel = "Site Position",
        ylabel = isempty(ylabel) ? variable_name : ylabel,
        title = isempty(title) ? "$variable_name vs Site Position" : title
    )
    
    # Plot data for each filament
    for (i, (nf, (positions, values))) in enumerate(sort(collect(site_arrays)))
        color = colors[mod1(i, length(colors))]
        label = "Filament $nf"
        
        lines!(ax, positions, values, 
               color = color, linewidth = 2, label = label)
        
        if show_scatter
            scatter!(ax, positions, values, 
                     color = color, markersize = 3)
        end
    end
    
    # Add parameter information
    params = extract_simulation_parameters(data)
    param_text = "Parameters:\n"
    for (key, value) in params
        param_text *= "$key: $value\n"
    end
    
    text!(ax, 0.02, 0.98, text = param_text, 
          space = :relative, align = (:left, :top), 
          fontsize = 8, color = :black)
    
    # Show legend if multiple filaments
    if length(site_arrays) > 1
        axislegend(ax, position = :rt)
    end
    
    # Save the plot
    save(output_file, fig)
    println("Plot saved to: $output_file")
    
    return fig
end

function create_comprehensive_plots(data::SimulationData, output_prefix::String)
    """Create plots for all important site-dependent variables using prefix-based naming."""
    
    # Key variables to plot with their display info
    plot_configs = [
        ("POcclude", "Site Occlusion Probability", "P(Occlusion)"),
        ("1-POcclude", "Site Availability Probability", "P(Available)"),
        ("PMembraneOcclude", "Membrane Occlusion Probability", "P(Membrane Occlusion)"),
        ("Prvec0", "Polymer Vector Probability", "P(r⃗=0)"),
        ("Prvec0_up", "Polymer Vector Probability (Up)", "P(r⃗=0, up)"),
        ("Prvec0_halfup", "Polymer Vector Probability (Half-Up)", "P(r⃗=0, half-up)"),
        ("Prvec0_rad", "Radial Polymer Vector Probability", "P(r⃗, radial)"),
        ("rMiSiteBar", "Mean Distance from Interaction Site", "⟨r_M⟩"),
        ("rM2iSiteBar", "Second Moment Distance from Site", "⟨r_M²⟩"),
        ("reeiSiteBar", "Mean End-to-End Distance from Site", "⟨r_ee⟩"),
        ("ree2iSiteBar", "Second Moment End-to-End Distance", "⟨r_ee²⟩")
    ]
    
    created_plots = String[]
    
    for (var_name, title, ylabel) in plot_configs
        if haskey(data.per_site_data, var_name)
            output_file = output_prefix * "_$(var_name)_vs_position.pdf"
            
            fig = plot_per_site_variable(data, var_name, output_file; 
                                       ylabel=ylabel, title=title)
            
            if fig !== nothing
                push!(created_plots, output_file)
            end
        else
            println("Variable $var_name not found in data")
        end
    end
    
    return created_plots
end

function analyze_single_run(input_file::String, output_prefix::String = "")
    """Main analysis function."""
    
    println("Analyzing simulation output: $input_file")
    
    # Generate output prefix if not provided
    if isempty(output_prefix)
        base_dir = dirname(input_file)
        base_name = splitext(basename(input_file))[1]  # Remove extension
        output_prefix = joinpath(base_dir, base_name)
    end
    
    # Legacy plot filename for backward compatibility
    legacy_output_plot = output_prefix * "_POcclude_NumSites.pdf"
    
    try
        # Parse the data
        positions, probabilities, data = parse_simulation_output(input_file)
        params = extract_simulation_parameters(data)
        
        println("Found $(length(positions)) data points")
        println("Position range: $(minimum(positions)) to $(maximum(positions))")
        println("Probability range: $(minimum(probabilities)) to $(maximum(probabilities))")
        
        # Create legacy plot for backward compatibility
        fig = plot_occlusion_probability(positions, probabilities, params, legacy_output_plot)
        
        # Create comprehensive plots for all site-dependent variables
        println("\nCreating comprehensive analysis plots...")
        
        created_plots = create_comprehensive_plots(data, output_prefix)
        println("Created $(length(created_plots)) additional plots")
        
        # Display analysis summary
        println("\n=== Analysis Summary ===")
        println("Number of filaments: $(data.n_filaments)")
        if !isempty(data.filament_lengths)
            println("Filament lengths: $(data.filament_lengths)")
        end
        
        # Display basic statistics
        println("\nBasic POcclude_NumSites Statistics:")
        println("Mean occlusion probability: $(mean(probabilities))")
        println("Max occlusion probability: $(maximum(probabilities))")
        println("Min occlusion probability: $(minimum(probabilities))")
        
        # Display per-site variable summary
        site_vars = get_site_dependent_variables(data)
        println("\nSite-dependent variables found: $(length(site_vars))")
        for var in sort(site_vars)
            println("  - $var")
        end
        
        # Display file summary
        println("\nGenerated files:")
        println("  - $(basename(legacy_output_plot)) (legacy POcclude_NumSites plot)")
        for plot_file in created_plots
            println("  - $(basename(plot_file))")
        end
        
        return fig
        
    catch e
        println("Error analyzing file: $e")
        rethrow(e)
    end
end

# Default file paths for REPL use - modify these as needed
# const DEFAULT_INPUT_FILE = "../local_experiments/250816/quick_test_output.txt"
# const DEFAULT_OUTPUT_FILE = "../local_experiments/250816/occlusion_probability_plot.pdf"

# Main execution
function main(input_file, output_prefix)
    # if length(ARGS) < 1
    #     println("Usage: julia analyze_single.jl <path_to_output_file> [output_prefix]")
    #     println("Example: julia analyze_single.jl ../local_experiments/250816/quick_test_output.txt ../local_experiments/250816/analysis")
    #     exit(1)
    # end
    
    # input_file = ARGS[1]
    # output_prefix = length(ARGS) >= 2 ? ARGS[2] : ""
    
    analyze_single_run(input_file, output_prefix)
end

# # Convenience function for REPL use with default file
# function analyze_default()
#     """Analyze using the default input file specified above."""
#     analyze_single_run(DEFAULT_INPUT_FILE, DEFAULT_OUTPUT_FILE)
# end

# # Run main if script is executed directly
# if abspath(PROGRAM_FILE) == @__FILE__
#     main()
# end

if length(ARGS) >= 2
    # Use command-line args
    inputfile  = ARGS[1]
    outputprefix = ARGS[2]
    main(inputfile, outputprefix)
elseif isinteractive()
    # Running in REPL (e.g. VSCode) → use defaults
    # inputfile  = "data/default_input.txt"
    # outputprefix = "results/default_analysis"

    inputfile = "../local_experiments/250816_2/quick_test_output.txt"
    outputprefix = "../local_experiments/250816_2/analysis"

    main(inputfile, outputprefix)
else
    error("Usage: julia script.jl inputfile outputprefix")
end