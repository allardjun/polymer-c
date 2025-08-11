function outputGillespie(output_file::String, timeStorage_End::Vector{Float64}, stateStorage_End::Vector{Int}, kpolyStorage_End::Vector{Int}, endStorage_length::Int, numValidStates::Int, iSiteTotal::Int, timeEnd::Float64, finalState::Int, finalTotalTime::Float64, saveTF::Bool)
    storedTotalTime_End = 0.0
    storedAddedActin_End = 0

    # Write output to the file
    if saveTF
        open(output_file, "a") do io
            println(io, "\n")

            for i in 1:endStorage_length
                storedTotalTime_End += timeStorage_End[i]
                storedAddedActin_End += kpolyStorage_End[i]
                println(io, "state time kpoly $(stateStorage_End[i]) $(timeStorage_End[i]) $(kpolyStorage_End[i])")
            end

            storedKpoly_End = storedAddedActin_End / storedTotalTime_End

            println(io, "numValidStates $numValidStates")
            println(io, "iSiteTotal $iSiteTotal")
            println(io, "timeEnd $timeEnd")
            println(io, "finalState $finalState")
            println(io, "finalTotalTime $finalTotalTime")
            println(io, "Over Avg time storedTotalTime $storedTotalTime_End")
            println(io, "Over Avg time storedAddedActin $storedAddedActin_End")
            println(io, "Over Avg time storedKpoly $storedKpoly_End")
        end
    else
        # for i in 1:endStorage_length
        #     storedTotalTime_End += timeStorage_End[i]
        #     storedAddedActin_End += kpolyStorage_End[i]
        # end

        storedTotalTime_End=timeStorage_End[1]
        storedAddedActin_End=kpolyStorage_End[1]
        storedKpoly_End = kpolyStorage_End[1] / timeStorage_End[1]
    end

    return storedTotalTime_End, storedAddedActin_End, storedKpoly_End
end
