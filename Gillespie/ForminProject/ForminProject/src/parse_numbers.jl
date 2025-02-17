function parse_numbers(input::String)
    # Split the input string at the double underscore
    parts = split(input, "__")

    if length(parts) != 2
        throw(ArgumentError("Input must contain exactly one double underscore (__)."))
    end

    # Split each part by single underscores and parse the numbers
    before_numbers = parse.(Int, split(parts[1], "_"))
    after_numbers = parse.(Int, split(parts[2], "_"))

    # Return as a 2D vector
    return [before_numbers, after_numbers]
end
