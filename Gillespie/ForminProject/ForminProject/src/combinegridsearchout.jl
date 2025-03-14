using JLD2
using DataFrames

function combinegridsearchout(fname::String)
    files = readdir(fname, join=true) 
    firstfile=true
    for file in files
        if isdir(file)
            if !isfile(joinpath(file, "gridsearch.jld2"))
                println("No gridsearch.jld2 file in $file")
                continue
            end
            gridsearchout = load(joinpath(file, "gridsearch.jld2"),"df")
            if firstfile
                global outdf=gridsearchout
                firstfile=false
            else
                outdf=vcat(outdf,gridsearchout)
            end
        end
    end
    jldsave(joinpath(fname, "combinedgridsearch.jld2"); 
                outdf)
    return outdf
end