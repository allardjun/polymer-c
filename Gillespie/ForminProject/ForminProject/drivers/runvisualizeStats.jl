using Revise, ForminProject, Plots

fname1="/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20"
fname2 = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb_16.666actin_real/double.2025.19.02/BSD35.5.radtype20"
fname3 = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb_40actin/double.2025.24.02/BSD35.5.radtype20"



outDict1=ForminProject.makeOutputDict(fname1)
outDict2=ForminProject.makeOutputDict(fname2)
outDict3=ForminProject.makeOutputDict(fname3)




#ForminProject.visualizeStatsold(outDict, "Prvec0")
#ForminProject.visualizeStatsold(outDict, "POcclude")

data_matrix1, x1, y1, z1=ForminProject.visualizeStats(outDict1, "Prvec0")
data_matrix2, x2, y2, z2=ForminProject.visualizeStats(outDict2, "Prvec0")
data_matrix3, x3, y3, z3=ForminProject.visualizeStats(outDict3, "Prvec0")



#data_matrix4, x4, y4, z4=ForminProject.visualizeStats(outDict, "POcclude")
p=Plots.plot(data_matrix3[:,6],data_matrix3[:,1],seriestype=:scatter)
Plots.title!("Prvec vs num bound; largest actin (40)")
display(p)
p=Plots.plot(data_matrix3[:,7],data_matrix3[:,1],seriestype=:scatter)
Plots.title!("Prvec vs min dist; largest actin (40)")
display(p)

p=Plots.plot(data_matrix2[:,6],data_matrix2[:,1],seriestype=:scatter)
Plots.title!("Prvec vs num bound; large actin")
display(p)
p=Plots.plot(data_matrix2[:,7],data_matrix2[:,1],seriestype=:scatter)
Plots.title!("Prvec vs min dist; large actin")
display(p)


p=Plots.plot(data_matrix1[:,6],data_matrix1[:,1],seriestype=:scatter)
Plots.title!("Prvec vs num bound")
display(p)

p=Plots.plot(data_matrix1[:,7],data_matrix1[:,1],seriestype=:scatter)
Plots.title!("Prvec vs min dist")
display(p)



data_matrix1, x1, y1, z1=ForminProject.visualizeStats(outDict1, "POcclude")
data_matrix2, x2, y2, z2=ForminProject.visualizeStats(outDict2, "POcclude")
data_matrix3, x3, y3, z3=ForminProject.visualizeStats(outDict3, "POcclude")

p=Plots.plot(data_matrix3[:,6],data_matrix3[:,1],seriestype=:scatter)
Plots.title!("Pocc vs num bound; largest actin (40)")
display(p)

p=Plots.plot(data_matrix3[:,7],data_matrix3[:,1],seriestype=:scatter)
Plots.title!("Pocc vs min dist; largest actin (40)")
display(p)

p=Plots.plot(data_matrix2[:,6],data_matrix2[:,1],seriestype=:scatter)
Plots.title!("Pocc vs num bound; large actin")
display(p)

p=Plots.plot(data_matrix2[:,7],data_matrix2[:,1],seriestype=:scatter)
Plots.title!("Pocc vs min dist; large actin")
display(p)


p=Plots.plot(data_matrix1[:,6],data_matrix1[:,1],seriestype=:scatter)
Plots.title!("Pocc vs num bound")
display(p)

p=Plots.plot(data_matrix1[:,7],data_matrix1[:,1],seriestype=:scatter)
Plots.title!("Pocc vs min dist")
display(p)

