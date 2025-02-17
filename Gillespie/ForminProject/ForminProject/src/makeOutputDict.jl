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
        subfile_path = dirname(subfiles[1]) * "/"
        out_struct = getOutputControl(basename(subfiles[1]), input_file_path=subfile_path)

        outDict[boundPRMs]=out_struct
    end

    return outDict
end
