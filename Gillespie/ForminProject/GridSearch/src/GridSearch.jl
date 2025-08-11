using DataFrames
using JLD2, BenchmarkTools

function gridSearch(paramsfname::String, index1::Int, index2::Int ,polymercfname::String,saveloc::String,)
    println("Inside gridSearch")
    flush(stdout)
                         
    construct_names = ["PA", "PB", "PC", "PD", "FH1", "PAPD", "PBPD", "PCPD", 
                           "PA15", "PA15_16", "FH115", "FH115_16", "PA13", "PA13_14", 
                           "PA15PD", "PA15PD_16"]
        
    construct_PRM_locs = [[104], [63], [42], [25], [25, 42, 63, 104], [25, 104], [25, 63], [25, 42],
                              [104], [104], [25, 42, 63, 104], [25, 42, 63, 104], [104], [104], [25, 104], [25, 104]]
        
    construct_PRM_sizes = [[12], [14], [7], [5], [5, 7, 14, 12], [5, 12], [5, 14], [5, 7],
                               [15], [16], [5, 7, 14, 15], [5, 7, 14, 16], [13], [14], [5, 15], [5, 16]]
        
    # Constants
    c_PA = 0.88
    G = 0.5
    r_del = 0.0  # Considering release instant
    k_rel = 1e10  # Large value for instant release
    r_cap_exp = 0.86103
    
    # Choose which probability density to use
    prname = "Prvec0"
    
    # read in file
    data = readdlm(paramsfname, ',', String)  # Read file as a matrix
    if index2>size(data)[1]
        index2= size(data)[1]
    end
    data = data[index1:index2, :]  # Extract specified range

    df = DataFrame([name => Vector{Float64}[] for name in construct_names])
    

    println("gridSearch setup complete, entering loop")
    flush(stdout)
    for i in 1:size(data)[1]
        #display(i)
        @info "starting iteration $i"
        println("starting iteration $i")
        flush(stdout)

        k_cap=parse(Float64, data[i,1])
        k_del=parse(Float64, data[i,2])
        r_cap=parse(Float64, data[i,3])

        savfname="test"

        outfname, kpolys = @time GridSearch.makeTM(saveloc, construct_names, construct_PRM_locs, construct_PRM_sizes, 
                                            c_PA, G, k_cap, k_del, r_cap, r_del, k_rel, r_cap_exp, 
                                            prname, polymercfname, savfname, false, true)
        @info "completed Gillespie for $i"
        println("finished running makeTM for iteration $i")
        flush(stdout)

        push!(df,kpolys)
        println("added kpoly to dataframe for iteraition $i")
        flush(stdout)

        mv(joinpath(outfname,"kpolys.txt"),joinpath(saveloc,"kpolys_$(i)_$(k_cap)_$(k_del)_$(r_cap).txt"))
        println("moved kpolys.txt for iteration $i")
        flush(stdout)
        #rm(outfname, recursive=true)
    end
    @info "all gillespie complete"
    println("all gillespie complete")
    flush(stdout)

    insertcols!(df,1, "k_cap" => data[:,1], "k_del" => data[:,2], "r_cap" => data[:,3])
    @info "final DataFrame generated"
    println("final DataFrame generated")
    flush(stdout)
    
    @time jldsave(joinpath(saveloc, "gridsearch.jld2"); df)
    @info "final JLD file saved"
    println("final JLD file saved")
    flush(stdout)
end