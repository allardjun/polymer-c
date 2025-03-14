using Revise, ForminProject, JLD2, DataFrames

df=load("/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.18.02.15.15/combinedgridsearch.jld2","outdf")

saveloc="/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.18.02.15.15"

interps_grid, kcap_range_grid, kdel_range_grid, rcap_range_grid=ForminProject.makeAllInterpolants(df,"grid")

interps_scatter, kcap_range_scatter, kdel_range_scatter, rcap_range_scatter=ForminProject.makeAllInterpolants(df,"scattered")

r_cap_slices=[rcap_range_grid[1],100,1000,10000,100000,1000000,rcap_range_grid[2]]

#ForminProject.plot_all_interpolations(interps_grid,kcap_range_grid, kdel_range_grid, rcap_range_grid, r_cap_slices,saveloc)

out_dict=ForminProject.getallratiodicts(interps_grid,"ForminProject/src/sums.txt")
ForminProject.plot_all_interpolations(out_dict,kcap_range_grid, kdel_range_grid, rcap_range_grid, r_cap_slices,saveloc,[:PC,:PB,:PA15PD,:PA15PD_16,:PAPD,:PCPD,:FH115,:FH115_16,:PA,:FH1,:PA15,:PA13_14,:PA13,:PA15_16,:PBPD,:PD])


