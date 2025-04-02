function runGillespieOnFolder(folder::String, timecount::Float64, timeavg::Float64)
    for construct in readdir(folder)
        ifolder = joinpath(folder, construct)
        if isdir(ifolder)
            states_file = joinpath(ifolder, "states.txt")
            numValidStates = countlines(states_file)
            iSiteTotal = length(split(readlines(states_file)[1], ","))
            matrix_file = joinpath(ifolder, "TM.txt")
            output_file = joinpath(ifolder, "TMout_$(timecount)_$(timeavg).txt")

            println("Running Gillespie simulation for construct: $construct")
            storedTotalTime_End, storedAddedActin_End, storedKpoly_End = runGillespie(matrix_file, states_file, numValidStates, iSiteTotal, timecount, output_file, timeavg, true)
        end
    end
end
