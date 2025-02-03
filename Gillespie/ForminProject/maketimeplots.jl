# using Pkg
# Pkg.update("JLLWrappers")
# Pkg.update("GLFW_jll")
# Pkg.update("FFTW_jll")

# Pkg.add("Plots")
# Pkg.add("StatsBase")
# Pkg.add("GLMakie")
# Pkg.add("StatsPlots")

using Plots
using StatsBase
using StatsPlots
using Statistics
using Printf
# using GLMakie


include("kpolytime.jl")
include("readinout.jl")

displayfigsTF=false
savefigsTF=true

dir="/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/testing/4999testing_2025.01.29.15.12.29"
Fnames=readdir(dir)
filter!(s -> !startswith(s, "."), Fnames)

for constructname in Fnames
    Fname ="$dir/$constructname/TMout_5000.0_4999.0.txt"

    state, time, kpolyTF = readinout(Fname)
    totalIter=length(state)

    cumtimes, iter = kpolytime(time, kpolyTF)

    n= length(cumtimes)

    notfound=true
    last100_kpoly_index=length(cumtimes)
    while notfound
        diff = totalIter - iter[last100_kpoly_index-1]
        if diff> 100
            notfound=false
        end
        last100_kpoly_index= last100_kpoly_index-1
    end

    # m = mean(cumtimes[n-100:n])
    # stephist(cumtimes[n-100:n],label=@sprintf("100 kpolys, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf, title = constructname, dpi=1000)
    # m = mean(cumtimes[last100_kpoly_index:n])
    # stephist!(cumtimes[last100_kpoly_index:n],label=@sprintf("100 iters, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    
    m = mean(cumtimes[1:floor(Int, n/2)])
    stephist(cumtimes[1:floor(Int, n/2)],label=@sprintf("1st half, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf,title = constructname, dpi=1000)
    m = mean(cumtimes[floor(Int, n/2):n])
    stephist!(cumtimes[floor(Int, n/2):n],label=@sprintf("2nd half, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)

    m = mean(cumtimes[1:floor(Int, n/4)])
    stephist!(cumtimes[1:floor(Int, n/4)],label=@sprintf("1st quarter, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    m = mean(cumtimes[floor(Int, n/4)+1:2*floor(Int, n/4)])
    stephist!(cumtimes[floor(Int, n/4)+1:2*floor(Int, n/4)],label=@sprintf("2nd quarter, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    m = mean(cumtimes[(floor(Int, n/4)*2)+1:3*floor(Int, n/4)])
    stephist!(cumtimes[(floor(Int, n/4)*2)+1:3*floor(Int, n/4)],label=@sprintf("3rd quarter, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    m = mean(cumtimes[(floor(Int, n/4)*3)+1:n])
    stephist!(cumtimes[(floor(Int, n/4)*3)+1:n],label=@sprintf("4th quarter, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)

    m = mean(cumtimes[1:floor(Int, n/3)])
    stephist!(cumtimes[1:floor(Int, n/3)],label=@sprintf("1st third, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    m = mean(cumtimes[floor(Int, n/3)+1:2*floor(Int, n/3)])
    stephist!(cumtimes[floor(Int, n/3)+1:2*floor(Int, n/3)],label=@sprintf("2nd third, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    m = mean(cumtimes[2*floor(Int, n/3)+1:end])
    if displayfigsTF
        display(stephist!(cumtimes[2*floor(Int, n/3)+1:end],label=@sprintf("3rd third, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf))
    else
        stephist!(cumtimes[2*floor(Int, n/3)+1:end],label=@sprintf("3rd third, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf)
    end
    display(stephist!(cumtimes[2*floor(Int, n/3)+1:end],label=@sprintf("3rd third, %.5f, %.5f", m, 1/m),fill=true, fillalpha=0.5, normalize=:pdf))
    if savefigsTF
        savefig("$dir/$constructname/$constructname.hist.png")
    end


    # m = mean(cumtimes[n-100:n])
    # ecdfplot(cumtimes[n-100:n], label=@sprintf("100 kpolys, %.5f, %.5f", m, 1/m),title = constructname,dpi=1000)
    # m = mean(cumtimes[last100_kpoly_index:n])
    # ecdfplot!(cumtimes[last100_kpoly_index:n],label=@sprintf("100 iters, %.5f, %.5f", m, 1/m))
    
    m = mean(cumtimes[1:floor(Int, n/2)])
    ecdfplot(cumtimes[1:floor(Int, n/2)],label=@sprintf("1st half, %.5f, %.5f", m, 1/m),title = constructname,dpi=1000)
    m = mean(cumtimes[floor(Int, n/2):n])
    ecdfplot!(cumtimes[floor(Int, n/2):n],label=@sprintf("2nd half, %.5f, %.5f", m, 1/m))

    m = mean(cumtimes[1:floor(Int, n/4)])
    ecdfplot!(cumtimes[1:floor(Int, n/4)],label=@sprintf("1st quarter, %.5f, %.5f", m, 1/m))
    m = mean(cumtimes[floor(Int, n/4)+1:2*floor(Int, n/4)])
    ecdfplot!(cumtimes[floor(Int, n/4)+1:2*floor(Int, n/4)],label=@sprintf("2nd quarter, %.5f, %.5f", m, 1/m))
    m = mean(cumtimes[(floor(Int, n/4)*2)+1:3*floor(Int, n/4)])
    ecdfplot!(cumtimes[(floor(Int, n/4)*2)+1:3*floor(Int, n/4)],label=@sprintf("3rd quarter, %.5f, %.5f", m, 1/m))
    m = mean(cumtimes[(floor(Int, n/4)*3)+1:n])
    ecdfplot!(cumtimes[(floor(Int, n/4)*3)+1:n],label=@sprintf("4th quarter, %.5f, %.5f", m, 1/m))


    m = mean(cumtimes[1:floor(Int, n/3)])
    ecdfplot!(cumtimes[1:floor(Int, n/3)],label=@sprintf("1st third, %.5f, %.5f", m, 1/m))
    m = mean(cumtimes[floor(Int, n/3)+1:2*floor(Int, n/3)])
    ecdfplot!(cumtimes[floor(Int, n/3)+1:2*floor(Int, n/3)],label=@sprintf("2nd third, %.5f, %.5f", m, 1/m))
    m = mean(cumtimes[2*floor(Int, n/3)+1:end])
    if displayfigsTF
        display(ecdfplot!(cumtimes[2*floor(Int, n/3)+1:end],label=@sprintf("3rd third, %.5f, %.5f", m, 1/m),legend=:bottomright))
    else
        ecdfplot!(cumtimes[2*floor(Int, n/3)+1:end],label=@sprintf("3rd third, %.5f, %.5f", m, 1/m),legend=:bottomright)
    end
    if savefigsTF
        savefig("$dir/$constructname/$constructname.ecdf.png")
    end

end