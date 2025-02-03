using DelimitedFiles

function process_kpoly_dict(input_file::String)
    # Read the lines from the file
    lines = readlines(input_file)
    
    # Initialize an empty dictionary to store the result
    result_dict = Dict{String, Vector{Float64}}()
    
    # Iterate over each line in the file
    for line in lines
        # Split the line into entries (assuming space-delimited)
        entries = split(line)
        
        # Check if the line has at least three entries
        if length(entries) >= 3
            # Get the first entry as the key
            key = entries[1]
            
            # Get the second and third entries as numbers (convert them to Float64)
            value1 = parse(Float64, entries[2])
            value2 = parse(Float64, entries[3])
            
            # Store the key and the array of values in the dictionary
            result_dict[key] = [value1, value2]
        else
            # Handle the case where the line doesn't have enough entries
            println("Skipping line due to insufficient entries: $line")
        end
    end
    
    return result_dict
end