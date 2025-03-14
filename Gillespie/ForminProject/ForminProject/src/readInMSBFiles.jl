using FileIO
using Glob

function readInMSBFiles(folder::String, states::Matrix{Int}, PRM_locs::Vector{Int})
    # Initialize variables
    nStates = size(states, 1)
    nPRMs = length(PRM_locs)
    occtexts = Vector{String}(undef, nStates)

    # Generate occupancy text for each state
    for i in 1:nStates
        occtext = ""
        for j in 1:nPRMs
            if states[i, j] == 1 || states[i, j] == 2 # Delivered or bound is considered bound
                occtext *= string(PRM_locs[j], "_")
            end
        end
        if isempty(occtext)
            occtext = "-1_"
        end

        nobound = true
        for j in 1:nPRMs
            if states[i, j + nPRMs] == 1 || states[i, j + nPRMs] == 2 # Delivered or bound is considered bound
                nobound = false
                occtext *= "_" * string(PRM_locs[j])
            end
        end
        if nobound
            occtext *= "_-1"
        end

        occtexts[i] = occtext
    end

    # Get list of files in the folder
    files = readdir(folder, join=true) |> filter(f -> occursin(r"run\.", basename(f)))

    # Initialize output cell
    output_cell = Vector{Union{Nothing, Dict}}(undef, nStates)

    # Process files
    Threads.@threads for file in files
    #for file in files
        parts = split(basename(file), "occupied")
        if length(parts) < 2
            continue
        end
        occtext = parts[2]

        # Match state
        match_state = map(x -> x == occtext, occtexts)

        if any(match_state)
            subfolder = file
            subfiles = readdir(subfolder, join=true) |> filter(f -> startswith(basename(f), "output_") && endswith(f, ".txt"))
            if length(subfiles) > 1
                error("Multiple output files found for $file")
            end
            if length(subfiles) < 1
                livefiles= readdir(subfolder, join=true) |> filter(f -> startswith(basename(f), "live_output_") && endswith(f, ".txt"))
                if length(livefiles) > 1
                    error("Multiple live output files found for $file")
                end
                if length(livefiles) < 1
                    error("No output files found for $file")
                end
                input_file=livefiles[1]
                lines = readlines(input_file)
    
                # Find the last occurrence of "nt {number}"
                last_index = findlast(line -> occursin(r"^nt \d+", line), lines)
                
                if last_index === nothing
                    error("No matching 'nt {number}' line found in the file.")
                end
                
                # Write from the last occurrence to the end of the file
                writedlm(joinpath(file,"lastliveoutput.txt"), lines[last_index:end], "\n")
                subfiles = readdir(subfolder, join=true) |> filter(f -> startswith(basename(f), "lastliveoutput") && endswith(f, ".txt"))
                subfile_path = dirname(subfiles[1]) * "/"
                out_struct = getOutputControl(basename(subfiles[1]), input_file_path=subfile_path)
            else
                subfile_path = dirname(subfiles[1]) * "/"
                out_struct = getOutputControl(basename(subfiles[1]), input_file_path=subfile_path)
            end
            
            for k in eachindex(match_state)
                if match_state[k]
                    output_cell[k] = out_struct
                end
            end
        end
    end

    # Convert output_cell to a matrix
    output_mat = filter(x -> x !== nothing && !isempty(x), output_cell)

    return output_mat, output_cell
end
