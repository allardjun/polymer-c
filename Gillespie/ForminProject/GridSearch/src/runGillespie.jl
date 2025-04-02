using BenchmarkTools

function runGillespie(
    matrix_input::Union{String, Matrix{Float64}}, state_input::Union{String, Matrix{Int}},
    numValidStates::Int, iSiteTotal::Int, timeEnd::Float64, output_file::String, timeAvgDuration::Float64, saveTF::Bool
)
    seed = rand(UInt) #rand(UInt)
    println("Random seed: $seed")
    flush(stdout)
    Random.seed!(seed)

    # Initialize rate and state matrices
    rateMatrix = zeros(Float64, numValidStates, numValidStates)
    stateMatrix = zeros(Int, numValidStates, iSiteTotal)

    # Load rate matrix from file or use the given matrix
    if typeof(matrix_input) == String
        open(matrix_input, "r") do io
            for i in 1:numValidStates
                line = readline(io)
                rateMatrix[i, :] .= parse.(Float64, split(line, ","))
            end
        end
    else
        rateMatrix .= matrix_input
    end

    # Load state matrix from file or use the given matrix
    if typeof(state_input) == String
        open(state_input, "r") do io
            for i in 1:numValidStates
                line = readline(io)
                stateMatrix[i, :] .= parse.(Int, split(line, ","))
            end
        end
    else
        stateMatrix .= state_input
    end

    timeTotal = 0.0
    currentState = 1
    pastState = currentState
    iter = 1
    endStorage_length = Ref(0)
    timeStorage_End = Float64[]
    stateStorage_End = Int[]
    kpolyStorage_End = Int[]

    if saveTF
    else
        push!(timeStorage_End, 0.0)
        push!(kpolyStorage_End, 0)
    end

    println("Gillespie set up, entering while loop")
    flush(stdout)
    while timeTotal < timeEnd && iter < 1_000_000_000
        timeStep = Inf
        newState = currentState

        # Gillespie step: calculate time to transition
        for iy in 1:numValidStates
            if rateMatrix[currentState, iy] != 0
                randTime = -log(rand()) / rateMatrix[currentState, iy]
                if randTime < timeStep
                    timeStep = randTime
                    newState = iy
                end
            end
        end

        timeTotal += timeStep
        currentState = newState

        # Record data if necessary
        dataRecording!(
            timeTotal, timeEnd, timeAvgDuration, timeStep, currentState, pastState,
            stateMatrix, iSiteTotal, timeStorage_End, stateStorage_End, kpolyStorage_End, endStorage_length, saveTF
        )

        iter += 1
        pastState = currentState
    end
    println("finished Gillespie while loop")
    flush(stdout)


    finalState = currentState
    finalTotalTime = timeTotal

    # Call outputGillespie to log the results
    storedTotalTime_End, storedAddedActin_End, storedKpoly_End = @btime outputGillespie(
        $(output_file), $(timeStorage_End), $(stateStorage_End), $(kpolyStorage_End),
        $(length(timeStorage_End)), $(numValidStates), $(iSiteTotal), $(timeEnd), $(finalState), $(finalTotalTime), $(saveTF)
    )

    return storedTotalTime_End, storedAddedActin_End, storedKpoly_End
end