using DelimitedFiles, Random, Combinatorics

function generateCombo(min1, max1,
                                   min2, max2, 
                                   min3, max3, points, 
                                   output_file="combinations.txt")

    # Generate log-spaced values
    
    vals1=get_points(min1,max1,points)
    display(vals1)
    vals2=get_points(min2,max2,points)
    display(vals2)
    vals3=get_points(min3,max3,points)
    display(vals3)

    # Create all combinations
    comb_matrix=[]
    for i in vals1
        for j in vals2
            for k in vals3
                push!(comb_matrix,[i,j,k])
            end
        end
    end

    # Remove duplicate rows due to floating-point precision issues
    unique_combinations = unique(comb_matrix, dims=1)

    # Shuffle rows randomly
    Random.shuffle!(unique_combinations)

    # Save to CSV file
    writedlm(output_file, unique_combinations, ',')

    println("Generated $output_file with unique shuffled log-spaced combinations.")

end

function get_points(min, max, points)
    display(points)
    display(min)
    display(max)
    min10=log10(min)
    max10=log10(max)
    display(min10)
    display(max10)

    range=max10-min10
    display(range)
    step=range/points
    display(step)

    output=[]

    i=min10
    while i<=max10
        push!(output,i)
        i=i+step
    end

    display(output)

    return exp10.(output)
end
