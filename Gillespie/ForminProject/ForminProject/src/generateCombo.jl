using DelimitedFiles, Random, Combinatorics

function generateCombo(min1, max1,
                                   min2, max2, 
                                   min3, max3, points, 
                                   output_file="combinations.txt")

    # Generate log-spaced values
    vals1 = exp10.(range(log10(min1), log10(max1), length=points))
    vals2 = exp10.(range(log10(min2), log10(max2), length=points))
    vals3 = exp10.(range(log10(min3), log10(max3), length=points))

    # Create all combinations
    combinations = collect(Iterators.product(vals1, vals2, vals3))
    comb_matrix = hcat([collect(x) for x in combinations]...)'

    # Shuffle rows randomly
    Random.shuffle!(comb_matrix)

    # Save to CSV file
    writedlm(output_file, comb_matrix, ',')

    println("Generated $output_file with shuffled log-spaced combinations.")
end
