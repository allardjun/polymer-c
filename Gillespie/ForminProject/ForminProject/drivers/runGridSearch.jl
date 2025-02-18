using ForminProject

paramsfname=string(ARGS[1])
index1=parse(Int, ARGS[2])
index2=parse(Int, ARGS[3])
polymercfname=string(ARGS[4])
savloc=string(ARGS[5])

ForminProject.gridSearch(paramsfname, index1, index2 ,polymercfname, savloc)