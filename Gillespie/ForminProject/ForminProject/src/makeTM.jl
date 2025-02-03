using DelimitedFiles
using JLD2
using Dates

function makeTM(saveloc, construct_names, construct_PRM_locs, construct_PRM_sizes, c_PA, G, k_cap, k_del, r_cap, r_del, k_rel, r_cap_exp, prname, fname, savfname)
    savfname = string(savfname, "_", Dates.format(now(),"yyyy.mm.dd.HH.MM.SS"))
    mkdir(joinpath(saveloc, savfname,))

    for k in 1:length(construct_PRM_sizes)
        # Formin information
        PRM_locs = construct_PRM_locs[k]
        PRM_sizes = construct_PRM_sizes[k]

        states, numValidStates, transitionMatrix, isBound, isDelivered = generateTMtemplate(PRM_locs)

        output_mat, output_cell = readInMSBFiles(fname, states, PRM_locs)

        # Get relevant polymer stats
        pocc = getStateVals(output_mat, PRM_locs, "POcclude")
        prvec = getStateVals(output_mat, PRM_locs, prname)
        pocc_0 = getStateVals(output_mat, [1], "POcclude")

        PRM_sizes2 = vcat(PRM_sizes, PRM_sizes)

        for i in 1:numValidStates
            fromstate = states[i, :]
            for j in 1:numValidStates
                tostate = states[j, :]
                if sum(fromstate .!= tostate) == 1  # If only one state has changed
                    diffPRM = findall(fromstate .!= tostate)[1]
                    if fromstate[diffPRM] == 0  # PRM is unbound at first
                        if tostate[diffPRM] == 1  # Unbound → Bound
                            transitionMatrix[i, j] = k_cap * (1 - pocc[i, diffPRM]) * c_PA
                        end
                    elseif fromstate[diffPRM] == 1  # PRM is bound at first
                        if tostate[diffPRM] == 2  # Bound → Delivered
                            transitionMatrix[i, j] = k_del * (1 - pocc_0[i, ((diffPRM > length(PRM_locs)) + 1)]) *
                                                    G * (1.0e33 * (prvec[i, diffPRM]) / (27 * 6.022e23))
                            if (transitionMatrix[i, j]<0)
                                println("Negative transition rate: ", transitionMatrix[i, j])
                                println("pocc_0: ", pocc_0[i, ((diffPRM > length(PRM_locs)) + 1)])
                                println("((diffPRM > length(PRM_locs)) + 1): ", ((diffPRM > length(PRM_locs)) + 1))
                            end
                        elseif tostate[diffPRM] == 0  # Bound → Unbound
                            transitionMatrix[i, j] = r_cap * exp(-PRM_sizes2[diffPRM] * r_cap_exp)
                        end
                    elseif fromstate[diffPRM] == 2  # PRM is delivered at first
                        if tostate[diffPRM] == 1  # Delivered → Bound
                            transitionMatrix[i, j] = r_del
                        elseif tostate[diffPRM] == 0  # Delivered → Unbound
                            transitionMatrix[i, j] = k_rel
                        end
                    end
                end
            end
        end

        # Save results
        mkdir(joinpath(saveloc, savfname, construct_names[k]))
        jldsave(joinpath(saveloc, savfname, construct_names[k], "TM.jld2"); 
            transitionMatrix, 
            numValidStates, 
            output_mat, 
            output_cell, 
            states, 
            isBound, 
            isDelivered, 
            PRM_locs, 
            PRM_sizes, 
            c_PA, 
            G, 
            k_cap , 
            k_del , 
            r_cap , 
            r_del , 
            k_rel , 
            r_cap_exp,
            prname)
        writedlm(joinpath(saveloc, savfname, construct_names[k], "states.txt"), states, ',')
        writedlm(joinpath(saveloc, savfname, construct_names[k], "TM.txt"), transitionMatrix, ',')
    end

    return (joinpath(saveloc, savfname,))
end
