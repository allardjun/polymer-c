using Revise, ForminProject, JLD2, DataFrames

df=load("/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.18.02.15.15/combinedgridsearch.jld2","outdf")

df=load("/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.31.03.10.01/combinedgridsearch.jld2","outdf")


saveloc="/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.18.02.15.15"
saveloc="/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data/HPC3outputs/GridSearch.2025.31.03.10.01"


#ForminProject.make2Dgridplots(df,"ForminProject/src/sums.txt","r_cap", saveloc)

interps_grid, kcap_range_grid, kdel_range_grid, rcap_range_grid=ForminProject.makeAllInterpolants(df,"grid")

#interps_scatter, kcap_range_scatter, kdel_range_scatter, rcap_range_scatter=ForminProject.makeAllInterpolants(df,"scattered")

r_cap_slices=[rcap_range_grid[1],100,1000,10000,100000,1000000,rcap_range_grid[2]]
r_cap_slices=[100,1000,100000,1000000]


#ForminProject.plot_all_interpolations(interps_grid,kcap_range_grid, kdel_range_grid, rcap_range_grid, r_cap_slices,saveloc)

out_dict=ForminProject.getallratiodicts(interps_grid,"ForminProject/src/sums.txt")
ForminProject.plot_all_interpolations(out_dict,kcap_range_grid, kdel_range_grid, rcap_range_grid, r_cap_slices,saveloc,[:PC,:PB,:PA15PD,:PA15PD_16,:PAPD,:PCPD,:FH115,:FH115_16,:PA,:FH1,:PA15,:PA13_14,:PA13,:PA15_16,:PBPD,:PD,:PA15PD_sum,:PA15PD_16_sum,:PAPD_sum,:PCPD_sum,:FH115_sum,:FH115_16_sum,:FH1_sum,:PA15_sum,:PA13_14_sum,:PA13_sum,:PA15_16_sum,:PBPD_sum])


