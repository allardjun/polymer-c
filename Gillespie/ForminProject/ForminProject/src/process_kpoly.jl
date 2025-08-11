using Glob
using DelimitedFiles

function process_kpoly(folder::String, input_file::String)
    # Read the input .txt file with lines delimited by spaces
    lines = readlines(input_file)
    
    # Initialize the dictionary to store the results
    result_dict = Dict{String, Vector{Float64}}()
    
    # Iterate over each line in the file
    for line in lines
        entries = split(line)  # Split the line into entries
        
        # Initialize an array to hold the kpoly values for the line
        kpolys = Float64[]
        
        # Get kpoly for the first entry (A)
        first_entry = string(entries[1])  # Explicitly convert SubString to String
        first_kpoly = get_kpoly_for_subfolder(folder, first_entry)
        push!(kpolys, first_kpoly)
        
        # Calculate the sum of kpolys for all subsequent entries (B, C, D, ...)
        sum_kpoly = 0.0
        for entry in entries[2:end]  # Exclude the first entry
            entry_str = string(entry)  # Explicitly convert SubString to String
            sum_kpoly += get_kpoly_for_subfolder(folder, entry_str)
        end
        push!(kpolys, sum_kpoly)
        
        # Store the result in the dictionary with the first entry as the key
        result_dict[first_entry] = kpolys
    end
    
    return result_dict
end

# Function to get the kpoly value for a given subfolder entry
function get_kpoly_for_subfolder(folder::String, entry::String)
    # Construct the path to the subfolder
    subfolder_path = joinpath(folder, entry)
    
    # Find the TMout_ file in the subfolder
    files = glob("TMout_*.txt", subfolder_path)
    
    # If no files are found, throw an error
    if isempty(files)
        error("No TMout_ file found in subfolder $subfolder_path")
    end
    
    # Read the TMout_ file (assuming only one file starts with "TMout_")
    tmout_file = files[1]
    lines_tmout = readlines(tmout_file)
    
    # Find the line that starts with "Over Avg time storedKpoly "
    for line in lines_tmout
        if startswith(line, "Over Avg time storedKpoly ")
            # Extract the kpoly value from the line
            kpoly_value = parse(Float64, split(line)[end])  # The last value in the line
            return kpoly_value
        end
    end
    
    # If no matching line is found, throw an error
    error("Line starting with 'Over Avg time storedKpoly ' not found in $tmout_file")
end