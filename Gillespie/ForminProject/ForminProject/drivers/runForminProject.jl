using Revise, ForminProject

saveloc = "/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data"
#saveloc="/dfs6/pub/kbogue1/GitHub/Data/Gillespie_data/HPC3outputs"

# construct_names = ["PA",  "FH1", ]

# construct_PRM_locs = [[104], [25, 42, 63, 104], ]

# construct_PRM_sizes = [[12], [5, 7, 14, 12], ]

                       
construct_names = ["PA", "PB", "PC", "PD", "FH1", "PAPD", "PBPD", "PCPD", 
                       "PA15", "PA15_16", "FH115", "FH115_16", "PA13", "PA13_14", 
                       "PA15PD", "PA15PD_16"]
    
construct_PRM_locs = [[104], [63], [42], [25], [25, 42, 63, 104], [25, 104], [25, 63], [25, 42],
                          [104], [104], [25, 42, 63, 104], [25, 42, 63, 104], [104], [104], [25, 104], [25, 104]]
    
construct_PRM_sizes = [[12], [14], [7], [5], [5, 7, 14, 12], [5, 12], [5, 14], [5, 7],
                           [15], [16], [5, 7, 14, 15], [5, 7, 14, 16], [13], [14], [5, 15], [5, 16]]
    
# Constants
c_PA = 0.88
G = 0.5
k_cap = 73.02274
k_del = 0.0022909
r_cap = 37896.5784
r_del = 0.0  # Considering release instant
k_rel = 1e8  # Large value for instant release
r_cap_exp = 0.86103

# Choose which probability density to use
prname = "Prvec0"

# Polymer-c output folder
fname = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20"
fname = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb_16.666actin_real/double.2025.19.02/BSD35.5.radtype20"
fname = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb_40actin/double.2025.24.02/BSD35.5.radtype20"


#fname = "/dfs6/pub/kbogue1/GitHub//Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20"


# folder name to save everything to in the saveloc
savfname = "actinsize40"

# generate transition matrices and files
# using Profile
# Profile.clear()
# @profile outfname=ForminProject.makeTM(saveloc, construct_names, construct_PRM_locs, construct_PRM_sizes, c_PA, G, k_cap, k_del, r_cap, r_del, k_rel, r_cap_exp, prname, fname, savfname)
# Profile.print()

#outfname =ForminProject.makeTM(saveloc, construct_names, construct_PRM_locs, construct_PRM_sizes, c_PA, G, k_cap, k_del, r_cap, r_del, k_rel, r_cap_exp, prname, fname, savfname, true, false)

outfname, kpolys =ForminProject.makeTM(saveloc, construct_names, construct_PRM_locs, construct_PRM_sizes, c_PA, G, k_cap, k_del, r_cap, r_del, k_rel, r_cap_exp, prname, fname, savfname, true, true)

# # run gillespie on the folder
#ForminProject.runGillespieOnFolder(outfname, 10000.0, 5000.0)

# # process the kpolys
exp = ForminProject.process_kpoly_dict("ForminProject/src/refsums.txt")
sim= ForminProject.process_kpoly(outfname,"ForminProject/src/sums.txt")
ForminProject.plot_kpoly_ratios(exp,sim,true,outfname)

