function makeOutputDict(folder::String)

    files = readdir(folder, join=true) |> filter(f -> occursin(r"run\.", basename(f)))

    outDict=Dict{Vector{Vector{Int}},Dict{String, Any}}()

    for file in files
        spfile=split(file,"occupied")
        boundPRMs=string(spfile[2])
        boundPRMs=parse_numbers(boundPRMs)

        subfiles = readdir(file, join=true) |> filter(f -> startswith(basename(f), "output_") && endswith(f, ".txt"))
        if length(subfiles) > 1
            error("Multiple output files found for $file")
        end
        if length(subfiles) < 1
            livefiles= readdir(file, join=true) |> filter(f -> startswith(basename(f), "live_output_") && endswith(f, ".txt"))
            if length(livefiles) > 1
                error("Multiple live output files found for $file")
            end
            if length(livefiles) < 1
                error("No output files found for $file")
            end
            subfiles=livefiles
        end
        subfile_path = dirname(subfiles[1]) * "/"
        out_struct = getOutputControl(basename(subfiles[1]), input_file_path=subfile_path)

        outDict[boundPRMs]=out_struct
    end

    return outDict
end
