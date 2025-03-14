using Interpolations

function makeratiointerpolations(dict::Dict{Symbol, Any}, input_key_1::Symbol, keys::Vector{Symbol})
    # Construct the new key for sum
    sum_key = Symbol(string(input_key_1, "_sum"))

    # Define the anonymous function that takes 3 inputs and sums the interpolants
    dict[sum_key] = (x, y, z) -> sum(get(dict, k, (x, y, z) -> 0.0)(x, y, z) for k in keys)

    # Construct the new key for ratio
    ratio_key = Symbol(string(input_key_1, "_ratio"))

    dict[ratio_key] = (x, y, z) -> begin
        denominator = sum(get(dict, k, (x, y, z) -> 0.0)(x, y, z) for k in keys)
        denominator == 0.0 ? 0.0 : dict[input_key_1](x, y, z) / denominator
    end

    return dict
end
