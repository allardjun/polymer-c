function getStateVals(state_mat, PRM_locs, value)
    """
    Get values for PRM locations of a matrix of output structures for states.

    Parameters:
    - state_mat: Array of output structures (from `readInMSBFiles`).
    - PRM_locs: Array of PRM locations. If `1`, gets the value at the base (0) for each state.
    - value: String specifying the polymer-c code output value to get.

    Returns:
    - out_mat: Matrix containing values for each PRM in each state.
               Each row corresponds to a state, and each column corresponds to a PRM.

    See also: `getOutputControl`, `generateTMtemplate`, `readInMSBFiles`.
    """
    nStates = length(state_mat)
    nPRMs = length(PRM_locs)

    out_mat = zeros(Float64, nStates, 2 * nPRMs)

    for i in 1:nStates
        val = state_mat[i][value]  # Access the dynamic field
        for j in 1:nPRMs
            PRM_loc = PRM_locs[j]
            out_mat[i, j] = val[1, PRM_loc]
            out_mat[i, j + nPRMs] = val[2, PRM_loc]
        end
    end

    return out_mat
end
