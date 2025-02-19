paramsfname=string(ARGS[1])
index1=parse(Int, ARGS[2])
index2=parse(Int, ARGS[3])
polymercfname=string(ARGS[4])
savloc=string(ARGS[5])

# Locate temporary directory
tmpdir = joinpath(savloc,"juliafiles")

# Set the temp directory as the first depot so any (re)compilation will happen there
ENV["JULIA_DEPOT_PATH"] = tmpdir
ENV["JULIA_PKG_PRECOMPILE_AUTO"] = 0

println("JULIA_DEPOT_PATH set to: ", ENV["JULIA_DEPOT_PATH"])

using Pkg
Pkg.gc()
Pkg.instantiate(verbose = true)


using ForminProject

ForminProject.gridSearch(paramsfname, index1, index2 ,polymercfname, savloc)