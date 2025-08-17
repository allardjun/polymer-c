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

function parse_simulation_output(filename::String)
    """Parse simulation output file and extract POcclude_NumSites data."""
    
    if !isfile(filename)
        error("Output file not found: $filename")
    end
    
    # Read all lines from the file
    lines = readlines(filename)
    
    # Initialize arrays to store data
    positions = Int[]
    probabilities = Float64[]
    
    # Parse POcclude_NumSites lines
    for line in lines
        if startswith(line, "POcclude_NumSites[i]")
            # Format: "POcclude_NumSites[i] <position> <probability>"
            parts = split(line)
            if length(parts) >= 3
                position = parse(Int, parts[2])
                probability = parse(Float64, parts[3])
                push!(positions, position)
                push!(probabilities, probability)
            end
        end
    end
    
    if isempty(positions)
        error("No POcclude_NumSites data found in file: $filename")
    end
    
    return positions, probabilities
end

function extract_simulation_parameters(filename::String)
    """Extract simulation parameters from the output file."""
    
    lines = readlines(filename)
    params = Dict{String, Any}()
    
    for line in lines
        # Extract key parameters
        if startswith(line, "nt ")
            params["NTMAX"] = parse(Int, split(line)[2])
        elseif startswith(line, "NFil ")
            params["n_filaments"] = parse(Int, split(line)[2])
        elseif startswith(line, "irLigand ")
            params["irLigand"] = parse(Float64, split(line)[2])
        elseif startswith(line, "brLigand ")
            params["brLigand"] = parse(Float64, split(line)[2])
        elseif startswith(line, "Force ")
            params["Force"] = parse(Float64, split(line)[2])
        elseif startswith(line, "kdimer ")
            params["kdimer"] = parse(Float64, split(line)[2])
        end
    end
    
    return params
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

function analyze_single_run(input_file::String, output_plot::String = "")
    """Main analysis function."""
    
    println("Analyzing simulation output: $input_file")
    
    # Generate output filename if not provided
    if isempty(output_plot)
        base_dir = dirname(input_file)
        output_plot = joinpath(base_dir, "occlusion_probability_plot.png")
    end
    
    try
        # Parse the data
        positions, probabilities = parse_simulation_output(input_file)
        params = extract_simulation_parameters(input_file)
        
        println("Found $(length(positions)) data points")
        println("Position range: $(minimum(positions)) to $(maximum(positions))")
        println("Probability range: $(minimum(probabilities)) to $(maximum(probabilities))")
        
        # Create and save plot
        fig = plot_occlusion_probability(positions, probabilities, params, output_plot)
        
        # Display basic statistics
        println("\nBasic Statistics:")
        println("Mean occlusion probability: $(mean(probabilities))")
        println("Max occlusion probability: $(maximum(probabilities))")
        println("Min occlusion probability: $(minimum(probabilities))")
        
        return fig
        
    catch e
        println("Error analyzing file: $e")
        rethrow(e)
    end
end

# Default file paths for REPL use - modify these as needed
const DEFAULT_INPUT_FILE = "../local_experiments/250816/quick_test_output.txt"
const DEFAULT_OUTPUT_FILE = "../local_experiments/250816/occlusion_probability_plot.pdf"

# Main execution
function main()
    if length(ARGS) < 1
        println("Usage: julia analyze_single.jl <path_to_output_file> [output_plot_file]")
        println("Example: julia analyze_single.jl ../local_experiments/250816/quick_test_output.txt")
        exit(1)
    end
    
    input_file = ARGS[1]
    output_plot = length(ARGS) >= 2 ? ARGS[2] : ""
    
    analyze_single_run(input_file, output_plot)
end

# Convenience function for REPL use with default file
function analyze_default()
    """Analyze using the default input file specified above."""
    analyze_single_run(DEFAULT_INPUT_FILE, DEFAULT_OUTPUT_FILE)
end

# Run main if script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end