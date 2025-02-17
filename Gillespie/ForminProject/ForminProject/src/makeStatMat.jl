function makeStatMat(state_dict, value)

    PRM_locs = unique(vcat([vcat(vecs...) for vecs in keys(state_dict)]...))
    PRM_locs = filter(x -> x >= 0, PRM_locs)
    out_dict=Dict{Vector{Vector{Int}},Matrix{Float64}}()
    
    nPRMs = length(PRM_locs)

    for key in keys(state_dict)
        out_mat = zeros(Float64, 2*nPRMs,1)
        val = state_dict[key][value] 
        for j in 1:nPRMs
            PRM_loc = PRM_locs[j]
            out_mat[j] = val[1, PRM_loc]
            out_mat[j + nPRMs] = val[2, PRM_loc]
        end
        out_dict[key]=out_mat
    end
    
    return out_dict, PRM_locs
end