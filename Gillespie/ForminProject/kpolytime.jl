function kpolytime(time, kpolyTF)
    numKpoly=length(filter(!iszero, kpolyTF))
    cumtimes=Array{Float64}(undef, numKpoly)
    iter=Array{Int64}(undef, numKpoly)
    timecounter=0
    kpolycounter=0
    for i in 1:length(kpolyTF)
        timecounter=timecounter+time[i]
        if kpolyTF[i]==1
            kpolycounter+=1
            cumtimes[kpolycounter]=timecounter
            iter[kpolycounter]=i
            timecounter=0
        end
    end
    if kpolycounter!=numKpoly
        error("issue determining number of kpoly events")
    end

    return cumtimes, iter
end