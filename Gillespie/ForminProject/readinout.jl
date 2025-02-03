function readinout(file)
    linenum= countlines(file)
    linenum=linenum-12
    f = open(file, "r")
    state = Array{Int64}(undef, linenum)
    time = Array{Float64}(undef, linenum)
    kpolyTF = Array{Int8}(undef, linenum)

    line_counter=0;
    for lines in readlines(f)
        line_split=split(lines," ")
        if line_split[1]=="state" && line_split[2]=="time"
            line_counter+=1
            if line_counter<=linenum
                state[line_counter]=parse(Float64,line_split[4])
                time[line_counter]=parse(Float64,line_split[5])
                kpolyTF[line_counter]= parse(Float64,line_split[6])
            else
                push!(state,parse(Float64,line_split[4]))
                push!(time,parse(Float64,line_split[5]))
                push!(kpolyTF,parse(Float64,line_split[6]))
            end
        end
    end
    close(f)
    return state, time, kpolyTF 
end

