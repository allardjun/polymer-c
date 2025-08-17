"""
PolymerAnalysis.jl

Generic module for polymer simulation data analysis.
Provides reusable data structures, parsing utilities, and plotting helpers
without any domain-specific knowledge of variable names or meanings.
"""

module PolymerAnalysis

using CairoMakie
using Statistics

export SimulationData, 
       parse_simulation_output, validate_input_file, extract_legacy_format,
       parse_line!, parse_indexed_data!, 
       parse_global_data!, parse_per_filament_data!, parse_per_site_data!,
       ensure_global_array_exists!, ensure_filament_array_exists!, 
       ensure_site_data_exists!, ensure_array_size!,
       get_per_site_arrays, get_site_dependent_variables,
       create_standard_plot, add_parameter_text!, save_plot_with_message,
       generate_plot_filename

# ============================================================================
# DATA STRUCTURES
# ============================================================================

"""
    SimulationData

Structured container for polymer simulation output data.
Organizes data by type: parameters, global arrays, per-filament, and per-site data.
"""
struct SimulationData
    parameters::Dict{String, Any}
    global_data::Dict{String, Vector{Float64}}
    per_filament_data::Dict{String, Vector{Float64}}
    per_site_data::Dict{String, Dict{Int, Dict{Int, Float64}}}
    filament_lengths::Vector{Int}
    n_filaments::Int
end

"""Create empty SimulationData with initialized containers."""
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

# ============================================================================
# DATA PARSING FUNCTIONS
# ============================================================================

"""Parse complete simulation output file into structured data."""
function parse_simulation_output(filename::String)
    validate_input_file(filename)
    
    lines = readlines(filename)
    data = SimulationData()
    
    # Parse all data types
    for line in lines
        parse_line!(data, line)
    end
    
    return data
end

"""Validate input file exists and is readable."""
function validate_input_file(filename::String)
    if !isfile(filename)
        error("Output file not found: $filename")
    end
end

"""Extract legacy format for a specific global variable."""
function extract_legacy_format(data::SimulationData, variable_name::String, filename::String)
    positions = Int[]
    values = Float64[]
    
    if haskey(data.global_data, variable_name)
        positions = collect(0:(length(data.global_data[variable_name])-1))
        values = data.global_data[variable_name]
    end
    
    if isempty(positions)
        error("No $variable_name data found in file: $filename")
    end
    
    return positions, values
end

"""Parse a single line and add to appropriate data structure."""
function parse_line!(data::SimulationData, line::String)
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
            
            # Track number of filaments if key suggests filament count
            if key == "NFil" || lowercase(key) == "nfilaments" || lowercase(key) == "n_filaments"
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

"""Parse indexed data (global arrays, per-filament, per-site)."""
function parse_indexed_data!(data::SimulationData, parts::Vector{SubString{String}})
    variable_part = parts[1]
    
    if occursin("[i]", variable_part)
        parse_global_data!(data, parts, variable_part)
    
    elseif occursin("[nf]", variable_part) && !occursin("[iy]", variable_part)
        parse_per_filament_data!(data, parts, variable_part)
    
    elseif occursin("[nf][iy]", variable_part)
        parse_per_site_data!(data, parts, variable_part)
    end
end

# Helper functions for parsing different data types
"""Parse global data: Variable[i] index value"""
function parse_global_data!(data::SimulationData, parts::Vector{SubString{String}}, variable_part::SubString{String})
    var_name = String(split(variable_part, "[i]")[1])
    if length(parts) >= 3
        index = parse(Int, parts[2])
        value = parse(Float64, parts[3])
        
        ensure_global_array_exists!(data, var_name)
        ensure_array_size!(data.global_data[var_name], index)
        
        data.global_data[var_name][index + 1] = value
    end
end

"""Parse per-filament data: Variable[nf] filament_index value"""
function parse_per_filament_data!(data::SimulationData, parts::Vector{SubString{String}}, variable_part::SubString{String})
    var_name = String(split(variable_part, "[nf]")[1])
    if length(parts) >= 3
        nf = parse(Int, parts[2])
        value = parse(Float64, parts[3])
        
        ensure_filament_array_exists!(data, var_name)
        ensure_array_size!(data.per_filament_data[var_name], nf)
        
        data.per_filament_data[var_name][nf + 1] = value
        
        # Track filament lengths for any variable that represents length
        if var_name == "N"
            ensure_array_size!(data.filament_lengths, nf)
            data.filament_lengths[nf + 1] = Int(value)
        end
    end
end

"""Parse per-site data: Variable[nf][iy] filament_index site_index value"""
function parse_per_site_data!(data::SimulationData, parts::Vector{SubString{String}}, variable_part::SubString{String})
    var_name = String(split(variable_part, "[nf][iy]")[1])
    if length(parts) >= 4
        nf = parse(Int, parts[2])
        iy = parse(Int, parts[3])
        value = parse(Float64, parts[4])
        
        ensure_site_data_exists!(data, var_name, nf)
        data.per_site_data[var_name][nf][iy] = value
    end
end

# Reusable utility functions for array management
"""Ensure global array exists for given variable name"""
function ensure_global_array_exists!(data::SimulationData, var_name::String)
    if !haskey(data.global_data, var_name)
        data.global_data[var_name] = Float64[]
    end
end

"""Ensure filament array exists for given variable name"""
function ensure_filament_array_exists!(data::SimulationData, var_name::String)
    if !haskey(data.per_filament_data, var_name)
        data.per_filament_data[var_name] = Float64[]
    end
end

"""Ensure site data structure exists for given variable and filament"""
function ensure_site_data_exists!(data::SimulationData, var_name::String, nf::Int)
    if !haskey(data.per_site_data, var_name)
        data.per_site_data[var_name] = Dict{Int, Dict{Int, Float64}}()
    end
    
    if !haskey(data.per_site_data[var_name], nf)
        data.per_site_data[var_name][nf] = Dict{Int, Float64}()
    end
end

"""Ensure array is large enough to accommodate given index"""
function ensure_array_size!(array::Vector{T}, index::Int) where T
    while length(array) <= index
        push!(array, zero(T))
    end
end

# ============================================================================
# DATA ACCESS FUNCTIONS
# ============================================================================

"""Extract per-site data as arrays for plotting."""
function get_per_site_arrays(data::SimulationData, variable_name::String)
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

"""Get list of all site-dependent variables in the data."""
function get_site_dependent_variables(data::SimulationData)
    return collect(keys(data.per_site_data))
end

# ============================================================================
# PLOTTING UTILITIES
# ============================================================================

"""Create standardized plot layout with common formatting"""
function create_standard_plot(xlabel::String, ylabel::String, title::String)
    fig = Figure(size = (800, 600))
    ax = Axis(fig[1, 1], 
        xlabel = xlabel,
        ylabel = ylabel,
        title = title
    )
    return fig, ax
end

"""Add parameter information text to plot"""
function add_parameter_text!(ax, params::Dict{String, Any})
    param_text = "Parameters:\n"
    for (key, value) in params
        param_text *= "$key: $value\n"
    end
    
    text!(ax, 0.02, 0.98, text = param_text, 
          space = :relative, align = (:left, :top), 
          fontsize = 8, color = :black)
end

"""Save plot with status message"""
function save_plot_with_message(fig, output_file::String)
    save(output_file, fig)
    println("Plot saved to: $output_file")
end

"""Generate standardized filename from prefix and variable name"""
function generate_plot_filename(prefix::String, variable_name::String)
    return prefix * "_$(variable_name)_vs_position.pdf"
end

end # module