using DelimitedFiles

function getallratiodicts(dict::Dict{Symbol, Any}, input_file::String)
    out_dict=dict
    # Read the input .txt file with lines delimited by spaces
    lines = readlines(input_file)
    
    # Iterate over each line in the file
    for line in lines
        entries = split(line)  # Split the line into entries
        
        # Get key for the first entry 
        key1 = Symbol(string(entries[1]))  # Convert the first entry to a Symbol

        # initialize array to hold the rest of the keys
        keys = Vector{Symbol}()  # Initialize an empty array to hold the keys
        
        for entry in entries[2:end]  # Exclude the first entry
            newkey = Symbol(string(entry))  # Convert the entry to a Symbol
            push!(keys, newkey)  # Append the new key to the array
        end
        
        
        # Store the result in the dictionary with the first entry as the key
        out_dict=ForminProject.makeratiointerpolations(out_dict,key1,keys)

    end
    
    return out_dict
end