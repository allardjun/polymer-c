function generateTMtemplate(PRM_locs::Vector{Int})
    """
    Generate a template for the transition matrix for formin based on an array of PRM locations.

    Args:
        PRM_locs::Vector{Int}: Array of PRM locations.

    Returns:
        Tuple containing:
            states::Matrix{Int}: Matrix where each row represents a state and each column corresponds to a PRM. Values are:
                                 0 - unbound
                                 1 - bound
                                 2 - delivered
            numValidStates::Int: Number of valid states.
            transitionMatrix::Matrix{Float64}: Empty transition matrix.
            isBound::Matrix{Bool}: Boolean matrix indicating bound PRMs for each state.
            isDelivered::Matrix{Bool}: Boolean matrix indicating delivered PRMs for each state.
    """
    # Number of binding sites
    N = 2 * length(PRM_locs)  # Assumes two identical FH1s

    # Number of possible states for a single site
    siteStates = 3  # unbound, bound, delivered

    # Initialize storage for valid states
    validStates = []
    isBoundList = []
    isDeliveredList = []

    # Enumerate all possible states
    totalStates = siteStates^N
    for i in 0:(totalStates - 1)
        # Convert index to base-3 and pad to length N
        state = reverse(digits(i, base=siteStates, pad=N))

        # Check validity: Only one site can be "delivered"
        if count(x -> x == 2, state) <= 1
            push!(validStates, state)
            push!(isBoundList, map(x -> x == 1, state))
            push!(isDeliveredList, map(x -> x == 2, state))
        end
    end

    # Convert lists to matrices
    states = hcat(validStates...)
    isBound = hcat(isBoundList...)
    isDelivered = hcat(isDeliveredList...)

    # Initialize the transition matrix for valid states
    numValidStates = size(states, 2)  # Number of rows in the states matrix
    transitionMatrix = zeros(Float64, numValidStates, numValidStates)

    states= Matrix(states')

    return states, numValidStates, transitionMatrix, isBound', isDelivered'
end
