#!/usr/bin/env julia

"""
analyze_single.jl

Comprehensive analysis tool for polymer-c simulation output.
Generates multiple plots for all site-dependent variables with multi-filament support.

Usage:
    julia analyze_single.jl <input_file> <output_prefix>
    
Example:
    julia analyze_single.jl ../local_experiments/250817/quick_test_output.txt ../local_experiments/250817/analysis

Output:
    Multiple PDF files with prefix:
    - {prefix}_POcclude_NumSites.pdf (legacy compatibility)
    - {prefix}_POcclude_vs_position.pdf
    - {prefix}_Prvec0_vs_position.pdf
    - ... (one for each site-dependent variable)
"""

using DelimitedFiles
using CairoMakie
using Statistics

# Import the generic utilities module
include("PolymerAnalysis.jl")
using .PolymerAnalysis

# ============================================================================
# DOMAIN-SPECIFIC ANALYSIS FUNCTIONS
# ============================================================================

"""Parse simulation output with domain-specific legacy format extraction."""
function parse_simulation_output(filename::String)
    # Use generic parsing from module
    data = PolymerAnalysis.parse_simulation_output(filename)
    
    # Extract domain-specific legacy format for POcclude_NumSites
    positions, probabilities = extract_legacy_format(data, "POcclude_NumSites", filename)
    
    return positions, probabilities, data
end

# ============================================================================
# DOMAIN-SPECIFIC PARAMETER MAPPING
# ============================================================================

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


# ============================================================================
# PLOTTING FUNCTIONS
# ============================================================================

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
    
    site_arrays = PolymerAnalysis.get_per_site_arrays(data, variable_name)
    
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
    # println("Plot saved to: $output_file")
    
    return fig
end

# Domain-specific plot configuration

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
            output_file = PolymerAnalysis.generate_plot_filename(output_prefix, var_name)
            
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

# ============================================================================
# MAIN ANALYSIS FUNCTION
# ============================================================================

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
        site_vars = PolymerAnalysis.get_site_dependent_variables(data)
        println("\nSite-dependent variables found: $(length(site_vars))")
        # for var in sort(site_vars)
        #     println("  - $var")
        # end
        
        # Display file summary
        # println("\nGenerated files:")
        # println("  - $(basename(legacy_output_plot)) (legacy POcclude_NumSites plot)")
        # for plot_file in created_plots
        #     println("  - $(basename(plot_file))")
        # end
        
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

    inputfile = "../local_experiments/250817/quick_test_output.txt"
    outputprefix = "../local_experiments/250817/analysis"

    main(inputfile, outputprefix)
else
    error("Usage: julia script.jl inputfile outputprefix")
end