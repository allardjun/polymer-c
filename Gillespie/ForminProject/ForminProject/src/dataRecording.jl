function dataRecording!(
    timeTotal::Float64, timeEnd::Float64, timeAvgDuration::Float64,
    timeStep::Float64, currentState::Int, pastState::Int,
    stateMatrix::Matrix{Int}, iSiteTotal::Int,
    timeStorage_End::Vector{Float64}, stateStorage_End::Vector{Int},
    kpolyStorage_End::Vector{Int}, endStorage_length::Ref{Int}
)
    if timeTotal >= (timeEnd - timeAvgDuration)
        push!(timeStorage_End, timeStep)
        push!(stateStorage_End, currentState)

        kpolynew = 0
        diffSite = 0
        difftot = 0

        # Identify state differences
        for j in 1:iSiteTotal
            if stateMatrix[pastState, j] != stateMatrix[currentState, j]
                difftot += 1
                diffSite = j
            end
        end

        # Check if the difference indicates polymerization
        if stateMatrix[pastState, diffSite] == 2 && stateMatrix[currentState, diffSite] == 0
            kpolynew = 1
        end

        push!(kpolyStorage_End, kpolynew)
        endStorage_length[] += 1
    end
end